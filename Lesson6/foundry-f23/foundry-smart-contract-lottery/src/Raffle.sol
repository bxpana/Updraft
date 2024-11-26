// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title A sample raffle contract
 * @author bxpana
 * @notice This contract is used to create a sample raffle
 * @dev Implements Chainlink VRFv2.5
 */
contract Raffle {
    /*Errors */
    error Raffle__NotEnoughEthToEnterRaffle();

    uint256 private immutable i_entranceFee;
    // @dev The duration of the lottery in seconds
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    /** Events */
    event RaffleEnter(address indexed player);

    constructor(uint256 entranceFee, uint256 interval) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable{
        // require(msg.value >= i_entranceFee, "Not enough ETH to enter the
        // raffle");
        // require(msg.value >= i_entranceFee, NotEnoughEthToEnterRaffle());
        if(msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthToEnterRaffle();
        }
        s_players.push(payable(msg.sender));
        emit RaffleEnter(msg.sender);
    }

    // 1. Pick a random winner
    // 2. Use randon number to select a winner
    // 3. Be automatically called
    function pickWinner() external {
        // check to see if enough time has passed
        if((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert();
        }
        // Get a random number from Chainlink VRF 2.5
    }

    /**Getter Functions */
    function getEntranceFee() external view returns(uint256) {
        return i_entranceFee;
    }    
}