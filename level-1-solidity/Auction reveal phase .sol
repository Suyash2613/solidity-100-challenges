
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract RevealAuction {
    struct BidInfo {
        uint amount;
        bytes32 hashValue;
    }

    address public owner;
    address public sellerAddress;
    uint public highestBid;
    address public highestBidder;

    uint256 public biddingEnd;
    uint256 public revealEnd;
    bool public ended;

    mapping(address => BidInfo[]) public bids;

    constructor(
        uint _biddingDuration,
        uint _revealDuration,
        address _sellerAddress
    ) {
        owner = msg.sender;
        sellerAddress = _sellerAddress;
        biddingEnd = block.timestamp + _biddingDuration;
        revealEnd = biddingEnd + _revealDuration;
    }

    // Generate hash from amount and secret
    function generateBlindedBid(uint _amount, string memory _secret) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_amount, _secret));
    }

    // Commit a blinded bid
    function bid(bytes32 _blindedBid) external payable {
        require(block.timestamp < biddingEnd, "Bidding has ended");
        bids[msg.sender].push(BidInfo({
            amount: msg.value,
            hashValue: _blindedBid
        }));
    }

    // Reveal your committed bid(s)
    function reveal(uint[] calldata _amounts, string[] calldata _secrets) external {
        require(block.timestamp > biddingEnd, "Reveal phase not started");
        require(block.timestamp < revealEnd, "Reveal phase ended");

        BidInfo[] storage userBids = bids[msg.sender];
        require(_amounts.length == userBids.length, "Mismatch in number of bids");

        uint refund;

        for (uint i = 0; i < userBids.length; i++) {
            BidInfo storage bidInfo = userBids[i];
            bytes32 expectedHash = keccak256(abi.encodePacked(_amounts[i], _secrets[i]));

            if (expectedHash != bidInfo.hashValue) {
                continue; // invalid reveal, skip
            }

            // valid reveal
            if (_amounts[i] > highestBid) {
                if (highestBidder != address(0)) {
                    payable(highestBidder).transfer(highestBid);
                }

                highestBid = _amounts[i];
                highestBidder = msg.sender;
                // seller gets the new highest bid immediately
                payable(sellerAddress).transfer(_amounts[i]);
            } else {
                // Not highest — refund immediately
                refund += _amounts[i];
            }

            bidInfo.hashValue = bytes32(0); // prevent reuse
        }

        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
    }
}
