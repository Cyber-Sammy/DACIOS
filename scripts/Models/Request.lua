-- modules
local utils_path = "utilities/?.lua"

package.path = package.path .. ";" .. utils_path
-- end modules

local I = {}

local _nanoId = require "NanoId"

I.Request = {
    command = '_',
    data = '_',
    address = '_',
    id = '_',
    text_only = false,
    uid = '_',
    is_response = false,
    is_log_needed = false,
    execute_at_id = nil,
    output_generic = nil,
}

function I.Request:new(_id, _address, _command, _data, _text_only, _is_log_needed, _execute_at_id)
    local instance = setmetatable({}, { __index = I.Request })
    instance.address = _address
    instance.command = _command
    instance.data = _data
    instance.id = tonumber(_id)
    instance.text_only = _text_only
    instance.uid = _nanoId:getNanoId()
    instance.is_response = false
    instance.is_log_needed = _is_log_needed
    instance.execute_at_id = _execute_at_id

    return instance
end

function I.Request.cast(request)
    local instance = setmetatable({}, { __index = I.Request })
    instance.address = request.address
    instance.command = request.command
    instance.data = request.data
    instance.id = tonumber(request.id)
    instance.text_only = request.text_only
    instance.uid = _nanoId:getNanoId()
    instance.is_response = false
    instance.is_log_needed = request.is_log_needed
    instance.execute_at_id = request.execute_at_id
    instance.output_generic = request.output_generic

    return instance
end

function I.Request:empty()
    return I.Request:new('_', '_', '_', '_', false)
end

function I.Request:output()
    if self.output_generic == nil then
        print('\n=====[REQUEST]=====')
        print('Will be sent to:\t' .. (self.id or '') ..
            '\nAddress:\t' .. (self.address or '') ..
            '\nCommand:\t' .. (self.command or '') ..
            '\nArgs:\t' .. (self.data or ''))
        print('\n===================')
    else
        self:output_generic()
    end
    
end

function I.Request:toSend()
    return self.id .. ";" .. self.address .. ";" .. self.command .. ";" .. self.data .. ";" .. tostring(self.text_only)
end

function I.Request:toSendFull()
    return self.id .. ";" .. self.address .. ";" .. self.command .. ";" .. self.data .. ";" .. tostring(self.text_only) .. ';' .. self.uid
end

return I