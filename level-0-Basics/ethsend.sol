// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;
 contract ethsend{
    uint256 public totalamount;

   mapping(address => uint) public balance;

  function amountsend() external payable returns(uint256){

     require(msg.value > 0,"amount not be zero");

     balance[msg.sender] = balance[msg.sender] + msg.value;
     
     return balance[msg.sender];
  }
 function getbalance() public returns(uint256){
    totalamount = balance[msg.sender];

    return(totalamount);
 }
 } 