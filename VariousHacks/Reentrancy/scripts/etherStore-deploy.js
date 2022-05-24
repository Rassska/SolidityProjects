const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {

  const EtherStore = await ethers.getContractFactory("EtherStore");
  const etherStore = await EtherStore.deploy();

  await etherStore.deployed();

  console.log("EtherStore deployed to:", etherStore.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
