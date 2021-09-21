//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./AvatarBase.sol";

contract AvatarBending is AvatarBase {
    uint256 levelUpFee = 0.001 ether; 
    uint randNonce = 0;
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
        uint damage = randMod(_bender.attack.maxDamage);
        _bender.health -= _bender.attack.cost;
        _bender.chi -= _bender.attack.cost;
        _enemy.health -= damage;
        return damage;
    }

    function fight(uint _benderId, uint _targetId) public ownerOf(_benderId) {
        Person storage myBender = benders[_benderId];
        Person storage target = benders[_targetId];
        require(_isReady(myBender), "Bender is not ready");
        uint myAttack = sendAttack(myBender, target);
        uint enemyAttach = sendAttack(target, myBender);

        if (myAttack > enemyAttach) {
            myBender.level++;
            myBender.wins++;
            target.losses++;
        } else {
            myBender.losses++;
            target.wins++;            
        }
        _triggerCoolDown(myBender);
    }
}