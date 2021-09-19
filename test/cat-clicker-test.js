const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Cat clicker", function () {
  it("Should create a new cat", async function () {
    const CatClicker = await ethers.getContractFactory("Clicker");
    const clicker = await CatClicker.deploy();
    await clicker.deployed();
  

    expect(await clicker.createRandomCat("sheercat", "http://wallpapercave.com/wp/TxarQV1.jpg"));
    expect(await clicker.createRandomCat("sheercat", "http://wallpapercave.com/wp/TxarQV1.jpg"));
    expect((await clicker.getCats()).length).to.equal(2);
  });

  it("Should add a new click count", async function () {
    const CatClicker = await ethers.getContractFactory("Clicker");
    const clicker = await CatClicker.deploy();
    await clicker.deployed();
  

    expect(await clicker.createRandomCat("sheercat", "http://wallpapercave.com/wp/TxarQV1.jpg"));
    await clicker.updateClick(0)
    await clicker.updateClick(0)
    const cat = (await clicker.getCats())[0];
    expect(cat.clicks).to.equal(2);
  });
});
