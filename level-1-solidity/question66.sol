// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract RetrieveData {

    struct UserRecord {
        string userdata;
        bytes32 userHash;
    }

    mapping(address => UserRecord) private userInfo;
    mapping(address => bool) private register;
    mapping(address => bool) private verify;

    // Store user data + hash
    function storeData(string memory _data, string memory _secret) external {
        bytes32 hash = keccak256(abi.encode(msg.sender, _data, _secret));
        userInfo[msg.sender].userHash = hash;
        userInfo[msg.sender].userdata = _data;
        register[msg.sender] = true;
    }

    // Verify user data
    function verifyData(string memory _data, string memory _salt) external {
        require(register[msg.sender], "Not a registered user");
        bytes32 hash = keccak256(abi.encode(msg.sender, _data, _salt));
        if(hash == userInfo[msg.sender].userHash){
            verify[msg.sender] = true;
        }
    }

    // Retrieve data after verification
    function retrieveData() external view returns(string memory) {
        require(verify[msg.sender], "Your hash is not matched");
        return userInfo[msg.sender].userdata;
    }
}
