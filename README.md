## Details & Dependencies
Written with Ruby 2.3.1

Additionally tested with Ruby 2.0.0 and 2.2.1

Testing requires:
- rspec 3.6.0

## Execution
To use the application, from the root directory, run

```
ruby gateway.rb
```

Usage should be fairly self-explanatory: select desired options from the menu.

## Testing
This application uses rspec for tests. To run all tests, make sure you have rspec installed, and from the root directory, run

```
rspec
```

Alternately, to perform individual tests, run

```
rspec spec/name_of_test_file.rb
```

Finally, there is also a manual test file for menu.rb, which allows you to interactively test menu behavior. To use it, run

```
ruby manual_menu_test.rb
```
