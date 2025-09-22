pragma solidity  ^0.8.16;
  contract wihtdrawN {
    mapping(address => uint) private Depositamount;
    mapping(address => bool) private ThusDeposit;
    mapping(address => uint) private DepositDuration;
    mapping(address => uint) private AvailableBalance;

     function deposit(uint256 _Duration) external payable {
      require(msg.value => 0.01 ether," Not suffiecient amount to deposit");
      DepositAmount[msg.sender] = msg.value;
      ThusDeposit[msg.sender] = true;
      DepositDuration[msg.sender] = block.timestamp + _Duration;
    }
   function withdraw(uint256 _amount) external payable {
    require(ThusDeposit[msg.sender], "No deposit found");
    require(_amount <= DepositAmount[msg.sender], "Insufficient balance");
    require(block.timestamp >= DepositDuration[msg.sender], "Lock period not over");

    // Effects
    DepositAmount[msg.sender] -= _amount;
    uint available = DepositAmount[msg.sender];
    AvailableBalance[msg.sender] = available;

    // Interactions
    (bool ok, ) = msg.sender.call{ value: _amount }("");
    require(ok, "Transfer failed");
}
  }