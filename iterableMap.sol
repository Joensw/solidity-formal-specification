pragma solidity ^0.7.0;
// dont really need this as again we dont care about the non-contained addresses, set will straighten them out anyway
// @notice invariant forall (address a) !(imap.indexOf[a] == 0) || (imap.values[a] == 0)


/// @notice invariant forall (address a) !(imap.indexOf[a] != 0) || (imap.indexOf[a] - 1 < imap.keys.length) && (imap.keys[imap.indexOf[a] - 1] == a)
/// @notice invariant forall (uint i) !(0 <= i && i < imap.keys.length) || (imap.indexOf[imap.keys[i]] - 1 == i)

contract IterableMapping {

    struct IMap {
        address[] keys;
        mapping (address => uint) values;
        mapping (address => uint) indexOf;
    }

    IMap imap;

    // For testing purposes, can be ignored

    function get() public view returns (address[] memory) {
        return imap.keys;
    }

    function get(address _key) public view returns (uint) {
        require(imap.indexOf[_key] != 0);
        return imap.values[_key];
    }

    function get(uint _index) public view returns (uint) {
        require(_index < imap.keys.length);
        return imap.values[imap.keys[_index]];
    }

    function size() public view returns (uint) {
        return imap.keys.length;
    }

    function containsKey(address _key) public view returns (bool) {
        return imap.indexOf[_key] != 0;
    }

    /// @notice postcondition imap.values[_key] == _value
    /// @notice postcondition forall (address a) !(a != _key) || imap.values[a] == __verifier_old_uint(imap.values[a])
    /// @notice postcondition !(__verifier_old_uint(imap.indexOf[_key]) == 0) || (imap.keys.length == __verifier_old_uint(imap.keys.length) + 1)
    /// @notice postcondition !(__verifier_old_uint(imap.indexOf[_key]) == 0) || (imap.keys[imap.keys.length - 1] == _key)
    /// @notice postcondition !(__verifier_old_uint(imap.indexOf[_key]) == 0) || (imap.indexOf[_key] == imap.keys.length)
    /// @notice postcondition forall (address a) !(__verifier_old_uint(imap.indexOf[_key]) == 0) || !(a != _key) || imap.indexOf[a] == __verifier_old_uint(imap.indexOf[a])
    /// @notice postcondition forall (uint i) !(__verifier_old_uint(imap.indexOf[_key]) == 0) || !(0 <= i && i < imap.keys.length - 1) || imap.keys[i] == __verifier_old_address(imap.keys[i])
    /// @notice postcondition forall (address a) (__verifier_old_uint(imap.indexOf[_key]) == 0) || imap.indexOf[a] == __verifier_old_uint(imap.indexOf[a])
    /// @notice postcondition forall (uint i) (__verifier_old_uint(imap.indexOf[_key]) == 0) || !(0 <= i && i < imap.keys.length) || imap.keys[i] == __verifier_old_address(imap.keys[i])

    function set(address _key, uint _value) public {
        imap.values[_key] = _value;

        if (imap.indexOf[_key] == 0) {
            imap.keys.push(_key);
            imap.indexOf[_key] = imap.keys.length;
        }
    }

    /*

        ensures: success <=> (__verifier_old_uint(imap.keys.length) != 0 && __verifier_old_uint(imap.indexOf[_key]) != 0)
            =>
            <=

        ensures: success => imap.keys.length == __verifier_old_uint(imap.keys.length) - 1
        ensures: !success => imap.keys.length == __verifier_old_uint(imap.keys.length)

        ensures !success => all data strucutres remain unchanged
            keys
            values
            indexOf

        ensures success =>
            values _key is now 0 && indexof _key is now 0
            all entries in keys are != _key, i.e _key doesnt appear in _keys anymore
            values stays the same except for _key 

        ensures: success & last => 
            keys before is the same as keys after just one shorter
            indexOf stays the same except for _key

        ensures: success & !last => 
            The old last element is now at the index where _key was
                in keys
                in indexOF
            everything else stays the same
                in keys (except ofcourse the last element is cut)
                in indexOF


    
    */

    /// @notice postcondition success || (__verifier_old_uint(imap.keys.length) == 0 || __verifier_old_uint(imap.indexOf[_key]) == 0)
    /// @notice postcondition !success || (__verifier_old_uint(imap.keys.length) != 0 && __verifier_old_uint(imap.indexOf[_key]) != 0)
    /// @notice postcondition success || imap.keys.length == __verifier_old_uint(imap.keys.length)
    /// @notice postcondition !success || imap.keys.length == __verifier_old_uint(imap.keys.length) - 1
    /// @notice postcondition forall (uint i) success || (0 <= i && i < imap.keys.length) || imap.keys[i] == __verifier_old_address(imap.keys[i])
    /// @notice postcondition forall (address a) success || imap.values[a] == __verifier_old_uint(imap.values[a])
    /// @notice postcondition forall (address a) success || imap.indexOf[a] == __verifier_old_uint(imap.indexOf[a])
    /// @notice postcondition !success || imap.values[_key] == 0 && imap.indexOf[_key] == 0
    /// @notice postcondition forall (uint i) !success || !(0 <= i && i < imap.keys.length) || imap.keys[i] != _key
    /// @notice postcondition forall (address a) !success || !(a != _key) || imap.values[a] == __verifier_old_uint(imap.values[a])
    /// @notice postcondition forall (uint i) !success || !(_key == __verifier_old_address(imap.keys[imap.keys.length - 1])) || !(0 <= i && i < imap.keys.length) || imap.keys[i] == __verifier_old_address(imap.keys[i])
    /// @notice postcondition forall (address a) !success || !(_key == __verifier_old_address(imap.keys[imap.keys.length - 1])) || !(a != _key) || imap.indexOf[a] == __verifier_old_uint(imap.indexOf[a])
    /// @notice postcondition !success || (_key == __verifier_old_address(imap.keys[imap.keys.length - 1])) || (__verifier_old_address(imap.keys[imap.keys.length - 1]) == imap.keys[__verifier_old_uint(imap.indexOf[_key] - 1)])
    /// @notice postcondition !success || (_key == __verifier_old_address(imap.keys[imap.keys.length - 1])) || imap.indexOf[__verifier_old_address(imap.keys[imap.keys.length - 1])] == __verifier_old_uint(imap.indexOf[_key])
    /// @notice postcondition forall (uint i) (!success) || (_key == __verifier_old_address(imap.keys[imap.keys.length - 1]))  || !(0 <= i && i < imap.keys.length && i != __verifier_old_uint(imap.indexOf[_key] - 1)) || (imap.keys[i] == __verifier_old_address(imap.keys[i]))
    /// @notice postcondition forall (address a) (!success) || (_key == __verifier_old_address(imap.keys[imap.keys.length - 1])) || !(a != __verifier_old_address(imap.keys[imap.keys.length - 1]) && a != _key) || (imap.indexOf[a] == __verifier_old_uint(imap.indexOf[a]))

    function remove(address _key) public returns (bool success) {
        if (imap.keys.length == 0) return false;
        if (imap.indexOf[_key] == 0) return false;
    

        // move last elemet of keys array to where out element we want to remove was
        uint index = imap.indexOf[_key] - 1;
        address lastKey = imap.keys[imap.keys.length - 1];
        imap.keys[index] = lastKey;
        imap.indexOf[lastKey] = index + 1;

        // delete

        delete imap.values[_key];
        delete imap.indexOf[_key];

        imap.keys.pop();
        return true;
    }

}