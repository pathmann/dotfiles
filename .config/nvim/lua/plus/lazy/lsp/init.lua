local Utils = require("plus.lazy.lsp.utils")

local function configure_servers()
  local mods = Utils.server_modules()
  for _, m in ipairs(mods) do
    local serv_mod = require(m)

    vim.lsp.enable(serv_mod.name)
    if serv_mod.setup ~= nil then
      serv_mod.setup()
    else
      vim.lsp.config(serv_mod.name, serv_mod.opts)
    end
  end
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "ray-x/lsp_signature.nvim",
        "L3MON4D3/LuaSnip",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        vim.lsp.inlay_hint.enable(true)

        vim.lsp.config("*", {
          capabilities = capabilities,
        })

        configure_servers()

        require("plus.lazy.lsp.autocommand").create()

        local is_server = require("plus.utils").is_server()
        local servmods = Utils.server_modules()

        local lsplist = {}
        for _, modname in ipairs(servmods) do
          local servmod = require(modname)

          if servmod.ensure_installed ~= nil then
            if servmod.on_server or not is_server then
              table.insert(lsplist, servmod.name)
            end
          end
        end

        require("mason").setup()
        require("mason-lspconfig").setup({
          automatic_enable = false,
          ensure_installed = lsplist,
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        local luasnip = require("luasnip")

        cmp.setup({
          preselect = cmp.PreselectMode.Item,
          completion = {
            completeopt = 'menu,menuone,noinsert',
            autocomplete = false, -- disable automatically popping up when typing
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<cr>'] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          },
          {
            { name = 'buffer' },
          }),
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body)
            end,
          },
        })

        cmp.setup.filetype({ "sql" }, {
          sources = {
            { name = "vim-dadbod-completion" },
            { name = "buffer" },
          }
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
        
        -- vim.lsp.set_log_level("debug")

        vim.api.nvim_set_hl(0, "LspReferenceText", { fg = "#000000", bg = "#FFD700", bold = true })    -- Black text on bright gold
        vim.api.nvim_set_hl(0, "LspReferenceRead", { fg = "#FFFFFF", bg = "#00BFFF", underline = true })  -- White text on deep sky blue
        vim.api.nvim_set_hl(0, "LspReferenceWrite", { fg = "#FFFFFF", bg = "#FF4500", bold = true })  -- White text on strong orange-red

    end
}
