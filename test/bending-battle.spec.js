const { expect } = require("chai");
const { ethers } = require("hardhat");
const { setupContract } = require("../scripts/setupBendingBattle");

let avatar = null;
let market = null;

const setContracts = async () => {
  const Market = await ethers.getContractFactory("BendingNFTMarket");
  const Avatar = await ethers.getContractFactory("BendingNFT");
  market = await Market.deploy();
  avatar = await Avatar.deploy(market.address);
  await avatar.deployed();
  await market.deployed();
  await setupContract(avatar, false);
  return {
    avatar, 
    market
  }
}

describe("Crypto avatar: the last crypto bender", function () {
  let owner, user2;
  const attributes = {
    strength: 5,
    speed: 5,
    agility: 5,
    chi: 5,
  };

  beforeEach(async () => {
    await setContracts();
    [owner, user2] = await ethers.getSigners();
  });

  it("Default attacks should have been created", async function () {
    expect((await avatar.getAttacks()).length).to.equal(4);
  });

  it("Should return the default bending attributes", async function () {
    const bending = await avatar.getBending('fire', attributes);
    expect(Object.values(bending).length).to.equal(8);
  });

  it("Should create a new bender", async function () {
    expect(await avatar.createRandomBender("Aang", "air", attributes));
    expect((await avatar.getBenders()).length).to.equal(1);
    expect((await avatar.getBender(0)).name).to.equal("Aang");
    expect((await avatar.getBenderAttacks(0)).length).to.equal(1);
  });

  it("Should fight with the next bender", async () => {
    await avatar.deployed();

    const trx = await avatar.createRandomBender("Aang", "air", attributes);
    const trx2 = await avatar.connect(user2).createRandomBender("Sokka", "fire", attributes);

    trx.wait();
    trx2.wait();

    await avatar.fight(0, 1);
    const benders = await avatar.getBenders();
    expect(benders.length).to.equal(2);
    expect(benders.map(bender => bender.record.wins.toNumber()).sort()).to.deep.equal([0, 1]);
  });

  it("Should get benders by owner", async () => {
    await avatar.deployed();

    await avatar.createRandomBender("Aang", "air", attributes);
    await avatar.connect(user2).createRandomBender("Sokka", "fire", attributes);

    const ownedByMe = await avatar.getMyBenders();
    expect(ownedByMe.length).to.equal(1);
  })
});


describe("Crypto avatar: NFT's functionality", function () {
  let owner, user2;
  const attributes = {
    strength: 5,
    speed: 5,
    agility: 5,
    chi: 5,
  };

  beforeEach(async () => {
    await setContracts();
    [owner, user2] = await ethers.getSigners();
    await avatar.createRandomBender("Aang", "air", attributes);
  });
  
  
  it("Should get the right owner and balance", async function () {
    expect(await avatar.ownerOf(0)).to.equal(owner.address);
    expect(await avatar.balanceOf(owner.address)).to.equal(1);
  });

  it("Should be able to transfer token", async function () {
    await avatar.transferFrom(owner.address, user2.address, 0)
    expect(await avatar.ownerOf(0)).to.equal(user2.address);
    expect(await avatar.balanceOf(user2.address)).to.equal(1);
    expect(await avatar.balanceOf(owner.address)).to.equal(0);
  });
});


describe("Crypto avatar: NFT's Market functionality", function () {
  let owner, user2;
  const attributes = {
    strength: 5,
    speed: 5,
    agility: 5,
    chi: 5,
  };

  beforeEach(async function () {
    await setContracts();
    [owner, user2] = await ethers.getSigners();
    await avatar.createRandomBender("Aang", "air", attributes);
    
  });
  
  
  it("Should be able to create a market item", async function () {
    const listingPrice = await market.getListingPrice();
    expect((await market.getMyCreatedNFTs()).length).to.equal(0);
    await market.createMarketItem(avatar.address, 0, ethers.utils.parseEther("0.05"), { value: listingPrice });
    expect((await market.getMyCreatedNFTs()).length).to.equal(1);
    
    expect((await market.getMarketItems()).length).to.equal(1);
    
    market.connect(user2).createMarketSale(avatar.address, 1, { value: ethers.utils.parseEther("0.05") })
    expect((await market.connect(user2).getMyNFTs()).length).to.equal(1);
    
    // The initial seller should  0
    expect((await market.getMyNFTs()).length).to.equal(0);
    
    // The new owner should have 1
    expect((await market.connect(user2).getMyNFTs()).length).to.equal(1);
    //  The market place should have 0
    expect((await market.getMarketItems()).length).to.equal(0);
    expect((await avatar.getBender(0))).to.exist;

    // sell and buy back
    market.connect(user2).resellMarketItem(avatar.address, 1, ethers.utils.parseEther("0.10"), { value: listingPrice })
    expect((await market.connect(user2).getMyNFTs()).length).to.equal(0);
    market.createMarketSale(avatar.address, 1, { value: ethers.utils.parseEther("0.10") })
    expect((await market.getMyNFTs()).length).to.equal(1);
  });
});