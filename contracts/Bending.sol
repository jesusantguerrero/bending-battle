//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./BenderBase.sol";

contract Bending is BenderBase {
    uint256 levelUpFee = 0.001 ether; 
    uint randNonce = 0;
    uint bonusLevel = 5;
    function _triggerCoolDown(Person storage _bender) internal {
        _bender.readyAt = uint32(block.timestamp + cooldownTime);
    }

    function levelUp(uint _benderId) external payable {
        require(msg.value == levelUpFee);
        benders[_benderId].level++;
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function _isReady(Person storage _bender) internal view returns (bool) {
        return (_bender.readyAt <= block.timestamp);
    }

    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function sendAttack(Person storage _bender, Person storage _enemy) internal returns(uint) {
        uint damage = randMod(_bender.attack.maxDamage + (_bender.level * bonusLevel));
        _bender.health -= _bender.attack.cost;
        _bender.chi -= _bender.attack.cost;
        _enemy.health -= damage;
        return damage;
    }

    function fight(uint _benderId, uint _targetId) public onlyOwnerOf(_benderId) {
        Person storage myBender = benders[_benderId];
        Person storage target = benders[_targetId];
        require(_isReady(myBender), "Bender is not ready");
        uint myAttack = sendAttack(myBender, target);
        uint enemyAttack = sendAttack(target, myBender);
        myAttack += sendAttack(myBender, target);
        enemyAttack += sendAttack(target, myBender);
        myAttack += sendAttack(myBender, target);
        enemyAttack += sendAttack(target, myBender);

        if (myAttack > enemyAttack) {
            myBender.level++;
            myBender.wins++;
            myBender.points+=uint16(myAttack);
            target.losses++;
        } else {
            myBender.losses++;
            target.points+=uint16(enemyAttack);
            target.wins++;            
        }
        myBender.experience+=myAttack;
        target.experience+=enemyAttack;
        _triggerCoolDown(myBender);
    }

    function getBendersByOwner(address _owner) external view returns (uint[] memory) {
        uint[] memory bendersByOwner = new uint[](ownerBendersCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < benders.length; i++) {
            if (benderToOwner[i] == _owner) {
                bendersByOwner[counter] = i;
                counter++;
            }
        }
        return bendersByOwner;
    }
}