// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title A sample raffle contract
 * @author bxpana
 * @notice This contract is used to create a sample raffle
 * @dev Implements Chainlink VRFv2.5
 */
contract Raffle {
    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable{
        // Enter the raffle
    }

    function pickWinner() public {}

    /**Getter Functions */
    function getEntranceFee() external view returns(uint256) {
        return i_entranceFee;
    }    
}