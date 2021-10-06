//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BenderBase is Ownable {
    uint cooldownTime = 1 minutes; 
    struct Record {
        uint wins;
        uint losses;
    }

    struct Bender {
        uint tokenId;
        uint health;
        uint HP;
        uint64 strength;
        uint64 speed;
        uint64 agility;
        uint32 chi;
        uint32 readyAt;
        Record record;
        uint16 points;
        string name;
        string element;
    }

    Bender[] public benders;
    mapping (uint => address) public benderToOwner;
    mapping (address => uint) ownerBendersCount;

    modifier onlyOwnerOf(uint _benderId) {
        require(msg.sender == benderToOwner[_benderId]);
        _;
    }

    function _isEqual(string memory str1,string memory str2) internal pure returns (bool) {
        return uint(keccak256(abi.encodePacked(str1))) == uint((keccak256(abi.encodePacked(str2)))); 
    }

    function getBenders() public view returns (Bender[] memory) {
        return benders;
    }
}