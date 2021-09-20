//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./CatClicker.sol";

contract Clicker is CatClicker {

    function _triggerCoolDown(Cat storage _cat) internal {
        _cat.readyAt = uint32(block.timestamp + cooldownTime);
    }

    function _isReady(Cat storage _cat) internal view returns (bool) {
        return (_cat.readyAt <= block.timestamp);
    }

    function updateClick(uint _catId) public {
        Cat storage cat = cats[_catId];
        require(_isReady(cat));
        cat.clicks++;
        _triggerCoolDown(cat);
    }

    function updateUrl(uint _catId, string memory _url) public {
        Cat storage cat = cats[_catId];
        cat.url = _url;
    }
}