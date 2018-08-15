" Vim ftplugin for perl
" Last change: 2018 Aug 13
" Maintainer: David Nebauer
" License: GPL3

" Control statements    {{{1
set encoding=utf-8
scriptencoding utf-8

let s:save_cpo = &cpoptions
set cpoptions&vim

" Documentation    {{{1

""
" @section Introduction,  intro
" @order intro config perltidy perlcritic commands mappings functions
" A filetype plugin providing auxiliary perl support. All functions have the
" prefix "#dn#perl". Provides custom versions of @section(perltidy) and
" @section(perlcritic) which can be called using @section(commands) and
" @section(mappings). The @plugin(name) plugin requires the |dn-utils| plugin.
"
" @subsection K Help
"
" This @plugin(name) plugin changes the behaviour of |K| by changing the value
" of the 'keywordprg' option. The default behaviour for perl file types is to
" look for documentation on a keyword ("X" in these examples) in function
" help:
" >
"   perldoc -f X
" <
" This is changed to look sequentially in function, variable, general and faq
" help:
" >
"   perldoc -f X || perldoc -v X || perldoc X || perldoc -q X
" <

""
" @section Perltidy, perltidy
" Perl::Tidy is a perl module that parses and beautifies perl source code.
" The Perl::Tidy module provides a convenience script called "perltidy",
" but it does not provide support for the "method" keyword. This @plugin(name) plugin
" includes a custom version of "perltidy" which supports this keyword and is configured to save a backup of the current file with a
" ".bak" extension before beautifying it. It has the following
" dependencies:
" * Cwd
" * File::MimeInfo::Magic
" * Function::Parameters
" * Getopt::Long::Descriptive
" * List::Util
" * Moo
" * namespace::clean
" * Perl::Tidy
" * Readonly
" * strictures
" * Test::File
" * Types::Standard
" * version.
" 
" The custom perltidy script can be run using the function
" @function(dn#perl#tidy), command @command(Tidy), and @section(mapping)
" "<Leader>t", usually "\t", in |Insert-mode| and |Normal-mode|.

""
" @section Perlcritic, perlcritic
" Perl::Critic is a perl module that critiques perl source code for best
" practices. The Perl::Critic module provides a convenience script called
" perlcritic, but it does not provide Moo(se) support. This plugin includes
" a custom version of "perlcritic" which does. It has the following
" dependences:
" * Carp
" * Cwd
" * English
" * File::MimeInfo::Magic
" * Function::Parameters
" * List::Util
" * Moo
" * MooX::Options
" * namespace::clean
" * Perl::Critic
" * Perl::Critic::Moose
" * Readonly
" * strictures
" * Test::File
" * Type::Library
" * Type::Utils
" * Types::Standard
" * version.
" 
" The custom perlcritic script can be run using the function
" @function(dn#perl#critic), command @command(Critic), and @section(mapping)s
" "<Leader>c1" to "<Leader>c5", usually "\c1" to "\c5", in |Insert-mode| and
" |Normal-mode|.

" }}}1

" Settings

" K looks in more locations for help    {{{1

" Change |K| by changing value of 'keywordprg'. Alter default behaviour of
" looking in function help:
" >
"   perldoc -f X
" <
" to look sequentially in function, variable, general and faq help:
" >
"   perldoc -f X || perldoc -v X || perldoc X || perldoc -q X
" <
setlocal keywordprg=f(){\ \
            \ \ \ \ perldoc\ -f\ $*\ \
            \ \|\|\ perldoc\ -v\ $*\ \
            \ \|\|\ perldoc\ \ \ $*\ \
            \ \|\|\ perldoc\ -q\ $*\ \
            \ ;\ }\ ;\ f
" }}}1

" Script variables

" s:tidy_name   - name of custom perltidy script    {{{1

""
" Name of custom perltidy script provided by script.
let s:tidy_name = 'vim-dn-perl-util-perltidy'

" s:tidy        - path to custom perltidy script    {{{1

""
" Path to custom perltidy script provided by plugin. Set dynamically at
" runtime.
if !exists('s:tidy') | let s:tidy = v:null | endif

" s:critic_name - name of custom perlcritic script    {{{1

""
" Name of custom perlcritic script provided by script.
let s:critic_name = 'vim-dn-perl-util-perlcritic'

" s:critic      - path to custom perlcritic script    {{{1

""
" Path to custom perlcritic script provided by plugin. Set dynamically at
" runtime.
if !exists('s:critic') | let s:critic = v:null | endif
" }}}1

" Script functions

" s:critic_path()    {{{1

