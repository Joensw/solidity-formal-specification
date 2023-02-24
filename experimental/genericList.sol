// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

library Lists {

    struct List {
        %TYPE%[] _data;
    }

    // For testing purposes, can be ignored
    
    function getData(List storage self) public view returns (%TYPE%[] memory) {
        return self._data;
    }

    /*
        X ensures: All previous values of the self._data remain unchanged
        X ensures: The added value is found at the end of the self._data
        X ensures: The Length of the self._data is the old length + 1 
    */

    /// @notice modifies self._data
    /// @notice postcondition forall (uint i) !(0 <= i && i < self._data.length - 1) || (self._data[i] == __verifier_old_%TYPE%(self._data[i]))
    /// @notice postcondition self._data[self._data.length - 1] == num 
    /// @notice postcondition self._data.length == __verifier_old_uint(self._data.length) + 1

    function add(List storage self, %TYPE% num) public {
        self._data.push(num);
    }

    /// @notice postcondition ret == self._data.length

    function size(List storage self) public view returns (uint ret) {
        ret = self._data.length;
    }

    /*
        ensures: if the return value is true, there exists an index i so that self._data[i] == num
        ensures: if the return value is false, for all indices between 0 and the self._datas length - 1 self._data[i] != num
        ensures: The self._data remains unchanged (should be implicit through view)
    */

    /// @notice postcondition exists (uint i) (!isContained || (0 <= i && i < self._data.length && self._data[i] == num))
    /// @notice postcondition forall (uint i) (isContained || !(0 <= i && i < self._data.length) || self._data[i] != num)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self._data.length) || (self._data[i] == __verifier_old_%TYPE%(self._data[i]))

    function contains(List storage self, %TYPE% num) public view returns (bool isContained) {

        /// @notice invariant i >= 0 && i <= self._data.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (self._data[k] != num)

        for (uint i = 0; i < self._data.length; i++) {
            if (self._data[i] == num) {
                return true;
            }
        }

        return false;
    }

    /*
        requires: index < self._data.length
        ensures: the return value is the value at the specified index in self._data
        ensures: the self._data is now one element shorter
        ensures: the other self._data elements stay unchanged
    */

    /// @notice postcondition self._data.length == __verifier_old_uint(self._data.length) - 1
    /// @notice postcondition forall (uint i) !(i >= 0 && i < index) || (self._data[i] == __verifier_old_%TYPE%(self._data[i]))
    /// @notice postcondition forall (uint i) !(i >= index && i < self._data.length) || (self._data[i] == __verifier_old_%TYPE%(self._data[i + 1]))
    /// @notice postcondition ret == __verifier_old_%TYPE%(self._data[index])
    /// @notice modifies self._data

    function remove(List storage self, uint index) public returns (%TYPE% ret) {

        require(index < self._data.length);
        require(index >= 0);

        ret = self._data[index];

        /// @notice invariant i >= index && i < self._data.length
        /// @notice invariant self._data[self._data.length - 1] ==  __verifier_old_%TYPE%(self._data[self._data.length - 1])
        /// @notice invariant self._data.length == __verifier_old_uint(self._data.length)
        /// @notice invariant forall (uint k) !(k >= 0 && k < index) || (self._data[k] == __verifier_old_%TYPE%(self._data[k]))
        /// @notice invariant forall (uint k) !(k >= index && k < i) || (self._data[k] == __verifier_old_%TYPE%(self._data[k + 1]))
        /// @notice invariant forall (uint k) !(k >= i && k < self._data.length) || (self._data[k] == __verifier_old_%TYPE%(self._data[k]))

        for (uint i = index; i < self._data.length - 1; i++) {
            self._data[i] = self._data[i + 1];
        }

        self._data.pop();
    }

    /*
        Remove first occurence
        iterate on found delete and shift and return
        Incase of deletion every other element can still be found just  moved

        ensures: success => modifies self._data
        ensures: success => length is reduced by one
        ensures !success => length is the same aas before
    */

    /// @notice modifies self._data if (success)
    /// @notice postcondition !(success) || self._data.length == __verifier_old_uint(self._data.length) - 1
    /// @notice postcondition forall (uint i) !(success) || !(i >= 0 && i < outIndex) || (self._data[i] == __verifier_old_%TYPE%(self._data[i]))
    /// @notice postcondition forall (uint i) !(success) || !(i >= outIndex && i < self._data.length) || (self._data[i] == __verifier_old_%TYPE%(self._data[i + 1]))
    /// @notice postcondition (success) || self._data.length == __verifier_old_uint(self._data.length)

    function removeObject(List storage self, %TYPE% val) public returns (bool success, uint outIndex) { 
        bool found = false;
        uint index = 0;
        
        /// @notice invariant i >= 0 && i <= self._data.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (self._data[k] != val)

        for (uint i = 0; i < self._data.length; i++) {
            if (self._data[i] == val) {
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

    /// @notice postcondition !valid || self._data[index] == val
    /// @notice postcondition forall (uint i) !valid || !(i >= 0 && i < index) || self._data[i] != val
    /// @notice postcondition forall (uint i) valid || !(i >= 0 && i < self._data.length) || self._data[i] != val

    function indexOf(List storage self, %TYPE% val) public view returns (bool valid, uint index){
        index = 0;

        /// @notice invariant i >= 0 && i <= self._data.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (self._data[k] != val)

        for (uint i = 0; i < self._data.length; i++) {
            if (self._data[i] == val){
                index = i;
                return (true, index);
            }
        }
        return (false, index);
    }

    /// @notice postcondition !out || self._data.length == 0
    /// @notice postcondition out || self._data.length > 0

    function isEmpty(List storage self) public view returns (bool out) {
        out = self._data.length == 0;
    }

    /*
        requires: index < self._data.length
        ensures: the return value is the value at the specified index in self._data
        ensures: The self._data remains unchanged (should be implicit through view)
    */

    /// @notice postcondition ret == self._data[index]

    function get(List storage self, uint index) public view returns (%TYPE% ret) {
        require(index < self._data.length);
        require(index >= 0);

        ret = self._data[index];
    }
}
