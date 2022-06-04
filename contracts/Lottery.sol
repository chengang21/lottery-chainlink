//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract Lottery is VRFConsumerBase {
    address public owner;
    address[] public players;
    address[] public lotteryHistory;

    bytes32 immutable internal keyHash;
    uint256 immutable internal fee;

    constructor() VRFConsumerBase (
        0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
        0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // LINK Token
    )
    {
        owner = msg.sender;
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18; // 0.1 LINK (Varies by network)

        lotteryHistory.push(address(0)); // placeholder number 0
    }

    function getWinnerByLottery(uint lottery) public view returns (address){
        return lotteryHistory[lottery];
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    function getPlays() public view returns (address[] memory){
        return players;
    }

    function enter() external payable {
        require (msg.value > .01 ether, "insufficient msg.value");
        players.push(payable(msg.sender));
    }

    //    function getRandomNumber() public view returns (uint){
    //        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    //    }

    // Requests randomness
    function pickWinner() public onlyOwner {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 /* requestId */, uint256 randomness) internal override {
        payWinner(randomness);
    }

    function payWinner( uint256 randomness ) internal {
        uint index = randomness % players.length;
        payable(players[index]).transfer(address(this).balance);
        lotteryHistory.push(players[index]);
        players = new address[](0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only-Owner");
        _;
    }
}
