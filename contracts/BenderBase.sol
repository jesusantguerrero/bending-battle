//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BenderBase is Ownable {
    
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 minutes; 
   
    
    struct Attack {
        uint32 maxDamage;
        uint32 minDamage;
        uint32 precision;
        string name;
        string element;  
        uint32 cost;      
    }

    struct Person {
        string name;
        uint32 chi;
        uint32 level;
        uint32 readyAt;
        uint dna;
        uint health;
        uint experience;
        string element;
        Attack attack;
        uint16 wins;
        uint16 losses;
        uint16 points;
    }

    Person[] public benders;
    mapping (uint => address) public benderToOwner;
    mapping (address => uint) ownerBendersCount;

    modifier onlyOwnerOf(uint _benderId) {
        require(msg.sender == benderToOwner[_benderId]);
        _;
    }

    function _createBender(string memory _name, uint _dna, string memory _element) internal {
        benders.push(Person(_name, 100, 1, uint32(block.timestamp), _dna, 100, 0, _element, _generateRandomAttack(_element), 0, 0, 0));
        uint benderId = benders.length - 1;
        benderToOwner[benderId] = msg.sender;
        ownerBendersCount[msg.sender]++;
    }
    
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function _generateRandomAttack(string memory _element) private pure returns (Attack memory) {
        return Attack(5, 1, 1, "Attack of ", _element, 1);
    }

    function createRandomBender(string memory _name, string memory _element) public {
        require(ownerBendersCount[msg.sender] == 0, "You can't create more than 1 bender");
        uint randDna = _generateRandomDna(_name);
        _createBender(_name, randDna, _element);
    }

    function getBenders() public view returns (Person[] memory) {
        return benders;
    }
}