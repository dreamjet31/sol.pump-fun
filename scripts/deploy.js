// scripts/deploy.js
const { ethers } = require("hardhat");

async function main() {
  // Deploy Token contract
  const Token = await ethers.getContractFactory("Token");
  const token = await Token.deploy("PumpFunToken", "PFT", 1000000); // Initial supply of 1 million tokens
  await token.deployed();
  console.log(`Token deployed to: ${token.address}`);

  // Deploy BondingCurve contract
  const BondingCurve = await ethers.getContractFactory("BondingCurve");
  const bondingCurve = await BondingCurve.deploy(token.address);
  await bondingCurve.deployed();
  console.log(`BondingCurve deployed to: ${bondingCurve.address}`);

  // Deploy LiquidityPool contract
  const LiquidityPool = await ethers.getContractFactory("LiquidityPool");
  const liquidityPool = await LiquidityPool.deploy(token.address);
  await liquidityPool.deployed();
  console.log(`LiquidityPool deployed to: ${liquidityPool.address}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
