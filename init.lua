
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.ayucolor="mirage"

-- optionally enable 24-bit colour
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.tw = 0
vim.opt.tabstop = 2
vim.opt.background = dark 
-- Plug stuff
local vim = vim
local Plug = vim.fn["plug#"]
vim.call("plug#begin")

Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
Plug('williamboman/mason.nvim')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')
Plug('mhartington/formatter.nvim')
Plug('nvim-lualine/lualine.nvim')
Plug('Luxed/ayu-vim')
Plug('lewis6991/gitsigns.nvim')
Plug('romgrk/barbar.nvim')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', {tag ='0.1.8'})
Plug('nvim-pack/nvim-spectre')

vim.call('plug#end')
vim.cmd 'colorscheme ayu'

require('lualine').setup({
  options = {
    theme = 'ayu',
  }
})
require('spectre').setup({
				open_cmd = "new"
})
require('telescope').setup()
require('gitsigns').setup()
require('barbar').setup()
require("nvim-tree").setup({
  view = {
    width = 30,
  },
  renderer = {
    group_empty = false,
  },
  filters = {
    dotfiles = true,
  },
})

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    })
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]-- 

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
})

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
   { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['gopls'].setup {
  capabilities = capabilities
}


-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    go = {
      require("formatter.filetypes.go").gofmt,
    },

    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    [""] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}



-- Keymaps
local ntree_api = require "nvim-tree.api"

local function opts(desc)
  return { desc = "Custom keymap: " .. desc, noremap = true, silent = true, nowait = true }
end

vim.keymap.set('n', '<C-b>', ntree_api.tree.toggle, opts('Toggle NvimTree'))
vim.keymap.set('n', '<C-w>', "<Cmd>BufferClose<CR>", opts('Close Buffer'))
vim.keymap.set('n', '<C-f>', "<Cmd>Format<CR>", opts('Format file'))

local builtin = require('telescope.builtin')
vim.keymap.set('n', 'ff', builtin.find_files, {})
vim.keymap.set('n', 'fg', builtin.live_grep, {})
--vim.keymap.set('n', '<C-f>', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
--    desc = "Toggle Spectre"
--})
