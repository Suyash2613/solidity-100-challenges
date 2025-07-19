pragma solidity ^0.8.16;
 contract splitEth{
    address[] public users;

   constructor(address [] memory _user) {
    users = _user;
   } 
  function SplitEth() public payable{
    uint amount = msg.value/users.length ;

    for(uint i=0, i < users.length ; i++) {
     payable(users[i]).transfer(amount)
    }
  } 
 }