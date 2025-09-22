pragma solidity^0.8.16;

 contract emergencyStop {
    bool public paused;
    address public owner;

modifier onlyowner(){
    require(owner == msg.sender,"Not the owner");
    _;
}  

modifier pausedfunction() {
    require(!pauded,"function is paused");
    _;
 }

function emergencyFunctionStop() onlyowner {
    paused = true;
    
} 
function addNumber() external pure pausedfunction returns(uint256){
    uint X;
    return X+1;
}
 }