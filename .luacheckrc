-- .luacheckrc
return {
    globals = {
        -- Neovim
        "vim", "bufnr",
        -- Busted
        "describe", "it", "before_each", "after_each", "teardown", "setup",
        -- LuaJIT
        "jit", "bit", "ffi",
        -- Awesome WM
        "awesome", "client", "root"
    },
    max_line_length = false,
    ignore = {
        -- Ignore unused arguments/variables warnings
        "unused args", "unused var"
    }
}

