// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers }  = require("hardhat");
const randomNumberJson = require('../artifacts/contracts/RandomNumber.sol/RandomNumber.json')

async function main() {

    const abi = randomNumberJson.abi
    const provider = new ethers.providers.InfuraProvider("rinkeby", process.env.RINKEBY_PROJECT_ID);
    // const provider = new ethers.providers.getDefaultProvider() //  .JsonRpcProvider(process.env.XSC_URL)
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider)
    const signer = wallet.connect(provider)
    const randomNumber = new ethers.Contract(process.env.RANDOM_NUMBER_ADDRESS, abi, signer)

    //let seq = await randomNumber.requestRandomNumber()
    //console.log(`getRandomNumber successfully, seq:: ${seq}`);

    let rn = await randomNumber.getRandomResult(1)
    console.log(`randomResult:: ${rn}`);
}

//deployed: 0x20157387A08a6b19C726Dc149dDFc4ba0AAf2ac2

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

// npx hardhat run scripts/getRandomNumber.js
