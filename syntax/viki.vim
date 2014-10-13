" viki.vim -- the viki syntax file
" @Author:      Tom Link (micathom AT gmail com?subject=vim)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     30-Dez-2003.
" @Last Change: 2014-10-09.
" @Revision: 0.1106

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif
scriptencoding utf-8

" This command sets up buffer variables and adds some basic highlighting.
let b:vikiEnabled = 0
call viki#DispatchOnFamily('MinorMode', '', 2)
let b:vikiEnabled = 2

syntax spell toplevel

if g:viki#use_texmath
    runtime syntax/texmath.vim
endif

" On slow machine the extended syntax highlighting can cause some major 
" slowdown (I'm not really sure what is causing this, but it can be 
" avoided anyway by highlighting only the basic syntax)
" if g:vikiBasicSyntax
"     finish
" endif

syn match vikiSemiParagraph /^\s\+$/

syn match vikiEscape /\\/ contained containedin=vikiEscapedChar
syn match vikiEscapedChar /\\\_./ contains=vikiEscape,vikiChar

" exe 'syn match vikiAnchor /^\('. escape(b:vikiCommentStart, '\/.*^$~[]') .'\)\?[[:blank:]]*#'. b:vikiAnchorNameRx .'/'
exe 'syn match vikiAnchor /^[[:blank:]]*%\?[[:blank:]]*#'. b:vikiAnchorNameRx .'.*/'
" syn match vikiMarkers /\(\([#?!+]\)\2\{2,2}\)/
syn match vikiMarkers /\V\(###\|???\|!!!\|+++\)/

if has('conceal') && &enc == 'utf-8'
    let s:sym_cluster = []
    for [s:name, s:chars, s:cchar] in [
                \ ['Dash', '--', '—'],
                \ ['Unequal', '!=', '≠'],
                \ ['Identity', '==', '≡'],
                \ ['Approx', '~~', '≈'],
                \ ['ArrowLR', '<-\+>', '↔'],
                \ ['ArrowL', '<-\+', '←'],
                \ ['ArrowR', '-\+>', '→'],
                \ ['ARROWLR', '<=\+>', '⇔'],
                \ ['ARROWL', '<=\+', '⇐'],
                \ ['ARROWR', '=\+>', '⇒'],
                \ ['ArrowTildeLR', '<~\+>', '↭'],
                \ ['ArrowTildeL', '<~\+', '↜'],
                \ ['ArrowTildeR', '~\+>', '↝'],
                \ ['Ellipsis', '...', '…'],
                \ ]
        
        exec 'syn match vikiSymbol'. s:name .' /\V'. s:chars .'/ conceal cchar='. s:cchar
        call add(s:sym_cluster, 'vikiSymbol'. s:name)
    endfor
    syn match vikiSymbolExtra /\V\(&\(#\d\+\|\w\+\);\)/
    exec 'syn cluster vikiSymbols contains=vikiSymbolExtra,'. join(s:sym_cluster, ',')
    unlet s:name s:chars s:cchar s:sym_cluster
else
    " syn match vikiSymbols /\(--\|!=\|==\+\|\~\~\+\|<-\+>\|<=\+>\|<\~\+>\|<-\+\|-\+>\|<=\+\|=\+>\|<\~\+\|\~\+>\|\.\.\.\)/
    syn match vikiSymbols /\V\(--\|!=\|==\+\|~~\+\|<-\+>\|<=\+>\|<~\+>\|<-\+\|-\+>\|<=\+\|=\+>\|<~\+\|~\+>\|...\|&\(#\d\+\|\w\+\);\)/
    syn cluster vikiSymbols contains=vikiSymbols
endif

syn cluster vikiHyperLinks contains=vikiLink,vikiExtendedLink,vikiURL,vikiInexistentLink

if b:vikiTextstylesVer == 1
    syn match vikiBold /\(^\|\W\zs\)\*\(\\\*\|\w\)\{-1,}\*/
    syn region vikiContinousBold start=/\(^\|\W\zs\)\*\*[^ 	*]/ end=/\*\*\|\n\{2,}/ skip=/\\\n/ contains=@Spell
    syn match vikiUnderline /\(^\|\W\zs\)_\(\\_\|[^_\s]\)\{-1,}_/
    syn region vikiContinousUnderline start=/\(^\|\W\zs\)__[^ 	_]/ end=/__\|\n\{2,}/ skip=/\\\n/ contains=@Spell
    syn match vikiTypewriter /\(^\|\W\zs\)=\(\\=\|\w\)\{-1,}=/
    syn region vikiContinousTypewriter start=/\(^\|\W\zs\)==[^ 	=]/ end=/==\|\n\{2,}/ skip=/\\\n/ contains=@Spell
    syn match vikiColor /\(^\|\W\zs\)'\(\\\*\|\w\)\{-1,}'/
    syn region vikiContinousColor start=/\(^\|\W\zs\)''[^      _]/ end=/''\|\n\{2,}/ skip=/\\\n/ contains=@Spell
    syn region vikiExample start=/^>\s*$/ end=/^<\s*$/ fold
    syn cluster vikiTextstyles contains=vikiBold,vikiContinousBold,vikiTypewriter,vikiContinousTypewriter,vikiUnderline,vikiContinousUnderline,vikiEscapedChar,vikiColor,vikiContinousColor
else
    if has('conceal')
        syn region vikiBold matchgroup=NonText start=/\(^\|\W\zs\)__\ze[^ 	_]/ end=/__\|\n\{2,}/ skip=/\\_\|\\\n/ contains=vikiEscapedChar,@Spell
                    \ concealends
        syn region vikiTypewriter matchgroup=NonText start=/\(^\|[^\w`]\zs\)''\ze[^ 	']/ end=/''\|\n\{2,}/ skip=/\\'\|\\\n/ contains=vikiEscapedChar,@Spell
                    \ concealends
    else
        syn region vikiBold start=/\(^\|\W\zs\)__\ze[^ 	_]/ end=/__\|\n\{2,}/ skip=/\\_\|\\\n/ contains=vikiEscapedChar,@Spell
        syn region vikiTypewriter start=/\(^\|[^\w`]\zs\)''\ze[^ 	']/ end=/''\|\n\{2,}/ skip=/\\'\|\\\n/ contains=vikiEscapedChar,@Spell
    endif
    syn cluster vikiTextstyles contains=vikiBold,vikiTypewriter,vikiEscapedChar
endif

syn cluster vikiText contains=@Spell,@vikiTextstyles,@vikiHyperLinks,vikiMarkers,@vikiSymbols

" exe 'syn match vikiComment /\V\^\[[:blank:]]\*'. escape(b:vikiCommentStart, '\/') .'\.\*/ contains=@vikiText'
" syn match vikiComment /^[[:blank:]]*%.*$/ contains=@vikiText
syn match vikiComment /^[[:blank:]]*%.*$/ contains=@vikiHyperLinks,vikiMarkers,vikiEscapedChar

" syn region vikiString start=+^[[:blank:]]\+"\|"+ end=+"[.?!]\?[[:blank:]]\+$\|"+ contains=@vikiText
" syn region vikiString start=+^"\|\s"\|[({\[]\zs"+ end=+"+ contains=@vikiText
syn region vikiString start=+^"\|\s"\|[({\[]\zs"\|[^[:alnum:]]\zs"\ze[[:alnum:]]+ end=+"+ contains=@vikiText

let b:vikiHeadingStart = '*'
if g:vikiFancyHeadings
    let hd=escape(b:vikiHeadingStart, '\/')
    exe 'syn region vikiHeading1 start=/\V\^'. hd .'\[[:blank:]]\+/ end=/\n/ contains=@vikiText'
    exe 'syn region vikiHeading2 start=/\V\^'. hd.hd .'\[[:blank:]]\+/ end=/\n/ contains=@vikiText'
    exe 'syn region vikiHeading3 start=/\V\^'. hd.hd.hd .'\[[:blank:]]\+/ end=/\n/ contains=@vikiText'
    exe 'syn region vikiHeading4 start=/\V\^'. hd.hd.hd.hd .'\[[:blank:]]\+/ end=/\n/ contains=@vikiText'
    exe 'syn region vikiHeading5 start=/\V\^'. hd.hd.hd.hd.hd .'\[[:blank:]]\+/ end=/\n/ contains=@vikiText'
    exe 'syn region vikiHeading6 start=/\V\^'. hd.hd.hd.hd.hd.hd .'\[[:blank:]]\+/ end=/\n/ contains=@vikiText'
else
    exe 'syn region vikiHeading start=/\V\^'. escape(b:vikiHeadingStart, '\/') .'\+\[[:blank:]]\+/ end=/\n/ contains=@vikiText'
endif

syn match vikiTableRowSep /||\?/ contained containedin=vikiTableRow,vikiTableHead
syn region vikiTableHead start=/^[[:blank:]]*|| / skip=/\\\n/ end=/\(^\| \)||[[:blank:]]*$/
            \ transparent keepend
            " \ contains=ALLBUT,vikiTableRow,vikiTableHead 
syn region vikiTableRow  start=/^[[:blank:]]*| / skip=/\\\n/ end=/\(^\| \)|[[:blank:]]*$/
            \ transparent keepend
            " \ contains=ALLBUT,vikiTableRow,vikiTableHead

syn keyword vikiCommandNames 
            \ #CAP #CAPTION #LANG #LANGUAGE #INC #INCLUDE #DOC #VAR #KEYWORDS #OPT 
            \ #PUT #CLIP #SET #GET #XARG #XVAL #ARG #VAL #BIB #TITLE #TI #AUTHOR 
            \ #AU #AUTHORNOTE #AN #DATE #IMG #IMAGE #FIG #FIGURE #MAKETITLE 
            \ #MAKEBIB #LIST #DEFLIST #REGISTER #DEFCOUNTER #COUNTER #TABLE #IDX 
            \ #AUTOIDX #NOIDX #DONTIDX #WITH #ABBREV #MODULE #MOD #LTX #INLATEX 
            \ #PAGE #NOP
            \ contained containedin=vikiCommand

syn keyword vikiRegionNames
            \ #Doc #Var #Native #Ins #Write #Code #Inlatex #Ltx #Img #Image #Fig 
            \ #Figure #Footnote #Fn #Foreach #Table #Verbatim #Verb #Abstract 
            \ #Quote #Qu #R #Ruby #Clip #Put #Set #Header #Footer #Swallow #Skip 
            \ contained containedin=vikiMacroDelim,vikiRegion,vikiRegionWEnd,vikiRegionAlt

syn keyword vikiMacroNames 
            \ {fn {cite {attr {attrib {date {doc {var {arg {val {xarg {xval {opt 
            \ {msg {clip {get {ins {native {ruby {ref {anchor {label {lab {nl {ltx 
            \ {math {$ {list {item {term {, {sub {^ {sup {super {% {stacked {: 
            \ {text {plain {\\ {em {emph {_ {code {verb {img {cmt {pagenumber 
            \ {pagenum {idx {let {counter 
            \ contained containedin=vikiMacro,vikiMacroDelim

syn match vikiSkeleton /{{\_.\{-}[^\\]}}/

syn region vikiMacro matchgroup=vikiMacroDelim start=/{\W\?[^:{}]*:\?/ end=/}/ 
            \ transparent contains=@vikiText,vikiMacroNames,vikiMacro

syn region vikiRegion matchgroup=vikiMacroDelim 
            \ start=/^[[:blank:]]*#\([A-Z]\([a-z][A-Za-z]*\)\?\>\|!!!\)\(\\\n\|.\)\{-}<<\z(.*\)$/ 
            \ end=/^[[:blank:]]*\z1[[:blank:]]*$/ 
            \ contains=@vikiText,vikiRegionNames
" syn region vikiRegionWEnd matchgroup=vikiMacroDelim 
"             \ start=/^[[:blank:]]*#\([A-Z]\([a-z][A-Za-z]*\)\?\>\|!!!\)\(\\\n\|.\)\{-}:[[:blank:]]*$/ 
"             \ end=/^[[:blank:]]*#End[[:blank:]]*$/ 
"             \ contains=@vikiText,vikiRegionNames
syn region vikiRegionAlt matchgroup=vikiMacroDelim 
            \ start=/^[[:blank:]]*\z(=\{4,}\)[[:blank:]]*\([A-Z][a-z]*\>\|!!!\)\(\\\n\|.\)\{-}$/ 
            \ end=/^[[:blank:]]*\z1\([[:blank:]].*\)\?$/ 
            \ contains=@vikiText,vikiRegionNames

syn match vikiCommand /^\C[[:blank:]]*#\([A-Z]\{2,}\)\>\(\\\n\|.\)*/
            \ contains=vikiCommandNames

" syn match vikiFilesMarkers /\[\[\([^\/]\+\/\)*\|\]!\]/ contained containedin=vikiFiles
" syn match vikiFilesIndicators /{.\{-}}/ contained containedin=vikiFiles
syn match vikiFilesIndicators /^\s*[`_+|\\-]\+\s/ contained containedin=vikiFiles
syn match vikiFiles /^\(\s*[`_+|\\-]\+\s\+\)\?\[\[.\{-}\]!\].*$/
            \ contained containedin=vikiFilesRegion contains=vikiExtendedLink,vikiFilesIndicators
syn region vikiFilesRegion matchgroup=vikiMacroDelim
            \ start=/^[[:blank:]]*#Files\>\(\\\n\|.\)\{-}<<\z(.*\)$/ 
            \ end=/^[[:blank:]]*\z1[[:blank:]]*$/ 
            \ contains=vikiFiles


if g:vikiHighlightMath == 'latex'
    syn region vikiTexFormula matchgroup=Comment
                \ start=/\z(\$\$\?\)/ end=/\z1/
                \ contains=@texmathMath
    syn sync match vikiTexFormula grouphere NONE /^\s*$/
endif

syn region vikiTexMacro matchgroup=vikiMacroDelim
            \ start=/{\(ltx\)\([^:{}]*:\)\?/ end=/}/ 
            \ transparent contains=vikiMacroNames,@texmath
syn region vikiTexMathMacro matchgroup=vikiMacroDelim
            \ start=/{\(math\>\|\$\)\([^:{}]*:\)\?/ end=/}/ 
            \ transparent contains=vikiMacroNames,@texmathMath
syn region vikiTexRegion matchgroup=vikiMacroDelim
            \ start=/^[[:blank:]]*#Ltx\>\(\\\n\|.\)\{-}<<\z(.*\)$/ 
            \ end=/^[[:blank:]]*\z1[[:blank:]]*$/ 
            \ contains=@texmathMath


if &ft == 'viki'
    let s:is_keyword = &l:iskeyword
    for s:filetype in viki#CollectSyntaxRegionsFiletypes()
        unlet! b:current_syntax
        setl iskeyword&
        let s:filetype1 = get(g:viki#code_syntax_map, s:filetype, s:filetype)
        exec 'syntax include @vikiCode_'. s:filetype 'syntax/'. s:filetype1 .'.vim'
        exec 'silent! syntax include @vikiCode_'. s:filetype 'after/syntax/'. s:filetype1 .'.vim'
        exec 'syn region vikiCodeRegion_'. s:filetype
                    \ 'matchgroup=vikiMacroDelim'
                    \ 'start=/^\s*#Code\>.\{-}\<syntax='. s:filetype .'\>\(\\\n\|.\)\{-}<<\z(.*\)$/'
                    \ 'end=/^[[:blank:]]*\z1\([[:blank:]].*\)\?$/'
                    \ 'contains=@vikiCode_'. s:filetype
        " Workaround based on vimviki Issue 115
        if s:filetype =~ 'perl'
            syntax clear perlFunctionName
        endif
    endfor
    let &l:iskeyword = s:is_keyword
    unlet! s:filetype s:filetype1 s:is_keyword
endif


syn match vikiList /^[[:blank:]]\+\([-+*#?@]\|[0-9#]\+\.\|[a-zA-Z?]\.\)\ze[[:blank:]]/
syn match vikiDescription /^[[:blank:]]\+\(\\\n\|.\)\{-1,}[[:blank:]]::\ze[[:blank:]]/ contains=@vikiHyperLinks,vikiEscapedChar,vikiComment

syn match vikiPriorityListTodo0 /#\(T: \+.\{-}\u.\{-}:\|\d*\u\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syn match vikiPriorityListTodoA /#\(T: \+.\{-}A.\{-}:\|\d*A\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syn match vikiPriorityListTodoB /#\(T: \+.\{-}B.\{-}:\|\d*B\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syn match vikiPriorityListTodoC /#\(T: \+.\{-}C.\{-}:\|\d*C\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syn match vikiPriorityListTodoD /#\(T: \+.\{-}D.\{-}:\|\d*D\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syn match vikiPriorityListTodoE /#\(T: \+.\{-}E.\{-}:\|\d*E\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syn match vikiPriorityListTodoF /#\(T: \+.\{-}F.\{-}:\|\d*F\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress

syn cluster vikiPriorityListTodo contains=vikiPriorityListTodoA,vikiPriorityListTodoB,vikiPriorityListTodoC,vikiPriorityListTodoD,vikiPriorityListTodoE,vikiPriorityListTodoF,vikiPriorityListTodo0

let s:progress = '\(_\|[0-9]\+%\|\d\{4}-\d\{2}-\d\{2}\(\.\.\d\{4}-\d\{2}-\d\{2}\)\?\)'
exec 'syn match vikiProgress /\s\+'. s:progress .'/ contained containedin=vikiPriorityListTodoGen'

if has('conceal')
    syn match vikiTagPrefix /\s\zs:/ contained containedin=vikiTag conceal
    syn match vikiContactPrefix /\s\zs@/ contained containedin=vikiContact conceal
    syn match vikiTag /\(\s\(:\(\d\{4}-\d\{2}-\d\{2}\|[^[:punct:][:space:]]\+\)\+\)\+\)\+/ contained containedin=vikiPriorityListTodoGen contains=vikiTagPrefix
    syn match vikiContact /\s@[^[:punct:][:space:]]\+/ contained containedin=vikiPriorityListTodoGen contains=vikiContactPrefix
else
    syn match vikiTag /\(\s\+\(:\(\d\{4}-\d\{2}-\d\{2}\|[^[:punct:][:space:]]\+\)\+\)\+\)\+/ contained containedin=vikiPriorityListTodoGen
    syn match vikiContact /\s\+\zs@[^[:punct:][:space:]]\+/ contained containedin=vikiPriorityListTodoGen
endif

" syn cluster vikiPriorityListTodoInline contains=@vikiPriorityListTodo,vikiTag,vikiContact

let s:plquant = g:vikiIndentedPriorityLists ? '\+' : '*'

exec 'syn match vikiPriorityListTodoGen /^[[:blank:]]'. s:plquant .'\zs#\(T: \+.\{-}\u.\{-}:\|\d*\u\d*\(\s\+'. s:progress .'\)\?\)\s.*$/ contains=vikiContact,vikiTag,@vikiPriorityListTodo,@vikiText'
exec 'syn match vikiPriorityListDoneGen /^[[:blank:]]'. s:plquant .'\zs#\(T: \+x\([0-9%-]\+\)\?.\{-}\u.\{-}:\|\(T: \+\)\?\d*\u\d* \+x'. s:progress .'\?\):\? .*/'
exec 'syn match vikiPriorityListDoneX /^[[:blank:]]'. s:plquant .'\zs#[X-Z]\d\?\s.*/'

unlet s:plquant


syntax sync minlines=2
" syntax sync maxlines=50
" syntax sync match vikiParaBreak /^\s*$/
" syntax sync linecont /\\$/


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_viki_syntax_inits")
  if version < 508
      let did_viki_syntax_inits = 1
      command! -nargs=+ HiLink hi link <args>
  else
      command! -nargs=+ HiLink hi def link <args>
  endif
  
  if &background == "light"
      let s:cm1="Dark"
      let s:cm2="Light"
  else
      let s:cm1="Light"
      let s:cm2="Dark"
  endif

  if exists("g:vikiHeadingFont")
      let s:hdfont = " font=". g:vikiHeadingFont
  else
      let s:hdfont = ""
  endif
  
  if exists("g:vikiTypewriterFont")
      let s:twfont = " font=". g:vikiTypewriterFont
  else
      let s:twfont = ""
  endif

  HiLink vikiSemiParagraph NonText
  HiLink vikiEscapedChars Normal
  exe "hi vikiEscape ctermfg=". s:cm2 ."grey guifg=". s:cm2 ."grey"
  hi vikiList term=bold cterm=bold gui=italic,bold ctermfg=Cyan guifg=Cyan
  HiLink vikiDescription vikiList
  if g:vikiFancyHeadings
      if &background == "light"
          let hdhl="term=bold,underline cterm=bold gui=bold ctermfg=". s:cm1 ."Magenta guifg=".s:cm1."Magenta". s:hdfont
          exe "hi vikiHeading1 ". hdhl ." guibg=#ffff00"
          exe "hi vikiHeading2 ". hdhl ." guibg=#ffff30"
          exe "hi vikiHeading3 ". hdhl ." guibg=#ffff60"
          exe "hi vikiHeading4 ". hdhl ." guibg=#ffff90"
          exe "hi vikiHeading5 ". hdhl ." guibg=#ffffb0"
          exe "hi vikiHeading6 ". hdhl ." guibg=#ffffe0"
      else
          let hdhl="term=bold,underline cterm=bold gui=bold ctermfg=DarkMagenta guifg=DarkMagenta". s:hdfont
          exe "hi vikiHeading1 ". hdhl ." guibg=#ffff00"
          exe "hi vikiHeading2 ". hdhl ." guibg=#aadd00"
          exe "hi vikiHeading3 ". hdhl ." guibg=#88aa00"
          exe "hi vikiHeading4 ". hdhl ." guibg=#558800"
          exe "hi vikiHeading5 ". hdhl ." guibg=#225500"
          exe "hi vikiHeading6 ". hdhl ." guibg=#002200"
      endif
  else
      exe "hi vikiHeading term=bold,underline cterm=bold gui=bold ctermfg=". s:cm1 ."Magenta guifg=".s:cm1."Magenta". s:hdfont
  endif
  
  let vikiPriorityListTodo = ' term=bold,underline cterm=bold gui=bold guifg=Black ctermfg=Black '
  exec 'hi vikiPriorityListTodo0'. vikiPriorityListTodo  .'ctermbg=LightRed guibg=LightRed'
  exec 'hi vikiPriorityListTodoA'. vikiPriorityListTodo  .'ctermbg=Red guibg=Red'
  exec 'hi vikiPriorityListTodoB'. vikiPriorityListTodo  .'ctermbg=Brown guibg=Orange'
  exec 'hi vikiPriorityListTodoC'. vikiPriorityListTodo  .'ctermbg=Yellow guibg=Yellow'
  exec 'hi vikiPriorityListTodoD'. vikiPriorityListTodo  .'ctermbg=LightMagenta guibg=LightMagenta'
  exec 'hi vikiPriorityListTodoE'. vikiPriorityListTodo  .'ctermbg=LightYellow guibg=LightYellow'
  exec 'hi vikiPriorityListTodoF'. vikiPriorityListTodo  .'ctermbg=LightGreen guibg=LightGreen'
  HiLink vikiContact Special
  HiLink vikiTag Title
  if has('conceal')
      HiLink vikiContactPrefix Special
      HiLink vikiTagPrefix Title
  endif
  HiLink vikiProgress WarningMsg
 
  " let vikiPriorityListDone = ' guifg='. s:cm1 .'Gray '
  " exec 'hi vikiPriorityListDoneA'. vikiPriorityListDone
  " exec 'hi vikiPriorityListDoneB'. vikiPriorityListDone
  " exec 'hi vikiPriorityListDoneC'. vikiPriorityListDone
  " exec 'hi vikiPriorityListDoneD'. vikiPriorityListDone
  " exec 'hi vikiPriorityListDoneE'. vikiPriorityListDone
  " exec 'hi vikiPriorityListDoneF'. vikiPriorityListDone
  HiLink vikiPriorityListDoneA Comment
  HiLink vikiPriorityListDoneB Comment
  HiLink vikiPriorityListDoneC Comment
  HiLink vikiPriorityListDoneD Comment
  HiLink vikiPriorityListDoneE Comment
  HiLink vikiPriorityListDoneF Comment
  HiLink vikiPriorityListDoneGen Comment
  HiLink vikiPriorityListDoneX Comment
  
  exe "hi vikiTableRowSep term=bold cterm=bold gui=bold ctermbg=". s:cm2 ."Grey guibg=". s:cm2 ."Grey"
  
  exe "hi vikiSymbols term=bold cterm=bold gui=bold ctermfg=". s:cm1 ."Red guifg=". s:cm1 ."Red"

  hi vikiMarkers term=bold cterm=bold gui=bold ctermfg=DarkRed guifg=DarkRed ctermbg=yellow guibg=yellow
  hi vikiAnchor term=italic cterm=italic gui=italic ctermfg=grey guifg=grey
  HiLink vikiComment Comment
  HiLink vikiString String
  
  if b:vikiTextstylesVer == 1
      hi vikiContinousBold term=bold cterm=bold gui=bold
      hi vikiContinousUnderline term=underline cterm=underline gui=underline
      exe "hi vikiContinousTypewriter term=underline ctermfg=". s:cm1 ."Grey guifg=". s:cm1 ."Grey". s:twfont
      HiLink vikiBold vikiContinousBold
      HiLink vikiUnderline vikiContinousUnderline 
      HiLink vikiTypewriter vikiContinousTypewriter
      hi vikiColor ctermfg=green guifg=green
      hi vikiContinousColor ctermfg=green guifg=green
      hi vikiExample ctermfg=cyan guifg=cyan
  else
      " hi vikiBold term=italic,bold cterm=italic,bold gui=italic,bold
      hi vikiBold term=bold,underline cterm=bold,underline gui=bold
      exe "hi vikiTypewriter term=underline ctermfg=". s:cm1 ."Grey guifg=". s:cm1 ."Grey". s:twfont
  endif

  HiLink vikiMacroHead Statement
  HiLink vikiMacroDelim Identifier
  HiLink vikiSkeleton Special
  HiLink vikiCommand Statement
  HiLink vikiRegion Statement
  HiLink vikiRegionWEnd vikiRegion
  HiLink vikiRegionAlt vikiRegion
  HiLink vikiFilesRegion Statement
  HiLink vikiFiles Constant
  HiLink vikiFilesMarkers Ignore
  HiLink vikiFilesIndicators Directory
  " HiLink vikiCommandNames Constant
  " HiLink vikiRegionNames Constant
  " HiLink vikiMacroNames Constant
  HiLink vikiCommandNames Identifier
  HiLink vikiRegionNames Identifier
  HiLink vikiMacroNames Identifier

  " Statement PreProc
  HiLink vikiTexSup Type
  HiLink vikiTexSub Type
  " HiLink vikiTexArgDelimiters Comment
  HiLink vikiTexCommand Statement
  HiLink vikiTexText Normal
  HiLink vikiTexMathFont Type
  HiLink vikiTexMathWord Identifier
  HiLink vikiTexUnword Constant
  HiLink vikiTexPairs PreProc

  delcommand HiLink
endif

" if g:vikiMarkInexistent && !exists("b:vikiCheckInexistent")
if g:vikiMarkInexistent
    call viki#MarkInexistentInitial()
endif

let b:current_syntax = 'viki'

