//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.9;

import "./Player.sol";

/**
 * 
 * amongst so many other things, I have to think about calldata vs memory vs storage
 * storage - expensive and stored on bc
 * memory - cheap and stored temporarily
 * calldata - even cheaper and stored temporarily, can/can't be used externally smth smth
 * ima i var - koristi se samo u funkcijama
 * 
 * percentage of lost games needs to be in frontend - ako ga bude ikako
 */


// This is the main building block for smart contracts.
contract Token {
    // Some string type variables to identify the token.
    string public name = "Potato Token";
    string public symbol = "POT";
    

    // The fixed amount of tokens, stored in an unsigned integer type variable.
    uint256 public totalSupply = 1;

    // An address type variable is used to store ethereum accounts.
   // address public owner;// could be first address

    // A mapping is a key/value map. Here we store each account's balance.
    
    mapping (address => Player) playerAddressMap;
    
    //playersArray se ponasa cudno, ali ima getallplayers tkd se ova funk da ignorisat
    Player[] public playersArray;
  
   
    // The Transfer event helps off-chain applications understand
    // what happens within your contract.
    
   
    // event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /**
     * Contract initialization.
     */
    //works
    constructor() {
        // The totalSupply is assigned to the transaction sender, which is the
        // account that is deploying the contract.
        //balance[msg.sender] = totalSupply;
        Player memory first = Player ({
            username: "first",
            balance: totalSupply,
            score: 0
        });
       
        playerAddressMap[msg.sender]=first;
        playersArray.push(first);
    }

    /**
     * A function to transfer tokens.
     *
     * The `external` modifier makes a function *only* callable from *outside*
     * the contract.
     */
    //works ali vjrv treba dodat from isto, jer je ovdje default owner
    function transfer(address to, address from) public {
        // Check if the transaction sender has enough tokens.
        // If `require`'s first argument evaluates to `false` then the
        // transaction will revert.
       
        require(playerAddressMap[from].balance >= 1, "Not enough tokens");

        // Transfer the amount.
        playerAddressMap[from].balance -= 1;
        playerAddressMap[to].balance += 1;

        // Notify off-chain applications of the transfer.
        //emit Transfer(msg.sender, to, amount);
    }
     
     /**
      * apparently blockchain ne voli randomness tako da ce ovo biti neka forma poduhvata za koji ja
      * psihicki nisam spremna
      */
     function transferRandom(address to, uint256 amount) public {
        // Check if the transaction sender has enough tokens.
        // If `require`'s first argument evaluates to `false` then the
        // transaction will revert.
        amount = 1;
        require(playerAddressMap[msg.sender].balance >= amount, "Not enough tokens");

        // Transfer the amount.
        playerAddressMap[msg.sender].balance -= amount;
        // TODO 
        //to = random address
        playerAddressMap[to].balance += amount;

        // Notify off-chain applications of the transfer.
        //emit Transfer(msg.sender, to, amount);
    }

   

     /**
     * add players to round
     */
    //works
    function addPlayers(address key, string memory username) public{
        /**
         * dodaj adrese u array
         * initialize score 0
         * initialize username
         * init balance 0
         */
        
      
        Player memory player = Player({
            username: username,
            score : 0,
            balance: 0
        });
        playerAddressMap[key] = player;
        playersArray.push(player);
    }
    //doesnt work
    function removePlayer(address key) public{
        /**
         * player has to have balance 0
         * if player wants to leave game
         */
            /*if (index >= payees.length) return;

        payees[index] = payees[payees.length - 1];
        payees.pop();*/
       
    }

    //works 
    function getPlayerInfo(address key) public view returns (Player memory){
        /**
         * return Player
         */
        return playerAddressMap[key];
    }
    //works
     function getAllPlayers() public view returns (Player[] memory){
         /**
          * return player array that will be placed in leaderboard
          * somehow sort by score
          */
         return playersArray;
     }

    function timer() public {
        /**
         * count seconds upon receiving token
         * if seconds > 86 400 trigger transfer random
         * player gets 90 000 points
         * else score = counter
         */
    }

     /**
     * Read only function to retrieve the token balance of a given account.
     *
     * The `view` modifier indicates that it doesn't modify the contract's
     * state, which allows us to call it without executing a transaction.
     */
    //works
    function balanceOf(address account) public view returns (uint256) {
        return playerAddressMap[account].balance;
    }

}