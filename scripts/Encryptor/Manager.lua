-- modules
local utils_path = "utilities/?.lua"

package.path = package.path .. ";" .. utils_path
-- end modules

local Manager = {}

local _cryptor = require "Crypt"
local _keys = require "Keys"
local _proto = require "Protocols"
local _md5 = require "md5"

function Manager.Pack(message_object, protocol)
    if message_object.output_generic ~= nil then
        message_object.output_generic = string.dump(message_object.output_generic)
    end
    local encrypted_serialized_message_object = _cryptor.encrypt(textutils.serialize(message_object), _keys.SyncKey)
    local signed_message_object = Manager.Sign(encrypted_serialized_message_object, protocol)

    return signed_message_object
end

function Manager.Unpack(signed_message_object)
    local signature, encrypted_serialized_message_object, protocol = Manager.Unsign(signed_message_object)
    local message_object = textutils.unserialize(_cryptor.decrypt(encrypted_serialized_message_object, _keys.SyncKey))
    if message_object.output_generic ~= nil then
        message_object.output_generic = load(message_object.output_generic)
    end 
    return signature, message_object, protocol
end

function Manager.Sign(encrypted_serialized_message_object, protocol)
    local object_to_sign = {
        signature = os.getComputerID(),
        content = encrypted_serialized_message_object,
        protocol = protocol or _proto.MessageProtocol
    }

    local signed_serialized_object = _cryptor.encrypt(textutils.serialize(object_to_sign), _keys.SignKey)

    return signed_serialized_object
end

function Manager.Unsign(signed_serialized_object)
    local object_unsigned = textutils.unserialize(_cryptor.decrypt(signed_serialized_object, _keys.SignKey))
    local encrypted_serialized_message_object = object_unsigned.content
    local signature = object_unsigned.signature
    local protocol = object_unsigned.protocol
    return signature, encrypted_serialized_message_object, protocol
end

return Manager