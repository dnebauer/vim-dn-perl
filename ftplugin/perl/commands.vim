" Control statements    {{{1
set encoding=utf-8
scriptencoding utf-8

if exists('b:disable_dn_perl') && b:disable_dn_perl | finish | endif
if exists('s:loaded') | finish | endif
let s:loaded = 1

let s:save_cpo = &cpoptions
set cpoptions&vim
" }}}1

" Commands

" Tidy              - run perltidy    {{{1

""
" Run custom perltidy plugin script (see @section(perltidy)). Runs
" @function(dn#perl#tidy).
command! -buffer -nargs=0 Tidy call dn#perl#tidy()

" Critic <severity> - run perlcritic    {{{1

" s:severity_completion(arg, line, pos)    {{{2

""
" @private
" Custom command completion for severity values, accepting the required
" arguments of {arg}, {line}, and {pos} although they are not used (see
" |:command-completion-customlist|). Returns a |List| of severity values:
" * 5=gentle
" * 4=stern
" * 3=harsh
" * 2=cruel
" * 1=brutal
function! s:severity_completion(arg, line, pos)
    return ['5=gentle', '4=stern', '3=harsh', '2=cruel', '1=brutal']
endfunction
" }}}2

""
" Run custom perlcritic plugin script (see @section(perlcritic)) with
" {severity} level |Number| in the range 1..5, or any |String| starting with a
" digit in the range 1..5.  Has |:command-completion| with the following
" values:
" * 5=gentle
" * 4=stern
" * 3=harsh
" * 2=cruel
" * 1=brutal
" Runs @function(dn#perl#critic).
command! -buffer -nargs=1 -complete=customlist,s:severity_completion Critic
            \ call dn#perl#critic(<q-args>)
" }}}1

" Control statements    {{{1
let &cpoptions = s:save_cpo
unlet s:save_cpo
" }}}1

" vim: set foldmethod=marker :
