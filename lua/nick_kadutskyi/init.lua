local fzf = require("fzf-lua")
local nnoremap = require("nick_kadutskyi.keymap").nnoremap
local conform = require("conform")

-- If opened a dir set it as current dir to help narrow down fzf scope
if vim.fn.isdirectory(vim.fn.expand("%")) == 1 then
  vim.api.nvim_set_current_dir(vim.fn.expand("%"))
elseif vim.fn.filereadable(vim.fn.expand("%")) == 1 then
  vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
end


-- NEOVIM SPECIFIC SETTINGS (keep as much as possible in .vimrc)

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Remove cmd line to allow more space
vim.opt.cmdheight = 0

-- make zsh files recognized as sh for bash-ls & treesitter because there is no parser for zsh
vim.filetype.add({
  extension = {
    zsh = "sh",
    sh = "sh", -- force sh-files with zsh-shebang to still get sh as filetype
  },
  filename = {
    [".zshrc"] = "sh",
    [".zshenv"] = "sh",
    [".zpath"] = "sh",
    [".zprofile"] = "sh",
  },
})


-- NEOVIM SPECIFIC MAPPINGS (keep as much as possible in .vimrc)

-- Fzf-lua
-- Go to file
nnoremap("<leader>gf", fzf.files, {})
-- Go to Class
nnoremap("<leader>gc", fzf.lsp_live_workspace_symbols, {})
-- Go to Symbol (same as class)
nnoremap("<leader>gs", fzf.lsp_live_workspace_symbols, {})
-- Find in path
nnoremap("<leader>fp", fzf.live_grep, {})
-- Go to buffer (Similar to Switcher in Intellij)
nnoremap("<leader>gb", fzf.buffers, {})

-- Formatting
-- Reformat code with Conform.nvim which might fallback to LSP
nnoremap("<leader>cf", function() conform.format({ lsp_fallback = true }) end)
-- Reformat code with LSP
nnoremap("<leader>clf", vim.lsp.buf.format)

-- Vim Fuigitive
-- Git Satus
-- nnoremap("<leader>gs", ":Git<CR>")


-- Diagnostics Trouble  plugin
-- Open Problems window
nnoremap("<leader>xx", ":TroubleToggle document_diagnostics<CR>")
-- Quick Fix
nnoremap("<leader>xq", ":TroubleToggle quickfix<CR>")

nnoremap("<leader>xx", function() require("trouble").toggle() end)
nnoremap("<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
nnoremap("<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
nnoremap("<leader>xq", function() require("trouble").toggle("quickfix") end)
nnoremap("<leader>xl", function() require("trouble").toggle("loclist") end)
nnoremap("gR", function() require("trouble").toggle("lsp_references") end)
nnoremap("gd", function() require("trouble").toggle("lsp_definitions") end)
nnoremap("gi", function() require("trouble").toggle("lsp_implementations") end)

-- Diagnostics builtin
nnoremap('[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
nnoremap(']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
nnoremap('<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
nnoremap('<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })


-- Treesitter Inspect builtin
nnoremap("<leader>ti", ":Inspect<CR>")
nnoremap("<leader>tti", ":InspectTree<CR>")


-- Obsidian
nnoremap("fl", function()
  if require("obsidian").util.cursor_on_markdown_link() then
    return "<cmd>ObsidianFollowLink<CR>"
  else
    return "fl"
  end
end, { noremap = false, expr = true })


-- FEATUERS

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
