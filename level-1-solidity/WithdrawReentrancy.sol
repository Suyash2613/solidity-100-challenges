// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract WithdrawReentrancy {
    bool private locked;
    mapping(address => uint) public balance;

    modifier Locked() {
        require(!locked, "No reentrancy");
        locked = true;
        _;
        locked = false;
    }

    function sendEth() external payable {
        balance[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) external Locked {
        require(_amount > 0, "Amount must be greater than 0");
        require(balance[msg.sender] >= _amount, "Insufficient balance");

        balance[msg.sender] -= _amount;

        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Transaction failed");
    }
}
