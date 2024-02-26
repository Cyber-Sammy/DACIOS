-- modules
local utils_path = "utilities/?.lua"

package.path = package.path .. ";" .. utils_path
-- end modules

local O = {}

local _nanoId = require "NanoId"

O.Response = {
    command = '_',
    message = '_',
    address = '_',
    id = '_',
    is_success = false,
    text_only = false,
    uid = '_',
    is_response = false,
    is_log_needed = false,
    output_generic = nil,
    temp_value = nil,
}

function O.Response:new(_id, _address, _command, _is_success, _message, _text_only, _is_log_needed)
    local instance = setmetatable({}, { __index = O.Response })
    instance.address = _address
    instance.command = _command
    instance.message = _message
    instance.id = tonumber(_id)
    instance.is_success = _is_success
    instance.text_only = _text_only
    instance.uid = _nanoId:getNanoId()
    instance.is_response = true
    instance.is_log_needed = _is_log_needed

    return instance
end

function O.Response.cast(response)
    local instance = setmetatable({}, { __index = O.Response })
    instance.address = response.address
    instance.command = response.command
    instance.message = response.message
    instance.id = tonumber(response.id)
    instance.is_success = response.is_success
    instance.text_only = response.text_only
    instance.uid = _nanoId:getNanoId()
    instance.is_response = true
    instance.is_log_needed = response.is_log_needed
    instance.output_generic = response.output_generic
    instance.temp_value = response.temp_value

    return instance
end

function O.Response.empty()
    return O.Response:new('_', '_', '_', false, '_', false)
end

function O.Response:output()
    if self.text_only then
        if tonumber(self.id) == tonumber(os.getComputerID()) then
            print("[SELF]: " .. self.message)
        else
            print(self.message)
        end
    else
        if self.output_generic == nil then
            print('\n-----[RESPONSE]-----')
            print('From:\t' .. (self.id or '') ..
            '\nAddress:\t' .. (self.address or '') ..
            '\nCommand:\t' .. (self.command or '') ..
            '\nStatus:\t' .. (tostring(self.is_success)) ..
            '\nResult:\t' .. (self.message or ''))
            print('\n--------------------')
        else
            self:output_generic()
        end
    end
end

function O.Response:toSend()
    if self.text_only then
        return self.message
    else
        return self.id .. ";" .. self.address .. ";" .. self.command .. ";" .. tostring(self.is_success) .. ";" .. self.message
    end
end

function O.Response:toSendFull()
    if self.text_only then
        return self.message
    else
        return self.id .. ";" .. self.address .. ";" .. self.command .. ";" .. tostring(self.is_success) .. ";" .. self.message .. ";" .. self.uid
    end
end

return O