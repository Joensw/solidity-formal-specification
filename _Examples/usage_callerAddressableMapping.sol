// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "../CallerAddressableMappings/uint_callerAddressableMapping.sol";

contract ExampleUsage {

    using CallerAddressableMappings for CallerAddressableMappings.CallerAddressableMapping;

    CallerAddressableMappings.CallerAddressableMapping private balances;

    // The Caller may only see their own entry of the mapping and not that of other caller addresses
    function getBalance() public view returns (uint) {
        return balances.get();
    }

    function deposit() public payable {
        balances.deposit(msg.value);
    }

    function withdraw(uint amount) public {
        require(amount <= balances.get(), "withdraw failed");
        balances.set(balances.get() - amount);
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "withdraw failed");
    }
}