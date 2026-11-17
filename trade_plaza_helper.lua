--[[
    DYNAMIC HUB | Blade Ball Trade Plaza Edition
    UI Architecture: Dynamic Hub (MM2) 1:1 Implementation
    Window Size: Enlarged PC format (620 x 430)
    Tabs:
      1. Main: Player Info, Server Info, Join by JobId, Rejoin, Server Hop
      2. Trade Helper:
         - Open Selected Item in Index (с графиком RAP и 3D превью)
         - Auto Claim Booth (авто-захват свободного стенда)
         - Session Profit Tracker (список проданных лотов с картинкой, ценой и временем)
         - ESP My Booth (подсветка своего стенда)
         - ESP Booths (подсветка занятых стендов с никами владельцев)
         - Anti-AFK & Auto-Rejoin on Kick
      3. Settings: Exact Dynamic Hub 4-icon Config Manager + Autoload + Unload
    Aesthetics: Dynamic Logo, TopBar Gradient, Neon Divider Seam, DropShadow
    BAC Safe: gethui(), cloneref, zero __namecall hooks, zero BAC tampering
    Toggle Key: Right Control
]]

local cloneref = cloneref or function(x) return x end
local gethui = gethui or function() return cloneref(game:GetService("CoreGui")) end

_G.DynamicTradeHub = nil
local Hub = {
    Services = {
        Players = cloneref(game:GetService("Players")),
        TweenService = cloneref(game:GetService("TweenService")),
        RunService = cloneref(game:GetService("RunService")),
        UserInputService = cloneref(game:GetService("UserInputService")),
        TeleportService = cloneref(game:GetService("TeleportService")),
        GuiService = cloneref(game:GetService("GuiService")),
        CoreGui = cloneref(game:GetService("CoreGui")),
        ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage")),
        HttpService = cloneref(game:GetService("HttpService")),
        ContentProvider = cloneref(game:GetService("ContentProvider")),
        Stats = cloneref(game:GetService("Stats")),
        Workspace = cloneref(game:GetService("Workspace")),
        Lighting = cloneref(game:GetService("Lighting")),
        SoundService = cloneref(game:GetService("SoundService")),
    },
    Theme = {
        MainBg = Color3.fromRGB(15, 15, 18),
        TopBarBg = Color3.fromRGB(19, 19, 24),
        CardBg = Color3.fromRGB(24, 24, 30),
        CardHover = Color3.fromRGB(30, 30, 38),
        Border = Color3.fromRGB(36, 36, 46),
        Accent = Color3.fromRGB(140, 80, 255),
        AccentGlow = Color3.fromRGB(195, 155, 255),
        AccentDark = Color3.fromRGB(38, 38, 48),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(160, 160, 175),
        TextMuted = Color3.fromRGB(105, 105, 118),
        DangerRed = Color3.fromRGB(255, 75, 90),
        DangerDark = Color3.fromRGB(45, 18, 24),
        SuccessGreen = Color3.fromRGB(80, 220, 120),
    },
    Config = {
        MenuKey = Enum.KeyCode.RightControl,
        CloseGuiOnStart = true,
        FastLoad = true,
        UltraFastLoad = true,
        AntiAFK = false,
        AutoRejoinOnKick = true,
        AutoClaimBooth = false,
        AutoServerHop = false,
        MinPlayersThreshold = 6,
        EspMyBooth = false,
        MyBoothTracer = false,
        EspBooths = false,
        WatchlistEsp = true,
        WatchlistItems = {},
        TeleportItemName = "",
        WebhookEnabled = false,
        WebhookUrl = "",
        Key_OpenIndex = Enum.KeyCode.Q,
    },
    State = {
        IsOpen = true,
        ActiveTab = "Main",
        Connections = {},
        Tabs = {},
        TabButtons = {},
        ConfigControls = {},
        WindowSize = UDim2.new(0, 620, 0, 430),
        IsRejoining = false,
        IsServerHopping = false,
        IsSearchingSellers = false,
        FastLoadWatcher = false,
        StrippedEffects = {
            Particles = {},
            Lighting = {},
            Terrain = {},
            Sounds = {},
            Leaderboard = nil,
        },
        UltraFastLoadActive = false,
        NotifiedListings = {},
        BoothObserverSetup = false,
        AntiAfkConn = nil,
        SelectedConfig = "",
        EspFolder = nil,
        MyBoothHighlight = nil,
        MyBoothBillboard = nil,
        MyBoothBeam = nil,
        MyBoothAtt0 = nil,
        MyBoothAtt1 = nil,
        LastSelectedBoothItem = "",
        InStatsMode = false,
        IndexNativeConn = nil,
        StatsCloseConn = nil,
        WatchlistListingConn = nil,
        RefreshWatchlistUI = nil,
        UpdateTeleportInput = nil,
    }
}

local Icons = {
    Main = "rbxassetid://10709782497",
    Trade = "rbxassetid://7734053495",
    Settings = "rbxassetid://10734950309",
    StarFilled = "rbxassetid://10709790807",
    Close = "rbxassetid://10747384394",
    User = "rbxassetid://10747373176",
    Server = "rbxassetid://10723395215",
    Store = "rbxassetid://7734053495",
    Search = "rbxassetid://10734943902",
}

-- Safe Parent Target (gethui prevents BAC from scanning descendants)
local parentTarget = gethui()
local existingGui = parentTarget:FindFirstChild("Dynamic_Hub_BladeBall")
if existingGui then
    existingGui:Destroy()
end

local LocalPlayer = Hub.Services.Players.LocalPlayer or Hub.Services.Players.PlayerAdded:Wait()

-- ESP Folder in parentTarget
local espContainer = parentTarget:FindFirstChild("Dynamic_Hub_ESP")
if espContainer then espContainer:Destroy() end
espContainer = Instance.new("Folder")
espContainer.Name = "Dynamic_Hub_ESP"
espContainer.Parent = parentTarget
Hub.State.EspFolder = espContainer

-- LOGO ASSET LOADER (Safe native asset, no PreloadAsync / writefile)
function Hub:GetLogoAsset()
    return "rbxassetid://7734053495"
end

-- UI Helper Methods
function Hub:Corner(instance, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = instance
    return c
end

function Hub:Stroke(instance, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or self.Theme.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = instance
    return s
end

function Hub:Tween(instance, props, duration, style, dir)
    local info = TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quad,
        dir or Enum.EasingDirection.Out
    )
    local t = self.Services.TweenService:Create(instance, info, props)
    t:Play()
    return t
end

function Hub:Notify(title, message)
    task.spawn(function()
        pcall(function()
            local StarterGui = cloneref(game:GetService("StarterGui"))
            StarterGui:SetCore("SendNotification", {
                Title = title or "Dynamic Hub",
                Text = message or "",
                Duration = 3
            })
        end)
    end)
end

-- UNLOAD SCRIPT (Clean Exit)
function Hub:Unload()
    self.State.IsOpen = false
    if self.State.Connections then
        for _, c in ipairs(self.State.Connections) do
            pcall(function() c:Disconnect() end)
        end
        self.State.Connections = {}
    end
    if self.State.AntiAfkConn then
        pcall(function() self.State.AntiAfkConn:Disconnect() end)
        self.State.AntiAfkConn = nil
    end
    self.Config.AntiAFK = false

    if self.State.StatsCloseConn then
        pcall(function() self.State.StatsCloseConn:Disconnect() end)
        self.State.StatsCloseConn = nil
    end
    if self.State.WatchlistListingConn then
        pcall(function() self.State.WatchlistListingConn:Disconnect() end)
        self.State.WatchlistListingConn = nil
    end
    if self.State.EspFolder then
        pcall(function() self.State.EspFolder:Destroy() end)
        self.State.EspFolder = nil
    end
    if self.State.MyBoothBeam then
        pcall(function() self.State.MyBoothBeam:Destroy() end)
        self.State.MyBoothBeam = nil
    end
    if self.State.MyBoothAtt0 then
        pcall(function() self.State.MyBoothAtt0:Destroy() end)
        self.State.MyBoothAtt0 = nil
    end
    if self.State.MyBoothAtt1 then
        pcall(function() self.State.MyBoothAtt1:Destroy() end)
        self.State.MyBoothAtt1 = nil
    end
    if self.State.Gui then
        pcall(function() self.State.Gui:Destroy() end)
        self.State.Gui = nil
    end
    print("[Dynamic Hub] Unloaded successfully.")
end

-- REJOIN LOGIC
function Hub:TriggerRejoin(reason)
    if self.State.IsRejoining then return end
    self.State.IsRejoining = true
    print("[Dynamic Hub] Rejoining due to: " .. tostring(reason))

    task.wait(1.2)
    local placeId = game.PlaceId or 16581637217
    local success, err = pcall(function()
        self.Services.TeleportService:Teleport(placeId, LocalPlayer)
    end)
    if not success then
        warn("[Dynamic Hub] Teleport retry in 2s:", err)
        task.wait(2)
        self.Services.TeleportService:Teleport(placeId, LocalPlayer)
    end
end

function Hub:SetupKickWatcher()
    local errConn = self.Services.GuiService.ErrorMessageChanged:Connect(function(msg)
        if not self.Config.AutoRejoinOnKick then return end
        if not msg or msg == "" then return end
        local lower = msg:lower()
        if lower:find("teleport failed") then return end
        if lower:find("kick") or lower:find("disconnect") or lower:find("lost connection") or lower:find("idle") or lower:find("267") or lower:find("268") or lower:find("277") then
            self:TriggerRejoin("GuiService Kick: " .. msg)
        end
    end)
    table.insert(self.State.Connections, errConn)
end

function Hub:SetupAutoServerHopWatcher()
    task.spawn(function()
        task.wait(35)
        while task.wait(12) do
            if self.Config.AutoServerHop and not self.State.IsServerHopping then
                local currentPlayers = #Hub.Services.Players:GetPlayers()
                local threshold = self.Config.MinPlayersThreshold or 6
                if currentPlayers < threshold then
                    self:Notify("Server Hop", "Игроков мало (" .. tostring(currentPlayers) .. " < " .. tostring(threshold) .. "). Поиск сервера...")
                    self:SmartServerHop()
                end
            end
        end
    end)
end

-- ==================== BOOTH & PLAZA FEATURES ====================

function Hub:HasClaimedBooth()
    local stands = Hub.Services.Workspace:FindFirstChild("Spawn") and Hub.Services.Workspace.Spawn:FindFirstChild("Hub") and Hub.Services.Workspace.Spawn.Hub:FindFirstChild("Stands")
    if not stands then return false end
    for _, s in ipairs(stands:GetChildren()) do
        if s:GetAttribute("Owner") == LocalPlayer.UserId then
            return true, s
        end
    end
    return false
end

-- 1. Teleport Directly to My Booth (Native Left HUD Button or Coordinates)
function Hub:TeleportToMyBooth(forcedStand)
    -- Check native HUD button on the left
    local hud = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("HUD")
    local toBooth = hud and hud.LeftFrame and hud.LeftFrame.Middle and hud.LeftFrame.Middle.MiddleStack:FindFirstChild("ToBooth")
    local firesignal = firesignal or function(sig, ...)
        for _, c in ipairs(getconnections(sig)) do c:Fire(...) end
    end

    if toBooth and toBooth.Visible then
        firesignal(toBooth.Activated)
        self:Notify("Booth", "Телепортирован к своему стенду")
        return true
    end

    -- Direct coordinate teleport to owner spot behind the counter (matching native ToBooth)
    local hasBooth, myStand = false, forcedStand
    if not myStand then
        hasBooth, myStand = self:HasClaimedBooth()
    else
        hasBooth = true
    end

    if hasBooth and myStand then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local rootPart = myStand:FindFirstChild("Root") or myStand:FindFirstChildOfClass("BasePart")
        if root and rootPart then
            local holder = rootPart:FindFirstChild("ProximityPromptHolder")
            local ownerPos = (rootPart.CFrame * CFrame.new(-1, 2.76, -6)).Position
            local lookTarget = holder and holder.WorldPosition or (rootPart.Position + Vector3.new(4, 2, 0))
            local standOwnerCF = CFrame.lookAt(ownerPos, Vector3.new(lookTarget.X, ownerPos.Y, lookTarget.Z))
            root.CFrame = standOwnerCF
            self:Notify("Booth", "Телепортирован к своему стенду")
            return true
        end
    end

    self:Notify("Booth", "У тебя еще нет своего стенда!")
    return false
end

-- 2. Auto Claim Booth (Teleport directly to owner spot behind counter, 100% 1st try claim)
function Hub:ClaimNearestBooth()
    local stands = Hub.Services.Workspace:FindFirstChild("Spawn") and Hub.Services.Workspace.Spawn:FindFirstChild("Hub") and Hub.Services.Workspace.Spawn.Hub:FindFirstChild("Stands")
    if not stands then return false end

    -- Check if we already own a booth
    if self:HasClaimedBooth() then
        return true, "Already own booth"
    end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    local nearestStand, nearestDist = nil, math.huge
    for _, s in ipairs(stands:GetChildren()) do
        local owner = s:GetAttribute("Owner")
        if owner == nil or owner == 0 then
            local rootPart = s:FindFirstChild("Root") or s:FindFirstChildOfClass("BasePart")
            if rootPart then
                local dist = (rootPart.Position - root.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestStand = s
                end
            end
        end
    end

    if nearestStand then
        local prompt = nearestStand:FindFirstChildWhichIsA("ProximityPrompt", true)
        local rootPart = nearestStand:FindFirstChild("Root") or nearestStand:FindFirstChildOfClass("BasePart")
        if prompt and rootPart then
            local holder = rootPart:FindFirstChild("ProximityPromptHolder")
            -- Teleport directly to the owner spot behind the counter (where To Booth teleports)
            local ownerPos = (rootPart.CFrame * CFrame.new(-1, 2.76, -6)).Position
            local lookTarget = holder and holder.WorldPosition or (rootPart.Position + Vector3.new(4, 2, 0))
            local standOwnerCF = CFrame.lookAt(ownerPos, Vector3.new(lookTarget.X, ownerPos.Y, lookTarget.Z))

            root.CFrame = standOwnerCF
            task.wait(0.15)

            if typeof(fireproximityprompt) == "function" then
                fireproximityprompt(prompt)
            else
                prompt:InputHoldBegin()
                task.wait(0.05)
                prompt:InputHoldEnd()
            end

            task.wait(0.35)

            self:Notify("Booth", "Захвачен стенд: " .. nearestStand.Name)
            if self.Config.MyBoothTracer then
                task.delay(0.5, function() self:UpdateMyBoothTracer(true) end)
            end
            if self.Config.EspMyBooth then
                task.delay(0.5, function() self:UpdateMyBoothEsp(true) end)
            end
            return true, "Claimed"
        end
    end
    return false, "No free stands found"
end

-- 3. Smart Server Hop (Filter active public servers with players)
function Hub:SmartServerHop()
    if self.State.IsServerHopping then return end
    self.State.IsServerHopping = true
    self:Notify("Server Hop", "Поиск подходящего сервера...")

    local placeId = game.PlaceId or 16581637217
    local req = request or http_request or (syn and syn.request)

    if typeof(req) == "function" then
        task.spawn(function()
            local success, res = pcall(req, {
                Url = "https://games.roblox.com/v1/games/" .. tostring(placeId) .. "/servers/Public?sortOrder=Desc&limit=100",
                Method = "GET"
            })
            if success and res and res.StatusCode == 200 and res.Body then
                local okJson, data = pcall(function() return Hub.Services.HttpService:JSONDecode(res.Body) end)
                if okJson and data and data.data then
                    local targetServer = nil
                    local threshold = self.Config.MinPlayersThreshold or 6
                    for _, s in ipairs(data.data) do
                        if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers and s.playing >= threshold then
                            targetServer = s.id
                            break
                        end
                    end
                    if targetServer then
                        self:Notify("Server Hop", "Подключение к серверу: " .. targetServer:sub(1, 8) .. "...")
                        pcall(function()
                            Hub.Services.TeleportService:TeleportToPlaceInstance(placeId, targetServer, LocalPlayer)
                        end)
                        task.wait(4)
                        self.State.IsServerHopping = false
                        return
                    end
                end
            end

            -- Fallback
            self:Notify("Server Hop", "Смена сервера через TeleportService...")
            pcall(function()
                Hub.Services.TeleportService:Teleport(placeId, LocalPlayer)
            end)
            task.wait(4)
            self.State.IsServerHopping = false
        end)
    else
        pcall(function()
            Hub.Services.TeleportService:Teleport(placeId, LocalPlayer)
        end)
        task.wait(4)
        self.State.IsServerHopping = false
    end
end

-- 2. ESP My Booth (Highlight Only, No Text)
function Hub:UpdateMyBoothEsp(enabled)
    if self.State.MyBoothHighlight then
        self.State.MyBoothHighlight:Destroy()
        self.State.MyBoothHighlight = nil
    end
    if self.State.MyBoothBillboard then
        self.State.MyBoothBillboard:Destroy()
        self.State.MyBoothBillboard = nil
    end

    if not enabled or not self.State.EspFolder then return end

    local stands = Hub.Services.Workspace:FindFirstChild("Spawn") and Hub.Services.Workspace.Spawn:FindFirstChild("Hub") and Hub.Services.Workspace.Spawn.Hub:FindFirstChild("Stands")
    if not stands then return end

    for _, s in ipairs(stands:GetChildren()) do
        if s:GetAttribute("Owner") == LocalPlayer.UserId then
            local hl = Instance.new("Highlight")
            hl.Name = "MyBooth_HL"
            hl.FillColor = self.Theme.Accent
            hl.OutlineColor = self.Theme.AccentGlow
            hl.FillTransparency = 0.45
            hl.OutlineTransparency = 0.1
            hl.Adornee = s
            hl.Parent = self.State.EspFolder
            self.State.MyBoothHighlight = hl
            return
        end
    end
end

-- 3. My Booth Tracer (Beam from player to own booth)
function Hub:UpdateMyBoothTracer(enabled)
    if self.State.MyBoothBeam then
        pcall(function() self.State.MyBoothBeam:Destroy() end)
        self.State.MyBoothBeam = nil
    end
    if self.State.MyBoothAtt0 then
        pcall(function() self.State.MyBoothAtt0:Destroy() end)
        self.State.MyBoothAtt0 = nil
    end
    if self.State.MyBoothAtt1 then
        pcall(function() self.State.MyBoothAtt1:Destroy() end)
        self.State.MyBoothAtt1 = nil
    end

    if not enabled then return end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local hasBooth, myStand = self:HasClaimedBooth()
    if not hasBooth or not myStand then return end

    local rootPart = myStand:FindFirstChild("Root") or myStand:FindFirstChildOfClass("BasePart")
    if not rootPart then return end

    local att0 = Instance.new("Attachment")
    att0.Name = "Hub_BoothTracer_Att0"
    att0.Position = Vector3.new(0, -1, 0)
    att0.Parent = hrp
    self.State.MyBoothAtt0 = att0

    local att1 = Instance.new("Attachment")
    att1.Name = "Hub_BoothTracer_Att1"
    att1.Position = Vector3.new(0, 1, 0)
    att1.Parent = rootPart
    self.State.MyBoothAtt1 = att1

    local beam = Instance.new("Beam")
    beam.Name = "Hub_BoothTracer_Beam"
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Theme.Accent),
        ColorSequenceKeypoint.new(1, self.Theme.AccentGlow)
    })
    beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(0.5, 0.0),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    beam.Width0 = 0.2
    beam.Width1 = 0.2
    beam.FaceCamera = true
    beam.Segments = 10
    beam.Parent = hrp
    self.State.MyBoothBeam = beam
