pragma solidity ^0.7.0;

contract List {

    int256[] private array;

    // For testing purposes, can be ignored
    
    function getData() public view returns (int256[] memory) {
        return array;
    }

    /// @notice postcondition array.length == 0

    constructor() {
        array = new int[](0);
    }

    /*
        X ensures: All previous values of the array remain unchanged
        X ensures: The added value is found at the end of the Array
        X ensures: The Length of the array is the old length + 1 
    */

    /// @notice postcondition forall (uint i) !(0 <= i && i < array.length - 1) || (array[i] == __verifier_old_int(array[i]))
    /// @notice postcondition array[array.length - 1] == num 
    /// @notice postcondition array.length == __verifier_old_uint(array.length) + 1
    /// @notice modifies array

    function add(int256 num) public {
        array.push(num);
    }

    /// @notice postcondition ret == array.length

    function size() public view returns (uint256 ret) {
        ret = array.length;
    }

    /*
        ensures: if the return value is true, there exists an index i so that array[i] == num
        ensures: if the return value is false, for all indices between 0 and the arrays length - 1 array[i] != num
        ensures: The array remains unchanged (should be implicit through view)
    */

    /// @notice postcondition exists (uint i) (!isContained || (0 <= i && i < array.length && array[i] == num))
    /// @notice postcondition forall (uint i) (isContained || !(0 <= i && i < array.length) || array[i] != num)
    /// @notice postcondition forall (uint i) !(0 <= i && i < array.length) || (array[i] == __verifier_old_int(array[i]))

    function contains(int256 num) public view returns (bool isContained) {

        /// @notice invariant i >= 0 && i <= array.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (array[k] != num)

        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == num) {
                return true;
            }
        }

        return false;
    }

    /*
        requires: index < array.length
        ensures: the return value is the value at the specified index in array
        ensures: the array is now one element shorter
        ensures: the other array elements stay unchanged
    */

    /// @notice postcondition array.length == __verifier_old_uint(array.length) - 1
    /// @notice postcondition forall (uint i) !(i >= 0 && i < index) || (array[i] == __verifier_old_int(array[i]))
    /// @notice postcondition forall (uint i) !(i >= index && i < array.length) || (array[i] == __verifier_old_int(array[i + 1]))
    /// @notice postcondition ret == __verifier_old_int(array[index])
    /// @notice modifies array

    function remove(uint256 index) public returns (int256 ret) {

        require(index < array.length);
        require(index >= 0);

        ret = array[index];

        /// @notice invariant i >= index && i < array.length
        /// @notice invariant array[array.length - 1] ==  __verifier_old_int(array[array.length - 1])
        /// @notice invariant array.length == __verifier_old_uint(array.length)
        /// @notice invariant forall (uint k) !(k >= 0 && k < index) || (array[k] == __verifier_old_int(array[k]))
        /// @notice invariant forall (uint k) !(k >= index && k < i) || (array[k] == __verifier_old_int(array[k + 1]))
        /// @notice invariant forall (uint k) !(k >= i && k < array.length) || (array[k] == __verifier_old_int(array[k]))

        for (uint256 i = index; i < array.length - 1; i++) {
            array[i] = array[i + 1];
        }

        array.pop();
    }

    /*
        Remove first occurence
        iterate on found delete and shift and return
        Incase of deletion every other element can still be found just  moved

        ensures: success => modifies array
        ensures: success => length is reduced by one
        ensures !success => length is the same aas before
    */

    /// @notice modifies array if (success)
    /// @notice postcondition !(success) || array.length == __verifier_old_uint(array.length) - 1
    /// @notice postcondition forall (uint i) !(success) || !(i >= 0 && i < outIndex) || (array[i] == __verifier_old_int(array[i]))
    /// @notice postcondition forall (uint i) !(success) || !(i >= outIndex && i < array.length) || (array[i] == __verifier_old_int(array[i + 1]))
    /// @notice postcondition (success) || array.length == __verifier_old_uint(array.length)

    function removeObject(int256 val) public returns (bool success, uint outIndex) { 
        bool found = false;
        // we can use an normal int for the index as the max length of an array in solidity is 2^(64-1)
        uint index = 0;
        
        /// @notice invariant i >= 0 && i <= array.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (array[k] != val)

        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == val) {
                found = true;
                index = i;
                break;
            }
        }

        if (found) {
            remove(index);
            return (true, index);
        }

        // what we return here as an index doesnt matter, as the first return value is false anyway
        return (false, index);
    }

    /// @notice postcondition !valid || array[index] == val
    /// @notice postcondition forall (uint i) !valid || !(i >= 0 && i < index) || array[i] != val
    /// @notice postcondition forall (uint i) valid || !(i >= 0 && i < array.length) || array[i] != val

    function indexOf(int val) public view returns (bool valid, uint index){
        index = 0;

        /// @notice invariant i >= 0 && i <= array.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (array[k] != val)

        for (uint64 i = 0; i < array.length; i++) {
            if (array[i] == val){
                index = i;
                return (true, index);
            }
        }
        return (false, index);
    }

    /// @notice postcondition !out || array.length == 0
    /// @notice postcondition out || array.length > 0

    function isEmpty() public view returns (bool out) {
        out = array.length == 0;
    }

    /*
        requires: index < array.length
        ensures: the return value is the value at the specified index in array
        ensures: The array remains unchanged (should be implicit through view)
    */

    /// @notice postcondition ret == array[index]

    function get(uint256 index) public view returns (int256 ret) {
        require(index < array.length);
        require(index >= 0);

        ret = array[index];
    }
}
