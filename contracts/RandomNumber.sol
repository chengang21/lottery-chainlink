//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract RandomNumber is VRFConsumerBase {
    // using Counters for Counters.Counter;
    // Counters.Counter private _nonce;

    bytes32 immutable internal keyHash;
    uint256 immutable internal fee;

    bytes32[] public requestIDs;
    mapping(bytes32 => uint256) public randomResults;

    constructor() VRFConsumerBase(
        0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
        0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // LINK Token
    )
    {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18; // 0.1 LINK (Varies by network)
    }

    /**
     * Requests randomness
     */
    function requestRandomNumber() public returns (uint seq) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        seq = requestIDs.length;
        requestIDs.push(requestRandomness(keyHash, fee));
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResults[requestId] = randomness;
    }

    function getRandomResult(uint _seq) public view returns (uint randomNumber) {
        randomNumber = randomResults[requestIDs[_seq]];
    }
}
