require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

module.exports = {
  defaultNetwork: "rinkeby",
  solidity: {
    version: "0.8.11",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    ethereum:{
      url: process.env.ETHEREUM_URL,
      accounts:[process.env.PRIVATE_KEY],
      gasPrice:16,
    },
    rinkeby: {
      url: process.env.RINKEBY_URL,
      accounts:[process.env.PRIVATE_KEY],
    },
    mumbai: {
      url: process.env.MUMBAI_URL,
      accounts:[process.env.PRIVATE_KEY],
    },
    bsc_testnet: {
      url: process.env.BSC_TESTNET_URL,
      accounts:[process.env.PRIVATE_KEY],
    },
    bsc: {
      url: process.env.BSC_URL,
      accounts:[process.env.PRIVATE_KEY],
    },
    xsc: {
      url: process.env.XSC_URL,
      accounts:[process.env.PRIVATE_KEY],
    },
    xsc_testnet: {
      url: process.env.XSC_TESTNET_URL,
      accounts:[process.env.PRIVATE_KEY],
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
};