""
" @private
" Returns path to custom perlcritic script provided by this plugin. The first
" time it is run this function locates the custom perlcritic script and stores
" the location in a script variable (s:critic) so it is available for future
" calls to this function.
" @throws NoCritic if cannot locate custom perlcritic script
function! s:critic_path() abort
    " return previously located path
    if s:critic isnot v:null | return s:critic | endif
    " find path if not previously found
    let l:critic = dn#util#getRtpFile(s:critic_name)
    if l:critic ==? ''  " could not locate custom perlcritic
        throw 'ERROR(NoCritic): Cannot locate custom perlcritic script'
    endif
    let s:critic = l:critic
endfunction

" s:intify_severity_string(severity)     {{{1

""
" Process {security} level value. If it is a string, take the first character,
" convert it to an integer and return it. If it is any other variable type,
" return unchanged.
function! s:intify_severity_string(severity) abort
    if type(a:severity) != type('') | return a:severity | endif
    " remove any quote marks
    let l:severity = substitute(a:severity, '[''"]', '', 'g')
    " take first char, convert to number, and return it
    " - has the effect of converting non-digit to zero, which is not valid
    return str2nr(split(l:severity, '\zs')[0])
endfunction

" s:severity_verb(level)    {{{1

""
" @private
" Provides verb for severity {level}. The {level} must be a |Number| (integer)
" in the range 1..5. Each {level} has a corresponding one word |String| verb
" which is returned:
" * 5: Gentle
" * 4: Stern
" * 3: Harsh
" * 2: Cruel
" * 1: Brutal
" Note that the error messages allow for the possibility that the original
" severity was a string starting with a character in the range 1..5, and which
" was converted by the calling function to a single digit integer before
" calling this function.
" @throws InvalidSeverity if invalid severity level provided
function! s:severity_verb(level) abort
    " exit if not an integer (|Number|)
    if type(a:level) != type(0)  " started as type other than integer|string
        throw 'ERROR(InvalidSeverity): Severity level must be integer|string'
    endif
    " now check that integer is in range 1..5
    if a:level < 1 || a:level > 5
        throw 'ERROR(InvalidSeverity): Severity level must start with 1..5'
    endif
    " now return corresponding verb
    let l:verbs = {5: 'Gentle', 4: 'Stern',
                \  3: 'Harsh',  2: 'Cruel', 1: 'Brutal'}
    return l:verbs[a:level]
endfunction

" s:tidy_path()    {{{1

""
" @private
" Returns path to custom perltidy script provided by this plugin. The first
" time it is run this function locates the custom perltidy script and stores
" the location in a script variable (s:tidy) so it is available for future
" calls to this function.
" @throws NoTidy if cannot locate custom perltidy script
function! s:tidy_path() abort
    " return previously located path
    if s:tidy isnot v:null | return s:tidy | endif
    " find path if not previously found
    let l:tidy = dn#util#getRtpFile(s:tidy_name)
    if l:tidy ==? ''  " could not locate custom perltidy
        throw 'ERROR(NoTidy): Cannot locate custom perltidy script'
    endif
    let s:tidy = l:tidy
endfunction

" s:utils_missing()    {{{1

