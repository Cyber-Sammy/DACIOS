-- modules
local utils_path = "utilities/?.lua"
local models_path = "models/?.lua"

package.path = package.path .. ";" .. utils_path
package.path = package.path .. ";" .. models_path
-- end modules

local Time = {}

local _request = require "Request"
local _response = require "Response"
local _string = require "StringUtils"

local function time(request)
    return _response.Response:new(request.id, '_', "time", true, textutils.formatTime(os.time(), true), request.text_only)
end

Time.time = time

return Time