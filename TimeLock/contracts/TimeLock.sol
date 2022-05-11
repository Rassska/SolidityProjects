//SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract TimeLock {

    using SafeMath for uint;

    struct Payment {
        uint timestamp;
        uint amount;
    }

    mapping (address => Payment[]) payments;


    receive() external payable {
        require(msg.value > 0, "Is this hacking?");
        Payment memory payment;
        payment.timestamp = block.timestamp + 1 weeks;
        payment.amount = msg.value;
        payments[msg.sender].push(payment);
    }

    function increaseLockTimeOfAllPayments(uint _seconds) external {
        uint length = payments[msg.sender].length;
        for (uint i = 0; i < length; ++i) {
            payments[msg.sender][i].timestamp.add(_seconds);
        }
    }
    
    function withdrawAllPossible() external {
        require(payments[msg.sender].length > 0, 'You have no any deposits!');
        uint alowedAmount;
        uint length = payments[msg.sender].length;
        for (uint i = 0; i < length; ++i) {
            if (payments[msg.sender][i].timestamp > block.timestamp) {
                alowedAmount.add(payments[msg.sender][i].amount);
            }
        }
        if (alowedAmount > 0) {
            Address.sendValue(payable(msg.sender), alowedAmount);
        } else {
            revert("Every payment is locked by now, see you later!");
        }

    }

}