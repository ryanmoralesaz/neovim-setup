return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    -- Setup Mason
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "ts_ls",
        "eslint",
        "html",
        "cssls",
        "emmet_ls",
      },
      automatic_installation = true,
    })

    -- Setup completion
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      },
    })

    -- LSP capabilities
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Common on_attach function for keymaps
    local on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, silent = true }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    end

    -- Configure TypeScript/JavaScript server
    vim.lsp.config.ts_ls = {
      default_config = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
      },
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayFunctionParameterTypeHints = true,
          },
        },
      },
    }

    -- Configure ESLint (LINTING ONLY - no auto-fix on save)
    vim.lsp.config.eslint = {
      default_config = {
        cmd = { "vscode-eslint-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { ".eslintrc.js", ".eslintrc.json", "eslint.config.js" },
      },
      capabilities = capabilities,
      on_attach = on_attach, -- Just use the regular on_attach, removed the EslintFixAll autocmd
    }

    -- Configure HTML
    vim.lsp.config.html = {
      default_config = {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html", "ejs" },
      },
      capabilities = capabilities,
      on_attach = on_attach,
    }

    -- Configure CSS
    vim.lsp.config.cssls = {
      default_config = {
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
      },
      capabilities = capabilities,
      on_attach = on_attach,
    }

    -- Configure Emmet
    vim.lsp.config.emmet_ls = {
      default_config = {
        cmd = { "emmet-ls", "--stdio" },
        filetypes = { "html", "css", "javascriptreact", "typescriptreact", "ejs" },
      },
      capabilities = capabilities,
      on_attach = on_attach,
    }

    -- Enable the LSP servers
    vim.lsp.enable("ts_ls")
    vim.lsp.enable("eslint")
    vim.lsp.enable("html")
    vim.lsp.enable("cssls")
    vim.lsp.enable("emmet_ls")

    -- Diagnostic configuration
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- Diagnostic signs
    local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  end,
}