""
" @private
" Checks whether the dn-utils plugin us available. If it is not, displays an
" error message. Returns a bool (true=missing, false=available). Designed to
" be used as:
" >
"   if s:utils_missing | return | endif
" <
function! s:utils_missing() abort
    silent! call dn#util#rev()  " load function if available
    if !(exists('*dn#util#rev') && dn#util#rev() =~? '\v^\d{8,}$')
        call dn#util#error('Cannot locate dn-utils plugin: aborting...')
    endif
endfunction

" }}}1

" Private functions

" dn#perl#severity_completion(arg, line, pos)    {{{1

""
" @private
" Custom command completion for severity values. Accepts the required
" arguments of {arg}, {line}, and {pos} although they are not used, and
" returns a |List| of severity values 1..5 (see
" |:command-completion-customlist|).
function! dn#perl#severity_completion(arg, line, pos)
    return [5, 4, 3, 2, 1]
endfunction
" }}}1

" Public functions

" dn#perl#critic(severity, [insert])    {{{1

""
" @public
" Runs custom version of perlcritic provided by plugin (see
" @section(Perlcritic)). Prints feedback provided by perlcritic. The
" {severity} determines the level of analysis, and can either be a |Number| in
" the range 1..5, or a |String| whose first character is a digit in the range
" 1..5. The option [insert] indicates whether or not this function was called
" from |Insert-mode|.
" @default insert=false
function! dn#perl#critic(severity, ...)
    if s:utils_missing() | return | endif  " requires dn-utils plugin
	" variables
    let l:insert = (a:0 && a:1)
    try   | let l:critic = s:critic_path()
    catch | echoerr 'Cannot locate custom perlcritic plugin script'
    endtry
    " if severity is string, take numeric value of first char
    let l:severity = (type(a:severity) == type(''))
                \  ? s:intify_severity_string(a:severity) : a:severity
    " s:severity_verb checks param, throws InvalidSeverity if invalid
    try   | let l:severity_verb = s:severity_verb(l:severity)
    catch | echoerr 'Severity must be number|string with first char in 1..5'
    endtry
    let l:file = expand('%')
    " give feedback because reporting delayed till after analysis
    let l:msg =   l:severity_verb
                \ . ' critique (severity ' . l:severity . ')... '
    redraw | echo l:msg
	" change to filedir if it isn't cwd
	let l:path = dn#util#getFileDir()
	let l:cwd = getcwd()
	if l:cwd !=# l:path
		try
			silent execute 'lcd' l:path
		catch
            echon 'error!'
			let l:msg = 'Fatal error: Unable to change to the current' .
                        \ "document's directory:\n"
                        \ . "'" . l:path . "'.\n"
                        \ . 'Aborting.'
			call dn#util#error(l:msg)
            if l:insert | call dn#util#insertMode(1) | endif
			return
		endtry
	endif
    " save file to be sure we operate on current version of it
    silent execute 'update'
    " time to criticise
    " - use of shellescape on l:cmd causes failure with command string
    "   wrapped in single quotes and interpreted as a single command
    let l:cmd = l:critic . ' ' . l:file . ' --severity ' . l:severity
    silent let l:output = systemlist(l:cmd)
    " do not check for v:shell_error because perlcritic has
    " previously exited with this error even when successful:
    " 'Tests were run but no plan was declared
    "  and done_testing() was not seen.'
    if type(l:output) == type('')  " error
        echon 'error!'
        let l:msg = "Command '" . l:cmd . "' failed"
        call dn#util#error(l:msg)
        let l:msg = "Shell feedback: '" . l:output . "'"
        call dn#util#error(l:msg)
    elseif type(l:output) == type([])  " succeeded
        if empty(l:output)    " nothing to report
            echon 'no policy violations'
        else    " display feedback
            echon 'found policy violations:'
            for l:item in l:output | echo l:item | endfor
        endif
    else    " unexpected data type
        echon 'error!'
        call dn#util#error('Unexpected data type for perlcritic feedback')
        return
    endif
    if l:insert | call dn#util#insertMode(1) | endif
endfunction

" dn#perl#tidy([insert])    {{{1

""
" @public
" Runs custom version of perltidy provided by plugin (see @section(Perltidy)).
" Prints feedback provided by perltidy. The option [insert] indicates whether
" or not this function was called from |Insert-mode|.
" @default insert=false
function! dn#perl#tidy(...) abort
    if s:utils_missing() | return | endif  " requires dn-utils plugin
	" variables
    let l:insert = (a:0 && a:1)
    try   | let l:tidy = s:tidy_path()
    catch | echoerr 'Cannot locate custom perltidy plugin script'
    endtry
    let l:file = expand('%')
    " give feedback because reporting delayed till after tidying
    redraw | echo 'Tidying...'
	" change to filedir if it isn't cwd
	let l:cwd = getcwd()
	let l:path = dn#util#getFileDir()
	if l:cwd !=# l:path
		try
			silent execute 'lcd' l:path
		catch
			let l:msg = 'Fatal error: Unable to change to the current' .
                        \ "document's directory:\n"
                        \ . "'" . l:path . "'.\n"
                        \ . 'Aborting.'
			call dn#util#error(l:msg)
            if l:insert | call dn#util#insertMode(1) | endif
			return
		endtry
	endif
    " save file to be sure we operate on current version of it
    silent execute 'update'
    " time to tidy
    " - use of shellescape on l:cmd causes failure with command string
    "   wrapped in single quotes and interpreted as a single command
    let l:cmd = l:tidy . ' ' . l:file
    silent let l:output = systemlist(l:cmd)
    " must reload file to display changes to underlying *file*
    " redraw is required here otherwise refresh does not occur
    "   until after list output
    silent! execute 'edit'
    redraw
    " do not check for v:shell_error because dn-perltidy always exits
    " with an error code - see dn-perltidy man page for details
    if type(l:output) == type('')  " error
        let l:msg = "Command '" . l:cmd . "' failed"
        call dn#util#error(l:msg)
        let l:msg = "Shell feedback: '" . l:output . "'"
        call dn#util#error(l:msg)
    else  " assume succeeded so have a List
        for l:item in l:output | echo l:item | endfor
        echo 'Tidying done'
    endif
    if l:insert | call dn#util#insertMode(1) | endif
endfunction
"}}}1

" Control statements    {{{1
let &cpoptions = s:save_cpo
unlet s:save_cpo
" }}}1

" vim: set foldmethod=marker :
