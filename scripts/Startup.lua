-- modules
local io_path = "IO/?.lua"

package.path = package.path .. ";" .. io_path
-- end modules

local _io = require "IO"

local modem_side = "back"
local counter = 0
local max_attempts = 50

if peripheral.isPresent(modem_side) then
    local success, error
    repeat
        success, error = pcall(function ()
            _io.startCoroutines()
        end)

        if not success then

            if error == "Terminated" then
                print("Terminating session")

                return
            end

            counter = counter + 1
            print("Unable to start coroutine. Attempt #" .. counter .. ". Trying again \n[" .. error .. "]")
            sleep(1)
        end
    until success or counter >= max_attempts

    if not success then
        print("Failed to start coroutines after " .. max_attempts .. " attempts.")
    end
else
    print("No modem found on the " .. modem_side .. " side.")
end