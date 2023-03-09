// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/EnumerableNFT.sol";

contract EnumerableTest is Test {

    address public account1;
    address public account2;
    address public account3;
    address public owner;

    EnumerableNFT public enumerableNFT;
    PrimeNFTCounter public primeNFTCounter;

    function setUp() public virtual {
        owner = vm.addr(0xAAAA);
        account1 = vm.addr(0xDABC);
        account2 = vm.addr(0xCDAB);
        account3 = vm.addr(0xBCDA);

        vm.prank(owner);
        enumerableNFT = new EnumerableNFT();
        primeNFTCounter = new PrimeNFTCounter(address(enumerableNFT));

        // distribute NFTs between the accounts
        vm.startPrank(owner);
        for (uint256 i = 1; i < 21; i++) {
            if (i < 6) {
                enumerableNFT.safeTransferFrom(owner, account1, i);
            }
            if ((i > 5) && (i < 13)) {
                enumerableNFT.safeTransferFrom(owner, account2, i);
            }
            if (i > 12) {
                enumerableNFT.safeTransferFrom(owner, account3, i);

            }
        }
        vm.stopPrank();
    }

    function testCountPrimes() external {
        assertEq(primeNFTCounter.countPrimes(account1), 3, "Wrong number of primes");
        assertEq(primeNFTCounter.countPrimes(account2), 2, "Wrong number of primes");
        assertEq(primeNFTCounter.countPrimes(account3), 3, "Wrong number of primes");
    }



}