end

-- 4. ESP All Claimed Booths (Dynamic Billboard Owner Names)
function Hub:UpdateBoothsEsp(enabled)
    if not self.State.EspFolder then return end

    if not enabled then
        for _, ch in ipairs(self.State.EspFolder:GetChildren()) do
            if ch.Name:find("StandOwner_") then
                ch:Destroy()
            end
        end
        return
    end

    local stands = Hub.Services.Workspace:FindFirstChild("Spawn") and Hub.Services.Workspace.Spawn:FindFirstChild("Hub") and Hub.Services.Workspace.Spawn.Hub:FindFirstChild("Stands")
    if not stands then return end

    local activeNames = {}
    for i, s in ipairs(stands:GetChildren()) do
        local ownerId = s:GetAttribute("Owner")
        local bbName = "StandOwner_" .. tostring(i)

        if ownerId and ownerId ~= 0 and ownerId ~= LocalPlayer.UserId then
            local rootPart = s:FindFirstChild("Root") or s:FindFirstChildOfClass("BasePart")
            if rootPart then
                activeNames[bbName] = true
                local ownerName = "ID: " .. tostring(ownerId)
                local p = Hub.Services.Players:GetPlayerByUserId(ownerId)
                if p then
                    ownerName = p.DisplayName
                else
                    for _, d in ipairs(s:GetDescendants()) do
                        if d:IsA("TextLabel") and (d.Name == "Username" or d.Name == "PlayerName" or d.Name == "Owner") and d.Text ~= "" then
                            ownerName = d.Text:gsub("'s Booth", ""):gsub("'s Stand", "")
                            break
                        end
                    end
                end

                local bb = self.State.EspFolder:FindFirstChild(bbName)
                if not bb then
                    bb = Instance.new("BillboardGui")
                    bb.Name = bbName
                    bb.Size = UDim2.new(0, 115, 0, 22)
                    bb.AlwaysOnTop = true
                    bb.MaxDistance = 0
                    bb.LightInfluence = 0
                    bb.ResetOnSpawn = false
                    bb.StudsOffset = Vector3.new(0, 4.5, 0)
                    bb.Adornee = rootPart
                    bb.Parent = self.State.EspFolder

                    local frame = Instance.new("Frame")
                    frame.Name = "BgFrame"
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
                    frame.BackgroundTransparency = 0.2
                    frame.Parent = bb
                    self:Corner(frame, 5)
                    self:Stroke(frame, Color3.fromRGB(50, 50, 70), 1)

                    local icon = Instance.new("ImageLabel")
                    icon.Name = "UserIcon"
                    icon.Size = UDim2.new(0, 12, 0, 12)
                    icon.Position = UDim2.new(0, 5, 0.5, -6)
                    icon.BackgroundTransparency = 1
                    icon.Image = Icons.User
                    icon.ImageColor3 = Color3.fromRGB(180, 180, 210)
                    icon.Parent = frame

                    local title = Instance.new("TextLabel")
                    title.Name = "OwnerTitle"
                    title.Size = UDim2.new(1, -22, 1, 0)
                    title.Position = UDim2.new(0, 20, 0, 0)
                    title.BackgroundTransparency = 1
                    title.Font = Enum.Font.GothamMedium
                    title.Text = ownerName
                    title.TextColor3 = Color3.fromRGB(220, 220, 240)
                    title.TextSize = 10
                    title.TextXAlignment = Enum.TextXAlignment.Left
                    title.Parent = frame
                else
                    bb.Adornee = rootPart
                    bb.MaxDistance = 0
                    local frame = bb:FindFirstChild("BgFrame") or bb:FindFirstChildOfClass("Frame")
                    if frame then
                        local title = frame:FindFirstChild("OwnerTitle") or frame:FindFirstChildOfClass("TextLabel")
                        if title and title.Text ~= ownerName then
                            title.Text = ownerName
                        end
                    end
                end
            end
        end
    end

    for _, ch in ipairs(self.State.EspFolder:GetChildren()) do
        if ch.Name:find("StandOwner_") and not activeNames[ch.Name] then
            ch:Destroy()
        end
    end
end

local ItemInfoModule = nil
pcall(function()
    ItemInfoModule = require(Hub.Services.ReplicatedStorage.Shared.ItemInfo)
end)

local function FormatNumber(n)
    if not n or type(n) ~= "number" then return tostring(n or 0) end
    local str = tostring(math.floor(n))
    local k
    while true do
        str, k = string.gsub(str, "^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
    end
    return str
end

function Hub:ResolveItemDisplayName(rawName, itemType)
    if not rawName or rawName == "" then return "" end
    if not ItemInfoModule then
        pcall(function()
            ItemInfoModule = require(Hub.Services.ReplicatedStorage.Shared.ItemInfo)
        end)
    end
    if not ItemInfoModule then return rawName end
    if itemType and ItemInfoModule[itemType] and ItemInfoModule[itemType][rawName] then
        local entry = ItemInfoModule[itemType][rawName]
        return entry.DisplayName or entry.Name or rawName
    end
    for _, cat in ipairs({"Emote", "Sword", "Explosion", "Ability", "Booth", "Character", "Title"}) do
        if ItemInfoModule[cat] and ItemInfoModule[cat][rawName] then
            local entry = ItemInfoModule[cat][rawName]
            return entry.DisplayName or entry.Name or rawName
        end
    end
    return rawName
end

function Hub:MatchesWatchlist(dispName, rawName)
    if not self.Config.WatchlistItems or #self.Config.WatchlistItems == 0 then
        return false
    end
    local cleanDisp = dispName and dispName:lower():gsub("%s+", " ") or ""
    local cleanRaw = rawName and rawName:lower():gsub("%s+", " ") or ""
    for _, watched in ipairs(self.Config.WatchlistItems) do
        local query = tostring(watched):lower():gsub("%s+", " "):match("^%s*(.-)%s*$")
        if query and query ~= "" then
            if cleanDisp ~= "" and (cleanDisp == query or string.find(cleanDisp, query, 1, true)) then
                return true, watched
            end
            if cleanRaw ~= "" and (cleanRaw == query or string.find(cleanRaw, query, 1, true)) then
                return true, watched
            end
        end
    end
    return false
end

-- 5. ESP Watchlist Items (Dynamic Billboard above Booths listing Item Name, Amount, Price)
function Hub:UpdateWatchlistEsp(enabled)
    if not self.State.EspFolder then return end

    if not enabled or not self.Config.WatchlistEsp or not self.Config.WatchlistItems or #self.Config.WatchlistItems == 0 then
        for _, ch in ipairs(self.State.EspFolder:GetChildren()) do
            if ch.Name:find("WatchlistStand_") then
                ch:Destroy()
            end
        end
        return
    end

    local stands = Hub.Services.Workspace:FindFirstChild("Spawn") and Hub.Services.Workspace.Spawn:FindFirstChild("Hub") and Hub.Services.Workspace.Spawn.Hub:FindFirstChild("Stands")
    if not stands then return end

    local bc = nil
    pcall(function()
        bc = require(Hub.Services.ReplicatedStorage.Controllers.Booth.BoothController)
    end)
    if not bc or not bc.BoothListings then return end
    local allListings = bc.BoothListings:Get()
    if not allListings then return end

    local activeWatchBillboards = {}

    for i, s in ipairs(stands:GetChildren()) do
        local ownerId = s:GetAttribute("Owner")
        local bbName = "WatchlistStand_" .. tostring(i)

        if ownerId and ownerId ~= 0 and allListings[tostring(ownerId)] then
            local userListings = allListings[tostring(ownerId)]
            local matching = {}

            for listId, itemData in pairs(userListings) do
                local rawName = itemData.ItemName or (itemData.Item and itemData.Item.Name) or ""
                local dispName = self:ResolveItemDisplayName(rawName, itemData.Type)
                if self:MatchesWatchlist(dispName, rawName) then
                    table.insert(matching, {
                        Name = dispName ~= "" and dispName or rawName,
                        Amount = itemData.Amount or 1,
                        Price = itemData.Price or 0
                    })
                end
            end

            if #matching > 0 then
                local rootPart = s:FindFirstChild("Root") or s:FindFirstChildOfClass("BasePart")
                if rootPart then
                    activeWatchBillboards[bbName] = true

                    -- Sort by price ascending
                    table.sort(matching, function(a, b)
                        return (a.Price or 0) < (b.Price or 0)
                    end)

                    local maxDisplay = 6
                    local totalMatches = #matching
                    local displayRows = math.min(totalMatches, maxDisplay)
                    local bbHeight = 22 + (displayRows * 18) + (totalMatches > maxDisplay and 14 or 0) + 6
                    local bbWidth = 230

                    local bb = self.State.EspFolder:FindFirstChild(bbName)
                    if not bb then
                        bb = Instance.new("BillboardGui")
                        bb.Name = bbName
                        bb.Size = UDim2.new(0, bbWidth, 0, bbHeight)
                        bb.AlwaysOnTop = true
                        bb.MaxDistance = 0
                        bb.LightInfluence = 0
                        bb.ResetOnSpawn = false
                        bb.StudsOffset = Vector3.new(0, 7.2, 0)
                        bb.Adornee = rootPart
                        bb.Parent = self.State.EspFolder

                        local frame = Instance.new("Frame")
                        frame.Name = "BgFrame"
                        frame.Size = UDim2.new(1, 0, 1, 0)
                        frame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
                        frame.BackgroundTransparency = 0.12
                        frame.BorderSizePixel = 0
                        frame.Parent = bb
                        self:Corner(frame, 6)
                        self:Stroke(frame, Color3.fromRGB(255, 205, 50), 1.5)

                        local header = Instance.new("Frame")
                        header.Name = "Header"
                        header.Size = UDim2.new(1, 0, 0, 20)
                        header.BackgroundTransparency = 1
                        header.Parent = frame

                        local badge = Instance.new("TextLabel")
                        badge.Name = "Badge"
                        badge.Size = UDim2.new(1, -12, 1, 0)
                        badge.Position = UDim2.new(0, 8, 0, 2)
                        badge.BackgroundTransparency = 1
                        badge.Font = Enum.Font.GothamBold
                        badge.Text = "🎯 НАЙДЕНО В ЛАВКЕ"
                        badge.TextColor3 = Color3.fromRGB(255, 215, 0)
                        badge.TextSize = 10
                        badge.TextXAlignment = Enum.TextXAlignment.Left
                        badge.Parent = header

                        local itemsContainer = Instance.new("Frame")
                        itemsContainer.Name = "ItemsContainer"
                        itemsContainer.Size = UDim2.new(1, -16, 1, -24)
                        itemsContainer.Position = UDim2.new(0, 8, 0, 20)
                        itemsContainer.BackgroundTransparency = 1
                        itemsContainer.Parent = frame

                        local listLayout = Instance.new("UIListLayout")
                        listLayout.Name = "Layout"
                        listLayout.FillDirection = Enum.FillDirection.Vertical
                        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                        listLayout.Padding = UDim.new(0, 2)
                        listLayout.Parent = itemsContainer
                    else
                        bb.Adornee = rootPart
                        bb.Size = UDim2.new(0, bbWidth, 0, bbHeight)
                    end

                    local frame = bb:FindFirstChild("BgFrame")
                    local itemsContainer = frame and frame:FindFirstChild("ItemsContainer")
                    if itemsContainer then
                        for _, child in ipairs(itemsContainer:GetChildren()) do
                            if child:IsA("TextLabel") then
                                child:Destroy()
                            end
                        end

                        for idx = 1, displayRows do
                            local item = matching[idx]
                            local row = Instance.new("TextLabel")
                            row.Name = "Row_" .. tostring(idx)
                            row.LayoutOrder = idx
                            row.Size = UDim2.new(1, 0, 0, 16)
                            row.BackgroundTransparency = 1
                            row.Font = Enum.Font.GothamMedium
                            row.RichText = true
                            row.Text = string.format("<b><font color=\"#FFFFFF\">%s</font></b> <font color=\"#80C0FF\">x%s</font>  <font color=\"#FFD700\"><b>%s 🪙</b></font>",
                                item.Name,
                                tostring(item.Amount),
                                FormatNumber(item.Price)
                            )
                            row.TextSize = 11
                            row.TextXAlignment = Enum.TextXAlignment.Left
                            row.TextStrokeTransparency = 0.5
                            row.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            row.Parent = itemsContainer
                        end

                        if totalMatches > maxDisplay then
                            local moreRow = Instance.new("TextLabel")
                            moreRow.Name = "MoreRow"
                            moreRow.LayoutOrder = maxDisplay + 1
                            moreRow.Size = UDim2.new(1, 0, 0, 14)
                            moreRow.BackgroundTransparency = 1
                            moreRow.Font = Enum.Font.GothamMedium
                            moreRow.Text = string.format("... и еще %d предм.", totalMatches - maxDisplay)
                            moreRow.TextColor3 = Color3.fromRGB(180, 180, 195)
                            moreRow.TextSize = 9
                            moreRow.TextXAlignment = Enum.TextXAlignment.Left
                            moreRow.Parent = itemsContainer
                        end
                    end
                end
            end
        end
    end

    for _, ch in ipairs(self.State.EspFolder:GetChildren()) do
        if ch.Name:find("WatchlistStand_") and not activeWatchBillboards[ch.Name] then
            ch:Destroy()
        end
    end
end

-- Safe Real-time ESP & Booth Watcher (Passive polling without hooking workspace instances)
function Hub:SetupEspUpdater()
    if self.State.EspWatcherRunning then return end
    self.State.EspWatcherRunning = true

    -- Real-time BoothListings:OnChange connection for instant watchlist updates
    if not self.State.WatchlistListingConn then
        pcall(function()
            local bc = require(Hub.Services.ReplicatedStorage.Controllers.Booth.BoothController)
            if bc and bc.BoothListings and bc.BoothListings.OnChange then
                self.State.WatchlistListingConn = bc.BoothListings:OnChange(function()
                    if self.Config.WatchlistEsp then
                        task.spawn(function()
                            self:UpdateWatchlistEsp(true)
                        end)
                    end
                end)
            end
        end)
    end

    task.spawn(function()
        while task.wait(3.5) do
            if self.Config.EspMyBooth then
                pcall(function() self:UpdateMyBoothEsp(true) end)
            end
            if self.Config.MyBoothTracer then
                pcall(function() self:UpdateMyBoothTracer(true) end)
            end
            if self.Config.EspBooths then
                pcall(function() self:UpdateBoothsEsp(true) end)
            end
            if self.Config.WatchlistEsp then
                pcall(function() self:UpdateWatchlistEsp(true) end)
            end
            if self.Config.AutoClaimBooth and not self:HasClaimedBooth() then
                pcall(function() self:ClaimNearestBooth() end)
            end
        end
    end)
end

-- Helper: Get Booth Item under Mouse or Click Position (100% passive, supports all skins & booth views)
function Hub:GetBoothItemAtPosition(posX, posY)
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local guis = pg:GetGuiObjectsAtPosition(posX, posY)
    for _, g in ipairs(guis) do
        local current = g
        for _ = 1, 7 do
            if not current or current == pg then break end
            local lbl = current:FindFirstChild("ItemName", true)
            if lbl and lbl:IsA("TextLabel") and lbl.Text ~= "" and lbl.Text ~= "ItemName" and lbl.Text ~= "Booth Name" then
                local rawText = lbl.Text:gsub("<[^>]->", ""):gsub("[\r\n\t]+", " ")
                rawText = rawText:gsub("%s*%(x%d+%)", ""):gsub("%s*%[.-%]", "")
                rawText = rawText:match("^%s*(.-)%s*$") or rawText
                if rawText ~= "" then
                    return rawText
                end
            end
            current = current.Parent
        end
    end
    return nil
end

function Hub:GetHoveredBoothItem()
    local mousePos = self.Services.UserInputService:GetMouseLocation()
    return self:GetBoothItemAtPosition(mousePos.X, mousePos.Y)
end

-- 5. Passive Item Selection Tracker on Booths (Zero interference with game purchase buttons)
function Hub:SetupBoothItemTracker()
    local conn = self.Services.UserInputService.InputEnded:Connect(function(input, gpe)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local itemName = self:GetBoothItemAtPosition(input.Position.X, input.Position.Y)
            if itemName and itemName ~= "" then
                self.State.LastSelectedBoothItem = itemName
                self:Notify("Index", "Выбран: " .. itemName)
            end
        end
    end)
    table.insert(self.State.Connections, conn)
end

-- Helper: Fast Load & Anti-Freeze (Skips intro cutscenes, blackouts & popups)
function Hub:ApplyFastLoad()
    if not self.Config.FastLoad then return end

    local function dismissCutscenes(pg)
        if not pg then return end

        -- 1. Remove native loading screens safely
        pcall(function()
            game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()
            local rf = game:GetService("ReplicatedFirst")
            if rf:FindFirstChild("TeleportUI") then
                rf.TeleportUI.Enabled = false
            end
        end)

        -- 2. SkipCutscene button (ONLY fire if enabled and visible to prevent click sound spam!)
        local sc = pg:FindFirstChild("SkipCutscene")
        if sc and sc.Enabled and sc:FindFirstChild("Skip") and sc.Skip.Visible then
            pcall(function()
                if firesignal then
                    firesignal(sc.Skip.Activated)
                else
                    for _, c in ipairs(getconnections(sc.Skip.Activated)) do c:Fire() end
                end
            end)
            pcall(function() sc.Enabled = false end)
        end

        -- 3. Cutscene with Skip button (ONLY fire if enabled and visible!)
        local cs = pg:FindFirstChild("Cutscene")
        if cs and cs.Enabled and cs:FindFirstChild("Skip") and cs.Skip.Visible then
            pcall(function()
                if firesignal then
                    firesignal(cs.Skip.Activated)
                else
                    for _, c in ipairs(getconnections(cs.Skip.Activated)) do c:Fire() end
                end
            end)
            pcall(function() cs.Enabled = false end)
        end

        -- 4. CutsceneOutside & CutsceneWaiting
        local co = pg:FindFirstChild("CutsceneOutside")
        if co and co.Enabled then co.Enabled = false end
        local cw = pg:FindFirstChild("CutsceneWaiting")
        if cw and cw.Enabled then cw.Enabled = false end

        -- 5. Tutorial & Popups
        local tsp = pg:FindFirstChild("TutorialSkipPrompt")
        if tsp and tsp.Enabled then tsp.Enabled = false end
        local dlg = pg:FindFirstChild("Dialogue")
        if dlg and dlg.Enabled then dlg.Enabled = false end
        local wb = pg:FindFirstChild("WelcomeBack")
        if wb and wb.Enabled then wb.Enabled = false end
        local nwb = pg:FindFirstChild("NewWelcomeBack")
        if nwb and nwb.Enabled then nwb.Enabled = false end
        local rtp = pg:FindFirstChild("RegionalTournamentPopups")
        if rtp and rtp.Enabled then rtp.Enabled = false end

        -- 6. Blackouts (NEVER touch IndexScreenBlackout while searching sellers!)
        if not self.State.IsSearchingSellers then
            local isb = pg:FindFirstChild("IndexScreenBlackout")
            if isb and isb.Enabled then
                local index = pg:FindFirstChild("Index")
                if not index or not index.Enabled then
                    isb.Enabled = false
                end
            end
        end
        local rpb = pg:FindFirstChild("RobloxPurchaseScreenBlackout")
        if rpb and rpb.Enabled then rpb.Enabled = false end

        -- 7. Restore Camera if frozen in cinematic/scriptable
        pcall(function()
            local cam = Hub.Services.Workspace.CurrentCamera
            if cam and cam.CameraType == Enum.CameraType.Scriptable and LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    cam.CameraType = Enum.CameraType.Custom
                    cam.CameraSubject = hum
                end
            end
        end)

        -- 8. Disable heavy post-processing effects for instant performance
        pcall(function()
            local lighting = Hub.Services.Lighting
            lighting.GlobalShadows = false
            for _, eff in ipairs(lighting:GetChildren()) do
                if eff:IsA("BlurEffect") or eff:IsA("BloomEffect") or eff:IsA("DepthOfFieldEffect") or eff:IsA("ColorCorrectionEffect") then
                    eff.Enabled = false
                end
            end
        end)

        -- 9. Ultra Fast Load: Strip particles, beams, water waves, leaderboards
        if self.Config.UltraFastLoad then
            self:ApplyUltraFastLoad(true)
        end
    end

    -- Run immediate pass
    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        dismissCutscenes(pg)
    end)

    -- Persistent Watcher: fast pass during first 8s + ChildAdded hook
    if not self.State.FastLoadWatcher then
        self.State.FastLoadWatcher = true

        -- Hook PlayerGui.ChildAdded
        pcall(function()
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                local conn = pg.ChildAdded:Connect(function(child)
                    if self.Config.FastLoad then
                        task.defer(function()
                            dismissCutscenes(pg)
                        end)
                    end
                end)
                table.insert(self.State.Connections, conn)
            end
        end)

        -- Polling loop (slow and silent after initial 8 seconds)
        task.spawn(function()
            local startTime = tick()
            while true do
                local elapsed = tick() - startTime
                local waitTime = (elapsed < 8) and 0.25 or 2.0
                task.wait(waitTime)

                if self.Config.FastLoad then
                    pcall(function()
                        local pg = LocalPlayer:FindFirstChild("PlayerGui")
                        dismissCutscenes(pg)
                    end)
                end
            end
        end)
    end
