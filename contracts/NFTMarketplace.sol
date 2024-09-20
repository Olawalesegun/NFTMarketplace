// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTMarketplace is ERC721URIStorage {
  address payable public owner;
  uint256 public allItemsSoldCount;
  uint256 public tokenId;
  uint256 public costForListing = 10;

  struct NFTOrder {
    uint256 id;
    uint256 price;
    address payable seller;
    address payable buyer;

  }

  mapping(uint256 => NFTOrder) listedNFTs;

  function onlyOwner() private view{
    if(msg.sender != owner){
      revert NotAuthorized();
    }
  }

  error NotAuthorized();
  error PriceMustBeGreaterThanZero();
  error AddressZeroDetected();

  constructor()ERC721("KHALSNFT", "KNFT"){
    owner = payable(msg.sender);
  }

  function listNFT(string memory _tokenURI, uint256 _price) public returns(uint256){
   if(msg.sender == address(0)){
    revert AddressZeroDetected();
   }
   if(_price <= 0){
    revert PriceMustBeGreaterThanZero();
   }
   tokenId++;
   uint256 tokId = tokenId;
   _safeMint(msg.sender, tokenId);
   _setTokenURI(tokId, _tokenURI);

   NFTOrder storage nftList = listedNFTs[tokId];
   nftList.id = tokId;
   nftList.seller = payable(msg.sender);
   nftList.price = _price;

   return tokId;
  }


  // owner
  // costForlisting
  // tokenId
  // allItemSoldCount;
  // 

  // what can be done on the Marketplace?
  // a user can list their NFT on the marketplace
  // a user can mint their NFT
}