const hre = require("hardhat")
const ethers = hre.ethers;


async function main() {

    const [signer1, signer2] = await ethers.getSigners();
    const Hotel = await ethers.getContractFactory("HotelRoom", signer2);
    const hotel = await Hotel.deploy();

    await hotel.deployed();

    console.log("Hotel has been deployed to the: ", hotel.address);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

