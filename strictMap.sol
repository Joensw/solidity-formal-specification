pragma solidity ^0.7.0;

contract StrictMap {

    // Shouldn't be public as we want to encapsulate access
    mapping (address => uint) public map;

    /// @notice postcondition forall (address a) (map[a] == __verifier_old_uint(map[a]))

    function get(address key) public view returns (uint contents) {
        contents = map[key];
    }

    /// @notice postcondition forall (address a) !(a != msg.sender ) || (map[a] == __verifier_old_uint(map[a]))
    /// @notice postcondition map[msg.sender] == value

    function set(uint value) public {
        map[msg.sender] = value;
    }

    /// @notice postcondition forall (address a) !(a != target) || (map[a] == __verifier_old_uint(map[a]))
    /// @notice postcondition map[target] == __verifier_old_uint(map[target]) + amount

    function deposit(address target, uint amount) public {
        map[target] += amount;
    }

}