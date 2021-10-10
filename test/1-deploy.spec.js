const { expect } = require("chai");
const { ethers } = require("hardhat");
const { setupContract } = require("../scripts/setupBendingBattle");

describe("Create and setup the market place", function () { 
  it("Default attacks should have been created", async function () {
    const BenderNFTMarket = await ethers.getContractFactory("BendingNFTMarket");
    const market = await BenderNFTMarket.deploy();
    await market.deployed();
    const BenderNFT = await ethers.getContractFactory("BendingNFT");
    const bender = await BenderNFT.deploy(market.address);
    await bender.deployed();
    await setupContract(bender, true, market);
    const marketItems = await market.getMarketItems();
    expect(marketItems.length).to.equal(4);
    
    const formattedItems = await parseMarketItems(marketItems, bender)
    expect(formattedItems.length).to.equal(4);
    console.log(formattedItems);
  });
});

async function parseMarketItems(marketItems, benderNFT) {
  return await Promise.all(marketItems.map(async (item) => {;
    const bender = await benderNFT.getBender(item.tokenId.toNumber());
    
    return {
      itemId: item.itemId,
      name: 'Item',
      price: ethers.utils.formatEther(item.price),
      priceETH: item.price,
      tokenId: item.tokenId,
      seller: item.seller,
      owner: item.owner,
      name: bender.name,
      element: bender.element
    }
  }));
}


