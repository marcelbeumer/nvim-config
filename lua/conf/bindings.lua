local M = {}

M.config = {
  base = {
    toggle_line_numbers = {
      desc = "Toggle line number",
      nmap = "<leader>n",
    },
    open_bottom_panel = {
      desc = 'Open window on bottom ("panel size")',
      nmap = "<leader>0",
    },
    open_new_vsplit = {
      desc = "Open new file in vsplit",
      nmap = "<C-w>N",
    },
    quickfix_next = {
      desc = "Next quickfix",
      nmap = "]q",
    },
    quickfix_prev = {
      desc = "Prev quickfix",
      nmap = "[q",
    },
    loclist_next = {
      desc = "Next loclist",
      nmap = "]l",
    },
    loclist_prev = {
      desc = "Prev loclist",
      nmap = "[l",
    },
    tab_next = {
      desc = "Next tab",
      nmap = "]t",
    },
    tab_prev = {
      desc = "Prev tab",
      nmap = "[t",
    },
    tab_add = {
      desc = "Add tab",
      nmap = "<leader>ta",
    },
    tab_close = {
      desc = "Close tab",
      nmap = "<leader>tc",
    },
    buf_next = {
      desc = "Next buffer",
      nmap = "]b",
    },
    buf_prev = {
      desc = "Prev buffer",
      nmap = "[b",
    },
  },

  tree = {
    toggle = {
      desc = "Tree toggle",
      nmap = "<leader>;",
    },
    find_file = {
      desc = "Tree find file",
      nmap = "<leader>'",
    },
    toggle_float = {
      desc = "Tree togle float mode",
      cmd = "NvimTreeToggleFloat",
    },
    prev_diag = {
      desc = "Tree prev diag item",
      value = "[d",
    },
    next_diag = {
      desc = "Tree next diag item",
      value = "]d",
    },
  },

  symbols_outline = {
    toggle = {
      desc = "Symbols outline toggle",
      nmap = "<leader>/",
    },
  },

  harpoon = {
    next = {
      desc = "Harpoon next",
      cmd = "HarpoonNext",
      nmap = "<C-.>",
    },
    prev = {
      desc = "Harpoon prev",
      cmd = "HarpoonPrev",
      nmap = "<C-,>",
    },
    quick_menu = {
      desc = "Harpoon quick menu",
      cmd = "HarpoonQuickmenu",
      nmap = "<leader>p",
    },
    add = {
      desc = "Harpoon add file",
      cmd = "HarpoonAdd",
      nmap = "<leader>a",
    },
    remove = {
      desc = "Harpoon remove file",
      cmd = "HarpoonRemove",
      nmap = "<leader>d",
    },
    -- TODO: dynamic / range
    -- goto_term = {
    --   desc = "Harpoon goto terminal <num>",
    --   cmd = "HarpoonDelete",
    -- },
  },

  cmp = {
    open = {
      desc = "Open cmp autocomplete menu",
      value = "<C-Space>",
    },
    abort = {
      desc = "Abort cmp autocomplete",
      value = "<C-e>",
    },
    confirm = {
      desc = "Confirm cmp selection",
      value = "<CR>",
    },
  },

  hop_motion = {
    forward = {
      desc = "Hop motion forward",
      nmap = "s",
    },
    backward = {
      desc = "Hop motion backwards",
      nmap = "S",
    },
  },

  git = {
    open_lazygit = {
      desc = "Open lazygit",
      nmap = "<leader>L",
    },
    next_hunk = {
      desc = "Git next hunk",
      nmap = "]g",
    },
    prev_hunk = {
      desc = "Git prev hunk",
      nmap = "[g",
    },
    select_hunk = {
      desc = "Git select hunk",
      omap = "xih",
      xmap = "xih",
    },
    preview_hunk = {
      desc = "Git preview hunk",
      nmap = "<space>gp",
    },
    stage_hunk = {
      desc = "Git stage hunk",
      nmap = "<space>gs",
      vmap = "<space>gs",
    },
    unstage_hunk = {
      desc = "Git unstage hunk",
      nmap = "<space>gu",
      vmap = "<space>gu",
    },
    reset_hunk = {
      desc = "Git reset hunk",
      nmap = "<space>gr",
      vmap = "<space>gr",
    },
    reset_buffer = {
      desc = "Git reset buffer",
      nmap = "<space>gR",
    },
    blame_line = {
      desc = "Git line blame (preview)",
      cmd = "GitBlameLine",
    },
    toggle_line_blame = {
      desc = "Git toggle line blame (virtual text)",
      cmd = "GitToggleLineBlame",
    },
    toggle_show_deleted = {
      desc = "Git toggle show deleted lines",
      cmd = "GitToggleShowDeleted",
    },
    diffthis = {
      desc = "Git diffthis",
      cmd = "GitDiffthis",
    },
    diffthis_prev = {
      desc = "Git diffthis with prev commit (~)",
      cmd = "GitDiffthisPrev",
    },
  },

  diag = {
    toggle_signs = {
      desc = "Toggle diagnostic signs",
      cmd = "DiagToggleSigns",
    },
    show_line = {
      desc = "Show diagnostic on line",
      cmd = "DiagShowLine",
      nmap = "<space>d",
    },
    toggle_virtual_lines = {
      desc = "Toggle diagnostic on virtual",
      cmd = "DiagToggleVirtualLines",
    },
    toggle_virtual_lines_current_only = {
      desc = "Toggle LSP diag lines (current line)",
      cmd = "DiagToggleVirtualLinesCurrent",
    },
    set_loclist = {
      desc = "Set diagnostics to location list",
      cmd = "DiagSetLoclist",
    },
    next = {
      desc = "Next diagnostic",
      nmap = "]d",
    },
    prev = {
      desc = "Prev diagnostic",
      nmap = "[d",
    },
  },

  layout = {
    save = {
      desc = "Save layout",
      nmap = "<C-W>.",
    },
    restore = {
      desc = "Restore layout",
      nmap = "<C-W>,",
    },
  },

  find = {
    files = {
      desc = "Find files",
      cmd = "FindFiles",
      nmap = "<leader>f",
    },
    buffers = {
      desc = "Find buffers",
      cmd = "FindBuffers",
      nmap = "<leader>b",
    },
    quickfix = {
      desc = "Find in quickfix",
      cmd = "FindQuickfix",
      nmap = "<leader>q",
    },
    loclist = {
      desc = "Find in loclist",
      cmd = "FindLoclist",
      nmap = "<leader>Q",
    },
    projects = {
      desc = "Find projects",
      cmd = "FindProjects",
      nmap = "<leader>P",
    },
    commands = {
      desc = "cmd",
      cmd = "FindCommands",
      nmap = "<leader>c",
    },
    ripgrep = {
      desc = "Find with ripgrep",
      cmd = "FindRipgrep",
      nmap = "<leader>g",
    },
    ripgrep_buffer = {
      desc = "Find with ripgrep (buffer only)",
      cmd = "FindRipgrepBuffer",
      nmap = "<leader>G",
    },
    help = {
      desc = "Find help",
      cmd = "FindHelp",
    },
    diag = {
      desck = "Find in diagnostics workspace",
      cmd = "FindDiag",
      nmap = "<leader>lq",
    },
    diag_buffer = {
      desc = "Find in diagnostics (buffer)",
      cmd = "FindDiagBuffer",
      nmap = "<leader>lQ",
    },
    lsp_references = {
      desc = "Find in LSP references",
      cmd = "FindLSPReference",
      nmap = "<leader>lr",
    },
    lsp_implementations = {
      desc = "Find in LSP implementations",
      cmd = "FindLspImplementations",
      nmap = "<leader>li",
    },
    lsp_definitions = {
      desc = "Find in LSP definitions",
      cmd = "FindLspDefinitions",
      nmap = "<leader>ld",
    },
    lsp_declarations = {
      desc = "Find in LSP declarations",
      cmd = "FindLspDeclarations",
      nmap = "<leader>lD",
    },
    lsp_typedefs = {
      desc = "Find in LSP typedefs",
      cmd = "FindLspDeclarations",
      nmap = "<leader>lt",
    },
    lsp_symbols = {
      desc = "Find in LSP symbols",
      cmd = "FindLSPSymbols",
    },
    lsp_symbols_buffer = {
      desc = "Find in LSP symbols",
      cmd = "FindLSPSymbolsBuffer",
    },
  },

  lsp = {
    next_reference = {
      desc = "KSP next reference",
      nmap = "]r",
    },
    prev_reference = {
      desc = "LSP prev reference",
      nmap = "[r",
    },
    goto_definition = {
      desc = "LSP goto definition",
      nmap = "gd",
    },
    goto_declaration = {
      desc = "LSP goto declaration",
      nmap = "gD",
    },
    goto_references = {
      desc = "LSP goto references",
      nmap = "gr",
    },
    goto_implementation = {
      desc = "LSP goto implementation",
      nmap = "gi",
    },
    hover = {
      desc = "LSP hover",
      nmap = "K",
    },
    rename = {
      desc = "LSP rename",
      nmap = "<space>r",
    },
    code_actions = {
      desc = "LSP code actions",
      nmap = "<space>a",
    },
    format = {
      desc = "LSP format",
      nmap = "<space>f",
    },
    signature_help = {
      desc = "LSP signature help",
      nmap = "<C-k>",
      imap = "<C-y>",
    },
    add_workspace_folder = {
      desc = "LSP add workspace folder",
      cmd = "LSPAddWorkspaceFolder",
    },
    remove_workspace_folder = {
      desc = "LSP remove workspace folder",
      cmd = "LSPRemoveWorkspaceFolder",
    },
    list_workspace_folders = {
      desc = "LSP list workspace folders",
      cmd = "LSPListWorkspaceFolders",
    },
  },

  lsp_lines = {
    toggle = {
      desc = "Toggle LSP diag lines",
      cmd = "LSPLinesToggle",
    },
    toggle_current_line = {
      desc = "Toggle LSP diag lines (current line)",
      cmd = "LSPLinesToggleLine",
    },
  },

  dap = {
    launch_lua_edit = {
      desc = "DAP edit launch.lua",
      cmd = "DAPLaunchLua",
    },
    ui_toggle_all = {
      desc = "DAP UI toggle",
      cmd = "DAPUIToggle",
      nmap = "<leader><leader>u",
    },
    ui_toggle_sidebar = {
      desc = "DAP UI toggle sidebar",
      cmd = "DAPUIToggleSidebar",
    },
    ui_toggle_tray = {
      desc = "DAP UI toggle tray",
      cmd = "DAPUIToggleTray",
    },
    continue = {
      desc = "DAP continue/run",
      nmap = "<leader><leader>r",
    },
    terminate = {
      desc = "DAP terminate",
      nmap = "<leader><leader>x",
    },
    step_over = {
      desc = "DAP step over",
      nmap = "<leader><leader>l",
    },
    step_into = {
      desc = "DAP step into",
      nmap = "<leader><leader>j",
    },
    step_out = {
      desc = "DAP step out",
      nmap = "<leader><leader>k",
    },
    toggle_breakpoint = {
      desc = "DAP toggle breakpoint",
      nmap = "<leader><leader>b",
    },
    breakpoint_condition = {
      desc = "DAP set breakpoint condition",
      nmap = "<leader><leader>B",
    },
    breakpoint_log = {
      desc = "DAP set breakpoint log point",
      nmap = "<leader><leader>L",
    },
    clear_breakpoints = {
      desc = "DAP clear all breakpoints",
      cmd = "DAPClearBreakpoints",
    },
    repl_toggle = {
      desc = "DAP toggle REPL",
      nmap = "<leader><leader>e",
    },
    run_last = {
      desc = "DAP run last",
      nmap = "<leader><leader>R",
    },
  },
}

