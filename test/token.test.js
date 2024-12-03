const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("LiquidityPool", function () {
  let Token, token, LiquidityPool, liquidityPool;
  const initialSupply = ethers.utils.parseUnits("1000000", 18); // 1 million tokens

  beforeEach(async function () {
    // Deploy Token contract
    Token = await ethers.getContractFactory("Token");
    token = await Token.deploy("PumpFunToken", "PFT", initialSupply);
    await token.deployed();

    // Deploy LiquidityPool contract
    LiquidityPool = await ethers.getContractFactory("LiquidityPool");
    liquidityPool = await LiquidityPool.deploy(token.address);
    await liquidityPool.deployed();
  });

  it("Should add liquidity correctly", async function () {
    const amountToAdd = ethers.utils.parseUnits("100", 18); // Add 100 tokens
    await token.approve(liquidityPool.address, amountToAdd);

    await liquidityPool.addLiquidity(amountToAdd);

    expect(
      await liquidityPool.userBalances(await ethers.getSigner().getAddress())
    ).to.equal(amountToAdd);
  });

  it("Should remove liquidity correctly", async function () {
    const amountToAdd = ethers.utils.parseUnits("100", 18); // Add 100 tokens
    await token.approve(liquidityPool.address, amountToAdd);

    await liquidityPool.addLiquidity(amountToAdd);

    const amountToRemove = ethers.utils.parseUnits("50", 18); // Remove 50 tokens

    await liquidityPool.removeLiquidity(amountToRemove);

    expect(
      await liquidityPool.userBalances(await ethers.getSigner().getAddress())
    ).to.equal(ethers.utils.parseUnits("50", 18));
  });
});
