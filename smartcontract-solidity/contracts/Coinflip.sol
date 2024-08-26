// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CoinFlip {
    address public owner;

    event BetPlaced(address indexed player, uint256 amount, bool isHeads);
    event CoinFlipped(address indexed player, bool outcome, uint256 payout);

    constructor() {
        owner = msg.sender;
    }

    // Modifier to ensure only the contract owner can perform certain actions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    // Function to place a bet
    function placeBet(bool isHeads) public payable {
        require(msg.value > 0, "Bet amount must be greater than zero.");
        
        // Emit event that a bet has been placed
        emit BetPlaced(msg.sender, msg.value, isHeads);
        
        // Flip the coin
        flipCoin(isHeads, msg.value);
    }

    // Internal function to flip the coin
    function flipCoin(bool isHeads, uint256 betAmount) internal {
        // Generate a pseudo-random outcome
        bool outcome = block.timestamp % 2 == 0;

        uint256 payout = 0;
        if (outcome == isHeads) {
            payout = betAmount * 2;
            payable(msg.sender).transfer(payout); // Send the payout to the player
        }

        // Emit event with the outcome
        emit CoinFlipped(msg.sender, outcome, payout);
    }

    // Function to withdraw the contract's balance
    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance.");
        payable(owner).transfer(amount);
    }

    // Fallback function to accept ether
    receive() external payable {}
}