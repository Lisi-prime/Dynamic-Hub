--[[
    Dynamic Hub
      by Lisi
]]

if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("Welcome to Dynamic Hub")

local PlaceId = game.PlaceId
local GameId = game.GameId

if PlaceId == 142823291 or PlaceId == 335132778 or GameId == 66654135 then
    local function fetch(url)
        for _ = 1, 3 do
            local ok, res = pcall(game.HttpGet, game, url)
            if ok and type(res) == "string" and #res > 500 then
                return res
            end
            task.wait(0.15)
        end
        return nil
    end

    local cb = "?t=" .. tostring(os.time())
    local coreRaw, guiRaw = nil, nil

    task.spawn(function()
        coreRaw = fetch("https://raw.githubusercontent.com/Lisi-prime/Dynamic-Hub/main/Dynamic_hub" .. cb)
            or fetch("https://raw.githubusercontent.com/Lisi-prime/Dynamic-Hub/refs/heads/main/Dynamic_hub" .. cb)
    end)
    task.spawn(function()
        guiRaw = fetch("https://raw.githubusercontent.com/Lisi-prime/Dynamic-Hub/main/Dynamic_gui" .. cb)
            or fetch("https://raw.githubusercontent.com/Lisi-prime/Dynamic-Hub/refs/heads/main/Dynamic_gui" .. cb)
    end)

    local waited = 0
    while (not coreRaw or not guiRaw) and waited < 6 do
        task.wait(0.05)
        waited = waited + 0.05
    end

    if not coreRaw or not guiRaw then return end

    local Hub = nil
    local fnCore = loadstring(coreRaw)
    if fnCore then
        local ok, res = pcall(fnCore)
        if ok and type(res) == "table" then
            Hub = res
        end
    end

    Hub = Hub or _G.DynamicHub or (getgenv and getgenv().DynamicHub)
    if Hub then
        _G.DynamicHub = Hub
        if getgenv then pcall(function() getgenv().DynamicHub = Hub end) end
        pcall(function() shared.DynamicHub = Hub end)
    end

    local fnGui = loadstring(guiRaw)
    if fnGui then
        pcall(fnGui, Hub)
    end
end
