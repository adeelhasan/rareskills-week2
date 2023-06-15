// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "openzeppelin-contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract StakerRewardToken is ERC20, Ownable {
 
    constructor() ERC20("StakerRewardToken", "RWD") {}

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

}


contract StakerNFT is ERC721 {

    uint256 public tokenCounter;
    uint256 public constant MAX_SUPPLY = 100;
 
    constructor() ERC721("StakerNFT", "STKNFT") {}

    function freeMint() external {
        require(tokenCounter < MAX_SUPPLY, "No more tokens");
        _mint(msg.sender, tokenCounter);
        tokenCounter++;
    }

}


/// something to do with safeTransfer for the NFT is left, as well as the testing
contract Staker {

    struct StakingInfo {
        address staker;
        uint256 lastClaimedOn;
    }

    event Staked(address indexed staker, uint256 indexed tokenId);
    event Unstaked(address indexed staker, uint256 indexed tokenId);
    event Rewarded(address indexed staker, uint256 reward,  uint256 indexed tokenId);

    StakerRewardToken public immutable rewardsToken;
    StakerNFT public immutable nftToken;

    mapping(uint256 => StakingInfo) public staked;

    uint256 public constant REWARD_RATE_NUMERATOR = 10 * 10**18;
    uint256 public constant REWARD_RATE_DENOMINATOR = 24 hours;

    constructor(address _nft) {
        rewardsToken = new StakerRewardToken();
        nftToken = StakerNFT(_nft);
    }

    function onERC721Received(
        address,
        address from,
        uint256 tokenId,
        bytes calldata
    ) external returns (bytes4) {
        require(msg.sender == address(nftToken), "not our NFT");
        require(msg.sender != address(this), "cannot stake for yourself");
        require(staked[tokenId].staker == address(0), "already staked");

        staked[tokenId] = StakingInfo(from, block.timestamp);
        emit Staked(from, tokenId);

        return this.onERC721Received.selector;
    }

    /// @notice payout any accrued rewards to the staker, and return ownership of the NFT to the staker
    function unstake(uint256 tokenId) external {
        StakingInfo memory stakingInfo = staked[tokenId];
        require(nftToken.ownerOf(tokenId) == address(this), "not owned by this contract");
        require(stakingInfo.staker != address(0), "not staked");
        require(stakingInfo.staker == msg.sender, "not staked by this user");

        nftToken.safeTransferFrom(address(this), msg.sender, tokenId);
        _processRewards(stakingInfo.staker, tokenId, stakingInfo.lastClaimedOn);

        delete staked[tokenId];
        emit Unstaked(msg.sender, tokenId);
    }

    function claimRewards(uint256 tokenId) external {
        StakingInfo memory staking = staked[tokenId];
        require(staking.staker != address(0), "not staked");
        require(staking.staker == msg.sender, "not staked by this user");

        _processRewards(staking.staker, tokenId, staking.lastClaimedOn);
    }

    /// @notice helpher function to get the staker of a token
    function getStaker(uint256 tokenId) external view returns (address) {
        //require(_exists(tokenId), "token not minted");
        require(nftToken.ownerOf(tokenId) == address(this), "not owned by this contract");
        require(staked[tokenId].staker != address(0), "Not staked");
        return staked[tokenId].staker;
    }

    /// @notice helper function to get the last claimed on timestamp of a token
    function getLastClaimedOn(uint256 tokenId) external view returns (uint256) {
        return staked[tokenId].lastClaimedOn;
    }

    /// @dev all prechecks should be done before calling this function
    function _processRewards(address user, uint256 tokenId, uint256 lastWithdrawnOn) internal {
        uint256 reward = ((block.timestamp - lastWithdrawnOn) * REWARD_RATE_NUMERATOR / REWARD_RATE_DENOMINATOR);
        staked[tokenId].lastClaimedOn = block.timestamp;
        rewardsToken.mint(user, reward);

        emit Rewarded(user, reward, tokenId);
    }

}