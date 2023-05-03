**SafeSave Smart Contract** 


SafeSave is a solidity smart contract that runs on the ethereum blockchain.  

**Features** 

- It ensures that the wallet that deployed the contract (owner of the smart contract) is same as the person withdrawing the funds. 
- Checks the amount the user is funding in wei to ensure it's more than $20. 
- The withdrawal date can't be changed after being set. 

**Functions** 

- `setNumberOfDaysToSaveFunds()`: The setNumberOfDaysToSaveFunds enables the user to specify how many days they wish to save their funds before withdrawal. The withdrawal date can only be set once and it can be set even after depositing funds into the smart contract. 

- `fetchCurrentEthPriceInUsd()`: The name of this function is self-explanatory. It fetches the current price of Ethereum in USD to ensure that the user is funding the smart contract with the latest price of eth in usd. It also enables the smart contract to calculate the price of eth in usd to determine the minimum amount in USD. 

- `convertWeiToUsd()` : Converts the user funded eth in wei to usd to determine the minimum amout in USD. 

- `widthdraw()` : Withdraws the total eth balance in the smart contract if the time is due and also ensures it's the owner of the contract that executing the function.



