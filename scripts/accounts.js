const { ethers } = require("hardhat");

const main = async () => {
  const accounts = await ethers.provider.listAccounts()
  accounts.forEach(async(account, index) => {
    console.log(`Account ${index}: ${account} \n\n`);
  });
}
main()