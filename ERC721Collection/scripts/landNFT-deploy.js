const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
  const LandNFT = await ethers.getContractFactory("LandNFT");
  const landNFT = await LandNFT.deploy();

  await landNFT.deployed();

  console.log("LandNFT deployed to:", landNFT.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
