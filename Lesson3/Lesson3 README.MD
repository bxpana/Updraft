# Things we've covered

## Deploying contracts using `new` keyword
- deploy contracts from other contract using `new`

## Importing from other contracts
- `import "./myOtherContract.sol";`

## Named Imports
- name the contract being imported to be more ogranized
 - `import { Contract as MyContract } from "./myOtherContract.sol";`

 ## Interacting with contracts
- interact with other contracts as long as we have the ABI and contract's address
 
 ## Contract Inheritance
- Can create a "child" contract that inherits the features of another contract. 
- Import the parent contract and use the `is` keyword
 - to override a function of the parent contract you use the `override` keyword in the child contract and need to use the `virtual` keyword on the function in the parent contract
  - see SimpleStorage.sol and AddFiveStorage.sol store function for example