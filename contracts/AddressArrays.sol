//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

import "./Player.sol";

contract Token {
    string public name = "Potato Token";
    string public symbol = "POT";
    uint256 public totalSupply = 1;
    mapping(address => Player) playerAddressMap;
    address[] public addressArray;
    Player[] public playerArray;

    constructor() {
        Player memory first = Player({
            username: "first",
            balance: totalSupply,
            score: 0
        });

        playerAddressMap[msg.sender] = first;
        addressArray.push(msg.sender);
        playerArray.push(first);
    }

    function transfer(address from, address to) public {
        require(playerAddressMap[from].balance >= 1, "Not enough tokens");
        playerAddressMap[from].balance -= 1;
        playerAddressMap[to].balance += 1;
    }

    function transferRandom(address to, uint256 amount) public {
        amount = 1;
        require(
            playerAddressMap[msg.sender].balance >= amount,
            "Not enough tokens"
        );

        playerAddressMap[msg.sender].balance -= amount;
        //to random address
        playerAddressMap[to].balance += amount;
    }

    function addPlayers(address key, string memory username) public {
        Player memory player = Player({
            username: username,
            score: 0,
            balance: 0
        });
        playerAddressMap[key] = player;
        addressArray.push(key);

        for(uint i = 0; i< addressArray.length; i++){
            playerArray.push( playerAddressMap[addressArray[i]]);
        }
    }

    function removePlayer(address key) public returns (bool) {
        for (uint i = 0; i < addressArray.length; i++) {
            if (addressArray[i] == key) {
                addressArray[i] = addressArray[addressArray.length - 1];
                addressArray.pop();
               playerArray[i] = playerArray[playerArray.length - 1];
               playerArray.pop();
                return true;
            }
        }
        return false;
    }

    function getPlayerInfo(address key) public view returns (Player memory) {
        return playerAddressMap[key];
    }

    function getAllPlayers() public view returns (Player[] memory) {
        return playerArray;
    }

    function timer() public {
        /**
         * count seconds upon receiving token
         * if seconds > 86 400 trigger transfer random
         * player gets 90 000 points
         * else score = counter
         */
    }

    function balanceOf(address account) public view returns (uint256) {
        return playerAddressMap[account].balance;
    }
}
