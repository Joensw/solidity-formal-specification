// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

library CallerAddressableMappings {

    struct CallerAddressableMapping {
        mapping (address => uint) _map;
    }

    /// @notice postcondition contents == self._map[key]

    function get(CallerAddressableMapping storage self, address key) public view returns (uint contents) {
        contents = self._map[key];
    }

    /// @notice postcondition forall (address a) !(a != msg.sender ) || (self._map[a] == __verifier_old_uint(self._map[a]))
    /// @notice postcondition self._map[msg.sender] == value

    function set(CallerAddressableMapping storage self, uint value) public {
        self._map[msg.sender] = value;
    }

    /// @notice postcondition forall (address a) !(a != target) || (self._map[a] == __verifier_old_uint(self._map[a]))
    /// @notice postcondition self._map[target] == __verifier_old_uint(self._map[target]) + amount

    function deposit(CallerAddressableMapping storage self, address target, uint amount) public {
        self._map[target] += amount;
    }

}