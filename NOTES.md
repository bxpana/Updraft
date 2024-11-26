# Solidity Smart Contract Development

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

# Foundry Fundamentals

## Foundry Simple Storage

- When using `forge script` if there is no RPC URL it will spin up a temporary Anvil to deploy the contract

- `cast --to-base <hex> dec` will convert hex into decimal
  - `cast --help` shows other conversions and tools you can use with cast

### DO NOT DO THIS WITH PRODUCTION CODE

- .env file make sure is listed in `.gitignore`
  - after make to `source .env` to make sure it grabs from .env file
        - can use `echo $<.env_VARIABLE>` to make sure it's getting it
    - can add .env variable to use with terminal command with `$<.env_VARIABLE>`

---

- For real money you'll use `--interactive` or a keystoree file with a password
- With `cast` you can do `cast wallet import defaultKey --interactive` to create your keystore with a password
- `cast wallet list` shows full lists of keystore wallets
  - `--password-file` could be used too to make it faster instead of having to put in your password that would come from something like a `.password` file
  - make sure to add `.password` file to `.gitignore`
  - Can also create a `ETH_PASSWORD` variable in a .env and use `--password $ETH_PASSWORD` instead of putting in your password everytime

### Terminal shortcuts

- View history with `history`
- clear history with `history -c`
- clear terminal with `clear`
- delete a word [ctrl] + W
- clear to the beginning [ctrl] + U
- `rm .bash_history` to clear command line history

---

- You can see your "runs" in the `broadcast` folder under the contract name and the chain ID
  - give you details about the txn
  - `run-latest.json` will always be the latest run

- `forge fmt` formats the smart contracts
- `foundryup` to spin up "vanilla" Foundry
  - `foundryup-zksync` to spin up ZKsync Foundry

### ZKsync Node <> Foundry

- use `forge create` over `forge script` for now
- `npx zksync-cli dev config` starts CLI with setting up era test node with a block explorer or a portal
  - make sure to use the space bar to select the portal or block explorer with the era test node

### Tx Types

