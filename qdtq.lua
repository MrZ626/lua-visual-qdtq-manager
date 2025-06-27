local f, o

while true do
    -- Print qdtq packages
    os.execute("clear")
    f = io.popen("paru -Qdtq", 'r')
    local list = {}
    while true do
        local line = f:read('*l')
        if not line then break end
        table.insert(list, line)
    end
    for i = 1, #list do
        print(i .. ": " .. list[i])
    end
    f:close()

    print("Choose a package to view details, anything else to quit.")
    o = tonumber(io.read())
    if not list[o] then os.exit() end

    -- Print package details
    os.execute("clear")
    f = io.popen("paru -Qi " .. list[o], 'r')
    print(f:read('*a'))
    f:close()

    -- Remove package after confirmation
    print("Type \"R\" to uninstall, anything else to continue...")
    o = io.read()
    if o == "R" then
        os.execute("paru -R " .. list[o])
        print("Package " .. list[o] .. " removed! Press Enter to continue...")
        io.read()
    end
end
