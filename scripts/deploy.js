require("dotenv");
const { deployContract } = require("./deploy-contract");
const { setupContract } = require("./setupBendingBattle");

async function main() {
  const market = await deployContract("BendingNFTMarket", null, "VITE_BENDING_MARKET_ADDRESS");
  await deployContract("BendingNFT", [market.address], "VITE_BENDING_ADDRESS").then(
    (contract) => setupContract(contract, false, market)
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
