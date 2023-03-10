// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "../Sets/address_set.sol";

contract ExampleUsage {

    using Sets for Sets.Set;
    using SetIterator for SetIterator.Iterator;

    Sets.Set private admins;
    SetIterator.Iterator private it;

    uint MAX_ADMINS = 4;

    constructor() {
        admins.add(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        admins.add(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
    }

    function privilegedOperation() public view {
        require(admins.contains(msg.sender));
        // ...
    }

    function normalOperation() public view {
        // ...
    }

    function removeSelfFromAdmins() public returns (bool) {
        require(admins.contains(msg.sender));
        return admins.remove(msg.sender);
    }

    function addToAdmins(address _adr) public returns (bool) {
        require(admins.contains(msg.sender));
        require(admins.size() < MAX_ADMINS);
        return admins.add(_adr);
    }

    function iterate() public {
        while(it.hasNext()){
            address current = it.next();
            // ... do something with current address
        }
    }

}