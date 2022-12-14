# SnaccMachine
## About
A smart contract that behaves like a vending machine for snacks. <br> <br>

## How to use
The smart contract is available in the Sepolia Test Network under the address: <br>
[0xef8eb7fe1fBd0b00B463374AcF9e5f490C1d37ac](https://sepolia.etherscan.io/address/0xef8eb7fe1fBd0b00B463374AcF9e5f490C1d37ac)
- Everyone can see which snaccs are available using: <br>
  `showSnaccs()` <br>
- Everyone can buy a snacc using: <br>
  `buySnacc("SnaccName", { from: "YourPublicAddress", value: web3.utils.toWei("PaymentInEther") })` <br>
- The owner can refill a snacc using: <br>
  `refillSnacc("SnaccName", Amount)` <br>
- The owner can add a snacc using: <br>
  `addSnacc("SnaccName", Amount, web3.utils.toWei("PriceInEther"))` <br>
- The owner can withdraw money using: <br>
  `withdraw()` <br> <br>

## Developers
- Barbaros Teker (bte3268)
- Christoph Perc (cpe2877)