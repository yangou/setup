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
  {'vim-airline/vim-airline', lazy = false},
  {'vim-airline/vim-airline-themes', lazy = false},
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
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      -- add any opts here
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
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
      },
    },
  }
}

require("lazy").setup(plugins)

vim.cmd('source $HOME/.vim/plugin/whitespace/whitespace.vim')

vim.cmd('source $HOME/.vimrc')