- `--legacy` flag sends transaction as `0x0` (pre-EIP1559 and before an intro of typed-txns)
  - ZKsync: [https://docs.zksync.io/zk-stack/concepts/transaction-lifecycle#transaction-types](https://docs.zksync.io/zk-stack/concepts/transaction-lifecycle#transaction-types)
  - Ethereum.org: [https://ethereum.org/en/developers/docs/transactions/#typed-transaction-envelope](https://ethereum.org/en/developers/docs/transactions/#typed-transaction-envelope)

### Recap

- `forge --init` will create project and give all the folders for Foundry
- `forge`: compiling and interacting with contracts
- `cast`: interacting with contracts that have already been deployed
  - `cast send` to send txns
  - `cast call` to read from contracts
- `anvil`: deploy a local blockchain
- When you send a txn, you're making an HTTP Post request to the RPC URL

## Foundry Fund Me

- `forge install <name_of_org/name_of_repo>`
  - you can also put the full Github repo URL in as well and it will work
- create a remapping to tell Foundry where to find the import in the `lib` folder
  - `foundry.toml` add `remappings = ["<file you want Foundry to remap>=lib<file you want to map to in lib>"]`
- `forge build` will compile your project
- When naming errors, start with contract name and then `__` (double underscores) so you can tell what contract the error came from

---

### Tests

- importing from `forge-std/Test.sol` gives you the `assert` function
- `setUp` is always ran before `testDemo` which is why the test below passes

  ```solidity
  contract FundMeTest is Test {
      uint256 number = 1;

      function setUp() external {
          number = 2;
      }    // setUp will always run first even if there is code before it

      function testDemo() public {
          assertEq(number, 2);
      }
  }
  ```

- Console Logging `console.log()`
  - can get things printed out from our tests
  - make sure to import from `forge-std/Test.sol`

  ```solidity
  import {Test, console} from "forge-std/Test.sol";
  ```

- `forge test -vv`
  - `-v` is the level of logs shown from `-v` to `-vvvvv`
  - more "v" the more detailed the logs
      - `-vv` will show `console.log()`s
- `import {FundMe} from "../src/FundMe.sol";`
  - `..` stands for going down a directory

- when testing, we can test functions or variables that are public functions in the OG smart contract
  - make test names very verbose so you know exactly what is being tested
    - `function testMinimumDollarIsFive() public {}` instead of `function testDemo() public {}`

- the line `FundMe fundMe;` is necessary because it declares a state variable that allows you to access the `FundMe` contract instance throughout the contract's functions.

  ```solidity
  contract FundMeTest is Test {
    FundMe fundMe;                  // declares state variable of type FundMe so that it's accessible by all functions within the FundMeTest contract

    function setUp() external {
        fundMe = new FundMe(); // "fundMe" variable of type "FundMe" is going to be a new FundMe contract
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18); // to call this we need access to "fundMe"
    }
  }
  ```

1. **State Variable**:
   - `FundMe fundMe;` This declares a state variable named `fundMe` of type `FundMe`. It tells the Solidity compiler that there will be a variable called `fundMe` in this contract that will hold an instance of a `FundMe` contract. This variable is accessible by all functions within the `FundMeTest` contract. State variables are stored on the blockchain and persist between function calls.
   - The line `FundMe fundMe;` is a declaration of a state variable, but it does not initialize or create an instance of the `FundMe` contract. It merely sets up a placeholder (or a reference) for a `FundMe` contract instance. Here’s why you still need `fundMe = new FundMe();`:
      - Without the `new FundMe();` line, the `fundMe` variable does not refer to any actual contract. Trying to interact with `fundMe` without initializing it would lead to errors because there is no contract instance to interact with.
      - The `new FundMe();` line effectively deploys the `FundMe` contract to the blockchain within your test environment and assigns the deployed contract’s address to the `fundMe` state variable. This deployment is necessary to test how your `FundMeTest` contract interacts with a live `FundMe` contract.

2. **Local Variable in `setUp()`**:
   - In the `setUp()` function, the line `FundMe fundMe = new FundMe();` declares a local variable `fundMe` that is scoped only to the `setUp()` function. This variable is different from the state variable `fundMe` declared at the top of the contract.
   - Since this `fundMe` variable is local to `setUp()`, it is destroyed after `setUp()` completes, meaning you cannot access it in other functions like `testMinimumDollarIsFive()`.

3. **State vs. Local Variables**:
   - **State Variable (`FundMe fundMe;`)**: This is accessible throughout the contract and retains its value across different function calls. When you create the contract instance in `setUp()` and assign it to this state variable, you can access it in any test function.
   - **Local Variable (`FundMe fundMe = new FundMe();`)**: This is only accessible within the `setUp()` function. Once `setUp()` completes, this variable is no longer accessible, which is why `testMinimumDollarIsFive()` cannot access the `fundMe` instance created in `setUp()` unless it was assigned to the state variable.

- `fundMe.MINIMUM_USD()`
  - You can access `fundMe.MINIMUM_USD()` because `MINIMUM_USD` is a public state variable or constant in the `FundMe` contract. Solidity automatically generates a getter function for any public variable, allowing you to access its value through this function.

- `address(this)` gets the Ethereum address of that contract instance
- `msg.sender` is the address that called the current function

> can use `console.log()` for both of these to find out which addresses they are

### Advanced Deploy Scripts

> [Example](foundry-f23/foundry-fund-me-f23/script/DeployFundMe.s.sol)

```
vm.startBroadcast();
  ...
v,.stopBroadcast();
```

- tells foundry to start deploy and when to finis the deployment

- `forge clean` will clear the cache of your Foundry files which deletes Build Artificats and removes Cache Files

### More Tests

-  `forge test --mt <test_function>` allows you to test one specific test in your test file
  - if you don't state which network it will test on an anvil one and close it after
- `forge coverage --<fork-url or rpc_url> <URL>` shows how many lines of code are actually tested
  - want this to be in higher % of tested lines (maximize your tests)

#### Unit

- testing a specific part of your code
  - example (also includes integration because we're checking the version from another contract):
    ```solidity
    function testPriceFeedVersionIsAccurate() public {
          uint256 version = fundMe.getVersion();
          console.log(version);
          assertEq(version, 4);
      }
    ```

#### Integration

- testing how your code works with other parts of your code

#### Forked

- testing your code on a simulated real environment
- `forge test --mt testPriceFeedVersionIsAccurate -vvv --fork-url $SEPOLIA_RPC_URL`
  - spins up an anvil copy of the URL (Sepolia in the above example) and simulate all the txns without having to actually deploy
- this still makes calls to your RPC URL which could cause increased cost of RPC URL if using a third party like Alchemy
  - Why?
    - you're still making calls to the RPC URL to retrieve the latest state data for the simulations

#### Staging

- testing your code in a real environment that is not prod

## Making Contracts more Modular

- make contracts open to be able to be deployed on other networks to interact with contracts on those chains
  - not hardcoding addresses or networks
- refactor: change up the code architecture but not the functionality. Keeps code maintainable moving forward

> - variables before the constructor are state variables and remain persistent throughout the lifetime of the contract
> - variables inside the constructor are executed only once at the time of contract deployment
>   - can set `immutable` variables here since it consumes less gas than setting as state variable

- Example
  - instead of hard coded address for `AggregatorV3Interface` we can add a variable to the constructor that will setup an instance of the `Aggregator V3Interface` stored in `s_priceFeed` based on the address passed at deployment (the address for the contract on the chain)

    ```solidity
      contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address public /* immutable */ i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    AggregatorV3Interface private s_priceFeed;  // <--

    constructor(address priceFeed) {  // <--
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed); // <--
    }
    ```

    - Checkout [`PriceConverter.sol`](foundry-f23/foundry-fund-me-f23/src/PriceConverter.sol) for changes to make more modular too

- How to make changes to deploy script without having to make changes to test too
  - Import the contract from deploy script to the test so that it will deploy the same was as in our script
    - example [`FundMeTest.t.sol`](foundry-f23/foundry-fund-me-f23/test/FundMeTest.t.sol)
    - See more notes in [`DeployFundMe.s.sol`](foundry-f23/foundry-fund-me-f23/script/DeployFundMe.s.sol)

### Deploy a mock priceFeed

- deploy a mock contract on anvil so you don't have to spend resources on infra provider (Alchemy)
  - see [`HelperConfig.s.sol`](foundry-f23/foundry-fund-me-f23/script/HelperConfig.s.sol) for examples of how to deploy a mock on anvil chain and keep track of contract addresses when connected to other chains
    - work with `structs`, `memory`, and `NetworkConfig`
    - have to import `HelperConfig` in [`DeployFundMe.s.sol`](foundry-f23/foundry-fund-me-f23/script/DeployFundMe.s.sol)
      - create variable for the price feed based on the `activeNetworkConfig` and deploy the `FundMe` contract passing the address for the priceFeed on the matching network
    - Anvil setup will be different since the mentioned contracts do not exist on Anvil
      - have to deploy them ourselves on Anvil
      1. Deploy the mocks
      2. Return the mock addresses
      - can no longer be a `pure` function since we have to use `vm.startBroadcast();` to deploy the mock contracts
        - also have to change `contract HelperConfig {` to `contract HelperConfig is Script {` so that it can have access to the `vm` keyword
      - create a `mocks` folder in `test` so that you can separate the mock contracts from the real ones
- in the AnvilEthConfig add an if statement so that it doesn't redeploy a mock priceFeed contract if there is already and address for `priceFeed`

  ```solidity
  function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // price feed address
        if (activeNetworkConfig.priceFeed != address(0)) {
            // if there was already a priceFeed address for the anvil config, don't run the rest of the code below. If priceFeed address is not 0
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        ...
  ```

#### Magic Numbers

- numbers in code that are not defined directly in the code but in another contract
  - example `8` and `2000e8` refer to the `_decimals` and `_initialAnswer` in [`MockV3Aggregator.sol`](foundry-f23/foundry-fund-me-f23/test/mocks/MockV3Aggregator.sol)

  ```solidity
  MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 2000e8);
  ```

  - can turn these into constants at the top of the contract

    ```solidity
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    ```

    - and update:

    ```solidity
      vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();
    ```

## Foundry Test Cheat Codes

- <https://book.getfoundry.sh/forge/cheatcodes>
  - Can also check out <https://book.getfoundry.sh/cheatcodes/> for looking at different cheatcode types

  [`FundMeTest.t.sol`](foundry-f23/foundry-fund-me-f23/test/FundMeTest.t.sol)

  ```solidity
  function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // the next line should revert // ignores `vm.` for example when setting a `prank` address
        fundMe.fund(); // fails because nothing is passed through the fund function which requires more than or equal to `MINIMUM_USD`
    }
  ```

> In Solidity, when you want to send Ether along with a function call, you use the {value: X} syntax inside the curly braces. This is known as a “function call option” and is used to specify additional parameters for the function call, such as the amount of Ether to send (value), the gas limit (gas), or the sender’s address (from).

[`FundMe.sol`](foundry-f23/foundry-fund-me-f23/src/FundMe.sol)

```solidity
contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) public s_addressToAmountFunded; // Keeps track of the amount of funds contributed by each address.
    address[] public s_funders; // stores the list of all addresses that have contributed funds to the contract.
...
```

- For the storage variables, start with `s_` to help make distinctive
  - default all the storage variables to `private` to make more gas efficient
    - if need public can signal that for specific ones
      - create `view` / `pure` functions or "getters" to be able to ask the private storage variables

      [`FundMe.sol`](foundry-f23/foundry-fund-me-f23/src/FundMe.sol)

      ```solidity
      function getAddressToAmountFunded(
        address fundingAddress
      )   external view returns (uint256) {
            return s_addressToAmountFunded[fundingAddress];
      }
      ```

- `prank` sets the `msg.sender` to the specified address for the next call
  - use to know who is sending the call instead of not knowing if it's `msg.sender` or `fundMe` (`address(this)`)

> Use `prank` after setting `makeAddr` see [`FundMeTest.t.sol`](foundry-f23/foundry-fund-me-f23/test/FundMeTest.t.sol)

- `makeAddr` makes a new address based on a name passed
  - added to top of [`FundMeTest.t.sol`](foundry-f23/foundry-fund-me-f23/test/FundMeTest.t.sol) so you can use it throughout the tests

    ```solidity
    address USER = makeAddr("user");
    ...
    function testFundUpdatesFundedDataStructure() public {
    vm.prank(USER);
    ...
    ```

- `vm.startPrank`/`vm.stopPrank`
  - same as `vm.startBroadcast` where you run everything within the vm
  - example:

  ```solidity
  vm.startPrank(fundMe.getOwner());
  fundMe.withdraw();
  vm.stopPrank();
  ```

- `deal` set the balance of an address
  - set a constant variable with an amount

  ```solidity
  uint256 constant STARTIN_BALANCE = 10 ether;
  ```

  - in the `setUp` function add deal with `vm`

  ```solidity
  vm.deal(USER, STARTING_BALANCE);
  ```

- `modifier` allows you to create a state that can be used in other tests so you don't have to continue to enter the same cheatcodes
  - `modifier` needs a `_;` at the end to signal where the code is executed after it. If the _ is omitted, the function body never gets executed, and only the modifier’s logic will run.
  - example:

  ```solidity
  modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }
  ````

  - add `modifier` to function in test:

  ```solidity
  function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }
  ```

> Fun fact:
>
> - (): Used to pass parameters defined in the function’s signature (e.g., uint256 amount).
> - {}: Used to pass optional transaction parameters like Ether (value), gas (gas), or sender (from), which are outside the function signature.

- `txGasPrice` sets the tx.gasprice for the rest of hte txn

### Arrange, Act, Assert

Way to think about setting up a test

1. **Arrange** the test
2. Do the **action** you want to test
3. **Assert** the test

- see `testWithdrawWithASingleFunder` function in [`FundMeTest.t.sol`](foundry-f23/foundry-fund-me-f23/test/FundMeTest.t.sol) for example of arrange, act, assert

- `hoax`
  - sets up a `prank` from an address that has some ether
    - puts `prank` and `deal` together
  - `hoax(<ADDRESS>, SEND_VALUE);`
  - when setting up addresses with `address(NUMBER)` you'll need to wrap it in a `uint160` instead of 256
    - example:

    ```solidity
    function testWithdrawFromMultipleFunders() public funded {
        uint256 numberOfFunders = 10; => uint160 numberOfFunders = 10;
        uint256 startingFunderIndex = 2; => uint160 startingFunderIndex = 2;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {}
    }
    ```

- `assert` and `assertEq`
  - `assertEq` provides more detailed error messages, including the expected and actual values, which can be extremely useful when troubleshooting.
    - `assertEq` is generally preferred in test cases because of the additional information it provides when the test fails, making it easier identify the issue.
  - `assert` only checks a condition but doesn’t provide as much detail on failure beyond the fact that the condition was false.

## Chisel

Let's you write in solidity in the terminal and execute it line by line

```bash
chisel 
```

## Storage Optimization

- How the contract stores things like the state variables (aka storage
  variables)
  - <https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html>
- Global or state variables that stay permanent, they are stuck in storage
  > Think of storage as a giant array or list of variables that we create

- each variable is stored in a "slot" and each slot is 32 bytes long,
  representing the bytes version of the object

Example:

```solidity
contract FunWithStorage {
  uint256 favoriteNumber;

  constructor() {
    favoriteNumber = 25;
  }
}
```

The uint256 25 is stored in the first slot (slot 0) and represented in hex as
0x000...0019

```solidity
contract FunWithStorage {
  uint256 favoriteNumber;
  bool someBool;

  constructor() {
    favoriteNumber = 25;
    someBool = true;
  }
}
```

For a "true" boolean, it would be 0x000...001 in hex

```solidity
contract FunWithStorage {
  uint256 favoriteNumber;
  bool someBool;
  uint256[] myArray;

  constructor() {
    favoriteNumber = 25;
    someBool = true;
    myArray.push(222);
  }
}
```

For dynamic values like mappings and dynamic arrays, the elements are stored
using a hashing function (see solidity dos for more details).
  - For arrays, a sequential storage spot is taken up for the length of the
    array
  - For mappings, a sequential storage spot is taken up, but left blank and
    solidity will know what to do with it

Constant and immutable variables do not take up slots in storage because they
are part of the contracts bytecode
  - variables within a function only last for the duration of the function and
    do not persist
      - they get added in their own memory structure that gets deleted after

`forge <CONTRACT_NAME> storageLayout` will show the storage layout of the
contract to see what variables are stored at what storage slots

"object" in bytecode is the contract in pure bytecode
"opcodes" show the used opcodes in the contract. The actual things that our
contract should do. 
- Each opcode has a gas cost for it
  - <https://www.evm.codes/> for list of opcodes and their costs
  > ex. `SLOAD` is 100 gas. Anytime you read from storage it's 100 gas! `MLOAD`
  > is 3 gas so we can save on gas by using Memory

### Comparison of `cheaperWithdraw` and `withdraw` Functions

| **`cheaperWithdraw`**                                                                                                                                                  | **`withdraw`**                                                                                                                                                      |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ```solidity<br>function cheaperWithdraw() public onlyOwner {<br>&nbsp;&nbsp;&nbsp;uint256 fundersLength = s_funders.length;<br>&nbsp;&nbsp;&nbsp;for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;address funder = s_funders;<br>&nbsp;&nbsp;&nbsp;(bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");<br>&nbsp;&nbsp;&nbsp;require(callSuccess, "Call failed");<br>}``` | ```solidity<br>function withdraw() public onlyOwner {<br>&nbsp;&nbsp;&nbsp;for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;address funder = s_funders;<br>&nbsp;&nbsp;&nbsp;(bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");<br>&nbsp;&nbsp;&nbsp;require(callSuccess, "Call failed");<br>}``` |

### Line-by-Line Comparison

| **Line** | **`cheaperWithdraw`**                                                                             | **`withdraw`**                                                                                  |
|----------|----------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|
| 1        | `function cheaperWithdraw() public onlyOwner {`                                                    | `function withdraw() public onlyOwner {`                                                        |
| 2        | &nbsp;&nbsp;&nbsp;`uint256 fundersLength = s_funders.length;`                                      | *(Line not present)*                                                                            |
| 3        | &nbsp;&nbsp;&nbsp;`for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {`    | &nbsp;&nbsp;&nbsp;`for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {` |
| 4        | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`address funder = s_funders[funderIndex];`                     | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`address funder = s_funders[funderIndex];`                 |
| 5        | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`s_addressToAmountFunded[funder] = 0;`                         | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`s_addressToAmountFunded[funder] = 0;`                     |
| 6        | &nbsp;&nbsp;&nbsp;`}`                                                                              | &nbsp;&nbsp;&nbsp;`}`                                                                           |
| 7        | &nbsp;&nbsp;&nbsp;`s_funders = new address;`                                                  | &nbsp;&nbsp;&nbsp;`s_funders = new address;`                                              |
| 8        | &nbsp;&nbsp;&nbsp;`(bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");` | &nbsp;&nbsp;&nbsp;`(bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");` |
| 9        | &nbsp;&nbsp;&nbsp;`require(callSuccess, "Call failed");`                                           | &nbsp;&nbsp;&nbsp;`require(callSuccess, "Call failed");`                                       |
| 10       | `}`                                                                                                | `}`                                                                                            |

### Key Differences

- **Line 2 (`cheaperWithdraw` only):**
  - `cheaperWithdraw` declares a local variable `fundersLength` to store the length of `s_funders`.
- **Line 3 (Loop Condition):**
  - `cheaperWithdraw` uses `fundersLength` in the loop condition.
  - `withdraw` accesses `s_funders.length` directly in the loop condition.

### Explanation

- **Optimization in `cheaperWithdraw`:**
  - **Storage Reads vs. Memory Reads:**
    - Accessing storage variables like `s_funders.length` is more gas-intensive than accessing memory variables.
    - By storing `s_funders.length` in a local memory variable `fundersLength`, the function reduces the number of storage reads.
  - **Gas Efficiency:**
    - This change makes `cheaperWithdraw` more gas-efficient, especially for loops with many iterations.
- **Standard Approach in `withdraw`:**
  - The `withdraw` function reads `s_funders.length` from storage during each loop iteration.
  - This approach is less gas-efficient due to multiple storage reads.

[Solidity Style Guide](https://docs.soliditylang.org/en/v0.8.4/style-guide.html)
for code layout to be more readable.

- use `s_` for variables stored in storage
- use `i_` for immutable variables
- use all caps for `CONSTANTS`

## README

- explain what codes does and how to do it

## Integration Tests

- [`Interactions.s.sol`](foundry-f23/foundry-fund-me-f23/script/Interactions.s.sol)
  have all the ways to interact with our contract

- install Foundry devops for tools to use with foundry such as a script that
  grabs the most recent deployment of a contract to test integrations
    - `forge install Cyfrin/foundry-devops --no-commit`
    - You can then import it in the `Interactions.s.sol` contract but need to
      set `ffi = true` in your `foundry.toml` file
      > You don't always want to use this as it let's foundry run commands
      > directly on your machine

    - `DevOpsTools.get_most_recent_deployment` can be used to get the most
      recent deployment address so you don't have to manually add the contract
      address you want to interact with every time
      - looks inside the `broadcast` folder in the `run-latest.json` and grabs
        the most recently deployed contract in that file

- Split Integration tests and Unit tests into different folders to keep track
  - `Interactions.s.sol` is for testing the main functions of my contract
  - `FundMeTest.t.sol` for testing different parts of the contract

## Makefiles

- allow you to create shortcuts for commands we are going to commonly use
- add a `Makefile` in your project
- allows you to automatically grab from variables from `.env` without having to
  run `source .env`
- need to add () around your environment variables
  - `$(PRIVATE_KEY)
    - see [`Makefile`](foundry-f23/foundry-fund-me-f23/Makefile) for example
    - can also use the
      [`Makefile`](https://github.com/Cyfrin/foundry-fund-me-cu/blob/main/Makefile)
      that is part of the Cyfrin repo for more shortcuts you can use

## ZKsync Devops

`ZksyncDevOps.t.sol` used to test things that will work on vanilla Foundry, but
not on ZKsync Foundry and vice-versa

`FoundryZkSyncChecker` to run test on either foundry-zksync or vanilla foundry

`ZkSyncChainChecker` to run tests only on ZKsync Era or on other EVM chains

Can learn more
[here](https://github.com/Cyfrin/foundry-devops?tab=readme-ov-file#usage---zksync-checker).

## Pushing to Github

In your `.gitignore` file you can do `<FILE_NAME>/` to prevent it from being
pushed publicly 

`git push origin main` pushes the commits to the repo on the main branch
  
- can do `git remote -v` to see what the origin is

# Fund Me Frontend

Better understanding how wallets are interacting with the frontend and making
sure you're signing what you're supposed to sign 

- Can use Liver Server extension to "Go Live" and have VS Code or Cursor host
  the website

The Console is a live javascript shell which has a lot of info about the browser
we're working with

- Metamask injects into the javascript shell in the `window` object
  - specifically it injects `window.ethereum` into the browser and this is how
    the website sends transactions to our wallet

- `index.js` will show the code that a website will use to interact with the
  wallet
  - the `async function connect()` has a check to see if the `window.ethereum`
    object is available and if it is then an `ethereum.request` to connect to
    one of the accounts in the wallet

"getBalance" button

- checks that metamask is there with the check of `window.ethereum`
- ethers package makes it easy to interact and work with wallets/MM
- when we click the "getBalance" button it's making an API call via the RPC url
  in the wallet

"fund" button

- gets the `ethAmount` from the frontend input box
- checks to make sure there is a wallet connected with `window.ethereum`
- gets the rpc url using ethers and calls the provider from the wallet
- `signer` gets the signer object associated with the account to sign the txn
- `contract` uses ethers to get the deployed address of the contract from the
  `constants.js` file (`abi` also comes from here)
    - REMINDER: You need the `contract address`, `abi`, and `signer` to interact
      with contracts
- transaction:

```javascript
const transactionResponse = await contract.fund(2, "0x0000000000000000000000000000000000000000", {
        value: ethers.parseEther(ethAmount),
```

  - creating the txn using javascript and sending to our wallet to sign
    - allows the private key to remain in wallet and not be exposed to the
      website

> `await` is used since txns are asynchronous and makes sure to wait for the
> first part of the function to be executed before moving on to the next

- `cast sig "<function>"()` will reveal the function selector (low level EVM
  stuff)
- `cast --calldata-decode "<function>(inputs)" <CALLDATA>` will decode the
  calldata

# Smart Contract Lottery

## Solidity Style Guide

[Solidity Style Guide](https://docs.soliditylang.org/en/v0.8.4/style-guide.html)

Order of Layout

1. Pragma statements
2. Import statements
3. Interfaces
4. Libraries
5. Contracts

Inside of each contract, library or interface, use the following order:

1. Type declarations
2. State variables
3. Events
4. Modifiers
5. Functions

Order of Functions

1. constructor
2. receive function (if exists)
3. fallback function (if exists)
4. external
5. public
6. internal
7. private
Within a grouping, place the `view` and `pure` functions last

Helpful to add this at the top of contracts to remember the layout. See
[`Raffle.sol`](Lesson6/foundry-f23/foundry-smart-contract-lottery/src/Raffle.sol)
for an example.

## Creating Custom Errors

As of Solidity v0.8.4 there is a new thing called custom errors so you don't
have to store the errors as a string which is more expensive

> Command + / will comment out a full line 

As of Solidity v0.8.26 can add custom errors inside `require` but requires
compiling with Via IR that we'll get into more later and still is not as gas
efficient as using `if`

**Version 1**

```solidity
function enterRaffle() public payable {
    require(msg.value >= i_entranceFee, "Not enough ETH to enter the raffle");
} 
```

- Explanation: Uses require with a string error message. This is more
  gas-intensive because the string is stored in the contract’s bytecode,
  increasing deployment and runtime costs.

**Version 2**

```solidity
function enterRaffle() public payable {
    require(msg.value >= i_entranceFee, NotEnoughEthToEnterRaffle());
}
```

- Explanation: Uses require with a custom error. As of Solidity v0.8.26, require statements can accept custom errors. This saves gas by avoiding string literals but requires a newer compiler version.

**Version 3**

```solidity
function enterRaffle() public payable {
    if (msg.value < i_entranceFee) {
        revert NotEnoughEthToEnterRaffle();
    }
}
```

- Explanation: Uses an if statement with revert and a custom error. Available
  since Solidity v0.8.4, this approach is more gas-efficient because it avoids
  storing string literals and has less overhead than using require.

It can get confusing on where the error is coming from if you have multiple
contracts so best practice is to use the contract name as a prefix with double
underscore after

- `Raffle__NotEnoughEthToEnterRaffle();`
  - this is a `NotEnoughEthToEnterRaffle` error coming from the `Raffle`
    contract
  
## Smart contract events

`address payable[] private s_players;` is the syntax for making an address array
payable so that you can pay out the winner of the lottery

- each time someone enters the raffle we can do
  `s_players.push(payable(msg.sender));` to push that address to the array

- address payable is essential for any address that will receive Ether.
- Explicit Conversion: Using payable(msg.sender) ensures that the address is correctly cast to a payable type, aligning with Solidity’s type safety.
- Future-Proofing: Storing addresses as payable prepares your contract for any
  future functions that may require sending Ether to these addresses.

Why Solidity Still Requires address payable:

1. Type System Enforcement:

    - No Assumptions: Solidity does not assume that every address is payable, even if it’s an EOA.
    - Explicit Declaration: This enforces intentionality in your code, ensuring that you explicitly handle Ether transfers.

2. Preventing Accidental Transfers:

    - Non-Payable Addresses: Using non-payable address types prevents developers from accidentally transferring Ether to unintended recipients.
    - Intentional Casting: Developers must intentionally cast an address to
      address payable when they mean to transfer Ether, adding a layer of
      intentionality and reducing potential bugs.

> Rule of thumb to follow whenever we make updates to storage, emit an event

Why events?

1. Makes migration easier
2. Makes front end "indexing" easier

EVM can emit logs and inside logs are events

  - events allow you to print to the logging structure to save on gas
  - BUT events cannot be read by smart contracts, hence the gas savings

**Chainlink** nodes are listening for request data events on what information it
needs to provide
**The Graph** is listening for events and indexes them to be queried later

example:

```solidity
event storedNumber(
        uint256 indexed oldNumber,
        uint256 indexed newNumber.
        uint256 addedNumber,
        address sender
);
```

- `indexed` and `nonindexed` parameters when you emit events
  - you can have up to 3 `indexed` parameters, also referred to as Topics, are
    searchable and easier to search for than non-indexed parameters

To emit an event you can do:

```solidity
emit storedNumber(
            favoriteNumber,
            _favoriteNumber,
            _favvoriteNumber + favoriteNumber,
            msg.sender
);
```

To read the logs on a block explorer like Etherscan

- Address
  - the address of the contract or account the event is emitted from
- Topics
  - the indexed parameters of the event
- Data
  - The ABI encoded non-indexed parameters of the event
    - This means we took the non-indexed parameters mashed them together with
      their ABI and "pumped" them through an encoding algorithm
    - If you have the ABI it's easy to decode
    - costs less gas to add to the EVM log

## Random numbers - Block Timestamp

Globally available unit

- current approximate time according to the blockchain

Example of using `block.timestamp` to see if enough time has passed

```solidity
block.timestamp - s_lastTimeStamp > i_interval;
```

Can set `block.timestamp` in the constructor to have the timestamp be taken as
soon as the contract is created