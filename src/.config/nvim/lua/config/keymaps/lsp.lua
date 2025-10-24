-- LSP Keymaps - Unified Code Intelligence
-- All LSP operations configured on attach

local keymap = vim.keymap.set

-- These keymaps are set when LSP attaches to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf }

    -- ============================================================================
    -- NAVIGATION (g prefix - vim goto semantics)
    -- ============================================================================

    keymap("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
    keymap("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
    keymap("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Go to references" })
    keymap("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Go to implementation" })
    keymap("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "Type definition" })

    -- ============================================================================
    -- DOCUMENTATION (K for hover)
    -- ============================================================================

    keymap("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover documentation" })

    -- Signature help (NOT on <C-k> - that's for window navigation)
    keymap("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature help" })

    -- ============================================================================
    -- CODE ACTIONS & REFACTORING (<leader>c group)
    -- ============================================================================

    keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code actions" })
    keymap("n", "<leader>cr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename symbol" })

    -- Format (unified with Conform)
    keymap("n", "<leader>cf", function()
      -- Try Conform first, fallback to LSP
      local conform = require("conform")
      if conform.format({ timeout_ms = 500, lsp_format = "fallback" }) then
        return
      end
      vim.lsp.buf.format({ async = true })
    end, { buffer = ev.buf, desc = "Format code" })

    keymap("n", "<leader>ci", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Implementation" })
    keymap("n", "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", { buffer = ev.buf, desc = "Document symbols" })
    keymap("n", "<leader>cS", "<cmd>Telescope lsp_workspace_symbols<cr>", { buffer = ev.buf, desc = "Workspace symbols" })
    keymap("n", "<leader>cd", vim.diagnostic.open_float, { buffer = ev.buf, desc = "Show diagnostics" })

    -- Legacy compatibility
    keymap("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename (legacy)" })

    -- ============================================================================
    -- DIAGNOSTICS
    -- ============================================================================

    keymap("n", "<leader>xx", vim.diagnostic.setloclist, { buffer = ev.buf, desc = "Diagnostics to loclist" })
  end,
})
