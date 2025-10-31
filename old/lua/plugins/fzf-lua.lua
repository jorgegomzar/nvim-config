return {
  "ibhagwan/fzf-lua",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")
    fzf.setup()

    local TVAV_DEPLOYMENTS_PATH = "/Users/jorgegomez/Documents/REPOS/BMAT/reportal/configs/tvav-deployments/"
    local MONGO_URI_REGEXP = "mongodb://[a-zA-Z0-9./:_-].*"

    vim.api.nvim_create_user_command("TVAVConfigs", function()
        vim.api.nvim_open_win(0, true, { split = "left", win = 0 })
        fzf.files({ cwd = TVAV_DEPLOYMENTS_PATH })
      end,
      {}
    )

    vim.api.nvim_create_user_command("TVAVDBQuery", function()
      -- apply right filetype to current buffer
      vim.api.nvim_cmd({
        cmd = 'set',
        args = { 'ft=js' },
      }, {})

      local cmd = 'rg ' ..
          TVAV_DEPLOYMENTS_PATH ..
          ' --files --glob "*.yaml" --glob "*yml" | xargs rg -o "' ..
          MONGO_URI_REGEXP .. '" | egrep -o "' .. MONGO_URI_REGEXP .. '" | grep "true" | sort | uniq'

      local handle = io.popen(cmd)
      if handle == nil then
        return
      end

      local result = handle:read("*a")
      handle:close()

      if result == nil then
        return
      end

      local mongo_uris = {}
      local db_names = {}

      -- if we recently queried a DB, show first in list
      if vim.w.db_name ~= nil then
        mongo_uris[vim.w.db_name] = vim.w.db
        table.insert(db_names, vim.w.db_name)
      end

      for uri in result:gmatch("[^\r\n]+") do
        local db_name = string.match(uri, ".*/(.*)?.*")
        if mongo_uris[db_name] == nil then
          -- this is to avoid adding read only user for av_raw
          if string.match(uri, "av_raw_ro") then
            goto continue
          end

          mongo_uris[db_name] = uri:gsub('"', '')
          table.insert(db_names, db_name)

          ::continue::
        end
      end

      -- Use fzf-lua to show the list of MongoDB URIs
      fzf.fzf_exec(db_names, {
        prompt = 'Select MongoDB: ',
        actions = {
          ['default'] = function(selected_db)
            local selected_mongo_uri = mongo_uris[selected_db[1]]
            -- Open a Dadbod connection for the selected URI
            -- vim.notify(selected_mongo_uri)
            vim.w.db_name = selected_db[1]
            vim.w.db = selected_mongo_uri

            local ok, res = pcall(vim.cmd, ":%DB")

            if not ok then
              vim.notify(res)
            end
          end
        }
      })
    end, { desc = 'Find and connect to a MongoDB URI using fzf-lua and dadbod' })
  end
}
