//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Potato {
    string public name = "Potato Token";
    string public symbol = "POT";
    uint256 public totalSupply = 1;
    mapping(address => Player) playerAddressMap;
    address[] public addressArray;
    bool game;
    uint startTime;
    uint len;

    struct Player {
        string username;
        // bool hasPotato;
        uint balance;
        uint256 score;
        uint256 receivedToken;
        bool startedGame;
    }

    constructor(string memory _username, uint _len) {
        Player memory first = Player({
            username: _username,
            // hasPotato: true,
            balance: 1,
            score: 0,
            receivedToken: block.timestamp,
            startedGame: true
        });

        playerAddressMap[msg.sender] = first;
        addressArray.push(msg.sender);
        game = true;
        startTime = block.timestamp;
        len = _len;
    }

    function transfer(address to) public checkGameRunning {
        // require(playerAddressMap[msg.sender].hasPotato, "You don't have it");
        require(
            playerAddressMap[msg.sender].balance == 1,
            "You don't have the potato"
        );
        require(playerExists(to), "This player is not in the game");
        require(msg.sender != to, "Why are you sending it to yourself?");
        playerAddressMap[msg.sender].score = stopCounter(
            msg.sender,
            block.timestamp,
            playerAddressMap[msg.sender].receivedToken
        );
        // playerAddressMap[msg.sender].hasPotato = false;
        playerAddressMap[msg.sender].balance = 0;
        // playerAddressMap[to].hasPotato = true;
        playerAddressMap[to].balance = 1;
        initCounter(to);
    }

    function getRandomAddress(
        address sender
    ) internal view returns (address random) {
        uint arrayLength = addressArray.length;
        uint digits = 0;
        while (arrayLength != 0) {
            arrayLength /= 10;
            digits++;
        }
        uint mod = 10 * digits;
        uint rNumber = playerAddressMap[sender].receivedToken % mod;
        if (rNumber >= addressArray.length) {
            rNumber = addressArray.length - 1;
        }
        if (sender == addressArray[rNumber]) {
            if (rNumber == 0) {
                rNumber++;
            } else if (rNumber == addressArray.length - 1) {
                rNumber--;
            }
        }
        return addressArray[rNumber];
    }

    //
    function transferRandom() public checkGameRunning {
        // require(playerAddressMap[msg.sender].hasPotato, "You don't have it");
        require(
            playerAddressMap[msg.sender].balance == 1,
            "You don't have the potato"
        );
        //to=randomaddress
        address to = getRandomAddress(msg.sender);
        playerAddressMap[msg.sender].score = stopCounter(
            msg.sender,
            block.timestamp,
            playerAddressMap[msg.sender].receivedToken
        );
        // playerAddressMap[msg.sender].hasPotato = false;
        playerAddressMap[msg.sender].balance = 0;
        // playerAddressMap[to].hasPotato = true;
        playerAddressMap[to].balance = 1;
        initCounter(to);
    }

    function addPlayers(string memory username) public checkGameRunning {
        require(!playerExists(msg.sender), "You are already in the game.");
        //require(key==msg.sender, "You can't add someone else to the game");
        Player memory player = Player({
            username: username,
            score: 0,
            // hasPotato: false,
            balance: 0,
            receivedToken: 0,
            startedGame: false
        });
        playerAddressMap[msg.sender] = player;
        addressArray.push(msg.sender);
    }

    function getPlayerInfo(address key) public view returns (Player memory) {
        return playerAddressMap[key];
    }

    function getAllPlayers() public view returns (Player[] memory) {
        Player[] memory playerArray = new Player[](addressArray.length);
        for (uint i = 0; i < addressArray.length; i++) {
            playerArray[i] = playerAddressMap[addressArray[i]];
        }
        return playerArray;
    }

    function initCounter(address key) internal {
        playerAddressMap[key].receivedToken = block.timestamp;
    }

    function stopCounter(
        address key,
        uint newTimestamp,
        uint oldTimestamp
    ) internal view returns (uint newScore) {
        newScore = playerAddressMap[key].score + (newTimestamp - oldTimestamp);
    }

    //works
    function balanceOf(
        address account
    ) public view checkGameRunning returns (/*bool*/ uint) {
        // return playerAddressMap[account].hasPotato;
        return playerAddressMap[account].balance;
    }

    function playerExists(address a) internal view returns (bool b) {
        b = false;
        for (uint i = 0; i < addressArray.length; i++) {
            if (addressArray[i] == a) {
                b = true;
            }
        }
    }

    function finishGame() public checkGameRunning {
        require(
            playerAddressMap[msg.sender].startedGame,
            "You are not allowed to finish the game"
        );
        //uint hour = 3600;
        //better way of calculating because receivedToken changes a lot
        uint timePassed = block.timestamp - startTime;
        require(timePassed >= len, "It is not time yet.");
        //calculate final score
        for (uint i = 0; i < addressArray.length; i++) {
            if (playerAddressMap[addressArray[i]].balance == 1) {
                playerAddressMap[addressArray[i]].score = stopCounter(
                    addressArray[i],
                    block.timestamp,
                    playerAddressMap[addressArray[i]].receivedToken
                );
            }
        }
        game = false;
    }

    function getWinner() public view returns (string memory) {
        require(!game, "It's not over yet!!!");
        uint min = block.timestamp;
        string memory winner;
        for (uint i = 0; i < addressArray.length; i++) {
            if (playerAddressMap[addressArray[i]].score < min) {
                min = playerAddressMap[addressArray[i]].score;
                winner = playerAddressMap[addressArray[i]].username;
            }
        }
        return
            string.concat(
                "The winner is: ",
                winner,
                "! With an incredible score of: ",
                Strings.toString(min)
            );
    }

    function getAddressArray() public view returns (address[] memory) {
        return addressArray;
    }

    modifier checkGameRunning() {
        require(game, "This game is over");
        _;
    }
}
