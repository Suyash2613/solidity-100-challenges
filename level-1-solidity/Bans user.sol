// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BannedFeature {
    address public owner;
    mapping(address => bool) public isBanned;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier notBanned() {
        require(!isBanned[msg.sender], "You are banned from this feature");
        _;
    }

    // Add an address to ban list
    function banAddress(address _user) external onlyOwner {
        isBanned[_user] = true;
    }

    // Remove an address from ban list
    function unbanAddress(address _user) external onlyOwner {
        isBanned[_user] = false;
    }

    // Example restricted feature
    function useFeature(uint _x, uint _y) external view notBanned returns (uint) {
        return _x + _y; // simple example
    }
}
