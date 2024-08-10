# Lesson 6

- When using `forge script` if there is no RPC URL it will spin up a temporary Anvil to deploy the contract

- `cast --to-base <hex> dec` will convert hex into decimal
  - `cast --help` shows other conversions and tools you can use with cast

## DO NOT DO THIS WITH PRODUCTION CODE

- .env file make sure is listed in `.gitignore`
  - after make to `source .env` to make sure it grabs from .env file
        - can use `echo $<.env_VARIABLE>` to make sure it's getting it
    - can add .env variable to use with terminal command with `$<.env_VARIABLE>`

- For real money you'll use `--interactive` or a keystoree file with a password
- With `cast` you can do `cast wallet import defaultKey --interactive` to create your keystore with a password
- `cast wallet list` shows full lists of keystore wallets
  - `--password-file` could be used too to make it faster instead of having to put in your password that would come from something like a `.password` file
  - make sure to add `.password` file to `.gitignore`
  - Can also create a `ETH_PASSWORD` variable in a .env and use `--password $ETH_PASSWORD` instead of putting in your password everytime

## Terminal shortcuts

- View history with `history`
- clear history with `history -c`
- clear terminal with `clear`
- delete a word [ctrl] + W
- clear to the beginning [ctrl] + U
- `rm .bash_history` to clear command line history

- You can see your "runs" in the `broadcast` folder under the contract name and the chain ID
  - give you details about the txn
  - `run-latest.json` will always be the latest run
