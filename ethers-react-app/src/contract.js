// src/contract.js
import Web3 from 'web3';

const contractAddress = '0xe4EE33F790f790950E0064E0E5aC474BE36d577F';
const contractABI = '0xe4EE33F790f790950E0064E0E5aC474BE36d577F';

let web3;
let contract;

if (window.ethereum) {
    web3 = new Web3(window.ethereum);
    contract = new web3.eth.Contract(contractABI, contractAddress);
} else {
    console.error('Non-Ethereum browser detected. Consider trying MetaMask!');
}

export const calculatePrizesProjection = async () => {
    try {
        const result = await contract.methods.calculatePrizesProjection().call();
        return result;
    } catch (error) {
        console.error('Error calling calculatePrizesProjection', error);
    }
};

export const makeMove = async () => {
    try {
        const accounts = await web3.eth.getAccounts();
        const result = await contract.methods.makeMove().send({ from: accounts[0] });
        return result;
    } catch (error) {
        console.error('Error calling makeMove', error);
    }
};
