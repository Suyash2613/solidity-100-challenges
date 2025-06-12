// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;
  contract Donation{
    address public immutable owner;
    
     constructor(){
        owner = msg.sender;
     }

    mapping(address => uint) public amount;

    event DonationAmount(address donator, uint256 indexed amount);

  receive() external payable {
    require(msg.value > 0);
    amount[msg.sender]= amount[msg.sender] + msg.value;
    emit DonationAmount(msg.sender, msg.value);
    }
   
   modifier onlyOwner(){
    require(msg.sender == owner,"you are not owner");
    _;
   }
    function withdraw() external onlyOwner  {
      uint256 Contractbalance = address(this).balance;
      require(Contractbalance > 0, "nothing to withdraw");
      payable(owner).transfer(Contractbalance);

  // Store the total ETH in the contract into 'contractBalance'
      } 
    }