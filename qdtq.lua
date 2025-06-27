local manager = "paru"

os.execute("clear")
print("Press enter to continue with paru")
print("Will execute: 'paru -Qdtq | -Qi <package> | -R <package>'")
print("Type [name] if you want to use another package manager")
manager = io.read():match("%S+") or manager

local f
local list
local needRefresh = true

while true do
    -- Refresh packages list
    if needRefresh then
        f = io.popen(manager .. " -Qdtq", 'r')
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
    print("\n[" .. manager .. "]\nChoose one to view details: (else to quit)")
    local choose = tonumber(io.read())
    if not list[choose] then os.exit() end

    -- Print package details
    os.execute("clear")
    f = io.popen(manager .. " -Qi " .. list[choose], 'r')
    print(f:read('*a'))
    f:close()

    -- Remove package after confirmation
    print("\n[" .. manager .. "]\nType \"Y\" to uninstall: (else to return)")
    local confirm = io.read()
    if confirm == "Y" then
        os.execute(manager .. " -R " .. list[choose])
        print("\nPackage " .. list[choose] .. " removed! Press Enter to continue...")
        io.read()
        needRefresh = true
    end
end
