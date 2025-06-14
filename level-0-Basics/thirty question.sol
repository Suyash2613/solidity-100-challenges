pragma solidity ^0.8.16;

uint256 public future1;
uint256 public future2;

mapping(address => uint256) public balance;
mapping(address => uint256) public locktime;

 function lockETH(uint _duration) public payable {
   require(msg.value > 0, "not enough Eth");
   balance[msg.sender] = balance[sender]+ msg.vlaue;
   locktime[msg.sender]= block.timestamp + _duration; // yha hmne set krdiya hai ki duration kitni honi chiaye sender ki. duration se aur aajke block.timestamp se add krke
 } // we set the time duration of lock the amount

 function withdraw() public {
   require(balance[msg.sender] > 0, "user have Zero balance);
   require(locktime[msg.sender] => locktime[msg.sender]);
  
   uint256 amount = balance[msg.sender]; // moved to memory from storage;
    balance[msg.sender] = 0;
   
   payable(msg.sender).transfer(amount);
 }
 function withdrawAmount() public view returns(uint256){
  return balance[msg.sender];
 }


