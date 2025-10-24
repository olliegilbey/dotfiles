-- LSP Configuration for your language stack
return {
  -- Mason - LSP installer
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- Language servers
        "rust-analyzer",
        "gopls", 
        "typescript-language-server",
        "pyright",
        "bash-language-server",
        "lua-language-server",
        "json-lsp",
        "yaml-language-server",
        
        -- Formatters
        "stylua",
        "shfmt",
        "prettier",
        "ruff",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      -- Only check/install missing tools, don't refresh registry on every startup
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      
      -- Defer the check to avoid blocking startup
      vim.defer_fn(function()
        if mr.refresh then
          mr.refresh(ensure_installed)
        else
          ensure_installed()
        end
      end, 100)
    end,
  },

  -- Mason LSP Config
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "rust_analyzer",
        "gopls",
        "ts_ls", 
        "pyright",
        "bashls",
        "lua_ls",
        "jsonls",
        "yamlls",
      },
    },
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      -- Setup diagnostics
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = true,
      })

      -- Setup capabilities (LazyVim uses blink.cmp, not nvim-cmp)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- LazyVim will handle completion capabilities automatically

      -- Setup language servers
      local lspconfig = require("lspconfig")
      
      -- Rust
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      })

      -- Go  
      lspconfig.gopls.setup({
        capabilities = capabilities,
      })

      -- TypeScript
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })

      -- Python
      lspconfig.pyright.setup({
        capabilities = capabilities,
      })

      -- Bash
      lspconfig.bashls.setup({
        capabilities = capabilities,
      })

      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      -- JSON
      lspconfig.jsonls.setup({
        capabilities = capabilities,
      })

      -- YAML
      lspconfig.yamlls.setup({
        capabilities = capabilities,
      })

      -- Note: All LSP keymaps are now in lua/config/keymaps/lsp.lua
    end,
  },
}