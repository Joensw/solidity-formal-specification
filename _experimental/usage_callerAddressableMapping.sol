// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./../callerAddressableMapping.sol";

contract ExampleUsage {

    using CallerAddressableMappings for CallerAddressableMappings.CallerAddressableMapping;

    // The StrictMap csm is private, access control from the outside is managed over the setEntry and getEntry functions
    CallerAddressableMappings.CallerAddressableMapping private csm;

    // The StrictMap at location msg.sender will be set to the value parameter. It is not necessary to pass msg.sender to the function
    function setEntry(uint value) public {
        csm.set(value);
    }

    // The Caller may only see their own entry of the mapping and not that of other caller addresses
    function getEntry() public view returns (uint contents) {
        return csm.get(msg.sender);
    }
}