
pargma solidity ^0.8.16;
 contract Staking {
    
    struct stake {
      uint256 amount ;
      uint256 Staketime ;
      bool claim;
    }
  mapping(address => stake) public userStake;
    uint256 public constant Duration = 30 ;

     event InfoOfStaked(address indexed user , uint256 amount, uint256 UTCtimestamp);

  function stake() external payable {
    require(msg.value > 0.1," Not sufficient Amount to stake ");
    require(stake[msg.sender] == 0 ,"already staked");

   userStake[msg.sender] = stake ({
    amount : msg.value,
    staketime : block.timestamp,
    clam : false 
    )};

   emit InfoOfStaked(msg.sender ,msg.value, block.timestamp);
 }
