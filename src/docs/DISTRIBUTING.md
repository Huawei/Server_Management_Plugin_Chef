# Distributing

This document describes how to distribute this cookbook.

## Using archive

1. Package
   
   Create cookbook archive:
   ```bash
   # Exclude integration group cookbook
   berks package -e integration
   ```

2. Usage
   
   Decompress cookbook archive in your `chef-repo` root dir, then you can specifiy it as your cookbook dependency in `metadata.rb`

## Using `supermarket`

1. Upload
   
   Upload to public `supermarket` (e.g. [https://supermarket.chef.io](https://supermarket.chef.io])) or private `supermarket`:
   ```bash
   knife supermarket share chef-ibmc-cookbook
   ```

2. Usage
   
   You can specifiy it as your cookbook dependency in `metadata.rb` directly, if your [berkshelf](https://docs.chef.io/berkshelf.html#source-keyword) `source` specifiy as same `supermarket` above.
   
   