const {ethers, upgrades} = require("hardhat");

async function main() {

    const LandNFT = await ethers.getContractFactory("LandNFT");
    const landNFT = await upgrades.deployProxy(LandNFT, {kind: 'uups'});

    await landNFT.deployed();

    console.log("LandNFT deployed to:", landNFT.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
