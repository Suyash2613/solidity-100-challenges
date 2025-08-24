// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2Upgradeable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

contract Lottery is
    Initializable,
    OwnableUpgradeable,
    VRFConsumerBaseV2Upgradeable
{
    uint256 public startingOfLottery;
    uint256 public endingTimeOfLottery;
    uint256 public ticketPrice;
    address payable public winner;

    address payable[] public listOfUser;
    mapping(address => bool) public register;

 // Chainlink VRF variables
    VRFCoordinatorV2Interface private COORDINATOR;
    uint64 public subscriptionId;
    bytes32 public keyHash;
    uint32 public callbackGasLimit;
    uint16 public requestConfirmations;
    uint32 public numWords;

    function initialize(
        uint256 _startTime,
        uint256 _endingTime,
        uint256 _ticketPrice,
        uint64 _subscriptionId,
        address _vrfCoordinator,
        bytes32 _keyHash
    ) public initializer {
        __Ownable_init();
        __VRFConsumerBaseV2_init(_vrfCoordinator);

        startingOfLottery = block.timestamp + _startTime;
        endingTimeOfLottery = startingOfLottery + _endingTime;
        ticketPrice = _ticketPrice;

        COORDINATOR = VRFCoordinatorV2Interface(_vrfCoordinator);
        subscriptionId = _subscriptionId;
        keyHash = _keyHash;
        callbackGasLimit = 200000;
        requestConfirmations = 3;
        numWords = 1;
    }

    function buy() public payable {
        require(msg.value >= ticketPrice, "Insufficient balance");
        require(!register[msg.sender], "Already registered");
        require(block.timestamp >= startingOfLottery, "Not started yet");

        register[msg.sender] = true;
        listOfUser.push(msg.sender);
    }

    function pickWinner() public onlyOwner {
        require(block.timestamp > endingTimeOfLottery,"Lottery is not ended yet");
        require(listOfUser.length > 0, "No players");

        COORDINATOR.requestRandomWords(
            keyHash,
           subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }
  // call by the chainlink not from owner , when the randomNumber is prepared
    function fulfillRandomWords(
        uint256,
        uint256[] memory randomWords
    ) internal override {
        uint256 winnerIndex = randomWords[0] % listOfUser.length;
        winner = listOfUser[winnerIndex];
        uint256 Amount = address(this).balance;

       // Reset players for next round
     for(uint256 i= 0 ; i< listOfUser.length ; i++) {
       register[listOfUser[i]] = false;
     }
     delete listOfUser;
     // for prevent Re-entrancy attack we transfer amount at the last 
        (bool success, ) = winner.call{value: Amount}("");
        require(success,"Prize not Transfer");
    }  
      receive() external payable {}
      fallback() external payable {}
   }

    // TransparentUpgradeableProxy = proxy contract jisme implementation ka address + admin ka address + initialization data pass karte hain deploy ke time.
    // ProxyAdmin = ek helper contract jo proxy ka implementation upgrade/manage karta hai.