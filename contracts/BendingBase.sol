pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./BenderBase.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BendingBase is BenderBase {
    struct Attack {
        uint32 minDamage;
        uint32 maxDamage;
        uint32 precision;
        uint32 cost; 
        string name;
        string element;  
        uint price;      
    }

    struct BenderAttack {
        uint benderId;
        uint attackId;
        Attack attack;
    }

    Attack[] attacks;
    BenderAttack[] benderAttacks;
    
    mapping (uint => uint) benderAttacksCount;
    mapping (uint => uint) benderAttackToBender;

    function setAttackToBender(uint _benderId, uint _attackId) internal {
        benderAttacksCount[_benderId]++;
        benderAttacks.push(BenderAttack(_benderId, _attackId, attacks[_attackId]));
        uint benderAttackId = benderAttacks.length;
        benderAttackToBender[benderAttackId] = _benderId;
    }

    function createAttack(
        uint32 _minDamage, 
        uint32 _maxDamage,  
        uint32 _precision, 
        uint32 _cost, 
        string memory _name, 
        string memory _element,  
        uint _price
    ) external onlyOwner {
        attacks.push(Attack(_minDamage, _maxDamage, _precision, _cost, _name, _element, _price));
    }

    function _createBenderAttacks(uint _benderId, string memory _element) internal {
        uint index = 0;
        if (_isEqual(_element, "water")) {
            index = 1;
        } else if (_isEqual(_element, "earth")) {
            index = 2;
        } else if (_isEqual(_element, "fire")) {
            index = 3;
        }
        setAttackToBender(_benderId, index);
    }

    function getBenderAttacks(uint _benderId) public view returns (Attack[] memory) {
        Attack[] memory myAttacks = new Attack[](benderAttacksCount[_benderId]);
        uint counter = 0;
        
        for (uint i = 0; i < benders.length; i++) {
            if (benderAttackToBender[i] == _benderId) {
                myAttacks[counter] = benderAttacks[i].attack;
                counter++;
            }
        }
        return myAttacks;
    }
}