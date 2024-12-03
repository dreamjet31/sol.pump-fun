// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LiquidityPool is Ownable {
    using SafeERC20 for IERC20;

    // State variables
    address public tokenMint; // Address of the token mint
    mapping(address => uint256) public userBalances; // User balances in the pool
    uint256 public totalLiquidity; // Total liquidity in the pool

    struct CurveConfiguration {
        uint256 fees;
    }

    CurveConfiguration public curveConfig;

    // Events
    event PoolCreated(address indexed creator, address indexed tokenMint);
    event LiquidityAdded(address indexed user, uint256 amount);
    event LiquidityRemoved(address indexed user, uint256 amount);
    event TokensPurchased(
        address indexed buyer,
        uint256 amountSpent,
        uint256 tokensReceived
    );
    event TokensSold(
        address indexed seller,
        uint256 amountSold,
        uint256 amountReceived
    );
    event CurveInitialized(uint256 fees);

    constructor(address _tokenMint) {
        require(
            _tokenMint != address(0),
            "Token mint cannot be the zero address"
        );
        tokenMint = _tokenMint;
        emit PoolCreated(msg.sender, _tokenMint);
    }

    // Function to initialize curve config
    function initializeCurveConfig(uint256 fees) external onlyOwner {
        require(fees >= 0 && fees <= 10000, "Invalid fee");
        curveConfig.fees = fees;
        emit CurveInitialized(fees);
    }

    // Function to add liquidity
    function addLiquidity(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        // Transfer tokens from user to this contract
        IERC20(tokenMint).safeTransferFrom(msg.sender, address(this), amount);

        // Update user balance and total liquidity
        userBalances[msg.sender] += amount;
        totalLiquidity += amount;

        emit LiquidityAdded(msg.sender, amount);
    }

    // Function to remove liquidity
    function removeLiquidity(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(userBalances[msg.sender] >= amount, "Insufficient balance");

        // Update user balance and total liquidity
        userBalances[msg.sender] -= amount;
        totalLiquidity -= amount;

        // Transfer tokens back to user
        IERC20(tokenMint).safeTransfer(msg.sender, amount);

        emit LiquidityRemoved(msg.sender, amount);
    }

    // Function to buy tokens from the liquidity pool
    function buyTokens(uint256 amountToSpend) external {
        require(amountToSpend > 0, "Amount must be greater than 0");

        // Calculate how many tokens can be bought
        uint256 tokensToReceive = calculateTokensReceived(amountToSpend);

        require(
            tokensToReceive <= totalLiquidity,
            "Not enough liquidity available"
        );

        // Transfer payment (assuming payment is made in ETH for simplicity)
        // If using ERC20 tokens for payment, you would transfer them similarly as shown in addLiquidity.

        // Update state variables
        totalLiquidity -= tokensToReceive;

        // Transfer tokens to buyer
        IERC20(tokenMint).safeTransfer(msg.sender, tokensToReceive);

        emit TokensPurchased(msg.sender, amountToSpend, tokensToReceive);
    }

    function sellTokens(uint256 amountToSell) external {
        require(amountToSell > 0, "Amount must be greater than 0");

        // Check if the user has enough tokens to sell
        require(
            IERC20(tokenMint).balanceOf(msg.sender) >= amountToSell,
            "Insufficient token balance"
        );

        // Calculate how much ETH or other payment will be received
        uint256 tokensToSell = calculateTokensReceived(amountToSell);

        require(
            tokensToSell <= address(this).balance,
            "Not enough liquidity in the pool for this sale"
        );

        // Transfer tokens from user to this contract
        IERC20(tokenMint).safeTransferFrom(
            msg.sender,
            address(this),
            amountToSell
        );

        // Transfer payment to the seller (assumming payment is made in ETH)
        payable(msg.sender).transfer(tokensToSell);

        emit TokensSold(msg.sender, amountToSell, tokensToSell);
    }

    // Calculate tokens received
    function calculateTokensReceived(
        uint256 amountSpent
    ) internal view returns (uint256) {
        return amountSpent;
    }
}
