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
    address payable[] private s_players;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable{
        // require(msg.value >= i_entranceFee, "Not enough ETH to enter the
        // raffle");
        // require(msg.value >= i_entranceFee, NotEnoughEthToEnterRaffle());
        if(msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthToEnterRaffle();
        }
        
    }

    function pickWinner() public {}

    /**Getter Functions */
    function getEntranceFee() external view returns(uint256) {
        return i_entranceFee;
    }    
}