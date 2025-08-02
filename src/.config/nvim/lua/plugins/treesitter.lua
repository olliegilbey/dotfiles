-- Treesitter for your language stack
return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        -- Your primary languages
        "rust",
        "go", 
        "gomod",
        "gowork",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "jsonc",
        
        -- Shell scripting (extensive in your dotfiles)
        "bash",
        "fish",
        -- Note: zsh uses bash parser
        
        -- Config files
        "lua",
        "vim",
        "vimdoc",
        "yaml",
        "toml",
        "dockerfile",
        
        -- Web/markup
        "html",
        "css",
        "markdown",
        "markdown_inline",
        
        -- Git
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        
        -- Other useful
        "regex",
        "sql",
        "comment",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ii"] = "@conditional.inner",
            ["ai"] = "@conditional.outer",
            ["il"] = "@loop.inner",
            ["al"] = "@loop.outer",
            ["at"] = "@comment.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      -- Ensure we have the necessary tools for compilation
      if vim.fn.executable("gcc") == 0 and vim.fn.executable("clang") == 0 then
        vim.notify("Warning: No C compiler found. TreeSitter parsers may not compile.", vim.log.levels.WARN)
      end
      
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      
      require("nvim-treesitter.configs").setup(opts)
      
      -- Install parsers after setup
      vim.defer_fn(function()
        vim.cmd("TSUpdate")
      end, 100)
    end,
  },
}