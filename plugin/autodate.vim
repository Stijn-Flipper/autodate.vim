" vi:set ts=8 sts=2 sw=2 tw=0:
"
" autodate.vim - A plugin to update time stamps automatically
"
" Maintainer:	    MURAOKA Taro <koron@tka.att.ne.jp>
" Last Modified:	28 November 2013.
" By:               Stijn Wouters.

if exists('plugin_autodate_disable')
  finish
endif
let s:debug = 0

"---------------------------------------------------------------------------
"				    Options

"
" 'autodate_format'
"
if !exists('autodate_format')
  let g:autodate_format = '%d %0m %Y'
endif

"
" 'autodate_lines'
"
if !exists('autodate_lines')
  let g:autodate_lines = 30
endif

"
" 'autodate_start_line'
"
if !exists('autodate_start_line')
  let g:autodate_start_line = 1
endif

"
" 'autodate_keyword_pre'
"
if !exists('autodate_keyword_pre')
  let g:autodate_keyword_pre = '\cLast modified:'
endif

"
" 'autodate_keyword_post'
"
if !exists('autodate_keyword_post')
  let g:autodate_keyword_post = '\.'
endif

"
" 'author_format'
"
if !exists('author_format')
  let g:author_format = 'Stijn Wouters'
endif

"
" 'author_keyword_pre'
"
if !exists('author_keyword_pre')
  let g:author_keyword_pre = '\cBy:'
endif

"
" 'author_keyword_post'
"
if !exists('author_keyword_post')
  let g:author_keyword_post = '\.'
endif


"---------------------------------------------------------------------------
"				    Mappings

command! -range Autodate call <SID>Autodate(<line1>, <line2>)
command! AutodateOFF let b:autodate_disable = 1
command! AutodateON let b:autodate_disable = 0
if has("autocmd")
  augroup Autodate
    au!
    autocmd BufUnload,FileWritePre,BufWritePre * call <SID>Autodate()
  augroup END
endif " has("autocmd")

"---------------------------------------------------------------------------
"				 Implementation

"
" Autodate([{firstline} [, {lastline}]])
"
function! s:Autodate(...)
  " Check enable
  if (exists('b:autodate_disable') && b:autodate_disable != 0) || &modified == 0
    return
  endif

  " Verify {firstline}
  if a:0 > 0 && a:1 > 0
    let firstline = a:1
  else
    let firstline = s:GetAutodateStartLine()
  endif

  " Verify {lastline}
  if a:0 > 1 && a:2 <= line('$')
    let lastline = a:2
  else
    let lastline = firstline + s:GetAutodateLines() - 1
    " Range check
    if lastline > line('$')
      let lastline = line('$')
    endif
  endif

  if firstline <= lastline
    call s:AutodateStub(firstline, lastline)
  endif
endfunction

"
" GetAutodateStartLine()
"
function! s:GetAutodateStartLine()
  let retval = 1
  if exists('b:autodate_start_line')
    let retval = b:autodate_start_line
  elseif exists('g:autodate_start_line')
    let retval = g:autodate_start_line
  endif

  if retval < 0
    let retval = retval + line('$') + 1
  endif
  if retval <= 0
    let retval = 1
  endif
  return retval
endfunction

"
" GetAutodateLines()
"
function! s:GetAutodateLines()
  if exists('b:autodate_lines') && b:autodate_lines > 0
    return b:autodate_lines
  elseif exists('g:autodate_lines') && g:autodate_lines > 0
    return g:autodate_lines
  else
    return 30
  endif
endfunction

