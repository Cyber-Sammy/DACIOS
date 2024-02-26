-- modules
local utils_path = "utilities/?.lua"
local commands_path = "commands/?.lua"
local models_path = "models/?.lua"
local cipher_path = "encryptor/?.lua"
local register_path = "reg/?.lua"

package.path = package.path .. ";" .. utils_path
package.path = package.path .. ";" .. commands_path
package.path = package.path .. ";" .. models_path
package.path = package.path .. ";" .. cipher_path
package.path = package.path .. ";" .. register_path
-- end modules

local IO = {}

local _commands = require "Commands"
local _request = require "Request"
local _response = require "Response"
local _string = require "StringUtils"
local _manager = require "Manager"
local _register = require "Register"

local to_proceed_queue = {}
local to_send_queue = {}

local modem_side = "back" 
local modem = peripheral.wrap(modem_side)

local function enqueue(queue, item)
    table.insert(queue, item)
end

local function dequeue(queue)
    return table.remove(queue, 1)
end

local function isEmpty(queue)
    return #queue == 0
end

local function printResponse(sender_id, message)
    local succees, error = pcall(function ()
        print("[" .. sender_id .. "]:" .. message)
    end)

    if succees ~= true then
        local casted = _response.Response.cast(message)
        casted:output()
    end
end

local function proceedCommandToQueue(command)
    if command.is_response and (tonumber(command.id) == tonumber(os.getComputerID())) then

        local casted = _response.Response.cast(command)
        if command.text_only then
            printResponse(casted.id, casted)
        else
            casted:output()
        end
    else
        enqueue(to_send_queue, command)
    end
end

local function handleIncomingMessage(sender_id, message)
    local is_valid, received_command = _register.insert(message.uid, message.command)

    if is_valid == false then
        print("Interruption detected on command " .. received_command .. " with uid " .. message.uid)

        return
    end

    if message.is_response then
        message.id = sender_id

        if message.text_only or message.is_log_needed then
            printResponse(sender_id, message.message)
        else
            local casted = _response.Response.cast(message)
            casted:output()
        end
    else
        if _commands.commands[message.command] then
            enqueue(to_proceed_queue, message)
        else
            if message.command == nil then
                local errorMsg = "Unknown command: " .. message.command
                print(errorMsg)
                local response = _response.Response:new(message.id, message.address, message.command, false, errorMsg)
                enqueue(to_send_queue, response)
            end

            local response = _response.Response:new(message.id, message.address, message.command, false, "Invalid request")
            enqueue(to_send_queue, response)
        end
    end
end

local function listen()
    while true do
        modem.open(os.getComputerID())
        local event, side, channel, replyChannel, message_raw, distance = os.pullEvent("modem_message")
        local signature, message_object

        local is_unpacked, error = pcall(function ()
            signature, message_object = _manager.Unpack(message_raw)
        end)

        if is_unpacked == true then
            local is_handled, handle_error = pcall(function ()
                parallel.waitForAll(handleIncomingMessage(signature, message_object))
            end)

            if not is_handled then
                print("Handling message error\n" .. tostring(error))
            end
        else
            print("Unable to unpack message")
        end

        os.sleep(0)
        modem.close(os.getComputerID())
    end
end

local function work()
    while true do
        if not isEmpty(to_proceed_queue) then
            local command = dequeue(to_proceed_queue)
            if command.is_log_needed then
                local casted = _request.Request.cast(command)
                casted:output()    
            end

            if command.execute_at_id ~= nil then
                proceedCommandToQueue(command)
            else
                local result = _commands.commands[command.command](command) --there could be requests instead of responses. It happens when chain commands (like CHAIN command) are being executed

                if #result == 0 then
                    proceedCommandToQueue(result)
                else
                    for i = 1, #result do
                        proceedCommandToQueue(result[i])
                    end
                end
            end
        else
            os.sleep(0)
        end
    end
end

local function send()
    while true do
        if not isEmpty(to_send_queue) then
            local to_transmit = dequeue(to_send_queue)
            
            local id_to_send, id_to_respond
            if not to_transmit.is_response and to_transmit.execute_at_id ~= nil then
                id_to_send = tonumber(to_transmit.execute_at_id)
                id_to_respond = tonumber(to_transmit.id)
                to_transmit.execute_at_id = nil
                print("[SEND REQUEST " .. to_transmit.command .. " TO " .. id_to_send .. " (TEXT ONLY: " .. tostring(to_transmit.text_only) .. ")]")
            else
                id_to_send = tonumber(to_transmit.id)
                id_to_respond = tonumber(os.getComputerID())
                print("[SEND RESPONSE " .. to_transmit.command .. " TO " .. id_to_send .. " (TEXT ONLY: " .. tostring(to_transmit.text_only) .. ")]")
            end

            modem.open(id_to_send)
            local message_object_to_send = _manager.Pack(to_transmit)
            modem.transmit(id_to_send, id_to_respond, message_object_to_send)
            modem.close(id_to_send)
        else
            os.sleep(0.2)
        end
    end
end

function IO.startCoroutines()
    parallel.waitForAll(listen, work, send)
end

return IO