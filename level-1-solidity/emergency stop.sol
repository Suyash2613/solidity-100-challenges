bhai dekho hum log kya kr rhe the normal function me modifier lga ek check kr rhe hai ki bool stopped hai ya nhi hai 
agr 





// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract UserStorageBatch {
    struct User {
        uint256 id;
        string name;
    }

    User[] public users;
    address public owner;
    bool public stopped = false; // ✅ pause flag but abhi paused nhi hai ye 

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier stopInEmergency() {
        require(!stopped, "Contract is paused");
        _;
    }
   
    function toggleContractActive() external onlyOwner {
        stopped = !stopped; // ✅ owner pause/unpause kar sakta hai
    }

    // Pausable function
    function addUsers(User[] calldata _users) external stopInEmergency {
        uint256 len = _users.length;
        for (uint256 i = 0; i < len; ) {
            users.push(User({
                id: _users[i].id,
                name: _users[i].name
            }));
            unchecked { i++; }
        }
    }
}
