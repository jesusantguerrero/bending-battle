//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./AvatarBase.sol";

contract AvatarBending is AvatarBase {
     
     function _triggerCoolDown(Person storage _bender) internal {
        _bender.readyAt = uint32(block.timestamp + cooldownTime);
    }

    function _isReady(Person storage _bender) internal view returns (bool) {
        return (_bender.readyAt <= block.timestamp);
    }

    function sendAttack(uint _benderId) public {
        Person storage person = benders[_benderId];
        require(_isReady(person), "Bender is not ready");
        person.attack;
        person.health -= person.attack.cost;
        person.chi -= person.attack.cost;
        _triggerCoolDown(person);
    }
}