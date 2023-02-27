
# solidity-formal-specification
Implementation of particular data structures in Solidity and specification / verification through the [solc-verify](https://github.com/SRI-CSL/solidity) tool.

This repository is an ongoing WIP as part of my thesis.

# Current progress

## Simple list
  - [x] implementation
  - [x] specification (solc-verify)
  - [x] verified (strangely the contains function for bool lists cannot be verified )
  
 There is also a preliminary companion document to go along with the solc-verify spec, which might be more readable.
 
## Set
  - [x] implementation
  - [x] specification (solc-verify) (Ideally the spec for isEmpty also makes guarantees for the state of the mapping i.e. that all locations are set to 0, this currently isnt possible as we need stronger invariants)
  - [x] verified 
        
   
## Iterable Mapping
  - [x] implementation
  - [x] specification (solc-verify)
  - [x] verified

## Strict Mapping
  - [x] implementation
  - [x] specification (solc-verify)
  - [x] verified
