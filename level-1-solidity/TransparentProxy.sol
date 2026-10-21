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
            logic,               
            address(proxyAdmin), 
            data                
        );
    }
}
 