end

-- Helper: Ultra Fast Load & FPS Booster (Strips particles, beams, shaders, leaderboards for max FPS & instant load)
function Hub:ApplyUltraFastLoad(enable)
    if enable then
        if self.State.UltraFastLoadActive then return end
        self.State.UltraFastLoadActive = true

        pcall(function()
            local ws = Hub.Services.Workspace
            local lighting = Hub.Services.Lighting

            -- 1. Lighting post-processing
            if self.State.StrippedEffects.Shadows == nil then
                self.State.StrippedEffects.Shadows = lighting.GlobalShadows
            end
            lighting.GlobalShadows = false

            for _, fx in ipairs(lighting:GetChildren()) do
                if fx:IsA("PostProcessEffect") then
                    if self.State.StrippedEffects.Lighting[fx] == nil then
                        self.State.StrippedEffects.Lighting[fx] = fx.Enabled
                    end
                    fx.Enabled = false
                elseif fx:IsA("Atmosphere") then
                    if self.State.StrippedEffects.Lighting[fx] == nil then
                        self.State.StrippedEffects.Lighting[fx] = fx.Density
                    end
                    fx.Density = 0
                end
            end

            -- 2. Workspace Particles, Beams, Trails, Fire, Smoke, Sparkles
            for _, d in ipairs(ws:GetDescendants()) do
                if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") or d:IsA("Fire") or d:IsA("Smoke") or d:IsA("Sparkles") then
                    if self.State.StrippedEffects.Particles[d] == nil then
                        self.State.StrippedEffects.Particles[d] = d.Enabled
                    end
                    d.Enabled = false
                end
            end

            -- 3. Leaderboards (11,400 decorative parts in Plaza)
            local lb = ws:FindFirstChild("Leaderboards")
            if lb and lb.Parent == ws then
                self.State.StrippedEffects.Leaderboard = lb
                lb.Parent = nil
            end

            -- 4. Terrain water waves & reflections
            local terrain = ws.Terrain
            if terrain then
                if self.State.StrippedEffects.Terrain.WaterWaveSpeed == nil then
                    self.State.StrippedEffects.Terrain.WaterWaveSpeed = terrain.WaterWaveSpeed
                    self.State.StrippedEffects.Terrain.WaterWaveSize = terrain.WaterWaveSize
                    self.State.StrippedEffects.Terrain.WaterReflectance = terrain.WaterReflectance
                end
                terrain.WaterWaveSpeed = 0
                terrain.WaterWaveSize = 0
                terrain.WaterReflectance = 0
            end

            -- 5. Mute background 3D Plaza music/ambient sounds (keep UI sounds)
            for _, s in ipairs(ws:GetDescendants()) do
                if s:IsA("Sound") and s.Playing and s.Looped then
                    if self.State.StrippedEffects.Sounds[s] == nil then
                        self.State.StrippedEffects.Sounds[s] = s.Volume
                    end
                    s.Volume = 0
                end
            end
        end)
    else
        if not self.State.UltraFastLoadActive then return end
        self.State.UltraFastLoadActive = false

        pcall(function()
            local ws = Hub.Services.Workspace
            local lighting = Hub.Services.Lighting

            -- 1. Restore Lighting
            if self.State.StrippedEffects.Shadows ~= nil then
                lighting.GlobalShadows = self.State.StrippedEffects.Shadows
            end
            for fx, orig in pairs(self.State.StrippedEffects.Lighting or {}) do
                if fx and fx.Parent then
                    if fx:IsA("PostProcessEffect") then
                        fx.Enabled = orig
                    elseif fx:IsA("Atmosphere") then
                        fx.Density = orig
                    end
                end
            end

            -- 2. Restore Particles
            for d, orig in pairs(self.State.StrippedEffects.Particles or {}) do
                if d and d.Parent then d.Enabled = orig end
            end

            -- 3. Restore Leaderboards
            if self.State.StrippedEffects.Leaderboard and self.State.StrippedEffects.Leaderboard.Parent == nil then
                self.State.StrippedEffects.Leaderboard.Parent = ws
            end

            -- 4. Restore Terrain
            local terrain = ws.Terrain
            if terrain and self.State.StrippedEffects.Terrain.WaterWaveSpeed ~= nil then
                terrain.WaterWaveSpeed = self.State.StrippedEffects.Terrain.WaterWaveSpeed
                terrain.WaterWaveSize = self.State.StrippedEffects.Terrain.WaterWaveSize
                terrain.WaterReflectance = self.State.StrippedEffects.Terrain.WaterReflectance
            end

            -- 5. Restore Sounds
            for s, orig in pairs(self.State.StrippedEffects.Sounds or {}) do
                if s and s.Parent then s.Volume = orig end
            end

            -- Reset storage
            self.State.StrippedEffects = {
                Particles = {},
                Lighting = {},
                Terrain = {},
                Sounds = {},
                Leaderboard = nil,
            }
        end)
    end
end

-- Helper: Match all current listings against Watchlist & TeleportItem
function Hub:CollectMatchingListings(allListings)
    local watchItems = {}
    if self.Config.WatchlistItems then
        for _, w in ipairs(self.Config.WatchlistItems) do
            table.insert(watchItems, w)
        end
    end
    local tpItem = self.Config.TeleportItemName
    if tpItem and tpItem:gsub("%s+", "") ~= "" then
        local exists = false
        for _, w in ipairs(watchItems) do
            if w:lower() == tpItem:lower() then exists = true break end
        end
        if not exists then
            table.insert(watchItems, tpItem)
        end
    end

    local foundList = {}
    if not allListings or #watchItems == 0 then
        return foundList, watchItems
    end

    for ownerId, items in pairs(allListings) do
        local sellerName = nil
        local pl = Hub.Services.Players:GetPlayerByUserId(tonumber(ownerId))
        if pl then
            sellerName = pl.Name
        else
            pcall(function()
                sellerName = Hub.Services.Players:GetNameFromUserIdAsync(tonumber(ownerId))
            end)
        end
        sellerName = sellerName or ("ID:" .. tostring(ownerId))

        for listId, itemData in pairs(items) do
            local rawName = itemData.ItemName or (itemData.Item and itemData.Item.Name) or ""
            local dispName = self:ResolveItemDisplayName(rawName, itemData.Type)
            local matched, query = self:MatchesWatchlist(dispName, rawName)
            if matched then
                table.insert(foundList, {
                    Id = tostring(ownerId) .. "_" .. tostring(listId),
                    Name = dispName ~= "" and dispName or rawName,
                    Amount = itemData.Amount or 1,
                    Price = itemData.Price or 0,
                    Seller = sellerName
                })
            end
        end
    end

    table.sort(foundList, function(a, b)
        return (a.Price or 0) < (b.Price or 0)
    end)

    return foundList, watchItems
end

