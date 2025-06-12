// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Voting {
    event Hello(string winner, uint256 votes);

    uint256 public countA;
    uint256 public countB;
    
    mapping(address => uint256) public voter;

    function vote(uint256 option) public {
        require(voter[msg.sender] == 0, "already voted");
        require(option == 1 || option == 2, "no other option");

        if (option == 1) {
            countA++;
            voter[msg.sender] = 1;
        } else {
            countB++;
            voter[msg.sender] = 2;
        }
    }


    function Winner() public returns (uint256, string memory) {
        uint256 winningVotes;
        string memory winnerName;

        if (countA > countB) {
            winningVotes = countA;
            winnerName = "A";
        } else if (countB > countA) {
            winningVotes = countB;
            winnerName = "B";
        } else {
            winnerName = "Tie";
        }

        emit Hello(winnerName, winningVotes);
        return (winningVotes, winnerName);
    }
}
