// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Whitelist {
    address public owner;
    mapping(address => bool) public whitelistedUser;
    mapping(address => uint256) public balances;

    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
    function addToWhitelist(address _addr) external onlyOwner {
        whitelistedUser[_addr] = true;
    }
    function removeFromWhitelist(address _addr) external onlyOwner {
        whitelistedUser[_addr] = false;
    }
    //  whitelisted can deposit ETH
    function sendEth() external payable {
        require(whitelistedUser[msg.sender], "not whitelisted");
        require(msg.value >= 0.1 ether, "minimum 0.1 ETH required");
        balances[msg.sender] += msg.value;
    }

    //  whitelisted can withdraw their ETH
    function withdraw(uint256 amount) external {
        require(whitelistedUser[msg.sender], "Not whitelisted");
        require(amount > 0, "Amount must be greater than 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Withdraw failed");
    }

    function MyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
