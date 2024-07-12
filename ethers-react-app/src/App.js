import logo from './logo.svg';
import './App.css';
import React, { useEffect, useState } from 'react';
import { calculatePrizesProjection, makeMove } from 'src/contract';
import { ethers } from 'ethers';

function App() {
  const [balance, setBalance] = useState(null);
  const [contractAddress, setContractAddress] = useState('');
  const getBalance = async () => {
    try {
      const provider = new ethers.providers.JsonRpcProvider('https://optimism-sepolia.infura.io/v3/7a1dd92310f14ccd88484f421c13b195');
      const balance = await provider.getBalance(contractAddress);
      setBalance(ethers.utils.formatEther(balance));
    } catch (error) {
      console.error('Error fetching balance:', error);
    }
  };

  const [prizesProjection, setPrizesProjection] = useState(null);

  const handleCalculatePrizes = async () => {
    const result = await calculatePrizesProjection();
    setPrizesProjection(result);
  };

  const handleMakeMove = async () => {
    await makeMove();
  };

  return (
    <div className="App">
      <h1>Check ETH Balance</h1>
      <input
        type="text"
        placeholder="Enter contract address"
        value={contractAddress}
        onChange={(e) => setContractAddress(e.target.value)}
      />
      <button onClick={getBalance}>Get Balance</button>
      {balance && (
        <div>
          <h2>Balance:</h2>
          <p>{balance} ETH</p>
        </div>
      )}
      <header className="App-header">
        <h1>Smart Contract Interaction</h1>
        <button onClick={handleCalculatePrizes}>Calculate Prizes Projection</button>
        <button onClick={handleMakeMove}>Make Move</button>
        {prizesProjection && <p>Prizes Projection: {prizesProjection}</p>}
      </header>
    </div>
  );
}
export default App;