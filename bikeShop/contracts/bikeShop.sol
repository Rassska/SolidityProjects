//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract bikeShop{

    address private owner;
    address private shopAddress;
    uint private bikePrice = 2 ether;
    uint private customersAmount;
    uint private receivedTotal;
    bool fullyPaid;
    
    mapping(address => bool) customers;

    constructor() {
        owner = msg.sender;
        shopAddress = address(this);
    }

    function addCustomer(address _newCustomer) public {
        require(msg.sender == owner, "This operation is only allowed for owner");
        customers[_newCustomer] = true;
        customersAmount++;
    }

    function getBalance() public view returns(uint) {
        require(msg.sender == owner, "This operation is only allowed for owner");
        return shopAddress.balance;
    }

    function getShopAddress() public view returns(address) {
        require(msg.sender == owner, "This operation is only allowed for owner");
        return address(shopAddress);
    }

    receive() external payable {
        require(customers[msg.sender], "Customer's list doesn't consist of the current user");
        require(bikePrice / customersAmount == msg.value, string(abi.encodePacked("You need to pay exactly: ", Strings.toString(bikePrice / customersAmount))));
        
        receivedTotal += msg.value;
    }








}

