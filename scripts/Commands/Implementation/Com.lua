-- modules
local utils_path = "utilities/?.lua"
local models_path = "models/?.lua"

package.path = package.path .. ";" .. utils_path
package.path = package.path .. ";" .. models_path
-- end modules

local Com = {}

local _response = require "Response"

local output_generic = function (output_entity)
    print('\n-----[COM COMMAND]-----')
    print('From:\t' .. (output_entity.id or '') ..
        '\nMessage:\t' .. (output_entity.message or '') ..
        '\nIs successful:\t' .. (tostring(output_entity.is_success)))
    print('\n-----------------------')
end

local function com(request)
    local response = _response.Response:new(request.id, '_', "com", true, request.data, request.text_only, request.is_log_needed)
    response.output_generic = output_generic
    return response
end

Com.com = com

return Com