-- Helper: Top Banner Notification on Server Join / Rescan for Watchlist items
function Hub:ShowJoinServerBanner(isManualRescan)
    task.spawn(function()
        pcall(function()
            local gethui = gethui or function() return game:GetService("CoreGui") end
            local parent = gethui()
            if not parent then return end

            local old = parent:FindFirstChild("DynamicPlazaTopBanner")
            if old then old:Destroy() end

            local gui = Instance.new("ScreenGui")
            gui.Name = "DynamicPlazaTopBanner"
            gui.ResetOnSpawn = false
            gui.DisplayOrder = 9999
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Parent = parent

            local banner = Instance.new("Frame")
            banner.Name = "Banner"
            banner.Size = UDim2.new(0, 560, 0, 52)
            banner.Position = UDim2.new(0.5, 0, 0, -70)
            banner.AnchorPoint = Vector2.new(0.5, 0)
            banner.BackgroundColor3 = Color3.fromRGB(15, 17, 24)
            banner.BackgroundTransparency = 0.08
            banner.BorderSizePixel = 0
            banner.Parent = gui

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = banner

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(80, 140, 255)
            stroke.Thickness = 1.5
            stroke.Parent = banner

            local title = Instance.new("TextLabel")
            title.Name = "Title"
            title.Size = UDim2.new(1, -40, 0, 20)
            title.Position = UDim2.new(0, 12, 0, 6)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = isManualRescan and "🔍 ПЕРЕСКАНИРОВАНИЕ ВИТРИН..." or "⏳ СКАНИРОВАНИЕ ВИТРИН СЕРВЕРА..."
            title.TextColor3 = Color3.fromRGB(120, 180, 255)
            title.TextSize = 12
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = banner

            local content = Instance.new("TextLabel")
            content.Name = "Content"
            content.Size = UDim2.new(1, -24, 0, 20)
            content.Position = UDim2.new(0, 12, 0, 26)
            content.BackgroundTransparency = 1
            content.Font = Enum.Font.GothamMedium
            content.Text = "Подключение к репликации рынка и проверка всех витрин..."
            content.TextColor3 = Color3.fromRGB(190, 195, 210)
            content.TextSize = 11.5
            content.TextXAlignment = Enum.TextXAlignment.Left
            content.Parent = banner

            local closeBtn = Instance.new("TextButton")
            closeBtn.Name = "CloseBtn"
            closeBtn.Size = UDim2.new(0, 20, 0, 20)
            closeBtn.Position = UDim2.new(1, -26, 0, 6)
            closeBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
            closeBtn.Font = Enum.Font.GothamBold
            closeBtn.Text = "✕"
            closeBtn.TextColor3 = Color3.fromRGB(170, 175, 190)
            closeBtn.TextSize = 11
            closeBtn.Parent = banner

            local cCorner = Instance.new("UICorner")
            cCorner.CornerRadius = UDim.new(0, 4)
            cCorner.Parent = closeBtn

            closeBtn.MouseButton1Click:Connect(function()
                pcall(function() gui:Destroy() end)
            end)

            -- Slide down smoothly
            local ts = Hub.Services.TweenService
            pcall(function()
                ts:Create(banner, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, 0, 0, 14)
                }):Play()
            end)

            local bc = nil
            local allListings = nil
            local lastBooths = -1
            local lastChangeTime = tick()
            local startWait = tick()
            local maxWait = isManualRescan and 3.0 or 14.0
            local minWait = isManualRescan and 0.4 or 6.0
            local soundPlayed = false

            while (tick() - startWait < maxWait) and gui and gui.Parent do
                pcall(function()
                    bc = require(Hub.Services.ReplicatedStorage.Controllers.Booth.BoothController)
                    if bc and bc.BoothListings then
                        allListings = bc.BoothListings:Get()
                    end
                end)

                local currentBooths = 0
                local currentItems = 0
                if allListings then
                    for _, items in pairs(allListings) do
                        currentBooths = currentBooths + 1
                        for _, _ in pairs(items) do
                            currentItems = currentItems + 1
                        end
                    end
                end

                if currentBooths ~= lastBooths then
                    lastBooths = currentBooths
                    lastChangeTime = tick()
                end

                local foundList, watchItems = self:CollectMatchingListings(allListings)

                if #foundList > 0 then
                    -- Items found! Transform banner immediately to success state
                    stroke.Color = Color3.fromRGB(80, 220, 120)
                    title.TextColor3 = Color3.fromRGB(80, 220, 120)
                    title.Text = string.format("🎯 НА СЕРВЕРЕ НАЙДЕНО (%d ЛОТ.):", #foundList)

                    local maxRows = math.min(#foundList, 4)
                    local lines = {}
                    for i = 1, maxRows do
                        local f = foundList[i]
                        table.insert(lines, string.format("• %s | x%d | Продавец: %s | %d 🪙", f.Name, f.Amount, f.Seller, f.Price))
                    end
                    if #foundList > maxRows then
                        table.insert(lines, string.format("... и еще %d лотов на сервере", #foundList - maxRows))
                    end

                    content.Text = table.concat(lines, "\n")
                    content.TextColor3 = Color3.fromRGB(240, 240, 245)
                    content.Size = UDim2.new(1, -24, 0, (#lines * 18) + 4)

                    local newHeight = 32 + (#lines * 18) + 12
                    ts:Create(banner, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, 560, 0, newHeight)
                    }):Play()

                    if not soundPlayed then
                        soundPlayed = true
                        pcall(function()
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxassetid://1053296915"
                            sound.Volume = 0.55
                            sound.Parent = Hub.Services.SoundService
                            sound:Play()
                            game:GetService("Debris"):AddItem(sound, 3)
                        end)
                    end
                else
                    content.Text = string.format("Загружено витрин: %d | Предметов на рынке: %d...", currentBooths, currentItems)
                end

                -- Stabilization condition: Must wait at least minWait seconds, and check if booth count hasn't changed for 3.0s or full capacity reached
                local elapsed = tick() - startWait
                if elapsed >= minWait then
                    if currentBooths >= 26 or (currentBooths > 0 and (tick() - lastChangeTime >= 3.0)) then
                        break
                    end
                end

                task.wait(0.3)
            end

            if not gui or not gui.Parent then return end

            local finalFound, watchItems = self:CollectMatchingListings(allListings)
            if #finalFound > 0 then
                -- Keep visible for 25s
                task.delay(25, function()
                    if gui and gui.Parent then
                        pcall(function()
                            local t = ts:Create(banner, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                                Position = UDim2.new(0.5, 0, 0, -120)
                            })
                            t:Play()
                            t.Completed:Connect(function() gui:Destroy() end)
                        end)
                    end
                end)
            else
                stroke.Color = Color3.fromRGB(100, 110, 130)
                title.TextColor3 = Color3.fromRGB(180, 185, 200)
                title.Text = "ℹ️ ТОРГОВАЯ ПЛОЩАДКА: ВИТРИНЫ ПРОВЕРЕНЫ"
                if #watchItems == 0 then
                    content.Text = "Список Watchlist пуст. Введи название предмета в меню для отслеживания."
                else
                    content.Text = string.format("Проверено %d витрин. Искомых предметов из Watchlist не найдено.", lastBooths > 0 and lastBooths or 0)
                end
                content.TextColor3 = Color3.fromRGB(160, 165, 175)

                -- Keep visible for 10s (gives user time to read)
                task.delay(10, function()
                    if gui and gui.Parent then
                        pcall(function()
                            local t = ts:Create(banner, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                                Position = UDim2.new(0.5, 0, 0, -70)
                            })
                            t:Play()
                            t.Completed:Connect(function() gui:Destroy() end)
                        end)
                    end
                end)
            end
        end)
    end)
end

-- Helper: Permanent Live Observer for new booth listings while on server
function Hub:SetupBoothObserver()
    if self.State.BoothObserverSetup then return end
    self.State.BoothObserverSetup = true

    task.spawn(function()
        local bc = nil
        while not bc do
            pcall(function()
                bc = require(Hub.Services.ReplicatedStorage.Controllers.Booth.BoothController)
            end)
            if not bc or not bc.BoothListings then
                task.wait(0.5)
            end
        end

        pcall(function()
            if bc and bc.BoothListings and bc.BoothListings.OnChange then
                local conn = bc.BoothListings:OnChange(function(allListings)
                    local foundList = self:CollectMatchingListings(allListings)
                    local hasNew = false
                    for _, item in ipairs(foundList) do
                        if not self.State.NotifiedListings[item.Id] then
                            self.State.NotifiedListings[item.Id] = true
                            hasNew = true
                        end
                    end
                    if hasNew then
                        self:ShowJoinServerBanner(true)
                    end
                    if self.Config.WatchlistEsp then
                        pcall(function() self:UpdateWatchlistEsp() end)
                    end
                end)
                table.insert(self.State.Connections, conn)
            end
        end)
    end)
end

-- Helper: Auto-Teleport to Seller's Server via Index
function Hub:TeleportToSeller(targetItem)
    local itemName = targetItem or self.Config.TeleportItemName
    if not itemName or itemName:gsub("%s+", "") == "" then
        -- Check if player already opened an item in Index
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local prev = pg and pg:FindFirstChild("Index") and pg.Index:FindFirstChild("Main") and pg.Index.Main:FindFirstChild("Left") and pg.Index.Main.Left:FindFirstChild("MainLabel") and pg.Index.Main.Left.MainLabel:FindFirstChild("ItemPreview")
        if prev and prev.Visible and prev:FindFirstChild("ItemName") and prev.ItemName.Text ~= "" then
            itemName = prev.ItemName.Text
        else
            self:Notify("Teleport", "Введи название предмета для ТП или выбери его в Index!")
            return
        end
    end

    local cat, exactName = self:FindItemCategory(itemName)
    self:Notify("Teleport", "Поиск продавца для: " .. exactName .. " (" .. cat .. ")...")

    local okIdx, ic = pcall(function()
        return require(Hub.Services.ReplicatedStorage.Controllers.Trading.IndexController)
    end)

    if not okIdx or not ic then
        self:Notify("Teleport", "Ошибка контроллеров игры")
        return
    end

    self.State.IsSearchingSellers = true

    task.spawn(function()
        -- 1. Open Index and preview the item with (cat, exactName)
        pcall(function()
            ic:Open()
            ic:Preview(cat, exactName)
        end)

        task.wait(0.4)

        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local right = pg and pg:FindFirstChild("Index") and pg.Index:FindFirstChild("Main") and pg.Index.Main:FindFirstChild("Right")
        local btn = right and right:FindFirstChild("ShowSellers")

        if not btn then
            self.State.IsSearchingSellers = false
            self:Notify("Teleport", "Кнопка 'Find Seller' не найдена")
            return
        end

        -- 2. Safely trigger Find Seller via IndexController connection (bypassing Analytics kick)
        local fired = false
        pcall(function()
            for _, c in ipairs(getconnections(btn.Activated)) do
                local inf = debug.getinfo(c.Function)
                if inf and inf.source and inf.source:find("IndexController") then
                    fired = true
                    task.spawn(function()
                        pcall(c.Function)
                    end)
                end
            end
        end)
        if not fired and firesignal then
            pcall(function() firesignal(btn.Activated) end)
        end

        -- 3. Wait for search to complete naturally.
        -- DO NOT touch IndexScreenBlackout.Enabled! The game manages it!
        -- Search remote typically takes 3 to 12 seconds.
        local startTime = tick()
        local clicked = false
        local sawBlackout = false

        while (tick() - startTime < 22) and not clicked do
            task.wait(0.2)
            if pg then
                local isb = pg:FindFirstChild("IndexScreenBlackout")
                if isb and isb.Enabled then
                    sawBlackout = true
                end

                -- Check Prompt (Accept or Ok)
                local prompts = pg:FindFirstChild("Prompts")
                if prompts then
                    local accept = prompts:FindFirstChild("Accept")
                    if accept and accept.Visible then
                        local desc = accept:FindFirstChild("Description")
                        local descText = (desc and desc.Text or ""):lower()
                        if descText:find("seller") or descText:find("teleport") then
                            local yesBtn = accept:FindFirstChild("Yes")
                            if yesBtn and yesBtn.Visible then
                                pcall(function()
                                    if firesignal then
                                        firesignal(yesBtn.Activated)
                                    else
                                        for _, c in ipairs(getconnections(yesBtn.Activated)) do
                                            pcall(c.Function)
                                        end
                                    end
                                end)
                                clicked = true
                                self:Notify("Teleport", "✅ Продавец найден! Телепортация...")
                                break
                            end
                        end
                    end

                    local okPrompt = prompts:FindFirstChild("Ok")
                    if okPrompt and okPrompt.Visible then
                        local okDesc = okPrompt:FindFirstChild("Description")
                        local okText = (okDesc and okDesc.Text or ""):lower()
                        if okText:find("no users") or okText:find("no seller") or okText:find("seller") then
                            local okBtn = okPrompt:FindFirstChild("Ok") or okPrompt:FindFirstChild("Close")
                            if okBtn then
                                pcall(function()
                                    if firesignal then firesignal(okBtn.Activated) else for _, c in ipairs(getconnections(okBtn.Activated)) do pcall(c.Function) end end
                                end)
                            end
                            self:Notify("Teleport", "❌ Продавцы онлайн для этого предмета не найдены")
                            self.State.IsSearchingSellers = false
                            return
                        end
                    end
                end

                -- Check OnlineSellers list for cards with Join buttons
                local ml = right and right:FindFirstChild("MainLabel")
                local os = ml and ml:FindFirstChild("OnlineSellers")
                if os and os.Visible then
                    for _, card in ipairs(os:GetChildren()) do
                        if card:IsA("ImageButton") and card.Name ~= "Template" and card.Visible then
                            local joinBtn = card:FindFirstChild("Join") or card:FindFirstChildWhichIsA("ImageButton")
                            if joinBtn and joinBtn.Visible then
                                pcall(function()
                                    if firesignal then
                                        firesignal(joinBtn.Activated)
                                    else
                                        for _, c in ipairs(getconnections(joinBtn.Activated)) do
                                            pcall(c.Function)
                                        end
                                    end
                                end)
                                clicked = true
                                self:Notify("Teleport", "✅ Сервер найден! Подключение...")
                                break
                            end
                        end
                    end
                end

                -- If blackout finished after being seen, give a brief grace period (1.5s) for prompts
                if sawBlackout and (not isb or not isb.Enabled) and (tick() - startTime > 2.5) then
                    task.wait(1.5)
                    -- Re-check prompt one last time
                    if prompts then
                        local accept = prompts:FindFirstChild("Accept")
                        if accept and accept.Visible and accept:FindFirstChild("Yes") then
                            pcall(function()
                                if firesignal then
                                    firesignal(accept.Yes.Activated)
                                else
                                    for _, c in ipairs(getconnections(accept.Yes.Activated)) do pcall(c.Function) end
                                end
                            end)
                            clicked = true
                            self:Notify("Teleport", "✅ Продавец найден! Телепортация...")
                        end
                    end
                    break
                end
            end
        end

        self.State.IsSearchingSellers = false

        if not clicked then
            self:Notify("Teleport", "❌ Продавцы онлайн для этого предмета не найдены")
        end
    end)
end

-- Helper: Look up item category and exact name from game database (supports all 5,353 items)
function Hub:FindItemCategory(targetName)
    if not targetName or targetName == "" then
        return "Sword", targetName
    end

    local cleanName = targetName:gsub("<[^>]->", ""):gsub("[\r\n\t]+", " ")
    cleanName = cleanName:gsub("%s*%(x%d+%)", ""):gsub("%s*%[.-%]", "")
    cleanName = cleanName:match("^%s*(.-)%s*$") or cleanName
    local targetLower = cleanName:lower()

    local ok, ItemInfo = pcall(function()
        return require(Hub.Services.ReplicatedStorage.Shared.ItemInfo)
    end)

    if ok and type(ItemInfo) == "table" then
        local categories = {"Sword", "Emote", "Explosion", "Ability", "Booth", "Title"}

        -- 1. Exact key match
        for _, cat in ipairs(categories) do
            local items = ItemInfo[cat]
            if type(items) == "table" then
                if items[cleanName] then
                    local entry = items[cleanName]
                    local disp = type(entry) == "table" and (entry.DisplayName or entry.Name) or cleanName
                    return cat, disp
                end
                for k, v in pairs(items) do
                    if tostring(k):lower() == targetLower then
                        local disp = type(v) == "table" and (v.DisplayName or v.Name) or tostring(k)
                        return cat, disp
                    end
                    if type(v) == "table" and type(v.DisplayName) == "string" and v.DisplayName:lower() == targetLower then
                        return cat, v.DisplayName
                    end
                end
            end
        end

        -- 2. Check full ItemInfos catalog (all 5,353 items)
        local allItems = ItemInfo.ItemInfos
        if type(allItems) == "table" then
            for _, item in ipairs(allItems) do
                local n = item.Name and tostring(item.Name) or ""
                local d = item.DisplayName and tostring(item.DisplayName) or ""
                if n:lower() == targetLower or d:lower() == targetLower then
                    local realName = d ~= "" and d or n
                    local cat = "Sword"
                    if ItemInfo.Sword and ItemInfo.Sword[n] then cat = "Sword"
                    elseif ItemInfo.Explosion and ItemInfo.Explosion[n] then cat = "Explosion"
                    elseif ItemInfo.Emote and ItemInfo.Emote[n] then cat = "Emote"
                    elseif ItemInfo.Ability and ItemInfo.Ability[n] then cat = "Ability"
                    end
                    return cat, realName
                end
            end

            -- Substring / partial match on full catalog
            for _, item in ipairs(allItems) do
                local n = item.Name and tostring(item.Name) or ""
                local d = item.DisplayName and tostring(item.DisplayName) or ""
                local nLower, dLower = n:lower(), d:lower()
                if (dLower ~= "" and (dLower:find(targetLower, 1, true) or targetLower:find(dLower, 1, true)))
                    or (nLower ~= "" and (nLower:find(targetLower, 1, true) or targetLower:find(nLower, 1, true))) then
                    local realName = d ~= "" and d or n
                    local cat = "Sword"
                    if ItemInfo.Sword and ItemInfo.Sword[n] then cat = "Sword"
                    elseif ItemInfo.Explosion and ItemInfo.Explosion[n] then cat = "Explosion"
                    elseif ItemInfo.Emote and ItemInfo.Emote[n] then cat = "Emote"
                    elseif ItemInfo.Ability and ItemInfo.Ability[n] then cat = "Ability"
                    end
                    return cat, realName
                end
            end
        end
    end

    return "Sword", cleanName
end

-- 6. Close Isolated Index Statistics cleanly
function Hub:CloseIndexStats()
    self.State.InStatsMode = false

    local okRap, RAPChartController = pcall(function()
        return require(Hub.Services.ReplicatedStorage.Controllers.Trading.RAPChartController)
    end)
    local okIdx, IndexController = pcall(function()
        return require(Hub.Services.ReplicatedStorage.Controllers.Trading.IndexController)
    end)

    pcall(function()
        if okRap and RAPChartController then
            RAPChartController:Close("Index")
        end
    end)
    pcall(function()
        if okIdx and IndexController and type(IndexController.SetPage) == "function" then
            IndexController:SetPage("Sword")
        end
        if okIdx and IndexController and type(IndexController.Close) == "function" then
            IndexController:Close()
        end
    end)
    pcall(function()
        local cam = Hub.Services.Workspace.CurrentCamera
        local indexModel = cam and cam:FindFirstChild("Index")
        if indexModel then
            indexModel:Destroy()
        end
        if cam then
            cam.CameraType = Enum.CameraType.Custom
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                cam.CameraSubject = LocalPlayer.Character.Humanoid
            end
        end
    end)

    local indexGui = LocalPlayer.PlayerGui:FindFirstChild("Index")
    if indexGui then
        indexGui.Enabled = false
        indexGui.DisplayOrder = 0

        pcall(function()
            local main = indexGui:FindFirstChild("Main")
            if main then
                main.BackgroundTransparency = 1
                main.Visible = true
                if main:FindFirstChild("Right") then main.Right.Visible = true end
                if main:FindFirstChild("Close") then main.Close.Visible = true end
                local left = main:FindFirstChild("Left")
                local ml = left and left:FindFirstChild("MainLabel")
                if ml then
                    ml.ImageTransparency = 0
                    for _, c in ipairs(ml:GetChildren()) do
                        if c:IsA("GuiObject") and c.Name ~= "RapChart" and c.Name ~= "UIAspectRatioConstraint" then
                            if c.Name == "ItemPreview" then
                                c.Visible = false
                            else
                                c.Visible = true
                            end
                        end
                    end
                    local rc = ml:FindFirstChild("RapChart")
                    if rc then
                        rc.Visible = false
                        local frame = rc:FindFirstChild("Frame")
                        if frame then
                            if frame:FindFirstChild("BackButton") then
                                frame.BackButton.Visible = true
                            end
                            if frame:FindFirstChild("CustomCloseBtn") then
                                frame.CustomCloseBtn.Visible = false
                            end
                            if frame:FindFirstChild("CustomDarkBg") then
                                frame.CustomDarkBg.Visible = false
                            end
                        end
                    end
                end
            end
        end)
    end
end

-- 7. Open Selected Item in Index (Opens isolated RAP Chart with snug dark background)
function Hub:OpenSelectedItemInIndex(overrideItem)
    -- 1. Check currently hovered item on screen
    local itemName = overrideItem or self:GetHoveredBoothItem()

    -- 2. Fallback to last selected booth item
    if not itemName or itemName == "" then
        itemName = self.State.LastSelectedBoothItem
    end

    -- 3. Fallback to any visible item in open PlayersBooth / EditBooth
    if not itemName or itemName == "" then
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local boothGui = pg and pg:FindFirstChild("Booth")
        if boothGui then
            local pb = boothGui:FindFirstChild("PlayersBooth")
            if pb and pb.Visible then
                for _, d in ipairs(pb:GetDescendants()) do
                    if d:IsA("TextLabel") and d.Name == "ItemName" and d.Text ~= "" and d.Text ~= "ItemName" then
                        itemName = d.Text
                        break
                    end
                end
            end
        end
    end

    if not itemName or itemName == "" then
        self:Notify("Index", "Наведи и нажми бинд!")
        return
    end

    local cat, exactName = self:FindItemCategory(itemName)

    local okRap, RAPChartController = pcall(function()
        return require(Hub.Services.ReplicatedStorage.Controllers.Trading.RAPChartController)
    end)

    if okRap and RAPChartController and type(RAPChartController.Render) == "function" then
        RAPChartController:Render("Index", cat, Hub.Services.HttpService:JSONEncode({{"Name", exactName}}))
    end

    self.State.InStatsMode = true

    local indexGui = LocalPlayer.PlayerGui:FindFirstChild("Index")
    if indexGui and indexGui:FindFirstChild("Main") then
        indexGui.DisplayOrder = 1000
        indexGui.Enabled = true

        local main = indexGui.Main
        main.Visible = true
        main.BackgroundTransparency = 1
        if main:FindFirstChild("Right") then main.Right.Visible = false end
        if main:FindFirstChild("Close") then main.Close.Visible = false end

        local left = main:FindFirstChild("Left")
        local ml = left and left:FindFirstChild("MainLabel")
        if ml then
            ml.ImageTransparency = 1

            for _, c in ipairs(ml:GetChildren()) do
                if c:IsA("GuiObject") and c.Name ~= "RapChart" and c.Name ~= "UIAspectRatioConstraint" then
                    c.Visible = false
                end
            end
            local rc = ml:FindFirstChild("RapChart")
            if rc then
                rc.Visible = true
                local frame = rc:FindFirstChild("Frame")
                if frame then
                    -- 1. Custom Solid Dark Card Background (Snug ~6px top padding, no large forehead)
                    local darkBg = frame:FindFirstChild("CustomDarkBg")
                    if not darkBg then
                        darkBg = Instance.new("Frame")
                        darkBg.Name = "CustomDarkBg"
                        darkBg.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
                        darkBg.BackgroundTransparency = 0.04
                        darkBg.BorderSizePixel = 0
                        darkBg.ZIndex = 0

                        local corner = Instance.new("UICorner")
                        corner.CornerRadius = UDim.new(0, 12)
                        corner.Parent = darkBg

                        local stroke = Instance.new("UIStroke")
                        stroke.Color = Color3.fromRGB(48, 50, 68)
                        stroke.Thickness = 1.5
                        stroke.Parent = darkBg

                        darkBg.Parent = frame
                    end
                    darkBg.Position = UDim2.new(-0.04, 0, -0.04, 0)
                    darkBg.Size = UDim2.new(1.08, 0, 1.14, 0)
                    darkBg.Visible = true

                    -- 2. Hide BackButton arrow
                    local backBtn = frame:FindFirstChild("BackButton")
                    if backBtn then
                        backBtn.Visible = false
                    end

                    -- 3. Custom Close Button [X]
                    local closeBtn = frame:FindFirstChild("CustomCloseBtn")
                    if not closeBtn then
                        closeBtn = Instance.new("TextButton")
                        closeBtn.Name = "CustomCloseBtn"
                        closeBtn.Size = UDim2.new(0, 24, 0, 24)
                        closeBtn.Position = UDim2.new(1, -2, 0, 0)
                        closeBtn.AnchorPoint = Vector2.new(1, 0)
                        closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
                        closeBtn.Text = "X"
                        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        closeBtn.Font = Enum.Font.GothamBold
                        closeBtn.TextSize = 13
                        closeBtn.ZIndex = 100
                        closeBtn.AutoButtonColor = true

                        local corner = Instance.new("UICorner")
                        corner.CornerRadius = UDim.new(0, 6)
                        corner.Parent = closeBtn
                        closeBtn.Parent = frame
                    end
                    closeBtn.Visible = true

                    if self.State.StatsCloseConn then
                        self.State.StatsCloseConn:Disconnect()
                    end
                    self.State.StatsCloseConn = closeBtn.MouseButton1Click:Connect(function()
                        self:CloseIndexStats()
                    end)
                end
            end
        end
    end

    self:Notify("Index", "Открыто: " .. exactName)
end

-- 6. Discord Webhook Sender
function Hub:SendDiscordWebhook(data)
    if not self.Config.WebhookEnabled or not self.Config.WebhookUrl or self.Config.WebhookUrl == "" then
        return
    end

    local req = request or http_request or (syn and syn.request)
    if typeof(req) ~= "function" then return end

    local moneyText = "0"
    pcall(function()
        local ml = LocalPlayer.PlayerGui.HUD.LeftFrame.Top.MoneyFrame.MoneyLabel
        if ml and ml.Text ~= "" then moneyText = ml.Text end
    end)

    local itemName = tostring(data.Name or "Unknown Item")
    local price = tonumber(data.Price or 0)
    local buyer = tostring(data.Buyer or "Покупатель с Плазы")
    local seller = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"
    local iconUrl = tostring(data.Icon or "https://raw.githubusercontent.com/Lisi-prime/Dynamic-Hub/main/Dynamic_logo.png")
    if iconUrl:find("rbxassetid://") then
        local id = iconUrl:gsub("rbxassetid://", "")
        iconUrl = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. id .. "&width=420&height=420&format=png"
    end

    local netProfit = math.floor(price * 0.9)

    local payload = {
        username = "Dynamic Hub | Plaza Sales",
        avatar_url = "https://raw.githubusercontent.com/Lisi-prime/Dynamic-Hub/main/Dynamic_logo.png",
        embeds = {
            {
                title = "Успешная продажа на стенде",
                color = 9522687,
                thumbnail = { url = iconUrl },
                fields = {
                    { name = "Продавец", value = seller, inline = true },
                    { name = "Покупатель", value = buyer, inline = true },
                    { name = "Проданный предмет", value = "**" .. itemName .. "**", inline = false },
                    { name = "Цена продажи", value = tostring(price) .. " Токенов", inline = true },
                    { name = "Прибыль (чистыми)", value = "+" .. tostring(netProfit) .. " Токенов", inline = true },
                    { name = "Баланс аккаунта", value = moneyText .. " Токенов", inline = true }
                },
                footer = {
                    text = "Dynamic Hub | Blade Ball Trade Plaza",
                    icon_url = "https://raw.githubusercontent.com/Lisi-prime/Dynamic-Hub/main/Dynamic_logo.png"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    }

    local jsonBody = Hub.Services.HttpService:JSONEncode(payload)
    task.spawn(function()
        pcall(function()
            req({
                Url = Hub.Config.WebhookUrl,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = jsonBody
            })
        end)
    end)
end

-- 7. Real-time Item Value & Exist Lookups (Passive Replion cache reader)
function Hub:LookupItemRAP(itemName)
    local ok, res, foundCat = pcall(function()
        local rep = Hub.Services.ReplicatedStorage
        local replionModule = rep:FindFirstChild("Replion", true)
        if not replionModule then return nil end
        local Replion = require(replionModule)
        local r = Replion.Client:GetReplion("ItemRAP")
        if not r then return nil end
        local items = r:Get() and r:Get().Items
        if not items then return nil end
        local key = '[["Name","' .. itemName .. '"]]'
        for cat, list in pairs(items) do
            if type(list) == "table" and list[key] then
                return list[key], cat
            end
        end
        -- Case-insensitive search if exact key failed
        local lowerName = itemName:lower()
        for cat, list in pairs(items) do
            if type(list) == "table" then
                for k, rapVal in pairs(list) do
                    if k:lower():find(lowerName, 1, true) then
                        return rapVal, cat
                    end
                end
            end
        end
        return nil
    end)
    if ok and res then
        return res, foundCat
    end
    return nil
end

function Hub:LookupItemExist(itemName)
    local ok, res = pcall(function()
        local rep = Hub.Services.ReplicatedStorage
        local replionModule = rep:FindFirstChild("Replion", true)
        if not replionModule then return nil end
        local Replion = require(replionModule)
        local r = Replion.Client:GetReplion("ClientExistCount")
        if not r then return nil end
        local items = r:Get() and r:Get().Items
        if not items then return nil end
        local key = '[["Name","' .. itemName .. '"]]'
        for cat, list in pairs(items) do
            if type(list) == "table" and list[key] then
                return list[key], cat
            end
        end
        local lowerName = itemName:lower()
        for cat, list in pairs(items) do
            if type(list) == "table" then
                for k, existVal in pairs(list) do
                    if k:lower():find(lowerName, 1, true) then
                        return existVal, cat
                    end
                end
            end
        end
        return nil
    end)
    return ok and res or nil
end

-- ==================== CONFIG MANAGER ====================
local CONFIG_FOLDER = "Dynamic_Hub"
local AUTOLOAD_FILE = CONFIG_FOLDER .. "/autoload.json"

pcall(function()
    if makefolder and not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
end)

function Hub:GetConfigsList()
    local configs = {}
    pcall(function()
        if listfiles and isfolder(CONFIG_FOLDER) then
            for _, path in ipairs(listfiles(CONFIG_FOLDER)) do
                local fileName = path:match("([^/\\]+)%.json$")
                if fileName and fileName ~= "autoload" then
                    table.insert(configs, fileName)
                end
            end
        end
    end)
    table.sort(configs)
    return configs
end

function Hub:GetAutoload()
    local isf = isfile or (syn and syn.isfile)
    local rf = readfile or (syn and syn.readfile)
    if isf and rf and isf(AUTOLOAD_FILE) then
        local ok, content = pcall(rf, AUTOLOAD_FILE)
        if ok and content and content ~= "" then
            local okJson, data = pcall(function()
                return Hub.Services.HttpService:JSONDecode(content)
            end)
            if okJson and type(data) == "table" and data.ConfigName then
                return data.ConfigName, true
            end
        end
    end
    return nil, false
end

function Hub:SetAutoload(name)
    local wf = writefile or (syn and syn.writefile)
    local df = delfile or (syn and syn.delfile)
    local isf = isfile or (syn and syn.isfile)
    if not name or name == "" then
        if df and isf and isf(AUTOLOAD_FILE) then
            pcall(df, AUTOLOAD_FILE)
        end
        self:Notify("Config", "Autoload removed")
        return
    end
    if wf then
        local data = { ConfigName = name }
        pcall(wf, AUTOLOAD_FILE, Hub.Services.HttpService:JSONEncode(data))
        self:Notify("Config", "Autoload set to: " .. name)
    end
end

function Hub:SaveConfig(name)
    if not name or name == "" then return false end
    local wf = writefile or (syn and syn.writefile)
    if not wf then return false end

    local cfgToSave = {}
    for k, v in pairs(self.Config) do
        if typeof(v) == "EnumItem" then
            cfgToSave[k] = { __type = "EnumItem", EnumType = tostring(v.EnumType), Name = v.Name }
        else
            cfgToSave[k] = v
        end
    end

    local cfgData = {
        Name = name,
        SavedAt = os.date and os.date("!%Y-%m-%d %H:%M:%SZ") or "Unknown",
        Config = cfgToSave
    }
    local ok, encoded = pcall(function()
        return Hub.Services.HttpService:JSONEncode(cfgData)
    end)
    if ok then
        pcall(wf, CONFIG_FOLDER .. "/" .. name .. ".json", encoded)
        self:Notify("Config", "Config '" .. name .. "' saved!")
        return true
    end
    return false
end

function Hub:LoadConfig(name)
    if not name or name == "" then return false end
    local rf = readfile or (syn and syn.readfile)
    local isf = isfile or (syn and syn.isfile)
    local path = CONFIG_FOLDER .. "/" .. name .. ".json"
    if isf and rf and isf(path) then
        local ok, content = pcall(rf, path)
        if ok and content and content ~= "" then
            local okJson, data = pcall(function()
                return Hub.Services.HttpService:JSONDecode(content)
            end)
            if okJson and type(data) == "table" and data.Config then
                for k, v in pairs(data.Config) do
                    if type(v) == "table" and v.__type == "EnumItem" and v.Name then
                        if v.EnumType == "KeyCode" and Enum.KeyCode[v.Name] then
                            self.Config[k] = Enum.KeyCode[v.Name]
                        end
                    else
                        self.Config[k] = v
                    end
                    if self.State.ConfigControls and self.State.ConfigControls[k] then
                        pcall(self.State.ConfigControls[k], self.Config[k])
                    end
                end
                if self.State.RefreshWatchlistUI then
                    pcall(self.State.RefreshWatchlistUI)
                end
                if self.State.UpdateTeleportInput then
                    pcall(self.State.UpdateTeleportInput, self.Config.TeleportItemName or "")
                end
                if self.Config.WatchlistEsp then
                    pcall(function() self:UpdateWatchlistEsp(true) end)
                end
                self:Notify("Config", "Config '" .. name .. "' loaded!")
                return true
            end
        end
    end
    return false
end

function Hub:DeleteConfig(name)
    if not name or name == "" then return false end
    local df = delfile or (syn and syn.delfile)
    local isf = isfile or (syn and syn.isfile)
    local path = CONFIG_FOLDER .. "/" .. name .. ".json"
    if df and isf and isf(path) then
        pcall(df, path)
        local autoName, isAuto = self:GetAutoload()
        if isAuto and autoName == name then
            self:SetAutoload(nil)
        end
        self:Notify("Config", "Config '" .. name .. "' deleted!")
        return true
    end
    return false
end

-- ==================== BUILD GUI ====================
function Hub:BuildUI()
    local screen = Instance.new("ScreenGui")
    screen.Name = "Dynamic_Hub_BladeBall"
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = parentTarget
    self.State.Gui = screen

    -- DropShadow (Enlarged)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(0, 670, 0, 480)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.35
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = 8
    shadow.Visible = true
    shadow.Parent = screen
    self.State.Shadow = shadow

    -- MainFrame (Enlarged PC Size: 620 x 430)
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.Size = self.State.WindowSize
    main.BackgroundColor3 = self.Theme.MainBg
    main.BorderSizePixel = 0
    main.ClipsDescendants = false
    main.ZIndex = 10
    main.Visible = true
    main.Parent = screen
    self.State.MainFrame = main
    self:Corner(main, 14)
    self:Stroke(main, self.Theme.Border, 1)

    -- TopBar
    local topbar = Instance.new("Frame")
    topbar.Name = "TopBar"
    topbar.Size = UDim2.new(1, 0, 0, 48)
    topbar.BackgroundColor3 = self.Theme.TopBarBg
    topbar.BorderSizePixel = 0
    topbar.ZIndex = 20
    topbar.Parent = main
    self:Corner(topbar, 14)

    local topGrad = Instance.new("UIGradient")
    topGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 22, 42)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 18, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 14, 20))
    })
    topGrad.Rotation = 90
    topGrad.Parent = topbar

    local topFiller = Instance.new("Frame")
    topFiller.Name = "TopFiller"
    topFiller.Position = UDim2.new(0, 0, 1, -14)
    topFiller.Size = UDim2.new(1, 0, 0, 14)
    topFiller.BackgroundColor3 = self.Theme.TopBarBg
    topFiller.BorderSizePixel = 0
    topFiller.ZIndex = 20
    topFiller.Parent = topbar

    local topDivider = Instance.new("Frame")
    topDivider.Name = "TopDivider"
    topDivider.Size = UDim2.new(1, 0, 0, 1)
    topDivider.Position = UDim2.new(0, 0, 1, -1)
    topDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    topDivider.BorderSizePixel = 0
    topDivider.ZIndex = 21
    topDivider.Parent = topbar

    local topDivGrad = Instance.new("UIGradient")
    topDivGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Theme.Accent),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 180, 255)),
        ColorSequenceKeypoint.new(1, self.Theme.Accent)
    })
    topDivGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.2, 0.2),
        NumberSequenceKeypoint.new(0.5, 0.0),
        NumberSequenceKeypoint.new(0.8, 0.2),
        NumberSequenceKeypoint.new(1, 0.9)
    })
    topDivGrad.Parent = topDivider

    -- TITLE: DYNAMIC (No Logo Image)
    local logoShadow = Instance.new("TextLabel")
    logoShadow.Name = "LogoShadow"
    logoShadow.Position = UDim2.new(0, 16, 0.5, 1)
    logoShadow.AnchorPoint = Vector2.new(0, 0.5)
    logoShadow.Size = UDim2.new(0, 120, 0, 26)
    logoShadow.BackgroundTransparency = 1
    logoShadow.Font = Enum.Font.GothamBold
    logoShadow.Text = "DYNAMIC"
    logoShadow.TextColor3 = self.Theme.Accent
    logoShadow.TextTransparency = 0.5
    logoShadow.TextSize = 16
    logoShadow.TextXAlignment = Enum.TextXAlignment.Left
    logoShadow.ZIndex = 22
    logoShadow.Parent = topbar

    local logoLabel = Instance.new("TextLabel")
    logoLabel.Name = "LogoLabel"
    logoLabel.Position = UDim2.new(0, 16, 0.5, 0)
    logoLabel.AnchorPoint = Vector2.new(0, 0.5)
    logoLabel.Size = UDim2.new(0, 120, 0, 26)
    logoLabel.BackgroundTransparency = 1
    logoLabel.Font = Enum.Font.GothamBold
    logoLabel.Text = "DYNAMIC"
    logoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoLabel.TextSize = 16
    logoLabel.TextXAlignment = Enum.TextXAlignment.Left
    logoLabel.ZIndex = 23
    logoLabel.Parent = topbar

    -- Right Controls: [RCtrl] & [X]
    local keyHint = Instance.new("TextLabel")
    keyHint.Name = "KeyHint"
    keyHint.Position = UDim2.new(1, -94, 0.5, -10)
    keyHint.Size = UDim2.new(0, 52, 0, 20)
    keyHint.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    keyHint.Font = Enum.Font.GothamMedium
    keyHint.Text = "[RCtrl]"
    keyHint.TextColor3 = self.Theme.TextDim
    keyHint.TextSize = 11
    keyHint.ZIndex = 23
    keyHint.Parent = topbar
    self:Corner(keyHint, 5)
    self:Stroke(keyHint, Color3.fromRGB(44, 44, 58), 1)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Position = UDim2.new(1, -34, 0.5, -13)
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(210, 210, 225)
    closeBtn.TextSize = 12
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 23
    closeBtn.Parent = topbar
    self:Corner(closeBtn, 6)
    self:Stroke(closeBtn, Color3.fromRGB(44, 44, 58), 1)

    closeBtn.MouseEnter:Connect(function()
        self:Tween(closeBtn, { BackgroundColor3 = Color3.fromRGB(55, 30, 40), TextColor3 = Color3.fromRGB(255, 120, 140) }, 0.15)
    end)
    closeBtn.MouseLeave:Connect(function()
        self:Tween(closeBtn, { BackgroundColor3 = Color3.fromRGB(28, 28, 38), TextColor3 = Color3.fromRGB(210, 210, 225) }, 0.15)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        self:ToggleMenu(false)
    end)

    -- SIDEBAR NAVIGATION (Width: 128)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Position = UDim2.new(0, 0, 0, 48)
    sidebar.Size = UDim2.new(0, 128, 1, -48)
    sidebar.BackgroundColor3 = Color3.fromRGB(17, 17, 22)
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 12
    sidebar.Parent = main

    local sidebarDivider = Instance.new("Frame")
    sidebarDivider.Name = "SidebarDivider"
    sidebarDivider.Position = UDim2.new(1, -1, 0, 0)
    sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    sidebarDivider.BackgroundColor3 = self.Theme.Border
    sidebarDivider.BorderSizePixel = 0
    sidebarDivider.ZIndex = 13
    sidebarDivider.Parent = sidebar

    local navContainer = Instance.new("Frame")
    navContainer.Name = "NavContainer"
    navContainer.Position = UDim2.new(0, 8, 0, 10)
    navContainer.Size = UDim2.new(1, -16, 1, -20)
    navContainer.BackgroundTransparency = 1
    navContainer.ZIndex = 14
    navContainer.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.FillDirection = Enum.FillDirection.Vertical
    navLayout.Padding = UDim.new(0, 6)
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navContainer

    -- CONTENT AREA
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Position = UDim2.new(0, 129, 0, 48)
    contentArea.Size = UDim2.new(1, -129, 1, -48)
    contentArea.BackgroundTransparency = 1
    contentArea.ClipsDescendants = true
    contentArea.ZIndex = 12
    contentArea.Parent = main

    -- TABS: Main, Trade Helper, Settings
    local tabsConfig = {
        { Name = "Main", Title = "Main", Icon = Icons.Main, LayoutOrder = 1 },
        { Name = "Trade Helper", Title = "Trade Helper", Icon = Icons.Trade, LayoutOrder = 2 },
        { Name = "Settings", Title = "Settings", Icon = Icons.Settings, LayoutOrder = 3 }
    }

    for _, def in ipairs(tabsConfig) do
        self:CreateTab(navContainer, contentArea, def)
    end

    -- POPULATE TABS
    self:BuildMainTab(self.State.Tabs["Main"])
    self:BuildTradeHelperTab(self.State.Tabs["Trade Helper"])
    self:BuildSettingsTab(self.State.Tabs["Settings"])

    self:SwitchTab("Main")
    self:SetupDragging(topbar, main, shadow)
    self:SetupKeybind()
    self:SetupKickWatcher()
    self:SetupEspUpdater()
    self:SetupBoothItemTracker()
    self:SetupAutoServerHopWatcher()

    if self.Config.CloseGuiOnStart then
        main.Visible = false
        if shadow then shadow.Visible = false end
        self.State.IsOpen = false
    else
        main.Visible = true
        if shadow then shadow.Visible = true end
        self.State.IsOpen = true
    end
