-- LSP Configuration for your language stack
return {
  -- Mason - LSP installer
  {
    "williamboman/mason.nvim",
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
    "williamboman/mason-lspconfig.nvim",
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
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
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
        on_attach = function(client, bufnr)
          local opts = { buffer = bufnr }
          -- Rust-specific keymaps
          vim.keymap.set("n", "<leader>Cr", "<cmd>!cargo run<cr>", { desc = "Cargo run", buffer = bufnr })
          vim.keymap.set("n", "<leader>Ct", "<cmd>!cargo test<cr>", { desc = "Cargo test", buffer = bufnr })
          vim.keymap.set("n", "<leader>Cb", "<cmd>!cargo build<cr>", { desc = "Cargo build", buffer = bufnr })
          vim.keymap.set("n", "<leader>Cc", "<cmd>!cargo check<cr>", { desc = "Cargo check", buffer = bufnr })
          vim.keymap.set("n", "<leader>Cf", "<cmd>!cargo fmt<cr>", { desc = "Cargo format", buffer = bufnr })
          vim.keymap.set("n", "<leader>Cl", "<cmd>!cargo clippy<cr>", { desc = "Cargo clippy", buffer = bufnr })
          vim.keymap.set("n", "<leader>Cd", "<cmd>!cargo doc --open<cr>", { desc = "Cargo docs", buffer = bufnr })
        end,
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
        on_attach = function(client, bufnr)
          local opts = { buffer = bufnr }
          -- Python-specific keymaps (modernized with uv + ruff)
          vim.keymap.set("n", "<leader>pr", "<cmd>!uv run python %<cr>", { desc = "Run Python file (uv)", buffer = bufnr })
          vim.keymap.set("n", "<leader>pt", "<cmd>!uv run pytest<cr>", { desc = "Run pytest (uv)", buffer = bufnr })
          vim.keymap.set("n", "<leader>pf", "<cmd>!ruff format % && ruff check --fix %<cr>", { desc = "Format with ruff", buffer = bufnr })
          vim.keymap.set("n", "<leader>pl", "<cmd>!ruff check %<cr>", { desc = "Lint with ruff", buffer = bufnr })
          vim.keymap.set("n", "<leader>pi", "<cmd>!uv sync<cr>", { desc = "Sync dependencies (uv)", buffer = bufnr })
          vim.keymap.set("n", "<leader>pa", "<cmd>!uv add ", { desc = "Add package (uv add ...)", buffer = bufnr })
          vim.keymap.set("n", "<leader>pc", "<cmd>!ruff check --fix %<cr>", { desc = "Check and fix with ruff", buffer = bufnr })
        end,
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

      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          -- Navigation
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          
          -- Code actions and refactoring (enhanced <leader>c group)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions", buffer = ev.buf })
          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Code rename", buffer = ev.buf })
          vim.keymap.set("n", "<leader>cf", function()
            vim.lsp.buf.format({ async = true })
          end, { desc = "Code format", buffer = ev.buf })
          vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, { desc = "Code implementation", buffer = ev.buf })
          vim.keymap.set("n", "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Code symbols", buffer = ev.buf })
          vim.keymap.set("n", "<leader>cS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Code workspace symbols", buffer = ev.buf })
          vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Code diagnostics", buffer = ev.buf })
          
          -- Keep legacy mapping for compatibility
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        end,
      })
    end,
  },
}