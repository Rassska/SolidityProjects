// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Note {
  string public m_name;
  uint m_number;
  string public m_address;

  function set(string memory _name, uint _number, string memory _address) public {
    m_name = _name;
    m_number = _number;
    m_address = _address;
  }

  function get() public view returns (string memory, uint, string memory) {
    return (m_name, m_number, m_address);
  }

}
