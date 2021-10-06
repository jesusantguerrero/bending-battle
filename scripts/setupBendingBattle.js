
const heroes = [
  {
    name: "Aang",
    element: "air",
    attack: {
      minDamage: 1,
      maxDamange: 3,
      precision: 7,
      cost: 2,
      name: 'Air Bumb',
      element: 'air',
      price: 0
    }
  },
  {
    name: "Korra",
    element: "water",
    attack: {
      minDamage: 1,
      maxDamange: 6,
      precision: 10,
      cost: 2,
      name: 'Water Attack',
      element: 'water',
      price: 0
    }
  },
  {
    name: "Todth",
    element: "earth",
    attack: {
      minDamage: 1,
      maxDamange: 8,
      precision: 7,
      cost: 4,
      name: 'Earth Block',
      element: 'earth',
      price: 0
    }
  },
  {
    name: "Roku",
    element: "fire",
    attack: {
      minDamage: 1,
      maxDamange: 10,
      precision: 5,
      cost: 1,
      name: 'Fire Bumb',
      element: 'fire',
      price: 0
    }
  },
];

async function setupContract(contract, createBenders = true) {
  for (hero of heroes) {
    const { minDamage, maxDamange, precision, cost, name, element, price } = hero.attack;
    await contract.createAttack(minDamage, maxDamange, precision, cost, name, element, price);
    if (createBenders) {
      await contract.mintBender(hero.name, hero.element);
    }
  }
}

module.exports.setupContract = setupContract;