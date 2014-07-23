SObjectFactory
==============
How it works:
- build([recordCount], objectType, [fieldToValue])
    - create an sObject but do not insert it
    - optionally specify how many of this sObject type to create
    - optionally specify a map of field to value
- create([recordCount], objectType, [fieldToValue])
    - same overloading structure, but sObjects are inserted
