const hre = require('hardhat')
const ethers = hre.ethers

async function main() {
    const accounts = await ethers.getSigners();
    const ERC20 = await ethers.getContractFactory("ERC20", accounts[5]);
    const erc20 = await ERC20.deploy("Bubble", "BBL");
    await erc20.deployed();

    console.log("ERC20 has been deployed to the address: ", erc20.address);

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });