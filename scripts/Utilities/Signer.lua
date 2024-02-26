-- modules
local utils_path = "utilities/?.lua"

package.path = package.path .. ";" .. utils_path
-- end modules

local _cryptor = require "Crypt"
local _keys = require "Keys"

local Signer = {}

function Signer.sign(computer_id, message)
    local message_to_sign = {
        computer_id = computer_id,
        message = message
    }

    return _cryptor.encrypt(textutils.serialize(message_to_sign), _keys.SignKey)
end

function Signer.unsign(crypted_serialized_message)
    local decrypted_signed_message = textutils.unserialize(_cryptor.decrypt(crypted_serialized_message, _keys.SignKey))
    local computer_sign, encrypted_message = decrypted_signed_message.computer_id, decrypted_signed_message.message

    return computer_sign, encrypted_message
end

return Signer