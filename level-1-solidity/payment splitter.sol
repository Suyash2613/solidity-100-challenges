pragma solidity^0.8.16;
 contract paymentSplitter{

    address public Admin;
    address[] public userlist;

    mapping(address => uint256) public UserReceived;
    mapping(address => uint256) public Usershares;
    mapping(address => bool) public resgiterUser;

 constructor(){
    Admin = msg.sender;
 }
  modifier onlyaAdmin(){
    require(msg.sender == Admin,"Not the Admin");
    _;
  }
 function adduser(address _addr, uint256 _shares) external onlyAdmin {
    Usershares[_addr] += _shares;
    userlist.push(_addr);
    registerUser[_addr] = true;
 } 
 recieve() external payable { }

function claimPayment() external {
    require(registerUser[msg.sender], "You aren't a registered user");

    uint256 totalBalance = address(this).balance;
    uint256 share = Usershares[msg.sender];
    uint256 received = UserReceived[msg.sender];

    uint256 payment = ((share * totalBalance) / 100) - received;
    require(payment > 0, "Nothing to claim");

    //  Effects
    UserReceived[msg.sender] += payment;

    //  Interactions
    (bool ok, ) = payable(msg.sender).call{value: payment}("");
    require(ok, "Transaction failed");
}

 }
  