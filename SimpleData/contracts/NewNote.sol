// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract NewNote {

  struct userInfo {
    uint m_userId;
    string m_name;
    uint m_number;
    string m_address;
  }

  mapping(uint => userInfo) public m_users;

  function addUser(
    uint userId, 
    string memory userName, 
    uint userNumber, 
    string memory userAddress) public {

    m_users[userId] = userInfo(userId, userName, userNumber, userAddress);

  }

  function getUser(uint userId) public view returns(uint userNumber, string memory userName){
    return (m_users[userId].m_number, m_users[userId].m_name);
  }

}
