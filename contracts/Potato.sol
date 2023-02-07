//SPDX-License-Identifier: UNLICENSED

/**
 * sve okej osim transfer random, koji je radio prvi put al drugi put ne
 */

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
            hasPotato: true,
            score: 0,
            receivedToken: block.timestamp
        });

        playerAddressMap[msg.sender] = first;
        addressArray.push(msg.sender);
    }

    //new stuff here works
    function transfer(address to) public {
        require(playerAddressMap[msg.sender].hasPotato, "You don't have it");
        require(playerExists(to), "This player is not in the game");
        require(msg.sender!=to, "Why are you sending it to yourself?");
        playerAddressMap[msg.sender].score = stopCounter(
            msg.sender,
            block.timestamp,
            playerAddressMap[msg.sender].receivedToken
        );
        playerAddressMap[msg.sender].hasPotato = false;
        playerAddressMap[to].hasPotato = true;
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
        return addressArray[rNumber];
    }
    
    //
    function transferRandom() public {
        require(playerAddressMap[msg.sender].hasPotato, "Not enough tokens");
        //to=randomaddress
        address to = getRandomAddress(msg.sender);
        playerAddressMap[msg.sender].score = stopCounter(
            msg.sender,
            block.timestamp,
            playerAddressMap[msg.sender].receivedToken
        );
        playerAddressMap[msg.sender].hasPotato = false;
        playerAddressMap[to].hasPotato = true;
        initCounter(to);
    }

    function addPlayers(address key, string memory username) public {
        Player memory player = Player({
            username: username,
            score: 0,
            hasPotato: false,
            receivedToken: 0
        });
        playerAddressMap[key] = player;
        addressArray.push(key);
    }

    function getPlayerInfo(address key) public view returns (Player memory) {
        return playerAddressMap[key];
    }

    function sortArray() internal {
        for(uint i=1; i<addressArray.length; i++){
            uint key = playerAddressMap[addressArray[i]].score;
            uint j = i-1;
            while((int(j)>=0) && (playerAddressMap[addressArray[j]].score>key)){
                playerAddressMap[addressArray[j+1]].score = playerAddressMap[addressArray[j]].score;
                j--;
            }
            playerAddressMap[addressArray[j+1]].score = key;
        }
    }

    function getAllPlayers() public view returns (Player[] memory) {
        Player[] memory playerArray = new Player[](addressArray.length);
        for(uint i = 0; i<addressArray.length; i++){
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
    function balanceOf(address account) public view returns (bool) {
        return playerAddressMap[account].hasPotato;
    }

    //works fine
    function playerExists(address a) internal view returns(bool b){
        b=false;
        for(uint i=0; i<addressArray.length; i++){
            if(addressArray[i]==a){
                b = true;
            }
        }
    }
}
