//SPDX-License-Identifier:MIT


pragma solidity ^0.8.0;

contract EtherStore {

	mapping(address => uint) __balances;

	function deposit() public payable {
		__balances[msg.sender] += msg.value;
	}

	function withdraw(uint _amount) public {
        require(__balances[msg.sender] >= _amount, "The actual __balance is less than amount");

        (bool sent, ) = msg.sender.call{value: _amount}("");

        require(sent, "Failed to send");
        __balances[msg.sender] -= _amount;

	}
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}

