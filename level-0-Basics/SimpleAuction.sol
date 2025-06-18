// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;
  
  contract Bidding{
    uint256 public highestBid;
    address public HighestBidder;
    address public owner;
    bool public auctionEnd;
 constructor(){
    owner = msg.sender;
 }
 mapping(address => uint) public bids;
  
   function Bid() public payable {
    require(auctionEnd == false, "Aunction is done ");
    require(msg.value > highestBid, " not accept current bid is lower");

     if(highestBid > 0){
        payable(HighestBidder).transfer(highestBid);
     }
    highestBid = msg.value;
    HighestBidder = msg.sender;

    bids[msg.sender] = msg.value;
   }
  function EndAunction() public {
    require( auctionEnd == false, "already End");
    require(msg.sender == owner,"not allowed anyone to end the auction");
    auctionEnd = true;

    payable(msg.sender).transfer(highestBid);
    }