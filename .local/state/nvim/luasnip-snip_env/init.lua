---@meta

-- Define a snippet with a trigger, nodes, and optional options table.
---@type fun(context: table | string, nodes: node | node[], opts?: table): table
s = require("luasnip.nodes.snippet").S

-- Define a snippet node (used inside dynamic snippets or snippet construction).
---@type fun(pos: integer, nodes: node[] | node, opts?: table): table
sn = require("luasnip.nodes.snippet").SN

-- Indent-sensitive snippet node; keeps indentation from surrounding context.
---@type fun(pos: integer, nodes: node[] | node, opts?: table): table
isn = require("luasnip.nodes.snippet").ISN

-- Static text node — outputs fixed strings in snippet expansions.
---@type fun(text: string | string[]): table
t = require("luasnip.nodes.textNode").T

-- Insert node — represents a cursor placeholder (jumpable position).
---@type fun(pos: integer, placeholder?: string | string[]): table
i = require("luasnip.nodes.insertNode").I

-- Function node — generates dynamic text using a Lua function at runtime.
---@type fun(pos: integer, fn: fun(args: table, parent: table, user_args: any): string | string[], args: any[], user_args?: any): table
f = require("luasnip.nodes.functionNode").F

-- Choice node — lets the user cycle through multiple options at the same cursor position.
---@type fun(pos: integer, choices: table[], opts?: table): table
c = require("luasnip.nodes.choiceNode").C

-- Dynamic node — regenerates its content dynamically based on input.
---@type fun(pos: integer, generator: fun(args: table, parent: table, old_state: table): table, args: any[], opts?: table): table
d = require("luasnip.nodes.dynamicNode").D

-- Restore node — used to preserve input when re-expanding snippets.
---@type fun(pos: integer, key: string): table
r = require("luasnip.nodes.restoreNode").R

-- Event constants used for keymaps, snippet state, etc.
---@type table
events = require("luasnip.util.events")

-- Key indexer for dynamic keys in choice nodes, etc.
---@type fun(key: string): any
k = require("luasnip.nodes.key_indexer").new_key

-- Indexing utility for absolute node references.
---@type table
ai = require("luasnip.nodes.absolute_indexer")

-- Table of additional helper functions and nodes.
---@type table
extras = require("luasnip.extras")

-- Lambda expression support for short, inline dynamic content.
---@type fun(expr: string, capture_map?: table): any
l = require("luasnip.extras").lambda

-- Repeats a previous node's content.
---@type fun(node_index: integer): any
rep = require("luasnip.extras").rep

-- Partially expand a string from a Lua function.
---@type fun(fn: fun(...): string, ...): any
p = require("luasnip.extras").partial

-- Pattern matcher for dynamic generation based on regex-like input.
---@type fun(regex: string, match_fn: fun(match: string[]): string): any
m = require("luasnip.extras").match

-- Only expands if the captured node is non-empty.
---@type fun(node_index: integer): boolean
n = require("luasnip.extras").nonempty

-- Dynamic lambda: like `lambda` but more flexible for generating nested content.
---@type fun(expr: string, capture_map: table): any
dl = require("luasnip.extras").dynamic_lambda

-- Format helper — allows you to write snippets using a printf-like format syntax.
---@type fun(fmt_string: string, nodes: table, opts?: table): table
fmt = require("luasnip.extras.fmt").fmt

-- Like `fmt`, but uses angle brackets (`<...>`) for placeholders.
---@type fun(fmt_string: string, nodes: table, opts?: table): table
fmta = require("luasnip.extras.fmt").fmta

-- Expansion conditions — functions that return whether a snippet should expand.
---@type table
conds = require("luasnip.extras.expand_conditions")

-- Postfix snippet helper — expands snippets based on suffix of a word (e.g., `.log`).
---@type fun(trigger: string, generator: function): any
postfix = require("luasnip.extras.postfix").postfix

-- Constants for snippet types and events.
---@type table
types = require("luasnip.util.types")

-- Parser for raw snippet definitions (e.g., from strings).
---@type fun(trigger: string, body: string | string[], opts?: table): any
parse = require("luasnip.util.parser").parse_snippet

-- Multi-snippet constructor — can define multiple versions under the same trigger.
---@type fun(trigger: string, snippets: table[]): any
ms = require("luasnip.nodes.multiSnippet").new_multisnippet
