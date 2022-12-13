// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SnaccMachine {
    struct Snack {
        string name;
        uint amount;
        uint price;
    }

    address public owner;
    Snack[] snacks;

    constructor() {
        owner = msg.sender;
        snacks.push(Snack("Snickers",  5, 1));
        snacks.push(Snack("Mars",     10, 2));
        snacks.push(Snack("Bounty",   15, 3));
        snacks.push(Snack("Twix",     20, 4));
    }

    function getSnacks() public view returns (Snack[] memory) {
        return snacks;
    }

    function buySnack(string memory _snackName) public payable {
        require(exists(_snackName), "The snack must exist in order to be bought.");
        require(isStocked(_snackName), "The snack must be stocked in order to be bought.");
        require(msg.value > getSnack(_snackName).price, "You must send more money in order to buy the snack.");

        Snack storage snack = getSnack(_snackName);
        snack.amount = snack.amount - 1;
        
        uint change = msg.value - snack.price;
        payable(msg.sender).transfer(change);
    }

    function refillSnack(string memory _snackName, uint _amount) public {
        require(msg.sender == owner, "Only the owner can refill snacks.");
        require(exists(_snackName), "The snack must exist in order to be refilled.");

        Snack storage snack = getSnack(_snackName);
        snack.amount = snack.amount + _amount;
    }

    function addSnack(string memory _snackName, uint _amount, uint _price) public {
        require(msg.sender == owner, "Only the owner can add snacks.");
        require(exists(_snackName) == false, "The snack already exists, please refill instead.");

        snacks.push(Snack(_snackName, _amount, _price));
    }

    // Helper functions
    function exists(string memory _snackName) private view returns (bool) {
        for (uint i = 0; i < snacks.length; i++) {
            if (keccak256(abi.encodePacked(snacks[i].name)) == keccak256(abi.encodePacked(_snackName))) {
                return true;
            }
        }
        return false;
    }

    function isStocked(string memory _snackName) private view returns (bool) {
        for (uint i = 0; i < snacks.length; i++) {
            if (keccak256(abi.encodePacked(snacks[i].name)) == keccak256(abi.encodePacked(_snackName))) {
                if (snacks[i].amount > 0) {
                    return true;
                }
            }
        }
        return false;
    }

    // Make sure to call exists() or require(exists()) before calling getSnack()
    function getSnack(string memory _snackName) private view returns (Snack storage) {
        for (uint i = 0; i < snacks.length; i++) {
            if (keccak256(abi.encodePacked(snacks[i].name)) == keccak256(abi.encodePacked(_snackName))) {
                return snacks[i];
            }
        }
        revert();
    }
}
