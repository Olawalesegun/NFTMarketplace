// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTMarketplace is ERC721URIStorage {
  address payable public owner;
  uint256 public allItemsSoldCount;
  uint256 public tokenId;
  uint256 public costForListing = 0.01 ether;

  struct NFTOrder {
    uint256 id;
    uint256 price;
    address[] prevOwner;
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
  error NotExactAmount();
  error InsufficientCostForListing();
  error NFTNotAvailable();

  event NftPurcaseSuccessful(uint256 _tokenId, address whoPays);

  constructor()ERC721("KHALSNFT", "KNFT"){
    owner = payable(msg.sender);
  }

  // in this function, I have the mint, and sell function
  function listNFT(string memory _tokenURI, uint256 _price) public payable returns(uint256){
   if(msg.sender == address(0)){
    revert AddressZeroDetected();
   }
   if(_price <= 0){
    revert PriceMustBeGreaterThanZero();
   }
   if(msg.value != costForListing){
    revert InsufficientCostForListing();
   }
   tokenId++;
   uint256 tokId = tokenId;
   _safeMint(msg.sender, tokenId);
   _setTokenURI(tokId, _tokenURI);

   owner.transfer(msg.value);

   NFTOrder storage nftList = listedNFTs[tokId];
   nftList.id = tokId;
   nftList.seller = payable(msg.sender);
   nftList.price = _price;

   return tokId;
  }

  function buyNFT(uint256 _tokenId) external payable {
    if(msg.sender == address(0)){
      revert AddressZeroDetected();
    }

    NFTOrder storage nftList = listedNFTs[_tokenId];

    if(nftList.price == 0){
      revert NFTNotAvailable();
    }
    uint256 amountToPay = nftList.price + costForListing;

    if(msg.value != amountToPay){
      revert NotExactAmount();
    }
    address oldOwner = nftList.seller;
    nftList.prevOwner.push(oldOwner);
    nftList.seller = payable(msg.sender);

    _safeTransfer(oldOwner, msg.sender, _tokenId);

    allItemsSoldCount++;
    payable(oldOwner).transfer(msg.value);

    delete listedNFTs[_tokenId];

    emit NftPurcaseSuccessful(_tokenId, msg.sender);

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