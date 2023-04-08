// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Lists {

    struct List {
        int[][] items;
    }

    function add(List storage self, int[] memory num) public {
        self.items.push(num);
    }

    function size(List storage self) public view returns (uint ret) {
        ret = self.items.length;
    }

    function contains(List storage self, int[] memory num) public view returns (bool isContained) {

        for (uint i = 0; i < self.items.length; i++) {
            if (elementEquality(self.items[i], num)) {
                return true;
            }
        }

        return false;
    }

    function remove(List storage self, uint index) public returns (int[] memory ret) {

        require(index < self.items.length);
        require(index >= 0);

        ret = self.items[index];

        for (uint i = index; i < self.items.length - 1; i++) {
            self.items[i] = self.items[i + 1];
        }

        self.items.pop();
    }

    function removeObject(List storage self, int[] memory val) public returns (bool success, uint outIndex) { 
        bool found = false;
        uint index = 0;

        for (uint i = 0; i < self.items.length; i++) {
            if (elementEquality(self.items[i], val)) {
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

    function indexOf(List storage self, int[] memory val) public view returns (bool valid, uint index){
        index = 0;

        for (uint i = 0; i < self.items.length; i++) {
            if (elementEquality(self.items[i], val)){
                index = i;
                return (true, index);
            }
        }
        return (false, index);
    }

    function isEmpty(List storage self) public view returns (bool out) {
        out = self.items.length == 0;
    }

    function get(List storage self, uint index) public view returns (int[] memory ret) {
        require(index < self.items.length);
        require(index >= 0);

        ret = self.items[index];
    }

    function set(List storage self, uint index, int[] memory newValue) public {
        require(index < self.items.length);
        require(index >= 0);

        self.items[index] = newValue;
    }

    function clear(List storage self) public {
        delete self.items;
    }

    function elementEquality(int[] storage arr1, int[] memory arr2) private view returns (bool) {
        if (arr1.length != arr2.length) return false;
        for (uint i = 0; i < arr1.length; i++) {
            if (arr1[i] != arr2[i]) return false;
        }
        return true;
    }
}
