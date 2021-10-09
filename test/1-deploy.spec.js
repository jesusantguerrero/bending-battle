const { expect } = require("chai");
const { ethers } = require("hardhat");
const { setupContract } = require("../scripts/setupBendingBattle");

describe("Create and setup the market place", function () { 
  it("Default attacks should have been created", async function () {
    const BenderNFTMarket = await ethers.getContractFactory("BendingNFTMarket");
    const market = await BenderNFTMarket.deploy();
    await market.deployed();
    const BenderNFT = await ethers.getContractFactory("BendingNFT");
    const bender = await BenderNFT.deploy("BenderBattleToken", "BBT");
    await bender.deployed();
    await setupContract(bender, true, market);
    expect((await market.getMarketItems()).length).to.equal(4);
  });
});


