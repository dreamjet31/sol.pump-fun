const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BondingCurve", function () {
  let Token, token, BondingCurve, bondingCurve;
  const initialSupply = ethers.utils.parseUnits("1000000", 18); // 1 million tokens

  beforeEach(async function () {
    // Deploy Token contract
    Token = await ethers.getContractFactory("Token");
    token = await Token.deploy("PumpFunToken", "PFT", initialSupply);
    await token.deployed();

    // Deploy BondingCurve contract
    BondingCurve = await ethers.getContractFactory("BondingCurve");
    bondingCurve = await BondingCurve.deploy(token.address);
    await bondingCurve.deployed();
  });

  it("Should buy tokens correctly", async function () {
    const amountToSpend = ethers.utils.parseEther("1"); // Spend 1 ETH
    await token.approve(bondingCurve.address, amountToSpend);

    const tokensReceived = await bondingCurve.buyTokens(amountToSpend);

    expect(tokensReceived).to.be.gt(0); // Expect to receive some tokens
  });

  it("Should sell tokens correctly", async function () {
    const amountToSpend = ethers.utils.parseEther("1"); // Spend 1 ETH
    await token.approve(bondingCurve.address, amountToSpend);
    await bondingCurve.buyTokens(amountToSpend);

    const amountToSell = 100; // Example amount to sell
    await token.approve(bondingCurve.address, amountToSell);

    const paymentAmount = await bondingCurve.calculatePaymentReceived(
      amountToSell
    );

    const sellerBalanceBefore = await ethers.provider.getBalance(
      await ethers.getSigner().getAddress()
    );

    await bondingCurve.sellTokens(amountToSell);

    const sellerBalanceAfter = await ethers.provider.getBalance(
      await ethers.getSigner().getAddress()
    );

    expect(sellerBalanceAfter).to.be.gt(sellerBalanceBefore); // Expect the seller's balance to increase
  });
});
