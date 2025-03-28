local o = vim.o

o.fileencoding = "utf-8"
o.showmode = false
o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
o.number = true
o.relativenumber = true
o.mouse = "a"
o.termguicolors = true
o.updatetime = 300
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.cursorline = true
o.signcolumn = "yes:2"
o.timeoutlen = 200

o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

o.splitright = true
o.splitbelow = true
