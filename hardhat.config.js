require('dotenv').config();
const config = require("./config");
require("@nomiclabs/hardhat-waffle");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  networks: {
    hardhat: {
      chainId: 1337,
    },
    mumbai: {
      url: config.mumbai,
      accounts: [config.privateKey],
    },
    mainnet: {
      url: config.mainnet,
      accounts: [config.privateKey],
    },
  },
  solidity: "0.8.4",

};
