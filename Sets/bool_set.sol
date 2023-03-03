// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

library SetIterator {

    struct Iterator {
        uint index;
        bool[] items;
    }

    /// @notice postcondition self.index == 0
    /// @notice postcondition self.items.length == set.items.length
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || self.items[i] == set.items[i]

    function init(Iterator storage self, Sets.Set storage set) public {
        self.items = set.items;
        self.index = 0;
    }

    /// @notice postcondition !ret || self.index < self.items.length
    /// @notice postcondition ret || self.index >= self.items.length

    function hasNext(Iterator storage self) public view returns (bool ret) {
        return self.index < self.items.length;
    }

    /// @notice postcondition item == __verifier_old_bool(self.items[self.index])
    /// @notice postcondition self.index == __verifier_old_uint(self.index) + 1
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || self.items[i] == __verifier_old_bool(self.items[i])

    function next(Iterator storage self) public returns (bool item) {
        item = self.items[self.index];
        self.index++;
    }
}

// The first 6 lines of every method represent the following invariants:
// invariant forall (bool i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
// invariant forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
// invariant forall (bool i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)

library Sets {

    struct Set {
        bool[] items;
        mapping (bool => uint) location;
    }

    // For testing purposes, can be ignored

    function get(Set storage self) public view returns (bool[] memory) {
        return self.items;
    }

    /// @notice precondition forall (bool i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (bool i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice precondition forall (bool i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (bool i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition ret == self.items.length

    function size(Set storage self) public view returns (uint ret) {
        return self.items.length;
    }

    /// @notice precondition forall (bool i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (bool i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice precondition forall (bool i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (bool i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition !(ret) || self.location[num] != 0

    function contains(Set storage self, bool num) public view returns (bool ret) {
        return self.location[num] != 0;
    }

    /// @notice precondition forall (bool i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (bool i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice precondition forall (bool i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (bool i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition __verifier_old_uint(self.location[num]) != 0 || self.items[self.items.length - 1] == num
    /// @notice postcondition __verifier_old_uint(self.location[num]) != 0 || self.location[num] == self.items.length
    /// @notice postcondition __verifier_old_uint(self.location[num]) != 0 || self.items.length == __verifier_old_uint(self.items.length) +1
    /// @notice postcondition forall (uint i) __verifier_old_uint(self.location[num]) != 0 || !(0 <= i && i < self.items.length - 1) || (self.items[i] == __verifier_old_bool(self.items[i]))
    /// @notice postcondition forall (bool i) __verifier_old_uint(self.location[num]) != 0 || i == num || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition __verifier_old_uint(self.location[num]) == 0 || self.items.length == __verifier_old_uint(self.items.length)
    /// @notice postcondition forall (uint i) __verifier_old_uint(self.location[num]) == 0 || !(0 <= i && i < self.items.length) || (self.items[i] == __verifier_old_bool(self.items[i]))
    /// @notice postcondition forall (bool i) __verifier_old_uint(self.location[num]) == 0 || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition (success && __verifier_old_uint(self.location[num]) == 0) || (!success && !(__verifier_old_uint(self.location[num]) == 0))

    function add(Set storage self, bool num) public returns (bool success) {
        if (self.location[num] == 0) {
            // push first because 0 is standard value in mapping therefore location 1 refers to the first entry of items
            self.items.push(num);
            self.location[num] = self.items.length;
            return true;
        }
        return false;
    }

    /// @notice precondition forall (bool i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (bool i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice precondition forall (bool i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (bool i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition !success || (__verifier_old_uint(self.location[num]) != 0 && __verifier_old_uint(self.items.length) != 0)
    /// @notice postcondition success || (__verifier_old_uint(self.location[num]) == 0 || __verifier_old_uint(self.items.length) == 0)
    /// @notice postcondition success || self.items.length == __verifier_old_uint(self.items.length)
    /// @notice postcondition forall (uint i) success || !(0 <= i && i < self.items.length) || (self.items[i] == __verifier_old_bool(self.items[i]))
    /// @notice postcondition forall (bool i) success || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition !success || self.items.length == __verifier_old_uint(self.items.length) - 1
    /// @notice postcondition !success || self.location[num] == 0
    /// @notice postcondition forall (uint i) (!success) || !(0 <= i && i < self.items.length) || self.items[i] != num
    /// @notice postcondition forall (bool i) (!success) || !(num == __verifier_old_bool(self.items[self.items.length - 1])) || !(i != num) || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition forall (uint i) (!success) || !(num == __verifier_old_bool(self.items[self.items.length - 1])) || !(0 <= i && i < self.items.length) || (self.items[i] == __verifier_old_bool(self.items[i]))
    /// @notice postcondition forall (uint i) (!success) || (num == __verifier_old_bool(self.items[self.items.length - 1])) || !(0 <= i && i < self.items.length && i != __verifier_old_uint(self.location[num] - 1)) || (self.items[i] == __verifier_old_bool(self.items[i]))
    /// @notice postcondition (!success) || (num == __verifier_old_bool(self.items[self.items.length - 1])) || self.items[__verifier_old_uint(self.location[num] - 1)] == __verifier_old_bool(self.items[self.items.length - 1])
    /// @notice postcondition (!success) || (num == __verifier_old_bool(self.items[self.items.length - 1])) || self.location[__verifier_old_bool(self.items[self.items.length - 1])] == __verifier_old_uint(self.location[num])
    /// @notice postcondition forall (bool i) (!success) || (num == __verifier_old_bool(self.items[self.items.length - 1])) || !(i != __verifier_old_bool(self.items[self.items.length - 1]) && i != num) || (self.location[i] == __verifier_old_uint(self.location[i]))

    function remove(Set storage self, bool num) public returns (bool success) {
        if (self.location[num] == 0) return false;
        if (self.items.length == 0) return false;
        
        uint index = self.location[num] - 1;
        bool last = self.items[self.items.length - 1];

        self.location[last] = index + 1;
        self.items[index] = last;

        delete self.location[num];

        self.items.pop(); 
        return true;
    } 

    /// @notice precondition forall (bool i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (bool i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)   
    /// @notice precondition forall (bool i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (bool i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition !out || self.items.length == 0
    /// @notice postcondition out || self.items.length > 0

    function isEmpty(Set storage self) public view returns (bool out) {
        out = self.items.length == 0;
    }
}