local maps = { nmap = "n", imap = "i", vmap = "v", omap = "o", xmap = "x" }

local get_config = function(lookup)
  local config = M.config
  for k, _ in string.gmatch(lookup .. ".", "(%S-)(%.)") do
    config = config[k]
    if not config then
      error('bindings: key "' .. k .. '" not found in "' .. lookup .. '"')
    end
  end
  return config
end

local get_ext_opts = function(config, opts)
  return vim.tbl_extend("keep", { desc = config.desc }, opts)
end

M.bind_keys = function(lookup, rhs, opts)
  local config = get_config(lookup)
  for mode, mode_short in pairs(maps) do
    if config and config[mode] then
      local ext_opts = get_ext_opts(config, opts)
      vim.keymap.set(mode_short, config[mode], rhs, ext_opts)
    end
  end
end

M.bind_cmd = function(lookup, rhs, opts)
  local config = get_config(lookup)
  if config and config.cmd then
    local ext_opts = get_ext_opts(config, opts)
    vim.api.nvim_create_user_command(config.cmd, rhs, ext_opts)
  end
end

M.bind_all = function(lookup, rhs, cmd_opts, key_opts)
  M.bind_cmd(lookup, rhs, cmd_opts)
  M.bind_keys(lookup, rhs, key_opts)
end

M.setup = function()
  vim.api.nvim_create_user_command("Bindings", function()
    local filepath = debug.getinfo(1, "S").source:sub(2)
    vim.cmd.edit(filepath)
  end, {})
end

return M
