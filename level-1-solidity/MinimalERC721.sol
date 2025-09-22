// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MinimalRoyaltyNFT {
    string public name;
    string public symbol;
    uint256 public royaltyPercent;
    address public creator;

    // Mapping from tokenId to owner
    mapping(uint256 => address) public ownerOf;
    // Mapping from owner to number of tokens
    mapping(address => uint256) public balanceOf;

    // Event for transfers
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    // Constructor
    constructor(string memory _name, string memory _symbol, uint256 _royaltyPercent) {
        name = _name;
        symbol = _symbol;
        royaltyPercent = _royaltyPercent;
        creator = msg.sender;             
    }

    // Mint a new NFT
    function mint(uint256 tokenId, address to) external {
        require(msg.sender == creator, "Only creator can mint");
        require(ownerOf[tokenId] == address(0), "Token already minted");

        ownerOf[tokenId] = to;
        balanceOf[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    // Transfer NFT with royalty
    function transfer(uint256 tokenId, address to) external payable {
        address from = ownerOf[tokenId];
        require(from == msg.sender, "Only owner can transfer");
        require(to != address(0), "Cannot transfer to zero address");

        // Calculate royalty
        uint256 royaltyAmount = (msg.value * royaltyPercent) / 100;
        require(royaltyAmount > 0, "Royalty must be > 0");

        // Send royalty to creator
        (bool sent, ) = payable(creator).call{value: royaltyAmount}("");
        require(sent, "Royalty transfer failed");

        // Transfer ownership
        ownerOf[tokenId] = to;
        balanceOf[from] -= 1;
        balanceOf[to] += 1;

        emit Transfer(from, to, tokenId);
    }

    // Allow contract to receive ETH
    receive() external payable {}
}
