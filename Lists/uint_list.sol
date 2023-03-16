// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

library Lists {

    struct List {
        uint[] items;
    }

    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length - 1) || (self.items[i] == __verifier_old_uint(self.items[i]))
    /// @notice postcondition self.items[self.items.length - 1] == num 
    /// @notice postcondition self.items.length == __verifier_old_uint(self.items.length) + 1

    function add(List storage self, uint num) public {
        self.items.push(num);
    }

    /// @notice postcondition ret == self.items.length

    function size(List storage self) public view returns (uint ret) {
        ret = self.items.length;
    }

    /// @notice postcondition exists (uint i) (!isContained || (0 <= i && i < self.items.length && self.items[i] == num))
    /// @notice postcondition forall (uint i) (isContained || !(0 <= i && i < self.items.length) || self.items[i] != num)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.items[i] == __verifier_old_uint(self.items[i]))

    function contains(List storage self, uint num) public view returns (bool isContained) {

        /// @notice invariant i >= 0 && i <= self.items.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (self.items[k] != num)

        for (uint i = 0; i < self.items.length; i++) {
            if (self.items[i] == num) {
                return true;
            }
        }

        return false;
    }

    /// @notice postcondition self.items.length == __verifier_old_uint(self.items.length) - 1
    /// @notice postcondition forall (uint i) !(i >= 0 && i < index) || (self.items[i] == __verifier_old_uint(self.items[i]))
    /// @notice postcondition forall (uint i) !(i >= index && i < self.items.length) || (self.items[i] == __verifier_old_uint(self.items[i + 1]))
    /// @notice postcondition ret == __verifier_old_uint(self.items[index])

    function remove(List storage self, uint index) public returns (uint ret) {

        require(index < self.items.length);
        require(index >= 0);

        ret = self.items[index];

        /// @notice invariant i >= index && i < self.items.length
        /// @notice invariant self.items[self.items.length - 1] ==  __verifier_old_uint(self.items[self.items.length - 1])
        /// @notice invariant self.items.length == __verifier_old_uint(self.items.length)
        /// @notice invariant forall (uint k) !(k >= 0 && k < index) || (self.items[k] == __verifier_old_uint(self.items[k]))
        /// @notice invariant forall (uint k) !(k >= index && k < i) || (self.items[k] == __verifier_old_uint(self.items[k + 1]))
        /// @notice invariant forall (uint k) !(k >= i && k < self.items.length) || (self.items[k] == __verifier_old_uint(self.items[k]))

        for (uint i = index; i < self.items.length - 1; i++) {
            self.items[i] = self.items[i + 1];
        }

        self.items.pop();
    }

    /// @notice postcondition !(success) || self.items.length == __verifier_old_uint(self.items.length) - 1
    /// @notice postcondition forall (uint i) !(success) || !(i >= 0 && i < outIndex) || (self.items[i] == __verifier_old_uint(self.items[i]))
    /// @notice postcondition forall (uint i) !(success) || !(i >= outIndex && i < self.items.length) || (self.items[i] == __verifier_old_uint(self.items[i + 1]))
    /// @notice postcondition (success) || self.items.length == __verifier_old_uint(self.items.length)

    function removeObject(List storage self, uint val) public returns (bool success, uint outIndex) { 
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

    function indexOf(List storage self, uint val) public view returns (bool valid, uint index){
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

    /// @notice postcondition ret == self.items[index]

    function get(List storage self, uint index) public view returns (uint ret) {
        require(index < self.items.length);
        require(index >= 0);

        ret = self.items[index];
    }

    /// @notice postcondition forall (uint i) !(i >= 0 && i < index) || (self.items[i] == __verifier_old_uint(self.items[i]))
    /// @notice postcondition forall (uint i) !(i > index && i < self.items.length) || (self.items[i] == __verifier_old_uint(self.items[i]))
    /// @notice postcondition self.items[index] == newValue

    function set(List storage self, uint index, uint newValue) public {
        require(index < self.items.length);
        require(index >= 0);

        self.items[index] = newValue;
    }

    // @notice postcondition self.items.length == 0

    function clear(List storage self) public {
        delete self.items;
    }
}
