// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;
contract FundRaising {
    address public owner;
    uint256 public goal;
    uint256 public deadline;
    uint256 public totalFund;

    mapping(address => uint256) public userFund;

    constructor(uint256 _amount) {
        owner = msg.sender;
        goal = _amount;
        deadline = block.timestamp + 86400; // 1 day from now (UTC)
    }

    modifier allowFund() {
        require(block.timestamp < deadline, "Above the deadline");
        require(totalFund < goal, "Goal already met");
        _;
    }

    modifier allowRefund() {
        require(block.timestamp > deadline, "Yet not allowed to refund");
        require(userFund[msg.sender] > 0, "You haven't funded");
        _;
    }

    function addFund() external payable allowFund {
        require(msg.value > 0, "Can't send 0 ETH");
        userFund[msg.sender] += msg.value;
        totalFund += msg.value;
    }

    function claimRefund() external allowRefund {
        uint256 amount = userFund[msg.sender];
        require(amount > 0, "No balance to refund");
        userFund[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Refund failed");
    }
}
