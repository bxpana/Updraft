// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig(); // deploy this before we broadcast so we don't have to spend gas on it
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        // Before startBroadcast -> not a real tx, gets simulated in an environment
        // After startBroadcast -> read tx
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
/*
	•	👆 This version deploys the FundMe contract but also assigns the deployed contract instance to the variable fundMe.
	•	FundMe fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306); deploys the contract and stores the address of the deployed contract in fundMe.
	•	The function then returns the fundMe instance.
        	•	Returning fundMe allows you to easily reference the deployed contract instance after the script completes.


# First version of deploy - simple version that does not take constructor arguments
contract DeployFundMe is Script {
    function run() external {
        vm.startBroadcast();
        new FundMe();
        vm.stopBroadcast();
    }
}
*/
