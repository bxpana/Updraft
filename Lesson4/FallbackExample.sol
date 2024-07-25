/*
- receive gets triggered anytime you send a txn to the contract and don't specify the function and leave the calldata blank
- fallback: similar to receive, but can work even when data is sent with a txn
- explainer "decision tree" at https:solidity-by-example.org/fallback/
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract FallbackExample {
    uint256 public result;

    receive() external payable {    // don't need "function" keyword because Solidity knows receive is special
        result = 1;
    }

    fallback() external payable {   // again don't need "function" keyword
        result = 2;
    }
}