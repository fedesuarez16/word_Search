// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

/**
 * @title EncryptionContract
 * @dev This Solidity contract provides functions for encrypting letters and words using a secret key.
 */
contract EncryptionContract {
    // Declare private immutable variable to store secret key
    bytes32 private immutable secretKey;

     /**
     * @dev Constructor to initialize the secret key.
     * @param _secretKey The secret key used for encryption.
     */
    constructor(bytes32 _secretKey) {
        require(_secretKey != 0, "Secret key cannot be empty");
        secretKey = _secretKey;
    }


    /**
     * @dev Function to pick and encrypt characters from a string.
     * @param str The input string from which characters are picked and encrypted.
     * @return pickedChars An array of encrypted characters (bytes32) from the input string.
     */
    function pickCharsFromString(
        string memory str
    ) public view returns (bytes32[5] memory) {
        bytes memory strBytes = bytes(str);
        bytes32[5] memory pickedChars;

        for (uint256 i = 0; i < strBytes.length && i < 5; i++) {
            pickedChars[i] = encryptLetter(
                string(abi.encodePacked(strBytes[i]))
            );
        }

        return pickedChars;
    }

    /**
     * @dev Function to encrypt a single letter using the secret key.
     * @param _letter The letter to be encrypted.
     * @return bytes32 The encrypted representation of the letter.
     */
    function encryptLetter(
        string memory _letter
    ) public view returns (bytes32) {
        // Encrypt letter using the secret key as a salt
        return keccak256(abi.encodePacked(_letter, secretKey));
    }

    /**
     * @dev Function to encrypt a word, which consists of multiple letters.
     * @param _word The word to be encrypted.
     * @return encryptedWordArray An array of encrypted characters (bytes32) from the input word.
     */
    function encryptWord(
        string memory _word
    ) public view returns (bytes32[5] memory) {
        // Encrypt letter using the secret key as a salt
        return pickCharsFromString(_word);
    }

    /**
     * @dev Function to check if an array of encrypted characters matches an array of words.
     * @param _encryptedWordArray An array of encrypted characters (bytes32).
     * @param _wordArray An array of words to compare with the encrypted characters.
     * @return bool A boolean indicating if the encrypted word array matches the word array.
     */
    function isCorrect(
        bytes32[5] memory _encryptedWordArray,
        string[5] memory _wordArray
    ) public view returns (bool) {
        require(_encryptedWordArray.length == _wordArray.length, "Array lengths must match");
        for (uint256 i = 0; i < _wordArray.length; i++) {
            bytes32 encryptedLetter = encryptLetter(_wordArray[i]);
            if (_encryptedWordArray[i] != encryptedLetter) {
                return false;
            }
        }
        return true;
    }
}
