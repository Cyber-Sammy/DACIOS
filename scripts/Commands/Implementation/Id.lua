-- modules
local utils_path = "utilities/?.lua"
local models_path = "models/?.lua"

package.path = package.path .. ";" .. utils_path
package.path = package.path .. ";" .. models_path
-- end modules

local Id = {}

local _request = require "Request"
local _response = require "Response"
local _string = require "StringUtils"

local function id(request)
    return _response.Response:new(request.id, '_', "id", true, os.getComputerID() or "Unnamed")
end

Id.id = id

return Id