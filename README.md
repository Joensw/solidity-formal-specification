
# solidity-formal-specification
Implementation and specification of new Solidity "Data Strucutres" in form of contracts that may or may not be useful.

This repository is an ongoing WIP as part of my thesis.

# Current progress

- **Simple list**
  - [x] implementation
  - [x] specification (solc-verify)
  - [x] verified
- **Set**
  - [x] implementation
  - [x] specification (solc-verify)
  - [ ] unverified. The postcondition specifying that the removed element in the values array will be overwritten by the last element of the array doesn't work as of yet. All the other    conditions work. 
    
    Note 1: the method remove has the precondition that there is actually an element to remove, this is needed by the prover for the current specification, but is more of a band aid fix. Ideally this isn't needed, as we would like guarantees even if the Set is empty.
    
    Note 2: the current spec includes: ```modifies set```, which isnt wrong but is essentially a catch all, it would be nice if we could specifiy more exactly what the method modifies however set.values and set.location don't seem to suffice for the prover.
 
