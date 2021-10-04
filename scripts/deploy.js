const { deployContract } = require('./deploy-contract');

async function main() {
  await deployContract("BenderOwnership", null, "VITE_BENDING_ADDRESS");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
