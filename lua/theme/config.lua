-- Appearance settings for the local colorscheme.
return {
  transparent = false,
  dim_inactive = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    sidebars = "dark", -- dark, normal, or transparent
    floats = "dark", -- dark, normal, or transparent
  },
  highlights = {
    -- Direct overrides, for example:
    -- Comment = { fg = "#bda7c8", italic = false },
  },
}
