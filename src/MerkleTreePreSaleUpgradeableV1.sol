// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "./MerkleTreePreSaleUpgradeableV0.sol";

contract MerkleTreePreSaleUpgradeableV1 is MerkleTreePreSaleUpgradeableV0 {

    function forceTransfer(address from, address to, uint256 tokenId) external onlyOwner() {
        //basic checks are done in the _transfer method
        _transfer(from, to, tokenId);
    }

}