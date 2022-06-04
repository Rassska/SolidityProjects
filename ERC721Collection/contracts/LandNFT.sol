// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

uint256 constant _maxSupply = 1500000000; // upper bound

contract LandNFT is Initializable, ERC721Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using Strings for uint256;

    CountersUpgradeable.Counter private _tokenIdCounter;
    string public _uriSuffix = ".json";
    string public _baseURI = "https://gateway.pinata.cloud/ipfs/QmNd5MKmkM4VhXgo9J9DvGEAM4XWZwyvBVtZ1K6iAjEkhr/";
  
    uint256 public _maxMintAmountPerTx = 10000;


    constructor() {
        _disableInitializers();
    }


    function initialize() initializer public {
        __ERC721_init("LandNFT", "NFL");
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}


    modifier mintCompliance(uint256 mintAmount) {
        require(mintAmount > 0 && mintAmount <= _maxMintAmountPerTx, "Invalid mint amount!");
        require(_tokenIdCounter.current() + mintAmount <= _maxSupply, "Max supply exceeded!");
        _;
    }

    function mintForAddress(uint256 mintAmount, address receiver) public mintCompliance(mintAmount) onlyOwner {
        _mintLoop(receiver, mintAmount);
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
        uint256 currentTokenId = 1;
        uint256 ownedTokenIndex = 0;

        while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
        address currentTokenOwner = ownerOf(currentTokenId);

            if (currentTokenOwner == _owner) {
                ownedTokenIds[ownedTokenIndex] = currentTokenId;
                ownedTokenIndex++;
            }

            currentTokenId++;
        }

        return ownedTokenIds;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        
        require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
            : "";
    }

    function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
        maxMintAmountPerTx = _maxMintAmountPerTx;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setUriSuffix(string memory _uriSuffix) public onlyOwner {
        uriSuffix = _uriSuffix;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function _mintLoop(address receiver, uint256 mintAmount) internal {
        for (uint256 i = 0; i < mintAmount; i++) {
         _tokenIdCounter.increment();
        _safeMint(receiver, _tokenIdCounter.current());
        }
    }

}

