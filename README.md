
# solidity-formal-specification
Implementation of particular data structures in Solidity and specification / verification through the [solc-verify](https://github.com/SRI-CSL/solidity) tool.

# Current progress

## Simple list (with iterator)
  - [x] implementation
  - [x] specification 
  - [x] verified (3 post conditions could be verified for bool lists, the other data types worked fine)
   
## Set (with iterator)
  - [x] implementation
  - [x] specification  
  - [x] verified 
        
   
## Iterable Mapping (with iterator)
  - [x] implementation
  - [x] specification 
  - [x] verified (using address as the value for the mapping causes issues with the remove method verification, all other key/value type combinations are verifiable)

## Caller Specific Mapping
  - [x] implementation
  - [x] specification 
  - [x] verified
