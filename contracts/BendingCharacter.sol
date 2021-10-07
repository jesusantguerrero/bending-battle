//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./BendingBase.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BendingCharacter is BendingBase {
    using Counters for Counters.Counter;
    Counters.Counter _tokenIds;

    struct BendingAttributes {
        uint64 strength;
        uint64 speed;
        uint64 agility;
        uint32 chi;
    }

    BendingAttributes airBending = BendingAttributes(3, 10, 10, 15);
    BendingAttributes waterbending = BendingAttributes(5, 5, 5, 20);
    BendingAttributes earthbending = BendingAttributes(10, 7, 5, 10);
    BendingAttributes firebending = BendingAttributes(5, 7, 7, 15);

    function _createBender(string memory _name, string memory _element, BendingAttributes memory initialAttributes) internal {
        uint benderId = _tokenIds.current();
        BendingAttributes memory bending = getBending(_element, initialAttributes);
        benders.push(Bender(benderId, 100, 0, bending.strength, bending.speed, bending.agility, bending.chi, uint32(block.timestamp), Record(0, 0), 0, _name, _element));
        benderToOwner[benderId] = msg.sender;
        ownerBendersCount[msg.sender]++;
        _createBenderAttacks(benderId, _element);
        _tokenIds.increment();
    }

    function getBending(string memory _element, BendingAttributes memory _attributes) view public returns(BendingAttributes memory) {
        BendingAttributes memory bending;
        if (_isEqual(_element, "fire")) {
            bending = firebending;
        } else if (_isEqual(_element, 'earth')) {
            bending = earthbending;
        } else if (_isEqual(_element, 'water')) {
            bending = waterbending;
        } else {
            bending = airBending;
        }

        bending.strength += _attributes.strength;
        bending.speed += _attributes.speed;
        bending.agility += _attributes.agility;
        bending.chi += _attributes.chi;
        return bending;

    }

    function mintBender(string memory _name, string memory _element) external onlyOwner {
        _createBender(_name, _element, BendingAttributes(0, 0, 0, 0));
    }

    function createRandomBender(string memory _name, string memory _element, BendingAttributes memory _attributes) public {
        require(ownerBendersCount[msg.sender] == 0, "You can't create more than 1 bender");
        _createBender(_name, _element, _attributes);
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