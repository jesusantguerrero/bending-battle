const hre = require("hardhat");
const fs = require('fs');
const path = require('path');

const saveEnvVar = (envName, value) => {
  const envFilePath = path.resolve(__dirname, '..' ,'frontend', '.env.local');
  let lines = fs.readFileSync(envFilePath, 'utf8');
  lines = lines.split('\n');
  const index = lines.findIndex(line => line.includes(envName));
  if (index === -1) {
    lines.push(`${envName}=${value}`);
  } else {
    lines.splice(index, 1, `${envName}=${value}`);
  }

  fs.writeFileSync(envFilePath, lines.join('\n'), (err) => {
    if (err) {
      console.log(err);
    }
  });
}

const deployContract = async (contractName, args = null, envName) => {
  const Contract = await hre.ethers.getContractFactory(contractName);
  const contract = await Contract.deploy(args);
  await contract.deployed();
  if (envName) {
    saveEnvVar(envName, contract.address);
  }
  console.log(`${contractName} deployed to:`, contract.address);
}

module.exports.deployContract = deployContract;