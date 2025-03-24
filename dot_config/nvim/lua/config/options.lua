local opt = vim.opt

opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.termguicolors = true
opt.updatetime = 300
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.cursorline = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.splitright = true
opt.splitbelow = true
