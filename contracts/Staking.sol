// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

error Staking__TransferFailed();
error Withdraw__TransferFailed();
error Staking__NeedsMoreThanZero();

/**
 * @title Staking
 * @dev A Solidity smart contract for staking and withdrawing tokens with rewards.
 */
contract Staking is ReentrancyGuard {
    IERC20 public s_stakingToken;
    // IGameContract public s_gameContract;

    /** @dev Mapping from address to the amount the user has staked */
    mapping(address => uint256) s_balances;
    uint256 public s_totalSupply;

    /**
     * @dev Throws if the specified amount is zero.
     * @param amount The amount to check.
     */
    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert Staking__NeedsMoreThanZero();
        }
        _;
    }

    /**
     * @dev Constructor to initialize the Staking contract.
     * @param stakingToken The address of the ERC20 token used for staking.
     */
    constructor(address stakingToken) {
        s_stakingToken = IERC20(stakingToken);
        // s_gameContract = IGameContract(_gameContract);
    }

    //neccessary events
    event Staked(address indexed staker, uint256 indexed amount);
    event StakeWithdrawn(address indexed staker, uint256 indexed amount);
    event RewardClaimed(address indexed staker, uint256 indexed _tokenId);

    /**
     * @dev Stake tokens into the contract.
     * @param amount The amount to stake.
     */
    function stake(uint256 amount) external moreThanZero(amount) {
        // keep track of how much this user has staked
        // keep track of how much token we have total
        // transfer the tokens to this contract
        /** @notice Be mindful of reentrancy attack here */
        s_balances[msg.sender] += amount;
        s_totalSupply += amount;
        //emit event
        bool success = s_stakingToken.transferFrom(
            msg.sender,
            address(this),
            amount
        );
        // require(success, "Failed"); Save gas fees here
        if (!success) {
            revert Staking__TransferFailed();
        }
        emit Staked(msg.sender, amount);
    }

    /**
     * @dev Withdraw staked tokens.
     * @param _amount The amount to withdraw.
     */
    function withdrawStaked(uint _amount) external moreThanZero(_amount) {
        s_balances[msg.sender] -= _amount;
        s_totalSupply -= _amount;
        // emit event
        bool success = s_stakingToken.transfer(msg.sender, _amount);
        if (!success) {
            revert Withdraw__TransferFailed();
        }
        emit StakeWithdrawn(msg.sender, _amount);
    }

    /**
     * @dev Get the amount staked by an account.
     * @param account The address of the account.
     * @return The amount staked by the account.
     */
    function getStaked(address account) public view returns (uint256) {
        return s_balances[account];
    }
}
