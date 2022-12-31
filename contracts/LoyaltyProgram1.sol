// contracts/OzodToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract LoyaltyToken is Ownable {
    address public tokenAddress;
    string[] public availableCurrencies;

    // One token equals _amount currency
    mapping(string => uint256) public currencyPairAmounts;

    constructor(
        address _tokenAddress,
        string memory _currency,
        uint256 oneTokenEqualsAmount
    ) {
        tokenAddress = _tokenAddress;
        availableCurrencies.push(_currency);
        currencyPairAmounts[_currency] = oneTokenEqualsAmount;
    }

    function checkIfCurrencyAvailable(string memory searchFor)
        private
        returns (bool)
    {
        for (uint256 i = 0; i < availableCurrencies.length; i++) {
            if (
                keccak256(bytes(availableCurrencies[i])) ==
                keccak256(bytes(searchFor))
            ) {
                return true;
            }
        }
        return false; // not found
    }

    function addNewCurrency(
        string memory currency,
        uint256 oneTokenEqualsAmount
    ) public onlyOwner {
        require(!checkIfCurrencyAvailable(currency), "Currency already exists");
        availableCurrencies.push(currency);
        currencyPairAmounts[currency] = oneTokenEqualsAmount;
    }

    function removeCurrency(uint256 index) public onlyOwner {
        delete currencyPairAmounts[availableCurrencies[index]];
        delete availableCurrencies[index];

        availableCurrencies[index] = availableCurrencies[
            availableCurrencies.length - 1
        ];
        availableCurrencies.pop();
    }

    function changeCurrencyPairAmount(string memory currency, uint256 newAmount)
        public
        onlyOwner
    {
        require(
            checkIfCurrencyAvailable(currency),
            "Currency is not available"
        );
        currencyPairAmounts[currency] = newAmount;
    }

    function convertCurrencyToToken(
        string memory currency,
        uint256 currencyAmount
    ) public view onlyOwner returns (uint256) {
        return currencyAmount / currencyPairAmounts[currency];
    }

    function convertTokenToCurrency(string memory currency, uint256 tokenAmount)
        public
        view
        onlyOwner
        returns (uint256)
    {
        return tokenAmount * currencyPairAmounts[currency];
    }
}
