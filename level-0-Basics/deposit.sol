pragma solidity ^0.8.16;
 contract BankDeposit{
    


    mapping(address => uint256) public sent;

  function deposit() external payable returns(uint256){
   require(msg.value > 0, "not send Zeo eht");
    sent[msg.sender] = sent[msg.sender] + msg.value;
    return sent[msg.sender];
  } 
  event actualbalance( uint256 indexed _availableBalance, uint256 indexed _withdrawAmount);

 function withdraw(uint256 _amount) public returns(uint256){
  require(sent[msg.sender] >0, "not uch balance you have");
  sent[msg.sender] = sent[msg.sender] - _amount;
 
  payable(msg.sender).transfer(_amount);
   emit actualbalnce(sent[msg.sender] , _amount);
  return sent[msg.sender]
 }
