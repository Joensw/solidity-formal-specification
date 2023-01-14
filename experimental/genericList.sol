pragma solidity ^0.7.0;

contract List {

    %TYPE%[] private array;

    /// @notice postcondition forall (uint i) !(0 <= i && i < array.length - 1) || (array[i] == __verifier_old_%TYPE%(array[i]))
    /// @notice postcondition array[array.length - 1] == num
    /// @notice postcondition array.length == __verifier_old_uint(array.length) + 1
    /// @notice modifies array

    function add(%TYPE% num) public {
        array.push(num);
    }

    /// @notice postcondition ret == array.length

    function size() public view returns (uint256 ret) {
        ret = array.length;
    }

    /// @notice postcondition exists (uint i) (!isContained || (0 <= i && i < array.length && array[i] == num))
    /// @notice postcondition forall (uint i) (isContained || !(0 <= i && i < array.length) || array[i] != num)

    function contains(%TYPE% num) public view returns (bool isContained) {

        /// @notice invariant i >= 0 && i <= array.length
        /// @notice invariant forall (uint k) !(k >= 0 && k < i) || (array[k] != num)

        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == num) {
                return true;
            }
        }

        return false;
    }

    /// @notice postcondition ret == array[index]

    function get(uint256 index) public view returns (%TYPE% ret) {
        require(index < array.length);
        require(index >= 0);

        ret = array[index];
    }

    /// @notice modifies array
    /// @notice postcondition forall (uint i) !(i >= 0 && i < index) || (array[i] == __verifier_old_%TYPE%(array[i]))
    /// @notice postcondition forall (uint i) !(i >= index && i < array.length) || (array[i] == __verifier_old_%TYPE%(array[i + 1]))
    /// @notice postcondition ret == __verifier_old_%TYPE%(array[index])

    function remove(uint256 index) public returns (%TYPE% ret) {

        require(index < array.length);
        require(index >= 0);

        ret = array[index];

        /// @notice invariant i >= index && i < array.length
        /// @notice invariant array[array.length - 1] ==  __verifier_old_%TYPE%(array[array.length - 1])
        /// @notice invariant array.length == __verifier_old_uint(array.length)
        /// @notice invariant forall (uint k) !(k >= 0 && k < index) || (array[k] == __verifier_old_%TYPE%(array[k]))
        /// @notice invariant forall (uint k) !(k >= index && k < i) || (array[k] == __verifier_old_%TYPE%(array[k + 1]))
        /// @notice invariant forall (uint k) !(k >= i && k < array.length) || (array[k] == __verifier_old_%TYPE%(array[k]))

        for (uint256 i = index; i < array.length - 1; i++) {
            array[i] = array[i + 1];
        }

        array.pop();
    }

}
