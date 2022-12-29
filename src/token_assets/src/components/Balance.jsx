import React, {useState} from "react";
import {Principal} from '@dfinity/principal';
import {token} from '../../../declarations/token';

function Balance() {
  const [principalValue, setPrincipal] = useState("");
  const [balanceResult, setBalance] = useState("");
  const [tokenName, setTokenName] = useState("");
  const [isHidden, setHidden] = useState(true);
  
  async function handleClick() {
    // console.log(principalValue);
    const principal = Principal.fromText(principalValue);
    const balance = await token.balanceOf(principal);
    const tokenID = await token.getTokenName();

    setBalance(balance.toLocaleString());
    setTokenName(tokenID);
    setHidden(false);
  }

  function setPrincipalValue(event){
    setPrincipal(event.target.value);
  }

  return (
    <div className="window white">
      <label>Check account token balance:</label>
      <p>
        <input
          id="balance-principal-id"
          type="text"
          placeholder="Enter a Principal ID"
          value={principalValue}
          onChange={setPrincipalValue}
        />
      </p>
      <p className="trade-buttons">
        <button
          id="btn-request-balance"
          onClick={handleClick}
        >
          Check Balance
        </button>
      </p>
      <p hidden={isHidden}>This account has a balance of {balanceResult} {tokenName}.</p>
    </div>
  );
}

export default Balance;
