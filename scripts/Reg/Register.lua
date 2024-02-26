local Register = {}

local General = {}
local Repeats = {}

local function check(table, uid)
    if table[uid] == nil then
        return nil, false
    else 
        return table[uid], true
    end
end

function Register.insert(uid, command)
    local valueFromRepeats, existsInRepeats = check(Repeats, uid)
    if existsInRepeats then
        return false, valueFromRepeats
    else
        local valueFromGeneral, existsInGeneral = check(General, uid)

        if existsInGeneral then
            Repeats[uid] = command

            return false, valueFromGeneral
        else
            if #General > 400 then
                General = {}
            end
            General[uid] = command

            return true, command
        end
    end
end

function Register.outputGeneral()
    print('++++++++++++++++++++++')
    for k, v in pairs(General) do
        if v ~= nil then
            print(k .. " - " .. v)
        else
            print(k)
        end
    end
    print('++++++++++++++++++++++')
end

function Register.outputRepeats()
    print('++++++++++++++++++++++')
    for k, v in pairs(Repeats) do
        if v ~= nil then
            print(k .. " - " .. v)
        else
            print(k)
        end
    end
    print('++++++++++++++++++++++')
end

return Register