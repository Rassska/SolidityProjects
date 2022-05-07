//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract sample {
    bytes32 name;
    int64 value;


    function setName(bytes32 _newName) external {
        name = _newName;
    }

    function setValue(int64 _newValue) external {
        value = _newValue;
    }

    function getName() external view returns (bytes32){
        return name;
    }

    function getValue() external view returns (int64){
        return value;
    }
}