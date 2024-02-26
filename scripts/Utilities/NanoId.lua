local NanoId = {
    validCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-",
  
    generate = function (size, validChars)
  
    local response = ""
    local ms = string.match(tostring(os.time() % os.clock() / os.clock()), "%d%.(%d+)")
    local temp = math.randomseed(ms)
  
    if (size > 0 and string.len(validChars) > 0) then
        for i = 1, size do
            local num = math.random(string.len(validChars))
  
            response = response..string.sub(validChars, num, num)
        end
    end
  
    return response
    end
}
  
function NanoId:getNanoId()
    return self.generate(21, self.validCharacters)
end

return NanoId