// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;
  contract TimeVault{

mapping(address => uint256) public balance;
mapping(address => uint256) public locktime;

 function lockETH(uint _duration) public payable {
   require(msg.value > 0, "not enough Eth");
   balance[msg.sender] = balance[msg.sender]+ msg.value;
   locktime[msg.sender]= block.timestamp + _duration; 
 } // we set the time duration of lock the amount

 function withdraw() public {
   require(balance[msg.sender] > 0, "user have Zero balance");
   require(block.timestamp >= locktime[msg.sender],"not enough time");
  
   uint256 amount = balance[msg.sender]; // moved to memory from storage;
    balance[msg.sender] = 0;
   
   payable(msg.sender).transfer(amount);
 }
 function withdrawAmount() public view returns(uint256){
  return balance[msg.sender];
 }
  } 
