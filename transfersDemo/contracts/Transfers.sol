// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Transfers {

    struct Transfer {
        uint amount;
        uint timestamp;
        address sender;
    }

    Transfer[] transfers;
    address owner;
    uint8 maxTransfersAmount;
    uint8 currTransfersAmount;

    constructor(uint8 _maxTransfers) {
        maxTransfersAmount = _maxTransfers;
        owner = msg.sender;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "This operation is only allowed for owner!");
        _;
    }

    function getTransfer(uint8 _index) public view returns(Transfer memory) {
        require(_index < transfers.length, "Index out of the range!");
        return transfers[_index];
    }

    function withdrawTo(address payable _to) public OnlyOwner {
        _to.transfer(address(this).balance);
    }

    receive() external payable {
        if (++currTransfersAmount > maxTransfersAmount) {
            revert(string(abi.encodePacked("Sorry, cannot accept more than: ", Strings.toString(maxTransfersAmount), string(" transfers!"))));
        }

        Transfer memory newTransfer = Transfer(msg.value, block.timestamp, msg.sender);
        transfers.push(newTransfer);
    }

}

