// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

contract NFTMerkleTreePreSale is ERC721, Ownable, IERC2981 {
    bytes32 private _root;
    uint256 private constant PRESALE_DISCOUNT = 2500; // 25% discount
    uint256 private constant MINTING_PRICE = 0.001 ether;
    uint256 private constant ROYALTY_FEE = 250; // 2.5%% royalty fee
    uint256 private constant MAX_SUPPLY = 10;
    uint256 private _preSaleParticipationBitmap;
    uint256 public totalSupply;

    mapping (address => uint256) private _hasParticipatedInPreSaleMapping;

    constructor(bytes32 root_) ERC721("MerklePresaleNFT", "MPSNFT") {
        _root = root_;
    }

    /// @notice Pre-sale minting function
    /// @param proof Merkle proof communicated offline
    /// @param bitmapIndex Index of the bitmap, provided to the user
    /// @param useBitmap Whether to use the bitmap or the mapping, for gas usage comparison
    function preSale(bytes32[] memory proof, uint256 bitmapIndex, bool useBitmap) external payable
    {
        require(msg.value == MINTING_PRICE * (10000 - PRESALE_DISCOUNT) / 10000, "Incorrect amount of ETH sent");
        require(totalSupply < MAX_SUPPLY, "No more tokens");

        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender, bitmapIndex))));
        require(MerkleProof.verify(proof, _root, leaf), "Invalid proof");

        if (useBitmap)
            require(_preSaleParticipationBitmap & (1 << bitmapIndex) == 0, "Already participated in pre-sale");
        else
            require(_hasParticipatedInPreSaleMapping[msg.sender] == 0, "Already participated in pre-sale");
        
        uint256 nextId = totalSupply;
        totalSupply++; // update state before minting to screen out reentrancy
        _mint(msg.sender, nextId);

        if (useBitmap)
            _preSaleParticipationBitmap |= (1 << bitmapIndex);
        else
            _hasParticipatedInPreSaleMapping[msg.sender] = 1;
    }

    /// @notice handy for previewing the price for pre-sale
    function calculatePreSalePrice() external pure returns (uint256) {
        return MINTING_PRICE * (10000 - PRESALE_DISCOUNT) / 10000;
    }

    /// @notice Minting function, should this automatically call the preSale function automatically
    /// for anyone who was on the whitelist, but has not taken the pre-sale?
    function mint() external payable {
        require(msg.value == MINTING_PRICE, "Incorrect amount of ETH sent");
        require(totalSupply < MAX_SUPPLY, "No more tokens");
        uint256 nextId = totalSupply;
        totalSupply++; // update state before minting to screen out reentrancy
        _mint(msg.sender, nextId);
    }

    /// @notice ERC2981 implementation
    function royaltyInfo(
        uint256 tokenId,
        uint256 salePrice
    ) 
        external
        view
         returns (
                address receiver,
                uint256 royaltyAmount
            )
    {
        require(_exists(tokenId), "ERC2981: Royalty info for nonexistent token");
        return (owner(), (salePrice * ROYALTY_FEE) / 10000);
    }

    /// @notice ERC721 implementation, returns metadata URI
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmcdposSzDZgZdNEy5SBS2dRrCKBnM8bvYx1rzSChNpMge/";
    }


    /// @notice reduce if buring the token
    /// @dev the other option is to block any burning for this implementation
    /// and to check if this edge case is needed at all?
    function _afterTokenTransfer(
        address /*from*/,
        address to,
        uint256 /*firstTokenId*/,
        uint256 /*batchSize*/
    ) internal override {        
        if (to == address(0)) {
            totalSupply--;
        }
    }

}