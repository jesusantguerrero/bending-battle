const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Cat clicker", function () {
  it("Should create a new cat", async function () {
    const CatClicker = await ethers.getContractFactory("CatClicker");
    const clicker = await CatClicker.deploy();
    await clicker.deployed();
  

    expect(await clicker.createRandomCat("sheercat", "http://wallpapercave.com/wp/TxarQV1.jpg"));
    expect(await clicker.createRandomCat("sheercat", "http://wallpapercave.com/wp/TxarQV1.jpg"));
    expect((await clicker.getCats()).length).to.equal(2);
  });
});
