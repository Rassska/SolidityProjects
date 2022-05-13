//SPDX-License-Identifier:MIT


pragma solidity ^0.8.0;

import "../../ERC20/contracts/IERC20";
import "../../ERC20/contracts/ERC20";

contract BubbleToken is ERC20 {
    address __owner;
    constructor() ERC20("Bubble", "BBL"){
        __owner = msg.sender;
        __mint(__owner, 100 * 10 * 18);
    }
}