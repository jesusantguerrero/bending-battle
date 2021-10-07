//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./BenderOwnership.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BenderNFTMarket is Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemSold;
    
    address payable contractOwner;
    uint listingPrice = 0.025 ether;

    struct MarketItem {
        uint itemId;
        address ntfContract;
        uint tokenId;
        address payable seller;
        address payable owner;
        uint price;
        bool sold;
    }

    mapping(address => uint) private itemsSellerCount;
    mapping(address => uint) private itemsOwnerCount;
    mapping(uint => MarketItem) private idToMarketItem;

    event MarketItemCreated(
        uint indexed itemId,
        address indexed ntfContract,
        uint indexed tokenId,
        address payable seller,
        address payable owner,
        uint price,
        bool sold
    );

    constructor() {
        contractOwner = payable(msg.sender);
    }

    function getListingPrice() public view returns (uint) {
        return listingPrice;
    }

    function setListingPrice(uint _listingPrice) external onlyOwner {
        listingPrice = _listingPrice;
    }

    function createMarketItem(address _nftContract, uint _tokenId, uint _price) public payable nonReentrant {
        require(_price > 0, "Price must be at least 1 wei");
        require(msg.value == listingPrice, "Price must be equal to listing price");

        _itemIds.increment();
        uint itemId = _itemIds.current();

        idToMarketItem[itemId] = MarketItem(
            itemId,
            _nftContract,
            _tokenId,
            payable(msg.sender),
            payable(address(0)),
            _price,
            false
        );

        itemsSellerCount[msg.sender]++;
        BenderOwnership(_nftContract).transferFrom(msg.sender, address(this), _tokenId);
        emit MarketItemCreated(
            itemId,
            _nftContract,
            _tokenId,
            payable(msg.sender),
            payable(address(0)),
            _price,
            false 
        );
    }

    function createMarketSale(address _nftContract, uint _itemId) public payable {
        uint price = idToMarketItem[_itemId].price;
        uint tokenId = idToMarketItem[_itemId].tokenId;
        require(price == msg.value, "Please submit the required price");
        
        idToMarketItem[_itemId].seller.transfer(price);
        BenderOwnership(_nftContract).transferFrom(address(this), msg.sender , tokenId);
        idToMarketItem[_itemId].owner = payable(msg.sender);
        idToMarketItem[_itemId].sold = true;
        _itemSold.increment();
        payable(contractOwner).transfer(listingPrice);
        itemsOwnerCount[msg.sender]++;
    }

    function getMarketItems() public view returns (MarketItem[] memory) {
        uint itemsCount = _itemIds.current();
        uint unsoldItemsCount = itemsCount - _itemSold.current();
        uint counter = 0;
        MarketItem[] memory items = new MarketItem[](unsoldItemsCount);

        for (uint i = 1; i <= itemsCount; i++) {
            if (idToMarketItem[i].owner == address(0)) {
                items[counter] = idToMarketItem[i];
                counter++;
            }
        }
        return items;
    }

    function getMyNFTs() public view returns (MarketItem[] memory)  {
        uint itemsCount = _itemIds.current();
        uint counter = 0;
        MarketItem[] memory items = new MarketItem[](itemsOwnerCount[msg.sender]);

        for (uint i = 1; i <= itemsCount; i++) {
            if (idToMarketItem[i].owner == msg.sender) {
                items[counter] = idToMarketItem[i];
                counter++;
            }
        }
        return items;
    }
   
    function getMyCreatedNFTs() public view returns (MarketItem[] memory) {
        uint itemsCount = _itemIds.current();
        uint counter = 0;
        MarketItem[] memory items = new MarketItem[](itemsSellerCount[msg.sender]);

        for (uint i = 1; i <= itemsCount; i++) {
            if (idToMarketItem[i].seller == msg.sender) {
                items[counter] = idToMarketItem[i];
                counter++;
            }
        }
        return items;
    }
}