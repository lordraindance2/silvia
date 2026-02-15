-- OPTIONS
vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.termguicolors = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

vim.o.wrap = false

-- OPTIONS>Tabs
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.o.winborder = "rounded"

vim.o.autoindent = true
vim.o.smartindent = true
vim.o.cindent = true

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- OPTIONS>diagnostic
vim.diagnostic.config({
  virtual_text = { current_line = false }
})

vim.o.autoread = true
vim.o.swapfile = false

vim.o.clipboard = "unnamedplus"

-- MISC
vim.filetype.add({
  extension = {
    pory = "pory",
  },
})

-- PLUGINS TODO: this could probably be separate files.
vim.pack.add({
  -- COLORSCHEME
  { src = "https://github.com/EdenEast/nightfox.nvim" },
  { src = "https://github.com/aikhe/fleur.nvim" },
  -- Features
  { src = "https://github.com/nvim-mini/mini.move",  },
  { src = "https://github.com/nvim-mini/mini.pick",  },
  { src = "https://github.com/nvim-mini/mini.files", },
  { src = "https://github.com/nvim-mini/mini.icons", },
  { src = "https://github.com/nvim-mini/mini-git", }, -- For mini.statusline functionality
  { src = "https://github.com/nvim-mini/mini.statusline", },
  { src = "https://github.com/nvim-mini/mini.notify", },
  { src = "https://github.com/nvim-mini/mini.indentscope", },
  { src = "https://github.com/nvim-mini/mini.cursorword", },
  { src = "https://github.com/folke/which-key.nvim" },
  -- LSP
  { src = "https://github.com/nvim-treesitter/nvim-treesitter.git", build = ":TSUpdate" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})

vim.cmd("colorscheme duskfox")

require("mini.pick").setup({
  options = {
    content_from_bottom = true,
    use_cache = true,
  },
})

vim.keymap.set("n", "<leader>ff", "<Cmd>Pick files<CR>", { desc = "File Picker" })
vim.keymap.set("n", "<leader>fb", "<Cmd>Pick buffers<CR>", { desc = "Buffer Picker" })
vim.keymap.set("n", "<leader>fg", "<Cmd>Pick grep_live<CR>", { desc = "Grep" })
vim.keymap.set("n", "<leader>fh", "<Cmd>Picker Help<CR>", { desc = "Picker Help" })

local MiniFiles = require("mini.files")
MiniFiles.setup()
vim.keymap.set("n", "<leader>e", function()
  -- Fix annoying bug with spamming
  if (vim.api.nvim_buf_get_name(0):sub(1, #"minifiles://") ==  "minifiles://") then
    return
  end
  MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
  MiniFiles.reveal_cwd()
end, { desc = "File Explorer" })

require("mini.move").setup()
require("mini.git").setup()
require("mini.icons").setup()
require("mini.statusline").setup()
require("mini.notify").setup()
require("mini.indentscope").setup()
require("mini.cursorword").setup()

-- treesitter-poryscript
vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').poryscript = {
      install_info = {
        url = 'https://github.com/Elsie19/treesitter-poryscript',
        branch = 'master',
        queries = 'queries/poryscript',
      },
    }
  end
})
vim.treesitter.language.register('poryscript', { 'pory' })

require('nvim-treesitter').install({
  "lua", "c", "vimdoc", "markdown", "vim", "json", "python", "poryscript", "zig"
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "lua", "c", "vimdoc", "markdown", "vim", "json", "python", "poryscript", "zig", "cmake",
  },
  callback = function()
    vim.treesitter.start()

    vim.o.autoindent = false
    vim.o.smartindent = false
    vim.o.cindent = false
    vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
  end,
})

-- If you want to try indentation with nvim-treesitter. In my experience, it's pretty awful
-- vim.keymap.set('n', '<leader>sT', function()
--   local current_indentexpr = vim.bo.indentexpr
--   local current_buffer = vim.api.nvim_get_current_buf()
--   if current_indentexpr ~= "v:lua.require('nvim-treesitter').indentexpr()" then
--     vim.b[current_buffer].rahlir_previous_indentexpr = current_indentexpr
--     vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
--     vim.print("Turned on treesitter indent...")
--     vim.o.autoindent = false
--     vim.o.smartindent = false
--     vim.o.cindent = false
--   else
--     local previous_indentexpr = vim.b[current_buffer].rahlir_previous_indentexpr
--     if previous_indentexpr == nil then
--       previous_indentexpr = ""
--     end
--     vim.bo.indentexpr = previous_indentexpr
--     vim.o.autoindent = true
--     vim.o.smartindent = true
--     vim.o.cindent = true
--     vim.print("Turned off treesitter indent...")
--   end
-- end, { noremap=true, silent=true, desc="Toggle treesitter indent" })

-- LSPCONFIG
require("blink-cmp").setup({
  keymap = { preset = "enter" },
  sources = {
    default = { 'lsp', 'buffer', 'snippets', 'path' },
    per_filetype = {
      pory = { "omni", "buffer", "snippets", "path" }
    },
    providers = {
      omni = {
        enabled = true,
        score_offset = 100,
        max_items = 10,
      },
    },
  },
})

vim.lsp.enable({"lua-ls", "poryscript", "clangd", "zls"})
