//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Erc721.sol";
import "./AvatarBending.sol";

contract AvatarOwnership is AvatarBending, ERC721 {
    mapping(uint256 => address) bendersApprovals;

    function balanceOf(address _owner)
        external
        view
        override
        returns (uint256)
    {
        return ownerBendersCount[_owner];
    }

    function ownerOf(uint256 _tokenId)
        external
        view
        override
        returns (address)
    {
        return benderToOwner[_tokenId];
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) private {
        ownerBendersCount[_to]++;
        ownerBendersCount[_from]--;
        benderToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable override {
        require(
            bendersApprovals[_tokenId] == msg.sender ||
                bendersApprovals[_tokenId] == msg.sender
        );
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) override external payable onlyOwnerOf(_tokenId) {
        bendersApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}
