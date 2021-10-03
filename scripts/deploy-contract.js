const hre = require("hardhat");

const deployContract = async (contractName, args = null) => {
  const Contract = await hre.ethers.getContractFactory(contractName);
  const contract = await Contract.deploy(args);
  await contract.deployed();
  console.log(`${contractName} deployed to:`, contract.address);
}

module.exports.deployContract = deployContract;