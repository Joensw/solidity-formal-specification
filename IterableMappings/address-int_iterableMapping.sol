// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

// The first 6 lines of every method represent the following invariants:
// invariant forall (address a) !(self.indexOf[a] != 0) || (self.indexOf[a] - 1 < self.keys.length) && (self.keys[self.indexOf[a] - 1] == a)
// invariant forall (uint i) !(0 <= i && i < self.keys.length) || (self.indexOf[self.keys[i]] - 1 == i)
// invariant forall (address a) !(self.indexOf[a] == 0) || (self.values[a] == defaultValue)

library IterableMappingIterator {

    struct Iterator {
        uint index;
        address[] items;
    }

    /// @notice postcondition self.index == 0
    /// @notice postcondition self.items.length == itmap.keys.length
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || self.items[i] == itmap.keys[i]

    function init(Iterator storage self, IterableMappings.IterableMapping storage itmap) public {
        self.items = itmap.keys;
        self.index = 0;
    }

    /// @notice postcondition !ret || self.index < self.items.length
    /// @notice postcondition ret || self.index >= self.items.length

    function hasNext(Iterator storage self) public view returns (bool ret) {
        return self.index < self.items.length;
    }

    /// @notice postcondition item == __verifier_old_address(self.items[self.index])
    /// @notice postcondition self.index == __verifier_old_uint(self.index) + 1
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || self.items[i] == __verifier_old_address(self.items[i])

    function next(Iterator storage self) public returns (address item) {
        item = self.items[self.index];
        self.index++;
    }
}

