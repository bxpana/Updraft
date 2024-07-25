                                        // Good to write out your functionality (functions) of your contract
                                        // Get funds from users
                                        // withdraw funds
                                        // set a min funding value in USD so you have to work with whole numbers

                                        // there are no decimals in Solidity so you have to work with whole numbers
                                        // solidity-by-example.org is a good source for learning more about Solidity

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import{PriceConverter} from "./PriceConverter.sol"; 
/*
import {AggregatorV3Interface} from "@chainlink/contracts/src/..."; // get the rest of the Github filepath 
                                                                    // can get the interface from the Github Repo
                                                                    // ? Why is this possible? Why not just do this all the time instead of deploying a contract?
*/
contract FundMe {
    using PriceConverter for uint256;   // uses PriceConverter for all uint256s

    uint256 public minimumUsd = 5e18;   // have to conver the 5 to have 18 decimals since getConversinRate returns a number with 18 decimal places

    address[] public funders;           // make a list (array) of addresses that send funds to the contract
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;   // mapping so that you can check how much that address funded

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {    // payable allows this contract to receive funds
                                // Allow users to send $
                                // have a min $ sent
                                // 1. How do we send ETH to this contract?
        // msg.value.getConversionRate();  // EXAMPLE. In the library we already have the first input variable which is the type you're using with the library even though we don't pass any variables through here which in this case is uint256 ethAmount. If you put something inside the paranthesis it would use the next parameter if there was one set
        require(msg.value.getConversionRate() >= minimumUsd, "didn't send enough ETH");     // implementing what we have in the comment above
        // require(getConversionRate(msg.value) >= minimumUsd, "didn't send enough ETH");    OLD WAY from earlier in the video  // require(msg.value > 1e18, "didn't send enough ETH"); // 1e18 = 1 ETH = 1000000000000000000 = 1 * 10 ** 18 | require is making sure that the amount being deposited is at least 1 ETH or it reverts
                                                                                            // a revert will undo the action and send the remaining gas back, but still consumes the gas needed to get through the code prior to the revert
        funders.push(msg.sender);       // global variable that refers to who ever called this function
        //addressToAmountFunded[msg.semder] = addressToAmountFunded [msg.sender] + msg.value; // store what they have previously send plus whatever additional value they are sending (msg.value)
        addressToAmountFunded[msg.sender] += msg.value;     // shortcut for the commented line above. Can use += to mean equal to the first part plus the part on the right of the equal sign
    }

    function withdraw() public onlyOwner {        // use for loop to reset the withdrawal mapping
            // for(/* starting index, ending index, step amount */ )
            for(uint256 funderIndex = 0; funderIndex < funders.length/* gives me length of array */; funderIndex++ /* = funerIndex +1 */ ){
                address funder = funders[funderIndex];
                addressToAmountFunded[funder] = 0;
            }
            funders = new address[](0);     // using the key word "new" will allow us to reset the "funders" array

                                            // three ways to withdraw funds: transfer, send, and call. Transfer is the easiest of the 3
            // transfer
            payable(msg.sender).transfer(address(this).balance);    // msg.sender is a address type so we have to type cast it with payable to make it a payable address. With transfer it will max out at 2300 gas and throw an error
            // send
            bool sendSuccess /* without this bool the txn wouldn't revert if it failed and the money wouldn't be sent */ = payble(msg.sender).send(address(this).balance);    // send will max at 2300 gas but returns a boolean. 
            require(sendSuccess,"Send failed");
            // call     can use to call any function in Ethereum
            // (bool callSuccess /* call also returns callSuccess where if the function was successful this would be true */, bytes dataReturned /* data returned from the function that call uses */) /* the () to the left shows that the call function returns 2 variables   */ = payable(msg.sender).call{value: address(this).balance}(""/* this is where you put any function information we want to call from another contract*/)
            (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}(""); // we don't need they bytes so we can leave it blank to let Solidity know we don't need it
            require(callSuccess, "Call failed");
            // call is the recommended way to send and receive funds
    }

    modifier onlyOwner() {                      // modifiers allow you to create easier ways to add functionality very quickly to any function
        require(msg.sender == owner, "Sender is not owner!");
        _;                                      // this means execute the code inside the function. So if it was first it would execute the code and then the require
    }

    // can remove the code below and create a library out of it so that my code is cleaner. moved to PriceConverter.sol 
    /*
    function getPrice() public view returns(uint256){
                                            // Address of the price feed contract
                                            // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface() // enter address of the price feed contract in the ()
        (,int256 price,,,)priceFee.latestRoundData;            // ? why can I do the commas and not just put what I want? // This will return the price of ETH in terms of USD, price feed has a decimal set

        return uint256(price * 1e10);                // price has 8 decimals, so have to add the additional 10 so it's in terms of ETH decimals. Also have to turn price into a uint256 since that is what msg.value is in so can wrap price to make it possible
    }
    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // divide because both ethPrice and ethAmount have 18 decimals and if you multiply them it will be too big and you need to get it back to 18 decimals
                                                                // in Solidity always want to multiply before you divide because you're always working with whole numbers (ex 1 / 2 = 0)
        return ethAmountInUsd;
    }

    function getVersion() public view returns (uint256){
        return AggregatorV3Interface(XXX).version();        // add address for version contract I think or double check on that
    }
    */
}