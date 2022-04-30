const hre = require('hardhat')
const ethers = hre.ethers
const transfersArtifact = require('../artifacts/contracts/Transfers.sol/Transfers.json')

async function currentBalance(address, msg = ''){
    const rawBalance = await ethers.provider.getBalance(address)
    console.log(msg, ethers.utils.formatEther(rawBalance))
}

async function main() {
    const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3'
    const [signer1, signer2] = await ethers.getSigners()
    const transfersContract = new ethers.Contract(
        contractAddress,
        transfersArtifact.abi,
        signer1
    )

    // const tx = {
    //     to: contractAddress, 
    //     value: ethers.utils.parseEther("1")
    // }

    // const txSend = await signer2.sendTransaction(tx)
    // await txSend.wait()


    // const result = await transfersContract.getTransfer(0)
    // console.log(result)

    // const withdrawResult = await transfersContract.withdrawTo(signer1.address)
    // console.log(withdrawResult)

    await currentBalance(signer1.address, "Current signer1's balance: ")
    await currentBalance(contractAddress, "Current contract's balance: ")

}





main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
