// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "./MerkleTreePreSaleUpgradeableV1.sol";

contract MerkleTreePreSaleUpgradeableV2 is MerkleTreePreSaleUpgradeableV1 {

    function getVersionNumber() external pure returns(uint256) {
        //basic checks are done in the _transfer method
        return 2;
    }

}