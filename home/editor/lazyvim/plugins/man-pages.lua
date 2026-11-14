---@type LazySpec
return {
  "neovim/nvim-lspconfig",
  keys = {
    {
      "<leader>m",
      function()
        local word = vim.fn.expand("<cword>")
        if word == "" then
          vim.notify("No word under cursor", vim.log.levels.WARN)
          return
        end

        local pages, seen = {}, {}
        local function add(name, section, description)
          local key = name .. "(" .. section .. ")"
          if not seen[key] then
            seen[key] = true
            table.insert(pages, {
              name = name,
              section = section,
              description = description or "",
            })
          end
        end

        -- 1) Keyword search via the whatis index (may be incomplete on NixOS).
        for _, line in ipairs(vim.fn.systemlist({ "man", "-k", word })) do
          local name, section, desc = line:match("^(%S+)%s*%(([^%)]+)%)%s*%-?%s*(.*)$")
          if name and section then
            add(name, section, desc)
          end
        end

        -- 2) Fallback: exact-name lookup straight from the page files.
        for _, path in ipairs(vim.fn.systemlist({ "man", "-wa", word })) do
          local file = vim.fn.fnamemodify(path, ":t")
          file = file:gsub("%.gz$", ""):gsub("%.bz2$", ""):gsub("%.xz$", ""):gsub("%.zst$", "")
          local name, section = file:match("^(.+)%.([^.]+)$")
          if name and section then
            add(name, section)
          end
        end

        if #pages == 0 then
          vim.notify("No man pages found for: " .. word, vim.log.levels.WARN)
          return
        end

        vim.ui.select(pages, {
          prompt = "Man pages for " .. word,
          format_item = function(item)
            return string.format("%-24s (%s)  %s", item.name, item.section, item.description)
          end,
        }, function(choice)
          if not choice then
            return
          end
          -- Create the bottom split first, then load the page into it.
          vim.cmd(("botright %dsplit"):format(math.floor(vim.o.lines * 0.45)))
          vim.cmd(("Man %s(%s)"):format(choice.name, choice.section))
        end)
      end,
      desc = "Search and open man pages",
    },
  },
}
