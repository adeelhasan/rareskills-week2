// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "openzeppelin-contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";


contract EnumerableNFT is ERC721Enumerable, Ownable {

    constructor() ERC721("EnumerableNFT", "ENUM") {
        for (uint256 i = 1; i < 21; i++) {
            _mint(msg.sender, i);    /// is it safe to use address(this) in the constructor?
        }
    }

}

contract PrimeNFTCounter {

    IERC721Enumerable public immutable nftToken;

    constructor(address nft) {
        // we can check if the expected interface is implemented
        nftToken = IERC721Enumerable(nft);        
    }

    function countPrimes(address ownerOfNft) external view returns (uint256) {
        uint256 primeCount;
        for (uint256 i; i < nftToken.balanceOf(ownerOfNft); i++) {
            uint256 tokenId = nftToken.tokenOfOwnerByIndex(ownerOfNft, i);        
            if (_isPrime(tokenId)) {
                primeCount++;
            }
        }
        return primeCount;
    }

    function _isPrime(uint256 n) internal pure returns (bool) {
        if (n < 2) {
            return false;
        }
        for (uint256 i = 2; i < n; i++) {
            if (n % i == 0) {
                return false;
            }
        }
        return true;
    }

}

