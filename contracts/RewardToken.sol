// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


/**
 * @title RewardItem
 * @dev A Solidity smart contract for managing reward items as ERC721 tokens.
 */
contract RewardItem is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /**
     * @dev Constructor to initialize the ERC721 contract.
     */
    constructor() ERC721("RewardItem", "TW") {}

    /**
     * @dev Award an item to a player.
     * @param player The address of the player receiving the item.
     * @param _tokenURI The URI for the item's metadata.
     * @return newItemId The ID of the newly created item.
     */    
    function awardItem(
        address player,
        string memory _tokenURI
    ) public returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, _tokenURI);

        _tokenIds.increment();
        return newItemId;
    }

    /**
     * @dev Redeem an item, burning the item and removing it from the player's ownership.
     * @param itemId The ID of the item to be redeemed.
     * @return bool A boolean indicating the success of the redemption process.
     */
    function redeemItem(uint256 itemId) public returns (bool) {
        require(_exists(itemId), "Item does not exist");
        require(ownerOf(itemId) == msg.sender, "Item does not belong to you");

        _burn(itemId);

        return true;
    }
}
