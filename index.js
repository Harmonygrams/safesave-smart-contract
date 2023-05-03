const ethers = require('ethers'); 
require('dotenv').config(); 
const fs = require('fs'); 
const main = async () => {
    const provider =  new ethers.JsonRpcProvider(process.env.RPC); 
    const wallet =  new ethers.Wallet(process.env.PRIVATE_KEY, provider);
    const abi = fs.readFileSync('./@chainlink_contracts_src_v0_8_interfaces_AggregatorV3Interface_sol_AggregatorV3Interface.abi', 'utf-8'); 
    const bin = fs.readFileSync('./@chainlink_contracts_src_v0_8_interfaces_AggregatorV3Interface_sol_AggregatorV3Interface.bin', 'utf-8'); 
    const contract = await new ethers.ContractFactory(abi, bin, wallet); 
    console.log('deploying contract') 
    const deployedContract = await contract.deploy(); 

}
main(). 
then(() => process.exit(1)). 
catch(err => {
    console.log(err); 
    process.exit(1); 
})