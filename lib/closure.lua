return function (func, ...)
    local args = {...}
    return function ()
        func(unpack(args))
    end
end
