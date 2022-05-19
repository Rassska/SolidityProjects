//SPDX-License-Identifier:MIT


pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";

contract Gambling {
    
    uint __depositNumber;
    uint __nthWinner;

    constructor(uint _nth) {
        __nthWinner = _nth;
    }

    event ReceivedDeposit(address indexed _from, uint indexed _depositNumber, uint _amount);
    event WithdrawFunds(address indexed _to, uint _amount);

    
    modifier costs(uint _amount) {
        require(_amount == 1 ether, "Exactly 1 ether per game!");
        _;
    }
    

    receive() external payable costs(msg.amount){
        unchecked { 
            __depositNumber++; 
        }
        ReceivedDeposit(msg.sender, __depositNumber, msg.amount);

        if (__depositNumber % __nthWinner == 0) {
            Address.sendValue(payable(msg.sender), this.balance);
            WithdrawFunds(msg.sender, this.balance);
            __depositNumber = 0;
        }
    }

}