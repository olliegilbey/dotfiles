-- Language-Specific Keymaps - Context-Aware <leader>l
-- Detects filetype and provides unified interface for language tools

local keymap = vim.keymap.set

-- ============================================================================
-- RUST KEYMAPS (.rs files)
-- ============================================================================

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function(ev)
    local opts = { buffer = ev.buf }

    keymap("n", "<leader>lr", "<cmd>!cargo run<cr>", vim.tbl_extend("force", opts, { desc = "Cargo run" }))
    keymap("n", "<leader>lt", "<cmd>!cargo test<cr>", vim.tbl_extend("force", opts, { desc = "Cargo test" }))
    keymap("n", "<leader>lb", "<cmd>!cargo build<cr>", vim.tbl_extend("force", opts, { desc = "Cargo build" }))
    keymap("n", "<leader>lc", "<cmd>!cargo check<cr>", vim.tbl_extend("force", opts, { desc = "Cargo check" }))
    keymap("n", "<leader>lf", "<cmd>!cargo fmt<cr>", vim.tbl_extend("force", opts, { desc = "Cargo format" }))
    keymap("n", "<leader>ll", "<cmd>!cargo clippy<cr>", vim.tbl_extend("force", opts, { desc = "Cargo clippy" }))
    keymap("n", "<leader>ld", "<cmd>!cargo doc --open<cr>", vim.tbl_extend("force", opts, { desc = "Cargo docs" }))

    -- Which-key group name
    vim.api.nvim_buf_set_var(ev.buf, "which_key_lang_name", "Cargo")
  end,
})

-- ============================================================================
-- PYTHON KEYMAPS (.py files)
-- ============================================================================

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(ev)
    local opts = { buffer = ev.buf }

    keymap("n", "<leader>lr", "<cmd>!uv run python %<cr>", vim.tbl_extend("force", opts, { desc = "Run Python (uv)" }))
    keymap("n", "<leader>lt", "<cmd>!uv run pytest<cr>", vim.tbl_extend("force", opts, { desc = "Run pytest (uv)" }))
    keymap(
      "n",
      "<leader>lf",
      "<cmd>!ruff format % && ruff check --fix %<cr>",
      vim.tbl_extend("force", opts, { desc = "Format with ruff" })
    )
    keymap("n", "<leader>ll", "<cmd>!ruff check %<cr>", vim.tbl_extend("force", opts, { desc = "Lint with ruff" }))
    keymap("n", "<leader>li", "<cmd>!uv sync<cr>", vim.tbl_extend("force", opts, { desc = "Sync deps (uv)" }))
    keymap("n", "<leader>la", "<cmd>!uv add ", vim.tbl_extend("force", opts, { desc = "Add package (uv)" }))
    keymap(
      "n",
      "<leader>lc",
      "<cmd>!ruff check --fix %<cr>",
      vim.tbl_extend("force", opts, { desc = "Check and fix (ruff)" })
    )

    -- Which-key group name
    vim.api.nvim_buf_set_var(ev.buf, "which_key_lang_name", "Python")
  end,
})

-- ============================================================================
-- GO KEYMAPS (.go files)
-- ============================================================================

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function(ev)
    local opts = { buffer = ev.buf }

    keymap("n", "<leader>lr", "<cmd>!go run .<cr>", vim.tbl_extend("force", opts, { desc = "Go run" }))
    keymap("n", "<leader>lt", "<cmd>!go test<cr>", vim.tbl_extend("force", opts, { desc = "Go test" }))
    keymap("n", "<leader>lb", "<cmd>!go build<cr>", vim.tbl_extend("force", opts, { desc = "Go build" }))
    keymap("n", "<leader>lf", "<cmd>!gofmt -w %<cr>", vim.tbl_extend("force", opts, { desc = "Go format" }))
    keymap("n", "<leader>li", "<cmd>!go mod tidy<cr>", vim.tbl_extend("force", opts, { desc = "Go mod tidy" }))

    -- Which-key group name
    vim.api.nvim_buf_set_var(ev.buf, "which_key_lang_name", "Go")
  end,
})

-- ============================================================================
-- JAVASCRIPT/TYPESCRIPT KEYMAPS
-- ============================================================================

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function(ev)
    local opts = { buffer = ev.buf }

    -- Package management (detect bun vs npm)
    local has_bun = vim.fn.executable("bun") == 1
    local pkg_manager = has_bun and "bun" or "npm"

    keymap(
      "n",
      "<leader>lr",
      string.format("<cmd>!%s run dev<cr>", pkg_manager == "bun" and "npm" or "npm"), -- Use npm for Next.js runtime
      vim.tbl_extend("force", opts, { desc = "Run dev server" })
    )
    keymap(
      "n",
      "<leader>lt",
      string.format("<cmd>!%s test<cr>", pkg_manager),
      vim.tbl_extend("force", opts, { desc = "Run tests" })
    )
    keymap(
      "n",
      "<leader>lb",
      string.format("<cmd>!%s run build<cr>", pkg_manager == "bun" and "npm" or "npm"), -- Use npm for Next.js build
      vim.tbl_extend("force", opts, { desc = "Build project" })
    )
    keymap(
      "n",
      "<leader>li",
      string.format("<cmd>!%s install<cr>", pkg_manager),
      vim.tbl_extend("force", opts, { desc = "Install dependencies" })
    )

    -- Which-key group name
    vim.api.nvim_buf_set_var(ev.buf, "which_key_lang_name", has_bun and "Bun/Node" or "Node")
  end,
})
