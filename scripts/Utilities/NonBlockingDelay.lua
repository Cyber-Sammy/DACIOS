local A = {}

function A.delay(ticks)
    local target = os.clock() + ticks
    repeat
        coroutine.yield()
    until os.clock() >= target
end

return A