---@brief
---
--- https://github.com/huderlem/poryscript-pls
---
--- Language server for poryscript (a high level scripting language for GBA-era Pokémon decompilation projects)

---@type vim.lsp.Config
return {
  cmd = { 'poryscript-pls' },
  filetypes = { 'pory' },
  root_markers = { '.git' },
  workspace_required = true,
  workspace_folders = nil,
  capabilities = require("blink-cmp").get_lsp_capabilities({
    workspace = {
      workspaceFolders = true,
      configuration = false,
    },
  }),
  handlers = {
    ["poryscript/getPoryscriptFiles"] = function()
      -- Search for all .pory files and return a table of URIs
      local files = vim.fs.find(function(name)
        return name:match('.*%.pory$')
      end, { limit = math.huge, type = 'file' })

      local files_array = {}
      for _, v in ipairs(files) do
        table.insert(files_array, vim.uri_from_fname(v))
      end
      return files_array
    end,

    ["poryscript/getfileuri"] = function()
      return vim.uri_from_bufnr(0)
    end,

    ["poryscript/readfile"] = function(_, filepath)
      print("LSP requesting file: ", filepath)
      local lines = vim.fn.readfile(filepath)
      return table.concat(lines, "\n")
    end,

    ["poryscript/readfs"] = function(_, result)
      local bufnr = vim.uri_to_bufnr(result)
      if vim.api.nvim_buf_is_loaded(bufnr) then
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        return table.concat(lines, "\n")
      end
      return ""
    end,
  },
}
