// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";

contract DeployProxy {
    ProxyAdmin public proxyAdmin;
    TransparentUpgradeableProxy public proxy;

    constructor(address logic, bytes memory data) {
        proxyAdmin = new ProxyAdmin();

        // Step 2: Deploy TransparentUpgradeableProxy
        proxy = new TransparentUpgradeableProxy(
            logic,               // Logic contract ka address
            address(proxyAdmin), // ProxyAdmin contract ko hi admin banaya
            data                 // Initialization data (abi.encodeWithSignature)
        );
    }
}
 // ProxyAdmin public admin; 
  // contract type, ek deployed ProxyAdmin ka address store karega
  // TransparentUpgradeableProxy ek special tyoe ka upgrade contract ka address save krne ke liye
  // bna rhe hai hum joki jis contrcat me upgrade krke call fowrward kr rhe hai delegatecall ko use krke usko store krta hai 