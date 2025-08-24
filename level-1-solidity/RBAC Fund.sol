// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

 contract RoleBasedFund{
    enum Role {None, Admin, User, Viewer}
  
  mapping(address => Role) public role;
  mapping (address => uint256) public balances;

 constructor(){
    role[msg.sender] = Role.Admin;
 }
  modifier onlyAdmin(){
    require(role[msg.sender] == Role.Admin,"Not admin");
    _;
  }
  modifier onlyUser(){
    require(role[msg.sender] == Role.User,"Not User");
    _;
  } 
  modifier onlyViewer(){
    require(role[msg.sender] == Role.Viewer,"Not viewer");
    _;
  }
 function AssignRole(address _addr, Role _role) external onlyAdmin{
    role[_addr] = _role ;
 }
 function adminDeposit(address _useraddr, uint256 _amount) external payable onlyAdmin{
    balances[_useraddr] += _amount;
 }
 function userdeposit() external payable onlyUser{
   balances[msg.sender] += msg.value;
 }
 function userWithdraw(uint256 _amount) external payable onlyUser{
    require(balances[msg.sender] >= _amount,"Insufficient balance");
    balances[msg.sender] -= _amount;
  
   (bool success, ) = msg.sender.call{value : _amount}("");
  require(success,"Not transfer");
 }
  
    function viewBalance(address _account) external view onlyViewer returns (uint256) {
        return balances[_account];
    }

    function myRole() external view returns (Role) {
        return role[msg.sender];
    }
 }
 