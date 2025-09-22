// Two-Step Admin Transfer (Basic Version)
pragma solidity ^0.8.16;

contract TwoStepAdmin {
    address public admin;
    address public pendingAdmin;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not the admin");
        _;
    }
    function proposeAdmin(address _addr) external onlyAdmin {
        require(_addr != address(0), "Invalid address");
        pendingAdmin = _addr;
    }

    // Proposed admin accepts 
    function acceptAdmin() external {
        require(msg.sender == pendingAdmin, "Not proposed admin");
        admin = pendingAdmin;
        pendingAdmin = address(0); // reset after acceptance
    }
}
