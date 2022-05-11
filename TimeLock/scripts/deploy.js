const hre = require("hardhat")
const ethers = hre.ethers

async function main() {
    const accounts = await ethers.getSigners();
    const TimeLock = await ethers.getContractFactory("TimeLock", accounts[5]);
    const timeLock = await TimeLock.deploy()
    await timeLock.deployed();

    console.log("Time Lock has been deployed to the: ", timeLock.address);
    
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });