# Config Challenge

This is demo code for a coding challenge that asked me to write a function that takes in a `config` file, parses it using a particular set of standard `.INI` or `.conf` file rules, and returns an object that can be queried thereafter.

## Instructions for Use

To run the built-in tests, clone the repo, navigate to the root directory, and run `rspec`. You can also `require` the file `entry.rb` (keeping `config_hash.rb`, `config_object.rb`, and `queryable_nil.rb` in the same folder as `entry.rb`).

## Design & Approach

This solution takes a 3-step approach:

1. **Error handling**: make sure the file is present and well-formed. This happens in the `entry.rb` file, before the `ConfigObject` is created.
2. **Creating the `ConfigObject`**: parse the text of the file upon initialization, creating a queryable hash as an instance variable as it goes.
3. **Query with Metaprogramming**: use Ruby's `method_missing` feature to query the `ConfigObject` in constant time. Note that the `Hash` class and `NilClass` get reopened and their `method_missing`s are redefined -- see the <a href="https://github.com/ScottDuane/ConfigChallenge#loose-ends">Loose Ends</a> section for some notes on this.

## Time & Space Complexity

The slowest work here is when the file is initially loaded. The methods `is_well_formed?` and `ConfigObject.parse_text` both run in `O(number of characters in file)` time. We must determine whether the file is well-formed or not, which necessarily involves looking at each individual character.  Therefore, this overall time complexity at load time is the best we can hope for.

After the object is returned, however, all queries run in (close to) constant time. Each query runs through `method_missing`, which must parse the method name.  This takes `O(method_name.length)` time. Assuming some reasonable cap on the length of the method name, this is essentially constant time. From there, we simply look up the query in our hash, which is a constant time call.

This method does use a lot of extra space. The space used is potentially as big as the file itself since we are storing all its group names and setting/value pairs.

## Tests

There are a few `rspec` tests in `/spec/config_object_spec.rb` that test the querying functionality of a successfully created `ConfigObject`. Run with `rspec` from the command line.

## Loose Ends

There are a few loose ends that I didn't have time to shore up. With more time I would:

- Write tests for `is_well_formed?` and `parse_file`.   
- It seems dicey to build onto `Hash` in this way. To better localize our work, another option would be to build a subclass onto `Hash`, say `ConfigHash`. Originally, I went this direction, but since the instructions specifically ask the `CONFIG.ftp` return a `Hash` object, I thought it better to return an object that is strictly an instance of this class.
- Seems dicier yet to build onto `NilClass`. Class inheritance is tricky here since `NilClass` is a singleton; with this one I just ran out of time.
- One way to safely package these monkey-patches on `NilClass` and `Hash` would be to create a module and then include it in `ConfigObject`. I'd do this with more time.
- An edge case occurs when one of the setting names is the same as an existing method name on the `Hash` class. In that case, that method will get called rather than hitting `method_missing`. That's definitely a problem, and one that we could potentially deal with by outlawing a list of setting names or overriding them on the `Hash` class with another metaprogramming technique.
- Refactor a couple things -- `remove_whitespace` appears in both `entry.rb` and `config_object.rb`, which is doesn't need to. It could sit in a helper file somewhere.  
- Find a cleaner way to infer type in Ruby. Right now, I do it with `eval_with_type`, `eval_as_bool`, `eval_as_num`, and `eval_as_string`.
