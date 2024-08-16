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
## Tests

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

## Advanced Deploy Scripts

> [Example](foundry-f23/foundry-fund-me-f23/script/DeployFundMe.s.sol)

```
vm.startBroadcast();
  ...
v,.stopBroadcast();
```

- tells foundry to start deploy and when to finis the deployment

- `forge clean` will clear the cache of your Foundry files which deletes Build Artificats and removes Cache Files
