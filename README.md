# dn-perl #

A filetype plugin that supplies auxiliary perl support

## Dependencies ##

This ftplugin relies on functions provided by the dn-utils plugin. In fact, the
functions provided by this ftplugin will fail if they cannot detect dn-utils.

## K help ##

The K help configured by the vim option

```vim
'keywordprg'
```

which defaults in perl file types to search function help:

```sh
perldoc -f X
```

where `X` is the keyword to search for help on.

This plugin sets the option so that K help searches for help on the keyword
sequentially in functions, variables, general, and faq help until it finds a
match:

```sh
perldoc -f X || perldoc -v X || perldoc X || perldoc -q X
```

## Perltidy ##

Provides a custom perltidy script that can be run on a buffer file. It honours
the `method` keyword and makes changes in place, saving a backup with a '.bak'
extension. See the `perltidy` man page for further details. The script can be
run using the `:Tidy` command, `<Leader>t` mapping, or the `dn#perl#tidy()`
function.

## Perlcritic ##

Provides a custom perlcritic script that can be run on a buffer file to display
any policy violations. This script honors Moo(se) conventions. See the
`perlcritic` man page for further details. The script can be run using the
`:Critic X` command, where `X` is the severity level (1--5), `<Leader>cX`
mappings, where `X` is the severity level (1--5), or the `dn#perl#critic()`
function.

## License ##

This plugin is made available under the GPL3+ license.