end

-- TAB CREATION
function Hub:CreateTab(navContainer, contentArea, def)
    local name = def.Name
    local btn = Instance.new("TextButton")
    btn.Name = "TabBtn_" .. name:gsub("%s+", "")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = def.LayoutOrder
    btn.ZIndex = 15
    btn.Parent = navContainer
    self:Corner(btn, 8)
    local btnStroke = self:Stroke(btn, Color3.fromRGB(42, 44, 60), 1)
    btnStroke.Transparency = 1

    local activeBar = Instance.new("Frame")
    activeBar.Name = "ActiveIndicator"
    activeBar.Size = UDim2.new(0, 3, 0.55, 0)
    activeBar.Position = UDim2.new(0, 4, 0.5, 0)
    activeBar.AnchorPoint = Vector2.new(0, 0.5)
    activeBar.BackgroundColor3 = self.Theme.Accent
    activeBar.BorderSizePixel = 0
    activeBar.BackgroundTransparency = 1
    activeBar.ZIndex = 16
    activeBar.Parent = btn
    self:Corner(activeBar, 2)

    local icon = Instance.new("ImageLabel")
    icon.Name = "TabIcon"
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(0, 12, 0.5, -8)
    icon.BackgroundTransparency = 1
    icon.Image = def.Icon or Icons.Main
    icon.ImageColor3 = self.Theme.TextDim
    icon.ZIndex = 16
    icon.Parent = btn

    local title = Instance.new("TextLabel")
    title.Name = "TabTitle"
    title.Position = UDim2.new(0, 36, 0, 0)
    title.Size = UDim2.new(1, -40, 1, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamMedium
    title.Text = def.Title
    title.TextColor3 = self.Theme.TextDim
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 16
    title.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Name = "Page_" .. name:gsub("%s+", "")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = self.Theme.Accent
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ZIndex = 14
    page.Parent = contentArea

    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingTop = UDim.new(0, 12)
    pagePad.PaddingBottom = UDim.new(0, 14)
    pagePad.PaddingLeft = UDim.new(0, 14)
    pagePad.PaddingRight = UDim.new(0, 14)
    pagePad.Parent = page

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Parent = page

    self.State.Tabs[name] = page
    self.State.TabButtons[name] = {
        Button = btn,
        Stroke = btnStroke,
        Bar = activeBar,
        Icon = icon,
        Title = title
    }

    btn.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)
end

