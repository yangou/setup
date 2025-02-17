vim.g.mapleader = ","

-- Enable lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
local plugins = {
  {'solarnz/thrift.vim', lazy = false},
  {'airblade/vim-gitgutter', lazy = false},
  {'altercation/vim-colors-solarized', lazy = false},
  {'austintaylor/vim-indentobject', lazy = false},
  {'christoomey/vim-tmux-navigator', lazy = false},
  {'juvenn/mustache.vim', lazy = false},
  {'kchmck/vim-coffee-script', lazy = false},
  {'ctrlpvim/ctrlp.vim', lazy = false},
  {'leafgarland/typescript-vim', lazy = false},
  {'majutsushi/tagbar', lazy = false},
  {'rking/ag.vim', lazy = false},
  {'tomtom/tlib_vim', lazy = false},
  {'nathanaelkane/vim-indent-guides', lazy = false},
  {'nono/vim-handlebars', lazy = false},
  {'pangloss/vim-javascript', lazy = false},
  {'wookiehangover/jshint.vim', lazy = false},
  {'scrooloose/nerdtree', lazy = false},
  {'scrooloose/syntastic', lazy = false},
  {'slim-template/vim-slim', lazy = false},
  {'tpope/vim-bundler', lazy = false},
  {'tpope/vim-commentary', lazy = false},
  {'tpope/vim-cucumber', lazy = false},
  {'tpope/vim-dispatch', lazy = false},
  {'tpope/vim-endwise', lazy = false},
  {'tpope/vim-fugitive', lazy = false},
  {'tpope/vim-pastie', lazy = false},
  {'tpope/vim-ragtag', lazy = false},
  {'tpope/vim-rails', lazy = false},
  {'tpope/vim-repeat', lazy = false},
  {'tpope/vim-surround', lazy = false},
  {'tpope/vim-unimpaired', lazy = false},
  {'tpope/vim-vividchalk', lazy = false},
  {'vim-ruby/vim-ruby', lazy = false},
  {'vim-scripts/Align', lazy = false},
  {'vim-scripts/greplace.vim', lazy = false},
  {'vim-scripts/matchit.zip', lazy = false},
  {'elixir-editors/vim-elixir', lazy = false},
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {'connorholyday/vim-snazzy', lazy = false},
  {'mhinz/vim-mix-format', lazy = false},
  {'chun-yang/vim-action-ag', lazy = false},
  {'junegunn/fzf', lazy = false},
  {'junegunn/fzf.vim', lazy = false},
  {'dyng/ctrlsf.vim', lazy = false},
  {'mg979/vim-visual-multi', lazy = false},
  {'fatih/vim-go', lazy = false},
  {'neoclide/coc.nvim', lazy = false},
  {'dense-analysis/ale', lazy = false},
  {'junegunn/goyo.vim', lazy = false},
  {'junegunn/limelight.vim', lazy = false},
  {'Shougo/deoplete.nvim', lazy = false},
  {'Xuyuanp/nerdtree-git-plugin', lazy = false},
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = "deepseek",
      auto_suggestions_provider = "deepseek", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
      vendors = {
	lm_studio = {
	  __inherited_from = "openai",
	  endpoint = "http://127.0.0.1:1234/v1",
          model = "deepseek-r1-distill-qwen-14b",
	  timeout = 30000, -- Timeout in milliseconds
	  temperature = 0.8,
	  max_tokens = 16384,
	  -- optional
	  api_key_name = "",
	},
	deepseek = {
	  __inherited_from = "openai",
	  endpoint = "https://api.deepseek.com/v1",
	  model = "deepseek-chat",
	  timeout = 30000, -- Timeout in milliseconds
	  temperature = 0.8,
	  max_tokens = 8192,
	  -- optional
	  api_key_name = "DEEPSEEK_API_KEY",  -- default OPENAI_API_KEY if not set
	},
      },
      behaviour = {
        auto_suggestions = true
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      }
    }
  }
}

require("lazy").setup(plugins)

require('lualine').setup({
  options = {
    theme = 'palenight'
  }
})

vim.cmd('source $HOME/.vim/plugin/whitespace/whitespace.vim')

vim.cmd('source $HOME/.vimrc')

vim.opt.fillchars = {
  vert = "|",
  fold = "-",
  eob = "~",
  lastline = "@"
}


-- exit terminal buffer
vim.api.nvim_set_keymap('t', '<leader><Esc>', '<C-\\><C-n>', {noremap = true})
vim.api.nvim_set_keymap('n', 'vt', ':vsplit | terminal<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ht', ':split | terminal<CR>', { noremap = true, silent = true })
