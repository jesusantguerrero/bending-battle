const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Crypto avatar: the last crypto bender", function () {
  it("Should create a new bender", async function () {
    const Avatar = await ethers.getContractFactory("AvatarFactory");
    const avatar = await Avatar.deploy();
    await avatar.deployed();
  

    expect(await avatar.createRandomBender("Aang", "air"));
    expect((await avatar.getBenders()).length).to.equal(1);
  });
});
