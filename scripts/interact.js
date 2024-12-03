// scripts/interact.js
const { ethers } = require("hardhat");

async function main() {
  const [owner] = await ethers.getSigners();

  // Replace with actual deployed contract addresses
  const tokenAddress = "YOUR_TOKEN_ADDRESS";
  const bondingCurveAddress = "YOUR_BONDING_CURVE_ADDRESS";
  const liquidityPoolAddress = "YOUR_LIQUIDITY_POOL_ADDRESS";

  const Token = await ethers.getContractAt("Token", tokenAddress);
  const BondingCurve = await ethers.getContractAt(
    "BondingCurve",
    bondingCurveAddress
  );
  const LiquidityPool = await ethers.getContractAt(
    "LiquidityPool",
    liquidityPoolAddress
  );

  // Example interaction: Mint tokens
  let tx = await Token.mint(owner.address, ethers.utils.parseUnits("100", 18));
  await tx.wait();
  console.log("Minted 100 tokens");

  // Example interaction: Add liquidity
  tx = await Token.approve(
    liquidityPoolAddress,
    ethers.utils.parseUnits("100", 18)
  );
  await tx.wait();

  tx = await LiquidityPool.addLiquidity(ethers.utils.parseUnits("100", 18));
  await tx.wait();
  console.log("Added 100 tokens to liquidity pool");

  // Example interaction: Buy tokens from bonding curve
  tx = await BondingCurve.buyTokens(ethers.utils.parseUnits("10", 18)); // Spend 10 tokens
  await tx.wait();

  console.log("Bought tokens from bonding curve");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
