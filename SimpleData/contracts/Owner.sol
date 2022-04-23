// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Owner {

  address m_owner;

  constructor() public {
    m_owner = msg.sender;
  }

  struct userInfo {
    uint m_userId;
    string m_name;
    uint age;
  }

  mapping(uint => userInfo) m_users;

  function addUser(uint _userId, string memory _userName, uint _userAge) public {
    require(msg.sender == m_owner, "Not the owner");
    m_users[_userId] = userInfo(_userId, _userName, _userAge);
  }

  function getUser(uint _userId) public view  returns(uint userId, string memory userName){
    require(msg.sender == m_owner, "Not the owner");
    return (m_users[_userId].m_userId, m_users[_userId].m_name);
  }
}
