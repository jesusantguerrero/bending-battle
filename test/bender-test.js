const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Crypto avatar: the last crypto bender", function () {
  let avatar = null;
  let owner, user2;
  beforeEach(async function () {
    const Avatar = await ethers.getContractFactory("BenderOwnership");
    avatar = await Avatar.deploy();
    [owner, user2] = await ethers.getSigners();
  });

  it("Should create a new bender", async function () {
    await avatar.deployed();

    expect(await avatar.createRandomBender("Aang", "air"));
    expect((await avatar.getBenders()).length).to.equal(1);
  });

  it("Should fight with the next bender", async () => {
    await avatar.deployed();

    await avatar.createRandomBender("Aang", "air");
    await avatar.connect(user2).createRandomBender("Sokka", "fire");

    await avatar.fight(0, 1);
    const benders = await avatar.getBenders();
    expect(benders.length).to.equal(2);
    expect(benders.map(bender => bender.wins).sort()).to.deep.equal([0, 1]);
  })
});