function Hub:SwitchTab(name)
    self.State.ActiveTab = name
    for tabName, page in pairs(self.State.Tabs) do
        local isTarget = (tabName == name)
        page.Visible = isTarget

        local data = self.State.TabButtons[tabName]
        if data then
            local targetBgTrans = isTarget and 0 or 1
            local targetBarTrans = isTarget and 0 or 1
            local targetStrokeTrans = isTarget and 0 or 1
            local targetColor = isTarget and self.Theme.TextPrimary or self.Theme.TextDim
            local targetIconColor = isTarget and self.Theme.AccentGlow or self.Theme.TextDim

            self:Tween(data.Button, { BackgroundTransparency = targetBgTrans }, 0.15)
            self:Tween(data.Bar, { BackgroundTransparency = targetBarTrans }, 0.15)
            self:Tween(data.Stroke, { Transparency = targetStrokeTrans }, 0.15)
            self:Tween(data.Title, { TextColor3 = targetColor }, 0.15)
            self:Tween(data.Icon, { ImageColor3 = targetIconColor }, 0.15)
        end
    end
end

-- DUAL COLUMN HELPER
function Hub:CreateDualColumn(container)
    local wrapper = Instance.new("Frame")
    wrapper.Name = "DualColWrapper"
    wrapper.Size = UDim2.new(1, 0, 0, 0)
    wrapper.AutomaticSize = Enum.AutomaticSize.Y
    wrapper.BackgroundTransparency = 1
    wrapper.Parent = container

    local leftCol = Instance.new("Frame")
    leftCol.Name = "LeftCol"
    leftCol.Size = UDim2.new(0.5, -6, 0, 0)
    leftCol.AutomaticSize = Enum.AutomaticSize.Y
    leftCol.BackgroundTransparency = 1
    leftCol.Parent = wrapper

    local leftLayout = Instance.new("UIListLayout")
    leftLayout.Padding = UDim.new(0, 10)
    leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    leftLayout.Parent = leftCol

    local rightCol = Instance.new("Frame")
    rightCol.Name = "RightCol"
    rightCol.Size = UDim2.new(0.5, -6, 0, 0)
    rightCol.Position = UDim2.new(0.5, 6, 0, 0)
    rightCol.AutomaticSize = Enum.AutomaticSize.Y
    rightCol.BackgroundTransparency = 1
    rightCol.Parent = wrapper

    local rightLayout = Instance.new("UIListLayout")
    rightLayout.Padding = UDim.new(0, 10)
    rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rightLayout.Parent = rightCol

    return leftCol, rightCol
end

-- SECTION CREATION
function Hub:CreateSection(parent, title, customIcon)
    local card = Instance.new("Frame")
    card.Name = "Card_" .. (title and title:gsub("%s+", "") or "Sec")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = self.Theme.CardBg
    card.BorderSizePixel = 0
    card.Parent = parent
    self:Corner(card, 10)
    self:Stroke(card, self.Theme.Border, 1)

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.Parent = card

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = card

    if title and title ~= "" then
        local header = Instance.new("Frame")
        header.Name = "Header"
        header.Size = UDim2.new(1, 0, 0, 20)
        header.BackgroundTransparency = 1
        header.Parent = card

        local star = Instance.new("ImageLabel")
        star.Name = "StarIcon"
        star.Size = UDim2.new(0, 13, 0, 13)
        star.Position = UDim2.new(0, 0, 0.5, -6.5)
        star.BackgroundTransparency = 1
        star.Image = customIcon or Icons.StarFilled
        star.ImageColor3 = self.Theme.Accent
        star.Parent = header

        local lbl = Instance.new("TextLabel")
        lbl.Name = "Title"
        lbl.Position = UDim2.new(0, 20, 0, 0)
        lbl.Size = UDim2.new(1, -20, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.Text = title
        lbl.TextColor3 = self.Theme.TextPrimary
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = header
    end

    return card
end

-- INFO ROW
function Hub:CreateInfoRow(parent, labelText, valueText, valueColor)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 24)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    row.BorderSizePixel = 0
    row.Parent = parent
    self:Corner(row, 6)
    self:Stroke(row, Color3.fromRGB(30, 30, 40), 1)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Position = UDim2.new(0, 10, 0, 0)
    titleLbl.Size = UDim2.new(0.42, -10, 1, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamMedium
    titleLbl.Text = labelText
    titleLbl.TextColor3 = self.Theme.TextDim
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = row

    local valLbl = Instance.new("TextLabel")
    valLbl.Position = UDim2.new(0.42, 0, 0, 0)
    valLbl.Size = UDim2.new(0.58, -10, 1, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Font = Enum.Font.GothamBold
    valLbl.Text = tostring(valueText or "")
    valLbl.TextColor3 = valueColor or self.Theme.TextPrimary
    valLbl.TextSize = 11
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = row

    return valLbl
end

-- TOGGLE
function Hub:CreateToggle(parent, title, defaultState, callback, configKey)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    row.ClipsDescendants = true
    row.Parent = parent
    self:Corner(row, 6)
    self:Stroke(row, Color3.fromRGB(32, 32, 42), 1)

    local lbl = Instance.new("TextLabel")
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(1, -54, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = title
    lbl.TextColor3 = defaultState and self.Theme.TextPrimary or self.Theme.TextDim
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 32, 0, 15)
    switch.Position = UDim2.new(1, -40, 0.5, -7.5)
    switch.BackgroundColor3 = defaultState and self.Theme.Accent or Color3.fromRGB(34, 34, 44)
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.Parent = row
    self:Corner(switch, 8)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 13, 0, 13)
    circle.Position = defaultState and UDim2.new(1, -14, 0.5, -6.5) or UDim2.new(0, 1, 0.5, -6.5)
    circle.BackgroundColor3 = defaultState and Color3.fromRGB(20, 22, 30) or Color3.fromRGB(210, 215, 225)
    circle.Parent = switch
    self:Corner(circle, 7)

    local state = defaultState
    local function setVisual(newState, silent)
        state = newState
        local targetColor = state and self.Theme.Accent or Color3.fromRGB(34, 34, 44)
        local targetPos = state and UDim2.new(1, -14, 0.5, -6.5) or UDim2.new(0, 1, 0.5, -6.5)
        local knobColor = state and Color3.fromRGB(20, 22, 30) or Color3.fromRGB(210, 215, 225)
        local textColor = state and self.Theme.TextPrimary or self.Theme.TextDim

        self:Tween(switch, { BackgroundColor3 = targetColor }, 0.18)
        self:Tween(circle, { Position = targetPos, BackgroundColor3 = knobColor }, 0.18)
        self:Tween(lbl, { TextColor3 = textColor }, 0.18)

        if not silent and callback then
            callback(state)
        end
    end

    if configKey then
        self.State.ConfigControls[configKey] = function(newVal)
            setVisual(newVal, true)
        end
    end

    switch.MouseButton1Click:Connect(function()
        setVisual(not state)
    end)

    return row, setVisual
end

-- BUTTON
function Hub:CreateButton(parent, text, callback, customColor, customBg)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = customBg or Color3.fromRGB(22, 22, 28)
    btn.Text = "  " .. text
    btn.Font = Enum.Font.GothamMedium
    btn.TextColor3 = customColor or self.Theme.TextPrimary
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = parent
    self:Corner(btn, 6)
    local s = self:Stroke(btn, Color3.fromRGB(36, 36, 48), 1)

    btn.MouseEnter:Connect(function()
        self:Tween(btn, { BackgroundColor3 = customBg and Color3.fromRGB(58, 24, 32) or Color3.fromRGB(32, 32, 44) }, 0.15)
        self:Tween(s, { Color = customColor or self.Theme.Accent }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        self:Tween(btn, { BackgroundColor3 = customBg or Color3.fromRGB(22, 22, 28) }, 0.15)
        self:Tween(s, { Color = Color3.fromRGB(36, 36, 48) }, 0.15)
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then callback(btn) end
    end)
    return btn
end

-- KEYBIND
function Hub:CreateKeybind(parent, title, defaultKey, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    row.ClipsDescendants = true
    row.Parent = parent
    self:Corner(row, 6)
    self:Stroke(row, Color3.fromRGB(32, 32, 42), 1)

    local lbl = Instance.new("TextLabel")
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(1, -74, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = title
    lbl.TextColor3 = self.Theme.TextPrimary
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 58, 0, 18)
    keyBtn.Position = UDim2.new(1, -66, 0.5, -9)
    keyBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    keyBtn.Font = Enum.Font.GothamBold
    local initialKeyName = (typeof(defaultKey) == "EnumItem" and defaultKey.Name) or tostring(defaultKey or "Q")
    keyBtn.Text = "[" .. initialKeyName .. "]"
    keyBtn.TextColor3 = self.Theme.AccentGlow
    keyBtn.TextSize = 10
    keyBtn.AutoButtonColor = false
    keyBtn.Parent = row
    self:Corner(keyBtn, 4)
    self:Stroke(keyBtn, Color3.fromRGB(44, 44, 58), 1)

    local listening = false
    local listenConn = nil

    keyBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        keyBtn.Text = "[...]"
        keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyBtn.BackgroundColor3 = self.Theme.Accent

        listenConn = self.Services.UserInputService.InputBegan:Connect(function(input, gpe)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local chosenKey = input.KeyCode
                if chosenKey ~= Enum.KeyCode.Escape and chosenKey ~= Enum.KeyCode.Unknown then
                    self.Config.Key_OpenIndex = chosenKey
                    keyBtn.Text = "[" .. chosenKey.Name .. "]"
                    if callback then callback(chosenKey) end
                    self:Notify("Keybind", "Бинд изменен: " .. chosenKey.Name)
                else
                    local curKey = self.Config.Key_OpenIndex
                    local curName = (typeof(curKey) == "EnumItem" and curKey.Name) or tostring(curKey or "Q")
                    keyBtn.Text = "[" .. curName .. "]"
                end
                keyBtn.TextColor3 = self.Theme.AccentGlow
                keyBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
                listening = false
                if listenConn then
                    listenConn:Disconnect()
                    listenConn = nil
                end
            end
        end)
    end)

    return row
end


-- Auto Strike / Parry Key Detection & Action for Anti-AFK
function Hub:GetBlockKeyInfo()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local hotbar = pg and pg:FindFirstChild("Hotbar")
    local block = hotbar and hotbar:FindFirstChild("Block")
    local hotkeyFrame = block and block:FindFirstChild("HotkeyFrame")

    if hotkeyFrame then
        local mouseIcon = hotkeyFrame:FindFirstChild("MouseIcon")
        if mouseIcon and mouseIcon.Visible then
            return "Mouse1"
        end

        for _, child in ipairs(hotkeyFrame:GetChildren()) do
            if child:IsA("TextLabel") and child.Visible and child.Text ~= "" then
                local txt = child.Text:upper():gsub("%s+", "")
                if txt == "M1" or txt == "LMB" or txt:find("MOUSE1") then
                    return "Mouse1"
                elseif txt == "M2" or txt == "RMB" or txt:find("MOUSE2") then
                    return "Mouse2"
                elseif txt == "SPACE" or txt == " " then
                    return Enum.KeyCode.Space
                elseif Enum.KeyCode[txt] then
                    return Enum.KeyCode[txt]
                end
            end
        end
    end

    return Enum.KeyCode.F
end

-- SLIDER
function Hub:CreateSlider(parent, title, minVal, maxVal, defaultVal, callback)
    local minV = minVal or 1
    local maxV = maxVal or 100
    local curV = math.clamp(defaultVal or minV, minV, maxV)

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    row.ClipsDescendants = true
    row.Parent = parent
    self:Corner(row, 6)
    self:Stroke(row, Color3.fromRGB(32, 32, 42), 1)

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, -20, 0, 18)
    header.Position = UDim2.new(0, 10, 0, 5)
    header.BackgroundTransparency = 1
    header.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = title
    lbl.TextColor3 = self.Theme.TextPrimary
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = header

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0.3, 0, 1, 0)
    valLbl.Position = UDim2.new(0.7, 0, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Font = Enum.Font.GothamBold
    valLbl.Text = tostring(curV)
    valLbl.TextColor3 = self.Theme.AccentGlow
    valLbl.TextSize = 11
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = header

    local sliderTrack = Instance.new("TextButton")
    sliderTrack.Size = UDim2.new(1, -20, 0, 6)
    sliderTrack.Position = UDim2.new(0, 10, 0, 28)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
    sliderTrack.Text = ""
    sliderTrack.AutoButtonColor = false
    sliderTrack.Parent = row
    self:Corner(sliderTrack, 3)

    local alpha = (maxV > minV) and ((curV - minV) / (maxV - minV)) or 0
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(alpha, 0, 1, 0)
    sliderFill.BackgroundColor3 = self.Theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    self:Corner(sliderFill, 3)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(1, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
    knob.Parent = sliderFill
    self:Corner(knob, 6)
    self:Stroke(knob, self.Theme.Accent, 1)

    local dragging = false

    local function updateValue(inputX)
        local trackPos = sliderTrack.AbsolutePosition.X
        local trackWidth = sliderTrack.AbsoluteSize.X
        if trackWidth <= 0 then return end
        local rel = math.clamp((inputX - trackPos) / trackWidth, 0, 1)
        local newV = math.floor(minV + (maxV - minV) * rel + 0.5)
        curV = newV
        valLbl.Text = tostring(curV)
        sliderFill.Size = UDim2.new(rel, 0, 1, 0)
        if callback then
            callback(curV)
        end
    end

    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateValue(input.Position.X)
        end
    end)

    local inputEndedConn = self.Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    table.insert(self.State.Connections, inputEndedConn)

    local inputChangedConn = self.Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateValue(input.Position.X)
        end
    end)
    table.insert(self.State.Connections, inputChangedConn)

    local function setValue(val)
        curV = math.clamp(val, minV, maxV)
        valLbl.Text = tostring(curV)
        local rel = (maxV > minV) and ((curV - minV) / (maxV - minV)) or 0
        sliderFill.Size = UDim2.new(rel, 0, 1, 0)
        if callback then callback(curV) end
    end

    return row, setValue
end

