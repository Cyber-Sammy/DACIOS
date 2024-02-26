-- modules
local utils_path = "utilities/?.lua"
local models_path = "models/?.lua"

package.path = package.path .. ";" .. utils_path
package.path = package.path .. ";" .. models_path
-- end modules

local Chain = {}

local _response = require "Response"
local _request = require "Request"
local _string = require "StringUtils"

local function chain(request) --correct format: id_to_respond;address;chain;exec_command 'exec command args' id_to_exec-id_to_respond id_to_exec-id_to_respond (0;0;chain;sum '2 3 4 5' 1-5 2-5 3-5 4-5)
    local global_args
    local success, error = pcall(function ()
        global_args = _string.split(request.data, "\'")
    end)

    if not success or #global_args ~= 3 then
        local response = _response.Response:new(request.id, '_', "chain", false, "Command has invalid format.\n" .. tostring(error), request.text_only)
        return response
    end

    local cmd_to_execute = global_args[1]:gsub("%s+", "")
    local cmd_args = global_args[2]
    local id_exec_send_pairs = _string.split(global_args[3], " ")

    local requests = {}

    for i = 1, #id_exec_send_pairs do
        local id_to_execute = _string.split(id_exec_send_pairs[i], "-")[1]:gsub("%s+", "")
        local id_to_respond = _string.split(id_exec_send_pairs[i], "-")[2]:gsub("%s+", "")
        requests[i] = _request.Request:new(tonumber(id_to_respond), request.address, cmd_to_execute, cmd_args, request.text_only, request.is_log_needed, tonumber(id_to_execute))
    end

    if request.is_log_needed then
        for i = 1, #requests do
            requests[i]:output()
        end
    end

    return requests
end

Chain.chain = chain

return Chain