// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedMarketplace {
    // Struct to define an item
    struct Item {
        uint256 id;
        string name;
        uint256 price;
        address seller;
        bool sold;
    }

    // State variables
    address public owner;
    uint256 private itemCounter;
    mapping(uint256 => Item) public items;
    mapping(uint256 => address) public itemOwners;
    mapping(address => uint256) public pendingWithdrawals;

    // Events
    event ItemListed(uint256 id, string name, uint256 price, address seller);
    event ItemPurchased(uint256 id, address buyer);
    event Withdrawal(address seller, uint256 amount);

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
        itemCounter = 0;
    }

    // Function to list an item for sale
    function listItem(string memory _name, uint256 _price) external {
        require(bytes(_name).length > 0, "Item name cannot be empty");
        require(_price > 0, "Item price must be greater than zero");

        itemCounter++;
        items[itemCounter] = Item(itemCounter, _name, _price, msg.sender, false);
        itemOwners[itemCounter] = msg.sender;

        emit ItemListed(itemCounter, _name, _price, msg.sender);
    }

    // Function to purchase an item
    function purchaseItem(uint256 _itemId) external payable {
        Item storage item = items[_itemId];
        require(item.id != 0, "Item does not exist");
        require(!item.sold, "Item already sold");
        require(msg.value == item.price, "Incorrect Ether value");

        item.sold = true;
        itemOwners[_itemId] = msg.sender;
        pendingWithdrawals[item.seller] += msg.value;

        emit ItemPurchased(_itemId, msg.sender);
    }

    // Function to withdraw funds
    function withdrawFunds() external {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "No funds to withdraw");

        pendingWithdrawals[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit Withdrawal(msg.sender, amount);
    }

    // Function to get item details
    function getItem(uint256 _itemId) external view returns (uint256, string memory, uint256, address, bool) {
        Item memory item = items[_itemId];
        return (item.id, item.name, item.price, item.seller, item.sold);
    }
}
