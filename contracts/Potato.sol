//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "./Player.sol";

contract Potato {
    string public name = "Potato Token";
    string public symbol = "POT";
    uint256 public totalSupply = 1;
    mapping(address => Player) playerAddressMap;
    address[] public addressArray;

    constructor(string memory _username) {
        Player memory first = Player({
            username: _username,
            balance: totalSupply,
            score: 0
        });

        playerAddressMap[msg.sender] = first;
        addressArray.push(msg.sender);
    }

    function transfer(address to) public {
        require(playerAddressMap[msg.sender].balance == 1, "Not enough tokens");
        playerAddressMap[msg.sender].balance -= 1;
        playerAddressMap[to].balance += 1;
    }

    function transferRandom(address to) public {
        require(playerAddressMap[msg.sender].balance == 1, "Not enough tokens");

        playerAddressMap[msg.sender].balance -= 1;
        //to random address
        playerAddressMap[to].balance += 1;
    }
    function addPlayers(address key, string memory username) public {
        Player memory player = Player({
            username: username,
            score: 0,
            balance: 0
        });
        playerAddressMap[key] = player;
        addressArray.push(key);
        
    }

    function getPlayerInfo(address key) public view returns (Player memory) {
        return playerAddressMap[key];
    }
    function getAllPlayers() public view returns (Player[] memory) {
        Player[] memory playerArray = new Player[](addressArray.length);
        for(uint i = 0; i<addressArray.length; i++){
            playerArray[i]=(playerAddressMap[addressArray[i]]);
        }
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

    //works
    function balanceOf(address account) public view returns (uint256) {
        return playerAddressMap[account].balance;
    }
}
