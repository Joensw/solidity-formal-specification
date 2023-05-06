// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

library CallerAddressableMappings {

    struct CallerAddressableMapping {
        mapping (address => int) map;
    }

    /// @notice postcondition contents == self.map[key]

    function getTarget(CallerAddressableMapping storage self, address key) public view returns (int contents) {
        contents = self.map[key];
    }

    /// @notice postcondition contents == self.map[msg.sender]

    function get(CallerAddressableMapping storage self) public view returns (int contents) {
        contents = self.map[msg.sender];
    }

    /// @notice postcondition forall (address a) !(a != msg.sender ) || (self.map[a] == __verifier_old_int(self.map[a]))
    /// @notice postcondition self.map[msg.sender] == value

    function set(CallerAddressableMapping storage self, int value) public {
        self.map[msg.sender] = value;
    }

    /// @notice postcondition !(amount < 0 || __verifier_old_int(self.map[msg.sender]) < amount || target == msg.sender) || !success
    /// @notice postcondition forall (address a) !(a != target && a != msg.sender) || (self.map[a] == __verifier_old_int(self.map[a]))
    /// @notice postcondition forall (address a) success || (self.map[a] == __verifier_old_int(self.map[a]))
    /// @notice postcondition !success || self.map[target] == __verifier_old_int(self.map[target]) + amount
    /// @notice postcondition !success || self.map[target] >= __verifier_old_int(self.map[target])
    /// @notice postcondition !success || self.map[msg.sender] ==  __verifier_old_int(self.map[msg.sender]) - amount

    function transfer(CallerAddressableMapping storage self, address target, int amount) public returns (bool success) {
        if (amount < 0 || self.map[msg.sender] < amount || target == msg.sender) {
            return false;
        }
        self.map[msg.sender] -= amount;
        self.map[target] += amount;  
        return true;  
    }

}
