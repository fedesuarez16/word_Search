require ("@nomiclabs/hardhat-ethers");
require("dotenv").config({path: ".env"});
// require("hardhat-tracer");


const CELO_RPC_URL = process.env.alfajores_API_KEY_URL;
const PRIVATE_KEY = process.env.ACCOUNT2_PRIVATE_KEY;


module.exports = {
  solidity: "0.8.20",
  networks: {
    alfajores: {
      url: CELO_RPC_URL,
      accounts: [PRIVATE_KEY]
    },
  }
}