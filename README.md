
# solidity-formal-specification
Implementation and specification of new Solidity "Data Strucutres" in form of contracts that may or may not be useful.

This repository is an ongoing WIP as part of my thesis.

# Current progress

## Simple list
  - [x] implementation
  - [x] specification (solc-verify)
  - [x] verified
 
## Set
  - [x] implementation
  - [x] specification (solc-verify)
  - [x] almost verified. (See Note.)
        
    Note: The contract can be verified with the caveat that the remove function has a certain precondition. Technically the precondition is always upheld anyway but to make this explicit and for a cleaner specification it will be factored out into a contract invariant.
   
## Iterable Mapping
TODO

## Strict Mapping
TODO
