// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract SeedNFT is Initializable, ERC1155Upgradeable, OwnableUpgradeable, ERC1155SupplyUpgradeable, UUPSUpgradeable {
    
    mapping (uint256 => string) public _tokenURIs; // base uri for given token id 
    string private _baseURI;

    /// @custom:oz-upgrades-unsafe-allow constructor

    constructor() {
        _disableInitializers();
    }

    function initialize() 
        initializer 
        public 
    {
        __ERC1155_init("https://game.example/api/"); // URI storage for all tokens.  
        __Ownable_init();
        __ERC1155Supply_init();
        __UUPSUpgradeable_init();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function uri(uint256 tokenId) 
        public 
        view 
        virtual 
        override 
        returns (string memory) 
    {
        string memory tokenURI = _tokenURIs[tokenId];

        // If token URI is set, concatenate base URI and tokenURI (via abi.encodePacked).
        return bytes(tokenURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenURI)) : super.uri(tokenId);
    }

    function _setURI(uint256 tokenId, string memory tokenURI)
        public 
        onlyOwner
    {
        _tokenURIs[tokenId] = tokenURI;
        emit URI(uri(tokenId), tokenId);
    }

    function _setBaseURI(string memory baseURI)  
        public
        onlyOwner
    {
        _baseURI = baseURI;
    }


    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}


    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155Upgradeable, ERC1155SupplyUpgradeable)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }



}
