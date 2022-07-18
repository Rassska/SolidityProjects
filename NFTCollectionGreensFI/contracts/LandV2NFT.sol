// SPDX-License-IDentifier: MIT
pragma solidity 0.8.15;

import 'erc721a-upgradeable/contracts/ERC721AUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";


error InvalidMintAmountPerTx(uint256 _allowedAmount, uint256 _currentAmount);
error MaxSupplyExceeded(uint256 _allowedAmount, uint256 _currentAmount);
error NonExistentToken(uint256 _currentTokenId);
error SignatureReplayed(bytes _currentSignature);
error RequestIsNotRegisteredByTheServer(address _sender, uint _tokenAmount, uint _value, bytes _currentSignature, uint _nonce);
contract LandV2NFT is ERC721AUpgradeable, OwnableUpgradeable { 

    uint256 public constant maxSupply = 1500000000; // upper bound
    
    uint256 public maxMintAmountPerTx;
    uint256 public nonce;
    address public verifier;
    string public uriSuffix;
    string public baseURI;  


    mapping (uint256 => uint256[]) public greenhouses; // LandNFT ID => GreenhouseNFT IDs 

    event newURISuffixValule(string _previous, string _updated);
    event newBaseURIValue(string _previous, string _updated);
    event newMaxMintAmountPerTxValue(uint256 _previous, uint256 _updated);
    event newVerifierAddress(address indexed _verifier);

    modifier mintCompliance(uint256 _mintAmount) {

        if (_mintAmount <= 0 || _mintAmount > maxMintAmountPerTx) {
            revert InvalidMintAmountPerTx(maxMintAmountPerTx, _mintAmount);
        }
        if (totalSupply() + _mintAmount <= maxSupply) {
            revert MaxSupplyExceeded(maxSupply, totalSupply() + _mintAmount);
        }
        _;
    }

    function initialize() 
        initializer 
        initializerERC721A 
        external 
    {
        __ERC721A_init("LandNFT", "NFL");
        __Ownable_init();
        _initializeBase();
        verifier = msg.sender;
    }

    function mint(
        uint256 _mintAmount, 
        bytes calldata _signature
    ) 
        external 
        payable
        mintCompliance(_mintAmount) 
    {
        if (_recoverSigner(address(this), msg.sender, _signature, msg.value, nonce) != verifier) {
            revert RequestIsNotRegisteredByTheServer(msg.sender, _mintAmount, msg.value, _signature, nonce);
        }

        unchecked {
            ++nonce;
        }
        _safeMint(msg.sender, _mintAmount);

    }
    
    function buildGreenhouses(uint256[] calldata _greenhouseTokenIDs, uint256 _landTokenID) external {
        greenhouses[_landTokenID] = _greenhouseTokenIDs;
    }

    function walletOfOwner(
        address _owner
    )
        external
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory ownedTokenIDs = new uint256[](ownerTokenCount);
        uint256 currentTokenID = 1;
        uint256 ownedTokenIndex = 0;

        while (ownedTokenIndex < ownerTokenCount && currentTokenID <= maxSupply) {
        address currentTokenOwner = ownerOf(currentTokenID);

            if (currentTokenOwner == _owner) {
                ownedTokenIDs[ownedTokenIndex] = currentTokenID;
                ownedTokenIndex++;
            }

            unchecked{
                ++currentTokenID;
            }
        }

        return ownedTokenIDs;
    }

    function tokenURI(
        uint256 _tokenID
    )
        external
        view
        virtual
        override
        returns (string memory)
    {
        if (!_exists(_tokenID)) {
            revert NonExistentToken(_tokenID);
        }
        string memory currentBaseURI = baseURI;

        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, _toString(_tokenID), uriSuffix))
            : "";
    }

    function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) external onlyOwner {
        emit newMaxMintAmountPerTxValue(maxMintAmountPerTx, _maxMintAmountPerTx);        
        maxMintAmountPerTx = _maxMintAmountPerTx;
    }

    function setBaseURI(string calldata _newBaseURI) external onlyOwner {
        emit newBaseURIValue(baseURI, _newBaseURI);
        baseURI = _newBaseURI;
    }

    function setUriSuffix(string calldata _uriSuffix) external onlyOwner {
        emit newURISuffixValule(uriSuffix, _uriSuffix);
        uriSuffix = _uriSuffix;
    }

    function setVerifier(address _newVerifier) external onlyOwner {
        emit newVerifierAddress(_newVerifier);
        verifier = _newVerifier;
    }


    function _initializeBase() internal {
        uriSuffix = ".json";
        baseURI = "https://gateway.pinata.cloud/ipfs/QmNd5MKmkM4VhXgo9J9DvGEAM4XWZwyvBVtZ1K6iAjEkhr/";
        maxMintAmountPerTx = 10000;
        
    }

    function _recoverSigner(address _contractAddress, address _senderAddress, bytes calldata _signature, uint _value, uint _nonce) internal pure returns(address) {
        bytes32 currentMessage = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32", 
                _senderAddress,
                _contractAddress,
                _nonce,
                _value
            )
        );
        return ECDSA.recover(currentMessage, _signature);

    }

}


