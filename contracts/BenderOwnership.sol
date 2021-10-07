//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./BenderGamePlay.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract BenderOwnership is BenderGamePlay, ERC165, IERC721 {
    string private _name;
    string private _symbol;

    mapping(uint256 => address) bendersApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

     /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

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
    ) external override {
        require(benderToOwner[_tokenId] == msg.sender || bendersApprovals[_tokenId] == msg.sender);
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) override external onlyOwnerOf(_tokenId) {
        bendersApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

   
    function getApproved(uint256 _tokenId) override external view returns (address operator) {
        require(benderToOwner[_tokenId] != address(0), "ERC721: approved query for nonexistent token");
        bendersApprovals[_tokenId];
    }


    function setApprovalForAll(address operator, bool _approved) override external {
        require(operator != msg.sender, "ERC721: approve to caller");
        _operatorApprovals[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);
    }

    function isApprovedForAll(address owner, address operator) override external view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) override external {
        _transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata _data
    ) override external {
        _transfer(_from, _to, _tokenId);
    }
}
