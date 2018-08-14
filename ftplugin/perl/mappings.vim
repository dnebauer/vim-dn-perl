" Control statements    {{{1
set encoding=utf-8
scriptencoding utf-8

if exists('b:disable_dn_perl') && b:disable_dn_perl | finish | endif
if exists('g:no_plugin_maps') || exists('g:no_perl_maps') | finish | endif
if exists('s:loaded') | finish | endif
let s:loaded = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Documentation    {{{1
" - vimdoc does not automatically generate a mappings section

""
" @section Mappings, mappings
"
" [NI]<Leader>t
"   * run custom perltidy plugin script (see @section(perltidy))
"   * calls @function(dn#perl#perltidy)
"
" [NI]<Leader>c5
"   * run custom perlcritic plugin script (see @section(perlcritic)) with
"     severity level 5 (gentle)
"   * calls @function(dn#perl#perlcritic)
"
" [NI]<Leader>c4
"   * run custom perlcritic plugin script (see @section(perlcritic)) with
"     severity level 4 (stern)
"   * calls @function(dn#perl#perlcritic)
"
" [NI]<Leader>c3
"   * run custom perlcritic plugin script (see @section(perlcritic)) with
"     severity level 3 (harsh)
"   * calls @function(dn#perl#perlcritic)
"
" [NI]<Leader>c2
"   * run custom perlcritic plugin script (see @section(perlcritic)) with
"     severity level 2 (cruel)
"   * calls @function(dn#perl#perlcritic)
"
" [NI]<Leader>c1
"   * run custom perlcritic plugin script (see @section(perlcritic)) with
"     severity level 1 (brutal)
"   * calls @function(dn#perl#perlcritic)

" }}}1

" Mappings

" \t  - run perltidy    {{{1
if !hasmapto( '<Plug>DnPTI' )
	imap <buffer> <unique> <LocalLeader>t <Plug>DnPTI
endif
imap <buffer> <unique> <Plug>DnPTI <Esc>:call dn#perl#tidy(v:true)<CR>
if !hasmapto( '<Plug>DnPTN' )
	nmap <buffer> <unique> <LocalLeader>t <Plug>DnPTN
endif
nmap <buffer> <unique> <Plug>DnPTN :call dn#perl#tidy()<CR>

" \c5 - run perlcritic (severity: gentle [5])    {{{1
if !hasmapto( '<Plug>DnC5I' )
	imap <buffer> <unique> <LocalLeader>c5 <Plug>DnC5I
endif
imap <buffer> <unique> <Plug>DnC5I <Esc>:call dn#perl#critic(5, v:true)<CR>
if !hasmapto( '<Plug>DnT5N' )
	nmap <buffer> <unique> <LocalLeader>c5 <Plug>DnT5N
endif
nmap <buffer> <unique> <Plug>DnT5N :call dn#perl#critic(5)<CR>

" \c4 - run perlcritic (severity: stern [4])    {{{1
if !hasmapto( '<Plug>DnC4I' )
	imap <buffer> <unique> <LocalLeader>c4 <Plug>DnC4I
endif
imap <buffer> <unique> <Plug>DnC4I <Esc>:call dn#perl#critic(4, v:true)<CR>
if !hasmapto( '<Plug>DnT4N' )
	nmap <buffer> <unique> <LocalLeader>c4 <Plug>DnT4N
endif
nmap <buffer> <unique> <Plug>DnT4N :call dn#perl#critic(4)<CR>

" \c3 - run perlcritic (severity: harsh [3])    {{{1
if !hasmapto( '<Plug>DnC3I' )
	imap <buffer> <unique> <LocalLeader>c3 <Plug>DnC3I
endif
imap <buffer> <unique> <Plug>DnC3I <Esc>:call dn#perl#critic(3, v:true)<CR>
if !hasmapto( '<Plug>DnT3N' )
	nmap <buffer> <unique> <LocalLeader>c3 <Plug>DnT3N
endif
nmap <buffer> <unique> <Plug>DnT3N :call dn#perl#critic(3)<CR>

" \c2 - run perlcritic (severity: cruel [2])    {{{1
if !hasmapto( '<Plug>DnC2I' )
	imap <buffer> <unique> <LocalLeader>c2 <Plug>DnC2I
endif
imap <buffer> <unique> <Plug>DnC2I <Esc>:call dn#perl#critic(2, v:true)<CR>
if !hasmapto( '<Plug>DnT2N' )
	nmap <buffer> <unique> <LocalLeader>c2 <Plug>DnT2N
endif
nmap <buffer> <unique> <Plug>DnT2N :call dn#perl#critic(2)<CR>

" \c1 - run perlcritic (severity: brutal [1])    {{{1
if !hasmapto( '<Plug>DnC1I' )
	imap <buffer> <unique> <LocalLeader>c1 <Plug>DnC1I
endif
imap <buffer> <unique> <Plug>DnC1I <Esc>:call dn#perl#critic(1, v:true)<CR>
if !hasmapto( '<Plug>DnT1N' )
	nmap <buffer> <unique> <LocalLeader>c1 <Plug>DnT1N
endif
nmap <buffer> <unique> <Plug>DnT1N :call dn#perl#critic(1)<CR>
" }}}1

" Control statements    {{{1
let &cpoptions = s:save_cpo
unlet s:save_cpo
" }}}1

" vim: set foldmethod=marker :
