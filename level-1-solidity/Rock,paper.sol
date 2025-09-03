// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;
 
  contract RockpaperScissors{
    enum Move{rock, paper, scissors}
    enum GameState{commitPhase, revealPhase, ended, waitingForplayers}

    struct Players{
    address addr;
    bytes32 commitment; // player commitment move + seceret phrases
    bool hascommitted;
    bool hasReavealed;
    Move move;
  }

  Players[2] public players;
  uint256 CommitDeadline;
  uint256 RevealDeadline;
  uint256 stake;
  GameState public gamestate; // yha pe iska type GameState hi type ka hai  kyuki ye yhi hi value hi store krgea
 
 mapping(address => bool) public JoinList;
 constructor(uint256 _stake, uint256 _commitDeadline, uint256 _revealDeadline){
    stake = _stake;
    CommitDeadline = block.timestamp + _commitDeadline;
    RevealDeadline = block.timestamp + _revealdeadline;
    gamestate = GameState.waitingForplayers;
  }
 // join game only for two players of array players

 function joinGame() external payable{

  require(msg.value == stake,"Insufficient amount of stake");
  require(GameState.waitinfForplayers,"Can't join right now");

// yha bht hi dimaak lga ke ye kr diya gya hai ki agr players[0] index wala blank hai to usme address daal do msg.sender ka .
// aur agr players[1] ka ye address khali hai to dusra player ye daal do msg.sender k address , isi liye check kra ahi ki addrss(0) zero ho blank 

   if(players[0].addr == address(0)) {
    players[0].addr == msg.sender;
    Joinlist[] = true;
   } else if (players[1].addr == address(0)) {
    players[1].addr == msg.sender;
    gamestate = GameState.commitPhase;
   }  else {
    revert("Game full");
   }
 } 
 
 // Commit =hash(keccak256(abi.encodePacked(move, salt)))
function commitMove(bytes _commitment) external {
  require(gamestate == GameState.commitPhase,"Can't commit right now ");
  require(block.timestamp <= CommitDeadline,"Can't commit right now");

   for(uint i= 0, i<2, i++){
    if(players[i].addr == msg.sender){
      require(!players[i].hascommited,"Already commited");
      players[i].commitment = _commitment;
      players[i].hascommitted = true;
    }

   // jaise if ke and rhota tha ki automatic true ke liye check krta hai bool waise hi if ke liye hai ye flag
    if(players[0].hascommited && players[1].hascommited){
      gamestate = GameState.revealPhase ;
    }
  }

// function reveal krne ka bnayenge is baar ye real me contract me hi move dega apna aur sath me seceret phase dega aur match krenge ki paihle wale commitment se is baar ka hash same hai ya nhi

 function revealMove(Move _move, string memmory _phrase) external {
  require(block.timestamp <= RevealDeadline,"Can't reveal right now");
  require(gamestate == GameState.revealPhase,"Reveal phase is over");

   for(uint i=0, i <2 , i++){
    if (players[i].addr == msg.sender){

  // bnde ne commit kr rkha ho aisa na ho ki commit hi nhi kra hai usne   
      require(players[i].hascommitted,"Haven't commited");

  // bnde ne paihle hi reveal na kr rkha ho 
      require(!players[i].hasRevealed,"Already revealed");

 bytes32 checkHash = keccak256(abi.encodedPacked(_move, _phrase));
 require(players[i].commitment == checkHash,"Hash not matched with commitement Hash");
   
   players[i].move = _move;
   players[i].hasRevealed = true;
   
    }
   }
 }

  }

