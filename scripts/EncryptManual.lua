-- modules
local utils_path = "utilities/?.lua"
local cipher_path = "encryptor/?.lua"
local models_path = "models/?.lua"

package.path = package.path .. ";" .. utils_path
package.path = package.path .. ";" .. cipher_path
package.path = package.path .. ";" .. models_path
-- end modules

local _string = require "StringUtils"
local _manager = require "Manager"
local _request = require "Request"

local modem = peripheral.wrap('back')

print('Input receiver id')
local id = read()
modem.open(tonumber(id))

print('Input command')
local command = read()
local reply_pc = _string.split(command, ';')[1]

print('You want to respond only with text?')
local input_respond_only = read()
local text_only = false

print('You want to log request on screen?')
local log_request_input = read()
local log_request = false

if log_request_input == "true" or tonumber(log_request_input) == 1 then
    log_request = true
else
    log_request = false
end

if input_respond_only == "true" or tonumber(input_respond_only) == 1 then
    text_only = true
else
    text_only = false
end

print('You wanna loop?')
local is_loop = read()
local loop_iterations = 0

local function send(id, reply_pc, command) --1 - id to send response, 2 - address, 3 - command name, 4 - arguments, 5 - id to send request
    local tokens = _string.split(command, ';')
    local request = _request.Request:new(tokens[1], tokens[2], tokens[3], tokens[4], text_only, log_request, tokens[5])
    print("ID TO RESPOND: " .. tostring(tokens[1]))
    print("ADDRESS: " .. tostring(tokens[2]))
    print("COMMAND: " .. tostring(tokens[3]))
    print("ARGUMENTS: " .. tostring(tokens[4]))
    print("ID TO REDIRECT RESULTING REQUEST: " .. tostring(tokens[5]))
    local message_object_to_send

    local is_packed, err = pcall(function ()
        message_object_to_send = _manager.Pack(request)
    end)

    if is_packed and message_object_to_send then
        modem.transmit(tonumber(id), tonumber(reply_pc), message_object_to_send)
        print("Command sent from " .. os.getComputerID() .. " to " .. id)
    else
        print("Error sending request.\n" .. err)
    end
end

if is_loop == 'true' or tonumber(is_loop) == 1 then
    print('How many?')
    loop_iterations = tonumber(read())

    print('How frequently?')
    local freq = tonumber(read())

    while loop_iterations ~= 0 do

        send(id, reply_pc, command)

        loop_iterations = loop_iterations - 1

        sleep(freq)
    end
else
    send(id, reply_pc, command)
end
