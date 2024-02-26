-- modules
local utils_path = "utilities/?.lua"
local models_path = "models/?.lua"

package.path = package.path .. ";" .. utils_path
package.path = package.path .. ";" .. models_path
-- end modules

local Call = {}

local _request = require "Request"
local _response = require "Response"
local _string = require "StringUtils"

local function call(request)
    local sender_id, address, command, data = request.id, request.address, request.command, request.data
    local arguments = _string.split(data, ' ')

    if #arguments < 1 then
        return _response.Response:new(os.getComputerID(), address, command, false, "Lack of arguments")
    end

    return _response.Response:new(os.getComputerID(), address, command, false, "This feature is not implementated yet!", false)
end

Call.call = call

return Call