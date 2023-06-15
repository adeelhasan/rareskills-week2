/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-foundry");
require('@openzeppelin/hardhat-upgrades');

require('dotenv').config({ path: __dirname + '/.env' })

module.exports = {
  solidity: "0.8.13",
  networks: {
    hardhat: {
    },
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/" + process.env.ALCHEMY_KEY,
      accounts: [process.env.GOERLI_PK1, process.env.GOERLI_PK1]
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_KEY
  }
};
