# Config Challenge

This is demo code for a coding challenge that asked me to write a function that takes in a `config` file, parses it using a particular set of standard `.INI` or `.conf` file rules, and return an object that can be queried thereafter.

## Instructions for Use

To run the built-in tests, clone the repo, navigate to the root directory, and run `rspec`. If you prefer to see printed example output, run `ruby lib/test.rb` from the command line. You can also `require` the file `entry.rb` (keeping `config_hash.rb` and `config_object.rb` in the same folder as `entry.rb`).

## Design & Approach

This solution takes a 3-step approach:

1. **Error handling**: Make sure the file is present and well-formed.
2. **Creating the `ConfigObject`**: parse the text of the file, creating a queryable hash as an instance variable as it goes.
3. **Query with Metaprogramming**: use Ruby's `method_missing` feature to query the `ConfigObject` in constant time.

### Error Handling

Before creating the `ConfigObject`, we check that the file is present and not malformed. The first check is done with `Pathname`. The second ensures these requirements:

1.
### Creating the `query_hash` Object

After the file is read in, each line is parsed to see which category it belongs in: blank line, comment line, group line, setting/value pair line, or setting/value pair with override line. Each of these is handled slightly differently, and the end result is `@query_hash`, which has as its keys the group names, pointing to nested hashes. These subhashes have as keys the setting names. As setting/override pairs are seen, the program replaces the value that setting points to if the current override is in the override list.    

### Querying with Metaprogramming


## Time & Space Complexity

The slowest work here is when the file is initially loaded. The methods `is_well_formed?` and `ConfigObject.parse_text` both run in `O(number of characters in file)` time. We must determine whether the file is well-formed or not, which necessarily involves looking at each individual character.  Therefore, this overall time complexity at load time is the best we can hope for.

After the object is returned, however, all queries run in (close to) constant time. Each query runs through `method_missing`, which must parse the method name.  This takes `O(method_name.length)` time. Assuming some reasonable cap on the length of the method name, this is essentially constant time. From there, we simply look up the query in our hash, which is a constant time call.

This method does use a lot of extra space. The space used is potentially as big as the file itself since we are storing all its group names and setting/value pairs.

## Tests

## Unimplemented Features, Edge Cases & Other Todos

There are a few loose ends that I didn't have time to shore up. With more time I would:

- Test `is_well_formed?` and `parse_file` in `entry.rb`. That'd require wrapping that up in a class, or incorporating the error handling into the `ConfigObject` class itself, as well as writing the tests themselves.  
- It seems dicey to build onto `Hash` in this way. To better localize our work, another option would be to build a subclass onto `Hash`, say `ConfigHash`.
- An edge case occurs when one of the setting names is the same as an existing method name on the `Hash` class. In that case, that method will get called rather than hitting `method_missing`. That's definitely a problem, and one that we could potentially deal with by outlawing a list of setting names or overriding them on the `Hash` class with another metaprogramming technique.

TODOs:

- Fix the string parsing error that's popping up when things in quotes are read in
- Write the `is_malformed?` method
- A couple more test files
- Refactor so some of the stuff is getting built while the file is being parsed rather than upon function call
