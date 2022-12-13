# SnaccMachine
## About
A smart contract that works like a vending machine.

Available in the Sepolia Test Network: 0xC49E73388073D23dD4B94aB0A0e90808CdDc8C8D

## Functionality
### > Look what's inside
You can look inside the vending machine using `instance.getSnacks()`

### > Buy something
You can buy a snack using `instance.buySnack("SnackName", 
{from: "YourPublicAddress", value: web3.utils.toWei("0.015")})`

### > Refill snack (owner only)
You can refill a snack using `instance.refillSnack("SnackName", Amount)`

### > Add new snack (owner only)
You can add a new snack using `instance.addSnack("SnackName", Amount, Price)`

## Developers
Barbaros Teker (bte3268)

Christoph Perc (cpe2877)
