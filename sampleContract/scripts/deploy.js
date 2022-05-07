const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {

  const signers = await ethers.getSigners();
  
  const Sample = await ethers.getContractFactory("sample", signers[5]);
  const sample = await Sample.deploy();

  await sample.deployed();

  console.log("Sample deployed to:", sample.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
