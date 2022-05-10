//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract addressBook {

    mapping (address => address[]) private _addresses;
    mapping (address => mapping(address => bytes32)) _aliases;

    function addNewAddress(address newAddress, bytes32 alia) public {
        _addresses[msg.sender].push(newAddress);
        _aliases[msg.sender][newAddress] = alia;
    }

    function getAddressBookOfThe(address currentAddress) public view returns(address[] memory) {
        return _addresses[currentAddress];
    }


    function getAllAliasesFor(address ownerAddress, address currentAddress) public view returns(bytes32) {
        return _aliases[ownerAddress][currentAddress];
    }

    function removeAddress(address currentAddress) public {
        uint length = _addresses[msg.sender].length;

        for (uint i = 0; i < length; ++i) {
            if (_addresses[msg.sender][i] == currentAddress) {
                if (_addresses[msg.sender].length > 1 && i < length - 1) {
                    _addresses[msg.sender][i] = _addresses[msg.sender][length - 1];
                }
                _addresses[msg.sender].pop();
                delete _aliases[msg.sender][currentAddress];
                break;
            }

        }
    }

}