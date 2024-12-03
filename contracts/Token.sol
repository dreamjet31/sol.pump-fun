// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {
    // Constructor to initialize the token with a name and symbol
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) Ownable(msg.sender) {
        // Mint the initial supply to the deployer of the contract
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    // Function to mint new tokens (only owner can mint)
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // Function to burn tokens (only owner can burn)
    function burn(uint256 amount) external onlyOwner {
        _burn(msg.sender, amount);
    }
}
