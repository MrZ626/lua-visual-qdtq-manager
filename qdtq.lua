local f
local needRefresh = true
local list
while true do
    -- Refresh packages list
    if needRefresh then
        f = io.popen("paru -Qdtq", 'r')
        list = {}
        while true do
            local line = f:read('*l')
            if not line then break end
            table.insert(list, line)
        end
        f:close()
        needRefresh = false
    end

    -- Print qdtq package names
    os.execute("clear")
    for i = 1, #list do print(i .. ": " .. list[i]) end
    print("Choose a package to view details, anything else to quit.")
    local choose = tonumber(io.read())
    if not list[choose] then os.exit() end

    -- Print package details
    os.execute("clear")
    f = io.popen("paru -Qi " .. list[choose], 'r')
    print(f:read('*a'))
    f:close()

    -- Remove package after confirmation
    print("Type \"R\" to uninstall, anything else to continue...")
    local confirm = io.read()
    if confirm == "R" then
        os.execute("paru -R " .. list[choose])
        print("\nPackage " .. list[choose] .. " removed! Press Enter to continue...")
        io.read()
        needRefresh = true
    end
end
