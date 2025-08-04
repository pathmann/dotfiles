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
    plug.add_rule(Rule("{%- if -%}", "{%- endif -%}", "jinja"))
    plug.add_rule(Rule("{% if %}", "{% endif %}", "jinja"))
    plug.add_rule(Rule("{%- for -%}", "{%- endfor -%}", "jinja"))
    plug.add_rule(Rule("{% for %}", "{% endfor %}", "jinja"))
  end
}
