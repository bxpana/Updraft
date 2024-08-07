// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        vm.startBroadcast();
        SimpleStorage simpleStorage = new SimpleStorage(); //SimpleStorage == contract. simpleStorage == variable  // sends a txn to create a new SimpleStorage contract
        vm.stopBroadcast(); // everything between vm.start and vm.stop broadcast are what will be sent
        return simpleStorage;
    }
}
