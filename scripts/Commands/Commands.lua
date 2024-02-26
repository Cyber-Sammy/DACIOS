-- modules
local commands_path = "commands/implementation/?.lua"

package.path = package.path .. ";" .. commands_path
-- end modules

local A = { } 

-- commands import
local _time = require "Time"
local _sum = require "Sum"
local _id = require "Id"
local _com = require "Com"
local _call = require "Call"
local _chain = require "Chain"
-- end commands import

A.commands = {
    ["time"] = _time.time,
    ["id"] = _id.id,
    ["sum"] = _sum.sum,
    ["com"] = _com.com,
    ["call"] = _call.call,
    ["chain"] = _chain.chain,
}

return A