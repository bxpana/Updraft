// SafeMath used to be used a lot and is now used much less
// Prior to 0.8.0 Solidity uint and int ran "unchecked", which means if you reached the upper limit of a number it would just wrap around and start from the lowest number it could be
// SafeMath would make sure that you weren't going over the max of the number
// 0.8.0 introduced a check to see if you would "overflow" or "underflow" on a variable

// SPDX-License-Identifier: MIT
pragma ^0.6.0;

contract SafeMathTester{
    uint8 public bigNumber = 255;       // 255 is the biggest number that can fit in a uint8

    function add() public {
        bigNumber = bigNumber + 1;      // since 255 is the max, adding one will turn it to 0
    }
/*
    function add() public {
        unchecked {bigNumber = bigNumber + 1};      // can use "unchecked" keyword on Solidity 0.8.0+ to force it to be unchecked
                                                    // using "unchecked" can actually be more gas efficient if you are sure that you'll never exceed the limits
    }
*/
    
}