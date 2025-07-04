// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Staking {
    struct Stake {
        uint256 amount;
        uint256 stakeTime;
        bool claimed;
    }

    mapping(address => Stake) public Stakes;
    uint256 public constant Duration = 30 days;

    event InfoOfStaked(address indexed user, uint256 amount, uint256 UTCtimestamp);

    // Stake function
    function stake() external payable {
        require(msg.value > 0.1 ether, "Not sufficient amount to stake");
        require(Stakes[msg.sender].amount == 0, "Already staked");

        Stakes[msg.sender] = Stake({
            amount: msg.value,
            stakeTime: block.timestamp,
            claimed: false
        });

        emit InfoOfStaked(msg.sender, msg.value, block.timestamp);
    }

    // Claim function
    function claim() external {
     Stake storage userStake = Stakes[msg.sender];

     require(userStake.amount > 0, "No amount staked");
     require(!userStake.claimed, "Already claimed");
     require(block.timestamp >= userStake.stakeTime + Duration, "Cannot claim before 30 days");

      uint256 amount = userStake.amount;
      userStake.claimed = true;
      userStake.amount = 0; // reentrancy prevention

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transaction failed");
    }
   // Time left 
    function timeLeft(address addr) external view returns (uint256) {
     Stake memory userStake = Stakes[addr];

     if (block.timestamp >= userStake.stakeTime + Duration) {
            return 0;}
    return (userStake.stakeTime + Duration) - block.timestamp;
    }
}

