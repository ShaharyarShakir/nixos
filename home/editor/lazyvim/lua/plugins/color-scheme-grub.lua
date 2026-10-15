return {
  "f4z3r/gruvbox-material.nvim",
  name = "gruvbox-material",
  lazy = false,
  enable = true,
  priority = 1000,
  config = function()
    -- Transparent background settings
    vim.g.gruvbox_material_background = "medium"
    vim.g.gruvbox_material_transparent_background = 1
    vim.g.gruvbox_material_enable_italic = 1

    -- Apply colorscheme
--    vim.cmd("colorscheme gruvbox-material")

    -- Extra transparency highlights
    vim.cmd([[
      hi Normal guibg=NONE ctermbg=NONE
      hi NormalNC guibg=NONE ctermbg=NONE
      hi EndOfBuffer guibg=NONE ctermbg=NONE
      hi LineNr guibg=NONE ctermbg=NONE
      hi SignColumn guibg=NONE ctermbg=NONE
    ]])
  end,
}