-- ==================== TAB 1: MAIN ====================
function Hub:BuildMainTab(page)
    local left, right = self:CreateDualColumn(page)

    -- CARD 1: PLAYER INFO
    local secPlayer = self:CreateSection(left, "Player Information", Icons.User)
    self:CreateInfoRow(secPlayer, "Username", LocalPlayer.Name, self.Theme.TextPrimary)
    self:CreateInfoRow(secPlayer, "Display Name", LocalPlayer.DisplayName, self.Theme.TextPrimary)
    self:CreateInfoRow(secPlayer, "User ID", tostring(LocalPlayer.UserId), self.Theme.AccentGlow)

    local pingLabel = self:CreateInfoRow(secPlayer, "Network Ping", "... ms", self.Theme.SuccessGreen)
    local fpsLabel = self:CreateInfoRow(secPlayer, "Framerate", "... FPS", self.Theme.SuccessGreen)

    local frameCount, timeAcc = 0, 0
    local renderConn = Hub.Services.RunService.RenderStepped:Connect(function(dt)
        frameCount = frameCount + 1
        timeAcc = timeAcc + (dt or 0.016)
        if timeAcc >= 0.5 then
            local currentFps = math.round(frameCount / timeAcc)
            fpsLabel.Text = tostring(currentFps) .. " FPS"
            frameCount = 0
            timeAcc = 0

            pcall(function()
                if LocalPlayer and LocalPlayer.GetNetworkPing then
                    local p = math.floor(LocalPlayer:GetNetworkPing() * 1000)
                    pingLabel.Text = tostring(p) .. " ms"
                end
            end)
        end
    end)
    table.insert(self.State.Connections, renderConn)

    -- CARD 2: SERVER INFO & JOIN BY JOBID
    local secServer = self:CreateSection(right, "Server Information & Join", Icons.Server)
    self:CreateInfoRow(secServer, "Game", "Blade Ball Trade Plaza", self.Theme.TextPrimary)
    self:CreateInfoRow(secServer, "Place ID", tostring(game.PlaceId or 16581637217), self.Theme.TextDim)
    
    local playersCountLabel = self:CreateInfoRow(secServer, "Players Online", tostring(#Hub.Services.Players:GetPlayers()) .. " / " .. tostring(Hub.Services.Players.MaxPlayers), self.Theme.SuccessGreen)
    
    local pConn = Hub.Services.Players.PlayerAdded:Connect(function()
        playersCountLabel.Text = tostring(#Hub.Services.Players:GetPlayers()) .. " / " .. tostring(Hub.Services.Players.MaxPlayers)
    end)
    local pRemConn = Hub.Services.Players.PlayerRemoving:Connect(function()
        playersCountLabel.Text = tostring(#Hub.Services.Players:GetPlayers()) .. " / " .. tostring(Hub.Services.Players.MaxPlayers)
    end)
    table.insert(self.State.Connections, pConn)
    table.insert(self.State.Connections, pRemConn)

    local jobIdFull = tostring(game.JobId or "")
    local jobIdShort = #jobIdFull > 12 and (jobIdFull:sub(1, 12) .. "...") or jobIdFull

    local jobRow = Instance.new("Frame")
    jobRow.Size = UDim2.new(1, 0, 0, 26)
    jobRow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    jobRow.Parent = secServer
    self:Corner(jobRow, 6)
    self:Stroke(jobRow, Color3.fromRGB(30, 30, 40), 1)

    local jobTitle = Instance.new("TextLabel")
    jobTitle.Position = UDim2.new(0, 10, 0, 0)
    jobTitle.Size = UDim2.new(0.35, -10, 1, 0)
    jobTitle.BackgroundTransparency = 1
    jobTitle.Font = Enum.Font.GothamMedium
    jobTitle.Text = "JobId"
    jobTitle.TextColor3 = self.Theme.TextDim
    jobTitle.TextSize = 11
    jobTitle.TextXAlignment = Enum.TextXAlignment.Left
    jobTitle.Parent = jobRow

    local jobVal = Instance.new("TextLabel")
    jobVal.Position = UDim2.new(0.35, 0, 0, 0)
    jobVal.Size = UDim2.new(0.44, 0, 1, 0)
    jobVal.BackgroundTransparency = 1
    jobVal.Font = Enum.Font.GothamBold
    jobVal.Text = jobIdShort
    jobVal.TextColor3 = self.Theme.AccentGlow
    jobVal.TextSize = 10
    jobVal.TextXAlignment = Enum.TextXAlignment.Left
    jobVal.Parent = jobRow

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 46, 0, 18)
    copyBtn.Position = UDim2.new(1, -52, 0.5, -9)
    copyBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.Text = "Copy"
    copyBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
    copyBtn.TextSize = 10
    copyBtn.AutoButtonColor = false
    copyBtn.Parent = jobRow
    self:Corner(copyBtn, 4)
    self:Stroke(copyBtn, Color3.fromRGB(45, 45, 60), 1)

    copyBtn.MouseEnter:Connect(function()
        self:Tween(copyBtn, { BackgroundColor3 = self.Theme.Accent, TextColor3 = Color3.fromRGB(255, 255, 255) }, 0.15)
    end)
    copyBtn.MouseLeave:Connect(function()
        self:Tween(copyBtn, { BackgroundColor3 = Color3.fromRGB(28, 28, 38), TextColor3 = Color3.fromRGB(220, 220, 240) }, 0.15)
    end)
    copyBtn.MouseButton1Click:Connect(function()
        local setclip = setclipboard or toclipboard or (syn and syn.write_clipboard)
        if setclip then
            setclip(tostring(game.JobId))
            self:Notify("JobId", "Скопирован в буфер!")
        end
    end)

    -- JOIN TO JOBID ROW
    local joinBoxFrame = Instance.new("Frame")
    joinBoxFrame.Size = UDim2.new(1, 0, 0, 30)
    joinBoxFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    joinBoxFrame.Parent = secServer
    self:Corner(joinBoxFrame, 6)
    self:Stroke(joinBoxFrame, Color3.fromRGB(34, 34, 44), 1)

    local joinJobBox = Instance.new("TextBox")
    joinJobBox.Size = UDim2.new(1, -78, 1, 0)
    joinJobBox.Position = UDim2.new(0, 8, 0, 0)
    joinJobBox.BackgroundTransparency = 1
    joinJobBox.Font = Enum.Font.GothamMedium
    joinJobBox.PlaceholderText = "Paste Target JobId..."
    joinJobBox.PlaceholderColor3 = self.Theme.TextMuted
    joinJobBox.Text = ""
    joinJobBox.TextColor3 = self.Theme.TextPrimary
    joinJobBox.TextSize = 11
    joinJobBox.TextXAlignment = Enum.TextXAlignment.Left
    joinJobBox.ClearTextOnFocus = false
    joinJobBox.Parent = joinBoxFrame

    local joinBtn = Instance.new("TextButton")
    joinBtn.Size = UDim2.new(0, 64, 1, -4)
    joinBtn.Position = UDim2.new(1, -66, 0, 2)
    joinBtn.BackgroundColor3 = self.Theme.Accent
    joinBtn.Font = Enum.Font.GothamBold
    joinBtn.Text = "Join"
    joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    joinBtn.TextSize = 11
    joinBtn.AutoButtonColor = false
    joinBtn.Parent = joinBoxFrame
    self:Corner(joinBtn, 4)

    joinBtn.MouseButton1Click:Connect(function()
        local targetJob = joinJobBox.Text:gsub("%s+", "")
        if targetJob ~= "" then
            self:Notify("Teleport", "Подключение к JobId: " .. targetJob:sub(1, 10) .. "...")
            local placeId = game.PlaceId or 16581637217
            pcall(function()
                Hub.Services.TeleportService:TeleportToPlaceInstance(placeId, targetJob, LocalPlayer)
            end)
        else
            self:Notify("Teleport", "Введи корректный JobId!")
        end
    end)

    -- REJOIN & SERVER HOP
    self:CreateButton(secServer, "Rejoin", function()
        self:TriggerRejoin("Manual Rejoin")
    end, Color3.fromRGB(90, 180, 255))

    self:CreateButton(secServer, "Server Hop", function()
        self:SmartServerHop()
    end, self.Theme.AccentGlow)
end

-- ==================== TAB 2: TRADE HELPER ====================
function Hub:BuildTradeHelperTab(page)
    local left, right = self:CreateDualColumn(page)

    -- CARD 1: BOOTH MODULES & INDEX
    local secBooth = self:CreateSection(left, "Booth Modules", Icons.Store)

    self:CreateButton(secBooth, "Открыть выбранный в Index", function()
        self:OpenSelectedItemInIndex()
    end, self.Theme.AccentGlow)

    self:CreateKeybind(secBooth, "Бинд открытия в Index", self.Config.Key_OpenIndex, function(newKey)
        self.Config.Key_OpenIndex = newKey
    end)


    self:CreateToggle(secBooth, "Auto Claim Booth", self.Config.AutoClaimBooth, function(val)
        self.Config.AutoClaimBooth = val
        if val then
            self:ClaimNearestBooth()
        end
    end, "AutoClaimBooth")

    self:CreateToggle(secBooth, "ESP My Booth", self.Config.EspMyBooth, function(val)
        self.Config.EspMyBooth = val
        self:UpdateMyBoothEsp(val)
    end, "EspMyBooth")

    self:CreateToggle(secBooth, "My Booth Tracer", self.Config.MyBoothTracer, function(val)
        self.Config.MyBoothTracer = val
        self:UpdateMyBoothTracer(val)
    end, "MyBoothTracer")

    self:CreateToggle(secBooth, "ESP Booths", self.Config.EspBooths, function(val)
        self.Config.EspBooths = val
        self:UpdateBoothsEsp(val)
    end, "EspBooths")

    -- CARD 2: UTILITIES
    local secUtil = self:CreateSection(left, "Utilities")

    self:CreateToggle(secUtil, "Anti-AFK", self.Config.AntiAFK, function(val)
        self.Config.AntiAFK = val
        if val then
            -- Disable native Roblox idle kicker connections
            if getconnections then
                pcall(function()
                    for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do
                        conn:Disable()
                    end
                end)
            end

            self.State.AntiAfkConn = LocalPlayer.Idled:Connect(function()
                pcall(function()
                    if mouse1click then
                        mouse1click()
                    elseif keypress and keyrelease then
                        keypress(0x20)
                        task.wait(0.04)
                        keyrelease(0x20)
                    end
                end)
            end)
            self:Notify("Anti-AFK", "Включен (безопасный режим)")
        else
            if self.State.AntiAfkConn then
                self.State.AntiAfkConn:Disconnect()
                self.State.AntiAfkConn = nil
            end
            if getconnections then
                pcall(function()
                    for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do
                        conn:Enable()
                    end
                end)
            end
            self:Notify("Anti-AFK", "Выключен")
        end
    end, "AntiAFK")

    self:CreateToggle(secUtil, "Auto-Rejoin on Kick", self.Config.AutoRejoinOnKick, function(val)
        self.Config.AutoRejoinOnKick = val
    end, "AutoRejoinOnKick")

    self:CreateToggle(secUtil, "Auto Server Hop", self.Config.AutoServerHop, function(val)
        self.Config.AutoServerHop = val
    end, "AutoServerHop")

    self:CreateSlider(secUtil, "Мин. игроков для хопа", 2, 20, self.Config.MinPlayersThreshold or 6, function(val)
        self.Config.MinPlayersThreshold = val
    end)

    -- CARD 3: ITEM WATCHLIST (Искатель предметов)
    local secWatch = self:CreateSection(right, "Искатель предметов (Watchlist)", Icons.Search or Icons.StarFilled)

    self:CreateToggle(secWatch, "ESP Искомых предметов", self.Config.WatchlistEsp, function(val)
        self.Config.WatchlistEsp = val
        self:UpdateWatchlistEsp(val)
    end, "WatchlistEsp")

    -- Input Row: TextBox + [+] Add Button
    local addRow = Instance.new("Frame")
    addRow.Name = "AddWatchlistRow"
    addRow.Size = UDim2.new(1, 0, 0, 30)
    addRow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    addRow.Parent = secWatch
    self:Corner(addRow, 6)
    self:Stroke(addRow, Color3.fromRGB(34, 34, 44), 1)

    local watchInput = Instance.new("TextBox")
    watchInput.Name = "WatchItemInput"
    watchInput.Size = UDim2.new(1, -75, 1, 0)
    watchInput.Position = UDim2.new(0, 8, 0, 0)
    watchInput.BackgroundTransparency = 1
    watchInput.Font = Enum.Font.GothamMedium
    watchInput.PlaceholderText = "Введи предмет (напр. Hellchain)..."
    watchInput.PlaceholderColor3 = self.Theme.TextMuted
    watchInput.Text = ""
    watchInput.TextColor3 = self.Theme.TextPrimary
    watchInput.TextSize = 10
    watchInput.TextXAlignment = Enum.TextXAlignment.Left
    watchInput.ClearTextOnFocus = false
    watchInput.Parent = addRow

    local addBtn = Instance.new("TextButton")
    addBtn.Name = "AddBtn"
    addBtn.Size = UDim2.new(0, 62, 0, 22)
    addBtn.Position = UDim2.new(1, -66, 0.5, -11)
    addBtn.BackgroundColor3 = self.Theme.Accent
    addBtn.Font = Enum.Font.GothamBold
    addBtn.Text = "+ Добавить"
    addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    addBtn.TextSize = 9
    addBtn.AutoButtonColor = true
    addBtn.Parent = addRow
    self:Corner(addBtn, 4)

    -- Dynamic scrolling container for added items
    local listContainer = Instance.new("ScrollingFrame")
    listContainer.Name = "WatchlistContainer"
    listContainer.Size = UDim2.new(1, 0, 0, 105)
    listContainer.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    listContainer.BorderSizePixel = 0
    listContainer.ScrollBarThickness = 3
    listContainer.ScrollBarImageColor3 = self.Theme.Border
    listContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    listContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listContainer.Parent = secWatch
    self:Corner(listContainer, 6)
    self:Stroke(listContainer, Color3.fromRGB(28, 28, 36), 1)

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 3)
    listLayout.Parent = listContainer

    local listPadding = Instance.new("UIPadding")
    listPadding.PaddingTop = UDim.new(0, 4)
    listPadding.PaddingBottom = UDim.new(0, 4)
    listPadding.PaddingLeft = UDim.new(0, 4)
    listPadding.PaddingRight = UDim.new(0, 4)
    listPadding.Parent = listContainer

    -- Bottom row: count label + Clear All button
    local btmRow = Instance.new("Frame")
    btmRow.Name = "BottomWatchlistRow"
    btmRow.Size = UDim2.new(1, 0, 0, 22)
    btmRow.BackgroundTransparency = 1
    btmRow.Parent = secWatch

    local countLabel = Instance.new("TextLabel")
    countLabel.Name = "CountLabel"
    countLabel.Size = UDim2.new(1, -85, 1, 0)
    countLabel.BackgroundTransparency = 1
    countLabel.Font = Enum.Font.GothamMedium
    countLabel.Text = "В списке: 0 предм."
    countLabel.TextColor3 = self.Theme.TextDim
    countLabel.TextSize = 9.5
    countLabel.TextXAlignment = Enum.TextXAlignment.Left
    countLabel.Parent = btmRow

    local clearBtn = Instance.new("TextButton")
    clearBtn.Name = "ClearAllBtn"
    clearBtn.Size = UDim2.new(0, 78, 0, 20)
    clearBtn.Position = UDim2.new(1, -78, 0.5, -10)
    clearBtn.BackgroundColor3 = Color3.fromRGB(38, 20, 24)
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.Text = "Очистить всё"
    clearBtn.TextColor3 = self.Theme.DangerRed
    clearBtn.TextSize = 9
    clearBtn.AutoButtonColor = true
    clearBtn.Parent = btmRow
    self:Corner(clearBtn, 4)
    self:Stroke(clearBtn, Color3.fromRGB(65, 30, 36), 1)

    local function refreshWatchlistUI()
        for _, ch in ipairs(listContainer:GetChildren()) do
            if not ch:IsA("UIListLayout") and not ch:IsA("UIPadding") then
                ch:Destroy()
            end
        end

        local items = self.Config.WatchlistItems or {}
        countLabel.Text = string.format("В списке: %d предм.", #items)

        if #items == 0 then
            local emptyLabel = Instance.new("TextLabel")
            emptyLabel.Size = UDim2.new(1, 0, 0, 40)
            emptyLabel.BackgroundTransparency = 1
            emptyLabel.Font = Enum.Font.GothamMedium
            emptyLabel.Text = "Список пуст. Введи название выше и нажми [+]."
            emptyLabel.TextColor3 = self.Theme.TextMuted
            emptyLabel.TextSize = 9.5
            emptyLabel.Parent = listContainer
            return
        end

        for idx, itemName in ipairs(items) do
            local itemRow = Instance.new("Frame")
            itemRow.Name = "ItemRow_" .. tostring(idx)
            itemRow.Size = UDim2.new(1, 0, 0, 22)
            itemRow.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
            itemRow.Parent = listContainer
            self:Corner(itemRow, 4)

            local dot = Instance.new("Frame")
            dot.Size = UDim2.new(0, 4, 0, 4)
            dot.Position = UDim2.new(0, 6, 0.5, -2)
            dot.BackgroundColor3 = Color3.fromRGB(255, 205, 50)
            dot.BorderSizePixel = 0
            dot.Parent = itemRow
            self:Corner(dot, 2)

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -38, 1, 0)
            nameLabel.Position = UDim2.new(0, 16, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Font = Enum.Font.GothamMedium
            nameLabel.Text = itemName
            nameLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
            nameLabel.TextSize = 10
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            nameLabel.Parent = itemRow

            local delBtn = Instance.new("TextButton")
            delBtn.Name = "DelBtn"
            delBtn.Size = UDim2.new(0, 18, 0, 18)
            delBtn.Position = UDim2.new(1, -20, 0.5, -9)
            delBtn.BackgroundColor3 = Color3.fromRGB(36, 18, 22)
            delBtn.Font = Enum.Font.GothamBold
            delBtn.Text = "✕"
            delBtn.TextColor3 = Color3.fromRGB(255, 90, 100)
            delBtn.TextSize = 10
            delBtn.AutoButtonColor = true
            delBtn.Parent = itemRow
            self:Corner(delBtn, 3)

            delBtn.MouseButton1Click:Connect(function()
                table.remove(self.Config.WatchlistItems, idx)
                refreshWatchlistUI()
                self:UpdateWatchlistEsp(self.Config.WatchlistEsp)
            end)
        end
    end

    self.State.RefreshWatchlistUI = refreshWatchlistUI

    local function handleAddItem()
        local raw = watchInput.Text or ""
        watchInput.Text = ""
        local addedCount = 0
        for item in string.gmatch(raw, "[^,]+") do
            local clean = item:match("^%s*(.-)%s*$")
            if clean and clean ~= "" then
                local exists = false
                for _, existing in ipairs(self.Config.WatchlistItems) do
                    if existing:lower() == clean:lower() then
                        exists = true
                        break
                    end
                end
                if not exists then
                    table.insert(self.Config.WatchlistItems, clean)
                    addedCount = addedCount + 1
                end
            end
        end

        if addedCount > 0 then
            refreshWatchlistUI()
            self:UpdateWatchlistEsp(self.Config.WatchlistEsp)
            self:Notify("Watchlist", string.format("Добавлено предметов: %d", addedCount))
        end
    end

    addBtn.MouseButton1Click:Connect(handleAddItem)
    watchInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            handleAddItem()
        end
    end)

    clearBtn.MouseButton1Click:Connect(function()
        if #self.Config.WatchlistItems > 0 then
            self.Config.WatchlistItems = {}
            refreshWatchlistUI()
            self:UpdateWatchlistEsp(self.Config.WatchlistEsp)
            self:Notify("Watchlist", "Список искомых предметов очищен")
        end
    end)

    refreshWatchlistUI()

    -- CARD 3.5: AUTO TELEPORT TO SELLER
    local secTp = self:CreateSection(right, "Авто-ТП к продавцу", Icons.Server)

    local tpRow = Instance.new("Frame")
    tpRow.Name = "TpRow"
    tpRow.Size = UDim2.new(1, 0, 0, 30)
    tpRow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    tpRow.Parent = secTp
    self:Corner(tpRow, 6)
    self:Stroke(tpRow, Color3.fromRGB(34, 34, 44), 1)

    local tpBox = Instance.new("TextBox")
    tpBox.Name = "TeleportItemInput"
    tpBox.Size = UDim2.new(1, -16, 1, 0)
    tpBox.Position = UDim2.new(0, 8, 0, 0)
    tpBox.BackgroundTransparency = 1
    tpBox.Font = Enum.Font.GothamMedium
    tpBox.PlaceholderText = "Предмет для ТП (напр. Python)..."
    tpBox.PlaceholderColor3 = self.Theme.TextMuted
    tpBox.Text = self.Config.TeleportItemName or ""
    tpBox.TextColor3 = self.Theme.TextPrimary
    tpBox.TextSize = 10
    tpBox.TextXAlignment = Enum.TextXAlignment.Left
    tpBox.ClearTextOnFocus = false
    tpBox.Parent = tpRow

    tpBox:GetPropertyChangedSignal("Text"):Connect(function()
        self.Config.TeleportItemName = tpBox.Text:match("^%s*(.-)%s*$") or ""
    end)

    self.State.UpdateTeleportInput = function(val)
        if tpBox then tpBox.Text = val or "" end
    end

    self:CreateButton(secTp, "🚀 Найти продавца и телепортироваться", function()
        self:TeleportToSeller(tpBox.Text)
    end, self.Theme.SuccessGreen, Color3.fromRGB(18, 36, 26))

    self:CreateButton(secTp, "🔍 Пересканировать витрины сейчас (Rescan)", function()
        self:Notify("Plaza", "Сканирование всех витрин сервера...")
        self:ShowJoinServerBanner(true)
    end, self.Theme.AccentGlow, self.Theme.SurfaceLight)

    -- CARD 4: DISCORD WEBHOOK
    local secWebhook = self:CreateSection(right, "Discord Webhook")

    self:CreateToggle(secWebhook, "Отправлять чеки в Webhook", self.Config.WebhookEnabled, function(val)
        self.Config.WebhookEnabled = val
        self:Notify("Webhook", val and "Webhook включен!" or "Webhook выключен")
    end, "WebhookEnabled")

    local whBoxFrame = Instance.new("Frame")
    whBoxFrame.Size = UDim2.new(1, 0, 0, 26)
    whBoxFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    whBoxFrame.Parent = secWebhook
    self:Corner(whBoxFrame, 6)
    self:Stroke(whBoxFrame, Color3.fromRGB(34, 34, 44), 1)

    local whUrlBox = Instance.new("TextBox")
    whUrlBox.Size = UDim2.new(1, -16, 1, 0)
    whUrlBox.Position = UDim2.new(0, 8, 0, 0)
    whUrlBox.BackgroundTransparency = 1
    whUrlBox.Font = Enum.Font.GothamMedium
    whUrlBox.PlaceholderText = "Paste Discord Webhook URL..."
    whUrlBox.PlaceholderColor3 = self.Theme.TextMuted
    whUrlBox.Text = self.Config.WebhookUrl or ""
    whUrlBox.TextColor3 = self.Theme.TextPrimary
    whUrlBox.TextSize = 10
    whUrlBox.TextXAlignment = Enum.TextXAlignment.Left
    whUrlBox.ClearTextOnFocus = false
    whUrlBox.Parent = whBoxFrame

    whUrlBox:GetPropertyChangedSignal("Text"):Connect(function()
        self.Config.WebhookUrl = whUrlBox.Text:gsub("%s+", "")
    end)

    self:CreateButton(secWebhook, "Тест вебхука", function()
        if not self.Config.WebhookUrl or self.Config.WebhookUrl == "" then
            self:Notify("Webhook", "Сначала вставь ссылку вебхука!")
            return
        end
        local oldState = self.Config.WebhookEnabled
        self.Config.WebhookEnabled = true
        self:SendDiscordWebhook({
            Name = "Illumina (Тестовый лот)",
            Price = 15000,
            Buyer = "TestBuyer_123",
            Icon = "rbxassetid://7734053495"
        })
        self.Config.WebhookEnabled = oldState
        self:Notify("Webhook", "Тестовый чек отправлен в Discord!")
    end, self.Theme.AccentGlow)
end

-- ==================== TAB 3: SETTINGS ====================
function Hub:BuildSettingsTab(page)
    local left, right = self:CreateDualColumn(page)

    -- CARD 1: EXACT DYNAMIC HUB CONFIG MANAGER
    local cfgSec = self:CreateSection(left, "Configs")

    local inputRow = Instance.new("Frame")
    inputRow.Size = UDim2.new(1, 0, 0, 30)
    inputRow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    inputRow.Parent = cfgSec
    self:Corner(inputRow, 6)
    self:Stroke(inputRow, Color3.fromRGB(34, 34, 44), 1)

    local nameBox = Instance.new("TextBox")
    nameBox.Size = UDim2.new(1, -16, 1, 0)
    nameBox.Position = UDim2.new(0, 10, 0, 0)
    nameBox.BackgroundTransparency = 1
    nameBox.Font = Enum.Font.GothamMedium
    nameBox.PlaceholderText = "Config name..."
    nameBox.PlaceholderColor3 = self.Theme.TextMuted
    nameBox.Text = ""
    nameBox.TextColor3 = self.Theme.TextPrimary
    nameBox.TextSize = 11
    nameBox.TextXAlignment = Enum.TextXAlignment.Left
    nameBox.ClearTextOnFocus = false
    nameBox.Parent = inputRow

    local listContainer = Instance.new("Frame")
    listContainer.Size = UDim2.new(1, 0, 0, 140)
    listContainer.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
    listContainer.Parent = cfgSec
    self:Corner(listContainer, 6)
    self:Stroke(listContainer, Color3.fromRGB(28, 28, 38), 1)

    local listScroll = Instance.new("ScrollingFrame")
    listScroll.Size = UDim2.new(1, -6, 1, -6)
    listScroll.Position = UDim2.new(0, 3, 0, 3)
    listScroll.BackgroundTransparency = 1
    listScroll.BorderSizePixel = 0
    listScroll.ScrollBarThickness = 3
    listScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 75)
    listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listScroll.Parent = listContainer

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 3)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listScroll

    local listPad = Instance.new("UIPadding")
    listPad.PaddingTop = UDim.new(0, 2)
    listPad.PaddingBottom = UDim.new(0, 2)
    listPad.PaddingLeft = UDim.new(0, 2)
    listPad.PaddingRight = UDim.new(0, 4)
    listPad.Parent = listScroll

    -- 4-ICON BUTTONS ROW (1:1 Dynamic Hub)
    local iconsRow = Instance.new("Frame")
    iconsRow.Size = UDim2.new(1, 0, 0, 32)
    iconsRow.BackgroundTransparency = 1
    iconsRow.ClipsDescendants = false
    iconsRow.Parent = cfgSec

    local iconLayout = Instance.new("UIListLayout")
    iconLayout.FillDirection = Enum.FillDirection.Horizontal
    iconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    iconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    iconLayout.Padding = UDim.new(0, 8)
    iconLayout.SortOrder = Enum.SortOrder.LayoutOrder
    iconLayout.Parent = iconsRow

    local function createIconButton(order, iconAsset, defaultTooltip)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.25, -6, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.LayoutOrder = order
        btn.ClipsDescendants = false
        btn.ZIndex = 25
        btn.Parent = iconsRow
        self:Corner(btn, 6)
        local stroke = self:Stroke(btn, Color3.fromRGB(34, 34, 44), 1)

        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, 16, 0, 16)
        img.Position = UDim2.new(0.5, -8, 0.5, -8)
        img.BackgroundTransparency = 1
        img.Image = iconAsset
        img.ImageColor3 = Color3.fromRGB(215, 215, 225)
        img.ZIndex = 26
        img.Parent = btn

        local tip = Instance.new("Frame")
        tip.Size = UDim2.new(0, 0, 0, 20)
        tip.AutomaticSize = Enum.AutomaticSize.X
        tip.AnchorPoint = Vector2.new(0.5, 1)
        tip.Position = UDim2.new(0.5, 0, 0, -6)
        tip.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        tip.BorderSizePixel = 0
        tip.ZIndex = 50
        tip.Visible = false
        tip.Parent = btn
        self:Corner(tip, 4)
        self:Stroke(tip, Color3.fromRGB(48, 48, 62), 1)

        local tipPad = Instance.new("UIPadding")
        tipPad.PaddingLeft = UDim.new(0, 6)
        tipPad.PaddingRight = UDim.new(0, 6)
        tipPad.PaddingTop = UDim.new(0, 2)
        tipPad.PaddingBottom = UDim.new(0, 2)
        tipPad.Parent = tip

        local tipLbl = Instance.new("TextLabel")
        tipLbl.Size = UDim2.new(1, 0, 1, 0)
        tipLbl.AutomaticSize = Enum.AutomaticSize.X
        tipLbl.BackgroundTransparency = 1
        tipLbl.Font = Enum.Font.GothamMedium
        tipLbl.Text = defaultTooltip
        tipLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        tipLbl.TextSize = 10
        tipLbl.ZIndex = 51
        tipLbl.Parent = tip

        btn.MouseEnter:Connect(function()
            tip.Visible = true
            self:Tween(btn, { BackgroundColor3 = Color3.fromRGB(28, 28, 36) }, 0.15)
            self:Tween(stroke, { Color = Color3.fromRGB(55, 55, 70) }, 0.15)
            self:Tween(img, { ImageColor3 = Color3.fromRGB(255, 255, 255) }, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            tip.Visible = false
            self:Tween(btn, { BackgroundColor3 = Color3.fromRGB(20, 20, 26) }, 0.15)
            self:Tween(stroke, { Color = Color3.fromRGB(34, 34, 44) }, 0.15)
            self:Tween(img, { ImageColor3 = Color3.fromRGB(215, 215, 225) }, 0.15)
        end)
        return btn, img, stroke, tip, tipLbl
    end

    local saveBtn, saveImg, saveStroke, saveTip, saveTipLbl = createIconButton(1, "rbxassetid://7734052335", "Save Config")
    local loadBtn, loadImg, loadStroke, loadTip, loadTipLbl = createIconButton(2, "rbxassetid://7733770755", "Load Config")
    local autoBtn, autoImg, autoStroke, autoTip, autoTipLbl = createIconButton(3, "rbxassetid://7734068321", "Set Autoload")
    local delBtn, delImg, delStroke, delTip, delTipLbl   = createIconButton(4, "rbxassetid://7743873871", "Delete Config")

    local function updateAutoloadBtnVisual()
        local curName = nameBox.Text
        local autoName, isAuto = self:GetAutoload()
        if isAuto and autoName and autoName ~= "" and autoName == curName then
            autoTipLbl.Text = "Remove Autoload"
            autoImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
            autoBtn.BackgroundColor3 = Color3.fromRGB(34, 34, 46)
            autoStroke.Color = Color3.fromRGB(80, 80, 100)
        else
            autoTipLbl.Text = "Set Autoload"
            autoImg.ImageColor3 = Color3.fromRGB(215, 215, 225)
            autoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            autoStroke.Color = Color3.fromRGB(34, 34, 44)
        end
    end

    local function refreshConfigList()
        for _, child in ipairs(listScroll:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        local configs = self:GetConfigsList()
        local curName = nameBox.Text
        local autoName, isAuto = self:GetAutoload()

        if #configs == 0 then
            local emptyLbl = Instance.new("TextLabel")
            emptyLbl.Size = UDim2.new(1, 0, 0, 24)
            emptyLbl.BackgroundTransparency = 1
            emptyLbl.Font = Enum.Font.Gotham
            emptyLbl.Text = "No configs found"
            emptyLbl.TextColor3 = Color3.fromRGB(100, 100, 115)
            emptyLbl.TextSize = 11
            emptyLbl.Parent = listScroll
            return
        end

        for _, cfgName in ipairs(configs) do
            local isSelected = (cfgName == curName)
            local isItemAuto = (isAuto and autoName == cfgName)

            local itemBtn = Instance.new("TextButton")
            itemBtn.Size = UDim2.new(1, 0, 0, 24)
            itemBtn.BackgroundColor3 = isSelected and Color3.fromRGB(28, 30, 40) or Color3.fromRGB(18, 18, 24)
            itemBtn.Text = ""
            itemBtn.AutoButtonColor = false
            itemBtn.Parent = listScroll
            self:Corner(itemBtn, 4)
            local itemStroke = self:Stroke(itemBtn, isSelected and Color3.fromRGB(55, 60, 80) or Color3.fromRGB(28, 28, 36), 1)

            local ind = Instance.new("Frame")
            ind.Size = UDim2.new(0, 3, 0.65, 0)
            ind.Position = UDim2.new(0, 3, 0.5, 0)
            ind.AnchorPoint = Vector2.new(0, 0.5)
            ind.BackgroundColor3 = isSelected and Color3.fromRGB(240, 240, 255) or Color3.fromRGB(42, 42, 54)
            ind.BorderSizePixel = 0
            ind.Parent = itemBtn
            self:Corner(ind, 2)

            local titleLbl = Instance.new("TextLabel")
            titleLbl.Size = UDim2.new(1, -65, 1, 0)
            titleLbl.Position = UDim2.new(0, 12, 0, 0)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Font = isSelected and Enum.Font.GothamBold or Enum.Font.GothamMedium
            titleLbl.Text = cfgName
            titleLbl.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 175)
            titleLbl.TextSize = 11
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            titleLbl.Parent = itemBtn

            if isItemAuto then
                local autoBadge = Instance.new("Frame")
                autoBadge.Size = UDim2.new(0, 48, 0, 16)
                autoBadge.Position = UDim2.new(1, -52, 0.5, -8)
                autoBadge.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
                autoBadge.BorderSizePixel = 0
                autoBadge.Parent = itemBtn
                self:Corner(autoBadge, 3)
                self:Stroke(autoBadge, Color3.fromRGB(45, 45, 60), 1)

                local badgeText = Instance.new("TextLabel")
                badgeText.Size = UDim2.new(1, 0, 1, 0)
                badgeText.BackgroundTransparency = 1
                badgeText.Font = Enum.Font.GothamBold
                badgeText.Text = "AUTO"
                badgeText.TextColor3 = Color3.fromRGB(200, 200, 215)
                badgeText.TextSize = 9
                badgeText.Parent = autoBadge
            end

            itemBtn.MouseEnter:Connect(function()
                if not (nameBox.Text == cfgName) then
                    self:Tween(itemBtn, { BackgroundColor3 = Color3.fromRGB(24, 24, 32) }, 0.15)
                end
            end)
            itemBtn.MouseLeave:Connect(function()
                if not (nameBox.Text == cfgName) then
                    self:Tween(itemBtn, { BackgroundColor3 = Color3.fromRGB(18, 18, 24) }, 0.15)
                end
            end)

            itemBtn.MouseButton1Click:Connect(function()
                nameBox.Text = cfgName
                self.State.SelectedConfig = cfgName
                updateAutoloadBtnVisual()
                refreshConfigList()
            end)
        end
    end

    saveBtn.MouseButton1Click:Connect(function()
        local name = nameBox.Text:gsub("%s+", "")
        if name ~= "" then
            self:SaveConfig(name)
            refreshConfigList()
            updateAutoloadBtnVisual()
        end
    end)

    loadBtn.MouseButton1Click:Connect(function()
        local name = nameBox.Text:gsub("%s+", "")
        if name ~= "" then
            self:LoadConfig(name)
        end
    end)

    autoBtn.MouseButton1Click:Connect(function()
        local curName = nameBox.Text:gsub("%s+", "")
        if curName ~= "" then
            local autoName, isAuto = self:GetAutoload()
            if isAuto and autoName == curName then
                self:SetAutoload(nil)
            else
                self:SetAutoload(curName)
            end
            updateAutoloadBtnVisual()
            refreshConfigList()
        end
    end)

    delBtn.MouseButton1Click:Connect(function()
        local name = nameBox.Text:gsub("%s+", "")
        if name ~= "" then
            self:DeleteConfig(name)
            nameBox.Text = ""
            self.State.SelectedConfig = ""
            updateAutoloadBtnVisual()
            refreshConfigList()
        end
    end)

    nameBox.FocusLost:Connect(function()
        updateAutoloadBtnVisual()
        refreshConfigList()
    end)

    nameBox:GetPropertyChangedSignal("Text"):Connect(function()
        updateAutoloadBtnVisual()
    end)

    refreshConfigList()
    updateAutoloadBtnVisual()

    -- CARD 2: SCRIPT CONTROL
    local actSec = self:CreateSection(right, "Script Control")

    self:CreateToggle(actSec, "Закрывать GUI при старте", self.Config.CloseGuiOnStart, function(val)
        self.Config.CloseGuiOnStart = val
    end, "CloseGuiOnStart")

    self:CreateToggle(actSec, "Fast Load (пропуск заставок)", self.Config.FastLoad, function(val)
        self.Config.FastLoad = val
        if val then self:ApplyFastLoad() end
    end, "FastLoad")

    self:CreateToggle(actSec, "⚡ Ultra Fast Load (FPS Boost)", self.Config.UltraFastLoad, function(val)
        self.Config.UltraFastLoad = val
        self:ApplyUltraFastLoad(val)
        self:Notify("Ultra Fast Load", val and "Мир очищен! Максимальный FPS." or "Графика и эффекты восстановлены!")
    end, "UltraFastLoad")

    self:CreateButton(actSec, "⚡ Очистить мир (Макс. FPS)", function()
        self:ApplyUltraFastLoad(true)
        self:Notify("FPS Boost", "Все партиклы, шейдеры и декорации отключены!")
    end, self.Theme.SuccessGreen, Color3.fromRGB(18, 36, 26))

    self:CreateButton(actSec, "🔄 Восстановить графику и эффекты", function()
        self:ApplyUltraFastLoad(false)
        self:Notify("Graphics", "Вся графика и спецэффекты восстановлены!")
    end, self.Theme.AccentGlow, self.Theme.SurfaceLight)

    self:CreateButton(actSec, "Unload Script", function()
        self:Unload()
    end, self.Theme.DangerRed, self.Theme.DangerDark)

    self:CreateButton(actSec, "Rejoin Server", function()
        self:TriggerRejoin("Settings Rejoin")
    end, self.Theme.AccentGlow)
end

-- ==================== DRAGGING & KEYBINDS ====================
function Hub:SetupDragging(topbar, main, shadow)
    local dragging = false
    local dragInput, dragStart, startPos

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    self.Services.UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            main.Position = newPos
            if shadow then
                shadow.Position = newPos
            end
        end
    end)
