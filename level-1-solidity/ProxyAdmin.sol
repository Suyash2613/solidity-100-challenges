
pragma solidity ^0.8.16 ;
  interface ITrasnparentUpgradeableProxy {
    function upgradeTo(address newImplementation) external;
    function changeAdmin(address newAdmin) external;
  }

 contrcat ProxyAdmin {
    address private owner;

  constructor(){
    owner = msg.sender;
  }  
  modifier onlyowner(){
    require(msg.sender == owner,"Not the owner");
    _;
  }
  function upgrade(address proxy, address NewLogicContract) external onlyowner {
     ITrasnparentUpgradeableProxy(proxy).upgradeTo(NewLogicContract);
  }
    function changeProxyAdmin(address proxy, address newAdmin) external onlyOwner {
        ITransparentUpgradeableProxy(proxy).changeAdmin(newAdmin);
    }
 } 
 /*
1. Logic Contract (Implementation Contract)
2. Proxy Contract (TransparentUpgradeableProxy)
3. ProxyAdmin Contract
4. Upgrade Process
5. Important Points
6. Code Example (Simplified)
7. Summary in One Line

 

 */
