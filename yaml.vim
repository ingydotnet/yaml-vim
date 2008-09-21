" Vim syntax file
" Language:	YAML
" Author:	Igor Vergeichik <iverg@mail.ru>
" Sponsor: Tom Sawyer <transami@transami.net>
" Copyright (c) 2002 Tom Saywer
"
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
syntax clear

syn match yamlStream	"\s*---$"
syn region yamlComment	start="\s*\#" end="$"
"syn region yamlMapping	start="\w+:\s*\w+" end="$" contains=yamlKey,yamlValue
syn match yamlDelimiter	"[:,]"
syn match yamlBlock "[\[\]\{\}]"

"syn region yamlScalar	start=+[^\\]"+  end=+"+ contains=yamlSpecial skip=+\\"+

" Predefined data types

" Yaml Integer type
syn match  yamlInteger	"[-+]\?\(0\|[1-9][0-9,]*\)"
syn match  yamlInteger	"[-+]\?0[xX][0-9a-fA-F,]\+"

" floating point number
syn match  yamlFloating		"\<\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\=\>"
syn match  yamlFloating		"\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
syn match  yamlFloating		"\<\d\+e[-+]\=\d\+[fl]\=\>"
syn match  yamlFloating		"\(([+-]\?inf)\)\|\((NaN)\)"


" Boolean
syn keyword yamlBoolean true True TRUE false False FALSE yes Yes YES no No NO on On ON off Off OFF
syn match yamlBoolean ":.*\zs\W[+-]\(\W\|$\)"

" Null
syn keyword yamlNull null Null NULL nil Nil NIL
syn match yamlNull "\W[~]\(\W\|$\)"

syn match yamlTime "\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\?Z"
syn match yamlTime "\d\d\d\d-\d\d-\d\dt\d\d:\d\d:\d\d.\d\d-\d\d:\d\d"
syn match yamlTime "\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d.\d\d\s-\d\d:\d\d"

" Single and double quoted scalars
syn region yamlString	start="'" end="'" skip="\\'"
syn region yamlString	start='"' end='"' skip='\\"' contains=yamlEscape

" Escaped symbols
" every charater preceeded with slash is escaped one
syn match  yamlEscape		"\\."
" 2,4 and 8-digit escapes
syn match  yamlEscape		"\\\(x\x\{2\}\|u\x\{4\}\|U\x\{8\}\)"

syn match  yamlKey		"\w\+\ze\s*:"
syn match  yamlType		"![^\s]\+\s\@="

hi link yamlKey		Identifier
hi link yamlType	Type
hi link yamlInteger	Number
hi link yamlFloating	Float
hi link yamlEscape	Special
hi link yamlComment	Comment
hi link yamlStream	Statement
hi link yamlBlock	Operator
hi link yamlDelimiter	Delimiter
hi link yamlString	String
hi link yamlBoolean	Boolean
hi link yamlNull	Boolean
hi link yamlTime	String

