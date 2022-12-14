// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface ISnaccMachine {
    struct Snacc {
        uint amount;
        uint priceInWei;
    }

    function showSnaccs() external view returns (Snacc[] memory);
    function buySnacc(string memory snaccName) external payable;
    function refillSnacc(string memory snaccName, uint amount) external;
    function addSnacc(string memory snaccName, uint amount, uint priceInWei) external;
    function withdraw() external;

    error SnaccDoesNotExist(string snaccName);
    error SnaccSoldOut(string snaccName);
    error NotEnoughValueSent(uint sent, uint expected);
    error CallerNotOwner(address caller, address owner);
    error SnaccAlreadyAdded(string snaccName);
}

contract SnaccMachine is ISnaccMachine {
    address public owner;
    string[] snaccNames;
    mapping(string => Snacc) snaccs;

    constructor() {
        owner = msg.sender;
        addSnacc("Twix",     40, (4.0 ether / 10000));   // 0.00040 wai
        addSnacc("Mars",     30, (5.0 ether / 10000));   // 0.00050 wai
        addSnacc("Bounty",   20, (7.5 ether / 10000));   // 0.00075 wai
        addSnacc("Snickers", 10, (9.9 ether / 10000));   // 0.00099 wai
    } 

    function showSnaccs() external view override returns (Snacc[] memory) {
        Snacc[] memory snaccsView = new Snacc[](snaccNames.length);
        for (uint index = 0; index < snaccNames.length; index++) {
            snaccsView[index] = snaccs[snaccNames[index]];
        }
        return snaccsView;
    }

    function buySnacc(string memory snaccName) external payable override enforceSnaccExists(snaccName) enforceSnaccNotSoldOut(snaccName) enforceEnoughValueSentForSnacc(snaccName) {
        snaccs[snaccName].amount -= 1;
        uint changeInWei = msg.value - snaccs[snaccName].priceInWei;
        payable(msg.sender).transfer(changeInWei);
    }

    function refillSnacc(string memory snaccName, uint amount) external override enforceCallerIsOwner() enforceSnaccExists(snaccName) {
        snaccs[snaccName].amount += amount;
    }

    function addSnacc(string memory snaccName, uint amount, uint priceInWei) public override enforceCallerIsOwner() enforceSnaccNotAlreadyAdded(snaccName) {
        snaccs[snaccName] = Snacc(amount, priceInWei);
        snaccNames.push(snaccName);
    }

    function withdraw() external override enforceCallerIsOwner() {
        payable(msg.sender).transfer(address(this).balance);
    }

    function exists(string memory snaccName) internal view returns (bool) {
        return snaccs[snaccName].priceInWei != 0;
    }

    modifier enforceSnaccExists(string memory snaccName) {
        if (exists(snaccName) == false) revert SnaccDoesNotExist(snaccName);
        _;
    }

    modifier enforceSnaccNotSoldOut(string memory snaccName) {
        if (snaccs[snaccName].amount == 0) revert SnaccSoldOut(snaccName);
        _;
    }

    modifier enforceEnoughValueSentForSnacc(string memory snaccName) {
        if (msg.value < snaccs[snaccName].priceInWei) revert NotEnoughValueSent(msg.value, snaccs[snaccName].priceInWei);
        _;
    }

    modifier enforceCallerIsOwner() {
        if (msg.sender != owner) revert CallerNotOwner(msg.sender, owner);
        _;
    }

    modifier enforceSnaccNotAlreadyAdded(string memory snaccName) {
        if (exists(snaccName)) revert SnaccAlreadyAdded(snaccName);
        _;
    }
}
