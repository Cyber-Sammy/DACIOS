-- modules
local utils_path = "utilities/?.lua"
local models_path = "models/?.lua"

package.path = package.path .. ";" .. utils_path
package.path = package.path .. ";" .. models_path
-- end modules

local Sum = {}

local _request = require "Request"
local _response = require "Response"
local _string = require "StringUtils"

local output_generic = function (output_entity)
    print('\n-----[SUM COMMAND]-----')
    print('From:\t' .. (output_entity.id or '') ..
        '\nNumbers are:\t' .. (output_entity.temp_value or '') ..
        '\nResult is:\t' .. (output_entity.message or '') ..
        '\nIs successful:\t' .. (tostring(output_entity.is_success)))
    print('\n-----------------------')
end

local function sum(request)
    local args = _string.split(request.data, ' ')

    if #args == 0 then
        return _response.Response:new(request.id, '_', "sum", false, "Lack of arguments")
    end

    local result = 0

    for index, value in ipairs(args) do
        result = result + value
    end

    local response = _response.Response:new(request.id, '_', "sum", true, result, request.text_only, request.is_log_needed)

    response.temp_value = request.data
    response.output_generic = output_generic

    return response
end

Sum.sum = sum

return Sum