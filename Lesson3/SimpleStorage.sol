// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; // this is the solidity version ^ means work with any newer version too >= allows you to set a range like ">=0.8.18 <0.9.0"

//name of contract and everything in {} is considered part of the contract
contract SimpleStorage { 
                                // Basic Types: boolean, uint (positive whole nunmber), int (pos or neg whole number), address, bytes
                                /*bool hasFavoriteNumber = true;
                                unit256 favoriteNumber = 88;
                                string favoriteNumberInText= "eighty-eight";
                                int256 favoriteInt = -88;
                                address myAddress = 0x8Ee042243f2d2ce5EFBEa796fE9e11e78B95Fdf1;
                                bytes32 favoriteBytes32 = "cat"; // strings can easily be converted to bytes. bytes and bytes32 are different things
                                */

                                // function visibility: public, private, external, internal. If you don't specify then internal is default
    uint256 myFavoriteNumber; // if no value is given, default is 0

                                // uint256[] listOfFavoriteNumbers; // [] means there is a list or an array of numbers
                                // can create your own Type using struct
    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    
                                // if you add a number in the array then that is the limit of indexing
                                    // Person[3] can only have a max size of 3
                                // dynamic array, can have any size list
    Person[] public listOfPeople; // default is an empty list

                                    // like a dictionary. Maps this string to a specific number
                                    // if I did Pat, it would return 7
    mapping(string => uint256) public nameToFavoriteNumber;

                                        /*  Person Struct
                                            // can now create a variable for the type "Person" they way we did for "uint256 myFavoriteNumber;"
                                            // when working with custom types you need to define on the left and the right
                                            Person public pat = Person({favoriteNumber: 7, name: "Pat"}); 
                                            // we created our own type "Person" and create a variable named "pat" with a favorite number of 7 and a name of Pat
                                            Person public mariah = Person({favoriteNumber: 16, name: "Mariah"}); 
                                            Person public jon = Person({favoriteNumber: 12, name: "Jon"}); 
                                            // instead of listing out each one, we can use the array []
                                        */
    function store(uint256 _favoriteNumber) public virtual { // whatever is in the () is going to be passed through our function, parameters  "virtual" allows it to be overwritten in a contract that is inhereting this function
        myFavoriteNumber = _favoriteNumber;
                                                // uint256 testVar = 5;
    }
                                                /*
                                                // if a variable is created inside of a function then it can't be read by other functions
                                                function something() public {
                                                    testVar = 6; 
                                                    favoriteNumber = 7; // this works because it's inside the {} of the Contract and favroteNumber was identified in the contract too
                                                } */

                                                // view and pure don't need to send a transaction to call them. 
                                                // view means read state from the blockchain. When marked as "view" the function is not able to update the state
                                                // pure, no updating state or reading from state and storage
                                                // does not cost gas unless a gas cost transaction is calling it (like being called from another contract or another function that uses gas)
    function retrieve() public view returns(uint256){ // returns defines what type we want returned
                                                 // favoriteNumber = favoriteNumber +1; would not work because it is modifying the state and marked as "view"
        return myFavoriteNumber; // favoriteNumber is a storage variable because it is stored in a place called storage
    }

                                            // we are going to take the listOfPeople object and call the "push" function on it. Allows us to add elements to the array
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
                                                        // _name = "cat"; // this would not work if it was "calldata" instead of memory because calldata cannot be modified more than once
        listOfPeople.push( Person(_favoriteNumber, _name) ); // executes Person(_favoriteNumber, _name) first and then executes the push to add to the array
        nameToFavoriteNumber[_name] = _favoriteNumber; // [] specifies what the key is for the mapping
    }
} 

                                            // Storage
                                            // calldata: temp cannot be modified
                                            // memory: temp that CAN be modified
                                                // structs, mapping, and arrays need the memory keyword
                                            // storage: perm that CAN be modified
                                                // variable declared outside of a function will default to storage