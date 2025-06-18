 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Leaderboard {
    mapping(address => uint) public score; // Stores the current score of each player
    mapping(address => bool) public alreadyInBoard; // Tracks if a player is already on the leaderboard

    struct player {
        address addr;
        uint score;
    }

    player[] private leaderboard; // Internal leaderboard array (not exposed publicly)

    // Adds or updates a player's score
    function addscore(uint _score) external {
        if (!alreadyInBoard[msg.sender]) {
            // New player
            alreadyInBoard[msg.sender] = true; // Mark as added
            score[msg.sender] = _score; // Store score in mapping
            leaderboard.push(player(msg.sender, _score)); // Add to leaderboard array
        } else {
            // Existing player — update score
            score[msg.sender] = _score;
            for (uint i = 0; i < leaderboard.length; i++) {
                if (leaderboard[i].addr == msg.sender) {
                    leaderboard[i].score = _score; // Update score in array
                    break; // Exit loop once updated
                }
            }
        }

        sortLeaderboard(); // Keep the leaderboard sorted after every update
    }

    // Returns the full leaderboard
    function viewleaders() external view returns (player[] memory) {
        return leaderboard;
    }

    // Returns the rank of a player (1-based index)
    function getrank(address _addressofplayer) external view returns (uint) {
        for (uint i = 0; i < leaderboard.length; i++) {
            if (leaderboard[i].addr == _addressofplayer) {
                return i + 1; // Index + 1 = Rank
            }
        }
        return 0; // Player not found on the leaderboard
    }

    // Sorts the leaderboard in descending order of score using bubble sort
    function sortLeaderboard() internal {
        uint n = leaderboard.length;
        for (uint i = 0; i < n; i++) {
            for (uint j = 0; j < n - i - 1; j++) {
                if (leaderboard[j].score < leaderboard[j + 1].score) {
                    player memory temp = leaderboard[j];
                    leaderboard[j] = leaderboard[j + 1];
                    leaderboard[j + 1] = temp;
                }
            }
        }
    }
}
