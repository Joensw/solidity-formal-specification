// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "../CallerAddressableMappings/uint_callerAddressableMapping.sol";

contract ExampleUsage {

    using CallerAddressableMappings for CallerAddressableMappings.CallerAddressableMapping;

    CallerAddressableMappings.CallerAddressableMapping private balances;

    function getBalance() public view returns (uint) {
        return balances.get();
    }

    function deposit() public payable {
        uint currentBalance = balances.get();
        balances.set(currentBalance + msg.value);
    }

    function withdraw(uint amount) public {
        require(amount <= balances.get(), "withdraw failed");
        balances.set(balances.get() - amount);
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "withdraw failed");
    }

    function send(address target) public payable returns (bool) {
        return balances.transfer(target, msg.value);
    }
}