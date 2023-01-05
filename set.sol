pragma solidity ^0.7.0;


/// @notice invariant forall (uint i) !(set.location[i] != 0) || (set.location[i] - 1 < set.values.length) && (set.values[set.location[i] - 1] == i)
contract Contract {

    struct Set {
        uint[] values;
        mapping (uint => uint) location;
    }

    Set set;

    // For testing purposes, can be ignored

    function get() public view returns (uint[] memory) {
        return set.values;
    }

    /// @notice postcondition ret == set.values.length
    /// @notice postcondition forall (uint i) !(0 <= i && i < set.values.length) || (set.values[i] == __verifier_old_uint(set.values[i]))
    /// @notice postcondition forall (uint i)  (set.location[i] == __verifier_old_uint(set.location[i]))

    function size() public view returns (uint ret) {
        return set.values.length;
    }

    /// @notice postcondition !(ret) || set.location[num] != 0
    /// @notice postcondition ret || set.location[num] == 0
    /// @notice postcondition forall (uint i) !(0 <= i && i < set.values.length) || (set.values[i] == __verifier_old_uint(set.values[i]))
    /// @notice postcondition forall (uint i)  (set.location[i] == __verifier_old_uint(set.location[i]))

    function contains(uint num) public view returns (bool ret) {
        return set.location[num] != 0;
    }


    /*
        => If item is in i.e set.location[num] != 0
        ensures: values length is the same
        ensures: the items in values stay the same
        ensures: the location mapping is identical to before



        => If item isnt in i.e set.location[num] == 0
        ensures: the item can now be found at the end of values
        ensures: values length has increase by 1
        ensures: the other items in values hasn't been altered
        ensures: the location mapping hasnt been altered except at 'num'

        => else:
        success == true <=> set.lcoation[num] != 0
    */

    /// @notice modifies set.location[num] if set.location[num] == 0
    /// @notice modifies set.values if set.location[num] == 0
    /// @notice postcondition __verifier_old_uint(set.location[num]) != 0 || set.values[set.values.length - 1] == num
    /// @notice postcondition __verifier_old_uint(set.location[num]) != 0 || set.location[num] == set.values.length
    /// @notice postcondition __verifier_old_uint(set.location[num]) != 0 || set.values.length == __verifier_old_uint(set.values.length) +1
    /// @notice postcondition forall (uint i) __verifier_old_uint(set.location[num]) != 0 || !(0 <= i && i < set.values.length - 1) || (set.values[i] == __verifier_old_uint(set.values[i]))
    /// @notice postcondition forall (uint i) __verifier_old_uint(set.location[num]) != 0 || i == num || set.location[i] == __verifier_old_uint(set.location[i])
    /// @notice postcondition __verifier_old_uint(set.location[num]) == 0 || set.values.length == __verifier_old_uint(set.values.length)
    /// @notice postcondition forall (uint i) __verifier_old_uint(set.location[num]) == 0 || !(0 <= i && i < set.values.length) || (set.values[i] == __verifier_old_uint(set.values[i]))
    /// @notice postcondition forall (uint i) __verifier_old_uint(set.location[num]) == 0 || set.location[i] == __verifier_old_uint(set.location[i])
    /// @notice postcondition (success && __verifier_old_uint(set.location[num]) == 0) || (!success && !(__verifier_old_uint(set.location[num]) == 0))

    function add(uint num) public returns (bool success) {
        if (set.location[num] == 0) {
            // push first because 0 is standard value in mapping therefore location 1 refers to the first entry of values
            set.values.push(num);
            set.location[num] = set.values.length;
            return true;
        }
        return false;
    }

    /*
        requires: Nothing, however we have 1 precondition because the prover needs them for the current state of the implementation it will be factored to a invariant later

        => If item is in i.e set.location[num] != 0

            ensure: location[item] is set to 0
            ensure: values.length reduces by one


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



        => If item isnt in i.e set.location[num] == 0

        ensure: values.length doesnt change
        ensure: values stays identical
        ensure:: location stays identical

    */

    /// @notice modifies set.values if success
    /// @notice modifies set.location if success
    /// @notice postcondition !success || (__verifier_old_uint(set.location[num]) != 0 && __verifier_old_uint(set.values.length) != 0)
    /// @notice postcondition success || (__verifier_old_uint(set.location[num]) == 0 || __verifier_old_uint(set.values.length) == 0)
    /// @notice postcondition success || set.values.length == __verifier_old_uint(set.values.length)
    /// @notice postcondition forall (uint i) success || !(0 <= i && i < set.values.length) || (set.values[i] == __verifier_old_uint(set.values[i]))
    /// @notice postcondition forall (uint i) success || set.location[i] == __verifier_old_uint(set.location[i])
    /// @notice postcondition !success || set.values.length == __verifier_old_uint(set.values.length) - 1
    /// @notice postcondition !success || set.location[num] == 0
    /// @notice postcondition forall (uint i) (!success) || !(num == __verifier_old_uint(set.values[set.values.length - 1])) || !(i != num) || set.location[i] == __verifier_old_uint(set.location[i])
    /// @notice postcondition forall (uint i) (!success) || !(num == __verifier_old_uint(set.values[set.values.length - 1])) || !(0 <= i && i < set.values.length) || (set.values[i] == __verifier_old_uint(set.values[i]))
    /// @notice postcondition forall (uint i) (!success) || (num == __verifier_old_uint(set.values[set.values.length - 1])) || !(0 <= i && i < set.values.length && i != __verifier_old_uint(set.location[num] - 1)) || (set.values[i] == __verifier_old_uint(set.values[i]))
    /// @notice postcondition (!success) || (num == __verifier_old_uint(set.values[set.values.length - 1])) || set.values[__verifier_old_uint(set.location[num] - 1)] == __verifier_old_uint(set.values[set.values.length - 1])
    /// @notice postcondition (!success) || (num == __verifier_old_uint(set.values[set.values.length - 1])) || set.location[__verifier_old_uint(set.values[set.values.length - 1])] == __verifier_old_uint(set.location[num])
    /// @notice postcondition forall (uint i) (!success) || (num == __verifier_old_uint(set.values[set.values.length - 1])) || !(i != __verifier_old_uint(set.values[set.values.length - 1]) && i != num) || (set.location[i] == __verifier_old_uint(set.location[i]))

    function remove(uint num) public returns (bool success) {
        if (set.location[num] == 0) return false;
        if (set.values.length == 0) return false;
        
        uint index = set.location[num] - 1;
        uint last = set.values[set.values.length - 1];

        set.location[num] = 0;


        if (num != last) {
            // set the location of last element to that of the element we want to remove
            set.location[last] = index + 1;
            set.values[index] = last;
        }

        set.values.pop(); 
        return true;
    } 
}