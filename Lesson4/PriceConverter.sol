// library does not need to be deployed as long as the functions are internal and do not change state


// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/..."; // get the rest of the Github filepath 

library PriceConverter{
    function getPrice() internal view returns(uint256){
                                            // Address of the price feed contract
                                            // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface() // enter address of the price feed contract in the ()
        (,int256 price,,,)priceFee.latestRoundData;            // ? why can I do the commas and not just put what I want? // This will return the price of ETH in terms of USD, price feed has a decimal set

        return uint256(price * 1e10);                // price has 8 decimals, so have to add the additional 10 so it's in terms of ETH decimals. Also have to turn price into a uint256 since that is what msg.value is in so can wrap price to make it possible
    }
    function getConversionRate(uint256 ethAmount) internal view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // divide because both ethPrice and ethAmount have 18 decimals and if you multiply them it will be too big and you need to get it back to 18 decimals
                                                                // in Solidity always want to multiply before you divide because you're always working with whole numbers (ex 1 / 2 = 0)
        return ethAmountInUsd;
    }

    function getVersion() internal view returns (uint256){
        return AggregatorV3Interface(XXX).version();        // add address for version contract I think or double check on that
    }
}