library IterableMappings {
    
    // Should be 0 for uint/int, false for bool and 0x0000000000000000000000000000000000000000 for address
    int private constant defaultValue = 0;

    struct IterableMapping {
        address[] keys;
        mapping (address => int) values;
        mapping (address => uint) indexOf;
    }

    /// @notice precondition forall (address a) !(self.indexOf[a] != 0) || (self.indexOf[a] - 1 < self.keys.length) && (self.keys[self.indexOf[a] - 1] == a)
    /// @notice postcondition forall (address a) !(self.indexOf[a] != 0) || (self.indexOf[a] - 1 < self.keys.length) && (self.keys[self.indexOf[a] - 1] == a)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.keys.length) || (self.indexOf[self.keys[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.keys.length) || (self.indexOf[self.keys[i]] - 1 == i)
    /// @notice precondition forall (address a) !(self.indexOf[a] == 0) || (self.values[a] == defaultValue)
    /// @notice postcondition forall (address a) !(self.indexOf[a] == 0) || (self.values[a] == defaultValue)
    /// @notice postcondition value == self.values[_key]
    /// @notice postcondition !(self.indexOf[_key] == 0) || (value == defaultValue)

    function get(IterableMapping storage self, address _key) public view returns (int value) {
        return self.values[_key];
    }

    /// @notice precondition forall (address a) !(self.indexOf[a] != 0) || (self.indexOf[a] - 1 < self.keys.length) && (self.keys[self.indexOf[a] - 1] == a)
    /// @notice postcondition forall (address a) !(self.indexOf[a] != 0) || (self.indexOf[a] - 1 < self.keys.length) && (self.keys[self.indexOf[a] - 1] == a)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.keys.length) || (self.indexOf[self.keys[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.keys.length) || (self.indexOf[self.keys[i]] - 1 == i)
    /// @notice precondition forall (address a) !(self.indexOf[a] == 0) || (self.values[a] == defaultValue)
    /// @notice postcondition forall (address a) !(self.indexOf[a] == 0) || (self.values[a] == defaultValue)
    /// @notice postcondition out == self.keys.length

    function size(IterableMapping storage self) public view returns (uint out) {
        return self.keys.length;
    }

    /// @notice precondition forall (address a) !(self.indexOf[a] != 0) || (self.indexOf[a] - 1 < self.keys.length) && (self.keys[self.indexOf[a] - 1] == a)
    /// @notice postcondition forall (address a) !(self.indexOf[a] != 0) || (self.indexOf[a] - 1 < self.keys.length) && (self.keys[self.indexOf[a] - 1] == a)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.keys.length) || (self.indexOf[self.keys[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.keys.length) || (self.indexOf[self.keys[i]] - 1 == i)
    /// @notice precondition forall (address a) !(self.indexOf[a] == 0) || (self.values[a] == defaultValue)
    /// @notice postcondition forall (address a) !(self.indexOf[a] == 0) || (self.values[a] == defaultValue)
    /// @notice postcondition exists (uint i) !out || !(0 <= i && i < self.keys.length) || self.keys[i] == _key
    /// @notice postcondition forall (uint i) out || !(0 <= i && i < self.keys.length) || self.keys[i] != _key

    function containsKey(IterableMapping storage self, address _key) public view returns (bool out) {
        return self.indexOf[_key] != 0;
    }

    /// @notice precondition forall (address a) !(self.indexOf[a] != 0) || (self.indexOf[a] - 1 < self.keys.length) && (self.keys[self.indexOf[a] - 1] == a)
    /// @notice postcondition forall (address a) !(self.indexOf[a] != 0) || (self.indexOf[a] - 1 < self.keys.length) && (self.keys[self.indexOf[a] - 1] == a)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.keys.length) || (self.indexOf[self.keys[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.keys.length) || (self.indexOf[self.keys[i]] - 1 == i)
    /// @notice precondition forall (address a) !(self.indexOf[a] == 0) || (self.values[a] == defaultValue)
    /// @notice postcondition forall (address a) !(self.indexOf[a] == 0) || (self.values[a] == defaultValue)
    /// @notice postcondition self.values[_key] == _value
    /// @notice postcondition forall (address a) !(a != _key) || self.values[a] == __verifier_old_int(self.values[a])
    /// @notice postcondition !(__verifier_old_uint(self.indexOf[_key]) == 0) || (self.keys.length == __verifier_old_uint(self.keys.length) + 1)
    /// @notice postcondition !(__verifier_old_uint(self.indexOf[_key]) == 0) || (self.keys[self.keys.length - 1] == _key)
    /// @notice postcondition !(__verifier_old_uint(self.indexOf[_key]) == 0) || (self.indexOf[_key] == self.keys.length)
    /// @notice postcondition forall (address a) !(__verifier_old_uint(self.indexOf[_key]) == 0) || !(a != _key) || self.indexOf[a] == __verifier_old_uint(self.indexOf[a])
    /// @notice postcondition forall (uint i) !(__verifier_old_uint(self.indexOf[_key]) == 0) || !(0 <= i && i < self.keys.length - 1) || self.keys[i] == __verifier_old_address(self.keys[i])
    /// @notice postcondition forall (address a) (__verifier_old_uint(self.indexOf[_key]) == 0) || self.indexOf[a] == __verifier_old_uint(self.indexOf[a])
    /// @notice postcondition forall (uint i) (__verifier_old_uint(self.indexOf[_key]) == 0) || !(0 <= i && i < self.keys.length) || self.keys[i] == __verifier_old_address(self.keys[i])

    function set(IterableMapping storage self, address _key, int _value) public {
        self.values[_key] = _value;

        if (self.indexOf[_key] == 0) {
            self.keys.push(_key);
            self.indexOf[_key] = self.keys.length;
        }
    }

    /// @notice precondition forall (address a) !(self.indexOf[a] != 0) || (self.indexOf[a] - 1 < self.keys.length) && (self.keys[self.indexOf[a] - 1] == a)
    /// @notice postcondition forall (address a) !(self.indexOf[a] != 0) || (self.indexOf[a] - 1 < self.keys.length) && (self.keys[self.indexOf[a] - 1] == a)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.keys.length) || (self.indexOf[self.keys[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.keys.length) || (self.indexOf[self.keys[i]] - 1 == i)
    /// @notice precondition forall (address a) !(self.indexOf[a] == 0) || (self.values[a] == defaultValue)
    /// @notice postcondition forall (address a) !(self.indexOf[a] == 0) || (self.values[a] == defaultValue)
    /// @notice postcondition success || (__verifier_old_uint(self.keys.length) == 0 || __verifier_old_uint(self.indexOf[_key]) == 0)
    /// @notice postcondition !success || (__verifier_old_uint(self.keys.length) != 0 && __verifier_old_uint(self.indexOf[_key]) != 0)
    /// @notice postcondition success || self.keys.length == __verifier_old_uint(self.keys.length)
    /// @notice postcondition !success || self.keys.length == __verifier_old_uint(self.keys.length) - 1
    /// @notice postcondition forall (uint i) success || (0 <= i && i < self.keys.length) || self.keys[i] == __verifier_old_address(self.keys[i])
    /// @notice postcondition forall (address a) success || self.values[a] == __verifier_old_int(self.values[a])
    /// @notice postcondition forall (address a) success || self.indexOf[a] == __verifier_old_uint(self.indexOf[a])
    /// @notice postcondition !success || self.values[_key] == defaultValue && self.indexOf[_key] == 0
    /// @notice postcondition forall (uint i) !success || !(0 <= i && i < self.keys.length) || self.keys[i] != _key
    /// @notice postcondition forall (address a) !success || !(a != _key) || self.values[a] == __verifier_old_int(self.values[a])
    /// @notice postcondition forall (uint i) !success || !(_key == __verifier_old_address(self.keys[self.keys.length - 1])) || !(0 <= i && i < self.keys.length) || self.keys[i] == __verifier_old_address(self.keys[i])
    /// @notice postcondition forall (address a) !success || !(_key == __verifier_old_address(self.keys[self.keys.length - 1])) || !(a != _key) || self.indexOf[a] == __verifier_old_uint(self.indexOf[a])
    /// @notice postcondition !success || (_key == __verifier_old_address(self.keys[self.keys.length - 1])) || (__verifier_old_address(self.keys[self.keys.length - 1]) == self.keys[__verifier_old_uint(self.indexOf[_key] - 1)])
    /// @notice postcondition !success || (_key == __verifier_old_address(self.keys[self.keys.length - 1])) || self.indexOf[__verifier_old_address(self.keys[self.keys.length - 1])] == __verifier_old_uint(self.indexOf[_key])
    /// @notice postcondition forall (uint i) (!success) || (_key == __verifier_old_address(self.keys[self.keys.length - 1]))  || !(0 <= i && i < self.keys.length && i != __verifier_old_uint(self.indexOf[_key] - 1)) || (self.keys[i] == __verifier_old_address(self.keys[i]))
    /// @notice postcondition forall (address a) (!success) || (_key == __verifier_old_address(self.keys[self.keys.length - 1])) || !(a != __verifier_old_address(self.keys[self.keys.length - 1]) && a != _key) || (self.indexOf[a] == __verifier_old_uint(self.indexOf[a]))

    function remove(IterableMapping storage self, address _key) public returns (bool success) {
        if (self.keys.length == 0) return false;
        if (self.indexOf[_key] == 0) return false;
    
        // move last elemet of keys array to where the element we want to remove was
        uint index = self.indexOf[_key] - 1;
        address lastKey = self.keys[self.keys.length - 1];
        self.keys[index] = lastKey;
        self.indexOf[lastKey] = index + 1;

        delete self.values[_key];
        delete self.indexOf[_key];

        self.keys.pop();
        return true;
    }

}