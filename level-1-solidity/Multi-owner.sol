// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract multiowner {
    address[] public owners;
    mapping(address => bool) public helloOwners;

    constructor(address[] memory _owner) {
        require(_owner.length > 0, "No owner addr");

        for (uint i = 0; i < _owner.length; i++) {
            require(_owner[i] != address(0), "Invalid address of owner which passing");
            owners.push(_owner[i]);
            helloOwners[_owner[i]] = true;
        }
    }

    modifier onlyowner() {
        require(helloOwners[msg.sender], "Not an owner");
        _;
    }

    function addOwner(address newOwner) external onlyowner {
        require(newOwner != address(0), "Invalid address");
        require(!helloOwners[newOwner], "Already an Owner");

        helloOwners[newOwner] = true;
        owners.push(newOwner);
    }

    function getOwners() external view returns(address[] memory) {
        return owners;
    }
}
