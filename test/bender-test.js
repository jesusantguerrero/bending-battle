const { expect } = require("chai");
const { ethers } = require("hardhat");
const { setupContract } = require("../scripts/setupBendingBattle");

describe("Crypto avatar: the last crypto bender", function () {
  let avatar = null;
  let owner, user2;
  beforeEach(async function () {
    const Avatar = await ethers.getContractFactory("BenderOwnership");
    avatar = await Avatar.deploy();
    await setupContract(avatar, false);
    [owner, user2] = await ethers.getSigners();
  });

  it("Default attacks should have been created", async function () {
    await avatar.deployed();
    expect((await avatar.getAttacks()).length).to.equal(4);
  });

  it("Should create a new bender", async function () {
    await avatar.deployed();

    expect(await avatar.createRandomBender("Aang", "air"));
    expect((await avatar.getBenders()).length).to.equal(1);
    expect((await avatar.getBenderAttacks(0)).length).to.equal(1);
  });

  it("Should fight with the next bender", async () => {
    await avatar.deployed();

    const trx = await avatar.createRandomBender("Aang", "air");
    const trx2 = await avatar.connect(user2).createRandomBender("Sokka", "fire");

    trx.wait();
    trx2.wait();

    await avatar.fight(0, 1);
    const benders = await avatar.getBenders();
    expect(benders.length).to.equal(2);
    expect(benders.map(bender => bender.record.wins.toNumber()).sort()).to.deep.equal([0, 1]);
  });

  it("Should get benders by owner", async () => {
    await avatar.deployed();

    await avatar.createRandomBender("Aang", "air");
    await avatar.connect(user2).createRandomBender("Sokka", "fire");

    const ownedByMe = await avatar.getBendersByOwner(owner.address);
    expect(ownedByMe.length).to.equal(1);
  })
});
