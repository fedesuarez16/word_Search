// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RewardItem is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("RewardItem", "TW") {}

    function awardItem(address player, string memory _tokenURI) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        return newItemId;
    }

    // Redeem an item and burn it
    function redeemItem(uint256 itemId) public returns (bool) {
        require(_exists(itemId), "Item does not exist");
        require(ownerOf(itemId) == msg.sender, "Item does not belong to you");

        _burn(itemId);

        return true;
    }
}
