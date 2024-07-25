// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage {      // inherits everything from SimpleStorage *is* is the the important part to inherit
                                                // +5
                                                // overrides
                                                // virtual override
    function store(uint256 _newNumber) public override{        // need to tell it to override the store function in SimpleStorage.sol with this one instead
        myFavoriteNumber = _newNumber + 5;
    }
}
