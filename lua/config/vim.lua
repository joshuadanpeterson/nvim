-- vim.lua
-- create a mock vim global to bypass the error:

if not _G.vim then
    _G.vim = {
        -- Mock functions and properties as needed
        inspect = function(...) return ... end,
        api = {
            nvim_buf_get_lines = function() return {} end,
            nvim_set_var = function() end,
            -- Add more API functions as needed
        },
        -- Continue with other `vim` sub-tables and functions as necessary
    }
end
