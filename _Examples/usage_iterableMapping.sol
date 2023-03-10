// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "../IterableMappings/address-uint_iterableMapping.sol";

contract ExampleUsage {

    using IterableMappings for IterableMappings.IterableMapping;
    using IterableMappingIterator for IterableMappingIterator.Iterator;

    IterableMappings.IterableMapping private balances;
    IterableMappingIterator.Iterator private accountIterator;

    constructor() {
        balances.set(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 50);
        balances.set(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 50);
        balances.set(0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB, 100);
        balances.set(0x617F2E2fD72FD9D5503197092aC168c91465E7f2, 100);
    }

    function getBalance(address _account) public view {
        balances.get(_account);
    }

    function setBalance(address _account, uint _value) public returns (bool) {
        balances.set(_account, _value);
    }

    function getSize() public view returns (uint) {
        return balances.size();
    }

    function getKeys() public view returns (address[] memory) {
        return balances.keys;
    }

    function payAll(uint _value) public {
        accountIterator.init(balances);
        while(accountIterator.hasNext()){
            address currentAccount = accountIterator.next();
            uint currentBalance = balances.get(currentAccount);
            balances.set(currentAccount, currentBalance + _value);
        }
    }

    function deleteAccount(address _account) public returns (bool) {
        if (!balances.containsKey(_account)) return false;
        balances.remove(_account);

        // balances will no longer contain the key _account
        // balances.get(_account) will return 0 akin to a regular solidity mapping
    }

}