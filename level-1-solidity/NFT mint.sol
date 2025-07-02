
// SPDX-License-Identifier: MIT
 pragma solidity ^0.6.18;
  
  contract NFTMint {
    address public owner;

    mapping(uint256 => address) public trackAddr;

    constructor public(){
        owner = msg.sender;
    }
    modifier onlyowner(){
        require( owner == msg.sender);
        _;
    }
    function mint( address addr , uint256 Token) external onlyowner {
        require( addr != address(0), "Not valid address null");
        require(trackAddr[Token] == address(0),"already get Token");
 
      trackAddr[Token] = addr ;
    }
    function tokenOwner(uint token) external view returns(address){
        require(trackAddr[token] != address(0), " Token Not minted yet");
        address addrofOwner = trackAddr[token];

        return addrofOwner;
    }
  }
