" File:    log.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#giti#log#define()"{{{
  return s:kind
endfunction"}}}

let s:kind = {
\ 'name' : 'giti/log',
\ 'default_action' : 'view',
\ 'action_table' : {},
\ 'alias_table' : {},
\}

" actions {{{
let s:kind.action_table.view = {
\ 'description' : 'view information of this commit',
\ 'is_selectable' : 0,
\ 'is_quit' : 0,
\ 'is_invalidate_cache' : 0,
\}
function! s:kind.action_table.view.func(candidate)"{{{
  let data = a:candidate.action__data
  echo        'Hash:       ' . data.hash
  echo        'ParentHash: ' . data.parent_hash
  echo printf('Author:     %s <%s> - %s',
\       data.author.name, data.author.mail, data.author.date)
  echo printf('Committer:  %s <%s> - %s',
\       data.committer.name, data.committer.mail, data.committer.date)
  echo        'Comment:    ' . data.comment
endfunction"}}}

let s:kind.action_table.diff = {
\ 'description' : 'git diff',
\ 'is_selectable' : 1,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\}
function! s:kind.action_table.diff.func(candidates)"{{{
  let from  = ''
  let to    = ''
  let files = [a:candidates[0].action__file]
  if len(a:candidates) == 1
    let to   = a:candidates[0].action__data.hash
    let from = a:candidates[0].action__data.parent_hash
  elseif len(a:candidates) == 2
    let to   = a:candidates[0].action__data.hash
    let from = a:candidates[1].action__data.hash
  else
    call unite#print_error('too many commits selected')
  endif
  call giti#diff#specify({'from' : from, 'to' : to, 'files' : files})
endfunction"}}}

let s:kind.action_table.revert = {
\ 'description' : 'git revert this commit',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\}
function! s:kind.action_table.revert.func(candidate)"{{{
  call giti#revert#run([a:candidate.action__data.hash])
endfunction"}}}

let s:kind.action_table.reset_hard = {
\ 'description' : 'git reset --hard this commit',
\ 'is_selectable' : 0,
\ 'is_quit' : 1,
\ 'is_invalidate_cache' : 0,
\}
function! s:kind.action_table.reset_hard.func(candidate)"{{{
  call giti#reset#hard({'hash' : a:candidate.action__data.hash})
endfunction"}}}
let s:kind.alias_table.reset = 'reset_hard'

" }}}

" local functions {{{
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
