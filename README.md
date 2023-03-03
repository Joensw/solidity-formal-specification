
# solidity-formal-specification
Implementation of particular data structures in Solidity and specification / verification through the [solc-verify](https://github.com/SRI-CSL/solidity) tool.

This repository is an ongoing WIP as part of my thesis.

# Current progress

## Simple list
  - [x] implementation
  - [x] specification (solc-verify)
  - [x] verified (strangely for bool lists the contains method cannot be verified with the current specification)
   
## Set
  - [x] implementation
  - [x] specification (solc-verify) (Ideally the spec for isEmpty also makes guarantees for the state of the mapping i.e. that all locations are set to 0, this currently isnt possible as we need stronger invariants)
  - [x] verified 
        
   
## Iterable Mapping
  - [x] implementation
  - [x] specification (solc-verify)
  - [x] verified (using address as the value for the mapping causes issues with the remove method verification, all other key/value type combinations are verifiable)

## Strict Mapping
  - [x] implementation
  - [x] specification (solc-verify)
  - [x] verified
