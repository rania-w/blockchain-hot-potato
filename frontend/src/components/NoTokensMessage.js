import React from "react";

export function NoTokensMessage({ selectedAddress }) {
  return (
    <>
      <h3>You don't have the potato!</h3>
      <p>
        Good for you ;) 
        <br />
        <br />
        {/* <code>npx hardhat --network localhost faucet {selectedAddress}</code> */}
      </p>
    </>
  );
}
