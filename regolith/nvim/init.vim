" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
"Plug 'tsony-tsonev/nerdtree-git-plugin'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
Plug 'scrooloose/nerdcommenter'
"Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'chrisbra/Colorizer'
Plug 'christoomey/vim-tmux-navigator'

Plug 'morhetz/gruvbox'

Plug 'HerringtonDarkholme/yats.vim' " TS Syntax

" Initialize plugin system
call plug#end()

inoremap jk <ESC>
nmap <C-n> :NERDTreeToggle<CR>

let NERDTreeMinimalUI=1

set relativenumber

" Cosas de tabulacion
set smarttab
set cindent
set tabstop=2
set shiftwidth=2
" always uses spaces instead of tab characters
set expandtab

colorscheme gruvbox

" if hidden is not set, TextEdit might fail.
set updatetime=300
set signcolumn=no
" don't give |ins-completion-menu| messages.


" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> fk <Plug>(coc-diagnostic-prev)
nmap <silent> fj <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Add status line support, for integration with other plugin, checkout `:h coc-status`

au VimEnter * hi Normal ctermbg=none guibg=none
nnoremap <C-c> :w <bar> :silent execute '!/home/pablo-snz/.scripts/compile %:p' <bar> :redraw! <Enter>

" Terminal Configurations
tnoremap jk <C-\><C-n>
nnoremap t :sp <bar> :wincmd j <bar> :res -20 <bar> :let $VIM_DIR=expand('%:p:h')<bar> cd $VIM_DIR <bar> :terminal<CR>

" remap ñ to : in normal mode
nnoremap ñ :

command! -nargs=* Tabmerge call Tabmerge(<f-args>)

function! Tabmerge(...)  " {{{1
	if a:0 > 2
		echohl ErrorMsg
		echo "Too many arguments"
		echohl None
		return
	elseif a:0 == 2
		let tabnr = a:1
		let where = a:2
	elseif a:0 == 1
		if a:1 =~ '^\d\+$' || a:1 == '$'
			let tabnr = a:1
		else
			let where = a:1
		endif
	endif

	if !exists('l:where')
		let where = 'top'
	endif

	if !exists('l:tabnr')
		if type(tabpagebuflist(tabpagenr() + 1)) == 3
			let tabnr = tabpagenr() + 1
		elseif type(tabpagebuflist(tabpagenr() - 1)) == 3
			let tabnr = tabpagenr() - 1
		else
			echohl ErrorMsg
			echo "Already only one tab"
			echohl None
			return
		endif
	endif

	if tabnr == '$'
		let tabnr = tabpagenr(tabnr)
	else
		let tabnr = tabnr
	endif

	let tabwindows = tabpagebuflist(tabnr)

	if type(tabwindows) == 0 && tabwindows == 0
		echohl ErrorMsg
		echo "No such tab number: " . tabnr
		echohl None
		return
	elseif tabnr == tabpagenr()
		echohl ErrorMsg
		echo "Can't merge with the current tab"
		echohl None
		return
	endif

	if where =~? '^t\(op\)\?$'
		let where = 'topleft'
	elseif where =~? '^b\(ot\(tom\)\?\)\?$'
		let where = 'botright'
	elseif where =~? '^l\(eft\)\?$'
		let where = 'leftabove vertical'
	elseif where =~? '^r\(ight\)\?$'
		let where = 'rightbelow vertical'
	else
		echohl ErrorMsg
		echo "Invalid location: " . a:2
		echohl None
		return
	endif

	let save_switchbuf = &switchbuf
	let &switchbuf = ''

	if where == 'top'
		let tabwindows = reverse(tabwindows)
	endif

	for buf in tabwindows
		exe where . ' sbuffer ' . buf
	endfor

	exe 'tabclose ' . tabnr

	let &switchbuf = save_switchbuf
endfunction

"
