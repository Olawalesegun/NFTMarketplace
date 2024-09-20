// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTMarketplace is ERC721URIStorage {
  address payable public owner;
  uint256 public allItemsSoldCount;
  uint256 public tokenId;
  uint256 public costForListing;


  // owner
  // costForlisting
  // tokenId
  // allItemSoldCount;
  // 

  // what can be done on the Marketplace?
  // a user can purchase list their NFT on the marketplace
  // a user can 
}