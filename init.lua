vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/tree-sitter")

-- OPTIONS
vim.g.mapleader = " "

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

vim.o.wrap = false
vim.o.swapfile = false

-- OPTIONS>Tabs
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autoindent = true

vim.o.winborder = "rounded"

-- OPTIONS>diagnostic
vim.diagnostic.config({
  virtual_text = { current_line = false }
})

-- MISC
vim.filetype.add({
  extension = {
    pory = "pory",
  },
})

-- COLORSCHEME
vim.pack.add({
  { src = "https://github.com/EdenEast/nightfox.nvim" },
})

vim.cmd("colorscheme duskfox")

-- PLUGINS TODO: this could probably be separate files.
vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.pick",  },
  { src = "https://github.com/nvim-mini/mini.files", },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter.git", build = ":TSUpdate" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})

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

require("mini.files").setup()
vim.keymap.set("n", "<leader>e", "<Cmd>lua MiniFiles.open()<CR>", { desc = "File Explorer" })

-- treesitter-poryscript
vim.api.nvim_create_autocmd("FileType", {
  pattern = "pory",
  callback = function()
    vim.treesitter.start()
  end,
})

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

require("nvim-treesitter.config").setup({
    ensure_installed = { "lua", "c", "vimdoc", "markdown", "vim", "json", "python", "poryscript" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
})

-- LSPCONFIG
require("blink-cmp").setup({
  keymap = { preset = "enter" },
})

vim.lsp.enable({"lua-ls", "poryscript", "clangd"})
