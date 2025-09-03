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
        require(isRegistered[_addr], "Not registered referral address"); // jo address pass kr rha hai vo register to haina refferal keliye 
        require(_addr != address(0), "Invalid referral address");// address invalid to nhi hai jiska pass kr rha hai  
        require(msg.sender != _addr, "Can't refer yourself");// khd ka address hi to nhi pass kr rha hai refferal address ke liye
        require(referrerOf[msg.sender] == address(0), "Already referred"); // paihle se hi to koi apne against refferal address nhi le rkha hai 

        referrerOf[msg.sender] = _addr; // yha paass user ne apne against refferal address de diya hai ki isse reward milenge.aur mapping me save kr liya hai
        noOfReferrals[_addr] += 1;

        emit Referred(msg.sender, _addr);
    }

    function buy() external payable {
        require(msg.value >= 0.5 ether, "Minimum 0.5 ETH required");

        address referrer = referrerOf[msg.sender]; // jisse referal address ko reward milna hai use hmne ek Referrer varibale me save krva diya hai.
        // For my address, the corresponding referral address has been taken, and it will point to that referrer’s address
        if (referrer != address(0)) {
            referralRewards[referrer] += reward;
          // buy krte hi time jis user ne buy kra hai uske referal address me hmne amount save krva di hai   
        }
    }

    function claimReward() external {
        uint256 rewardAmt = referralRewards[msg.sender]; // jo bhi amount tha claim krne wale ka hmne ek variable me store krva di hai 
        require(rewardAmt > 0, "No reward to claim");

        referralRewards[msg.sender] = 0; // ab uska balance khali kr diya hai 
        (bool success, ) = payable(msg.sender).call{value: rewardAmt}(""); // ab transfer kr diya hai hmne .
        require(success, "Transfer failed");
    }
}
