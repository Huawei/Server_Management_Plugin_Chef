# chef-ibmc-cookbook TESTING doc

This document describes the process for testing this cookbook using Chef WorkStation.

## Testing Prerequisites

- A working Chef WorkStation installation set as your system's default ruby. Chef WorkStation can be downloaded at [Chef WorkStation](https://downloads.chef.io/chef-workstation/0.2.48)
- Hashicorp's [Vagrant](https://www.vagrantup.com/downloads.html)
- Oracle's [Virtualbox](https://www.virtualbox.org/wiki/Downloads)

## Linting

```bash
cookstyle
```

## Style Check

```bash
# in cookbook root dir
foodcritic .
```

## Unit Test

Unit test sit inside `./spec` dir

```bash
# output as documentation format
rspec -f d
```

## Integration Test

Integration test sit inside `./test` dir.

1. Configuration 

    First, copy kitchen configuration file as `.kitchen.local.yml`. This can avoid commit secret info accidently:

    ```bash
    mv ./.kitchen.yml ./.kitchen.local.yml
    ```

    Then, you need to fill in all `attributes`'s values under `provisioner` section in `./.kitchen.local.yml` file.

2. Test

    ```bash
    # `kitchen test` command will destroy virtual instance after all tests pass
    # see `kitchen` command line usage for other purpose
    kitchen test all
    ```

## Using `rake`

This cookbook has a `./Rakefile` definition. You can use [rake](https://github.com/ruby/rake/) to make all testing into one command.

- Linting, style check and unit testing:

  ```bash
  rake
  ```

- Linting, style check, unit testing and integration testing:

  ```bash
  rake test
  ```