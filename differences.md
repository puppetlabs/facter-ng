# Differences between Facter 2 and Facter 4

### Deprecated API

- `Facter.collection` is no longer accessible, you should always add facts with `Facter.add()` and extract them with `Facter.fact()` or `Facter.value()`


### Different behaviour:
- when writing custom facts, everything that is outside `setcode` block will be executed when loading the facts. 
(In Facter 2, the code outside setcode was not executed untill the fact was requested)