//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./BendingNFTBase.sol";

contract BendingNFT is BendingNFTBase {
    address marketAddress;

    constructor(address _marketAddress) BendingNFTBase("CryptoBenderToken", "CBT") {
        marketAddress = _marketAddress;
    }

    function mintBender(string memory _benderName, string memory _element) external onlyOwner {
        _createBender(_benderName, _element, BendingAttributes(0, 0, 0, 0));
        setApprovalForAll(marketAddress, true);
    }

    function createRandomBender(string memory _benderName, string memory _element, BendingAttributes memory _attributes) public {
        require(ownerBendersCount[msg.sender] == 0, "You can't create more than 1 bender");
        _createBender(_benderName, _element, _attributes);
        setApprovalForAll(marketAddress, true);
    }
}
