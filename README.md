# autodate(.vim)
Originally forked from [vim-scripts/autodate.vim](https://github.com/vim-scripts/autodate.vim)
with some small modifications:

- Custom date format
- Additionally, it also updates `By: {authorname}`

## Details
This plugin inserts and updates a time stamp plus author automatically.

Users can specify a format and position of the time stamp by options.
Also, the name of the author can be specified. By default, `autodate.vim` 
searches for in the first 30 lines of the buffer for the keyword `Last 
modified:.` and `By:.` respectively and inserts a time stamp and author.

### Commands
The following commands are directly available in your VIm editor after
install:
```viml
" Manually autodate, note that if you've actually made some change and then
" press :w or :wq then Autodate will automatically be executed.
:Autodate

" Turn on autodate in current buffer (default).
:AutodateON

" Turn off autodate in current buffer.
:AutodateOFF
```

The range of lines which looks for a time stamp can also be specified.
When no range is given, the command will be applied to the current line.
For example:
```viml
:%Autodate      " Whole file
:\<,\>Autodate  " Range selected by visual mode
:Autodate       " Current cursor line
```

The format of the time stamp to insert can be specified by `autodate_format`
option (see further below). Sample format settings and the corresponding 
outputs are shown below.
```
FORMAT: %Y/%m/%d     OUTPUT: 2001/12/24
FORMAT: %H:%M:%S     OUTPUT: 10:06:32
FORMAT: %y%m%d-%H%M  OUTPUT: 011224-1006
FORMAT: %Y %0m %d    OUTPUT: 2001 December 24
FORMAT: %Y %3m %d    OUTPUT: 2001 Dec 24
```

To make vim NOT TO LOAD this plugin, write the following line in your 
`~/.vimrc` (create one if necessary):
```viml
let plugin_autodate_disable = 1
```

### Options
> Each global variable (option) is overruled by buffer variable (what starts 
> with `b:`). You can override all options by typing `:let {option} = {value}`
> in your VIm editor. Priority will thus given to the variables (or options)
> in the buffer.

- `autodate_format`: Format string used for time stamps.  See `|strftime()|`
  for details. See `MonthnameString()` for special extension of format.
  Default is `%d %0m %Y`.

- `autodate_lines`: The number of lines searched for the existence of a time 
  stamp when writing a buffer. The search range will be from top of buffer 
  (or line `autodate_start_line`) to `autodate_lines` lines below. The bigger 
  value you have, the longer it'll take to search words. You can expect to 
  improve performance by decreasing the value of this option. Default is 30.

- `autodate_start_line`: Line number to start searching for time stamps when 
  writing buffer to file. If minus, line number is counted from the end of
  file. Default is 1.

- `autodate_keyword_pre`: A prefix pattern (see `|pattern|` for details) 
  which denotes time stamp's location. If empty, default value will be used.
  Default is `\cLast modified:`.

- `autodate_keyword_post`: A postfix pattern which denotes time stamp's 
  location. If empty, default value will be used. Default is `\.`.

- `autodate_keyword_post`: A postfix pattern which denotes time stamp's 
  location.  If empty, default value will be used. Default is `\.`.

- `author_format`: Format string used for author section. Default is 
  `Stijn Wouters`.

- `author_keyword_pre`: A prefix pattern (see `|pattern|` for details) which 
  denotes author's location. If empty, default value will be used. Default
  is `\cBy:`.

- `author_keyword_post`: A postfix pattern which denotes author's location.
  If empty, default value will be used. Default is `\.`.

### Examples
```
Last modified:.
By:.
```
When you've actually modified something and then type `:w` or `:wq`, those
lines will be changed to:
```
Last modified: 28 November 2013.
By: Stijn Wouters.
```

Setting example:
```viml
:let b:autodate_keyword_pre = '<!--DATE-->'
:let b:autodate_keyword_post = '<!--DATE-->'
:let b:autodate_format = '%Y/%m/%d'
```

The result:
```
<!--DATE-->2003/06/24<!--DATE-->
```

## Installing
I strongly recommend to install [Pathogen](https://github.com/tpope/vim-pathogen)
so you've just to do:

```sh
$ cd ~/.vim/bundle/
$ git clone https://github.com/Stijn-Flipper/autodate.vim.git
```

> If you're using Windows, drop the repository into `~\vimfiles\bundle\` instead.

You might also want to fork it first, so you can make some modification to it
and pushing to you own repo instead of mine.
