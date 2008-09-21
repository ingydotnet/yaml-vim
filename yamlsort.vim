" Vim script for vim-ruby for sorting yaml collections
" Requires: yamlsort.rb
" Author:	Igor Vergeichik <iverg@mail.ru>
" Sponsor: Tom Sawyer <transami@transami.net>
" Copyright (c) 2002 Tom Saywer

ruby load '~/.vim/scripts/yamlsort.rb'

" Direct sort
function! YamlSort()
	ruby YCollection.new lambda{|a,b| a<=>b}
endfunction
" Reverse sort
function! YamlRSort()
	ruby YCollection.new lambda{|a,b| b<=>a}
endfunction

map <F4> :call YamlSort()<CR>
map <F5> :call YamlRSort()<CR>
