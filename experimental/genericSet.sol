// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

library SetIterator {

    struct Iterator {
        uint index;
        %TYPE%[] items;
    }
 
    // For testing purposes, can be ignored

    function get(Iterator storage self) public view returns (%TYPE%[] memory) {
        return self.items;
    }

    /// @notice postcondition self.index == 0
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items) || self.items[i] == set.items

    function init(Iterator storage self, Sets.Set storage set) public {
        self.items = set.items;
        self.index = 0;
    }

    /// @notice postcondition !ret || self.index < self.items.length
    /// @notice postcondition ret || self.index >= self.items.length

    function hasNext(Iterator storage self) public view returns (bool ret) {
        return self.index < self.items.length;
    }

    /// @notice postcondition item == __verifier_old_%TYPE%(self.items[self.index])
    /// @notice postcondition self.index == __verifier_old_uint(self.index) + 1
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || self.items[i] == __verifier_old_%TYPE%(self.items[i])

    function next(Iterator storage self) public returns (%TYPE% item) {
        item = self.items[self.index];
        self.index++;
    }
}

// The first 6 lines of every method represent the following invariants:
// invariant forall (%TYPE% i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
// invariant forall (uint i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
// invariant forall (%TYPE% i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)

library Sets {

    struct Set {
        %TYPE%[] items;
        mapping (%TYPE% => uint) location;
    }

    // For testing purposes, can be ignored

    function get(Set storage self) public view returns (%TYPE%[] memory) {
        return self.items;
    }

    /// @notice precondition forall (%TYPE% i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (%TYPE% i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice precondition forall (%TYPE% i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (%TYPE% i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition ret == self.items.length

    function size(Set storage self) public view returns (uint ret) {
        return self.items.length;
    }

    /// @notice precondition forall (%TYPE% i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (%TYPE% i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice precondition forall (%TYPE% i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (%TYPE% i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition !(ret) || self.location[num] != 0

    function contains(Set storage self, %TYPE% num) public view returns (bool ret) {
        return self.location[num] != 0;
    }


    /*
        => If item is in i.e self.location[num] != 0
        ensures: items length is the same
        ensures: the items in items stay the same
        ensures: the location mapping is identical to before



        => If item isnt in i.e self.location[num] == 0
        ensures: the item can now be found at the end of items
        ensures: items length has increase by 1
        ensures: the other items in items hasn't been altered
        ensures: the location mapping hasnt been altered except at 'num'

        => else:
        success == true <=> self.lcoation[num] != 0
    */
    /// @notice precondition forall (%TYPE% i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (%TYPE% i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice precondition forall (%TYPE% i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (%TYPE% i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice modifies self.location[num] if self.location[num] == 0
    /// @notice modifies self.items if self.location[num] == 0
    /// @notice postcondition __verifier_old_uint(self.location[num]) != 0 || self.items[self.items.length - 1] == num
    /// @notice postcondition __verifier_old_uint(self.location[num]) != 0 || self.location[num] == self.items.length
    /// @notice postcondition __verifier_old_uint(self.location[num]) != 0 || self.items.length == __verifier_old_uint(self.items.length) +1
    /// @notice postcondition forall (uint i) __verifier_old_uint(self.location[num]) != 0 || !(0 <= i && i < self.items.length - 1) || (self.items[i] == __verifier_old_%TYPE%(self.items[i]))
    /// @notice postcondition forall (%TYPE% i) __verifier_old_uint(self.location[num]) != 0 || i == num || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition __verifier_old_uint(self.location[num]) == 0 || self.items.length == __verifier_old_uint(self.items.length)
    /// @notice postcondition forall (uint i) __verifier_old_uint(self.location[num]) == 0 || !(0 <= i && i < self.items.length) || (self.items[i] == __verifier_old_%TYPE%(self.items[i]))
    /// @notice postcondition forall (%TYPE% i) __verifier_old_uint(self.location[num]) == 0 || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition (success && __verifier_old_uint(self.location[num]) == 0) || (!success && !(__verifier_old_uint(self.location[num]) == 0))

    function add(Set storage self, %TYPE% num) public returns (bool success) {
        if (self.location[num] == 0) {
            // push first because 0 is standard value in mapping therefore location 1 refers to the first entry of items
            self.items.push(num);
            self.location[num] = self.items.length;
            return true;
        }
        return false;
    }

    /*
        requires: Nothing, however we have 1 precondition because the prover needs them for the current state of the implementation it will be factored to a invariant later

        => If item is in i.e self.location[num] != 0

            ensure: location[item] is self to 0
            ensure: items.length reduces by one
            ensure: num no longer appears in items


            => If the item was the last element of items
            ensure: every other location[x] remains unchanged
            ensure: \old(items) is the same as items bar the last element

            => If it wasnt
            ensure: \old(items) is the same as items bar the removed element, except the last item has moved to where the removed item used to be
                all except at the removal index remain unchanged
                at the removal index the new value is now the old end of items
            ensure: every other location[x] remains unchanged except possibly the one of the last element, which is changd to the index + 1 where the removed value was in items
                all locations except at index num and last are unchanged
                at index last the new value is where num used to be



        => If item isnt in i.e self.location[num] == 0

        ensure: items.length doesnt change
        ensure: items stays identical
        ensure:: location stays identical

    */

    /// @notice precondition forall (%TYPE% i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (%TYPE% i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice precondition forall (%TYPE% i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (%TYPE% i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice modifies self.items if success
    /// @notice modifies self.location if success
    /// @notice postcondition !success || (__verifier_old_uint(self.location[num]) != 0 && __verifier_old_uint(self.items.length) != 0)
    /// @notice postcondition success || (__verifier_old_uint(self.location[num]) == 0 || __verifier_old_uint(self.items.length) == 0)
    /// @notice postcondition success || self.items.length == __verifier_old_uint(self.items.length)
    /// @notice postcondition forall (uint i) success || !(0 <= i && i < self.items.length) || (self.items[i] == __verifier_old_%TYPE%(self.items[i]))
    /// @notice postcondition forall (%TYPE% i) success || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition !success || self.items.length == __verifier_old_uint(self.items.length) - 1
    /// @notice postcondition !success || self.location[num] == 0
    /// @notice postcondition forall (uint i) (!success) || !(0 <= i && i < self.items.length) || self.items[i] != num
    /// @notice postcondition forall (%TYPE% i) (!success) || !(num == __verifier_old_%TYPE%(self.items[self.items.length - 1])) || !(i != num) || self.location[i] == __verifier_old_uint(self.location[i])
    /// @notice postcondition forall (uint i) (!success) || !(num == __verifier_old_%TYPE%(self.items[self.items.length - 1])) || !(0 <= i && i < self.items.length) || (self.items[i] == __verifier_old_%TYPE%(self.items[i]))
    /// @notice postcondition forall (uint i) (!success) || (num == __verifier_old_%TYPE%(self.items[self.items.length - 1])) || !(0 <= i && i < self.items.length && i != __verifier_old_uint(self.location[num] - 1)) || (self.items[i] == __verifier_old_%TYPE%(self.items[i]))
    /// @notice postcondition (!success) || (num == __verifier_old_%TYPE%(self.items[self.items.length - 1])) || self.items[__verifier_old_uint(self.location[num] - 1)] == __verifier_old_%TYPE%(self.items[self.items.length - 1])
    /// @notice postcondition (!success) || (num == __verifier_old_%TYPE%(self.items[self.items.length - 1])) || self.location[__verifier_old_%TYPE%(self.items[self.items.length - 1])] == __verifier_old_uint(self.location[num])
    /// @notice postcondition forall (%TYPE% i) (!success) || (num == __verifier_old_%TYPE%(self.items[self.items.length - 1])) || !(i != __verifier_old_%TYPE%(self.items[self.items.length - 1]) && i != num) || (self.location[i] == __verifier_old_uint(self.location[i]))

    function remove(Set storage self, %TYPE% num) public returns (bool success) {
        if (self.location[num] == 0) return false;
        if (self.items.length == 0) return false;
        
        uint index = self.location[num] - 1;
        %TYPE% last = self.items[self.items.length - 1];

        self.location[last] = index + 1;
        self.items[index] = last;

        delete self.location[num];

        self.items.pop(); 
        return true;
    } 

    /// @notice precondition forall (%TYPE% i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (%TYPE% i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)   
    /// @notice precondition forall (%TYPE% i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (%TYPE% i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition !out || self.items.length == 0
    /// @notice postcondition out || self.items.length > 0

    function isEmpty(Set storage self) public view returns (bool out) {
        out = self.items.length == 0;
    }

    /// @notice precondition forall (%TYPE% i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice postcondition forall (%TYPE% i) forall (uint j) !(self.location[i] == 0) || !(0 <= j && j < self.items.length) || (self.items[j] != i)
    /// @notice precondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.location[self.items[i]] - 1 == i)
    /// @notice precondition forall (%TYPE% i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition forall (%TYPE% i) !(self.location[i] != 0) || (self.location[i] - 1 < self.items.length) && (self.items[self.location[i] - 1] == i)
    /// @notice postcondition ret == self.items[index]

    function get(Set storage self, uint index) public view returns (%TYPE% ret) {
        require(index < self.items.length);
        require(index >= 0);

        ret = self.items[index];
    }
}
