// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface ISnaccMachine {
    struct Snack {
        uint amount;
        uint price;
    }

    function getSnacks() external view returns (Snack[] memory);
    function buySnack(string memory snackName) external payable;
    function refillSnack(string memory snackName, uint amount) external;
    function addSnack(string memory snackName, uint amount, uint price) external;
    function withdraw() external;

    error CallerNotOwner(address caller, address owner);
    error SnackDoesNotExist(string snackName);
    error SnackSoldOut(string snackName);
    error SnackAlreadyExists(string snackName);
    error NotEnoughValueSent(uint sent, uint expected);
}

contract SnaccMachine is ISnaccMachine {
    address public owner;
    mapping(string => Snack) snacks;
    string[] snackNames;

    constructor() {
        owner = msg.sender;
        addSnack("Snickers", 5, 1   ether / 10000); // 0.00010
        addSnack("Mars",    10, 2.5 ether / 10000); // 0.00025
        addSnack("Bounty",  15, 3   ether / 10000); // 0.00030
        addSnack("Twix",    20, 3.5 ether / 10000); // 0.00035
    }

    function getSnacks() external view override returns (Snack[] memory) {
        Snack[] memory snacksView = new Snack[](snackNames.length);

        for (uint index = 0; index < snackNames.length; index++) {
            snacksView[index] = snacks[snackNames[index]];
        }

        return snacksView;
    }

    function buySnack(string memory snackName) external payable override enforceSnackExists(snackName) {
        if (snacks[snackName].amount == 0) revert SnackSoldOut(snackName);
        if (msg.value < snacks[snackName].price) revert NotEnoughValueSent(msg.value, snacks[snackName].price);

        snacks[snackName].amount -= 1;

        uint change = msg.value - snacks[snackName].price;
        payable(msg.sender).transfer(change);
    }

    function refillSnack(string memory snackName, uint amount) external override enforceCallerIsOwner() enforceSnackExists(snackName) {
        snacks[snackName].amount += amount;
    }

    function addSnack(string memory snackName, uint amount, uint price) public override enforceCallerIsOwner() enforceSnackDoesNotExist(snackName) {
        snacks[snackName] = Snack(amount, price);
        snackNames.push(snackName);
    }

    function withdraw() external override enforceCallerIsOwner() {
        payable(msg.sender).transfer(address(this).balance);
    }

    modifier enforceCallerIsOwner() {
        if (msg.sender != owner) revert CallerNotOwner(msg.sender, owner);
        _;
    }

    modifier enforceSnackExists(string memory snackName) {
        if (exists(snackName) == false) revert SnackDoesNotExist(snackName);
        _;
    }

    modifier enforceSnackDoesNotExist(string memory snackName) {
        if (exists(snackName)) revert SnackAlreadyExists(snackName);
        _;
    }

    function exists(string memory snackName) internal view returns (bool) {
        return snacks[snackName].price != 0;
    }
}
