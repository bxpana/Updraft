// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// Solidity is copying and pasting the code from the import to the top of the contract
// import "./SimpleStorage.sol";

// It's better to use name importing instead so you can be specific about which part of a contract you want to import
import {SimpleStorage} from "./SimpleStorage.sol";
/*
You can also import multiple contracts
import {SimpleStorage, SimpleStorage2} from "./SimpleStorage.sol";
*/

contract StorageFactory{ 

    // Solidity is case sensitive
    //SimpleStorage public simpleStorage;     // call createSimpleStorageContract, it deploys a new SimpleStorage contract, but then overwrite it in simpleStorage
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {                 // Creates new SimpleStorage contract from the SimpleStorage.sol import
        SimpleStorage newSimpleStorageContract = new SimpleStorage();   
        listOfSimpleStorageContracts.push(newSimpleStorageContract); // pushes to the dynamic array listOfSimpleStorageContracts
    }
    
    function sfStore(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {         // stores a new number in one of the simple storage contracts using the index
        // Address
        // ABI - Application Binary Interface, tells the code how it can interact with another contract
        listOfSimpleStorageContracts[_simpleStorageIndex].store(_newSimpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){           // we can read the number that we stored in contract by the index
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();        // .retrieve is calling retrieve funcion on whatever is in front of it
    }
}
