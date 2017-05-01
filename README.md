# Config Challenge

This is demo code for a coding challenge that asked me to write a function that takes in a `config` file, parses it using a particular set of standard `.INI` or `.conf` file rules, and return an object that can be queried thereafter.

## Instructions for Use

## Design & Approach

This solution takes advantage of Ruby's unique metaprogramming capabilities.  

### Error Handling
### Creating the Hash Object
### Querying with Metaprogramming

## Time & Space Complexity

## Tests

## Unimplemented Features & Other Todos

There are a few loose ends that I didn't have time to shore up. With more time I would:

- Test `is_well_formed?` and `parse_file` in `entry.rb`. That'd require wrapping that up in a class, or incorporating the error handling into the `ConfigObject` class itself, as well as writing the tests themselves.  
- Overwrite `to_ary` in `ConfigHash` so that `puts` works properly.  Right now all the querying functionality of the `Hash` class persists onto `ConfigHash`, but `to_ary` is not working. 
