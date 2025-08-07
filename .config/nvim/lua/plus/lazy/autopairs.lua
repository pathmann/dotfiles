return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",

  opts = {

  },

  config = function(_, opts) 
    local plug = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")

    plug.setup(opts)

    plug.get_rules("{")[1].not_filetypes = { "jinja" }
    -- with_pair: avoid appending more end tags when typing between start and end, only when '}' is typed,
    -- but I don't know how to get only_cr to work
    plug.add_rule(Rule("{%%%- if.- %-%%}", "{%- endif -%}", "jinja"):use_regex(true)
    :with_pair(function(fopts)
      return fopts.char == "}"
    end))
    plug.add_rule(Rule("{%% if.- %%}", "{% endif %}", "jinja"):use_regex(true)
    :with_pair(function(fopts)
      return fopts.char == "}"
    end))
    plug.add_rule(Rule("{%%%- for.- %-%%}", "{%- endfor -%}", "jinja"):use_regex(true)
    :with_pair(function(fopts)
      return fopts.char == "}"
    end))
    plug.add_rule(Rule("{%% for.- %%}", "{% endfor %}", "jinja"):use_regex(true)
    :with_pair(function(fopts)
      return fopts.char == "}"
    end))
  end
}
