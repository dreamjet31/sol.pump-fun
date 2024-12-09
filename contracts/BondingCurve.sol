// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract BondingCurve {
    using SafeERC20 for IERC20;

    IERC20 public token;
    uint256 public reserveBalance;
    uint256 public totalSupply;

    // Parameters for the bonding curve
    uint256 public constant INITIAL_PRICE = 1 ether; // Initial price for the first token
    uint256 public constant SLOPE = 0.1 ether; // Price increase per additional token minted

    mapping(address => uint256) private balances;

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

    constructor(IERC20 _token) {
        token = _token;
    }

    function buyTokens(uint256 amountToSpend) external {
        require(amountToSpend > 0, "Amount must be greater than 0");

        // Calculate how many tokens can be bought based on the current price
        uint256 tokensToReceive = calculateTokenReceived(amountToSpend);

        reserveBalance += amountToSpend;
        totalSupply += tokensToReceive;

        token.safeTransferFrom(msg.sender, address(this), amountToSpend);
        _mint(msg.sender, tokensToReceive);

        emit TokensPurchased(msg.sender, amountToSpend, tokensToReceive);
    }

    function sellTokens(uint256 amountToSell) external {
        require(amountToSell > 0, "Amount must be greater than 0");
        require(balances[msg.sender] >= amountToSell, "Insufficient balance");

        uint256 paymentAmount = calculatePaymentReceived(amountToSell);
        require(paymentAmount <= reserveBalance, "Not enough liquidity");

        reserveBalance -= paymentAmount;
        totalSupply -= amountToSell;

        _burn(msg.sender, amountToSell);
        token.safeTransfer(msg.sender, paymentAmount);

        emit TokensSold(msg.sender, amountToSell, paymentAmount);
    }

    function calculateTokenReceived(
        uint256 amountSpent
    ) public view returns (uint256) {
        uint256 tokensReceived = 0;
        uint256 currentPrice = INITIAL_PRICE;

        while (amountSpent >= currentPrice) {
            amountSpent -= currentPrice;
            tokensReceived++;
            currentPrice += SLOPE;
        }
        return tokensReceived;
    }

    function calculatePaymentReceived(
        uint256 amountSold
    ) public view returns (uint256) {
        uint256 paymentReceived = 0;
        uint256 currentPrice = INITIAL_PRICE;

        for (uint256 i = 0; i < amountSold; i++) {
            paymentReceived += currentPrice;
            currentPrice += SLOPE;
        }
        return paymentReceived;
    }

    function _mint(address account, uint256 amount) internal {
        balances[account] += amount;
    }

    function _burn(address account, uint256 amount) internal {
        balances[account] -= amount;
    }
}
