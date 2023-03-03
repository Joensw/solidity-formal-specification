// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "../Sets/address_set.sol";

contract ExampleUsage {

    using Sets for Sets.Set;
    using SetIterator for SetIterator.Iterator;

    Sets.Set private admins;
    SetIterator.Iterator private it;

    uint max_admins = 4;

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

    function addToAdmins(address adr) public returns (bool) {
        require(admins.contains(msg.sender));
        require(admins.size() < max_admins);
        return admins.add(adr);
    }

    function iterate() public {
        while(it.hasNext()){
            address current = it.next();
            // ...
        }
    }

}