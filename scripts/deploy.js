require("dotenv");
const { deployContract } = require("./deploy-contract");
const { setupContract } = require("./setupBendingBattle");

async function main() {
  await deployContract("BendingNFT", ["CryptoBender", "BBT"], "VITE_BENDING_ADDRESS").then(
    setupContract
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
