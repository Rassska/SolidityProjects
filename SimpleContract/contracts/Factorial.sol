// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Factorial {
  
  function getFactorialOf(uint32 number) public pure returns(uint256){
    uint256 result = 1;
    for (uint32 i = 1; i <= number; i++){
      result *= i; 
    }
    return result;
  }


}
