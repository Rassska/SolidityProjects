const hre = require("hardhat");
const ethers = hre.ethers
const greeterArtifact = require("../artifacts/contracts/Greeter.sol/Greeter.json")

async function main() {


    const [signer1, signer2] = await ethers.getSigners()
    const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"

    const greeter = new ethers.Contract(
        contractAddress,
        greeterArtifact.abi,
        signer1
    )

    const result = await greeter.greet()
    console.log(result)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