"
" AutodateStub(first, last)
"
function! s:AutodateStub(first, last)

  " First, do the date
  " Verify pre-keyword.
  if exists('b:autodate_keyword_pre') && b:autodate_keyword_pre != ''
    let pre = b:autodate_keyword_pre
  else
    if exists('g:autodate_keyword_pre') && g:autodate_keyword_pre != ''
      let pre = g:autodate_keyword_pre
    else
      let pre = '\cLast modified:'
    endif
  endif

  " Verify post-keyword.
  if exists('b:autodate_keyword_post') && b:autodate_keyword_post != ''
    let post = b:autodate_keyword_post
  else
    if exists('g:autodate_keyword_post') && g:autodate_keyword_post != ''
      let post = g:autodate_keyword_post
    else
      let post = '\.'
    endif
  endif

  " Verify format.
  if exists('b:autodate_format') && b:autodate_format != ''
    let format = b:autodate_format
  else
    if exists('g:autodate_format') && g:autodate_format != ''
      let format = g:autodate_format
    else
      let format = '%d %0m %Y'
    endif
  endif

  " Generate substitution pattern
  let pat = '\('.pre.'\s*\)\(\S.*\)\?\('.post.'\)'
  let sub = Strftime2(format)
  " For debug
  if s:debug
    echo "range=".a:first."-".a:last
    echo "pat= ".pat
    echo "sub= ".sub
  endif

  " Process
  let i = a:first
  while i <= a:last
    let curline = getline(i)
    if curline =~ pat
      let newline = substitute(curline, pat, '\1' . sub . '\3', '')
      if curline !=# newline
	call setline(i, newline)
      endif
    endif
    let i = i + 1
  endwhile

  " Okay, now the author
  " Verify pre-keyword.
  if exists('b:author_keyword_pre') && b:author_keyword_pre != ''
    let pre = b:author_keyword_pre
  else
    if exists('g:author_keyword_pre') && g:author_keyword_pre != ''
      let pre = g:author_keyword_pre
    else
      let pre = '\cBy:'
    endif
  endif

  " Verify post-keyword.
  if exists('b:author_keyword_post') && b:author_keyword_post != ''
    let post = b:author_keyword_post
  else
    if exists('g:author_keyword_post') && g:author_keyword_post != ''
      let post = g:author_keyword_post
    else
      let post = '\.'
    endif
  endif

  " Verify format.
  if exists('b:author_format') && b:author_format != ''
    let format = b:author_format
  else
    if exists('g:author_format') && g:author_format != ''
      let format = g:author_format
    else
      let format = 'Stijn Wouters'
    endif
  endif

  " Generate substitution pattern
  let pat = '\('.pre.'\s*\)\(\S.*\)\?\('.post.'\)'
  let sub = Strftime2(format)
  " For debug
  if s:debug
    echo "range=".a:first."-".a:last
    echo "pat= ".pat
    echo "sub= ".sub
  endif

  " Process
  let i = a:first
  while i <= a:last
    let curline = getline(i)
    if curline =~ pat
      let newline = substitute(curline, pat, '\1' . sub . '\3', '')
      if curline !=# newline
	call setline(i, newline)
      endif
    endif
    let i = i + 1
  endwhile
endfunction

"
" Strftime2({format} [, {time}])
"   Enchanced version of strftime().
"
"	    :echo Strftime2("%d-%3m-%Y")
"	    07-Oct-2001
"	    :echo Strftime2("%d-%0m-%Y")
"	    07-October-2001
"
function! Strftime2(...)
  if a:0 > 0
    " Get {time} argument.
    if a:0 > 1
      let time = a:2
    else
      let time = localtime()
    endif
    " Parse special format.
    let format = a:1
    let format = substitute(format, '%\(\d\+\)m', '\=MonthnameString(-1, submatch(1), time)', 'g')
    let format = substitute(format, '%\(\d\+\)a', '\=DaynameString(-1, submatch(1), time)', 'g')
    return strftime(format, time)
  endif
  " Genrate error!
  return strftime()
endfunction

"
" MonthnameString([{month} [, {length} [, {time}]]])
"   Get month name string in English with first specified letters.
"
"	    :echo MonthnameString(8) . " 2001"
"	    August 2001
"	    :echo MonthnameString(8,3) . " 2001"
"	    Aug 2001
"
function! MonthnameString(...)
  " Get {time} argument.
  if a:0 > 2
    let time = a:3
  else
    let time = localtime()
  endif
  " Verify {month}.
  if a:0 > 0 && (a:1 >= 1 && a:1 <= 12)
    let month = a:1
  else
    let month = substitute(strftime('%m', time), '^0\+', '', '')
  endif
  " Verify {length}.
  if a:0 > 1 && (a:2 >= 1 && a:2 <= 9)
    let length = a:2
  else
    let length = strpart('785534469788', month - 1, 1)
  endif
  " Generate string of month name.
  return strpart('January  February March    April    May      June     July     August   SeptemberOctober  November December ', month * 9 - 9, length)
endfunction

"
" DaynameString([{month} [, {length} [, {time}]]])
"   Get day name string in English with first specified letters.
"
"	    :echo DaynameString(0)
"	    Sunday
"	    :echo DaynameString(5,3).', 13th'
"	    Fri, 13th
"
function! DaynameString(...)
  " Get {time} argument.
  if a:0 > 2
    let time = a:3
  else
    let time = localtime()
  endif
  " Verify {day}.
  if a:0 > 0 && (a:1 >= 0 && a:1 <= 6)
    let day = a:1
  else
    let day = strftime('%w', time) + 0
  endif
  " Verify {length}.
  if a:0 > 1 && (a:2 >= 1 && a:2 <= 9)
    let length = a:2
  else
    let length = strpart('6798686', day, 1)
  endif
  " Generate string of day name.
  return strpart('Sunday   Monday   Tuesday  WednesdayThursday Friday   Saturday ', day * 9, length)
endfunction
