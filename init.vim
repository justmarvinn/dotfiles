" https://vimdoc.sourceforge.net/htmldoc/options.html`
"
" You need to install:
" vim-plug
" exuberant ctags
" ripgrep
"
" LSPs by default:
" rust-analyzer
" clangd
" if you want to change its, edit line 73 and 136
"
" also recommend if using alacritty:
" sudo pacman -S ttf-jetbrains-mono
" mkdir ~/.config/alacritty
" touch ~/.config/alacritty/alacritty.yml
"
" with next contents:
" font:
"   normal:
"     family: JetBrains Mono
"     style: Regular


set number
" set relativenumber
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab
set autoindent
set mouse=a
set nowrap
set scrolloff=8
" set showmatch
syntax enable
filetype indent on
set encoding=UTF-8
set noswapfile
set autoread

filetype plugin indent on

call plug#begin('~/.config/nvim/plugged')

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
nnoremap ff <cmd>Telescope find_files<cr>
nnoremap fg <cmd>Telescope live_grep<cr>

Plug 'neovim/nvim-lspconfig'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'preservim/nerdtree'
nmap <C-d> :NERDTreeToggle<CR>

Plug 'tpope/vim-commentary'
Plug 'ryanoasis/vim-devicons'
Plug 'terryma/vim-multiple-cursors'

Plug 'majutsushi/tagbar'
nmap <C-a> :TagbarToggle<CR>

if (has('termguicolors'))
    set termguicolors
endif

Plug 'joshdick/onedark.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'sickill/vim-monokai'

" Plug 'rust-lang/rust.vim'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
nmap md <Plug>MarkdownPreview
" nmap <C-p> <Plug>MarkdownPreviewToggle
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
" nmap md <cmd>MarkdownPreview<CR>

call plug#end()

colorscheme onedark
" colorscheme dracula
" colorscheme monokai

lua <<EOF
    -- Setup treesitter
    require('nvim-treesitter.configs').setup {
        ensure_installed = { "rust", "cpp", "comment", "markdown" },
    }

    -- Set up nvim-cmp.
    local cmp = require'cmp'
    cmp.setup({
        -- completion = {
        --     autocomplete = false
        -- },
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            -- ['<C-j>'] = cmp.mapping.scroll_docs(4),
            -- ['<C-k>'] = cmp.mapping.scroll_docs(-4),
            ['<C-n>'] = cmp.mapping.scroll_docs(4),
            ['<C-p>'] = cmp.mapping.scroll_docs(-4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            -- { name = 'vsnip' }, -- For vsnip users.
            -- { name = 'luasnip' }, -- For luasnip users.
            -- { name = 'ultisnips' }, -- For ultisnips users.
            -- { name = 'snippy' }, -- For snippy users.
        }, {
            { name = 'buffer' },
        })
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
    })

    -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
    })

    -- Set up lspconfig.
    local servers = { 'clangd', 'rust_analyzer' }
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    for _, server in ipairs(servers) do
        require('lspconfig')[server].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            -- flags = {
            --     debounce_text_changes = 150,
            -- },
        }
    end
EOF
