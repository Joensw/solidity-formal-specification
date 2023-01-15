
pragma solidity ^0.7.0;

library StrictMap {

    struct Strictmapping {
        mapping (address => uint) map;
    }

    /// @notice postcondition contents == self.map[key]

    function get(Strictmapping storage self, address key) public view returns (uint contents) {
        contents = self.map[key];
    }

    /// @notice postcondition forall (address a) !(a != msg.sender ) || (self.map[a] == __verifier_old_uint(self.map[a]))
    /// @notice postcondition self.map[msg.sender] == value

    function set(Strictmapping storage self, uint value) public {
        self.map[msg.sender] = value;
    }

    /// @notice postcondition forall (address a) !(a != target) || (self.map[a] == __verifier_old_uint(self.map[a]))
    /// @notice postcondition self.map[target] == __verifier_old_uint(self.map[target]) + amount

    function deposit(Strictmapping storage self, address target, uint amount) public {
        self.map[target] += amount;
    }

}



contract ExampleUsage {

    using StrictMap for StrictMap.Strictmapping;

    StrictMap.Strictmapping sm;

    function setEntry(uint value) public {
        sm.set(value);
    }

    function getEntry() public view returns (uint contents) {
        return sm.get(msg.sender);
    }
}