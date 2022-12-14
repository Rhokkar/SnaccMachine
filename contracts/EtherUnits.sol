// SPDX-License-Identifier: MIT
// Source: https://solidity-by-example.org/ether-units/
pragma solidity 0.8.17;

contract EtherUnits {
    // 1 wei is equal to 1
    uint public oneWei = 1 wei;
    bool public isOneWei = 1 wei == 1;

    // 1 ether is equal to 10^18 wei
    uint public oneEther = 1 ether;
    bool public isOneEther = 1 ether == 1e18;
}