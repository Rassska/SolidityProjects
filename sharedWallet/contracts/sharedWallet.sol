//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

contract SharedWallet {

    mapping (address => bool) __owners;
    address private __contractOwner;

    modifier onlyContractOwner {
        require(msg.sender == __contractOwner, "Only Owner!");
        _;
    }
    modifier onlyWalletOwner(address _walletOwnerAddress) {
        require(__owners[_walletOwnerAddress] == true, "Current user is not a wallet owner!");
        _;
    }
    modifier isValidAddress(address _currentAddress) {
        require(address(0) != _currentAddress);
        _;
    }

    event DepositFunds(address _walletOwner, uint256 _amount);
    event WithdrawFunds(address _walletOwner, uint256 _amount);
    event TransferFunds(address _to, address _walletOwner, uint256 _amount);

    constructor() {
        __contractOwner = msg.sender;
    }



    function addOwner(address _walletOwnerAddress) external onlyContractOwner isValidAddress(_walletOwnerAddress){
        __owners[_walletOwnerAddress] = true;
    }
    function removeOwner(address _walletOwnerAddress) external onlyContractOwner isValidAddress(_walletOwnerAddress){
        __owners[_walletOwnerAddress] = false;
    }

    receive() external payable onlyWalletOwner(msg.sender) {
        emit DepositFunds(msg.sender, msg.value);
    }

    function withdrawTo(address _walletOwnerAddress, uint256 _amount) external onlyWalletOwner(_walletOwnerAddress) isValidAddress(_walletOwnerAddress){
        require(_amount <= address(this).balance, 'Insufficient balance!');
        Address.sendValue(payable(_walletOwnerAddress), _amount);
        emit WithdrawFunds(_walletOwnerAddress, _amount);
    }

    function transferFundsTo(address _to, uint256 _amount) external onlyWalletOwner(msg.sender) isValidAddress(_to) {
        require(_amount <= address(this).balance, 'Insufficient balance!');
        Address.sendValue(payable(_to), _amount);
        emit TransferFunds(_to, msg.sender, _amount);

    }

}