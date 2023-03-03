// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

library CallerAddressableMappings {

    struct CallerAddressableMapping {
        mapping (address => int) map;
    }

    /// @notice postcondition contents == self.map[key]

    function get(CallerAddressableMapping storage self, address key) public view returns (int contents) {
        contents = self.map[key];
    }

    /// @notice postcondition forall (address a) !(a != msg.sender ) || (self.map[a] == __verifier_old_int(self.map[a]))
    /// @notice postcondition self.map[msg.sender] == value

    function set(CallerAddressableMapping storage self, int value) public {
        self.map[msg.sender] = value;
    }

    /// @notice postcondition forall (address a) !(a != target) || (self.map[a] == __verifier_old_int(self.map[a]))
    /// @notice postcondition self.map[target] == __verifier_old_int(self.map[target]) + amount
    /// @notice postcondition self.map[target] >= __verifier_old_int(self.map[target])

    function deposit(CallerAddressableMapping storage self, address target, int amount) public {
        require(amount >= 0);
        self.map[target] += amount;
    }

}