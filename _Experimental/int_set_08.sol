// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SetIterator {

    struct Iterator {
        uint index;
        int[] items;
    }

    /// @notice postcondition !ret || self.index < self.items.length
    /// @notice postcondition ret || self.index >= self.items.length

    function hasNext(Iterator storage self) public view returns (bool ret) {
        return self.index < self.items.length;
    }

    /// @notice postcondition item == __verifier_old_int(self.items[self.index])
    /// @notice postcondition self.index == __verifier_old_uint(self.index) + 1
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || self.items[i] == __verifier_old_int(self.items[i])

    function next(Iterator storage self) public returns (int item) {
        item = self.items[self.index];
        self.index++;
    }
}

// The first 6 lines of every method represent the following invariants:
// invariant forall (int i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
// invariant forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
// invariant forall (int i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)

library Sets {

    struct Set {
        int[] items;
        mapping (int => uint) location;
    }

    // For testing purposes, can be ignored

    function get(Set storage self) public view returns (int[] memory) {
        return self.items;
    }

    /// @notice precondition forall (int i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (int i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice precondition forall (int i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (int i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition ret == self.items.length

    function size(Set storage self) public view returns (uint ret) {
        return self.items.length;
    }

    /// @notice precondition forall (int i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (int i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice precondition forall (int i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (int i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition !(ret) || self.location[num] != 0
    /// @notice postcondition ret && self.location[num] != 0 || !ret && self.location[num] == 0

    function contains(Set storage self, int num) public view returns (bool ret) {
        return self.location[num] != 0;
    }

    /// @notice precondition forall (int i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (int i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice precondition forall (int i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (int i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition __verifier_old_uint(self.location[num]) != 0 || self.items[self.items.length - 1] == num
    /// @notice postcondition __verifier_old_uint(self.location[num]) != 0 || self.location[num] == self.items.length
    /// @notice postcondition __verifier_old_uint(self.location[num]) != 0 || self.items.length == __verifier_old_uint(self.items.length) +1
    /// @notice postcondition forall (uint i) __verifier_old_uint(self.location[num]) != 0 || !(0 <= i && i < self.items.length - 1) || (self.items[i] == __verifier_old_int(self.items[i]))
    /// @notice postcondition forall (int i) __verifier_old_uint(self.location[num]) != 0 || i == num || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition __verifier_old_uint(self.location[num]) == 0 || self.items.length == __verifier_old_uint(self.items.length)
    /// @notice postcondition forall (uint i) __verifier_old_uint(self.location[num]) == 0 || !(0 <= i && i < self.items.length) || (self.items[i] == __verifier_old_int(self.items[i]))
    /// @notice postcondition forall (int i) __verifier_old_uint(self.location[num]) == 0 || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition (success && __verifier_old_uint(self.location[num]) == 0) || (!success && !(__verifier_old_uint(self.location[num]) == 0))
    /// @notice postcondition !success && __verifier_old_uint(self.location[num]) != 0 || success && __verifier_old_uint(self.location[num]) == 0

    function add(Set storage self, int num) public returns (bool success) {
        if (self.location[num] == 0) {
            // push first because 0 is standard value in mapping therefore location 1 refers to the first entry of items
            self.items.push(num);
            self.location[num] = self.items.length;
            return true;
        }
        return false;
    }

    /// @notice precondition forall (int i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (int i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice precondition forall (int i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (int i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition !success || (__verifier_old_uint(self.location[num]) != 0 && __verifier_old_uint(self.items.length) != 0)
    /// @notice postcondition success || (__verifier_old_uint(self.location[num]) == 0 || __verifier_old_uint(self.items.length) == 0)
    /// @notice postcondition success || self.items.length == __verifier_old_uint(self.items.length)
    /// @notice postcondition forall (uint i) success || !(0 <= i && i < self.items.length) || (self.items[i] == __verifier_old_int(self.items[i]))
    /// @notice postcondition forall (int i) success || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition !success || self.items.length == __verifier_old_uint(self.items.length) - 1
    /// @notice postcondition !success || self.location[num] == 0
    /// @notice postcondition forall (uint i) (!success) || !(0 <= i && i < self.items.length) || self.items[i] != num
    /// @notice postcondition forall (int i) (!success) || !(num == __verifier_old_int(self.items[self.items.length - 1])) || !(i != num) || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition forall (uint i) (!success) || !(num == __verifier_old_int(self.items[self.items.length - 1])) || !(0 <= i && i < self.items.length) || (self.items[i] == __verifier_old_int(self.items[i]))
    /// @notice postcondition forall (uint i) (!success) || (num == __verifier_old_int(self.items[self.items.length - 1])) || !(0 <= i && i < self.items.length && i != __verifier_old_uint(self.location[num] - 1)) || (self.items[i] == __verifier_old_int(self.items[i]))
    /// @notice postcondition (!success) || (num == __verifier_old_int(self.items[self.items.length - 1])) || self.items[__verifier_old_uint(self.location[num] - 1)] == __verifier_old_int(self.items[self.items.length - 1])
    /// @notice postcondition (!success) || (num == __verifier_old_int(self.items[self.items.length - 1])) || self.location[__verifier_old_int(self.items[self.items.length - 1])] == __verifier_old_uint(self.location[num])
    /// @notice postcondition forall (int i) (!success) || (num == __verifier_old_int(self.items[self.items.length - 1])) || !(i != __verifier_old_int(self.items[self.items.length - 1]) && i != num) || (self.location[i] == __verifier_old_uint(self.location[i]))
    /// @notice postcondition !success && (__verifier_old_uint(self.location[num]) == 0 || __verifier_old_uint(self.items.length) == 0) || success && __verifier_old_uint(self.location[num]) != 0 && __verifier_old_uint(self.items.length) != 0

    function remove(Set storage self, int num) public returns (bool success) {
        if (self.location[num] == 0) return false;
        if (self.items.length == 0) return false;
        
        uint index = self.location[num] - 1;
        int last = self.items[self.items.length - 1];

        self.location[last] = index + 1;
        self.items[index] = last;

        delete self.location[num];

        self.items.pop(); 
        return true;
    } 

    /// @notice precondition forall (int i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (int i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)   
    /// @notice precondition forall (int i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (int i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition !out || self.items.length == 0
    /// @notice postcondition out || self.items.length > 0

    function isEmpty(Set storage self) public view returns (bool out) {
        out = self.items.length == 0;
    }

    function iterator(Set storage self) public view returns (SetIterator.Iterator memory)  {
        SetIterator.Iterator memory it;
        it.items = self.items;
        it.index = 0;
        return it;
    }
}

contract Test {

    using Sets for Sets.Set;
    using SetIterator for SetIterator.Iterator;

    Sets.Set mySet;
    SetIterator.Iterator myIterator;

    int[] public test_array;

    function add(int toAdd) public returns (bool) {
        return mySet.add(toAdd);
    }

    function contains(int toAdd) public view returns (bool) {
        return mySet.contains(toAdd);
    }
    function remove(int toAdd) public returns (bool) {
        return mySet.remove(toAdd);
    }

    function size() public view returns (uint) {
        return mySet.size();
    }

    function iterate() public returns (uint) {
        myIterator = mySet.iterator();
        uint max = 10;
        uint current = 1;
        while (myIterator.hasNext() && current < max) {
            int item = myIterator.next();
            test_array.push(item);
            current++;
        }
        return current;
    }

    function testIteratorItems() public view returns (int[] memory) {
        SetIterator.Iterator memory currentIterator = mySet.iterator();
        return currentIterator.items;
    }

    function get() public view returns (int[] memory) {
        return test_array;
    }
}
