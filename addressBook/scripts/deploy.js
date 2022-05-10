const hre = require("hardhat")
const ethers = hre.ethers;


async function main() {
    const [signer1, singer2] = await ethers.getSigners();

    const AddressBook = await ethers.getContractFactory("addressBook", signer1);
    const addressBook =  await AddressBook.deploy();

    await addressBook.deployed();

    console.log("Address Book deployed to: ", addressBook.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
