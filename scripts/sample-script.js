// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
async function deployContract(contractName, args) {
  const Contract = await hre.ethers.getContractFactory(contractName);
  const contract = await Contract.deploy(args);
  await contract.deployed();
  console.log(` ${contractName} deployed to:`, contract.address);
}
async function main() {
  deployContract("Greeter", "Hello, Hardhat!");
  deployContract("CatClicker");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
