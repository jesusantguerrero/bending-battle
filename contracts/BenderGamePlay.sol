//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./BendingCharacter.sol";

contract BenderGamePlay is BendingCharacter {
    event AttackAction(string benderName, uint256 damage, string message);
    event FightResult(uint damage, uint damageReceived, string winner);

    struct Level {
        uint min;
        uint max;
    }

    uint256 levelUpFee = 0.001 ether; 
    uint randNonce = 0;
    uint bonusLevel = 5;
    Level[] levels;

    constructor() {
        levels.push(Level(0, 100));
        levels.push(Level(100, 1000));
        levels.push(Level(1000, 10000));
        levels.push(Level(10000, 100000));
    }

    function getLevel(uint _benderId) view public returns(uint) {
        uint level;
        Bender memory bender = benders[_benderId];
        for (uint i = 0; i < levels.length; i++) {
            if (levels[i].min >= bender.HP && levels[i].max <= bender.HP) {
                level = i+1;
            }
        }
        return level;
    }

    function _triggerCoolDown(Bender storage _bender) internal {
        _bender.readyAt = uint32(block.timestamp + cooldownTime);
    }

    function levelUp(uint _benderId) external payable {
        require(msg.value == levelUpFee);
        benders[_benderId].HP += 10;
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function _isReady(Bender storage _bender) internal view returns (bool) {
        return (_bender.readyAt <= block.timestamp);
    }

    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function sendAttack(Bender storage _bender, Bender storage _enemy) internal returns(uint, string memory) {
        Attack[] memory myAttacks = getBenderAttacks(_bender.tokenId);
        Attack memory attack = myAttacks[0];
        uint level = getLevel(_bender.tokenId);
        uint damage = randMod(attack.maxDamage + (level * bonusLevel));
        _bender.health -= attack.cost;
        _bender.chi -= attack.cost;
        _enemy.health -= damage;
        return (damage, attack.name);
    }

    function fight(uint _benderId, uint _targetId) public onlyOwnerOf(_benderId) {
        Bender storage myBender = benders[_benderId];
        Bender storage target = benders[_targetId];
        require(_isReady(myBender), "Bender is not ready");
        string memory attackName;
        string memory enemyAttackName;
        uint myAttack; 
        uint enemyAttack;
        (myAttack, attackName) = sendAttack(myBender, target);
        (enemyAttack, enemyAttackName) = sendAttack(target, myBender);
        string memory winner;
       
        if (myAttack > enemyAttack) {
            myBender.record.wins++;
            myBender.points+=uint16(myAttack);
            target.record.losses++;
            winner = myBender.name;
        } else {
            winner = target.name;
            myBender.record.losses++;
            target.points+=uint16(enemyAttack);
            target.record.wins++;            
        }
        myBender.HP+=myAttack;
        target.HP+=enemyAttack;
        _triggerCoolDown(myBender);
        emit AttackAction(myBender.name, myAttack, attackName);
        emit AttackAction(target.name, enemyAttack, enemyAttackName);
        emit FightResult(myAttack, enemyAttack, winner);
    }

}