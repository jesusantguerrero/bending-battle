//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract CatClicker {
    event NewCat(uint catId, string name, uint dna, string url);
    
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Cat {
        string name;
        uint dna;
        uint clicks;
        string url;
    }

    Cat[] public cats;

    function _createCat(string memory _name, uint _dna, string memory _url) internal {
        cats.push(Cat(_name, _dna, 0, _url));
        uint catId = cats.length - 1;
        emit NewCat(catId, _name, _dna, _url);
    }

    
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRamdomCat(string memory _name, string memory _url) public {
        uint randDna = _generateRandomDna(_name);
        _createCat(_name, randDna, _url);
    }

    function getCats() public view returns (Cat[] memory) {
        return cats;
    }  

}