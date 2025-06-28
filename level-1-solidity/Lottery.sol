// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

// ✅ IMPORTS from Chainlink
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/vrf/VRFCoordinatorV2Interface.sol";

contract Lottery is VRFConsumerBaseV2 {
    address public owner;
    address payable[] public players;
    address public winner;

    VRFCoordinatorV2Interface public COORDINATOR;
    uint64 public subscriptionId;
    bytes32 public keyHash;
    uint32 public callbackGasLimit = 100000;
    uint16 public requestConfirmations = 3;  
    uint32 public numWords = 1;           
    uint256 public lastRequestId;

    mapping(address => uint256) public AmountEth;

    event Winneraddress(address indexed winner);

    constructor(address _vrfCoordinator, uint64 _subscriptionId, bytes32 _keyHash)
        VRFConsumerBaseV2(_vrfCoordinator)
    {
        owner = msg.sender;
        COORDINATOR = VRFCoordinatorV2Interface(_vrfCoordinator);
        subscriptionId = _subscriptionId;
        keyHash = _keyHash;
    }

    //  Users buy ticket
    function BuyLottery() public payable {
        require(msg.value >= 0.1 ether, "Not enough ETH to buy ticket"); // ✅ Fix: `=>` was wrong
        players.push(payable(msg.sender));
        AmountEth[msg.sender] += msg.value;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    // Request randomness from Chainlink
    function pickWinner() public onlyOwner {
        require(players.length > 0, "No players yet");

        lastRequestId = COORDINATOR.requestRandomWords(
            keyHash,
            subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    //  Chainlink calls this function automatically
    function fulfillRandomWords(
        uint256,        
        uint256[] memory randomWords  
    ) internal override {
        uint256 winnerIndex = randomWords[0] % players.length;
        winner = players[winnerIndex];
     players[winnerIndex].transfer(address(this).balance);
        emit Winneraddress(winner);

        delete players; //  Reset for next round
    }
}
