const hre = require('hardhat');
const ethers = hre.ethers;
const sampleArtifact = require("../artifacts/contracts/sample.sol/sample.json");
const utils = ethers.utils;

async function main() {

    const contractAddress = "0x0116686E2291dbd5e317F47faDBFb43B599786Ef";
    const [signer1, signer2] = await ethers.getSigners();

    const sampleContract = new ethers.Contract(
        contractAddress, 
        sampleArtifact.abi,
        signer1
    )

    await sampleContract.setName(utils.formatBytes32String("Hello, World!"));
    const result = utils.parseBytes32String(await sampleContract.getName());
    console.log(result);


}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
