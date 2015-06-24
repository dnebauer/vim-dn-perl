dn-perl
=======

A filetype plugin that supplies auxiliary perl support

Dependencies
------------

This ftplugin relies on functions and variables provided by the dn-utils
plugin. In fact, the functions provided by this ftplugin will fail if
they cannot detect dn-utils.

Settings
--------

These settings improve the perl coding experience.

###perl_include_pod

set to true

causes the pod.vim syntax file to be included with perl.vim

###perl_extended_vars

set to true

highlights complex expressions such as @{[\$x, \$y]}

###perl_sync_dist

set to 250

increase the context used for highlighting

###perl_sub_signatures

set to true

prevents error highlighting of method arguments

###keywordprg

default is to search functions (`perldoc -f X`)

set to search functions, variables, general and faq help (`perldoc -f -X || perldoc -v -X || perldoc -X || perldoc -q-X`)

Perltidy
--------

Runs dn-perltidy on current file. It makes changes in place, saving a
backup with a '.bak' extension. See the dn-perltidy man page for further
details. Relies on the DNP_PerlTidy function.

###DNP_PerlTidy(params)

purpose: run utility dn-perltidy on current file

params: 1 - all parameters [Hash], 'mode': calling mode ('insert'|'normal')

return: nil

###Mapping

This feature is mapped by default to '<LocalLeader>t', usually '\t', in
both Insert and Normal modes.

###Command

This feature is also invoked by the command 'Tidy'.

Perlcritic
----------

Runs dn-perlcritic on current file and display output. See the
dn-perltidy man page for further details. Relies on the DNP_PerlCritic
function.

###DNP_PerlCritic(params)

purpose: run utility dn-perltidy on current file

params: 1 - all parameters [Hash], 'mode': calling mode ('insert'|'normal'),
'severity': severity of analysis (1..5)

return: nil

###Mapping

This feature is mapped in both Insert and Normal modes by default to
'<LocalLeader>cX' where X is the desired severity of analysis (1, 2, 3,
4 or 5), and is usually '\cX'.

###Commands

This feature is also invoked by the
command 'CriticX' where X is the severity.

Syntax
------

This ftplugin assumes the following syntax files from the vim-perl plugin
are in use: moose.vim and method-signatures.vim. At the time of writing
these are all contributed files (in the 'contrib' directory) and must be
manually installed in a directory visible to vim.

These useful files are also contributed to the vim-perl ftplugin and are
worth using: try-tiny.vim, carp.vim, and highlight-all-pragmas.vim.

The syntax file provided by this ftplugin relies on the main perl
ftplugin syntax file, and so is installed to an 'after' directory. This
auxiliary synta file provides support for keywords provided by the
MooseX::App(::Simple) and Readonly modules.
