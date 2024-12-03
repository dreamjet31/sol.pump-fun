// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBondingCurve {
    /// @notice Buys tokens from the bonding curve.
    /// @param amountToSpend The currency spent to buy tokens.
    /// @return The number of tokens received.
    function buyTokens(
        uint256 amountToSpend
    ) external returns (uint256 tokensReceived);

    /// @notice Sells tokens back to the bonding curve.
    /// @param amountToSell The number of tokens sold.
    /// @return The currency received for selling tokens.
    function sellTokens(
        uint256 amountToSell
    ) external returns (uint256 paymentAmount);

    /// @notice Calculates how many tokens can be bought for a given spent currency.
    /// @param amountSpent The currency spent.
    /// @return The number of tokens received.
    function calculateTokensReceived(
        uint256 amountSpent
    ) external view returns (uint256);

    /// @notice Calculates how much currency will be received for a given number of sold tokens.
    /// @param amountSold The number of tokens sold.
    /// @return The currency received for selling tokens.
    function calculatePaymentReceived(
        uint256 amountSold
    ) external view returns (uint256);

    /// @notice Gets current reserve balance held by the bonding curve.
    /// @return Current reserve balance.
    function getReserveBalance() external view returns (uint256);

    /// @notice Gets total supply of issued tokens by this bonding curve.
    /// @return Total supply of issued tokens.
    function getTotalSupply() external view returns (uint256);
}
