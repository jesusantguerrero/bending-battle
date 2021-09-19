//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./CatClicker.sol";

contract Clicker is CatClicker {
    function updateClick(uint _catId) public {
        Cat storage cat = cats[_catId];
        cat.clicks++;
    }

    function updateUrl(uint _catId, string memory _url) public {
        Cat storage cat = cats[_catId];
        cat.url = _url;
    }
}