// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title TLCToken
 * @dev A Solidity smart contract for the TLC (TLCToken) ERC20 token.
 */
contract TLCToken is ERC20 {
    uint256 private constant MAX_SUPPLY = 100000000;
    uint256 private constant NINETY_FIVE_PERCENT = (MAX_SUPPLY * 95) / 100;

    address private _deployer;

    /**
     * @dev Constructor to initialize the TLCToken contract and mint the total supply.
     */
    constructor() ERC20("TLCToken", "TLC") {
        _deployer = msg.sender;
        _mint(_deployer, MAX_SUPPLY);
    }

    /**
     * @dev Send 95% of the total supply to the specified recipient.
     * @param recipient The address of the recipient.
     */
    function send95PercentTo(address recipient) public {
        require(
            msg.sender == _deployer,
            "Only deployer can call this function"
        );
        _transfer(_deployer, recipient, NINETY_FIVE_PERCENT);
    }
}
