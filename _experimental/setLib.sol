// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

library SetIterator {

    struct Iterator {
        uint index;
        uint[] items;
    }
 
    // For testing purposes, can be ignored

    function get(Iterator storage self) public view returns (uint[] memory) {
        return self.items;
    }

    function init(Iterator storage self, Sets.Set storage set) public {
        self.items = set.values;
        self.index = 0;
    }

    /// @notice postcondition !ret || self.index < self.items.length
    /// @notice postcondition ret || self.index >= self.items.length

    function hasNext(Iterator storage self) public view returns (bool ret) {
        return self.index < self.items.length;
    }

    /// @notice postcondition item == __verifier_old_uint(self.items[self.index])
    /// @notice postcondition self.index == __verifier_old_uint(self.index) + 1
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || self.items[i] == __verifier_old_uint(self.items[i])

    function next(Iterator storage self) public returns (uint item) {
        item = self.items[self.index];
        self.index++;
    }
}

// The first 6 lines of every method represent the following invariants:
// invariant forall (uint i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.values.length) || (self.values[j] != i)
// invariant forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.values.length) && (self.values[self.location[i] - 1] == i)
// invariant forall (uint i) !(0 <= i && i < self.values.length) || (self.location[self.values[i]] - 1 == i)

library Sets {

    struct Set {
        uint[] values;
        mapping (uint => uint) location;
    }

    // For testing purposes, can be ignored

    function get(Set storage self) public view returns (uint[] memory) {
        return self.values;
    }

    /// @notice precondition forall (uint i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.values.length) || (self.values[j] != i)
    /// @notice postcondition forall (uint i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.values.length) || (self.values[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.values.length) || (self.location[self.values[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.values.length) || (self.location[self.values[i]] - 1 == i)
    /// @notice precondition forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.values.length) && (self.values[self.location[i] - 1] == i)
    /// @notice postcondition forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.values.length) && (self.values[self.location[i] - 1] == i)
    /// @notice postcondition ret == self.values.length

    function size(Set storage self) public view returns (uint ret) {
        return self.values.length;
    }

    /// @notice precondition forall (uint i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.values.length) || (self.values[j] != i)
    /// @notice postcondition forall (uint i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.values.length) || (self.values[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.values.length) || (self.location[self.values[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.values.length) || (self.location[self.values[i]] - 1 == i)
    /// @notice precondition forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.values.length) && (self.values[self.location[i] - 1] == i)
    /// @notice postcondition forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.values.length) && (self.values[self.location[i] - 1] == i)
    /// @notice postcondition !(ret) || self.location[num] != 0

    function contains(Set storage self, uint num) public view returns (bool ret) {
        return self.location[num] != 0;
    }


    /*
        => If item is in i.e self.location[num] != 0
        ensures: values length is the same
        ensures: the items in values stay the same
        ensures: the location mapping is identical to before



        => If item isnt in i.e self.location[num] == 0
        ensures: the item can now be found at the end of values
        ensures: values length has increase by 1
        ensures: the other items in values hasn't been altered
        ensures: the location mapping hasnt been altered except at 'num'

        => else:
        success == true <=> self.lcoation[num] != 0
    */
    
    /// @notice precondition forall (uint i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.values.length) || (self.values[j] != i)
    /// @notice postcondition forall (uint i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.values.length) || (self.values[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.values.length) || (self.location[self.values[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.values.length) || (self.location[self.values[i]] - 1 == i)
    /// @notice precondition forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.values.length) && (self.values[self.location[i] - 1] == i)
    /// @notice postcondition forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.values.length) && (self.values[self.location[i] - 1] == i)
    /// @notice postcondition __verifier_old_uint(self.location[num]) != 0 || self.values[self.values.length - 1] == num
    /// @notice postcondition __verifier_old_uint(self.location[num]) != 0 || self.location[num] == self.values.length
    /// @notice postcondition __verifier_old_uint(self.location[num]) != 0 || self.values.length == __verifier_old_uint(self.values.length) +1
    /// @notice postcondition forall (uint i) __verifier_old_uint(self.location[num]) != 0 || !(0 <= i && i < self.values.length - 1) || (self.values[i] == __verifier_old_uint(self.values[i]))
    /// @notice postcondition forall (uint i) __verifier_old_uint(self.location[num]) != 0 || i == num || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition __verifier_old_uint(self.location[num]) == 0 || self.values.length == __verifier_old_uint(self.values.length)
    /// @notice postcondition forall (uint i) __verifier_old_uint(self.location[num]) == 0 || !(0 <= i && i < self.values.length) || (self.values[i] == __verifier_old_uint(self.values[i]))
    /// @notice postcondition forall (uint i) __verifier_old_uint(self.location[num]) == 0 || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition (success && __verifier_old_uint(self.location[num]) == 0) || (!success && !(__verifier_old_uint(self.location[num]) == 0))

    function add(Set storage self, uint num) public returns (bool success) {
        if (self.location[num] == 0) {
            // push first because 0 is standard value in mapping therefore location 1 refers to the first entry of values
            self.values.push(num);
            self.location[num] = self.values.length;
            return true;
        }
        return false;
    }

    /*
        requires: Nothing, however we have 1 precondition because the prover needs them for the current state of the implementation it will be factored to a invariant later

        => If item is in i.e self.location[num] != 0

            ensure: location[item] is self to 0
            ensure: values.length reduces by one
            ensure: num no longer appears in values


            => If the item was the last element of values
            ensure: every other location[x] remains unchanged
            ensure: \old(values) is the same as values bar the last element

            => If it wasnt
            ensure: \old(values) is the same as values bar the removed element, except the last item has moved to where the removed item used to be
                all except at the removal index remain unchanged
                at the removal index the new value is now the old end of values
            ensure: every other location[x] remains unchanged except possibly the one of the last element, which is changd to the index + 1 where the removed value was in values
                all locations except at index num and last are unchanged
                at index last the new value is where num used to be



        => If item isnt in i.e self.location[num] == 0

        ensure: values.length doesnt change
        ensure: values stays identical
        ensure:: location stays identical

    */

    /// @notice precondition forall (uint i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.values.length) || (self.values[j] != i)
    /// @notice postcondition forall (uint i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.values.length) || (self.values[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.values.length) || (self.location[self.values[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.values.length) || (self.location[self.values[i]] - 1 == i)
    /// @notice precondition forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.values.length) && (self.values[self.location[i] - 1] == i)
    /// @notice postcondition forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.values.length) && (self.values[self.location[i] - 1] == i)
    /// @notice postcondition !success || (__verifier_old_uint(self.location[num]) != 0 && __verifier_old_uint(self.values.length) != 0)
    /// @notice postcondition success || (__verifier_old_uint(self.location[num]) == 0 || __verifier_old_uint(self.values.length) == 0)
    /// @notice postcondition success || self.values.length == __verifier_old_uint(self.values.length)
    /// @notice postcondition forall (uint i) success || !(0 <= i && i < self.values.length) || (self.values[i] == __verifier_old_uint(self.values[i]))
    /// @notice postcondition forall (uint i) success || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition !success || self.values.length == __verifier_old_uint(self.values.length) - 1
    /// @notice postcondition !success || self.location[num] == 0
    /// @notice postcondition forall (uint i) (!success) || !(0 <= i && i < self.values.length) || self.values[i] != num
    /// @notice postcondition forall (uint i) (!success) || !(num == __verifier_old_uint(self.values[self.values.length - 1])) || !(i != num) || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition forall (uint i) (!success) || !(num == __verifier_old_uint(self.values[self.values.length - 1])) || !(0 <= i && i < self.values.length) || (self.values[i] == __verifier_old_uint(self.values[i]))
    /// @notice postcondition forall (uint i) (!success) || (num == __verifier_old_uint(self.values[self.values.length - 1])) || !(0 <= i && i < self.values.length && i != __verifier_old_uint(self.location[num] - 1)) || (self.values[i] == __verifier_old_uint(self.values[i]))
    /// @notice postcondition (!success) || (num == __verifier_old_uint(self.values[self.values.length - 1])) || self.values[__verifier_old_uint(self.location[num] - 1)] == __verifier_old_uint(self.values[self.values.length - 1])
    /// @notice postcondition (!success) || (num == __verifier_old_uint(self.values[self.values.length - 1])) || self.location[__verifier_old_uint(self.values[self.values.length - 1])] == __verifier_old_uint(self.location[num])
    /// @notice postcondition forall (uint i) (!success) || (num == __verifier_old_uint(self.values[self.values.length - 1])) || !(i != __verifier_old_uint(self.values[self.values.length - 1]) && i != num) || (self.location[i] == __verifier_old_uint(self.location[i]))

    function remove(Set storage self, uint num) public returns (bool success) {
        if (self.location[num] == 0) return false;
        if (self.values.length == 0) return false;
        
        uint index = self.location[num] - 1;
        uint last = self.values[self.values.length - 1];

        self.location[last] = index + 1;
        self.values[index] = last;

        delete self.location[num];

        self.values.pop(); 
        return true;
    } 

    /// @notice precondition forall (uint i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.values.length) || (self.values[j] != i)
    /// @notice postcondition forall (uint i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.values.length) || (self.values[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.values.length) || (self.location[self.values[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.values.length) || (self.location[self.values[i]] - 1 == i)   
    /// @notice precondition forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.values.length) && (self.values[self.location[i] - 1] == i)
    /// @notice postcondition forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.values.length) && (self.values[self.location[i] - 1] == i)
    /// @notice postcondition !out || self.values.length == 0
    /// @notice postcondition out || self.values.length > 0

    function isEmpty(Set storage self) public view returns (bool out) {
        out = self.values.length == 0;
    }

    /// @notice precondition forall (uint i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.values.length) || (self.values[j] != i)
    /// @notice postcondition forall (uint i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.values.length) || (self.values[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.values.length) || (self.location[self.values[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.values.length) || (self.location[self.values[i]] - 1 == i)
    /// @notice precondition forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.values.length) && (self.values[self.location[i] - 1] == i)
    /// @notice postcondition forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.values.length) && (self.values[self.location[i] - 1] == i)
    /// @notice postcondition ret == self.values[index]

    function get(Set storage self, uint256 index) public view returns (uint256 ret) {
        require(index < self.values.length);
        require(index >= 0);

        ret = self.values[index];
    }
}
