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

    function _createBender(string memory _name, string memory _element) internal {
        uint benderId = _tokenIds.current();
        BendingAttributes memory bending = _getBending(_element);
        benders.push(Bender(benderId, 100, 0, bending.strength, bending.speed, bending.agility, bending.chi, uint32(block.timestamp), Record(0, 0), 0, _name, _element));
        benderToOwner[benderId] = msg.sender;
        ownerBendersCount[msg.sender]++;
        _createBenderAttacks(benderId, _element);
        _tokenIds.increment();
    }

    function _getBending(string memory _element) private returns(BendingAttributes memory) {
        if (_isEqual(_element, "fire")) {
            return firebending;
        } else if (_isEqual(_element, 'earth')) {
            return earthbending;
        } else if (_isEqual(_element, 'water')) {
            return waterbending;
        } else {
            return airBending;
        }
    }

    function mintBender(string memory _name, string memory _element) external onlyOwner {
        _createBender(_name, _element);
    }

    function createRandomBender(string memory _name, string memory _element) public {
        require(ownerBendersCount[msg.sender] == 0, "You can't create more than 1 bender");
        _createBender(_name, _element);
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