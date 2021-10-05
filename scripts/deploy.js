require('dotenv');
const { deployContract } = require('./deploy-contract');
const heroes = [
  {
    name: 'Roku',
    element: 'fire'
}, {
  name: 'Aang',
  element: 'air'
},
{
  name: 'Todth',
  element: 'earth'
}, {
  name: 'Korra',
  element: 'water'
}];


async function createHeroes(contract) {
  for (hero of heroes) {
    await contract.mintBender(hero.name, hero.element)
    console.log(`Hero ${hero.name} bender of ${hero.element} has been created \n`)
  }
}

async function main() {
  await deployContract("BenderOwnership", null, "VITE_BENDING_ADDRESS").then(createHeroes);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
