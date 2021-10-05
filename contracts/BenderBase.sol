//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BenderBase is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint cooldownTime = 1 minutes; 
    
    struct Attack {
        uint32 maxDamage;
        uint32 minDamage;
        uint32 precision;
        string name;
        string element;  
        uint32 cost;      
    }

    struct Bender {
        uint tokenId;
        uint health;
        uint experience;
        string name;
        uint32 chi;
        uint32 level;
        uint32 readyAt;
        string element;
        Attack attack;
        uint16 wins;
        uint16 losses;
        uint16 points;
    }

    Bender[] public benders;
    mapping (uint => address) public benderToOwner;
    mapping (address => uint) ownerBendersCount;

    modifier onlyOwnerOf(uint _benderId) {
        require(msg.sender == benderToOwner[_benderId]);
        _;
    }

    function _createBender(string memory _name, string memory _element) internal {
        uint benderId = _tokenIds.current();
        benders.push(Bender(benderId, 100, 0, _name, 100, 1, uint32(block.timestamp), _element, _generateRandomAttack(_element), 0, 0, 0));
        benderToOwner[benderId] = msg.sender;
        ownerBendersCount[msg.sender]++;
        _tokenIds.increment();
    }

    function _generateRandomAttack(string memory _element) private pure returns (Attack memory) {
        return Attack(5, 1, 1, "Attack of ", _element, 1);
    }

    function mintBender(string memory _name, string memory _element) external onlyOwner {
        _createBender(_name, _element);
    }

    function createRandomBender(string memory _name, string memory _element) public {
        require(ownerBendersCount[msg.sender] == 0, "You can't create more than 1 bender");
        _createBender(_name, _element);
    }

    function getBenders() public view returns (Bender[] memory) {
        return benders;
    }
}