
# solidity-formal-specification
Implementation of particular data structures in Solidity and specification / verification through the [solc-verify](https://github.com/SRI-CSL/solidity) tool.

This repository is an ongoing WIP as part of my thesis.

# Current progress

## Simple list
  - [x] implementation
  - [x] specification (solc-verify)
  - [x] verified
  
 There is also a preliminary companion document to go along with the solc-verify spec, which might be more readable.
 
## Set
  - [x] implementation
  - [x] specification (solc-verify) (Ideally the spec for isEmpty also makes guarantees for the state of the mapping, this currently isnt possible as we need stronger invariants)
  - [x] verified 
        
   
## Iterable Mapping
  - [ ] implementation
  - [ ] specification (solc-verify)
  - [ ] verified

## Strict Mapping
  - [ ] implementation
  - [ ] specification (solc-verify)
  - [ ] verified
