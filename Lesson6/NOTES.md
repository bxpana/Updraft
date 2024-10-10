# Lesson 6

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