end

function Hub:ToggleMenu(forceState)
    if forceState ~= nil then
        self.State.IsOpen = forceState
    else
        self.State.IsOpen = not self.State.IsOpen
    end

    local main = self.State.MainFrame
    local shadow = self.State.Shadow
    if not main then return end

    if self.State.IsOpen then
        main.Visible = true
        if shadow then shadow.Visible = true end
        self:Tween(main, { BackgroundTransparency = 0 }, 0.15)
        if shadow then self:Tween(shadow, { ImageTransparency = 0.35 }, 0.15) end
    else
        self:Tween(main, { BackgroundTransparency = 1 }, 0.15)
        if shadow then self:Tween(shadow, { ImageTransparency = 1 }, 0.15) end
        task.delay(0.15, function()
            if not self.State.IsOpen then
                main.Visible = false
                if shadow then shadow.Visible = false end
            end
        end)
    end
end

function Hub:SetupKeybind()
    local conn = self.Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed then
            if input.KeyCode == self.Config.MenuKey then
                self:ToggleMenu()
            elseif self.Config.Key_OpenIndex and input.KeyCode == self.Config.Key_OpenIndex then
                local hovered = self:GetHoveredBoothItem()
                if hovered and hovered ~= "" then
                    self:OpenSelectedItemInIndex(hovered)
                elseif self.State.InStatsMode then
                    self:CloseIndexStats()
                else
                    self:OpenSelectedItemInIndex()
                end
            end
        end
    end)
    table.insert(self.State.Connections, conn)
end

-- INITIALIZE
Hub:BuildUI()

-- Autoload saved configuration if set
pcall(function()
    local autoName, isAuto = Hub:GetAutoload()
    if isAuto and autoName and autoName ~= "" then
        Hub:LoadConfig(autoName)
    end
end)

-- Apply Fast Load optimizations (skip cutscenes, popups & blackouts)
Hub:ApplyFastLoad()
if Hub.Config.UltraFastLoad and Hub.ApplyUltraFastLoad then
    Hub:ApplyUltraFastLoad(true)
end

-- Show Join Server Watchlist notification banner at top of screen
Hub:ShowJoinServerBanner()

-- Setup permanent live observer for new booth listings while on server
Hub:SetupBoothObserver()

-- Ensure native Index starts completely clean (ItemPreview hidden, ItemsList visible)
pcall(function()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local indexGui = pg and pg:FindFirstChild("Index")
    local ml = indexGui and indexGui:FindFirstChild("Main") and indexGui.Main:FindFirstChild("Left") and indexGui.Main.Left:FindFirstChild("MainLabel")
    if ml then
        if ml:FindFirstChild("ItemPreview") then ml.ItemPreview.Visible = false end
        if ml:FindFirstChild("ItemsList") then ml.ItemsList.Visible = true end
        if ml:FindFirstChild("RapChart") then ml.RapChart.Visible = false end
    end
end)

-- Ensure character joints and sword are reset
pcall(function()
    local char = LocalPlayer.Character
    if char then
        local torso = char:FindFirstChild("Torso")
        if torso and torso:FindFirstChild("Motor6D") then
            torso.Motor6D.Enabled = true
        end
        for _, d in ipairs(char:GetDescendants()) do
            if d.Name == "Adjustment6D" then d:Destroy() end
            if d:IsA("Trail") then d.Enabled = false end
        end
    end
end)

print("[Dynamic Hub] Blade Ball Trade Plaza Edition loaded with Booth Modules & Item RAP Inspector! Toggle: [Right Control].")

_G.DynamicTradeHub = Hub
