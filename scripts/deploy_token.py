from brownie import LoyaltyToken
from scripts.helpful_scripts import get_account
from web3 import Web3

initial_supply= Web3.toWei(1000, "ether")

def main():
    account = get_account(id="goerli-testnet1")
    ozod_token = LoyaltyToken.deploy(initial_supply, "Korzinka Loyalty", "KRZ-OZD",{"from":account})
    ozod_token.mintToCustomer("0xb73b9caB0a5a19de048980930c171a22FB40650D",Web3.toWei(10, "ether"))
    print(ozod_token.name())