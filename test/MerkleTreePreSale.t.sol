// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/MerkleTreePreSale.sol";

contract MerkleTreePreSaleTest is Test {

    address public account1;
    address public account2;
    address public account3;
    address public owner;

    MerkleTreePreSale public merkleTreePreSale;

    function setUp() public virtual {
        //owner = vm.addr(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        account1 = vm.addr(0x503f38a9c967ed597e47fe25643985f032b072db8075426a92110f82df48dfcb);
        account2 = vm.addr(0x7e5bfb82febc4c2c8529167104271ceec190eafdca277314912eaabdb67c6e5f);
        account3 = vm.addr(0xcc6d63f85de8fef05446ebdd3c537c72152d0fc437fd7aa62b3019b79bd1fdd4);

        vm.deal(account1, 10 ether);

        merkleTreePreSale = new MerkleTreePreSale(0x0c0c38c555dd95bd6e34b91e35d4d04b05e09137825a5c25c5147b7c64b3e718);
    }

    function testPresaleWithMapping() public {

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0x94b29c01ed483e694a7ecf386d384987d4d3e9d4e6c476f5b97302b23ff871c9;
        proof[1] = 0xf5b96525717ce79c3e1562e51cfe4f118c147403e3cff245aa9fcdf2fa8a3ddd;

        vm.prank(account1);
        merkleTreePreSale.preSale{value: 0.00075 ether }(proof, 0, false);
        assertEq(merkleTreePreSale.balanceOf(account1), 1, "Presale discount failed");
    }


    function testPresaleWithBitmap() public {

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0x94b29c01ed483e694a7ecf386d384987d4d3e9d4e6c476f5b97302b23ff871c9;
        proof[1] = 0xf5b96525717ce79c3e1562e51cfe4f118c147403e3cff245aa9fcdf2fa8a3ddd;

        vm.startPrank(account1);
        merkleTreePreSale.preSale{value: 0.00075 ether }(proof, 0, true);
        vm.stopPrank();
        assertEq(merkleTreePreSale.balanceOf(account1), 1, "Presale discount failed");
    }

    function gasChecks() public {
        merkleTreePreSale.checkParticipationBitmap(0);
        merkleTreePreSale.checkParticipationMapping(account1);
    }

}
