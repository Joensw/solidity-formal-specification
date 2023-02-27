// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

library Lists {

    struct List {
        %TYPE%[] items;
    }

    // For testing purposes, can be ignored
    
    function getData(List storage self) public view returns (%TYPE%[] memory) {
        return self.items;
    }

    /*
        X ensures: All previous values of the self.items remain unchanged
        X ensures: The added value is found at the end of the self.items
        X ensures: The Length of the self.items is the old length + 1 
    */

    /// @notice modifies self.items
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length - 1) || (self.items[i] == __verifier_old_%TYPE%(self.items[i]))
    /// @notice postcondition self.items[self.items.length - 1] == num 
    /// @notice postcondition self.items.length == __verifier_old_uint(self.items.length) + 1

    function add(List storage self, %TYPE% num) public {
        self.items.push(num);
    }

    /// @notice postcondition ret == self.items.length

    function size(List storage self) public view returns (uint ret) {
        ret = self.items.length;
    }

    /*
        ensures: if the return value is true, there exists an index i so that self.items[i] == num
        ensures: if the return value is false, for all indices between 0 and the self.itemss length - 1 self.items[i] != num
        ensures: The self.items remains unchanged (should be implicit through view)
    */

    /// @notice postcondition exists (uint i) (!isContained || (0 <= i && i < self.items.length && self.items[i] == num))
    /// @notice postcondition forall (uint i) (isContained || !(0 <= i && i < self.items.length) || self.items[i] != num)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.items[i] == __verifier_old_%TYPE%(self.items[i]))

    function contains(List storage self, %TYPE% num) public view returns (bool isContained) {

        /// @notice invariant i >= 0 && i <= self.items.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (self.items[k] != num)

        for (uint i = 0; i < self.items.length; i++) {
            if (self.items[i] == num) {
                return true;
            }
        }

        return false;
    }

    /*
        requires: index < self.items.length
        ensures: the return value is the value at the specified index in self.items
        ensures: the self.items is now one element shorter
        ensures: the other self.items elements stay unchanged
    */

    /// @notice postcondition self.items.length == __verifier_old_uint(self.items.length) - 1
    /// @notice postcondition forall (uint i) !(i >= 0 && i < index) || (self.items[i] == __verifier_old_%TYPE%(self.items[i]))
    /// @notice postcondition forall (uint i) !(i >= index && i < self.items.length) || (self.items[i] == __verifier_old_%TYPE%(self.items[i + 1]))
    /// @notice postcondition ret == __verifier_old_%TYPE%(self.items[index])
    /// @notice modifies self.items

    function remove(List storage self, uint index) public returns (%TYPE% ret) {

        require(index < self.items.length);
        require(index >= 0);

        ret = self.items[index];

        /// @notice invariant i >= index && i < self.items.length
        /// @notice invariant self.items[self.items.length - 1] ==  __verifier_old_%TYPE%(self.items[self.items.length - 1])
        /// @notice invariant self.items.length == __verifier_old_uint(self.items.length)
        /// @notice invariant forall (uint k) !(k >= 0 && k < index) || (self.items[k] == __verifier_old_%TYPE%(self.items[k]))
        /// @notice invariant forall (uint k) !(k >= index && k < i) || (self.items[k] == __verifier_old_%TYPE%(self.items[k + 1]))
        /// @notice invariant forall (uint k) !(k >= i && k < self.items.length) || (self.items[k] == __verifier_old_%TYPE%(self.items[k]))

        for (uint i = index; i < self.items.length - 1; i++) {
            self.items[i] = self.items[i + 1];
        }

        self.items.pop();
    }

    /*
        Remove first occurence
        iterate on found delete and shift and return
        Incase of deletion every other element can still be found just  moved

        ensures: success => modifies self.items
        ensures: success => length is reduced by one
        ensures !success => length is the same aas before
    */

    /// @notice modifies self.items if (success)
    /// @notice postcondition !(success) || self.items.length == __verifier_old_uint(self.items.length) - 1
    /// @notice postcondition forall (uint i) !(success) || !(i >= 0 && i < outIndex) || (self.items[i] == __verifier_old_%TYPE%(self.items[i]))
    /// @notice postcondition forall (uint i) !(success) || !(i >= outIndex && i < self.items.length) || (self.items[i] == __verifier_old_%TYPE%(self.items[i + 1]))
    /// @notice postcondition (success) || self.items.length == __verifier_old_uint(self.items.length)

    function removeObject(List storage self, %TYPE% val) public returns (bool success, uint outIndex) { 
        bool found = false;
        uint index = 0;
        
        /// @notice invariant i >= 0 && i <= self.items.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (self.items[k] != val)

        for (uint i = 0; i < self.items.length; i++) {
            if (self.items[i] == val) {
                found = true;
                index = i;
                break;
            }
        }

        if (found) {
            remove(self, index);
            return (true, index);
        }

        // what we return here as an index doesnt matter, as the first return value is false anyway
        return (false, index);
    }

    /// @notice postcondition !valid || self.items[index] == val
    /// @notice postcondition forall (uint i) !valid || !(i >= 0 && i < index) || self.items[i] != val
    /// @notice postcondition forall (uint i) valid || !(i >= 0 && i < self.items.length) || self.items[i] != val

    function indexOf(List storage self, %TYPE% val) public view returns (bool valid, uint index){
        index = 0;

        /// @notice invariant i >= 0 && i <= self.items.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (self.items[k] != val)

        for (uint i = 0; i < self.items.length; i++) {
            if (self.items[i] == val){
                index = i;
                return (true, index);
            }
        }
        return (false, index);
    }

    /// @notice postcondition !out || self.items.length == 0
    /// @notice postcondition out || self.items.length > 0

    function isEmpty(List storage self) public view returns (bool out) {
        out = self.items.length == 0;
    }

    /*
        requires: index < self.items.length
        ensures: the return value is the value at the specified index in self.items
        ensures: The self.items remains unchanged (should be implicit through view)
    */

    /// @notice postcondition ret == self.items[index]

    function get(List storage self, uint index) public view returns (%TYPE% ret) {
        require(index < self.items.length);
        require(index >= 0);

        ret = self.items[index];
    }
}
