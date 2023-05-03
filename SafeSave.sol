//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
error amountTooLow(); 
error notAuthorized();
error tooEarlyToWithdraw();
error alreadySetWithdrawalDate(); 
contract SafeSave {
    address public immutable i_owner;
    uint256 public numberOfDaysToSaveFunds;
    uint256 public firstDepositDate;
    uint256 public withdrawalDate;
    mapping(address => uint256) public funders;
    address[] public fundersArray;
    bool public hasSetWithdrawalDate = false;
    uint256 minimumAmount = 20 * 1e18;
    bool public hasDepositedOnce = false; 
    constructor(){
        i_owner = msg.sender;
    }
    modifier owner () {
        if(msg.sender == i_owner){
            _;
        }else{
            revert notAuthorized();
        }
    }
    function setNumberOfDaysToSaveFunds(uint256 _numberOfDaysToSaveFunds) public {
        if(!hasSetWithdrawalDate){
            numberOfDaysToSaveFunds = _numberOfDaysToSaveFunds;
            withdrawalDate = (block.timestamp + (numberOfDaysToSaveFunds * 1 days));
            hasSetWithdrawalDate = true;
        }else{
            revert alreadySetWithdrawalDate();
        }

    }
    function fund () public payable {
        if(convertWeiToUsd(msg.value) >= minimumAmount){
            if(hasDepositedOnce == false){
                hasDepositedOnce = true;
                firstDepositDate = block.timestamp;
            }
            fundersArray.push(msg.sender); 
            funders[msg.sender] = msg.value;
        }else{
            revert amountTooLow();
        }
    }
    function fetchCurrentEthPriceInUsd()public view returns (uint256){
        (, int price, , ,) = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).latestRoundData();
        return uint256(price * 1e10);
    }
    function convertWeiToUsd(uint256 _amountInWei) internal view returns(uint256){
        uint256 amountInUSD = fetchCurrentEthPriceInUsd();
        uint256 totalInUsd = (_amountInWei * amountInUSD) / 1e18; 
        return totalInUsd;
    }
    function widthdraw (address payable _receiver) public owner payable {
        if(block.timestamp >= withdrawalDate){
            (bool sent,) = _receiver.call{value : msg.value}("");
            for(uint256 x = 0; x < fundersArray.length; x++){
                delete funders[fundersArray[x]];
            }
            delete fundersArray;
            require(sent, "Cannot withdraw funds at this moment");
        }else{
            revert tooEarlyToWithdraw();
        }
    }

}
