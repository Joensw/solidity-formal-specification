// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Lists {

    struct List {
        CustomStruct[] items;
    }

    struct CustomStruct {
        uint ID; // ID field is mandatory as the code and verification relys on its existence
        // further fields ...
    }

    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length - 1) || (self.items[i].ID == __verifier_old_uint(self.items[i].ID))
    /// @notice postcondition self.items[self.items.length - 1].ID == cs.ID
    /// @notice postcondition self.items.length == __verifier_old_uint(self.items.length) + 1

    function add(List storage self, CustomStruct memory cs) public {
        self.items.push(cs);
    }

    /// @notice postcondition ret == self.items.length

    function size(List storage self) public view returns (uint ret) {
        ret = self.items.length;
    }

    /// @notice postcondition exists (uint i) (!isContained || (0 <= i && i < self.items.length && self.items[i].ID == cs.ID))
    /// @notice postcondition forall (uint i) (isContained || !(0 <= i && i < self.items.length) || self.items[i].ID != cs.ID)
    /// @notice postcondition forall (uint i) !(0 <= i && i < self.items.length) || (self.items[i].ID == __verifier_old_uint(self.items[i].ID))

    function contains(List storage self, CustomStruct memory cs) public view returns (bool isContained) {

        /// @notice invariant i >= 0 && i <= self.items.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (self.items[k].ID != cs.ID)

        for (uint i = 0; i < self.items.length; i++) {
            if (self.items[i].ID == cs.ID) {
                return true;
            }
        }
        return false;
    }

    /// @notice postcondition self.items.length == __verifier_old_uint(self.items.length) - 1
    /// @notice postcondition forall (uint i) !(i >= 0 && i < index) || (self.items[i].ID == __verifier_old_uint(self.items[i].ID))
    /// @notice postcondition forall (uint i) !(i >= index && i < self.items.length) || (self.items[i].ID == __verifier_old_uint(self.items[i + 1].ID))

    function remove(List storage self, uint index) public {
        require(index < self.items.length);
        require(index >= 0);

        /// @notice invariant i >= index && i < self.items.length
        /// @notice invariant self.items[self.items.length - 1].ID ==  __verifier_old_uint(self.items[self.items.length - 1].ID)
        /// @notice invariant self.items.length == __verifier_old_uint(self.items.length)
        /// @notice invariant forall (uint k) !(k >= 0 && k < index) || (self.items[k].ID == __verifier_old_uint(self.items[k].ID))
        /// @notice invariant forall (uint k) !(k >= index && k < i) || (self.items[k].ID == __verifier_old_uint(self.items[k + 1].ID))
        /// @notice invariant forall (uint k) !(k >= i && k < self.items.length) || (self.items[k].ID == __verifier_old_uint(self.items[k].ID))

        for (uint i = index; i < self.items.length - 1; i++) {
            self.items[i] = self.items[i + 1];
        }

        self.items.pop();
    }

    /// @notice postcondition !(success) || self.items.length == __verifier_old_uint(self.items.length) - 1
    /// @notice postcondition forall (uint i) !(success) || !(i >= 0 && i < outIndex) || (self.items[i].ID == __verifier_old_uint(self.items[i].ID))
    /// @notice postcondition forall (uint i) !(success) || !(i >= outIndex && i < self.items.length) || (self.items[i].ID == __verifier_old_uint(self.items[i + 1].ID))
    /// @notice postcondition (success) || self.items.length == __verifier_old_uint(self.items.length)

    function removeObject(List storage self, CustomStruct memory cs) public returns (bool success, uint outIndex) { 
        bool found = false;
        uint index = 0;

        /// @notice invariant i >= 0 && i <= self.items.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (self.items[k].ID != cs.ID)

        for (uint i = 0; i < self.items.length; i++) {
            if (self.items[i].ID == cs.ID) {
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

    /// @notice postcondition !valid || self.items[index].ID == cs.ID
    /// @notice postcondition forall (uint i) !valid || !(i >= 0 && i < index) || self.items[i].ID != cs.ID
    /// @notice postcondition forall (uint i) valid || !(i >= 0 && i < self.items.length) || self.items[i].ID != cs.ID

    function indexOf(List storage self, CustomStruct memory cs) public view returns (bool valid, uint index){
        index = 0;

        /// @notice invariant i >= 0 && i <= self.items.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (self.items[k].ID != cs.ID)

        for (uint i = 0; i < self.items.length; i++) {
            if (self.items[i].ID == cs.ID){
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


    /// @notice postcondition ret.ID == self.items[index].ID

    function get(List storage self, uint index) public view returns (CustomStruct memory ret) {
        require(index < self.items.length);
        require(index >= 0);

        ret = self.items[index];
    }

    /// @notice postcondition forall (uint i) !(i >= 0 && i < index) || (self.items[i].ID == __verifier_old_uint(self.items[i].ID))
    /// @notice postcondition forall (uint i) !(i > index && i < self.items.length) || (self.items[i].ID == __verifier_old_uint(self.items[i].ID))
    /// @notice postcondition self.items[index].ID == cs.ID

    function set(List storage self, uint index, CustomStruct memory cs) public {
        require(index < self.items.length);
        require(index >= 0);

        self.items[index] = cs;
    }

    /// @notice postcondition self.items.length == 0


    function clear(List storage self) public {
        delete self.items;
    }
    
}

