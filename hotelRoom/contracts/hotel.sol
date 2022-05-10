//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract HotelRoom {

    address immutable ownerAddress;

    enum Statuses {Occupied, Vacant}
    Statuses status;

    constructor() {
        ownerAddress = msg.sender;
        status = Statuses.Vacant;
    }
        
    event Occupy(address _ownerAddress, uint _value);

    modifier costs(uint _amount) {
        require(msg.value == _amount, string(abi.encodePacked("Cost is exactly 1 ether: ", Strings.toString(_amount))));
        _;
    }
    
    modifier inStatus(Statuses _currentStatus) {
        require(_currentStatus == Statuses.Vacant, "Current Room is Occupied!");
        _;
    }

    receive() external payable inStatus(status) costs(1 ether) {
        status = Statuses.Occupied;
        emit Occupy(ownerAddress, msg.value);
    }
    function withdrawTo(address _address) external {
        Address.sendValue(payable(_address), address(this).balance);
    }

    function getState() external view returns(bytes32) {
        if (status == Statuses.Occupied) return "Occupied";
        if (status == Statuses.Vacant) return "Vacant";
        return "";

    }
}
