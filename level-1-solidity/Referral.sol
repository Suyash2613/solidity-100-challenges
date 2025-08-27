// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract ReferralSystem {
    mapping(address => address) public referrerOf; // kisne kisko refer kiya
    mapping(address => uint256) public noOfReferrals; // ek referrer ke kitne referrals
    mapping(address => uint256) public referralRewards; // reward balance
    mapping(address => bool) public isRegistered; // registration check

    uint256 public reward = 0.01 ether; // reward fix hai

    event Referred(address indexed user, address indexed referrer);
    event RegisteredAddr(address indexed user);

    function register(address _addr) external {
        require(_addr != address(0), "Invalid address");
        require(!isRegistered[_addr], "Already registered");

        isRegistered[_addr] = true;
        emit RegisteredAddr(_addr);
    }

    function addAddr(address _addr) external {
        require(isRegistered[_addr], "Not registered referral address");
        require(_addr != address(0), "Invalid referral address");
        require(msg.sender != _addr, "Can't refer yourself");
        require(referrerOf[msg.sender] == address(0), "Already referred"); 

        referrerOf[msg.sender] = _addr;
        noOfReferrals[_addr] += 1;

        emit Referred(msg.sender, _addr);
    }

    function buy() external payable {
        require(msg.value >= 0.5 ether, "Minimum 0.5 ETH required");

        address referrer = referrerOf[msg.sender];
        // For my address, the corresponding referral address has been taken, and it will point to that referrer’s address
        if (referrer != address(0)) {
            referralRewards[referrer] += reward;
        }
    }

    function claimReward() external {
        uint256 rewardAmt = referralRewards[msg.sender];
        require(rewardAmt > 0, "No reward to claim");

        referralRewards[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: rewardAmt}("");
        require(success, "Transfer failed");
    }
}
