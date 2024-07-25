/* 
- More advanced ways to write the FundMe.sol contract
- Make more gas efficient
    - we are storing them in the byte code of contract instead of storage slot
- constant: variable no longer takes up a storage slot so use less gas
    - different naming conven: ALL CAPS with _
- immutable: variables that you set 1 time out of the same line they are declared (like in the constructor) can be set as immmutable
    - different naming conve: i and _
- update "require"
    - instead of storing error message as a string array
- custom errors
    - can use instead of using require with an "if" and "revert"
- receive and fallback
    - if people send money to the contract or people call a function that doesn't exist, to trigger some code 
    - receive
        - contract can have at most one receive function using `receive() external payable { ... }` without the `function` keyword
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import{PriceConverter} from "./PriceConverter.sol"; 

error NotOwner();   // custom error

contract FundMe {
    using PriceConverter for uint256;   

    uint256 public constant MINIMUM_USD = 5e18;   

    address[] public funders;           
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;   

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {    

        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough ETH");     

        funders.push(msg.sender);      

        addressToAmountFunded[msg.sender] += msg.value;     
    }

    function withdraw() public onlyOwner {        

            for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
                address funder = funders[funderIndex];
                addressToAmountFunded[funder] = 0;
            }
            funders = new address[](0);     

            payable(msg.sender).transfer(address(this).balance);    

            bool sendSuccess = payble(msg.sender).send(address(this).balance);  
            require(sendSuccess,"Send failed");
            
            (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}(""); 
            require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {                      
        //require(msg.sender == i_owner, "Sender is not owner!");
        if(msg.sender != i_owner) { revert NotOwner(); }
        _;                                      
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}