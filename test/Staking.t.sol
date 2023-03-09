// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/Staking.sol";

contract StakingTest is Test {

    address public account1;
    address public account2;
    address public account3;
    address public owner;

    StakerRewardToken public rewardsToken;
    StakerNFT public nftToken;
    Staker public staker;

    function setUp() public virtual {
        owner = vm.addr(0xAAAA);
        account1 = vm.addr(0xDABC);
        account2 = vm.addr(0xCDAB);
        account3 = vm.addr(0xBCDA);

        nftToken = new StakerNFT();
        staker = new Staker(address(nftToken));

        vm.prank(account1);
        nftToken.freeMint();

        vm.prank(account2);
        nftToken.freeMint();

        vm.prank(account3);
        nftToken.freeMint();

        // stake one token
        vm.prank(account1);
        nftToken.safeTransferFrom(account1, address(staker), 0);
        assertEq(nftToken.ownerOf(0), address(staker), "Staker should own the NFT");
    }

    function testStake() public {
        assertEq(staker.getStaker(0), account1, "Staking info not set");
        assertEq(staker.getLastClaimedOn(0), block.timestamp, "Staking was not set at the current time");

        vm.warp(block.timestamp + 1 days);
        vm.startPrank(account1);
        staker.claimRewards(0);
        
        require(staker.rewardsToken().balanceOf(account1) == staker.REWARD_RATE_NUMERATOR(), "Reward not claimed");

        vm.stopPrank();
    }

    function testUnstake() public {
        vm.warp(block.timestamp + 1 days);
        vm.prank(account1);
        staker.unstake(0);

        assertEq(nftToken.ownerOf(0), account1, "Staker should own the NFT");
        require(staker.rewardsToken().balanceOf(account1) == staker.REWARD_RATE_NUMERATOR(), "Reward not claimed");
   }

   function testRewardsAtHalfage() public {
        vm.warp(block.timestamp + 12 hours);
        vm.prank(account1);
        staker.claimRewards(0);

        require(staker.rewardsToken().balanceOf(account1) == staker.REWARD_RATE_NUMERATOR() / 2, "Reward not as expected");
   }

   function testCanClaimRewardMultipleTimes() external {
        vm.warp(block.timestamp + 12 hours);
        vm.prank(account1);
        staker.claimRewards(0);

        vm.warp(block.timestamp + 12 hours);
        vm.prank(account1);
        staker.claimRewards(0);

        require(staker.rewardsToken().balanceOf(account1) == staker.REWARD_RATE_NUMERATOR(), "Reward not as expected");
   }

}