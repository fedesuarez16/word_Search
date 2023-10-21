// SPDX-License-Identifier: MIT
// This is a Solidity smart contract for a simple game where players can play and win rewards
// The contract uses encryption to verify the data provided by the players

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IStaking.sol";
import "./EncryptionContract.sol";

contract GameContract is EncryptionContract {
    error Error__NotPlayed();
    error Error__AlreadyPlayed();

    IERC20 public immutable s_stakingToken;
    uint256 public immutable REWARD_AMOUNT;
    uint256 public immutable REWARD_PERCENTAGE;
    IStaking public immutable s_stakingContract;

    /**
     * @dev Event emitted when a player starts a game.
     * @param player The address of the player.
     * @param startTime The timestamp when the game started.
     * @param codedWordArray An array of bytes32 containing the coded word provided by the player.
     */
    event GameStarted(
        address player,
        uint256 startTime,
        bytes32[5] codedWordArray
    );

    /**
     * @dev Event emitted when a player plays the game.
     * @param player The address of the player.
     * @param isWon A boolean indicating if the player has won the game.
     * @param amountWon The total amount won by the player.
     */
    event PlayedGame(
        address indexed player,
        bool indexed isWon,
        uint256 indexed _amountWon
    );


    /**
     * @dev Event emitted when a player claims their game reward.
     * @param player The address of the player.
     * @param amount The amount of the reward claimed by the player.
     */
    event RewardClaimed(address indexed player, uint256 amount);

    constructor(
        uint256 _rewardPercent,
        uint256 _rewardAmount,
        address _stakingToken,
        address _stakingContract,
        bytes32 _secretKey
    ) EncryptionContract(_secretKey) {
        REWARD_PERCENTAGE = _rewardPercent;
        REWARD_AMOUNT = _rewardAmount;
        s_stakingToken = IERC20(_stakingToken);
        s_stakingContract = IStaking(_stakingContract);
    }

    //mapping that stores winners
    address[] private winners;
    //mapping that stores users encryptedword
    mapping(address => bytes32[5]) private userToCodedWordArray;
    //mapping that maps users time of play
    mapping(address => uint256) timeOfPlay;

    /**
     * @dev Allows a player to start a game by providing a coded word array.
     * @param _codedWordArray An array of bytes32 containing the coded word.
     */
    function startGame(bytes32[5] memory _codedWordArray) public {
        //update user's word
        userToCodedWordArray[msg.sender] = _codedWordArray;
        //update user time
        timeOfPlay[msg.sender] = block.timestamp;

        emit GameStarted(msg.sender, block.timestamp, _codedWordArray);
    }


    /**
     * @dev Allows a player to submit their game results for verification and rewards.
     * @param _encryptedWordArray An array of bytes32 containing the encrypted word.
     * @param _wordArray An array of strings representing the player's guess.
     * @return bool True if the player has won the game, false otherwise.
     */
    function playedGame(
        bytes32[5] memory _encryptedWordArray,
        string[5] memory _wordArray
    ) public returns (bool) {
        if (block.timestamp == 0) {
            revert Error__NotPlayed("You have not started the game yet.");
        }
        if (block.timestamp >= timeOfPlay[msg.sender] + 1 days) {
            revert Error__AlreadyPlayed("You have already played in the last 24 hours.");
        }
        uint userStake = s_stakingContract.getStaked(msg.sender);
        uint _payAmount = (REWARD_PERCENTAGE * userStake) / 100;
        s_stakingToken.transfer(msg.sender, _payAmount);
        emit PlayedGame(msg.sender, isWon, _payAmount + REWARD_AMOUNT);

        bool isWon = isCorrect(_encryptedWordArray, _wordArray);
        //check if won
        if (isWon) {
            winners.push(msg.sender);
            s_stakingToken.transfer(msg.sender, REWARD_AMOUNT);
            emit RewardClaimed(msg.sender, REWARD_AMOUNT);
        }
        
    }

    /**
     * @dev Retrieves the list of players who have won the game.
     * @return address[] An array of addresses representing the winners.
     */
    function fetchWinners() public view returns (address[] memory) {
        return winners;
    }

    /**
     * @dev Retrieves the game information of the calling player.
     * @return bytes32[5] An array of bytes32 containing the player's coded word.
     * @return uint256 The time when the player started the game.
     */
    function fetchPlayerInfo()
        public
        view
        returns (bytes32[5] memory, uint256)
    {
        return (userToCodedWordArray[msg.sender], timeOfPlay[msg.sender]);
    }
}
