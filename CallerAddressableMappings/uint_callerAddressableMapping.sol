// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

library CallerAddressableMappings {

    struct CallerAddressableMapping {
        mapping (address => uint) map;
    }

    /// @notice postcondition contents == self.map[key]

    function getTarget(CallerAddressableMapping storage self, address key) public view returns (uint contents) {
        contents = self.map[key];
    }

    /// @notice postcondition contents == self.map[msg.sender]

    function get(CallerAddressableMapping storage self) public view returns (uint contents) {
        contents = self.map[msg.sender];
    }

    /// @notice postcondition forall (address a) !(a != msg.sender ) || (self.map[a] == __verifier_old_uint(self.map[a]))
    /// @notice postcondition self.map[msg.sender] == value

    function set(CallerAddressableMapping storage self, uint value) public {
        self.map[msg.sender] = value;
    }

    /// @notice postcondition forall (address a) !(a != target) || (self.map[a] == __verifier_old_uint(self.map[a]))
    /// @notice postcondition self.map[target] == __verifier_old_uint(self.map[target]) + amount
    /// @notice postcondition self.map[target] >= __verifier_old_uint(self.map[target])

    function depositTarget(CallerAddressableMapping storage self, address target, uint amount) public {
        require(amount >= 0);
        self.map[target] += amount;
    }

    /// @notice postcondition forall (address a) !(a != msg.sender) || (self.map[a] == __verifier_old_uint(self.map[a]))
    /// @notice postcondition self.map[msg.sender] == __verifier_old_uint(self.map[msg.sender]) + amount
    /// @notice postcondition self.map[msg.sender] >= __verifier_old_uint(self.map[msg.sender])

    function deposit(CallerAddressableMapping storage self, uint amount) public {
        require(amount >= 0);
        self.map[msg.sender] += amount;
    }
}
