// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./LandNFT.sol";

contract LandNFTV3 is LandNFT{

    function getCurrentVersion() public pure returns(string memory) {
        return "v3!";
    }

}

