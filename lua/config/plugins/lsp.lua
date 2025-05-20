return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        ft = "lua", --only load on lua files
        opts = {
          library = {
            -- See the configurations section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Loads lspconfigs' configuration for the languages listed and
      -- passes a table of configuration options
      require("lspconfig").lua_ls.setup { capabilities = capabilities }
      require("lspconfig").gopls.setup {
        capabilities = capabilities,
        settings = {
          gopls = {
            staticcheck = true,
          },
        },
      }
      require("lspconfig").templ.setup({
        cmd = { "templ", "lsp" },
        filetypes = { "templ" },
        root_dir = require("lspconfig.util").root_pattern("go.mod", ".git"),
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          vim.cmd("silent !golangci-lint run %")
        end
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.templ",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end
      })

      -- Enable inline diagnostics
      vim.diagnostic.config({
        virtual_text = true,      -- Show errors inline
        signs = true,             -- Show signs in the number line
        underline = true,         -- Underline errors
        update_in_insert = false, -- Don't update diagnostics while typing
        severity_sort = true,     -- Sort diagnostics by severity
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          ---@diagnostic disable-next-line: missing-parameter
          if client.supports_method('textDocument/formatting') then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })
    end,
  }
}
