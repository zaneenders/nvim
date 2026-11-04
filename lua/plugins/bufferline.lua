local function close_buffer(bufnr)
  Snacks.bufdelete(bufnr)
end

return {
  "akinsho/bufferline.nvim",
  lazy = false,
  dependencies = { "nvim-mini/mini.icons" },
  opts = {
    options = {
      mode = "buffers",
      always_show_bufferline = true,
      separator_style = "thin",
      sort_by = "id",
      close_command = close_buffer,
      right_mouse_command = close_buffer,
      show_close_icon = false,
      get_element_icon = function(element)
        local icon, hl = require("mini.icons").get("file", element.path)
        return icon, hl
      end,
    },
  },
}
