-- lua/kickstart/plugins/init.lua
-- Config file for kickstart plugins


local autoformat = require('kickstart.plugins.autoformat')
local debug = require('kickstart.plugins.debug')

return {
    autoformat,
    debug,
    -- any other plugin configurations
}
