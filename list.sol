pragma solidity ^0.7.0;

contract List {

    int256[] private array;

    // For testing purposes, can be ignored
    
    function getData() public view returns (int256[] memory) {
        return array;
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

    /// @notice postcondition exists (uint i) (!ret || (0 <= i && i < array.length && array[i] == num))
    /// @notice postcondition forall (uint i) (ret || !(0 <= i && i < array.length) || array[i] != num)

    function contains(int256 num) public view returns (bool ret) {

        /// @notice invariant i >= 0 && i <= array.length
        /// @notice invariant i == 0 || array[i-1] != num
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
