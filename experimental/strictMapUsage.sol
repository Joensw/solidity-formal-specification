// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./../strictMap.sol";

contract ExampleUsage {

    using StrictMaps for StrictMaps.StrictMap;

    // The StrictMap sm is private, access control from the outside is managed over the setEntry and getEntry functions
    StrictMaps.StrictMap private sm;

    // The StrictMap at location msg.sender will be set to the value parameter. It is not necessary to pass msg.sender to the function
    function setEntry(uint value) public {
        sm.set(value);
    }

    // The Caller may only see their own entry of the mapping and not that of other caller addresses
    function getEntry() public view returns (uint contents) {
        return sm.get(msg.sender);
    }
}