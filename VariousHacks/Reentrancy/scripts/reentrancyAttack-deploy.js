const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {

  const ReentrancyAttack = await ethers.getContractFactory("ReentrancyAttack");
  const reentrancyAttack = await ReentrancyAttack.deploy("0x5FbDB2315678afecb367f032d93F642f64180aa3");

  await reentrancyAttack.deployed();

  console.log("ReentrancyAttack deployed to:", reentrancyAttack.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
