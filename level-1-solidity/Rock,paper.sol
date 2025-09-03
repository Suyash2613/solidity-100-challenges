// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract RockPaperScissors {
    enum Move { None, Rock, Paper, Scissors }
    enum GameState { WaitingForPlayers, CommitPhase, RevealPhase, Finished }

    event MoveRevealed(address indexed player, Move move);
    event WinnerDecided(address winner);

    address public winner;
    uint256 public stake;
    uint256 public commitDeadline;
    uint256 public revealDeadline;
    GameState public gameState;

    struct Player {
        address addr;
        bytes32 commitment; 
        bool hasCommitted;
        bool hasRevealed;
        Move move;
    }

    Player[2] public players;
    mapping(address => bool) public joined;

    constructor(uint256 _stake, uint256 _commitTime, uint256 _revealTime) {
        stake = _stake;
        commitDeadline = block.timestamp + _commitTime;
        revealDeadline = commitDeadline + _revealTime;
        gameState = GameState.WaitingForPlayers;
    }

    function joinGame() external payable {
        require(msg.value == stake, "Wrong stake");
        require(gameState == GameState.WaitingForPlayers, "Not join phase");

        if (players[0].addr == address(0)) {
            players[0].addr = msg.sender;
            joined[msg.sender] = true;
        } else if (players[1].addr == address(0)) {
            players[1].addr = msg.sender;
            joined[msg.sender] = true;
            gameState = GameState.CommitPhase;
        } else {
            revert("Game full");
        }
    }

    // Player submits commitment (off-chain precomputed hash)
    function commitMove(bytes32 _commitment) external {
        require(gameState == GameState.CommitPhase, "Not commit phase");
        require(block.timestamp <= commitDeadline, "Commit phase ended");

        for (uint i = 0; i < 2; i++) {
            if (players[i].addr == msg.sender) {
                require(!players[i].hasCommitted, "Already committed");
                players[i].commitment = _commitment;
                players[i].hasCommitted = true;
            }
        }

        if (players[0].hasCommitted && players[1].hasCommitted) {
            gameState = GameState.RevealPhase;
        }
    }

    function revealMove(Move _move, string memory _salt) external {
        require(gameState == GameState.RevealPhase, "Not reveal phase");
        require(block.timestamp <= revealDeadline, "Reveal time over");

        for (uint i = 0; i < 2; i++) {
            if (players[i].addr == msg.sender) {
                require(players[i].hasCommitted, "No commit");
                require(!players[i].hasRevealed, "Already revealed");

                bytes32 checkHash = keccak256(abi.encodePacked(_move, _salt));
                require(players[i].commitment == checkHash, "Hash mismatch");

                players[i].move = _move;
                players[i].hasRevealed = true;

                emit MoveRevealed(msg.sender, _move);

                if (players[0].hasRevealed && players[1].hasRevealed) {
                    decideWinner();
                }
            }
        }
    }

    function decideWinner() internal {
        require(gameState == GameState.RevealPhase, "Not in reveal phase");

        Move m1 = players[0].move;
        Move m2 = players[1].move;

        if (m1 == m2) {
            winner = address(0); // draw
        } else if (
            (m1 == Move.Rock && m2 == Move.Scissors) ||
            (m1 == Move.Paper && m2 == Move.Rock) ||
            (m1 == Move.Scissors && m2 == Move.Paper)
        ) {
            winner = players[0].addr;
        } else {
            winner = players[1].addr;
        }

        gameState = GameState.Finished;
        emit WinnerDecided(winner);
    }

    function getWinner() external view returns (address) {
        require(gameState == GameState.Finished, "Game not over yet");
        return winner;
    }
}
