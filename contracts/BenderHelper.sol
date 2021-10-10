//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./BenderBending.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BenderHelper is BenderBending {
    using Counters for Counters.Counter;
    Counters.Counter _tokenIds;

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

    function _getBendersByOf(address _owner) internal view returns (Bender[] memory) {
        Bender[] memory bendersByOwner = new Bender[](ownerBendersCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < benders.length; i++) {
            if (benderToOwner[i] == _owner) {
                bendersByOwner[counter] = benders[i];
                counter++;
            }
        }
        return bendersByOwner;
    }

    function getBendersByOwner(address _owner) external view returns (Bender[] memory) {
        return _getBendersByOf(_owner);
    }

    function getMyBenders() public view returns (Bender[] memory) {
        return _getBendersByOf(msg.sender);
    }
}