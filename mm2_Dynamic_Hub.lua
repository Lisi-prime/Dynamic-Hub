if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("Welcome to Dynamic Hub")

local syn = rawget(_G, "syn") or (getgenv and getgenv().syn)
local removefile = rawget(_G, "removefile") or (getgenv and getgenv().removefile)
local deletefile = rawget(_G, "deletefile") or (getgenv and getgenv().deletefile)
local Hub = {
    Services = {
        AssetService = game:GetService("AssetService"),
        CollectionService = game:GetService("CollectionService"),
        Players = game:GetService("Players"),
        TweenService = game:GetService("TweenService"),
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        HttpService = game:GetService("HttpService"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        Workspace = game:GetService("Workspace"),
        Lighting = game:GetService("Lighting"),
        TeleportService = game:GetService("TeleportService"),
        GuiService = game:GetService("GuiService"),
        VirtualInputManager = (function()
            local vim = nil
            pcall(function() vim = game:GetService("VirtualInputManager") end)
            return vim
        end)(),
        CoreGui = (function()
            local cg = nil
            pcall(function() cg = game:GetService("CoreGui") end)
            return cg
        end)(),
        StarterGui = (function()
            local sg = nil
            pcall(function() sg = game:GetService("StarterGui") end)
            return sg
        end)(),
    },
    Config = {
        ActiveTab = "Combat",
        MenuKey = Enum.KeyCode.RightControl,
        IsListeningMenuKey = false,
        ShootKey = Enum.KeyCode.Unknown,
        IsListeningShootKey = false,
        SelectedTargetPlayer = nil,
        Toggles = {
            SilentAim = false,
            AimWallbang = false,
            AimPrediction = false,
            FlickShot = false,
            AutoShotMurderer = false,
            AutoGrabGun = false,
            KillAll = false,
            KillAura = false,
            AutoKillSheriff = false,
            ESPRoles = false,
            LocalESP = false,
            ESPRoleText = false,
            ESPNickname = false,
            ESPDist = false,
            ESPBoxes = false,
            ESPTracers = false,
            ESPGun = false,
            OnlyImportantRoles = false,
            PreviewRotate = false,
            PreviewAura = false,
            CustomCrosshair = false,
            CrosshairSpin = false,
            CrosshairOnlyGun = false,
            CrosshairHideDefault = false,
            CrosshairDot = false,
            FullBright = false,
            NoFog = false,
            WorldShadows = false,
            XRay = false,
            SpeedHack = false,
            InfiniteJump = false,
            NoClip = false,
            AntiAFK = false,
            VoteDup = false,
            ShowSkinValues = false,
            ShowInventoryValues = false,
            ShowTradeValues = false,
            AutoFarm = false,
            AutoPrestige = false,
            AutoFarmSafeZone = false,
            AutoFarmAvoidMurder = false,
            AutoFarmFlingMurderOnDeath = false,
            AutoFarmAutoReset = false,
            AutoFarmKillAllOnFull = false,
            AutoFarmShootMurdererOnFull = false,
            PotatoOptimizer = false,
            AntiFling = false,
            WalkFling = false,
            Watermark = true,
            BulletTracers = false,
            AutoRejoin = false,
            AntiStuckLoading = false,
        },
        Values = {
            PredictionPercent = 50,
            FlickMode = "Mouse",
            KillAllMode = "Classic",
            KillMode = "Classic",
            KillSheriffMode = "Classic",
            KillAuraDist = 18,
            AutoFarmMode = "Basic",
            AutoFarmSpeed = 23,
            AutoFarmBagLimit = 50,
            AutoFarmTPDelay = 0.85,
            WalkSpeed = 24,
            CameraFOV = 70,
            ClockTime = 14,
            AmbientTint = "Default",
            XRayTransparency = 65,
            CrosshairSpinSpeed = 3,
            CrosshairSize = 12,
            CrosshairThickness = 2,
            CrosshairGap = 5,
            CrosshairColor = "Accent",
            PreviewZoom = 7.2,
            PreviewHeight = 0.1,
            PreviewRotateSpeed = 3,
            ValuesURL = "https://raw.githubusercontent.com/Lisi-prime/mm2_skin/main/values.json",
        }
    },
    Controls = {
        Toggles = {},
        Sliders = {},
        Dropdowns = {},
        Keybinds = {},
    },
    Theme = {
        MainBg = Color3.fromRGB(15, 15, 18),
        TopBarBg = Color3.fromRGB(19, 19, 24),
        SubHeaderBg = Color3.fromRGB(17, 17, 21),
        CardBg = Color3.fromRGB(24, 24, 30),
        CardHover = Color3.fromRGB(30, 30, 38),
        Border = Color3.fromRGB(36, 36, 46),
        Accent = Color3.fromRGB(255, 255, 255),
        AccentGlow = Color3.fromRGB(240, 240, 255),
        AccentDark = Color3.fromRGB(38, 38, 48),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(160, 160, 175),
        TextMuted = Color3.fromRGB(105, 105, 118),
        SheriffBlue = Color3.fromRGB(50, 160, 255),
        MurderRed = Color3.fromRGB(255, 65, 85),
        InnocentGray = Color3.fromRGB(195, 200, 215),
        InnocentGreen = Color3.fromRGB(195, 200, 215),
        HeroYellow = Color3.fromRGB(255, 215, 60),
        ZombieGreen = Color3.fromRGB(40, 240, 90),
        SurvivorBlue = Color3.fromRGB(45, 150, 255),
    },
    State = {
        Gui = nil,
        MainFrame = nil,
        Shadow = nil,
        TopBar = nil,
        IsOpen = true,
        Tabs = {},
        TabButtons = {},
        Connections = {},
        OriginalSheriff = nil,
        PotatoBackup = {},
        PotatoLightingBackup = nil,
        NavCapsule = nil,
        TabIndicator = nil,
        ButtonsHolder = nil,
        SidePanel = nil,
        SidePanelOpen = false,
        SideArrowBtn = nil,
        SideArrowLabel = nil,
        SideShadow = nil,
        SideTooltip = nil,
        WindowSize = nil,
        Device = nil,
    },
    ESP = {
        Highlights = {},
        Drawings = {},
        PlayerRoles = {},
        GuiCache = {},
        GunHighlight = nil,
        GunBillboard = nil,
        GunBillboardBot = nil,
        GunDrawing = nil,
    },
    Crosshair = {
        Gui = nil,
        Container = nil,
        Dot = nil,
        Lines = {},
        OriginalTransparency = nil,
        Connection = nil,
    },
    Preview = {
        Viewport = nil,
        World = nil,
        Camera = nil,
        Model = nil,
        Yaw = 0,
        Pitch = 0,
        Dragging = false,
        LastMouse = Vector2.new(0, 0),
        AuraEmitter = nil,
    },
    World = {
        Section = nil,
        OrigAmbient = nil,
        OrigClockTime = nil,
        OrigFogEnd = nil,
        OrigShadows = nil,
        OriginalTransparency = {},
        XRayConnection = nil,
    },
    Maps = {
        DupRunning = false,
        SelectedPad = nil,
        Cards = {},
        Cached = {
            VotePad1 = { MapName = "Map 1", Votes = "0", Image = "rbxassetid://10747384394" },
            VotePad2 = { MapName = "Map 2", Votes = "0", Image = "rbxassetid://10747384394" },
            VotePad3 = { MapName = "Map 3", Votes = "0", Image = "rbxassetid://10747384394" },
        },
        StatusLabel = nil,
    },
    ValuesSystem = {
        DatabaseURL = "https://raw.githubusercontent.com/Lisi-prime/mm2_skin/main/values.json",
        LastFetch = 0,
        FetchInterval = 300,
        CachedValues = {},
        StructuredValues = {},
        TradeOverlayGui = nil,
        InventoryHeader = nil,
    },
    Combat = {
        AimHooked = false,
        LastShot = 0,
        IsFiringOurself = false,
    },
    Animations = {
        CurrentTrack = nil,
        EmoteTrack = nil,
        EmoteWalk = true,
        Favorites = {},
        ActiveTab = "Animations",
        SearchQuery = "",
        ListContainer = nil,
        List = {
            { Id = "4212455378", Name = "Ninja Animation", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "2510198475", Name = "Zombie Walk", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "3303162083", Name = "Vampire Walk", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "4551322476", Name = "Sneaky Walk", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "3303165239", Name = "Levitation Style", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "3303161396", Name = "Toy Animation", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "3303163774", Name = "Mage Animation", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "3303160862", Name = "Cartoony Walk", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "5319847207", Name = "OldSchool Walk", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "3303162791", Name = "Robot Animation", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "4349242221", Name = "Superhero Walk", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "3303164478", Name = "Werewolf Walk", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "3303163273", Name = "Pirate Animation", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "3303161726", Name = "Elder Animation", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "3303162432", Name = "Knight Animation", Category = "Animations", Icon = "rbxassetid://10747384394" },
            { Id = "3303389445", Name = "Dab", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "3303382711", Name = "Zen Pose", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "3303391864", Name = "Floss Dance", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "3303399939", Name = "Hype Dance", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "3303387872", Name = "Electro Shuffle", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "3303385410", Name = "Line Dance", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "3303384210", Name = "Heroic Pose", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "3303393214", Name = "Headless Emote", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "3303395610", Name = "Zombie Dance", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "128777973",  Name = "Wave", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "128777974",  Name = "Cheer", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "128777975",  Name = "Laugh", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "128777976",  Name = "Point", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "182435998",  Name = "Dance 1", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "182436842",  Name = "Dance 2", Category = "Emotes", Icon = "rbxassetid://10747384394" },
            { Id = "182436935",  Name = "Dance 3", Category = "Emotes", Icon = "rbxassetid://10747384394" },
        }
    },
    SkinSystem = {
        DatabaseURL = "https://raw.githubusercontent.com/Lisi-prime/mm2_skin/main/skins.json",
        Loaded = false,
        ByName = {},
        BySlot = { Knife = {}, Gun = {} },
        ByRarity = {},
        Meshes = {},
        Musor = {},
        Saved = {},
        Picked = {},
        CurrentKnife = "None",
        CurrentGun = "None",
        AutoReapply = true,
        LobbyPedestal = true,
        ActiveToolAnims = {},
        ActiveToolSounds = {},
        OriginalToolGrips = {},
        OriginalToolTextures = {},
        NativeEquipped = {},
    },
    AutoFarm = {
        Target = nil,
        HoldCF = nil,
        NoClipCache = {},
        WasDown = false,
        DownRefY = nil,
        LastTouch = 0,
        LastTP = 0,
        CollectedCount = 0,
        CoinsDone = false,
        SawCoins = false,
        Connection = nil,
        DeathFlingTriggered = false,
    }
}
local Icons = {
    Combat = "rbxassetid://10734975692",
    Visuals = "rbxassetid://10723346959",
    Avatar = "rbxassetid://10747373176",
    Skins = "rbxassetid://10734975486",
    Misc = "rbxassetid://10709782497",
    Fun = "rbxassetid://74221781983156",
    Maps = "rbxassetid://10723395215",
    Animation = "rbxassetid://10747372992",
    Settings = "rbxassetid://10734950309",
    Config = "rbxassetid://10734950309",
    StarOutline = "rbxassetid://10709790948",
    StarFilled = "rbxassetid://10709790807",
    Search = "rbxassetid://10734883986",
    Close = "rbxassetid://10747384394",
    MapFallback = "rbxassetid://6527581691",
}
function Hub:GetRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
        or char:FindFirstChildWhichIsA("BasePart")
end
function Hub:GetRoundModule()
    local ok, m = pcall(function()
        local rep = self.Services.ReplicatedStorage
        local mods = rep:FindFirstChild("Modules")
        if mods then
            local crc = mods:FindFirstChild("CurrentRoundClient")
            if crc then return require(crc) end
        end
        return nil
    end)
    if ok and type(m) == "table" then return m end
    return nil
end
function Hub:GetPlayerDataMap()
    local m = self:GetRoundModule()
    if m and type(m.PlayerData) == "table" then
        return m.PlayerData
    end
    local rep = self.Services.ReplicatedStorage
    for _, path in ipairs({ "Remotes.Gameplay.GetCurrentPlayerData", "GetCurrentPlayerData", "GetPlayerData", "Remotes.Gameplay.GetPlayerData", "Remotes.GetPlayerData" }) do
        local rem = rep
        for part in path:gmatch("[^%.]+") do
            rem = rem and rem:FindFirstChild(part)
        end
        if rem and rem:IsA("RemoteFunction") then
            local ok, data = pcall(function() return rem:InvokeServer() end)
            if ok and type(data) == "table" then return data end
        end
    end
    return nil
end
function Hub:IsRoundActive()
    local rtp = self.Services.Workspace:FindFirstChild("RoundTimerPart")
    if rtp then
        local cr = rtp:FindFirstChild("CurrentRound", true)
        if cr and cr:IsA("TextLabel") and cr.Text ~= "" and cr.Text ~= "Current Round" then
            return false
        end
    end
    local data = self:GetPlayerDataMap()
    if data and type(data) == "table" and next(data) ~= nil then
        local hasActiveRole = false
        for _, pData in pairs(data) do
            if type(pData) == "table" and pData.Role and pData.Role ~= "" and pData.Role ~= "Lobby" and (not pData.Dead) and (not pData.Killed) then
                hasActiveRole = true
                break
            end
        end
        if not hasActiveRole then
            return false
        end
        return true
    end
    if self.Services.Workspace:FindFirstChild("GunDrop") then
        return true
    end
    local coinContainer = self.Services.Workspace:FindFirstChild("CoinContainer", true)
    if coinContainer and #coinContainer:GetChildren() > 0 then
        return true
    end
    self.State.OriginalSheriff = nil
    return false
end
function Hub:IsPlayerInRound(player)
    if not player or not player.Character then return false end
    local root = self:GetRoot(player.Character)
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not (root and hum and hum.Health > 0) then return false end
    local data = self:GetPlayerDataMap()
    if data and type(data) == "table" and next(data) ~= nil then
        local pd = data[player.Name]
        if not pd then
            return false
        end
        if pd.Dead or pd.Killed then
            return false
        end
        if not pd.Role or pd.Role == "" or pd.Role == "Lobby" or pd.Role == "Dead" then
            return false
        end
        return true
    end
    if not self:IsRoundActive() then
        return false
    end
    local char = player.Character
    local bp = player:FindFirstChildOfClass("Backpack")
    if char and (char:FindFirstChild("Knife") or (char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool").Name:lower():find("knife"))) then
        return true
    end
    if bp and (bp:FindFirstChild("Knife") or (bp:FindFirstChildWhichIsA("Tool") and bp:FindFirstChildWhichIsA("Tool").Name:lower():find("knife"))) then
        return true
    end
    if char and (char:FindFirstChild("Gun") or (char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool").Name:lower():find("gun"))) then
        return true
    end
    if bp and (bp:FindFirstChild("Gun") or (bp:FindFirstChildWhichIsA("Tool") and bp:FindFirstChildWhichIsA("Tool").Name:lower():find("gun"))) then
        return true
    end
    local lobby = self:GetLobby()
    if lobby then
        local spawns = lobby:FindFirstChild("Spawns")
        local spawnPart = spawns and spawns:FindFirstChildOfClass("SpawnLocation") or (spawns and spawns:FindFirstChildWhichIsA("BasePart"))
        if spawnPart and (root.Position - spawnPart.Position).Magnitude < 120 then
            return false
        end
    end
    return true
end
function Hub:IsBarnMap()
    local map = self:GetActiveMap()
    if map and map.Name and map.Name:lower():find("barn") then
        return true
    end
    local ws = self.Services.Workspace
    local directBarn = ws:FindFirstChild("Barn")
    if directBarn and (directBarn:IsA("Model") or directBarn:IsA("Folder")) then
        return true
    end
    for _, child in ipairs(ws:GetChildren()) do
        if (child:IsA("Model") or child:IsA("Folder")) and child.Name:lower():find("barn") then
            return true
        end
    end
    return false
end
function Hub:IsZombie(player)
    if not player then return false end
    if not self:IsZombieMode() then
        return false
    end
    local char = player.Character
    local bp = player:FindFirstChildOfClass("Backpack")

    -- 1. Official MM2 Character & Player Attribute check (Direct from MM2 code)
    if char and (char:GetAttribute("Zombie") == true or char:GetAttribute("Infected") == true or char:GetAttribute("Role") == "Zombie") then
        return true
    end
    if player:GetAttribute("Zombie") == true or player:GetAttribute("Infected") == true or player:GetAttribute("Role") == "Zombie" then
        return true
    end
    if char and (char:FindFirstChild("Zombie") or char:FindFirstChild("ZombieAnimation") or char:FindFirstChild("Infected")) then
        return true
    end

    -- 2. Official Team check
    if player.Team then
        local t = player.Team.Name:lower()
        if t:find("zombie") or t:find("infect") or t:find("undead") then
            return true
        end
        if t:find("survivor") or t:find("human") or t:find("innocent") then
            return false
        end
    end

    -- 3. PlayerData Map from MM2
    local data = self:GetPlayerDataMap()
    local pd = data and data[player.Name]
    if pd and type(pd) == "table" then
        if pd.Zombified == true or pd.Infected == true or (pd.Role and tostring(pd.Role):lower():find("zombie")) then
            return true
        end
        if pd.Survivor == true or (pd.Role and tostring(pd.Role):lower():find("survivor")) then
            return false
        end
    end

    -- 4. In Zombie/Infection mode: Zombies carry Knife; Survivors carry Gun or empty hands
    local hasKnife = (char and (char:FindFirstChild("Knife") or (char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool").Name:lower():find("knife"))))
        or (bp and (bp:FindFirstChild("Knife") or (bp:FindFirstChildWhichIsA("Tool") and bp:FindFirstChildWhichIsA("Tool").Name:lower():find("knife"))))
    if hasKnife then
        return true
    end

    local hasGun = (char and (char:FindFirstChild("Gun") or (char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool").Name:lower():find("gun"))))
        or (bp and (bp:FindFirstChild("Gun") or (bp:FindFirstChildWhichIsA("Tool") and bp:FindFirstChildWhichIsA("Tool").Name:lower():find("gun"))))
    if hasGun then
        return false
    end

    -- 5. BodyColors check (MM2 gives Zombies bright green skin)
    if char then
        local bc = char:FindFirstChildOfClass("BodyColors")
        if bc then
            local h = bc.HeadColor3
            if h.G > (h.R + 0.15) and h.G > (h.B + 0.15) then
                return true
            end
        end
    end

    return false
end
function Hub:GetPlayerRole(player)
    if not self:IsPlayerInRound(player) then
        return "None"
    end
    local char = player.Character
    local bp = player:FindFirstChildOfClass("Backpack")
    local data = self:GetPlayerDataMap()
    local pd = data and data[player.Name]
    if self:IsZombieMode() then
        if self:IsZombie(player) then
            return "Zombie"
        else
            return "Survivor"
        end
    end
    local hasKnife = false
    if char and (char:FindFirstChild("Knife") or (char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool").Name:lower():find("knife"))) then
        hasKnife = true
    end
    if bp and (bp:FindFirstChild("Knife") or (bp:FindFirstChildWhichIsA("Tool") and bp:FindFirstChildWhichIsA("Tool").Name:lower():find("knife"))) then
        hasKnife = true
    end
    local hasGun = false
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and (item.Name == "Gun" or item.Name:lower():find("gun")) then
                hasGun = true
                break
            end
        end
    end
    if not hasGun and bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") and (item.Name == "Gun" or item.Name:lower():find("gun")) then
                hasGun = true
                break
            end
        end
    end
    if hasKnife or (pd and pd.Role == "Murderer") then
        return "Murderer"
    end
    if hasGun then
        if pd then
            if pd.Role == "Hero" or pd.Hero == true then
                return "Hero"
            end
            if pd.Role == "Innocent" then
                return "Hero"
            end
            if pd.Role == "Sheriff" then
                if not self.State.OriginalSheriff then
                    self.State.OriginalSheriff = player.Name
                end
                return "Sheriff"
            end
        end
        if self.State.OriginalSheriff and self.State.OriginalSheriff ~= player.Name then
            return "Hero"
        end
        if not self.State.OriginalSheriff then
            self.State.OriginalSheriff = player.Name
            return "Sheriff"
        end
        return "Hero"
    end
    if pd and pd.Role and pd.Role ~= "" and pd.Role ~= "Lobby" and pd.Role ~= "Dead" then
        if pd.Role == "Sheriff" then
            if not self.State.OriginalSheriff then
                self.State.OriginalSheriff = player.Name
            end
            return "Sheriff"
        end
        if pd.Role == "Hero" or pd.Hero == true then
            return "Hero"
        end
        return pd.Role
    end
    return "Innocent"
end
function Hub:GetRoleColor(role)
    if role == "Zombie" then return self.Theme.ZombieGreen or Color3.fromRGB(50, 225, 110)
    elseif role == "Survivor" then return self.Theme.SurvivorBlue or Color3.fromRGB(50, 160, 255)
    elseif role == "Murderer" then return self.Theme.MurderRed
    elseif role == "Sheriff" then return self.Theme.SheriffBlue
    elseif role == "Hero" then return self.Theme.HeroYellow
    else return self.Theme.InnocentGray or Color3.fromRGB(195, 200, 215)
    end
end
function Hub:GetZombieTarget()
    if not self:IsZombieMode() then
        return nil
    end
    local lp = self.Services.Players.LocalPlayer
    local myRoot = lp.Character and self:GetRoot(lp.Character)
    local myPos = myRoot and myRoot.Position
    local bestZombie = nil
    local bestDist = math.huge
    for _, p in ipairs(self.Services.Players:GetPlayers()) do
        if p ~= lp and self:IsPlayerInRound(p) then
            local r = self:GetPlayerRole(p)
            if r == "Zombie" then
                local char = p.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and self:GetRoot(char)
                if hum and hum.Health > 0 and root then
                    local dist = myPos and (root.Position - myPos).Magnitude or 0
                    if dist < bestDist then
                        bestDist = dist
                        bestZombie = p
                    end
                end
            end
        end
    end
    return bestZombie
end
function Hub:IsZombieMode()
    if self:IsBarnMap() then
        return true
    end
    if not self:IsRoundActive() then
        return false
    end
    if self:IsBarnMap() then
        return true
    end
    local data = self:GetPlayerDataMap()
    if data then
        for _, pd in pairs(data) do
            if type(pd) == "table" then
                if pd.Zombified == true or pd.Infected == true then
                    return true
                end
                if pd.Role then
                    local r = tostring(pd.Role):lower()
                    if r:find("zombie") or r:find("survivor") or r:find("infect") then
                        return true
                    end
                end
            end
        end
    end
    for _, p in ipairs(self.Services.Players:GetPlayers()) do
        if p.Team then
            local t = p.Team.Name:lower()
            if t:find("zombie") or t:find("infect") or t:find("survivor") then
                return true
            end
        end
    end
    for _, p in ipairs(self.Services.Players:GetPlayers()) do
        if p:GetAttribute("Zombie") == true or p:GetAttribute("Infected") == true then
            return true
        end
        local c = p.Character
        if c and (c:GetAttribute("Zombie") == true or c:GetAttribute("Infected") == true or c:FindFirstChild("Zombie") or c:FindFirstChild("ZombieAnimation")) then
            return true
        end
    end
    local knifeCount = 0
    for _, p in ipairs(self.Services.Players:GetPlayers()) do
        if self:IsPlayerInRound(p) then
            local c = p.Character
            local bp = p:FindFirstChildOfClass("Backpack")
            if (c and c:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife")) then
                knifeCount = knifeCount + 1
                if knifeCount > 1 then
                    return true
                end
            end
        end
    end
    return false
end
function Hub:GetMurderer()
    local isZ = self:IsBarnMap() or self:IsZombieMode()
    if isZ then
        local zombie = self:GetZombieTarget()
        if zombie then
            return zombie
        end
    end
    for _, p in ipairs(self.Services.Players:GetPlayers()) do
        if p ~= self.Services.Players.LocalPlayer and self:IsPlayerInRound(p) then
            local r = self:GetPlayerRole(p)
            if r == "Murderer" or (isZ and r == "Zombie") then
                local c = p.Character
                local hum = c and c:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    return p
                end
            end
        end
    end
    if self:IsBarnMap() and self:IsZombieMode() then
        local zombie = self:GetZombieTarget()
        if zombie then
            return zombie
        end
    end
    for _, p in ipairs(self.Services.Players:GetPlayers()) do
        if p ~= self.Services.Players.LocalPlayer and self:IsPlayerInRound(p) then
            local c = p.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local bp = p:FindFirstChildOfClass("Backpack")
                if (c and (c:FindFirstChild("Knife") or (c:FindFirstChildWhichIsA("Tool") and c:FindFirstChildWhichIsA("Tool").Name:lower():find("knife"))))
                    or (bp and (bp:FindFirstChild("Knife") or (bp:FindFirstChildWhichIsA("Tool") and bp:FindFirstChildWhichIsA("Tool").Name:lower():find("knife")))) then
                    return p
                end
            end
        end
    end
    return nil
end
function Hub:GetSheriff()
    for _, p in ipairs(self.Services.Players:GetPlayers()) do
        if p ~= self.Services.Players.LocalPlayer then
            local r = self:GetPlayerRole(p)
            if r == "Sheriff" or r == "Hero" then return p end
        end
    end
    for _, p in ipairs(self.Services.Players:GetPlayers()) do
        if p ~= self.Services.Players.LocalPlayer then
            local c = p.Character
            local bp = p:FindFirstChildOfClass("Backpack")
            if (c and (c:FindFirstChild("Gun") or (c:FindFirstChildWhichIsA("Tool") and c:FindFirstChildWhichIsA("Tool").Name:lower():find("gun"))))
                or (bp and (bp:FindFirstChild("Gun") or (bp:FindFirstChildWhichIsA("Tool") and bp:FindFirstChildWhichIsA("Tool").Name:lower():find("gun")))) then
                return p
            end
        end
    end
    return nil
end
function Hub:GetShootRemote()
    local lp = self.Services.Players.LocalPlayer
    local containers = { lp.Character, lp:FindFirstChildOfClass("Backpack") }
    for _, container in ipairs(containers) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") then
                    for _, rName in ipairs({ "Shoot", "ShootEvent", "ShootGun", "Fire" }) do
                        local rem = item:FindFirstChild(rName)
                        if rem and (rem:IsA("RemoteEvent") or rem:IsA("RemoteFunction")) then
                            return rem, item
                        end
                    end
                end
            end
        end
    end
    return nil, nil
end
function Hub:FindKnife()
    local lp = self.Services.Players.LocalPlayer
    local containers = { lp.Character, lp:FindFirstChildOfClass("Backpack") }
    for _, container in ipairs(containers) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and (item.Name:lower():find("knife") or item:FindFirstChild("Slash") or item:FindFirstChild("Stab")) then
                    return item
                end
            end
        end
    end
    return nil
end
function Hub:FindGun()
    local lp = self.Services.Players.LocalPlayer
    local containers = { lp.Character, lp:FindFirstChildOfClass("Backpack") }
    for _, container in ipairs(containers) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and (item.Name == "Gun" or item.Name:lower():find("gun")) then
                    return item
                end
            end
        end
    end
    return nil
end
function Hub:GetAimTargetPart(character)
    if not character then return nil end
    return character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
        or character:FindFirstChild("LowerTorso")
        or character:FindFirstChild("Head")
        or character:FindFirstChild("HumanoidRootPart")
end
function Hub:GetPredictedAimPos(targetPart, forcePrediction)
    if not targetPart then return Vector3.new(0, 0, 0) end
    local char = targetPart.Parent
    -- Aim directly at HumanoidRootPart or Torso for largest collision volume
    local bestPart = (char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))) or targetPart
    local basePos = bestPart.Position

    local shouldPredict = (forcePrediction == true) or (self.Config.Toggles.AimPrediction == true)
    if not shouldPredict then
        return basePos
    end

    local rootPart = (char and char:FindFirstChild("HumanoidRootPart")) or targetPart
    local vel = rootPart.AssemblyLinearVelocity or rootPart.Velocity or targetPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)

    -- If target is nearly stationary or AFK (idle breathing/physics jitter < 1.2), return EXACT center!
    if vel.Magnitude < 1.2 then
        return basePos
    end

    -- Cap excessive velocity spikes (fling/teleport)
    if vel.Magnitude > 32 then
        vel = vel.Unit * 32
    end

    local lp = self.Services.Players.LocalPlayer
    local ping = 0.04
    pcall(function()
        if lp and lp.GetNetworkPing then
            local rawPing = lp:GetNetworkPing()
            if rawPing and rawPing > 0 then
                ping = rawPing
            end
        end
    end)
    ping = math.clamp(ping, 0.015, 0.15)

    -- Hitscan latency lead: one-way ping + server step
    local lead = math.clamp((ping * 0.5) + 0.016, 0.015, 0.08)
    local horizVel = Vector3.new(vel.X, 0, vel.Z)
    return basePos + (horizVel * lead)
end
function Hub:CalculateWallbangRay(targetPos, targetChar, shooterPos)
    local lp = self.Services.Players.LocalPlayer
    local myChar = lp and lp.Character
    local myHead = myChar and myChar:FindFirstChild("Head")
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local sPos = shooterPos or (myHead and myHead.Position) or (myRoot and (myRoot.Position + Vector3.new(0, 1.5, 0))) or targetPos
    local toTarget = targetPos - sPos
    local totalDist = toTarget.Magnitude
    local dir = totalDist > 0.1 and toTarget.Unit or Vector3.new(0, 0, -1)

    local worldUp = Vector3.new(0, 1, 0)
    local rightVec = dir:Cross(worldUp)
    if rightVec.Magnitude < 0.05 then
        rightVec = Vector3.new(1, 0, 0)
    else
        rightVec = rightVec.Unit
    end
    local upVec = rightVec:Cross(dir).Unit

    local rayParams = self.CombatRayParams
    if not rayParams then
        rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.IgnoreWater = true
        self.CombatRayParams = rayParams
    end
    rayParams.FilterDescendantsInstances = myChar and { myChar } or {}

    local function isPathClear(from, to)
        local delta = to - from
        local dist = delta.Magnitude
        if dist < 0.2 then return true end
        local r = workspace:Raycast(from, delta, rayParams)
        if not r or not r.Instance then return true end
        if targetChar and r.Instance:IsDescendantOf(targetChar) then return true end
        if r.Instance.Transparency == 1 or not r.Instance.CanCollide then return true end
        return false
    end

    local fromPos = nil

    -- 1. Direct shot from shooter if clear (no wall between shooter and target)
    if isPathClear(sPos + dir * 0.4, targetPos) then
        fromPos = sPos + dir * 0.4
    else
        -- 2. Wallbang: Trace backwards from target towards shooter to find clear space in front of target
        local traceBack = workspace:Raycast(targetPos, -dir * math.clamp(totalDist, 2, 35), rayParams)
        if traceBack and traceBack.Position then
            local clearDist = (traceBack.Position - targetPos).Magnitude
            if clearDist > 0.8 then
                local cand = targetPos - dir * math.clamp(clearDist - 0.35, 0.5, 8.0)
                if isPathClear(cand, targetPos) then
                    fromPos = cand
                end
            end
        end

        -- 3. If target is flush against a wall in front of them, check clearance from above / sides / behind
        if not fromPos then
            local testOffsets = {
                Vector3.new(0, 2.2, 0), -- Direct headshot from above
                upVec * 2.2,
                rightVec * 2.0,
                -rightVec * 2.0,
                dir * 2.0, -- From behind target
                Vector3.new(0, 1.5, 0) + rightVec * 1.5,
                Vector3.new(0, 1.5, 0) - rightVec * 1.5
            }
            for _, offset in ipairs(testOffsets) do
                local cand = targetPos + offset
                if isPathClear(cand, targetPos) then
                    fromPos = cand
                    break
                end
            end
        end

        -- 4. Guaranteed fallback: 1.2 studs right in front of target along shot vector
        if not fromPos then
            fromPos = targetPos - (dir * 1.2)
        end
    end

    local originCF = CFrame.lookAt(fromPos, targetPos)
    local targetCF = CFrame.new(targetPos)
    return originCF, targetCF, fromPos, targetPos
end
function Hub:PerformFlick(targetWorldPos)
    local mode = self.Config.Values.FlickMode or "Mouse"
    local cam = self.Services.Workspace.CurrentCamera
    if not cam then return end
    if mode == "Mouse" then
        local screenPos, onScreen = cam:WorldToViewportPoint(targetWorldPos)
        if onScreen then
            local mouse = self.Services.Players.LocalPlayer:GetMouse()
            local curX, curY = mouse.X, mouse.Y
            local dx = math.floor(screenPos.X - curX)
            local dy = math.floor(screenPos.Y - curY)
            if mousemoverel then
                mousemoverel(dx, dy)
            elseif mousemoveabs then
                mousemoveabs(screenPos.X, screenPos.Y)
            elseif self.Services.VirtualInputManager then
                pcall(function()
                    self.Services.VirtualInputManager:SendMouseMoveEvent(screenPos.X, screenPos.Y, game)
                end)
            end
        end
    else
        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetWorldPos)
    end
end
function Hub:CreateBulletBeam(fromPos, toPos)
    if not self.Config.Toggles.BulletTracers then return end
    if not self:IsRoundActive() then return end
    if not (fromPos and toPos) then return end
    local dist = (toPos - fromPos).Magnitude
    if dist < 0.5 then return end
    if self.Combat.LastTracer and (os.clock() - self.Combat.LastTracer) < 0.04 then return end
    self.Combat.LastTracer = os.clock()

    task.spawn(function()
        local terrain = workspace.Terrain or workspace
        local holder = Instance.new("Folder")
        holder.Name = "BulletTracer"
        holder.Parent = terrain

        local att0 = Instance.new("Attachment")
        att0.WorldPosition = fromPos
        att0.Parent = holder

        local att1 = Instance.new("Attachment")
        att1.WorldPosition = toPos
        att1.Parent = holder

        -- Outer neon glow beam
        local glowBeam = Instance.new("Beam")
        glowBeam.Attachment0 = att0
        glowBeam.Attachment1 = att1
        glowBeam.Width0 = 0.35
        glowBeam.Width1 = 0.35
        glowBeam.LightEmission = 1
        glowBeam.LightInfluence = 0
        glowBeam.FaceCamera = true
        glowBeam.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 235, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 90, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 70, 160))
        })
        glowBeam.Transparency = NumberSequence.new(0.1)
        glowBeam.Parent = holder

        -- Inner white hot core beam
        local coreBeam = Instance.new("Beam")
        coreBeam.Attachment0 = att0
        coreBeam.Attachment1 = att1
        coreBeam.Width0 = 0.12
        coreBeam.Width1 = 0.12
        coreBeam.LightEmission = 1
        coreBeam.LightInfluence = 0
        coreBeam.FaceCamera = true
        coreBeam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        coreBeam.Transparency = NumberSequence.new(0)
        coreBeam.Parent = holder

        -- Impact sparks at hit position
        pcall(function()
            local sparks = Instance.new("ParticleEmitter")
            sparks.Texture = "rbxassetid://446111271"
            sparks.Color = ColorSequence.new(Color3.fromRGB(0, 235, 255))
            sparks.LightEmission = 1
            sparks.Size = NumberSequence.new(0.35, 0)
            sparks.Rate = 0
            sparks.Speed = NumberRange.new(5, 12)
            sparks.Lifetime = NumberRange.new(0.12, 0.22)
            sparks.Parent = att1
            sparks:Emit(6)
        end)

        -- Smooth instant hitscan beam fade out
        local ts = self.Services.TweenService or game:GetService("TweenService")
        local tInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        ts:Create(glowBeam, tInfo, { Width0 = 0, Width1 = 0 }):Play()
        ts:Create(coreBeam, tInfo, { Width0 = 0, Width1 = 0 }):Play()

        task.wait(0.32)
        holder:Destroy()
    end)
end
function Hub:ShootGun(forcedTargetPos, isDirectMurdererTarget, forceWallbang, forcePrediction, allowNoEquip)
    if not self:IsRoundActive() then return false end
    if (os.clock() - self.Combat.LastShot) < 0.2 then return false end
    local remote, gunTool = self:GetShootRemote()
    if not (remote and gunTool) then return false end
    local lp = self.Services.Players.LocalPlayer
    local myChar = lp.Character
    if not myChar then return false end
    local myRoot = self:GetRoot(myChar)
    local hum = myChar:FindFirstChildOfClass("Humanoid")
    if not (myRoot and hum and hum.Health > 0) then return false end
    if gunTool.Parent ~= myChar then
        hum:EquipTool(gunTool)
        task.wait(0.04)
    end
    local targetPos = forcedTargetPos
    local isSilentAimTarget = (isDirectMurdererTarget == true)
    local targetMurderer = nil
    if not targetPos and (isSilentAimTarget or self.Config.Toggles.SilentAim) then
        targetMurderer = self:GetMurderer()
        if targetMurderer and targetMurderer.Character then
            local aimPart = self:GetAimTargetPart(targetMurderer.Character)
            if aimPart then
                targetPos = self:GetPredictedAimPos(aimPart, forcePrediction)
                isSilentAimTarget = true
            end
        end
    elseif isDirectMurdererTarget then
        targetMurderer = self:GetMurderer()
    end
    if not targetPos then
        local mouse = lp:GetMouse()
        targetPos = mouse.Hit.Position
    end
    local hrp = myChar:FindFirstChild("HumanoidRootPart") or myRoot
    local att = hrp:FindFirstChild("GunRaycastAttachment")
    if not att then
        pcall(function()
            att = Instance.new("Attachment")
            att.Name = "GunRaycastAttachment"
            att.Position = Vector3.new(0, 0.5, -1)
            att.Parent = hrp
        end)
    end
    local muzzlePos = (att and att.WorldPosition) or (hrp.Position + Vector3.new(0, 1.5, 0))
    local originCF
    local targetCF
    local useWallbang = forceWallbang or self.Config.Toggles.AimWallbang
    if useWallbang and targetPos then
        local mChar = targetMurderer and targetMurderer.Character
        originCF, targetCF = self:CalculateWallbangRay(targetPos, mChar, muzzlePos)
    else
        local fromPos = (myRoot and (myRoot.Position + Vector3.new(0, 1.5, 0))) or muzzlePos
        originCF = CFrame.lookAt(fromPos, targetPos)
        targetCF = CFrame.new(targetPos)
    end
    self.Combat.LastShot = os.clock()
    pcall(function()
        local shotStart = muzzlePos
        local shotEnd = targetPos
        if shotStart and shotEnd then
            self:CreateBulletBeam(shotStart, shotEnd)
        end
    end)
    self.Combat.IsFiringOurself = true
    pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer(originCF, targetCF)
        else
            remote:InvokeServer(originCF, targetCF)
        end
    end)
    self.Combat.IsFiringOurself = false
    return true
end
function Hub:ShootMurderer(forceWallbang, forcePrediction, allowNoEquip)
    local murderer = self:GetMurderer()
    if murderer and murderer.Character then
        local aimPart = self:GetAimTargetPart(murderer.Character)
        if aimPart then
            local aimPos = self:GetPredictedAimPos(aimPart, forcePrediction)
            return self:ShootGun(aimPos, true, forceWallbang, forcePrediction, allowNoEquip)
        end
    end
    return false
end
function Hub:HookSilentAim()
    if self.Combat.AimHooked then return end
    self.Combat.AimHooked = true

    local function modifyShootArgs(remote, args)
        if not Hub:IsRoundActive() then
            return false
        end
        if Hub.Combat.IsFiringOurself then
            return true
        end
        -- Prevent duplicate firing if user clicked mouse and our direct shoot already executed
        if (os.clock() - Hub.Combat.LastShot) < 0.22 then
            return false
        end

        local lp = Hub.Services.Players.LocalPlayer
        local char = lp and lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return true end

        local att = hrp:FindFirstChild("GunRaycastAttachment")
        local muzzlePos = (att and att.WorldPosition) or (hrp.Position + Vector3.new(0, 1.5, 0))

        local targetPos = nil
        local targetMurderer = nil

        if Hub.Config.Toggles.SilentAim then
            targetMurderer = Hub:GetMurderer()
            if targetMurderer and targetMurderer.Character then
                local tChar = targetMurderer.Character
                local mRoot = Hub:GetRoot(tChar)
                local mHum = tChar:FindFirstChildOfClass("Humanoid")
                if mRoot and mHum and mHum.Health > 0 then
                    -- No distance limit: unlimited cross-map range
                    local aimPart = Hub:GetAimTargetPart(tChar)
                    if aimPart then
                        targetPos = Hub:GetPredictedAimPos(aimPart)
                    end
                end
            end
        end

        if targetPos then
            local toTarget = targetPos - muzzlePos
            local dist = toTarget.Magnitude
            local dir = dist > 0.1 and toTarget.Unit or Vector3.new(0, 0, -1)

            if Hub.Config.Toggles.AimWallbang then
                local originCF, targetCF = Hub:CalculateWallbangRay(targetPos, targetMurderer and targetMurderer.Character, muzzlePos)
                args[1] = originCF
                args[2] = targetCF
            else
                local startCF = (typeof(args[1]) == "CFrame" and args[1]) or CFrame.lookAt(muzzlePos, targetPos)
                args[1] = CFrame.lookAt(startCF.Position, targetPos)
                args[2] = CFrame.new(targetPos)
            end

            pcall(function()
                local bStart = args[1] and args[1].Position or muzzlePos
                local bEnd = args[2] and args[2].Position or targetPos
                Hub:CreateBulletBeam(bStart, bEnd)
            end)
        elseif Hub.Config.Toggles.AimWallbang then
            local destPos = (typeof(args[2]) == "CFrame" and args[2].Position) or (typeof(args[2]) == "Vector3" and args[2])
            if destPos then
                local originCF, targetCF = Hub:CalculateWallbangRay(destPos, nil, muzzlePos)
                args[1] = originCF
                args[2] = targetCF
                pcall(function()
                    Hub:CreateBulletBeam(originCF.Position, targetCF.Position)
                end)
            end
        end

        return true
    end

    if hookmetamethod and newcclosure and getnamecallmethod then
        local oldNC
        oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if (method == "FireServer" or method == "InvokeServer") then
                local n = tostring(self.Name):lower()
                if n == "shoot" or n == "shootevent" or n == "shootgun" or n == "fire" then
                    local args = { ... }
                    local ok = modifyShootArgs(self, args)
                    if not ok then return end
                    if setnamecallmethod then setnamecallmethod(method) end
                    return oldNC(self, table.unpack(args))
                end
            end
            if setnamecallmethod then setnamecallmethod(method) end
            return oldNC(self, ...)
        end))
    end

    if hookfunction and newcclosure then
        pcall(function()
            local dummyRemote = Instance.new("RemoteEvent")
            local oldFireServer
            oldFireServer = hookfunction(dummyRemote.FireServer, newcclosure(function(self, ...)
                local n = tostring(self.Name):lower()
                if n == "shoot" or n == "shootevent" or n == "shootgun" or n == "fire" then
                    local args = { ... }
                    local ok = modifyShootArgs(self, args)
                    if not ok then return end
                    return oldFireServer(self, table.unpack(args))
                end
                return oldFireServer(self, ...)
            end))
        end)
    end
end
function Hub:StabClassic(targetPlr, knife)
    if not self:IsRoundActive() then return end
    local lp = self.Services.Players.LocalPlayer
    local myChar = lp.Character
    local myRoot = myChar and self:GetRoot(myChar)
    local ch = targetPlr.Character
    local root = self:GetRoot(ch)
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not (root and hum and hum.Health > 0 and knife) then return end

    if knife.Parent ~= myChar then
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        if myHum then pcall(function() myHum:EquipTool(knife) end) end
        if knife.Parent ~= myChar then knife.Parent = myChar end
    end
    pcall(function() knife:Activate() end)

    -- Fire knife stab remotes
    local events = knife:FindFirstChild("Events")
    if events then
        local stab = events:FindFirstChild("KnifeStabbed") or events:FindFirstChild("HandleTouched")
        if stab and stab:IsA("RemoteEvent") then
            pcall(function() stab:FireServer(root, root.Position) end)
        end
    end
    for _, o in ipairs(knife:GetDescendants()) do
        if o:IsA("RemoteEvent") then
            pcall(function() o:FireServer(root, root.Position) end)
            pcall(function() o:FireServer() end)
        elseif o:IsA("RemoteFunction") then
            pcall(function() o:InvokeServer(root, root.Position) end)
        end
    end

    if firetouchinterest then
        local handle = knife:FindFirstChild("Handle") or knife:FindFirstChildWhichIsA("BasePart")
        if handle and root then
            pcall(function()
                firetouchinterest(handle, root, 0)
                firetouchinterest(handle, root, 1)
            end)
            if myRoot and myRoot.Parent then
                myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

function Hub:StabSilent(targetPlr, knife)
    if not self:IsRoundActive() then return end
    local lp = self.Services.Players.LocalPlayer
    local myChar = lp.Character
    local myRoot = myChar and self:GetRoot(myChar)
    local ch = targetPlr.Character
    local root = self:GetRoot(ch)
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not (root and hum and hum.Health > 0 and knife) then return end

    local events = knife:FindFirstChild("Events")
    if events then
        local stab = events:FindFirstChild("KnifeStabbed") or events:FindFirstChild("HandleTouched")
        if stab and stab:IsA("RemoteEvent") then
            pcall(function() stab:FireServer(root, root.Position) end)
        end
    end
    for _, o in ipairs(knife:GetDescendants()) do
        if o:IsA("RemoteEvent") then
            pcall(function() o:FireServer(root, root.Position) end)
        elseif o:IsA("RemoteFunction") then
            pcall(function() o:InvokeServer(root, root.Position) end)
        end
    end

    if firetouchinterest then
        local handle = knife:FindFirstChild("Handle") or knife:FindFirstChildWhichIsA("BasePart")
        if handle and root then
            pcall(function()
                firetouchinterest(handle, root, 0)
                firetouchinterest(handle, root, 1)
            end)
            if myRoot and myRoot.Parent then
                myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

function Hub:ExecuteKillAll()
    if not self:IsRoundActive() then return end
    local lp = self.Services.Players.LocalPlayer
    if not self:IsPlayerInRound(lp) then return end
    local myChar = lp.Character
    local myRoot = self:GetRoot(myChar)
    if not (myChar and myRoot) then return end

    local knife = self:FindKnife()
    if not knife then return end

    local handle = knife:FindFirstChild("Handle") or knife:FindFirstChildWhichIsA("BasePart")
    if not handle then return end

    local playersToKill = {}
    for _, p in ipairs(self.Services.Players:GetPlayers()) do
        if p ~= lp and self:IsPlayerInRound(p) then
            local ch = p.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                table.insert(playersToKill, p)
            end
        end
    end

    if #playersToKill == 0 then return end

    -- Equip and activate knife once for all kills
    if knife.Parent ~= myChar then
        local myHum = myChar:FindFirstChildOfClass("Humanoid")
        if myHum then pcall(function() myHum:EquipTool(knife) end) end
        if knife.Parent ~= myChar then knife.Parent = myChar end
    end
    pcall(function() knife:Activate() end)

    -- Zero out physics velocity to prevent fling into space
    myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

    local events = knife:FindFirstChild("Events")
    local stabRemote = events and (events:FindFirstChild("KnifeStabbed") or events:FindFirstChild("HandleTouched"))

    -- Instantaneous kill: hit all players simultaneously in the exact same frame (no sequential wait)
    for _, p in ipairs(playersToKill) do
        local ch = p.Character
        local root = ch and (ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Torso") or ch:FindFirstChild("UpperTorso"))
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if root and hum and hum.Health > 0 then
            if firetouchinterest then
                pcall(function()
                    firetouchinterest(handle, root, 0)
                    firetouchinterest(handle, root, 1)
                end)
            end
            if stabRemote and stabRemote:IsA("RemoteEvent") then
                pcall(function() stabRemote:FireServer(root, root.Position) end)
            end
            for _, o in ipairs(knife:GetDescendants()) do
                if o:IsA("RemoteEvent") and o ~= stabRemote then
                    pcall(function() o:FireServer(root, root.Position) end)
                elseif o:IsA("RemoteFunction") then
                    pcall(function() o:InvokeServer(root, root.Position) end)
                end
            end
        end
    end

    if myRoot and myRoot.Parent then
        myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end

    -- Instant follow-up sweep on the next micro-tick for any high-ping targets
    task.defer(function()
        if not self:IsRoundActive() then return end
        for _, p in ipairs(playersToKill) do
            local ch = p.Character
            local root = ch and (ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Torso") or ch:FindFirstChild("UpperTorso"))
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 and handle and firetouchinterest then
                pcall(function()
                    firetouchinterest(handle, root, 0)
                    firetouchinterest(handle, root, 1)
                end)
            end
        end
        if myRoot and myRoot.Parent then
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end)
end
function Hub:RestoreCollisions()
    local char = self.Services.Players.LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local name = part.Name
            if name == "Torso" or name == "UpperTorso" or name == "LowerTorso" or name == "Head" then
                part.CanCollide = true
            else
                part.CanCollide = false
            end
        end
    end
    if hum then
        hum.PlatformStand = false
        hum.Sit = false
        hum.MaxSlopeAngle = 89
        hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
end
function Hub:KillSheriff()
    local target = self:GetSheriff()
    local knife = self:FindKnife()
    if target and target.Character and knife then
        local mode = self.Config.Values.KillSheriffMode or "Classic"
        task.spawn(function()
            if mode == "Silent" then
                self:StabSilent(target, knife)
            else
                self:StabClassic(target, knife)
            end
        end)
    end
end
function Hub:SetupGunDropWatcher()
    local function checkAndBindGun(obj)
        if not obj then return end
        local name = obj.Name
        if name == "GunDrop" or name:lower():find("gundrop") or (obj:IsA("Tool") and name == "Gun") then
            local handle = obj:IsA("BasePart") and obj or (obj:FindFirstChild("Handle") or obj:FindFirstChild("GunDrop") or obj:FindFirstChildWhichIsA("BasePart"))
            if handle then
                self.State.DroppedGunPart = handle
                local conn
                conn = handle.AncestryChanged:Connect(function(_, parent)
                    if not (parent and handle:IsDescendantOf(self.Services.Workspace)) then
                        if self.State.DroppedGunPart == handle then
                            self.State.DroppedGunPart = nil
                            self:ClearGunESP()
                        end
                        if conn then conn:Disconnect() end
                    end
                end)
            end
        end
    end

    -- Initial check for already spawned dropped gun
    for _, ch in ipairs(self.Services.Workspace:GetChildren()) do
        checkAndBindGun(ch)
    end
    local map = self.Services.Workspace:FindFirstChild("Normal") or self.Services.Workspace:FindFirstChild("Map")
    if map then
        for _, ch in ipairs(map:GetChildren()) do
            checkAndBindGun(ch)
        end
    end

    -- Event-driven zero-cost listener: triggers instantly when gun drops
    local wsConn = self.Services.Workspace.ChildAdded:Connect(function(child)
        checkAndBindGun(child)
        if child:IsA("Model") and (child.Name == "Normal" or child.Name:lower():find("map")) then
            local mapConn = child.ChildAdded:Connect(function(mapChild)
                checkAndBindGun(mapChild)
            end)
            table.insert(self.State.Connections, mapConn)
        end
    end)
    table.insert(self.State.Connections, wsConn)
end

function Hub:GetDroppedGunPart()
    local cached = self.State.DroppedGunPart
    if cached and cached.Parent and cached:IsDescendantOf(self.Services.Workspace) then
        return cached
    end
    self.State.DroppedGunPart = nil
    return nil
end
function Hub:GrabDroppedGun()
    local lp = self.Services.Players.LocalPlayer
    if not self:IsPlayerInRound(lp) then return end
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = self:GetRoot(char)
    if not (char and root and hum and hum.Health > 0) then return end
    local myRole = self:GetPlayerRole(lp)
    if myRole == "Murderer" or myRole == "Zombie" then return end
    local bp = lp:FindFirstChildOfClass("Backpack")
    if char:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife")) then return end
    if char:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun")) then return end
    local handle = self:GetDroppedGunPart()
    if not handle then return end
    if self.State.GrabbingGun then return end
    self.State.GrabbingGun = true
    task.spawn(function()
        pcall(function()
            local myPos = root.Position
            local gunPos = handle.Position
            local dist = (gunPos - myPos).Magnitude
            pcall(function()
                if handle:IsA("BasePart") then
                    handle.CFrame = root.CFrame
                end
            end)
            if dist <= 12 and firetouchinterest then
                for _, part in ipairs({ root, char:FindFirstChild("RightHand"), char:FindFirstChild("Right Arm"), char:FindFirstChild("LeftFoot") }) do
                    if part then
                        firetouchinterest(part, handle, 0)
                        firetouchinterest(part, handle, 1)
                    end
                end
            else
                local oldCF = root.CFrame
                local oldVel = root.AssemblyLinearVelocity
                local targetCF = handle.CFrame + Vector3.new(0, 1.2, 0)
                local startTime = tick()
                while (tick() - startTime) < 0.45 do
                    if char:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun")) then
                        break
                    end
                    if not handle or not handle.Parent then
                        break
                    end
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.CFrame = targetCF
                    if firetouchinterest then
                        firetouchinterest(root, handle, 0)
                        firetouchinterest(root, handle, 1)
                    end
                    task.wait(0.05)
                end
                root.CFrame = oldCF
                root.AssemblyLinearVelocity = oldVel
            end
        end)
        task.wait(0.3)
        self.State.GrabbingGun = false
    end)
end
function Hub:FixToolGrip()
    self:StopAnimation()
    local lp = self.Services.Players.LocalPlayer
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local bp = lp:FindFirstChildOfClass("Backpack")
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and hum and bp then
        tool.Parent = bp
        task.wait(0.08)
        hum:EquipTool(tool)
    end
end
function Hub:ClearGunESP()
    if self.ESP.GunHighlight then
        pcall(function() self.ESP.GunHighlight:Destroy() end)
        self.ESP.GunHighlight = nil
    end
    if self.ESP.GunBillboard then
        pcall(function() self.ESP.GunBillboard:Destroy() end)
        self.ESP.GunBillboard = nil
    end
    if self.ESP.GunBillboardBot then
        pcall(function() self.ESP.GunBillboardBot:Destroy() end)
        self.ESP.GunBillboardBot = nil
    end
    if self.ESP.GunDrawing then
        if self.ESP.GunDrawing.Tracer then
            pcall(function()
                self.ESP.GunDrawing.Tracer.Visible = false
                self.ESP.GunDrawing.Tracer:Remove()
            end)
        end
        self.ESP.GunDrawing = nil
    end
end
function Hub:ClearAllESP()
    for _, h in pairs(self.ESP.Highlights) do
        if h then pcall(function() h:Destroy() end) end
    end
    table.clear(self.ESP.Highlights)
    table.clear(self.ESP.PlayerRoles)

    for _, d in pairs(self.ESP.Drawings) do
        if d.Box then pcall(function() d.Box.Visible = false; d.Box:Remove() end) end
        if d.Tracer then pcall(function() d.Tracer.Visible = false; d.Tracer:Remove() end) end
    end
    table.clear(self.ESP.Drawings)

    if self.ESP.GuiCache then
        for _, cache in pairs(self.ESP.GuiCache) do
            if cache.TopGui then pcall(function() cache.TopGui:Destroy() end) end
            if cache.BotGui then pcall(function() cache.BotGui:Destroy() end) end
        end
        table.clear(self.ESP.GuiCache)
    end

    for _, p in ipairs(self.Services.Players:GetPlayers()) do
        local char = p.Character
        if char then
            local bg = char:FindFirstChild("MM2_ESP_Top")
            if bg then bg:Destroy() end
            local bgBot = char:FindFirstChild("MM2_ESP_Bot")
            if bgBot then bgBot:Destroy() end
        end
    end
    self:ClearGunESP()
end
function Hub:RenderESP()
    if not self.Config.Toggles.ESPRoles and not self.Config.Toggles.ESPGun then
        self:ClearAllESP()
        return
    end
    local lp = self.Services.Players.LocalPlayer
    local myRoot = self:GetRoot(lp.Character)
    local cam = self.Services.Workspace.CurrentCamera
    local roundActive = self:IsRoundActive()
    if self.Config.Toggles.ESPRoles then
        for _, p in ipairs(self.Services.Players:GetPlayers()) do
            local isSelf = (p == lp)
        local char = p.Character
        local root = self:GetRoot(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local isAlive = hum and hum.Health > 0
        local role = self:GetPlayerRole(p)
        local inRound = roundActive and self:IsPlayerInRound(p)
        local shouldRender = inRound and isAlive and root and (role ~= "None") and (role ~= "Dead")
        if isSelf and not self.Config.Toggles.LocalESP then
            shouldRender = false
        end
        if self.Config.Toggles.OnlyImportantRoles and (role == "Innocent" or role == "None") and not isSelf then
            shouldRender = false
        end
        if shouldRender then
            local color = self:GetRoleColor(role)

            -- 1. Highlight (Only update colors when role actually changes!)
            local hl = self.ESP.Highlights[p]
            if not hl or hl.Parent ~= char or hl.Adornee ~= char then
                if hl then pcall(function() hl:Destroy() end) end
                hl = Instance.new("Highlight")
                hl.Name = "MM2_Highlight"
                hl.Adornee = char
                hl.FillTransparency = 0.45
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillColor = color
                hl.OutlineColor = color
                hl.Parent = char
                self.ESP.Highlights[p] = hl
                self.ESP.PlayerRoles[p] = role
            elseif self.ESP.PlayerRoles[p] ~= role then
                hl.FillColor = color
                hl.OutlineColor = color
                self.ESP.PlayerRoles[p] = role
            end

            -- 2. BillboardGui with GuiCache (Zero FindFirstChild calls, Nickname set ONCE, Role set only on change)
            local cache = self.ESP.GuiCache and self.ESP.GuiCache[p]
            if not cache or cache.Character ~= char or not (cache.TopGui and cache.TopGui.Parent) then
                if cache then
                    if cache.TopGui then pcall(function() cache.TopGui:Destroy() end) end
                    if cache.BotGui then pcall(function() cache.BotGui:Destroy() end) end
                end

                local head = char:FindFirstChild("Head") or root
                local topGui = Instance.new("BillboardGui")
                topGui.Name = "MM2_ESP_Top"
                topGui.Adornee = head
                topGui.Size = UDim2.new(0, 160, 0, 36)
                topGui.StudsOffset = Vector3.new(0, 2.4, 0)
                topGui.AlwaysOnTop = true
                topGui.Parent = char

                local lRole = Instance.new("TextLabel")
                lRole.Name = "RoleLabel"
                lRole.Size = UDim2.new(1, 0, 0, 16)
                lRole.BackgroundTransparency = 1
                lRole.Font = Enum.Font.GothamBold
                lRole.TextSize = 12
                lRole.Text = (isSelf and "[YOU] " or "") .. role:upper()
                lRole.TextColor3 = color
                lRole.Visible = self.Config.Toggles.ESPRoleText
                lRole.Parent = topGui

                local lNick = Instance.new("TextLabel")
                lNick.Name = "NickLabel"
                lNick.Size = UDim2.new(1, 0, 0, 16)
                lNick.Position = UDim2.new(0, 0, 0, 16)
                lNick.BackgroundTransparency = 1
                lNick.Font = Enum.Font.GothamMedium
                lNick.TextSize = 11
                lNick.TextColor3 = Color3.fromRGB(240, 240, 245)
                lNick.Text = p.DisplayName .. " (@" .. p.Name .. ")" -- Set ONCE on creation!
                lNick.Visible = self.Config.Toggles.ESPNickname
                lNick.Parent = topGui

                local botGui = Instance.new("BillboardGui")
                botGui.Name = "MM2_ESP_Bot"
                botGui.Adornee = root
                botGui.Size = UDim2.new(0, 120, 0, 18)
                botGui.StudsOffset = Vector3.new(0, -3.2, 0)
                botGui.AlwaysOnTop = true
                botGui.Enabled = false
                botGui.Parent = char

                local lDist = Instance.new("TextLabel")
                lDist.Name = "DistLabel"
                lDist.Size = UDim2.new(1, 0, 1, 0)
                lDist.BackgroundTransparency = 1
                lDist.Font = Enum.Font.GothamBold
                lDist.TextSize = 11
                lDist.TextColor3 = Color3.fromRGB(255, 255, 255)
                lDist.Parent = botGui

                cache = {
                    Character = char,
                    TopGui = topGui,
                    RoleLabel = lRole,
                    NickLabel = lNick,
                    BotGui = botGui,
                    DistLabel = lDist,
                    LastRole = role,
                    LastRoleVis = self.Config.Toggles.ESPRoleText,
                    LastNickVis = self.Config.Toggles.ESPNickname,
                    LastDist = nil
                }
                self.ESP.GuiCache[p] = cache
            else
                -- Update role text and color ONLY if role changed
                if cache.LastRole ~= role then
                    cache.LastRole = role
                    cache.RoleLabel.Text = (isSelf and "[YOU] " or "") .. role:upper()
                    cache.RoleLabel.TextColor3 = color
                end
                -- Update visibility toggles only if changed
                if cache.LastRoleVis ~= self.Config.Toggles.ESPRoleText then
                    cache.LastRoleVis = self.Config.Toggles.ESPRoleText
                    cache.RoleLabel.Visible = self.Config.Toggles.ESPRoleText
                end
                if cache.LastNickVis ~= self.Config.Toggles.ESPNickname then
                    cache.LastNickVis = self.Config.Toggles.ESPNickname
                    cache.NickLabel.Visible = self.Config.Toggles.ESPNickname
                end
            end

            -- Update distance only when needed and when meter distance changes
            local showDist = (not isSelf) and self.Config.Toggles.ESPDist and (myRoot ~= nil)
            if cache.BotGui.Enabled ~= showDist then
                cache.BotGui.Enabled = showDist
            end
            if showDist then
                local dist = math.floor((root.Position - myRoot.Position).Magnitude)
                if cache.LastDist ~= dist then
                    cache.LastDist = dist
                    cache.DistLabel.Text = tostring(dist) .. "m"
                end
            end
                if Drawing and Drawing.new and cam then
                    if not self.ESP.Drawings[p] then
                        self.ESP.Drawings[p] = {}
                    end
                    local d = self.ESP.Drawings[p]
                    if self.Config.Toggles.ESPBoxes then
                        if not d.Box then
                            local ok, box = pcall(function() return Drawing.new("Square") end)
                            if ok then
                                box.Thickness = 1.5
                                box.Filled = false
                                box.Transparency = 1
                                d.Box = box
                            end
                        end
                        if d.Box then
                            local screenPos, onScreen = cam:WorldToViewportPoint(root.Position)
                            if onScreen then
                                local headPos = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 2.8, 0))
                                local legPos = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3.2, 0))
                                local h = math.abs(headPos.Y - legPos.Y)
                                local w = h * 0.65
                                d.Box.Size = Vector2.new(w, h)
                                d.Box.Position = Vector2.new(screenPos.X - w / 2, screenPos.Y - h / 2)
                                d.Box.Color = color
                                d.Box.Visible = true
                            else
                                d.Box.Visible = false
                            end
                        end
                    else
                        if d.Box then d.Box.Visible = false end
                    end
                    if not isSelf and self.Config.Toggles.ESPTracers then
                        if not d.Tracer then
                            local ok, tr = pcall(function() return Drawing.new("Line") end)
                            if ok then
                                tr.Thickness = 1.2
                                tr.Transparency = 0.85
                                d.Tracer = tr
                            end
                        end
                        if d.Tracer then
                            local screenPos, onScreen = cam:WorldToViewportPoint(root.Position)
                            if onScreen then
                                d.Tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                                d.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                                d.Tracer.Color = color
                                d.Tracer.Visible = true
                            else
                                d.Tracer.Visible = false
                            end
                        end
                    else
                        if d.Tracer then d.Tracer.Visible = false end
                    end
                end
            else
                if self.ESP.Highlights[p] then
                    pcall(function() self.ESP.Highlights[p]:Destroy() end)
                    self.ESP.Highlights[p] = nil
                end
                self.ESP.PlayerRoles[p] = nil
                local cache = self.ESP.GuiCache and self.ESP.GuiCache[p]
                if cache then
                    if cache.TopGui then pcall(function() cache.TopGui:Destroy() end) end
                    if cache.BotGui then pcall(function() cache.BotGui:Destroy() end) end
                    self.ESP.GuiCache[p] = nil
                end
                if char then
                    local bg = char:FindFirstChild("MM2_ESP_Top")
                    if bg then bg:Destroy() end
                    local bgBot = char:FindFirstChild("MM2_ESP_Bot")
                    if bgBot then bgBot:Destroy() end
                end
                if self.ESP.Drawings[p] then
                    if self.ESP.Drawings[p].Box then self.ESP.Drawings[p].Box.Visible = false end
                    if self.ESP.Drawings[p].Tracer then self.ESP.Drawings[p].Tracer.Visible = false end
                end
            end
        end
    else
        for _, h in pairs(self.ESP.Highlights) do
            if h then pcall(function() h:Destroy() end) end
        end
        table.clear(self.ESP.Highlights)
        for _, d in pairs(self.ESP.Drawings) do
            if d.Box then pcall(function() d.Box.Visible = false; d.Box:Remove() end) end
            if d.Tracer then pcall(function() d.Tracer.Visible = false; d.Tracer:Remove() end) end
        end
        table.clear(self.ESP.Drawings)
        for _, p in ipairs(self.Services.Players:GetPlayers()) do
            local char = p.Character
            if char then
                local bg = char:FindFirstChild("MM2_ESP_Top")
                if bg then bg:Destroy() end
                local bgBot = char:FindFirstChild("MM2_ESP_Bot")
                if bgBot then bgBot:Destroy() end
            end
        end
    end
    if self.Config.Toggles.ESPGun then
        local gunPart = self:GetDroppedGunPart()
        if gunPart and gunPart:IsDescendantOf(self.Services.Workspace) then
            local gunObj = gunPart
            if gunPart.Parent and gunPart.Parent:IsA("Tool") then
                gunObj = gunPart.Parent
            end
            local gHl = self.ESP.GunHighlight
            if not gHl or gHl.Parent ~= gunObj or gHl.Adornee ~= gunObj then
                if gHl then pcall(function() gHl:Destroy() end) end
                gHl = Instance.new("Highlight")
                gHl.Name = "MM2_Gun_Highlight"
                gHl.Adornee = gunObj
                gHl.FillTransparency = 0.35
                gHl.OutlineTransparency = 0
                gHl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                gHl.FillColor = self.Theme.HeroYellow
                gHl.OutlineColor = Color3.fromRGB(255, 255, 255)
                gHl.Parent = gunObj
                self.ESP.GunHighlight = gHl
            else
                gHl.FillColor = self.Theme.HeroYellow
                gHl.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
            local gBg = self.ESP.GunBillboard
            if not gBg or gBg.Parent ~= gunPart then
                if gBg then pcall(function() gBg:Destroy() end) end
                gBg = Instance.new("BillboardGui")
                gBg.Name = "MM2_Gun_ESP"
                gBg.Adornee = gunPart
                gBg.Size = UDim2.new(0, 140, 0, 18)
                gBg.StudsOffset = Vector3.new(0, 1.4, 0)
                gBg.AlwaysOnTop = true
                gBg.Parent = gunPart
                self.ESP.GunBillboard = gBg
                local lGun = Instance.new("TextLabel")
                lGun.Name = "GunLabel"
                lGun.Size = UDim2.new(1, 0, 1, 0)
                lGun.BackgroundTransparency = 1
                lGun.Font = Enum.Font.GothamBold
                lGun.TextSize = 13
                lGun.TextColor3 = self.Theme.HeroYellow
                lGun.Text = "GUN"
                lGun.Parent = gBg
            end
            local gBgBot = self.ESP.GunBillboardBot
            if not gBgBot or gBgBot.Parent ~= gunPart then
                if gBgBot then pcall(function() gBgBot:Destroy() end) end
                gBgBot = Instance.new("BillboardGui")
                gBgBot.Name = "MM2_Gun_ESP_Bot"
                gBgBot.Adornee = gunPart
                gBgBot.Size = UDim2.new(0, 100, 0, 16)
                gBgBot.StudsOffset = Vector3.new(0, -1.4, 0)
                gBgBot.AlwaysOnTop = true
                gBgBot.Parent = gunPart
                self.ESP.GunBillboardBot = gBgBot
                local lDist = Instance.new("TextLabel")
                lDist.Name = "GunDistLabel"
                lDist.Size = UDim2.new(1, 0, 1, 0)
                lDist.BackgroundTransparency = 1
                lDist.Font = Enum.Font.GothamBold
                lDist.TextSize = 12
                lDist.TextColor3 = Color3.fromRGB(255, 255, 255)
                lDist.Text = "0m"
                lDist.Parent = gBgBot
            end
            local lDist = gBgBot:FindFirstChild("GunDistLabel")
            if lDist and myRoot then
                local dist = math.floor((gunPart.Position - myRoot.Position).Magnitude)
                lDist.Text = tostring(dist) .. "m"
            end
        else
            self:ClearGunESP()
        end
    else
        self:ClearGunESP()
    end
end
function Hub:ApplyWorldSettings()
    local L = self.Services.Lighting
    if not self.World.OrigAmbient then
        self.World.OrigAmbient = L.Ambient
        self.World.OrigClockTime = L.ClockTime
        self.World.OrigFogEnd = L.FogEnd
        self.World.OrigShadows = L.GlobalShadows
    end
    if self.Config.Toggles.FullBright then
        L.Brightness = 2
        L.Ambient = Color3.fromRGB(255, 255, 255)
        L.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        L.Brightness = 1
        L.Ambient = self.World.OrigAmbient or Color3.fromRGB(128, 128, 128)
    end
    if self.Config.Toggles.NoFog then
        L.FogEnd = 9e9
        L.FogStart = 9e9
    else
        L.FogEnd = self.World.OrigFogEnd or 1000
    end
    L.GlobalShadows = self.Config.Toggles.WorldShadows
    if not self.Config.Toggles.FullBright then
        L.ClockTime = self.Config.Values.ClockTime
    end
    local cam = self.Services.Workspace.CurrentCamera
    if cam then
        cam.FieldOfView = self.Config.Values.CameraFOV
    end
    local tint = self.Config.Values.AmbientTint
    if tint == "Neon Purple" then
        L.ColorShift_Top = Color3.fromRGB(220, 100, 255)
    elseif tint == "Sunset Warm" then
        L.ColorShift_Top = Color3.fromRGB(255, 160, 90)
    elseif tint == "Midnight Blue" then
        L.ColorShift_Top = Color3.fromRGB(80, 120, 255)
    else
        L.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    end
    if self.Config.Toggles.XRay then
        self:ApplyXRay(true)
    else
        self:DisableXRay()
    end
end
function Hub:IsCharacterOrGunPart(part)
    if not part then return false end
    for _, p in ipairs(self.Services.Players:GetPlayers()) do
        if p.Character and part:IsDescendantOf(p.Character) then
            return true
        end
    end
    local gun = self.Services.Workspace:FindFirstChild("GunDrop")
    if gun and part:IsDescendantOf(gun) then
        return true
    end
    local pName = part.Name:lower()
    if pName:find("knife") or (part.Parent and part.Parent.Name:lower():find("knife")) then
        return true
    end
    return false
end
function Hub:ApplyXRay(enabled)
    if enabled == false or not self.Config.Toggles.XRay then
        self:DisableXRay()
        return
    end
    if not self.World.OriginalTransparency then
        self.World.OriginalTransparency = {}
    end
    local targetTrans = math.clamp((self.Config.Values.XRayTransparency or 65) / 100, 0, 1)
    for _, part in ipairs(self.Services.Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsA("Terrain") then
            if not self:IsCharacterOrGunPart(part) and part.Transparency < 0.95 then
                if self.World.OriginalTransparency[part] == nil then
                    self.World.OriginalTransparency[part] = part.Transparency
                end
                part.Transparency = targetTrans
            end
        end
    end
    if not self.World.XRayConnection then
        self.World.XRayConnection = self.Services.Workspace.DescendantAdded:Connect(function(descendant)
            if not self.Config.Toggles.XRay then return end
            if descendant:IsA("BasePart") and not descendant:IsA("Terrain") then
                task.wait(0.05)
                if self.Config.Toggles.XRay and descendant and descendant.Parent and not self:IsCharacterOrGunPart(descendant) and descendant.Transparency < 0.95 then
                    if self.World.OriginalTransparency[descendant] == nil then
                        self.World.OriginalTransparency[descendant] = descendant.Transparency
                    end
                    descendant.Transparency = math.clamp((self.Config.Values.XRayTransparency or 65) / 100, 0, 1)
                end
            end
        end)
    end
end
function Hub:UpdateXRayTransparency()
    if not self.Config.Toggles.XRay then return end
    local targetTrans = math.clamp((self.Config.Values.XRayTransparency or 65) / 100, 0, 1)
    if self.World.OriginalTransparency then
        for part, _ in pairs(self.World.OriginalTransparency) do
            if part and part.Parent and typeof(part) == "Instance" and part:IsA("BasePart") then
                pcall(function()
                    part.Transparency = targetTrans
                end)
            end
        end
    end
end
function Hub:DisableXRay()
    if self.World.XRayConnection then
        self.World.XRayConnection:Disconnect()
        self.World.XRayConnection = nil
    end
    if self.World.OriginalTransparency then
        for part, orig in pairs(self.World.OriginalTransparency) do
            if part and part.Parent and typeof(part) == "Instance" and part:IsA("BasePart") then
                pcall(function()
                    part.Transparency = orig
                end)
            end
        end
        table.clear(self.World.OriginalTransparency)
    end
end
function Hub:SetupAntiAFK()
    local lp = self.Services.Players.LocalPlayer
    if lp then
        lp.Idled:Connect(function()
            if self.Config.Toggles.AntiAFK then
                pcall(function()
                    local vu = game:GetService("VirtualUser")
                    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)
            end
        end)
    end
end
function Hub:ApplyPotatoOptimizer(enabled)
    local lighting = self.Services.Lighting
    local terrain = self.Services.Workspace.Terrain
    if not self.State.PotatoBackup then self.State.PotatoBackup = {} end

    if enabled then
        -- 1. Lighting Optimization (Shadows, Fog, Post-processing without touching settings menu)
        if not self.State.PotatoLightingBackup then
            self.State.PotatoLightingBackup = {
                GlobalShadows = lighting.GlobalShadows,
                FogEnd = lighting.FogEnd,
                Brightness = lighting.Brightness,
                OutdoorAmbient = lighting.OutdoorAmbient,
                Effects = {}
            }
            for _, child in ipairs(lighting:GetChildren()) do
                if child:IsA("PostProcessEffect") or child:IsA("Atmosphere") or child:IsA("Sky") then
                    pcall(function()
                        self.State.PotatoLightingBackup.Effects[child] = child.Enabled
                        child.Enabled = false
                    end)
                end
            end
        end
        pcall(function()
            lighting.GlobalShadows = false
            lighting.FogEnd = 9e9
            lighting.Brightness = 2
        end)

        -- 2. Terrain Optimization (water reflections, waves, transparency)
        if terrain and not self.State.PotatoTerrainBackup then
            pcall(function()
                self.State.PotatoTerrainBackup = {
                    WaterWaveSize = terrain.WaterWaveSize,
                    WaterWaveSpeed = terrain.WaterWaveSpeed,
                    WaterReflectance = terrain.WaterReflectance,
                    WaterTransparency = terrain.WaterTransparency,
                }
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 0
            end)
        end

        -- 3. Workspace Full Objects Optimization
        for _, obj in ipairs(self.Services.Workspace:GetDescendants()) do
            self:OptimizeInstance(obj)
        end

        -- 4. Dynamic Watchers for newly spawned map parts / effects
        if not self.State.OptimizerConn then
            self.State.OptimizerConn = self.Services.Workspace.DescendantAdded:Connect(function(obj)
                if self.Config.Toggles.PotatoOptimizer then
                    self:OptimizeInstance(obj)
                end
            end)
        end
        if not self.State.OptimizerLightingConn then
            self.State.OptimizerLightingConn = lighting.ChildAdded:Connect(function(obj)
                if self.Config.Toggles.PotatoOptimizer then
                    if obj:IsA("PostProcessEffect") or obj:IsA("Atmosphere") then
                        pcall(function()
                            if self.State.PotatoLightingBackup and self.State.PotatoLightingBackup.Effects then
                                self.State.PotatoLightingBackup.Effects[obj] = obj.Enabled
                            end
                            obj.Enabled = false
                        end)
                    end
                end
            end)
        end
    else
        -- 1. Restore Lighting
        if self.State.PotatoLightingBackup then
            pcall(function()
                lighting.GlobalShadows = self.State.PotatoLightingBackup.GlobalShadows
                lighting.FogEnd = self.State.PotatoLightingBackup.FogEnd
                lighting.Brightness = self.State.PotatoLightingBackup.Brightness
                lighting.OutdoorAmbient = self.State.PotatoLightingBackup.OutdoorAmbient
                if self.State.PotatoLightingBackup.Effects then
                    for effect, wasEnabled in pairs(self.State.PotatoLightingBackup.Effects) do
                        if effect and effect.Parent then
                            pcall(function() effect.Enabled = wasEnabled end)
                        end
                    end
                end
            end)
            self.State.PotatoLightingBackup = nil
        else
            pcall(function()
                lighting.GlobalShadows = self.Config.Toggles.WorldShadows
                lighting.FogEnd = self.Config.Toggles.NoFog and 9e9 or 500
            end)
        end

        -- 2. Restore Terrain
        if terrain and self.State.PotatoTerrainBackup then
            pcall(function()
                terrain.WaterWaveSize = self.State.PotatoTerrainBackup.WaterWaveSize
                terrain.WaterWaveSpeed = self.State.PotatoTerrainBackup.WaterWaveSpeed
                terrain.WaterReflectance = self.State.PotatoTerrainBackup.WaterReflectance
                terrain.WaterTransparency = self.State.PotatoTerrainBackup.WaterTransparency
            end)
            self.State.PotatoTerrainBackup = nil
        end

        -- 3. Disconnect Watchers
        if self.State.OptimizerConn then
            self.State.OptimizerConn:Disconnect()
            self.State.OptimizerConn = nil
        end
        if self.State.OptimizerLightingConn then
            self.State.OptimizerLightingConn:Disconnect()
            self.State.OptimizerLightingConn = nil
        end

        -- 4. Restore Workspace Objects
        for obj, data in pairs(self.State.PotatoBackup) do
            if obj and obj.Parent then
                pcall(function()
                    if data.Type == "BasePart" then
                        obj.Material = data.Material
                        obj.CastShadow = data.CastShadow
                        obj.Reflectance = data.Reflectance
                        if data.TextureID and obj:IsA("MeshPart") then
                            obj.TextureID = data.TextureID
                        end
                        if data.RenderFidelity and obj:IsA("MeshPart") then
                            obj.RenderFidelity = data.RenderFidelity
                        end
                    elseif data.Type == "Decal" then
                        obj.Transparency = data.Transparency
                    elseif data.Type == "SpecialMesh" then
                        obj.TextureId = data.TextureId
                    elseif data.Type == "Toggleable" then
                        obj.Enabled = data.Enabled
                    end
                end)
            end
        end
        table.clear(self.State.PotatoBackup)
    end
end

function Hub:OptimizeInstance(obj)
    if not obj then return end
    pcall(function()
        if not self.State.PotatoBackup then self.State.PotatoBackup = {} end

        -- Skip players and their character parts, clothes, weapons, and displays!
        local function isProtected(inst)
            local p = inst.Parent
            while p and p ~= workspace do
                if p:FindFirstChildOfClass("Humanoid") then return true end
                if p.Name == "WeaponDisplays" or p.Name == "CustomSkinMesh" then return true end
                if p:IsA("Tool") then return true end
                p = p.Parent
            end
            return false
        end

        if isProtected(obj) then return end

        if obj:IsA("BasePart") then
            if not self.State.PotatoBackup[obj] then
                self.State.PotatoBackup[obj] = {
                    Type = "BasePart",
                    Material = obj.Material,
                    CastShadow = obj.CastShadow,
                    Reflectance = obj.Reflectance,
                    TextureID = obj:IsA("MeshPart") and obj.TextureID or nil,
                    RenderFidelity = obj:IsA("MeshPart") and obj.RenderFidelity or nil,
                }
            end
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
            obj.Reflectance = 0
            if obj:IsA("MeshPart") then
                obj.TextureID = ""
                pcall(function() obj.RenderFidelity = Enum.RenderFidelity.Performance end)
            end
        elseif obj:IsA("SpecialMesh") then
            if not self.State.PotatoBackup[obj] then
                self.State.PotatoBackup[obj] = {
                    Type = "SpecialMesh",
                    TextureId = obj.TextureId
                }
            end
            obj.TextureId = ""
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            if not self.State.PotatoBackup[obj] then
                self.State.PotatoBackup[obj] = {
                    Type = "Decal",
                    Transparency = obj.Transparency
                }
            end
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Light") or obj:IsA("Beam") or obj:IsA("Trail") or obj:IsA("Highlight") then
            if not self.State.PotatoBackup[obj] then
                self.State.PotatoBackup[obj] = {
                    Type = "Toggleable",
                    Enabled = obj.Enabled
                }
            end
            obj.Enabled = false
        end
    end)
end
function Hub:SetFarmNoClip(on)
    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if on then
        if not char then return end
        if hum then pcall(function() hum.PlatformStand = true end) end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                if self.AutoFarm.NoClipCache[p] == nil then
                    self.AutoFarm.NoClipCache[p] = p.CanCollide
                end
                p.CanCollide = false
            end
        end
    else
        if hum then
            hum.PlatformStand = false
            hum.Sit = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            task.defer(function()
                if hum and not self.AutoFarm.IsActive then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
        if not self.Config.Toggles.NoClip then
            self:RestoreCollisions()
        end
        self.AutoFarm.NoClipCache = {}
    end
end
function Hub:ReturnToSurface()
    if not self:IsRoundActive() then return end
    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character
    local root = char and self:GetRoot(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root then return end
    local upParams = self.FarmRayParams
    if not upParams then
        upParams = RaycastParams.new()
        upParams.FilterType = Enum.RaycastFilterType.Exclude
        upParams.IgnoreWater = true
        self.FarmRayParams = upParams
    end
    upParams.FilterDescendantsInstances = char and { char } or {}
    local startY = (self.AutoFarm.DownRefY and (self.AutoFarm.DownRefY + 6)) or (root.Position.Y + 16)
    local testPos = Vector3.new(root.Position.X, startY, root.Position.Z)
    local res = self.Services.Workspace:Raycast(testPos, Vector3.new(0, -35, 0), upParams)
    if not (res and res.Position) then
        return
    end
    local y = res.Position.Y + 3
    pcall(function()
        local _, ry, _ = root.CFrame:ToOrientation()
        root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, ry, 0)
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)
    if hum then
        hum.PlatformStand = false
        hum.Sit = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        task.defer(function()
            if hum and not self.AutoFarm.IsActive then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end
end
function Hub:ReleaseFarm()
    self.AutoFarm.HoldCF = nil
    self.AutoFarm.LastCoin = nil
    if self.AutoFarm.WasDown then
        self.AutoFarm.WasDown = false
        if self:IsRoundActive() then
            self:ReturnToSurface()
        end
    end
    self:SetFarmNoClip(false)
    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character
    local root = char and self:GetRoot(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if root and self:IsRoundActive() then
        local _, ry, _ = root.CFrame:ToOrientation()
        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, ry, 0)
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
    if hum then
        hum.PlatformStand = false
        hum.Sit = false
        hum.MaxSlopeAngle = 89
        hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        task.defer(function()
            if hum and not self.AutoFarm.IsActive then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end
    self:RestoreCollisions()
end
function Hub:StopAutoFarm()
    self.AutoFarm.Target = nil
    if self.AutoFarm.IsActive then
        self.AutoFarm.IsActive = false
    end
    self:ReleaseFarm()
end
function Hub:StopAutoFarmTween()
    self:StopAutoFarm()
end
function Hub:IsCoinBagFull()
    local isFull = false
    local limit = self.Config.Values.AutoFarmBagLimit or 50
    pcall(function()
        local lp = self.Services.Players.LocalPlayer
        local pgui = lp:FindFirstChild("PlayerGui")
        local mg = pgui and pgui:FindFirstChild("MainGUI")
        if not mg then return end
        local coinBags = mg:FindFirstChild("Game") and mg.Game:FindFirstChild("CoinBags")
        if not coinBags then return end
        local container = coinBags:FindFirstChild("Container")
        if container then
            for _, bagFrame in ipairs(container:GetChildren()) do
                if bagFrame:IsA("Frame") and bagFrame.Visible then
                    local fullLabel = bagFrame:FindFirstChild("Full")
                    if fullLabel and fullLabel.Visible then
                        isFull = true
                        return
                    end
                    for _, lbl in ipairs(bagFrame:GetDescendants()) do
                        if lbl:IsA("TextLabel") and lbl.Visible then
                            local txt = lbl.Text:match("(%d+)")
                            if txt then
                                local num = tonumber(txt)
                                if num and num >= limit then
                                    isFull = true
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
        local scriptFolder = coinBags:FindFirstChild("CoinBagContainerScript")
        local fullNotif = scriptFolder and scriptFolder:FindFirstChild("FullBagNotification")
        if fullNotif and fullNotif.Visible then
            isFull = true
            return
        end
    end)
    return isFull
end
function Hub:GetAvailableCoins()
    local list = {}
    local cs = self.Services.CollectionService
    local ok, tagged = pcall(function() return cs:GetTagged("CoinVisual") end)
    if ok and type(tagged) == "table" and #tagged > 0 then
        for _, v in ipairs(tagged) do
            if v and v.Parent and v:IsA("BasePart") then
                if not v:GetAttribute("Collected") and not v:GetAttribute("Delete") then
                    table.insert(list, v)
                end
            end
        end
    end
    if #list == 0 then
        local coinContainer = self.Services.Workspace:FindFirstChild("CoinContainer", true)
        if coinContainer then
            for _, c in ipairs(coinContainer:GetChildren()) do
                if c:IsA("BasePart") and c.Parent and not c:GetAttribute("Collected") then
                    table.insert(list, c)
                elseif c:IsA("Model") and c.Parent then
                    local p = c.PrimaryPart or c:FindFirstChildWhichIsA("BasePart")
                    if p and not p:GetAttribute("Collected") then
                        table.insert(list, p)
                    end
                end
            end
        end
    end
    return list
end
function Hub:GetTouchTargets(coin)
    local list = {}
    local seen = {}
    local function add(p)
        if p and not seen[p] and p:IsA("BasePart") and p:FindFirstChildOfClass("TouchTransmitter") then
            seen[p] = true
            table.insert(list, p)
        end
    end
    add(coin)
    if coin then
        for _, v in ipairs(coin:GetChildren()) do add(v) end
        local par = coin.Parent
        if par then
            if par:IsA("BasePart") then add(par) end
            for _, v in ipairs(par:GetChildren()) do add(v) end
        end
    end
    if #list == 0 and coin then table.insert(list, coin) end
    return list
end
function Hub:FireCoinTouch(coin)
    if type(firetouchinterest) ~= "function" then return end
    if not coin or not coin.Parent then return end
    local now = os.clock()
    if now - (self.AutoFarm.LastTouch or 0) < 0.05 then return end
    self.AutoFarm.LastTouch = now
    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character
    local root = char and self:GetRoot(char)
    if not root then return end
    for _, p in ipairs(self:GetTouchTargets(coin)) do
        pcall(firetouchinterest, root, p, 0)
        pcall(firetouchinterest, root, p, 1)
    end
end
function Hub:GetMurdererHRP()
    local data = self:GetPlayerDataMap()
    if type(data) == "table" then
        local lp = self.Services.Players.LocalPlayer
        for name, info in pairs(data) do
            if type(info) == "table" and (info.Role == "Murderer" or info.Role == "Zombie") and not info.Dead and name ~= lp.Name then
                local pl = self.Services.Players:FindFirstChild(name)
                local char = pl and pl.Character
                local root = char and self:GetRoot(char)
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if root and (not hum or hum.Health > 0) then
                    return root
                end
            end
        end
    end
    for _, plr in ipairs(self.Services.Players:GetPlayers()) do
        if plr ~= self.Services.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("Knife") then
            local root = self:GetRoot(plr.Character)
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if root and (not hum or hum.Health > 0) then
                return root
            end
        end
    end
    return nil
end
function Hub:PickBestCoin(pos, coins, mpos)
    if not (self.Config.Toggles.AutoFarmAvoidMurder and mpos) then
        local best, bd = nil, math.huge
        for _, v in ipairs(coins) do
            local d = (v.Position - pos).Magnitude
            if d < bd then bd = d; best = v end
        end
        return best
    end
    local AVOID_DIST = 40
    local safe, sd = nil, math.huge
    local far, fd = nil, -1
    for _, v in ipairs(coins) do
        local md = Vector3.new(v.Position.X - mpos.X, 0, v.Position.Z - mpos.Z).Magnitude
        if md > fd then fd = md; far = v end
        if md >= AVOID_DIST then
            local d = (v.Position - pos).Magnitude
            if d < sd then sd = d; safe = v end
        end
    end
    if safe then return safe end
    if far and fd >= AVOID_DIST * 0.6 then return far end
    return nil
end
function Hub:AvoidSteer(cur, dest, mpos)
    if not (self.Config.Toggles.AutoFarmAvoidMurder and mpos) then return dest end
    local AVOID_DIST = 40
    local dm = Vector3.new(cur.X - mpos.X, 0, cur.Z - mpos.Z).Magnitude
    if dm >= AVOID_DIST then return dest end
    local away = Vector3.new(cur.X - mpos.X, 0, cur.Z - mpos.Z)
    if away.Magnitude < 0.1 then away = Vector3.new(1, 0, 0) end
    away = away.Unit
    local want = Vector3.new(dest.X - cur.X, 0, dest.Z - cur.Z)
    local mag = want.Magnitude
    if mag < 0.1 then return dest end
    local weight = 1 + (1 - dm / AVOID_DIST) * 2
    local blend = (want.Unit + away * weight)
    if blend.Magnitude < 0.1 then blend = away else blend = blend.Unit end
    local np = cur + blend * mag
    return Vector3.new(np.X, dest.Y, np.Z)
end
function Hub:FarmStepMove(root, dest, dt, speed, mode)
    local dir = dest - root.Position
    local dist = dir.Magnitude
    local np = dest
    if dist > 0.05 then
        np = root.Position + dir.Unit * math.min(speed * dt, dist)
    end
    local cf = CFrame.new(np)
    if mode == "Down" then
        cf = cf * CFrame.Angles(-math.pi * 0.5, 0, 0)
        self.AutoFarm.WasDown = true
    end
    pcall(function()
        root.CFrame = cf
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)
end
function Hub:FlingMurdererOnDeath(deadChar)
    task.spawn(function()
        local lp = self.Services.Players.LocalPlayer
        local char = deadChar or (lp and lp.Character)
        if not char then return end
        local root = self:GetRoot(char) or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if not root then return end
        local murderer = self:GetMurderer()
        if not murderer or not murderer.Character then
            for _, p in ipairs(self.Services.Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    if p.Character:FindFirstChild("Knife") or (p:FindFirstChildOfClass("Backpack") and p.Backpack:FindFirstChild("Knife")) then
                        murderer = p
                        break
                    end
                end
            end
        end
        if not murderer or not murderer.Character then return end
        local mChar = murderer.Character
        local mRoot = self:GetRoot(mChar) or mChar:FindFirstChild("HumanoidRootPart") or mChar:FindFirstChild("Torso")
        local mHum = mChar:FindFirstChildOfClass("Humanoid")
        if not (mRoot and mHum and mHum.Health > 0) then return end
        pcall(function()
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = (p == root)
                end
            end
        end)
        local startTime = os.clock()
        local flingConn
        flingConn = self.Services.RunService.Heartbeat:Connect(function()
            local elapsed = os.clock() - startTime
            if elapsed > 2.2 then
                if flingConn then flingConn:Disconnect() end
                return
            end
            if not mRoot or not mRoot.Parent or not mHum or mHum.Health <= 0 then
                if flingConn then flingConn:Disconnect() end
                return
            end
            if mRoot.Position.Y < -40 or mRoot.Position.Y > 400 or mRoot.AssemblyLinearVelocity.Magnitude > 300 then
                if flingConn then flingConn:Disconnect() end
                return
            end
            if not root or not root.Parent then
                if flingConn then flingConn:Disconnect() end
                return
            end
            pcall(function()
                root.CanCollide = true
                mRoot.CanCollide = true
                root.CFrame = mRoot.CFrame
                root.AssemblyLinearVelocity = Vector3.new(0, 150000, 0)
                root.AssemblyAngularVelocity = Vector3.new(100000, 100000, 100000)
            end)
        end)
    end)
end
function Hub:StartAutoFarmLoop()
    if self.AutoFarm.Connection then
        pcall(function() self.AutoFarm.Connection:Disconnect() end)
        self.AutoFarm.Connection = nil
    end
    local DOWN_DEPTH = 14
    local DOWN_RISE_XZ = 4
    local RISE_SAFE_DIST = 20
    pcall(function()
        local rep = self.Services.ReplicatedStorage
        local remotes = rep:FindFirstChild("Remotes")
        local gp = remotes and remotes:FindFirstChild("Gameplay")
        if gp then
            for _, rName in ipairs({ "CoinsStarted", "RoundStart", "GameOver", "RoundEndFade" }) do
                local rem = gp:FindFirstChild(rName)
                if rem and rem:IsA("RemoteEvent") then
                    local c = rem.OnClientEvent:Connect(function()
                        self.AutoFarm.Target = nil
                        self.AutoFarm.HoldCF = nil
                        self.AutoFarm.WasDown = false
                        self.AutoFarm.SawCoins = false
                        self.AutoFarm.CoinsDone = false
                        if self.AutoFarm.IsActive then
                            self.AutoFarm.IsActive = false
                            self:ReleaseFarm()
                        end
                        self:SetFarmNoClip(false)
                    end)
                    table.insert(self.State.Connections, c)
                end
            end
        end
    end)
    self.AutoFarm.Connection = self.Services.RunService.Stepped:Connect(function(_, dt)
        if not self.Config.Toggles.AutoFarm then
            if self.AutoFarm.IsActive then
                self.AutoFarm.IsActive = false
                self:ReleaseFarm()
            end
            return
        end
        local lp = self.Services.Players.LocalPlayer
        local char = lp and lp.Character
        local root = char and self:GetRoot(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not (char and root and hum and hum.Health > 0) then
            if hum and hum.Health <= 0 and (not self.AutoFarm.DeathFlingTriggered) then
                self.AutoFarm.DeathFlingTriggered = true
                if self.Config.Toggles.AutoFarm and self.Config.Toggles.AutoFarmFlingMurderOnDeath then
                    self:FlingMurdererOnDeath(char)
                end
            end
            self.AutoFarm.Target = nil
            self.AutoFarm.WasDown = false
            if self.AutoFarm.IsActive then
                self.AutoFarm.IsActive = false
                self:ReleaseFarm()
            end
            return
        end
        if not self:IsRoundActive() or not self:IsPlayerInRound(lp) then
            self.AutoFarm.Target = nil
            self.AutoFarm.HoldCF = nil
            self.AutoFarm.WasDown = false
            self.AutoFarm.SawCoins = false
            self.AutoFarm.CoinsDone = false
            if self.AutoFarm.IsActive then
                self.AutoFarm.IsActive = false
                self:ReleaseFarm()
            end
            return
        end
        local function finish()
            self.AutoFarm.Target = nil
            if self.AutoFarm.IsActive then
                self.AutoFarm.IsActive = false
                self:ReleaseFarm()
            end
            if self.Config.Toggles.AutoPrestige then
                self:CheckAutoPrestige()
            end
            if not self.AutoFarm.CoinsDone then
                self.AutoFarm.CoinsDone = true
                task.spawn(function()
                    if self.Config.Toggles.AutoFarmSafeZone then
                        self:TeleportToLobby()
                        task.wait(0.6)
                    end
                    if self.Config.Toggles.AutoFarmKillAllOnFull then
                        local knife = self:FindKnife()
                        if knife then
                            local char = lp.Character
                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                            if hum and knife.Parent ~= char then
                                hum:EquipTool(knife)
                                task.wait(0.2)
                            end
                            self:ExecuteKillAll()
                            task.wait(0.3)
                        end
                    end
                    if self.Config.Toggles.AutoFarmShootMurdererOnFull then
                        local gun = self:FindGun()
                        if gun then
                            local char = lp.Character
                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                            if hum and gun.Parent ~= char then
                                hum:EquipTool(gun)
                                task.wait(0.25)
                            end
                            local isZombie = self:IsZombieMode()
                            local shootStart = os.clock()
                            while self:IsRoundActive() and self.AutoFarm.CoinsDone and self.Config.Toggles.AutoFarm do
                                local curChar = lp.Character
                                local curHum = curChar and curChar:FindFirstChildOfClass("Humanoid")
                                if not curHum or curHum.Health <= 0 then
                                    break
                                end
                                local currentGun = self:FindGun()
                                if not currentGun then
                                    break
                                end
                                if currentGun.Parent ~= curChar and curHum then
                                    curHum:EquipTool(currentGun)
                                end
                                local target = self:GetMurderer()
                                if not target then
                                    if not isZombie then
                                        break
                                    end
                                    task.wait(0.5)
                                else
                                    local tHum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
                                    if tHum and tHum.Health > 0 then
                                        self:ShootMurderer(true, true, false)
                                        task.wait(1.5)
                                    else
                                        task.wait(0.3)
                                    end
                                end
                                if not isZombie and (os.clock() - shootStart >= 16) then
                                    break
                                end
                            end
                            task.wait(0.4)
                        end
                    end
                    if self.Config.Toggles.AutoFarmAutoReset then
                        local char = lp.Character
                        local curHum = char and char:FindFirstChildOfClass("Humanoid")
                        if curHum then pcall(function() curHum.Health = 0 end) end
                    end
                end)
            end
        end
        local coins = self:GetAvailableCoins()
        if #coins > 0 then
            self.AutoFarm.SawCoins = true
            if self:IsCoinBagFull() then
                self.AutoFarm.Target = nil
                self.AutoFarm.HoldCF = nil
                if self.AutoFarm.IsActive then
                    self.AutoFarm.IsActive = false
                    self:ReleaseFarm()
                end
                if not self.AutoFarm.CoinsDone then
                    finish()
                end
                return
            end
            if self.AutoFarm.CoinsDone then self.AutoFarm.CoinsDone = false end
            local mRoot = self.Config.Toggles.AutoFarmAvoidMurder and self:GetMurdererHRP() or nil
            local mpos = mRoot and mRoot.Position or nil
            local curTarget = self.AutoFarm.Target
            local targetValid = curTarget and curTarget.Parent and (not curTarget:GetAttribute("Collected")) and (not curTarget:GetAttribute("Delete"))
            if targetValid and self.Config.Toggles.AutoFarmAvoidMurder and mpos then
                local md = Vector3.new(curTarget.Position.X - mpos.X, 0, curTarget.Position.Z - mpos.Z).Magnitude
                if md < 24 then targetValid = false end
            end
            if not targetValid then
                self.AutoFarm.Target = self:PickBestCoin(root.Position, coins, mpos)
            end
            local farmMode = self.Config.Values.AutoFarmMode or "Basic"
            local speed = self.Config.Values.AutoFarmSpeed or 23
            if self.AutoFarm.Target then
                self.AutoFarm.IsActive = true
                local cpos = self.AutoFarm.Target.Position
                self.AutoFarm.DownRefY = cpos.Y
                local dest = cpos
                if farmMode == "Down" then
                    self:SetFarmNoClip(true)
                    local xz = Vector3.new(root.Position.X - cpos.X, 0, root.Position.Z - cpos.Z).Magnitude
                    local safeToRise = (not mpos) or Vector3.new(root.Position.X - mpos.X, 0, root.Position.Z - mpos.Z).Magnitude > RISE_SAFE_DIST
                    if xz <= DOWN_RISE_XZ and safeToRise then
                        dest = cpos
                        self:FireCoinTouch(self.AutoFarm.Target)
                    else
                        dest = Vector3.new(cpos.X, cpos.Y - DOWN_DEPTH, cpos.Z)
                    end
                    dest = self:AvoidSteer(root.Position, dest, mpos)
                    self:FarmStepMove(root, dest, dt, speed, farmMode)
                elseif farmMode == "Teleport" then
                    self.AutoFarm.WasDown = false
                    self:SetFarmNoClip(true)
                    local now = os.clock()
                    local tpDelay = math.clamp(self.Config.Values.AutoFarmTPDelay or 0.4, 0.2, 1.0)
                    local targetY = cpos.Y - 0.95
                    local rayParams = self.FarmRayParams
                    if not rayParams then
                        rayParams = RaycastParams.new()
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        rayParams.IgnoreWater = true
                        self.FarmRayParams = rayParams
                    end
                    rayParams.FilterDescendantsInstances = { char, self.AutoFarm.Target }
                    local floorRay = self.Services.Workspace:Raycast(cpos, Vector3.new(0, -6, 0), rayParams)
                    if floorRay and floorRay.Position then
                        targetY = math.max(floorRay.Position.Y + 2.45, cpos.Y - 1.1)
                    end
                    local _, ry, _ = root.CFrame:ToOrientation()
                    local targetCF = CFrame.new(cpos.X, targetY, cpos.Z) * CFrame.Angles(0, ry, 0)
                    if (self.AutoFarm.LastCoin ~= self.AutoFarm.Target) or (now - (self.AutoFarm.LastTP or 0) >= tpDelay) then
                        self.AutoFarm.LastTP = now
                        self.AutoFarm.LastCoin = self.AutoFarm.Target
                        self.AutoFarm.HoldCF = targetCF
                        pcall(function()
                            root.CFrame = targetCF
                            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end)
                        self:FireCoinTouch(self.AutoFarm.Target)
                        task.delay(0.08, function()
                            if self.AutoFarm.IsActive and self.AutoFarm.Target then
                                self:FireCoinTouch(self.AutoFarm.Target)
                            end
                        end)
                    end
                    local holdCF = self.AutoFarm.HoldCF or targetCF
                    pcall(function()
                        root.CFrame = holdCF
                        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        if hum then
                            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        end
                    end)
                    self:FireCoinTouch(self.AutoFarm.Target)
                else
                    self:SetFarmNoClip(true)
                    if (cpos - root.Position).Magnitude <= 6 then
                        self:FireCoinTouch(self.AutoFarm.Target)
                    end
                    dest = self:AvoidSteer(root.Position, dest, mpos)
                    self:FarmStepMove(root, dest, dt, speed, farmMode)
                end
            else
                if farmMode == "Teleport" and self.AutoFarm.HoldCF then
                    pcall(function()
                        root.CFrame = self.AutoFarm.HoldCF
                        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end)
                else
                    self.AutoFarm.Target = nil
                    if self.AutoFarm.IsActive then
                        self.AutoFarm.IsActive = false
                        self:ReleaseFarm()
                    end
                end
            end
        else
            self.AutoFarm.Target = nil
            self.AutoFarm.HoldCF = nil
            self.AutoFarm.LastCoin = nil
            if self.AutoFarm.IsActive then
                self.AutoFarm.IsActive = false
                self:ReleaseFarm()
            end
        end
    end)
end
function Hub:FormatNumber(num)
    local n = tonumber(num) or 0
    local sign = n < 0 and "-" or ""
    local absN = math.abs(n)
    local intPart = math.floor(absN)
    local decPart = absN - intPart
    local formatted = tostring(intPart)
    local k
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
    end
    if decPart >= 0.01 then
        local decStr = string.format("%.2f", decPart):sub(2)
        decStr = decStr:gsub("0+$", "")
        if decStr ~= "." then
            return sign .. formatted .. decStr
        end
    end
    return sign .. formatted
end
function Hub:CountTable(tbl)
    local c = 0
    if type(tbl) == "table" then
        for _ in pairs(tbl) do c = c + 1 end
    end
    return c
end
function Hub:DecodeSkinEnum(raw)
    local group, item = string.match(raw, "^Enum%.([%w_]+)%.([%w_]+)$")
    if not group then return nil end
    local ok, val = pcall(function() return Enum[group][item] end)
    return ok and val or nil
end
function Hub:DecodeSkinProperty(current, raw)
    local k = type(raw)
    if k == "number" or k == "boolean" then return raw end
    local want = typeof(current)
    if k == "string" then
        if want == "EnumItem" then return self:DecodeSkinEnum(raw) end
        return raw
    end
    if k ~= "table" then return nil end
    if want == "Vector3" then
        return Vector3.new(raw[1], raw[2], raw[3])
    elseif want == "Vector2" then
        return Vector2.new(raw[1], raw[2])
    elseif want == "Color3" then
        return Color3.new(raw[1], raw[2], raw[3])
    elseif want == "NumberRange" then
        return NumberRange.new(raw[1], raw[2])
    elseif want == "CFrame" then
        return CFrame.new(table.unpack(raw))
    elseif want == "NumberSequence" then
        local keys = {}
        for i = 1, #raw do
            local pt = raw[i]
            keys[i] = NumberSequenceKeypoint.new(pt.t, pt.v, pt.e or 0)
        end
        if #keys < 2 then return NumberSequence.new(keys[1] and keys[1].Value or 0) end
        return NumberSequence.new(keys)
    elseif want == "ColorSequence" then
        local keys = {}
        for i = 1, #raw do
            local pt = raw[i]
            local rgb = pt.c
            keys[i] = ColorSequenceKeypoint.new(pt.t, Color3.new(rgb[1], rgb[2], rgb[3]))
        end
        if #keys < 2 then return ColorSequence.new(keys[1] and keys[1].Value or Color3.new(1, 1, 1)) end
        return ColorSequence.new(keys)
    end
    return nil
end
local skinPropNope = {
    Anchored = true, Massless = true, CanCollide = true, CanQuery = true, CanTouch = true,
    Locked = true, Size = true, MeshId = true, MeshSize = true, Part0 = true, Part1 = true,
    Playing = true, TimeLength = true, IsLoaded = true, IsPlaying = true,
}
local skinFxClasses = {
    Attachment = true, Sound = true, ParticleEmitter = true, Beam = true, Trail = true,
    Decal = true, Texture = true, Fire = true, Smoke = true, Sparkles = true,
    PointLight = true, SpotLight = true, SurfaceLight = true, Highlight = true,
}
local skinOnHandleClasses = { Attachment = true, Sound = true, Beam = true }

function Hub:ApplySkinProps(inst, props)
    if type(props) ~= "table" then return inst end
    for key, raw in pairs(props) do
        if not (skinPropNope and skinPropNope[key]) then
            local ok, curr = pcall(function() return inst[key] end)
            if ok then
                local val = self:DecodeSkinProperty(curr, raw)
                if val ~= nil then
                    pcall(function() inst[key] = val end)
                end
            end
        end
    end
    return inst
end
function Hub:RegisterSkinGarbage(owner, inst)
    if not owner or not inst then return inst end
    local list = self.SkinSystem.Musor[owner]
    if not list then
        list = {}
        self.SkinSystem.Musor[owner] = list
    end
    list[#list + 1] = inst
    return inst
end
function Hub:ClearSkinGarbage(owner)
    local list = self.SkinSystem.Musor[owner]
    if not list then return end
    for i = #list, 1, -1 do
        local inst = list[i]
        if inst then
            pcall(function() inst:Destroy() end)
        end
        list[i] = nil
    end
end
function Hub:BackupSkinProp(inst, data)
    if not inst or not data then return end
    local saved = self.SkinSystem.Saved[inst]
    if not saved then
        saved = {}
        self.SkinSystem.Saved[inst] = saved
    end
    for k, v in pairs(data) do
        if saved[k] == nil then
            saved[k] = v
        end
    end
end

function Hub:GetSkinImage(rec)
    if not rec then return nil end
    local meta = rec.meta
    local img = (meta and meta.Image) or rec.Image or (rec.display and rec.display.attrs and rec.display.attrs.Image)
    if img and type(img) == "string" and img ~= "" then
        return img
    end
    local itemId = (meta and meta.ItemID) or rec.ItemID
    if itemId then
        return "rbxthumb://type=Asset&w=150&h=150&id=" .. tostring(itemId)
    end
    return nil
end

function Hub:UpdateBackpackIcons(slot, img)
    if not slot then return end
    local imageToSet = img or ""
    local lp = self.Services.Players.LocalPlayer
    local tool = self:FindToolBySlot(slot)

    -- 1. MM2 custom BackpackUI (hotbar slots at screen bottom)
    pcall(function()
        local pgui = lp and lp:FindFirstChildOfClass("PlayerGui")
        local bpUi = pgui and pgui:FindFirstChild("BackpackUI")
        local bpFrame = bpUi and bpUi:FindFirstChild("BackpackFrame")
        if bpFrame then
            local frames = {}
            for _, c in ipairs(bpFrame:GetChildren()) do
                if c:IsA("Frame") and c.Name == "BackpackItem" then
                    table.insert(frames, c)
                end
            end
            for _, item in ipairs(frames) do
                local hotkey = item:FindFirstChild("Container") and item.Container:FindFirstChild("Hotkey")
                local icon = item:FindFirstChild("Container") and item.Container:FindFirstChild("ToolIcon")
                local nameLbl = item:FindFirstChild("Container") and item.Container:FindFirstChild("NameLabel")
                local hotkeyText = hotkey and hotkey.Text

                local match = false
                if item:GetAttribute("WeaponSlot") == slot then
                    match = true
                elseif #frames == 1 and tool then
                    match = true
                elseif slot == "Knife" and hotkeyText == "1" then
                    match = true
                elseif slot == "Gun" and (hotkeyText == "2" or (hotkeyText == "1" and not self:FindToolBySlot("Knife"))) then
                    match = true
                end

                if match then
                    item:SetAttribute("WeaponSlot", slot)
                    if icon and icon:IsA("ImageLabel") then
                        icon.Image = imageToSet
                    end
                    if nameLbl and imageToSet ~= "" then
                        nameLbl.Text = ""
                    end
                end
            end
        end
    end)

    -- 2. CoreGui Backpack Hotbar
    pcall(function()
        local coreGui = self.Services.CoreGui or game:GetService("CoreGui")
        local robloxGui = coreGui and coreGui:FindFirstChild("RobloxGui")
        local backpack = robloxGui and robloxGui:FindFirstChild("Backpack")
        local hotbar = backpack and backpack:FindFirstChild("Hotbar")
        if hotbar then
            for _, slotFrame in ipairs(hotbar:GetChildren()) do
                local toolRef = slotFrame:FindFirstChild("Tool")
                local isMatch = false
                if toolRef and toolRef.Value == tool then
                    isMatch = true
                elseif slot == "Knife" and slotFrame.Name == "1" then
                    isMatch = true
                elseif slot == "Gun" and (slotFrame.Name == "2" or (slotFrame.Name == "1" and not self:FindToolBySlot("Knife"))) then
                    isMatch = true
                end
                if isMatch then
                    local icon = slotFrame:FindFirstChild("Icon")
                    if icon and icon:IsA("ImageLabel") then
                        icon.Image = imageToSet
                    end
                end
            end
        end
    end)

    -- 3. Touch / Mobile controls (GameplayControlsUI)
    pcall(function()
        local pgui = lp and lp:FindFirstChildOfClass("PlayerGui")
        local touch = pgui and pgui:FindFirstChild("GameplayControlsUI")
        if touch then
            local rightBar = touch:FindFirstChild("TouchControls") and touch.TouchControls:FindFirstChild("RightBar")
            if rightBar then
                local equip = rightBar:FindFirstChild("EquipWeapon")
                local ctrlIcon = equip and equip:FindFirstChild("ControlIcon")
                if ctrlIcon and ctrlIcon:IsA("ImageLabel") then
                    ctrlIcon.Image = imageToSet
                end
            end
        end
    end)
end
function Hub:UpdateNativeInventoryEquipped(slot, skinName, skinImg)
    if not slot then return end
    pcall(function()
        local lp = self.Services.Players.LocalPlayer
        local pg = lp and lp:FindFirstChildOfClass("PlayerGui")
        if not pg then return end

        local containers = {}
        local mainGui = pg:FindFirstChild("MainGUI")
        if mainGui and mainGui:FindFirstChild("Game") then
            local inv = mainGui.Game:FindFirstChild("Inventory")
            local eq = inv and inv:FindFirstChild("Main") and inv.Main:FindFirstChild("Weapons") and inv.Main.Weapons:FindFirstChild("Equipped") and inv.Main.Weapons.Equipped:FindFirstChild("Container")
            if eq then table.insert(containers, eq) end

            local inv2 = mainGui.Game:FindFirstChild("Inventory2")
            local eq2 = inv2 and inv2:FindFirstChild("Main") and inv2.Main:FindFirstChild("Weapons") and inv2.Main.Weapons:FindFirstChild("Equipped") and inv2.Main.Weapons.Equipped:FindFirstChild("Container")
            if eq2 then table.insert(containers, eq2) end
        end

        local MM2RarityColors = {
            ["Ancient"] = Color3.fromHex("#640aff"),
            ["Godly"] = Color3.fromHex("#ff00b3"),
            ["Legendary"] = Color3.fromHex("#dc0005"),
            ["Rare"] = Color3.fromHex("#00c800"),
            ["Uncommon"] = Color3.fromHex("#00ffff"),
            ["Common"] = Color3.fromHex("#6a6a6a"),
            ["Vintage"] = Color3.fromHex("#e6c800"),
            ["Classic"] = Color3.fromHex("#e6c800"),
            ["Unique"] = Color3.fromHex("#fa8c00"),
            ["Christmas"] = Color3.fromHex("#1ec3be"),
            ["Halloween"] = Color3.fromHex("#b44600"),
            ["Chroma"] = Color3.fromHex("#ff00b3"),
        }

        local rec = skinName and self.SkinSystem.ByName and self.SkinSystem.ByName[skinName]
        local meta = rec and rec.meta
        local rarity = meta and meta.Rarity or "Godly"
        local event = meta and meta.Event
        local year = meta and meta.Year
        local rarityColor = MM2RarityColors[rarity] or Color3.fromHex("#ff00b3")

        for _, eq in ipairs(containers) do
            local itemFrame = eq:FindFirstChild(slot)
            if itemFrame then
                local c = itemFrame:FindFirstChild("Container")
                local itemNameFrame = c and c:FindFirstChild("ItemName")
                local lbl = itemNameFrame and itemNameFrame:FindFirstChild("Label")
                local icon = c and c:FindFirstChild("Container") and c.Container:FindFirstChild("Icon")
                local tags = c and c:FindFirstChild("Tags")

                self.SkinSystem.OriginalNativeEquipped = self.SkinSystem.OriginalNativeEquipped or {}

                if skinName and skinName ~= "" then
                    if not self.SkinSystem.OriginalNativeEquipped[slot] then
                        self.SkinSystem.OriginalNativeEquipped[slot] = {
                            Name = (lbl and lbl.Text ~= skinName and lbl.Text ~= "") and lbl.Text or (self.SkinSystem.NativeEquipped and self.SkinSystem.NativeEquipped[slot]) or slot,
                            Image = (icon and icon.Image ~= skinImg and icon.Image ~= "") and icon.Image or "",
                            RarityColor = itemNameFrame and itemNameFrame.BackgroundColor3 or Color3.fromRGB(220, 20, 20),
                            Christmas = tags and tags:FindFirstChild("Christmas") and tags.Christmas.Visible,
                            Halloween = tags and tags:FindFirstChild("Halloween") and tags.Halloween.Visible,
                            Chroma = tags and tags:FindFirstChild("Chroma") and tags.Chroma.Visible,
                            Unique = tags and tags:FindFirstChild("Unique") and tags.Unique.Visible,
                        }
                    end

                    if lbl then lbl.Text = skinName end
                    if icon and skinImg and skinImg ~= "" then icon.Image = skinImg end
                    if itemNameFrame then itemNameFrame.BackgroundColor3 = rarityColor end

                    if tags then
                        if tags:FindFirstChild("Christmas") then
                            tags.Christmas.Visible = (event == "Christmas")
                            if tags.Christmas.Visible and year and tags.Christmas:FindFirstChild("Year") then
                                tags.Christmas.Year.Text = tostring(year)
                            end
                        end
                        if tags:FindFirstChild("Halloween") then
                            tags.Halloween.Visible = (event == "Halloween")
                            if tags.Halloween.Visible and year and tags.Halloween:FindFirstChild("Year") then
                                tags.Halloween.Year.Text = tostring(year)
                            end
                        end
                        if tags:FindFirstChild("Chroma") then
                            tags.Chroma.Visible = (rarity == "Chroma" or (skinName and skinName:lower():find("chroma") ~= nil))
                        end
                        if tags:FindFirstChild("Unique") then
                            tags.Unique.Visible = (rarity == "Unique")
                        end
                    end
                else
                    if self.SkinSystem.OriginalNativeEquipped[slot] then
                        local orig = self.SkinSystem.OriginalNativeEquipped[slot]
                        if lbl and orig.Name then lbl.Text = orig.Name end
                        if icon and orig.Image then icon.Image = orig.Image end
                        if itemNameFrame and orig.RarityColor then itemNameFrame.BackgroundColor3 = orig.RarityColor end
                        if tags then
                            if tags:FindFirstChild("Christmas") and orig.Christmas ~= nil then
                                tags.Christmas.Visible = orig.Christmas
                            end
                            if tags:FindFirstChild("Halloween") and orig.Halloween ~= nil then
                                tags.Halloween.Visible = orig.Halloween
                            end
                            if tags:FindFirstChild("Chroma") and orig.Chroma ~= nil then
                                tags.Chroma.Visible = orig.Chroma
                            end
                            if tags:FindFirstChild("Unique") and orig.Unique ~= nil then
                                tags.Unique.Visible = orig.Unique
                            end
                        end
                        self.SkinSystem.OriginalNativeEquipped[slot] = nil
                    end
                end
            end
        end
    end)
end

function Hub:CreateSkinPart(rec)
    local root = rec.display and rec.display.root
    local props = root and root.props
    if not props then return nil end

    local targetSize = nil
    if type(props.Size) == "table" then
        targetSize = Vector3.new(props.Size[1], props.Size[2], props.Size[3])
    end

    if props.MeshId then
        local numId = tonumber(string.match(tostring(props.MeshId), "(%d+)"))
        if numId then
            local base = self.SkinSystem.Meshes[numId]
            if not base then
                local ok, mesh
                local as = self.Services.AssetService or game:GetService("AssetService")
                if Content and Content.fromAssetId and as and as.CreateMeshPartAsync then
                    ok, mesh = pcall(as.CreateMeshPartAsync, as, Content.fromAssetId(numId))
                end
                if not ok or not mesh then
                    local part = Instance.new("Part")
                    local sm = Instance.new("SpecialMesh")
                    sm.MeshType = Enum.MeshType.FileMesh
                    sm.MeshId = tostring(props.MeshId)
                    if props.TextureID then sm.TextureId = tostring(props.TextureID) end
                    if props.TextureId then sm.TextureId = tostring(props.TextureId) end
                    if targetSize and type(props.MeshSize) == "table" then
                        local sx = targetSize.X / math.max(0.001, props.MeshSize[1])
                        local sy = targetSize.Y / math.max(0.001, props.MeshSize[2])
                        local sz = targetSize.Z / math.max(0.001, props.MeshSize[3])
                        sm.Scale = Vector3.new(sx, sy, sz)
                    elseif targetSize then
                        sm.Scale = Vector3.new(1, 1, 1)
                    end
                    sm.Parent = part
                    mesh = part
                end
                mesh.Parent = nil
                self.SkinSystem.Meshes[numId] = mesh
                base = mesh
            end
            local part = base:Clone()
            self:ApplySkinProps(part, props)
            if targetSize then
                part.Size = targetSize
            end
            local sm = part:FindFirstChildOfClass("SpecialMesh")
            if sm then
                if targetSize and type(props.MeshSize) == "table" then
                    local sx = targetSize.X / math.max(0.001, props.MeshSize[1])
                    local sy = targetSize.Y / math.max(0.001, props.MeshSize[2])
                    local sz = targetSize.Z / math.max(0.001, props.MeshSize[3])
                    sm.Scale = Vector3.new(sx, sy, sz)
                end
                if props.TextureID then sm.TextureId = tostring(props.TextureID) end
                if props.TextureId then sm.TextureId = tostring(props.TextureId) end
            end
            part.Anchored = true
            part.Massless = true
            part.CanCollide = false
            part.CanQuery = false
            part.CanTouch = false
            part.Locked = true
            return part
        end
    end

    local specialNode = nil
    if type(rec.display and rec.display.nodes) == "table" then
        for _, n in ipairs(rec.display.nodes) do
            if n.class == "SpecialMesh" and n.props and n.props.MeshId then
                specialNode = n
                break
            end
        end
    end
    if specialNode then
        local part = Instance.new("Part")
        self:ApplySkinProps(part, props)
        if targetSize then
            part.Size = targetSize
        end
        part.Anchored = false
        part.Massless = true
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.Locked = true
        local mesh = Instance.new("SpecialMesh")
        mesh.Name = specialNode.name or "Mesh"
        mesh.MeshType = Enum.MeshType.FileMesh
        self:ApplySkinProps(mesh, specialNode.props)
        pcall(function() mesh.MeshId = specialNode.props.MeshId end)
        if specialNode.props.TextureId then
            pcall(function() mesh.TextureId = specialNode.props.TextureId end)
        elseif specialNode.props.TextureID then
            pcall(function() mesh.TextureId = specialNode.props.TextureID end)
        end
        if specialNode.props.Scale and type(specialNode.props.Scale) == "table" then
            mesh.Scale = Vector3.new(specialNode.props.Scale[1], specialNode.props.Scale[2], specialNode.props.Scale[3])
        elseif targetSize and specialNode.props.MeshSize and type(specialNode.props.MeshSize) == "table" then
            local sx = targetSize.X / math.max(0.001, specialNode.props.MeshSize[1])
            local sy = targetSize.Y / math.max(0.001, specialNode.props.MeshSize[2])
            local sz = targetSize.Z / math.max(0.001, specialNode.props.MeshSize[3])
            mesh.Scale = Vector3.new(sx, sy, sz)
        end
        mesh.Parent = part
        return part
    end
    return nil
end

function Hub:ApplySkinFX(rec, owner, body, handle)
    local paths = {}
    local sounds = {}
    if not self.Config.Toggles.SkinWeaponEffects then
        return sounds
    end
    local allNodes = {}
    if rec.display and type(rec.display.nodes) == "table" then
        for _, n in ipairs(rec.display.nodes) do table.insert(allNodes, n) end
    end
    if rec.tool and type(rec.tool.nodes) == "table" then
        for _, n in ipairs(rec.tool.nodes) do table.insert(allNodes, n) end
    end

    for _, node in ipairs(allNodes) do
        local class = node.class
        if skinFxClasses and skinFxClasses[class] then
            local parent = node.parent and paths[node.parent]
            if not parent then
                parent = (skinOnHandleClasses and skinOnHandleClasses[class] and handle) or body
            end
            local inst = Instance.new(class)
            inst.Name = node.name or class
            self:ApplySkinProps(inst, node.props)
            inst.Parent = parent
            if node.tags then
                local cs = self.Services.CollectionService or game:GetService("CollectionService")
                for _, t in ipairs(node.tags) do
                    if cs and cs.AddTag then
                        pcall(function() cs:AddTag(inst, t) end)
                    end
                end
            end
            if node.attrs then
                for k, v in pairs(node.attrs) do
                    pcall(function() inst:SetAttribute(k, v) end)
                end
            end
            if node.path then paths[node.path] = inst end
            if class == "Sound" then sounds[node.name] = inst end
            self:RegisterSkinGarbage(owner, inst)
        end
    end
    return sounds
end

function Hub:ApplySkinSoundsAndAnims(rec, tool)
    if not rec or not tool then return end
    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
    local slot = rec.kind or (rec.meta and rec.meta.ItemType) or "Knife"

    local customSounds = {}
    local customAnims = {}
    local soundsToPreload = {}

    local allNodes = {}
    if type(rec.fx) == "table" then
        for _, n in ipairs(rec.fx) do table.insert(allNodes, n) end
    end
    if rec.tool and type(rec.tool.nodes) == "table" then
        for _, n in ipairs(rec.tool.nodes) do table.insert(allNodes, n) end
    end
    if rec.display and type(rec.display.nodes) == "table" then
        for _, n in ipairs(rec.display.nodes) do table.insert(allNodes, n) end
    end

    local altGunSound = nil
    local normalGunSound = nil
    local customReload = nil

    for _, n in ipairs(allNodes) do
        if n.class == "Sound" and n.props and n.props.SoundId then
            local nName = (n.name or ""):lower()
            local sId = tostring(n.props.SoundId)
            if not nName:find("coin") then
                local sItem = {
                    Name = n.name or (slot == "Gun" and "Gunshot" or "Slash"),
                    SoundId = sId,
                    Volume = n.props.Volume or 1,
                    PlaybackSpeed = n.props.PlaybackSpeed or 1
                }
                customSounds[#customSounds + 1] = sItem
                if nName:find("alt") then
                    altGunSound = sItem
                elseif nName:find("reload") then
                    customReload = sItem
                elseif nName:find("shoot") or nName:find("shot") or nName:find("gun") or nName:find("fire") then
                    if sId ~= "http://www.roblox.com/asset/?id=10209803" and sId ~= "rbxassetid://10209803" then
                        normalGunSound = sItem
                    end
                end
            end
        elseif (n.class == "Animation" or n.class == "StringValue") and n.props and (n.props.AnimationId or n.props.Value) then
            local aId = n.props.AnimationId or n.props.Value
            customAnims[#customAnims + 1] = {
                Name = n.name or (slot == "Gun" and "Shoot" or "Slash"),
                AnimationId = tostring(aId)
            }
        end
    end

    if slot == "Gun" then
        local bestShotSound = altGunSound or normalGunSound
        for _, s in ipairs(tool:GetDescendants()) do
            if s:IsA("Sound") then
                local sName = s.Name:lower()
                if sName:find("shot") or sName:find("shoot") or sName == "gunshot" then
                    if bestShotSound then
                        self:BackupSkinProp(s, { soundId = s.SoundId, volume = s.Volume })
                        s.SoundId = bestShotSound.SoundId
                        s.Volume = bestShotSound.Volume or 1
                        if bestShotSound.PlaybackSpeed then s.PlaybackSpeed = bestShotSound.PlaybackSpeed end
                        table.insert(soundsToPreload, s)
                    end
                elseif sName:find("alt") then
                    self:BackupSkinProp(s, { soundId = s.SoundId, volume = s.Volume })
                    s.Volume = 0
                elseif sName:find("reload") and customReload then
                    self:BackupSkinProp(s, { soundId = s.SoundId, volume = s.Volume })
                    s.SoundId = customReload.SoundId
                    s.Volume = customReload.Volume or 1
                    table.insert(soundsToPreload, s)
                end
            end
        end

        if bestShotSound and handle and not handle:FindFirstChild("Gunshot") then
            local gs = Instance.new("Sound")
            gs.Name = "Gunshot"
            gs.SoundId = bestShotSound.SoundId
            gs.Volume = bestShotSound.Volume or 1
            if bestShotSound.PlaybackSpeed then gs.PlaybackSpeed = bestShotSound.PlaybackSpeed end
            gs.Parent = handle
            self:RegisterSkinGarbage(tool, gs)
            table.insert(soundsToPreload, gs)
        end
    else
        for _, cs in ipairs(customSounds) do
            local csName = (cs.Name or ""):lower()
            local existing = (handle and handle:FindFirstChild(cs.Name)) or (tool:FindFirstChild("Sounds") and tool.Sounds:FindFirstChild(cs.Name))
            if not existing and handle then
                existing = Instance.new("Sound")
                existing.Name = cs.Name
                existing.SoundId = cs.SoundId
                existing.Volume = cs.Volume or 1
                if cs.PlaybackSpeed then existing.PlaybackSpeed = cs.PlaybackSpeed end
                existing.Parent = handle
                self:RegisterSkinGarbage(tool, existing)
            elseif existing then
                self:BackupSkinProp(existing, { soundId = existing.SoundId, volume = existing.Volume })
                existing.SoundId = cs.SoundId
                existing.Volume = cs.Volume or 1
                if cs.PlaybackSpeed then existing.PlaybackSpeed = cs.PlaybackSpeed end
            end
            if existing then table.insert(soundsToPreload, existing) end

            for _, s in ipairs(tool:GetDescendants()) do
                if s:IsA("Sound") and s ~= existing then
                    local sName = s.Name:lower()
                    if (sName == "kill" and (csName:find("kill") or csName:find("hit")))
                       or (sName == "throw" and csName:find("throw")) then
                        self:BackupSkinProp(s, { soundId = s.SoundId, volume = s.Volume })
                        s.SoundId = cs.SoundId
                        s.Volume = cs.Volume or 1
                        table.insert(soundsToPreload, s)
                    end
                end
            end
        end
    end

    if #soundsToPreload > 0 then
        task.spawn(function()
            pcall(function()
                game:GetService("ContentProvider"):PreloadAsync(soundsToPreload)
            end)
        end)
    end

    for _, a in ipairs(tool:GetDescendants()) do
        if a:IsA("Animation") then
            local aName = a.Name:lower()
            for _, ca in ipairs(customAnims) do
                local caName = (ca.Name or ""):lower()
                local match = (aName == caName)
                if not match and (aName:find("shoot") or aName:find("slash") or aName:find("stab") or aName:find("hold")) then
                    if (aName:find("shoot") and caName:find("shoot")) or (aName:find("slash") and caName:find("slash")) or (aName:find("stab") and caName:find("stab")) then
                        match = true
                    end
                end
                if match then
                    self:BackupSkinProp(a, { animId = a.AnimationId })
                    a.AnimationId = ca.AnimationId
                end
            end
        end
    end

    self.SkinSystem.ActiveToolAnims[tool] = customAnims
    self.SkinSystem.ActiveToolSounds[tool] = customSounds

    if slot == "Knife" then
        self.Combat.LastKnifeSlash = self.Combat.LastKnifeSlash or 0
        local actConn = tool.Activated:Connect(function()
            local now = os.clock()
            if (now - self.Combat.LastKnifeSlash) < 0.85 then return end
            self.Combat.LastKnifeSlash = now

            local lp = self.Services.Players.LocalPlayer
            local char = lp and lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if handle then
                for _, cs in ipairs(customSounds) do
                    local csName = (cs.Name or ""):lower()
                    if csName:find("slash") or csName:find("swing") or csName:find("whoosh") or csName:find("throw") then
                        local s = handle:FindFirstChild(cs.Name) or (tool:FindFirstChild("Sounds") and tool.Sounds:FindFirstChild(cs.Name))
                        if s and s:IsA("Sound") then
                            s:Play()
                            break
                        end
                    end
                end
            end

            if hum then
                for _, ca in ipairs(customAnims) do
                    local caName = (ca.Name or ""):lower()
                    if caName:find("slash") or caName:find("stab") then
                        pcall(function()
                            local anim = Instance.new("Animation")
                            anim.AnimationId = ca.AnimationId
                            local track = hum:LoadAnimation(anim)
                            track:Play(0.08, 1, 1)
                        end)
                        break
                    end
                end
            end
        end)
        self:RegisterSkinGarbage(tool, actConn)

        local events = tool:FindFirstChild("Events")
        local handleTouched = events and events:FindFirstChild("HandleTouched")
        if handleTouched and handleTouched:IsA("RemoteEvent") then
            local touchConn = handleTouched.OnClientEvent:Connect(function()
                if handle then
                    for _, cs in ipairs(customSounds) do
                        local csName = (cs.Name or ""):lower()
                        if csName:find("kill") or csName:find("stab") or csName:find("hit") then
                            local s = handle:FindFirstChild(cs.Name) or (tool:FindFirstChild("Sounds") and tool.Sounds:FindFirstChild(cs.Name))
                            if s and s:IsA("Sound") then
                                s:Play()
                                break
                            end
                        end
                    end
                end
            end)
            self:RegisterSkinGarbage(tool, touchConn)
        end
    end
end
function Hub:FindToolBySlot(slot)
    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character
    local bp = lp and lp:FindFirstChildOfClass("Backpack")
    local containers = { char, bp }
    for _, cont in ipairs(containers) do
        if cont then
            for _, ch in ipairs(cont:GetChildren()) do
                if ch:IsA("Tool") then
                    local n = ch.Name:lower()
                    if slot == "Gun" and (n == "gun" or n:find("gun") or n:find("revolver") or ch:FindFirstChild("Shoot") or ch:FindFirstChild("GunShoot")) then
                        return ch
                    elseif slot == "Knife" and (n == "knife" or n:find("knife") or ch:FindFirstChild("Slash") or ch:FindFirstChild("Stab")) then
                        return ch
                    elseif ch.Name == slot then
                        return ch
                    end
                end
            end
        end
    end
    return nil
end

function Hub:FindDisplayPedestal(slot)
    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character
    local ref = char and char:FindFirstChild("DisplayRef" .. slot)
    local part = ref and ref.Value
    if part and part.Parent then return part end
    return nil
end

function Hub:GetSkinGripCFrame(rec, slot)
    -- Check tool root props
    local toolRoot = rec.tool and rec.tool.root
    local grip = toolRoot and toolRoot.props and toolRoot.props.Grip
    if grip and #grip >= 12 then
        return CFrame.new(table.unpack(grip))
    end

    local name = (rec.name or ""):lower()
    local meshId = ""
    for _, n in ipairs((rec.display and rec.display.nodes) or {}) do
        if n.class == "SpecialMesh" and n.props and n.props.MeshId then
            meshId = tostring(n.props.MeshId)
            break
        end
    end
    if rec.display and rec.display.root and rec.display.root.props and rec.display.root.props.MeshId then
        meshId = tostring(rec.display.root.props.MeshId)
    end

    if slot == "Gun" then
        -- Crossbows (Harvester, Icepiercer): horizontal forward grip aligned with hand
        if name:find("harvester") or name:find("icepiercer") or name:find("bow") or name:find("crossbow") or meshId:find("7775027413") or meshId:find("11868991644") then
            return CFrame.new(0, -0.25, 0.45)
        end
        -- Luger family: upright modeled mesh, identity rotation grip
        if name:find("luger") or name == "sugar" or meshId:find("95356090") or meshId:find("101086719") then
            return CFrame.new(0, -0.206, 0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        end
        -- Cartoon / Toy guns
        if name:find("strawberr") or name:find("sunny") or name:find("duckie") or name:find("cherrie") or name:find("floral") or name:find("frozen") or name:find("cookie") or name:find("plaid") or name:find("heartbreak") or name:find("striped") or name:find("paws") or name:find("sunset") or name:find("sticker") then
            return CFrame.new(0.6997, -0.306, 0.001, 0, 0, 1, 0, 1, 0, -1, 0, 0)
        end
        -- Default Gun / Revolver
        return CFrame.new(0, -0.7, -0.3, 1, 0, 0, 0, 0, -1, 0, 1, 0)
    else
        -- Knives
        if name == "candy" then
            return CFrame.new(0.08, 0.79, 0, 0, 0, 1, -0.04, -1, 0, 1, -0.04, 0)
        elseif name:find("americasword") or name:find("sword") then
            return CFrame.new(0.05, 0.18, 1.25, 1, 0, 0, 0, 0, 1, 0, -1, 0)
        elseif name:find("heartblade") then
            return CFrame.new(0.02, -1.42, 0.02, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        elseif name:find("axe") or name:find("scythe") or name:find("chopper") then
            return CFrame.new(0.05, -0.9, 0.35, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        end
        return CFrame.new(0, -1, -0.1, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    end
end

function Hub:ApplySkinToTool(rec, specificTool)
    local slot = rec.kind or (rec.meta and rec.meta.ItemType) or "Knife"
    local tool = specificTool or self:FindToolBySlot(slot)
    if not tool then return false end
    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
    if not handle then return false end

    -- Save original properties before any modifications
    if not self.SkinSystem.OriginalToolGrips[slot] then
        self.SkinSystem.OriginalToolGrips[slot] = tool.Grip
    end
    if tool.TextureId and tool.TextureId ~= "" and not tool.TextureId:find("rbxassetid") then
        if not self.SkinSystem.OriginalToolTextures[slot] then
            self.SkinSystem.OriginalToolTextures[slot] = tool.TextureId
        end
    end

    self:BackupSkinProp(tool, { grip = tool.Grip, textureId = tool.TextureId })
    self:BackupSkinProp(handle, {
        size = handle.Size,
        trans = handle.Transparency,
        mod = handle.LocalTransparencyModifier,
    })

    -- Update Tool Texture and Hotbar Image
    local skinImg = self:GetSkinImage(rec)
    if skinImg and skinImg ~= "" then
        pcall(function() tool.TextureId = skinImg end)
        self:UpdateBackpackIcons(slot, skinImg)
        self:UpdateNativeInventoryEquipped(slot, rec.name, skinImg)
    end

    -- Avoid re-creating skin part if already welded to prevent 1-frame drop/flicker
    local existingBody = tool:FindFirstChild("CustomSkinMesh")
    if existingBody and existingBody:GetAttribute("SkinSig") == rec.sig then
        local targetGrip = self:GetSkinGripCFrame(rec, slot)
        if targetGrip then
            tool.Grip = targetGrip
            local lp = self.Services.Players.LocalPlayer
            local char = lp and lp.Character
            local rightHand = char and (char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm"))
            local rightGrip = rightHand and rightHand:FindFirstChild("RightGrip")
            if rightGrip then rightGrip.C1 = targetGrip end
        end
        handle.LocalTransparencyModifier = 1
        pcall(function() handle.Transparency = 1 end)
        existingBody.LocalTransparencyModifier = 0
        pcall(function() existingBody.Transparency = 0 end)
        return true
    end

    self:ClearSkinGarbage(tool)

    -- Hide default visual textures on handle
    -- DO NOT set SpecialMesh.Scale to 0! Thrown knives in MM2 clone the Handle, so scale 0 made thrown knives invisible!
    for _, ch in ipairs(handle:GetChildren()) do
        if ch:IsA("Decal") or ch:IsA("Texture") or ch:IsA("SurfaceAppearance") then
            self:BackupSkinProp(ch, { trans = ch.Transparency })
            pcall(function() ch.Transparency = 1 end)
        end
    end
    handle.LocalTransparencyModifier = 1
    pcall(function() handle.Transparency = 1 end)

    -- Apply Grip
    local targetGrip = self:GetSkinGripCFrame(rec, slot)
    if targetGrip then
        tool.Grip = targetGrip
        local lp = self.Services.Players.LocalPlayer
        local char = lp and lp.Character
        local rightHand = char and (char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm"))
        local rightGrip = rightHand and rightHand:FindFirstChild("RightGrip")
        if rightGrip then
            rightGrip.C1 = targetGrip
        end
    end

    local body = self:CreateSkinPart(rec)
    if not body then return false end
    body.Name = "CustomSkinMesh"
    body:SetAttribute("SkinSig", rec.sig)
    body.CanCollide = false
    body.CanTouch = false
    body.CanQuery = false
    body.Massless = true
    body.CFrame = handle.CFrame

    -- Rigid Weld guarantees instant mathematical attachment with zero physics engine frame lag
    local weld = Instance.new("Weld")
    weld.Name = "SkinRigidWeld"
    weld.Part0 = handle
    weld.Part1 = body
    weld.C0 = CFrame.new()
    weld.C1 = CFrame.new()
    weld.Parent = body

    body.Parent = tool
    self:RegisterSkinGarbage(tool, body)
    self:RegisterSkinGarbage(tool, weld)
    task.defer(function()
        if body and body.Parent then
            body.Anchored = false
        end
    end)

    self:ApplySkinFX(rec, tool, body, handle)
    self:ApplySkinSoundsAndAnims(rec, tool)

    return true
end

function Hub:ApplySkinToDisplay(rec)
    if not self.SkinSystem.LobbyPedestal then return false end
    local slot = rec.kind or (rec.meta and rec.meta.ItemType) or "Knife"
    local display = self:FindDisplayPedestal(slot)
    if not display then return false end

    self:BackupSkinProp(display, {
        trans = display.Transparency,
        mod = display.LocalTransparencyModifier,
    })
    self:ClearSkinGarbage(display)

    -- Update attachment on display to orient correctly on waist / back
    local dispAtt = display:FindFirstChildOfClass("Attachment")
    if dispAtt and rec.display and rec.display.nodes then
        for _, n in ipairs(rec.display.nodes) do
            if n.class == "Attachment" and n.props and n.props.CFrame then
                self:BackupSkinProp(dispAtt, { cframe = dispAtt.CFrame })
                pcall(function()
                    dispAtt.CFrame = CFrame.new(table.unpack(n.props.CFrame))
                end)
                break
            end
        end
    end

    -- Hide default visual children in display
    for _, ch in ipairs(display:GetChildren()) do
        if ch:IsA("SpecialMesh") then
            self:BackupSkinProp(ch, { scale = ch.Scale })
            pcall(function() ch.Scale = Vector3.new(0, 0, 0) end)
        elseif ch:IsA("Decal") or ch:IsA("Texture") or ch:IsA("SurfaceAppearance") then
            self:BackupSkinProp(ch, { trans = ch.Transparency })
            pcall(function() ch.Transparency = 1 end)
        end
    end

    display.LocalTransparencyModifier = 1
    pcall(function() display.Transparency = 1 end)

    local body = self:CreateSkinPart(rec)
    if not body then return false end
    body.Name = "CustomSkinMesh"
    body.CanCollide = false
    body.CanTouch = false
    body.CanQuery = false
    body.Massless = true
    body.CFrame = display.CFrame

    local weld = Instance.new("WeldConstraint")
    weld.Name = "SkinRigidWeld"
    weld.Part0 = display
    weld.Part1 = body
    weld.Parent = body

    body.Parent = display
    self:RegisterSkinGarbage(display, body)
    self:RegisterSkinGarbage(display, weld)
    task.defer(function()
        if body and body.Parent then
            body.Anchored = false
        end
    end)

    self:ApplySkinFX(rec, display, body, body)
    return true
end

function Hub:EquipSkin(name)
    local rec = self.SkinSystem.ByName[name]
    if not rec then
        return false
    end
    local slot = rec.kind or (rec.meta and rec.meta.ItemType) or "Knife"
    self.SkinSystem.Picked[slot] = rec
    if slot == "Knife" then
        self.SkinSystem.CurrentKnife = name
    else
        self.SkinSystem.CurrentGun = name
    end

    -- Record original native weapon before overriding
    if not self.SkinSystem.NativeEquipped[slot] then
        pcall(function()
            local rep = self.Services.ReplicatedStorage or game:GetService("ReplicatedStorage")
            local ok, profile = pcall(require, rep.Modules.ProfileData)
            if ok and profile and profile.Weapons and profile.Weapons.Equipped then
                self.SkinSystem.NativeEquipped[slot] = profile.Weapons.Equipped[slot]
            end
        end)
    end

    local skinImg = self:GetSkinImage(rec)
    self:UpdateNativeInventoryEquipped(slot, rec.name, skinImg)
    self:UpdateBackpackIcons(slot, skinImg)

    self:ApplySkinToDisplay(rec)
    self:ApplySkinToTool(rec)
    return true
end

function Hub:UnequipSkin(slot)
    if not slot or slot == "All" then
        self:UnequipSkin("Knife")
        self:UnequipSkin("Gun")
        return
    end

    -- 1. Reset state
    self.SkinSystem.Picked[slot] = nil
    if slot == "Knife" then
        self.SkinSystem.CurrentKnife = "None"
    else
        self.SkinSystem.CurrentGun = "None"
    end

    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character

    -- 2. Fully clean up Display (waist / back pedestal)
    local displaysToClean = {}
    local primaryDisp = self:FindDisplayPedestal(slot)
    if primaryDisp then table.insert(displaysToClean, primaryDisp) end

    if char then
        local ref = char:FindFirstChild("DisplayRef" .. slot)
        if ref and ref.Value and not table.find(displaysToClean, ref.Value) then
            table.insert(displaysToClean, ref.Value)
        end
    end
    local wd = workspace:FindFirstChild("WeaponDisplays")
    if wd and char then
        for _, d in ipairs(wd:GetChildren()) do
            if d.Name:lower():find(slot:lower()) then
                local rc = d:FindFirstChildOfClass("RigidConstraint") or d:FindFirstChildOfClass("WeldConstraint")
                if rc and ((rc.Attachment0 and rc.Attachment0:IsDescendantOf(char)) or (rc.Attachment1 and rc.Attachment1:IsDescendantOf(char))) then
                    if not table.find(displaysToClean, d) then
                        table.insert(displaysToClean, d)
                    end
                end
            end
        end
    end

    for _, disp in ipairs(displaysToClean) do
        -- Destroy all custom meshes and added FX
        for _, ch in ipairs(disp:GetChildren()) do
            if ch.Name == "CustomSkinMesh" or ch.Name:find("Skin") or ch:IsA("ParticleEmitter") or ch:IsA("Beam") or ch:IsA("PointLight") or ch:IsA("Highlight") then
                pcall(function() ch:Destroy() end)
            end
        end
        -- Restore base part transparency
        disp.LocalTransparencyModifier = 0
        pcall(function() disp.Transparency = 0 end)

        -- Restore child meshes and decals
        for _, ch in ipairs(disp:GetChildren()) do
            if ch:IsA("SpecialMesh") then
                pcall(function() ch.Scale = Vector3.new(1, 1, 1) end)
            elseif ch:IsA("Decal") or ch:IsA("Texture") or ch:IsA("SurfaceAppearance") then
                pcall(function() ch.Transparency = 0 end)
            elseif ch:IsA("Attachment") then
                local origCf = (self.SkinSystem.Saved[ch] and self.SkinSystem.Saved[ch].cframe)
                if origCf then
                    pcall(function() ch.CFrame = origCf end)
                end
            end
        end
        self:ClearSkinGarbage(disp)
    end

    -- 3. Fully clean up Tools in Hand / Backpack
    local toolsToClean = {}
    local primaryTool = self:FindToolBySlot(slot)
    if primaryTool then table.insert(toolsToClean, primaryTool) end

    local bp = lp and lp:FindFirstChildOfClass("Backpack")
    for _, cont in ipairs({ char, bp }) do
        if cont then
            for _, ch in ipairs(cont:GetChildren()) do
                if ch:IsA("Tool") and not table.find(toolsToClean, ch) then
                    local n = ch.Name:lower()
                    if slot == "Gun" and (n == "gun" or n:find("gun") or n:find("revolver") or ch:FindFirstChild("Shoot") or ch:FindFirstChild("GunShoot")) then
                        table.insert(toolsToClean, ch)
                    elseif slot == "Knife" and (n == "knife" or n:find("knife") or ch:FindFirstChild("Slash") or ch:FindFirstChild("Stab")) then
                        table.insert(toolsToClean, ch)
                    end
                end
            end
        end
    end

    local origTexture = self.SkinSystem.OriginalToolTextures[slot] or ""
    local origGrip = self.SkinSystem.OriginalToolGrips[slot]

    for _, t in ipairs(toolsToClean) do
        -- Destroy all custom meshes & FX
        for _, ch in ipairs(t:GetChildren()) do
            if ch.Name == "CustomSkinMesh" or ch.Name:find("Skin") or ch:IsA("ParticleEmitter") or ch:IsA("Beam") or ch:IsA("PointLight") then
                pcall(function() ch:Destroy() end)
            end
        end

        local handle = t:FindFirstChild("Handle") or t:FindFirstChildWhichIsA("BasePart")
        if handle then
            for _, ch in ipairs(handle:GetChildren()) do
                if ch.Name == "CustomSkinMesh" or ch.Name:find("Skin") or ch:IsA("ParticleEmitter") or ch:IsA("Beam") or ch:IsA("PointLight") then
                    pcall(function() ch:Destroy() end)
                end
                if ch:IsA("Decal") or ch:IsA("Texture") or ch:IsA("SurfaceAppearance") then
                    pcall(function() ch.Transparency = 0 end)
                elseif ch:IsA("SpecialMesh") then
                    pcall(function() ch.Scale = Vector3.new(1, 1, 1) end)
                end
            end
            handle.LocalTransparencyModifier = 0
            pcall(function() handle.Transparency = 0 end)
        end

        -- Restore Grip
        local toolGrip = (self.SkinSystem.Saved[t] and self.SkinSystem.Saved[t].grip) or origGrip
        if toolGrip then
            pcall(function() t.Grip = toolGrip end)
        end
        local rightHand = char and (char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm"))
        local rightGrip = rightHand and rightHand:FindFirstChild("RightGrip")
        if rightGrip and toolGrip then
            pcall(function() rightGrip.C1 = toolGrip end)
        end

        -- Restore TextureId
        local toolTex = (self.SkinSystem.Saved[t] and self.SkinSystem.Saved[t].textureId) or origTexture
        pcall(function() t.TextureId = toolTex end)

        -- Restore sounds
        for _, desc in ipairs(t:GetDescendants()) do
            if desc:IsA("Sound") and self.SkinSystem.Saved[desc] then
                local sData = self.SkinSystem.Saved[desc]
                if sData.soundId then pcall(function() desc.SoundId = sData.soundId end) end
                if sData.volume ~= nil then pcall(function() desc.Volume = sData.volume end) end
            end
        end

        self:ClearSkinGarbage(t)
    end

    -- 4. Restore Backpack and Hotbar icons
    self:UpdateBackpackIcons(slot, origTexture)
    self:UpdateNativeInventoryEquipped(slot, nil, nil)

    -- 5. Restore MM2 Native Equipped Weapon in ProfileData and Server Remotes
    pcall(function()
        local rep = self.Services.ReplicatedStorage or game:GetService("ReplicatedStorage")
        local nativeName = self.SkinSystem.NativeEquipped[slot]
        if nativeName then
            local ok, profile = pcall(require, rep.Modules.ProfileData)
            if ok and profile and profile.Weapons and profile.Weapons.Equipped then
                profile.Weapons.Equipped[slot] = nativeName
            end
            local remotes = rep:FindFirstChild("Remotes")
            local inv = remotes and remotes:FindFirstChild("Inventory")
            local equip = inv and inv:FindFirstChild("Equip")
            if equip and equip:IsA("RemoteEvent") then
                equip:FireServer(nativeName, "Weapons")
            end
        end
    end)
end

function Hub:ReapplySkinSystemEquipped()
    pcall(function()
        for slot, rec in pairs(self.SkinSystem.Picked) do
            if rec then
                local skinImg = self:GetSkinImage(rec)
                self:UpdateNativeInventoryEquipped(slot, rec.name, skinImg)
                if skinImg then
                    self:UpdateBackpackIcons(slot, skinImg)
                end
                self:ApplySkinToDisplay(rec)
                local tool = self:FindToolBySlot(slot)
                if tool then
                    self:ApplySkinToTool(rec, tool)
                end
            end
        end
    end)
end

function Hub:SetupSkinWatchers()
    local lp = self.Services.Players.LocalPlayer
    if not lp then return end

    local function checkAndApplyTool(tool)
        if not (tool and tool:IsA("Tool")) then return end
        local nameLower = tool.Name:lower()
        local slot = nil
        if nameLower:find("gun") or nameLower:find("revolver") or tool:FindFirstChild("Shoot") or tool:FindFirstChild("GunShoot") then
            slot = "Gun"
        elseif nameLower:find("knife") or tool:FindFirstChild("Slash") or tool:FindFirstChild("Stab") then
            slot = "Knife"
        elseif tool.Name == "Gun" then slot = "Gun"
        elseif tool.Name == "Knife" then slot = "Knife" end

        if slot then
            if not self.SkinSystem.OriginalToolGrips[slot] then
                self.SkinSystem.OriginalToolGrips[slot] = tool.Grip
            end
            if tool.TextureId and tool.TextureId ~= "" and not tool.TextureId:find("rbxassetid") then
                if not self.SkinSystem.OriginalToolTextures[slot] then
                    self.SkinSystem.OriginalToolTextures[slot] = tool.TextureId
                end
            end

            if self.SkinSystem.Picked[slot] then
                self:ApplySkinToTool(self.SkinSystem.Picked[slot], tool)
            end
        end
    end

    local function watchContainer(cont)
        if not cont then return end
        cont.ChildAdded:Connect(function(ch)
            if ch:IsA("Tool") then
                checkAndApplyTool(ch)
                ch.Equipped:Connect(function()
                    local csm = ch:FindFirstChild("CustomSkinMesh")
                    if csm and csm.Parent == ch then
                        return
                    end
                    checkAndApplyTool(ch)
                end)
                for _, delaySec in ipairs({ 0.04, 0.12, 0.25 }) do
                    task.delay(delaySec, function()
                        if ch and ch.Parent then checkAndApplyTool(ch) end
                    end)
                end
            end
        end)
    end

    local function setupChar(char)
        if not char then return end
        watchContainer(char)
        for _, ch in ipairs(char:GetChildren()) do
            if ch:IsA("Tool") then
                checkAndApplyTool(ch)
                ch.Equipped:Connect(function()
                    local csm = ch:FindFirstChild("CustomSkinMesh")
                    if csm and csm.Parent == ch then
                        return
                    end
                    checkAndApplyTool(ch)
                end)
            end
        end

        -- Re-skin DisplayRef when MM2 swaps waist/back display upon inventory equip
        local refKnife = char:FindFirstChild("DisplayRefKnife")
        if refKnife and refKnife:IsA("ObjectValue") then
            refKnife.Changed:Connect(function()
                if self.SkinSystem.Picked["Knife"] then
                    task.defer(function() self:ApplySkinToDisplay(self.SkinSystem.Picked["Knife"]) end)
                end
            end)
        end
        local refGun = char:FindFirstChild("DisplayRefGun")
        if refGun and refGun:IsA("ObjectValue") then
            refGun.Changed:Connect(function()
                if self.SkinSystem.Picked["Gun"] then
                    task.defer(function() self:ApplySkinToDisplay(self.SkinSystem.Picked["Gun"]) end)
                end
            end)
        end

        local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
        if hum then
            hum.AnimationPlayed:Connect(function(track)
                local anim = track.Animation
                if not anim then return end
                for tool, animList in pairs(self.SkinSystem.ActiveToolAnims) do
                    if tool and tool.Parent == char then
                        local trackName = (track.Name or anim.Name or ""):lower()
                        for _, ca in ipairs(animList) do
                            local caName = (ca.Name or ""):lower()
                            if (trackName ~= "" and caName ~= "" and (trackName:find(caName) or caName:find(trackName)))
                               or (trackName:find("shoot") and caName:find("shoot"))
                               or (trackName:find("slash") and caName:find("slash")) then
                                pcall(function()
                                    local newAnim = Instance.new("Animation")
                                    newAnim.AnimationId = ca.AnimationId
                                    local customTrack = hum:LoadAnimation(newAnim)
                                    customTrack:Play(0.05, 1, 1)
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end

    -- If user has skin changer skin enabled, changing skin in native MM2 inventory
    -- MUST NOT change the skin on waist, back, or hand! We preserve the custom skin!
    pcall(function()
        local rep = self.Services.ReplicatedStorage or game:GetService("ReplicatedStorage")
        local remotes = rep:FindFirstChild("Remotes")
        local inv = remotes and remotes:FindFirstChild("Inventory")
        local equipRemote = inv and inv:FindFirstChild("Equip")
        if equipRemote and equipRemote:IsA("RemoteEvent") then
            equipRemote.OnClientEvent:Connect(function(itemData)
                task.defer(function()
                    for slot, rec in pairs(self.SkinSystem.Picked) do
                        if rec then
                            self:ApplySkinToDisplay(rec)
                            local tool = self:FindToolBySlot(slot)
                            if tool then
                                self:ApplySkinToTool(rec, tool)
                            end
                        end
                    end
                end)
            end)
        end
    end)

    -- Monitor native MM2 inventory equipped labels, rarity, and ICONS across rounds
    local function hookInventoryEquipped()
        pcall(function()
            local pgui = lp:FindFirstChildOfClass("PlayerGui")
            if not pgui then return end
            local mainGui = pgui:FindFirstChild("MainGUI")
            if not (mainGui and mainGui:FindFirstChild("Game")) then return end

            local containers = {}
            local inv = mainGui.Game:FindFirstChild("Inventory")
            if inv then
                inv:GetPropertyChangedSignal("Visible"):Connect(function()
                    if inv.Visible then
                        self:ReapplySkinSystemEquipped()
                        if self.Config.Toggles.ShowSkinValues then
                            self:UpdateInventoryValues()
                        end
                    end
                end)
                local eq = inv:FindFirstChild("Main") and inv.Main:FindFirstChild("Weapons") and inv.Main.Weapons:FindFirstChild("Equipped") and inv.Main.Weapons.Equipped:FindFirstChild("Container")
                if eq then table.insert(containers, eq) end
            end

            local inv2 = mainGui.Game:FindFirstChild("Inventory2")
            if inv2 then
                local eq2 = inv2:FindFirstChild("Main") and inv2.Main:FindFirstChild("Weapons") and inv2.Main.Weapons:FindFirstChild("Equipped") and inv2.Main.Weapons.Equipped:FindFirstChild("Container")
                if eq2 then table.insert(containers, eq2) end
            end

            local MM2RarityColors = {
                ["Ancient"] = Color3.fromHex("#640aff"),
                ["Godly"] = Color3.fromHex("#ff00b3"),
                ["Legendary"] = Color3.fromHex("#dc0005"),
                ["Rare"] = Color3.fromHex("#00c800"),
                ["Uncommon"] = Color3.fromHex("#00ffff"),
                ["Common"] = Color3.fromHex("#6a6a6a"),
                ["Vintage"] = Color3.fromHex("#e6c800"),
                ["Classic"] = Color3.fromHex("#e6c800"),
                ["Unique"] = Color3.fromHex("#fa8c00"),
                ["Christmas"] = Color3.fromHex("#1ec3be"),
                ["Halloween"] = Color3.fromHex("#b44600"),
                ["Chroma"] = Color3.fromHex("#ff00b3"),
            }

            local function hookSlot(eq, sName)
                local itemF = eq:FindFirstChild(sName)
                if not itemF then return end
                local c = itemF:FindFirstChild("Container")
                local itemNameFrame = c and c:FindFirstChild("ItemName")
                local lbl = itemNameFrame and itemNameFrame:FindFirstChild("Label")
                local icon = c and c:FindFirstChild("Container") and c.Container:FindFirstChild("Icon")

                local function enforceCustomSkin()
                    local rec = self.SkinSystem.Picked[sName]
                    if not rec then return end
                    local skinImg = self:GetSkinImage(rec)
                    self:UpdateNativeInventoryEquipped(sName, rec.name, skinImg)
                    self:ApplySkinToDisplay(rec)
                    local tool = self:FindToolBySlot(sName)
                    if tool then
                        self:ApplySkinToTool(rec, tool)
                    end
                end

                if lbl then
                    lbl:GetPropertyChangedSignal("Text"):Connect(function()
                        local rec = self.SkinSystem.Picked[sName]
                        if rec and lbl.Text ~= rec.name then
                            task.defer(enforceCustomSkin)
                        end
                    end)
                end

                if itemNameFrame then
                    itemNameFrame:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
                        local rec = self.SkinSystem.Picked[sName]
                        if rec then
                            local meta = rec.meta
                            local rarity = meta and meta.Rarity or "Godly"
                            local expectedColor = MM2RarityColors[rarity] or Color3.fromHex("#ff00b3")
                            if itemNameFrame.BackgroundColor3 ~= expectedColor then
                                task.defer(enforceCustomSkin)
                            end
                        end
                    end)
                end

                if icon then
                    icon:GetPropertyChangedSignal("Image"):Connect(function()
                        local rec = self.SkinSystem.Picked[sName]
                        if rec then
                            local skinImg = self:GetSkinImage(rec)
                            if skinImg and icon.Image ~= skinImg then
                                task.defer(enforceCustomSkin)
                            end
                        end
                    end)
                end
            end

            for _, eq in ipairs(containers) do
                for _, sName in ipairs({ "Knife", "Gun" }) do
                    hookSlot(eq, sName)
                end
                eq.ChildAdded:Connect(function(ch)
                    if ch.Name == "Knife" or ch.Name == "Gun" then
                        task.delay(0.05, function()
                            hookSlot(eq, ch.Name)
                            local rec = self.SkinSystem.Picked[ch.Name]
                            if rec then
                                local skinImg = self:GetSkinImage(rec)
                                self:UpdateNativeInventoryEquipped(ch.Name, rec.name, skinImg)
                            end
                        end)
                    end
                end)
            end
        end)
    end

    hookInventoryEquipped()

    -- Monitor Workspace.WeaponDisplays so native inventory changes cannot wipe waist/back pedestal
    pcall(function()
        local wd = workspace:FindFirstChild("WeaponDisplays")
        if wd then
            wd.ChildAdded:Connect(function(ch)
                for _, slot in ipairs({ "Knife", "Gun" }) do
                    if ch.Name:lower():find(slot:lower()) and self.SkinSystem.Picked[slot] then
                        task.delay(0.04, function()
                            if self.SkinSystem.Picked[slot] then
                                self:ApplySkinToDisplay(self.SkinSystem.Picked[slot])
                            end
                        end)
                    end
                end
            end)
        end
    end)

    setupChar(lp.Character)
    lp.CharacterAdded:Connect(function(c)
        task.wait(0.1)
        setupChar(c)
        local bp = lp:FindFirstChildOfClass("Backpack")
        if bp then watchContainer(bp) end
        hookInventoryEquipped()
        for _, delaySec in ipairs({ 0, 0.15, 0.5, 1.2, 2.5 }) do
            task.delay(delaySec, function()
                self:ReapplySkinSystemEquipped()
            end)
        end
    end)

    -- Background watchdog to permanently safeguard custom skin equipped icons after round changes
    task.spawn(function()
        while self.State.Gui and self.State.Gui.Parent do
            task.wait(1.5)
            if self.SkinSystem.Picked["Knife"] or self.SkinSystem.Picked["Gun"] then
                self:ReapplySkinSystemEquipped()
            end
        end
    end)

    local bp = lp:FindFirstChildOfClass("Backpack")
    if bp then watchContainer(bp) end

    -- Watch MM2 BackpackUI to keep skin icons fresh instantly when items are added to backpack frame
    local function watchBackpackUI()
        pcall(function()
            local pgui = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 5)
            local bpUi = pgui and (pgui:FindFirstChild("BackpackUI") or pgui:WaitForChild("BackpackUI", 5))
            local bpFrame = bpUi and (bpUi:FindFirstChild("BackpackFrame") or bpUi:WaitForChild("BackpackFrame", 5))
            if bpFrame then
                bpFrame.ChildAdded:Connect(function(item)
                    for _, delaySec in ipairs({ 0, 0.04, 0.1, 0.25 }) do
                        task.delay(delaySec, function()
                            for slot, rec in pairs(self.SkinSystem.Picked) do
                                local skinImg = self:GetSkinImage(rec)
                                if skinImg then
                                    self:UpdateBackpackIcons(slot, skinImg)
                                end
                            end
                        end)
                    end
                end)
                -- Initial sweep
                for slot, rec in pairs(self.SkinSystem.Picked) do
                    local skinImg = self:GetSkinImage(rec)
                    if skinImg then
                        self:UpdateBackpackIcons(slot, skinImg)
                    end
                end
            end
        end)
    end
    watchBackpackUI()
    lp.ChildAdded:Connect(function(ch)
        if ch:IsA("Backpack") then
            task.wait(0.1)
            watchContainer(ch)
            for _, t in ipairs(ch:GetChildren()) do
                if t:IsA("Tool") then checkAndApplyTool(t) end
            end
        end
    end)

    -- Hook actual weapon firing (GunFired Remote) for custom gunshot sound and flying projectile tracer
    pcall(function()
        local rep = self.Services.ReplicatedStorage or game:GetService("ReplicatedStorage")
        local ws = rep:FindFirstChild("ClientServices") and rep.ClientServices:FindFirstChild("WeaponService")
        local gunFired = ws and ws:FindFirstChild("GunFired")
        if gunFired and gunFired:IsA("RemoteEvent") then
            gunFired.OnClientEvent:Connect(function(wepInst, startPos, hitPos)
                local char = lp.Character
                -- Only trigger if local player is shooter
                local isLocal = false
                if wepInst and char and (wepInst:IsDescendantOf(char) or wepInst.Name:find(lp.Name)) then
                    isLocal = true
                elseif char and char:FindFirstChildOfClass("Tool") then
                    isLocal = true
                end

                if isLocal then
                    -- 1. Gunshot sound is naturally played by Handle.Gunshot:Play() on server,
                    -- which replicates with our custom SoundId applied. Removing duplicate s:Play() eliminates echo!
                    local tool = self:FindToolBySlot("Gun")
                    local handle = tool and (tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart"))

                    -- 2. Play custom gun animation if available
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum and tool and self.SkinSystem.ActiveToolAnims[tool] then
                        for _, ca in ipairs(self.SkinSystem.ActiveToolAnims[tool]) do
                            local caName = (ca.Name or ""):lower()
                            if caName:find("shoot") then
                                pcall(function()
                                    local a = Instance.new("Animation")
                                    a.AnimationId = ca.AnimationId
                                    hum:LoadAnimation(a):Play(0.05, 1, 1)
                                end)
                                break
                            end
                        end
                    end

                    -- 3. Trigger bullet tracer along confirmed shot trajectory
                    if self.Config.Toggles.BulletTracers then
                        local muzzle = nil
                        if tool then
                            local csm = tool:FindFirstChild("CustomSkinMesh")
                            if csm and csm:IsA("BasePart") then
                                muzzle = csm.Position + (csm.CFrame.LookVector * 1.5)
                            elseif handle and handle:IsA("BasePart") then
                                muzzle = handle.Position + (handle.CFrame.LookVector * 1.5)
                            end
                        end
                        if not muzzle and typeof(startPos) == "Vector3" then
                            muzzle = startPos
                        elseif not muzzle and char and char:FindFirstChild("RightHand") then
                            muzzle = char.RightHand.Position
                        end
                        local target = (typeof(hitPos) == "Vector3" and hitPos) or (typeof(startPos) == "Vector3" and startPos)
                        if muzzle and target then
                            self:CreateBulletBeam(muzzle, target)
                        end
                    end
                end
            end)
        end
    end)

    -- Keep handle and its default meshes invisible while holding tool, and immediately restore when unequipped
    self.Services.RunService.RenderStepped:Connect(function()
        local c = lp.Character
        if not c then return end
        for _, ch in ipairs(c:GetChildren()) do
            if ch:IsA("Tool") then
                local h = ch:FindFirstChild("Handle") or ch:FindFirstChildWhichIsA("BasePart")
                if ch:FindFirstChild("CustomSkinMesh") then
                    if h then
                        h.LocalTransparencyModifier = 1
                        h.Transparency = 1
                        for _, sub in ipairs(h:GetChildren()) do
                            if sub:IsA("Decal") or sub:IsA("Texture") then
                                sub.Transparency = 1
                            end
                        end
                    end
                else
                    if h and h.LocalTransparencyModifier > 0 then
                        h.LocalTransparencyModifier = 0
                    end
                end
            end
        end
        if self.Config.Toggles.CrosshairHideDefault then
            local mouse = lp:GetMouse()
            if mouse and mouse.Icon ~= "" then
                mouse.Icon = ""
            end
        end
    end)
end
function Hub:ProcessSkinDatabase(data)
    table.clear(self.SkinSystem.ByName)
    table.clear(self.SkinSystem.ByRarity)
    table.clear(self.SkinSystem.BySlot.Knife)
    table.clear(self.SkinSystem.BySlot.Gun)
    local total = 0
    local entries = data.entries or data
    for _, rec in pairs(entries) do
        if type(rec) == "table" then
            local meta = rec.meta
        local name = rec.name or (meta and meta.ItemName)
        local slot = rec.kind or (meta and meta.ItemType)
        local bucket = slot and self.SkinSystem.BySlot[slot]
        if name and rec.display and bucket then
            bucket[#bucket + 1] = rec
            self.SkinSystem.ByName[name] = rec
            if meta and meta.ItemName and meta.ItemName ~= name then
                self.SkinSystem.ByName[meta.ItemName] = rec
            end
            local val = meta and (meta.Value or meta.Price or meta.val)
            if val and tonumber(val) then
                local numVal = tonumber(val)
                self.ValuesSystem.CachedValues[name] = numVal
                if meta and meta.ItemName then
                    self.ValuesSystem.CachedValues[meta.ItemName] = numVal
                end
            end
            local rarity = (meta and meta.Rarity) or "Unknown"
            local rares = self.SkinSystem.ByRarity[rarity]
            if not rares then
                rares = {}
                self.SkinSystem.ByRarity[rarity] = rares
            end
            rares[#rares + 1] = rec
            total = total + 1
        end
        end
    end
    self.SkinSystem.Loaded = true
    return total
end
function Hub:LoadSkinDatabase()
    local content = nil
    local paths = { "Dynamic_Hub_MM2/skins.json", "Dynamic_Hub/skins.json", "skins.json" }
    for _, p in ipairs(paths) do
        local ok, data = pcall(function()
            if readfile and (not isfile or isfile(p)) then
                return readfile(p)
            end
            return nil
        end)
        if ok and type(data) == "string" and #data > 1000 then
            content = data
            break
        end
    end
    if not content then
        local url = self.SkinSystem.DatabaseURL
        if url and url ~= "" then
            local okNet, res = pcall(function()
                if game.HttpGet then
                    return game:HttpGet(url)
                end
                return nil
            end)
            if okNet and type(res) == "string" and #res > 1000 then
                content = res
                pcall(function()
                    if writefile then
                        if makefolder and (not isfolder or not isfolder("Dynamic_Hub_MM2")) then
                            pcall(makefolder, "Dynamic_Hub_MM2")
                        end
                        pcall(writefile, "Dynamic_Hub_MM2/skins.json", res)
                        pcall(writefile, "skins.json", res)
                    end
                end)
            end
        end
    end
    if content then
        local okParse, data = pcall(self.Services.HttpService.JSONDecode, self.Services.HttpService, content)
        if okParse and type(data) == "table" then
            self:ProcessSkinDatabase(data)
            return true
        end
    end
    return false
end
function Hub:GetLobby()
    return self.Services.Workspace:FindFirstChild("Lobby") or self.Services.Workspace:FindFirstChild("RegularLobby")
end
function Hub:TeleportToLobby(force)
    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return false end
    if not force and not self.AutoFarm.WasDown and not self.Config.Toggles.AutoFarmSafeZone then end
    local lobby = self:GetLobby()
    if not lobby then return false end

    local targetPart = nil
    local spawns = lobby:FindFirstChild("Spawns")
    if spawns then
        local valid = {}
        for _, child in ipairs(spawns:GetChildren()) do
            if child:IsA("BasePart") then
                table.insert(valid, child)
            end
        end
        if #valid > 0 then
            targetPart = valid[math.random(1, #valid)]
        end
    end
    if not targetPart then
        for _, desc in ipairs(lobby:GetDescendants()) do
            if desc:IsA("SpawnLocation") or (desc:IsA("BasePart") and string.find(desc.Name:lower(), "spawn")) then
                targetPart = desc
                break
            end
        end
    end
    if not targetPart then
        local pad = self:GetVotePad("VotePad1") or self:GetVotePad("VotePad2")
        if pad then
            if pad:IsA("BasePart") then
                targetPart = pad
            elseif pad:IsA("Model") then
                targetPart = pad.PrimaryPart or pad:FindFirstChildWhichIsA("BasePart", true)
            end
        end
    end

    local targetPos = nil
    if targetPart then
        targetPos = targetPart.Position + Vector3.new(0, 3.5, 0)
    elseif lobby:IsA("Model") then
        local piv = lobby:GetPivot()
        targetPos = piv and (piv.Position + Vector3.new(0, 5, 0))
    end
    if not targetPos then
        return false
    end
    pcall(function() hum.PlatformStand = false end)
    pcall(function() hum.Sit = false end)
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
    pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
    pcall(function() root.Velocity = Vector3.zero end)
    pcall(function() root.RotVelocity = Vector3.zero end)
    local _, ry, _ = root.CFrame:ToOrientation()
    root.CFrame = CFrame.new(targetPos) * CFrame.Angles(0, ry, 0)
    self:RestoreCollisions()
    return true
end
function Hub:GetActiveMap()
    local ws = self.Services.Workspace
    local normal = ws:FindFirstChild("Normal")
    if normal and (normal:IsA("Model") or normal:IsA("Folder")) then
        return normal
    end
    local map = ws:FindFirstChild("Map")
    if map and (map:IsA("Model") or map:IsA("Folder")) then
        return map
    end
    local coinContainer = ws:FindFirstChild("CoinContainer", true)
    if coinContainer and coinContainer.Parent and coinContainer.Parent ~= ws then
        local p = coinContainer.Parent
        while p and p.Parent and p.Parent ~= ws do
            p = p.Parent
        end
        if p and p.Name ~= "Lobby" and p.Name ~= "RegularLobby" then
            return p
        end
    end
    for _, child in ipairs(ws:GetChildren()) do
        if (child:IsA("Model") or child:IsA("Folder")) and child.Name ~= "Lobby" and child.Name ~= "RegularLobby" and child.Name ~= "Camera" and child.Name ~= "Terrain" then
            if child:FindFirstChild("Spawns") or child:FindFirstChild("CoinContainer") then
                return child
            end
        end
    end
    return nil
end
function Hub:TeleportToMap()
    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return false end
    local map = self:GetActiveMap()
    local targetPos = nil
    if map then
        local spawns = map:FindFirstChild("Spawns")
        if spawns then
            local validSpawns = {}
            for _, child in ipairs(spawns:GetChildren()) do
                if child:IsA("BasePart") then
                    table.insert(validSpawns, child)
                end
            end
            if #validSpawns > 0 then
                local chosen = validSpawns[math.random(1, #validSpawns)]
                targetPos = chosen.Position + Vector3.new(0, 3.5, 0)
            end
        end
        if not targetPos then
            for _, desc in ipairs(map:GetDescendants()) do
                if desc:IsA("SpawnLocation") or (desc:IsA("BasePart") and string.find(desc.Name:lower(), "spawn")) then
                    targetPos = desc.Position + Vector3.new(0, 3.5, 0)
                    break
                end
            end
        end
        if not targetPos and map:IsA("Model") then
            local pivot = map:GetPivot()
            if pivot then
                targetPos = pivot.Position + Vector3.new(0, 5, 0)
            end
        end
    end
    if not targetPos then
        return false
    end
    pcall(function() hum.PlatformStand = false end)
    pcall(function() hum.Sit = false end)
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
    pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
    pcall(function() root.Velocity = Vector3.zero end)
    pcall(function() root.RotVelocity = Vector3.zero end)
    local _, ry, _ = root.CFrame:ToOrientation()
    root.CFrame = CFrame.new(targetPos) * CFrame.Angles(0, ry, 0)
    self:RestoreCollisions()
    return true
end
function Hub:GetVotePad(padName)
    local lobby = self:GetLobby()
    if lobby then
        local votePadsFolder = lobby:FindFirstChild("VotePads")
        if votePadsFolder then
            local p = votePadsFolder:FindFirstChild(padName)
            if p then return p end
        end
        local direct = lobby:FindFirstChild(padName)
        if direct then return direct end
        local rec = lobby:FindFirstChild(padName, true)
        if rec then return rec end
    end
    return self.Services.Workspace:FindFirstChild(padName, true)
end
function Hub:IsVotingActive()
    local lobby = self:GetLobby()
    if not lobby then return false end
    if self.Services.Workspace:FindFirstChild("Map") or self.Services.Workspace:FindFirstChild("Normal") then
        return false
    end
    local pad = self:GetVotePad("VotePad1")
    if not pad then return false end
    local vig = pad:FindFirstChild("VoteInfoGui") or pad:FindFirstChildWhichIsA("BillboardGui", true) or pad:FindFirstChildWhichIsA("SurfaceGui", true)
    if vig then
        if vig:IsA("BillboardGui") or vig:IsA("SurfaceGui") then
            if not vig.Enabled then return false end
        end
        local mn = vig:FindFirstChild("MapName", true)
        if mn and mn:IsA("TextLabel") then
            local t = mn.Text:gsub("%s+", "")
            if t == "" or t == "Map" then return false end
        end
    end
    return true
end
function Hub:ScanMaps()
    local lobby = self:GetLobby()
    local pads = { "VotePad1", "VotePad2", "VotePad3" }
    local result = {}
    for _, padName in ipairs(pads) do
        local pad = self:GetVotePad(padName)
        local mapName = ""
        local votes = ""
        local imageId = ""
        if pad then
            local vig = pad:FindFirstChild("VoteInfoGui") or pad:FindFirstChildWhichIsA("BillboardGui", true) or pad:FindFirstChildWhichIsA("SurfaceGui", true)
            if vig then
                local mn = vig:FindFirstChild("MapName", true)
                if mn and mn:IsA("TextLabel") and mn.Text ~= "" then mapName = mn.Text end
                local vt = vig:FindFirstChild("Votes", true)
                if vt and vt:IsA("TextLabel") and vt.Text ~= "" then votes = vt.Text end
            end
            local mig = pad:FindFirstChild("MapInfoGui")
            if mig then
                local mi = mig:FindFirstChild("MapIcon", true)
                if mi and mi:IsA("ImageLabel") and mi.Image ~= "" then imageId = mi.Image end
            end
            local voteIcons = (lobby and lobby:FindFirstChild("VoteIcons")) or (lobby and lobby:FindFirstChild("VotePads") and lobby.VotePads:FindFirstChild("VoteIcons"))
            if voteIcons then
                local viPad = voteIcons:FindFirstChild(padName)
                if viPad then
                    local img = viPad:FindFirstChildWhichIsA("ImageLabel", true)
                    if img and img.Image ~= "" then imageId = img.Image end
                end
            end
        end
        if not self.Maps.Cached[padName] then
            self.Maps.Cached[padName] = { MapName = padName, Votes = "0", Image = Icons.MapFallback }
        end
        if mapName ~= "" and mapName ~= "Unknown Map" then
            self.Maps.Cached[padName].MapName = mapName
        end
        if votes ~= "" then
            self.Maps.Cached[padName].Votes = votes
        end
        if imageId ~= "" then
            self.Maps.Cached[padName].Image = imageId
        end
        table.insert(result, {
            PadName = padName,
            Pad = pad,
            MapName = self.Maps.Cached[padName].MapName,
            Votes = self.Maps.Cached[padName].Votes,
            Image = self.Maps.Cached[padName].Image,
        })
    end
    return result
end
function Hub:TeleportToPad(padName)
    if not self:IsVotingActive() then return end
    local pad = self:GetVotePad(padName)
    if not pad then return end
    local targetPart = nil
    if pad:IsA("BasePart") then
        targetPart = pad
    else
        for _, p in ipairs(pad:GetChildren()) do
            if p:IsA("BasePart") and p:FindFirstChildOfClass("TouchTransmitter") then
                targetPart = p
                break
            end
        end
        if not targetPart then
            targetPart = pad:FindFirstChild("Pad") or pad.PrimaryPart or pad:FindFirstChildWhichIsA("BasePart")
        end
    end
    local lp = self.Services.Players.LocalPlayer
    local char = lp.Character
    local root = self:GetRoot(char)
    if targetPart and root then
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        root.CFrame = targetPart.CFrame + Vector3.new(0, 3.5, 0)
        if firetouchinterest then
            for _, p in ipairs(pad:GetDescendants()) do
                if p:IsA("BasePart") and p:FindFirstChildOfClass("TouchTransmitter") then
                    pcall(firetouchinterest, root, p, 0)
                    pcall(firetouchinterest, root, p, 1)
                end
            end
            pcall(firetouchinterest, root, targetPart, 0)
            pcall(firetouchinterest, root, targetPart, 1)
        end
    end
end
function Hub:StartVoteDuplicator()
    if self.Maps.DupRunning then return end
    self.Maps.DupRunning = true
    task.spawn(function()
        while self.Config.Toggles.VoteDup and self.State.Gui and self.State.Gui.Parent do
            if not self:IsVotingActive() then
                if self.Maps.StatusLabel then
                    self.Maps.StatusLabel.Text = "Статус: Ожидание голосования..."
                    self.Maps.StatusLabel.TextColor3 = self.Theme.TextMuted
                end
                task.wait(0.4)
            else
                local padName = self.Maps.SelectedPad
                if not padName then
                    if self.Maps.StatusLabel then
                        self.Maps.StatusLabel.Text = "Статус: Нажмите на карту ниже для запуска дюпа"
                        self.Maps.StatusLabel.TextColor3 = self.Theme.HeroYellow
                    end
                    task.wait(0.2)
                else
                    self:UpdateMapCardsHighlight()
                    if self.Maps.StatusLabel then
                        local mapName = (self.Maps.Cached[padName] and self.Maps.Cached[padName].MapName) or padName
                        self.Maps.StatusLabel.Text = "Статус: Дюп голосов для " .. tostring(mapName) .. "..."
                        self.Maps.StatusLabel.TextColor3 = self.Theme.InnocentGreen
                    end
                    local lp = self.Services.Players.LocalPlayer
                    local char = lp.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local root = self:GetRoot(char)
                    if root and hum and hum.Health > 0 then
                        self:TeleportToPad(padName)
                        task.wait(0.22)
                        if self.Config.Toggles.VoteDup and self:IsVotingActive() and self.Maps.SelectedPad == padName then
                            hum.Health = 0
                        end
                    end
                    local deadChar = char
                    local timeout = 0
                    while self.Config.Toggles.VoteDup and self:IsVotingActive() and timeout < 80 do
                        local curChar = lp.Character
                        if curChar and curChar ~= deadChar and curChar:FindFirstChild("HumanoidRootPart") then
                            break
                        end
                        task.wait(0.03)
                        timeout = timeout + 1
                    end
                    task.wait(0.08)
                end
            end
        end
        self.Maps.DupRunning = false
    end)
end
function Hub:UpdateMapCardsHighlight()
    for padName, cardData in pairs(self.Maps.Cards) do
        if cardData and cardData.CardStroke then
            if self.Maps.SelectedPad == padName then
                cardData.CardStroke.Color = self.Theme.InnocentGreen
                cardData.CardStroke.Thickness = 2
            else
                cardData.CardStroke.Color = self.Theme.Border
                cardData.CardStroke.Thickness = 1
            end
        end
    end
end
function Hub:WatchCharacterMorphs()
    local lp = self.Services.Players.LocalPlayer
    if not lp then return end
    local function setupCharWatch(char)
        if not char then return end
        local debounce = false
        local function triggerMorphUpdate()
            if debounce then return end
            debounce = true
            task.delay(0.2, function()
                debounce = false
                if self.Preview and self.Preview.World then
                    self:CloneLocalPlayerModel()
                end
            end)
        end
        local c1 = char.ChildAdded:Connect(triggerMorphUpdate)
        local c2 = char.ChildRemoved:Connect(triggerMorphUpdate)
        local c3 = char.DescendantAdded:Connect(function(d)
            if d:IsA("BasePart") or d:IsA("CharacterMesh") or d:IsA("Shirt") or d:IsA("Pants") or d:IsA("Accessory") or d:IsA("SpecialMesh") then
                triggerMorphUpdate()
            end
        end)
        local c4 = char.DescendantRemoving:Connect(function(d)
            if d:IsA("BasePart") or d:IsA("CharacterMesh") or d:IsA("Shirt") or d:IsA("Pants") or d:IsA("Accessory") or d:IsA("SpecialMesh") then
                triggerMorphUpdate()
            end
        end)
        table.insert(self.State.Connections, c1)
        table.insert(self.State.Connections, c2)
        table.insert(self.State.Connections, c3)
        table.insert(self.State.Connections, c4)
    end
    if lp.Character then
        setupCharWatch(lp.Character)
    end
    lp.CharacterAdded:Connect(function(newChar)
        setupCharWatch(newChar)
        task.wait(0.3)
        if self.Preview and self.Preview.World then
            self:CloneLocalPlayerModel()
        end
    end)
end
function Hub:CheckAutoPrestige()
    if not self.Config.Toggles.AutoPrestige then return end
    local now = os.clock()
    if self.AutoFarm.LastPrestigeCheck and (now - self.AutoFarm.LastPrestigeCheck < 4) then
        return
    end
    self.AutoFarm.LastPrestigeCheck = now
    local lp = self.Services.Players.LocalPlayer
    if not lp then return end
    local shouldPrestige = false
    pcall(function()
        local pg = lp:FindFirstChildOfClass("PlayerGui")
        local mg = pg and pg:FindFirstChild("MainGUI")
        local gameGui = mg and mg:FindFirstChild("Game")
        if gameGui then
            local lvl = gameGui:FindFirstChild("Level")
            local presBtn = lvl and lvl:FindFirstChild("Prestige")
            if presBtn and presBtn:IsA("GuiObject") and presBtn.Visible then
                shouldPrestige = true
            end
            local tabLvl = gameGui:FindFirstChild("TabletLevel")
            local tabPresBtn = tabLvl and tabLvl:FindFirstChild("Prestige")
            if tabPresBtn and tabPresBtn:IsA("GuiObject") and tabPresBtn.Visible then
                shouldPrestige = true
            end
        end
    end)
    if not shouldPrestige then
        pcall(function()
            local xp = lp:GetAttribute("XP") or lp:GetAttribute("NewXP")
            local lvl = lp:GetAttribute("Level")
            if (lvl and lvl >= 100) or (xp and xp >= 100000) then
                shouldPrestige = true
            end
        end)
    end
    if shouldPrestige then
        pcall(function()
            local rep = self.Services.ReplicatedStorage
            local remotes = rep:FindFirstChild("Remotes")
            local inv = remotes and remotes:FindFirstChild("Inventory")
            local presRemote = inv and inv:FindFirstChild("Prestige")
            if presRemote and presRemote:IsA("RemoteEvent") then
                presRemote:FireServer()
                print("[Dynamic Hub] Auto Prestige: FireServer sent!")
            end
        end)
        pcall(function()
            local pg = lp:FindFirstChildOfClass("PlayerGui")
            local mg = pg and pg:FindFirstChild("MainGUI")
            local gameGui = mg and mg:FindFirstChild("Game")
            if gameGui and gameGui:FindFirstChild("Prestige") then
                gameGui.Prestige.Visible = false
            end
        end)
    end
end
function Hub:TeleportToNewServer()
    local ts = self.Services.TeleportService or game:GetService("TeleportService")
    local placeId = game.PlaceId
    pcall(function()
        ts:Teleport(placeId)
    end)
end
function Hub:RejoinServer()
    local ts = self.Services.TeleportService or game:GetService("TeleportService")
    local lp = self.Services.Players.LocalPlayer or game:GetService("Players").LocalPlayer
    local placeId = game.PlaceId
    local jobId = game.JobId
    local players = self.Services.Players:GetPlayers()
    if #players <= 1 or not jobId or jobId == "" then
        pcall(function()
            if lp then lp:Kick("\nRejoining...") end
            task.wait(0.3)
            ts:Teleport(placeId, lp)
        end)
    else
        pcall(function()
            ts:TeleportToPlaceInstance(placeId, jobId, lp)
        end)
    end
end
Hub.Rejoin = Hub.RejoinServer
function Hub:SetupAutoRejoin()
    local ts = self.Services.TeleportService or game:GetService("TeleportService")
    local gs = self.Services.GuiService or game:GetService("GuiService")
    local lp = self.Services.Players.LocalPlayer or game:GetService("Players").LocalPlayer
    local rejoinScheduled = false

    local function handleKick(reason)
        if rejoinScheduled or not self.Config.Toggles.AutoRejoin then return end
        rejoinScheduled = true

        task.spawn(function()
            task.wait(1.5)
            while true do
                -- Try clicking built-in reconnect button first if present
                pcall(function()
                    local coreGui = self.Services.CoreGui or game:GetService("CoreGui")
                    local robloxPromptGui = coreGui and coreGui:FindFirstChild("RobloxPromptGui")
                    local po = robloxPromptGui and robloxPromptGui:FindFirstChild("promptOverlay")
                    if po then
                        for _, desc in ipairs(po:GetDescendants()) do
                            if desc:IsA("GuiButton") and (desc.Name:lower():find("reconnect") or (desc:IsA("TextButton") and desc.Text:lower():find("reconnect"))) then
                                if getconnections then
                                    for _, conn in ipairs(getconnections(desc.MouseButton1Down)) do conn:Fire() end
                                    for _, conn in ipairs(getconnections(desc.Activated)) do conn:Fire() end
                                end
                            end
                        end
                    end
                end)

                -- Rejoin the EXACT SAME SERVER (using current PlaceId and JobId)
                pcall(function()
                    self:RejoinServer()
                end)
                task.wait(3.0)

                -- Fallback if instance teleport failed
                pcall(function()
                    ts:Teleport(game.PlaceId, lp)
                end)
                task.wait(3.5)
            end
        end)
    end

    pcall(function()
        gs.ErrorMessageChanged:Connect(function(msg)
            if msg and #msg > 0 then
                handleKick(msg)
            end
        end)
    end)

    task.spawn(function()
        local coreGui = self.Services.CoreGui or game:GetService("CoreGui")
        local robloxPromptGui = coreGui:WaitForChild("RobloxPromptGui", 10)
        if robloxPromptGui then
            local promptOverlay = robloxPromptGui:WaitForChild("promptOverlay", 10)
            if promptOverlay then
                promptOverlay.ChildAdded:Connect(function(child)
                    local msg = ""
                    pcall(function()
                        local errFrame = child:FindFirstChild("MessageArea", true)
                        local errLbl = errFrame and errFrame:FindFirstChild("ErrorMessage", true)
                        if errLbl and errLbl:IsA("TextLabel") then
                            msg = errLbl.Text
                        end
                    end)
                    handleKick(msg ~= "" and msg or child.Name)
                end)
                for _, child in ipairs(promptOverlay:GetChildren()) do
                    handleKick(child.Name)
                end
            end
        end
    end)
end

function Hub:EnsureDirectories()
    pcall(function()
        if makefolder and isfolder then
            if not isfolder("Dynamic_Hub_MM2") then
                makefolder("Dynamic_Hub_MM2")
            end
            if not isfolder("Dynamic_Hub_MM2/Dynamic_cfg") then
                makefolder("Dynamic_Hub_MM2/Dynamic_cfg")
            end
            if not isfolder("Dynamic_Hub_MM2/Dynamic_values") then
                makefolder("Dynamic_Hub_MM2/Dynamic_values")
            end
        end
    end)
end
function Hub:GetConfigDir()
    self:EnsureDirectories()
    return "Dynamic_Hub_MM2/Dynamic_cfg/"
end
function Hub:SanitizeConfigName(name)
    local clean = tostring(name or "default")
    clean = clean:gsub('[%c\\/:*?"<>|]', "")
    clean = clean:gsub("^[%.%s]+", ""):gsub("[%.%s]+$", "")
    if clean == "" then
        clean = "default"
    end
    return clean
end
function Hub:GetConfigFilePath(name)
    local clean = self:SanitizeConfigName(name)
    local dir = self:GetConfigDir()
    return dir .. clean .. ".json", clean
end
function Hub:GetAutoloadFilePath()
    local dir = self:GetConfigDir()
    return dir .. "autoload.json"
end
function Hub:GetConfigsList()
    local configs = {}
    local seen = {}
    local function addCfg(cName)
        if cName and cName ~= "" and cName ~= "autoload" and cName ~= "MM2_autoload" and cName ~= "values" and not seen[cName] then
            seen[cName] = true
            table.insert(configs, cName)
        end
    end
    pcall(function()
        local list = listfiles or (syn and syn.listfiles)
        if not list then return end
        local dir = self:GetConfigDir()
        local s, files = pcall(list, dir:sub(1, -2))
        if s and type(files) == "table" then
            for _, path in ipairs(files) do
                local fileName = path:match("([^/\\]+)%.json$")
                if fileName and fileName ~= "autoload" and fileName ~= "MM2_autoload" and fileName ~= "values" then
                    addCfg(fileName)
                end
            end
        end
    end)
    table.sort(configs)
    return configs
end
function Hub:SaveConfig(name)
    local path, cleanName = self:GetConfigFilePath(name)
    local wf = writefile or (syn and syn.writefile)
    if not wf then
        return false, "writefile not supported"
    end
    local cfgData = {
        Name = cleanName,
        Version = "1.0",
        SavedAt = os and os.date and os.date("!%Y-%m-%d %H:%M:%SZ") or "Unknown",
        Toggles = {},
        Values = {},
        MenuKey = self.Config.MenuKey and self.Config.MenuKey.Name or "RightControl",
        ShootKey = self.Config.ShootKey and (typeof(self.Config.ShootKey) == "EnumItem" and self.Config.ShootKey.Name or tostring(self.Config.ShootKey)) or "None",
    }
    for k, v in pairs(self.Config.Toggles) do
        cfgData.Toggles[k] = v
    end
    for k, v in pairs(self.Config.Values) do
        cfgData.Values[k] = v
    end
    local okJson, encoded = pcall(function()
        return self.Services.HttpService:JSONEncode(cfgData)
    end)
    if not okJson or not encoded then
        return false, "JSON encode error"
    end
    local okWrite, err = pcall(wf, path, encoded)
    if not okWrite then
        return false, "Write error: " .. tostring(err)
    end
    return true, "Config '" .. cleanName .. "' saved!"
end
function Hub:LoadConfig(name)
    local path, cleanName = self:GetConfigFilePath(name)
    local rf = readfile or (syn and syn.readfile)
    local isf = isfile or (syn and syn.isfile)
    if not (rf and isf) then
        return false, "readfile/isfile not supported"
    end
    if not isf(path) then
        return false, "Config file '" .. cleanName .. "' not found"
    end
    local okRead, content = pcall(rf, path)
    if not okRead or not content or content == "" then
        return false, "Failed to read file"
    end
    local okJson, data = pcall(function()
        return self.Services.HttpService:JSONDecode(content)
    end)
    if not okJson or type(data) ~= "table" then
        return false, "Corrupted config JSON"
    end
    if type(data.Toggles) == "table" then
        for k, v in pairs(data.Toggles) do
            self.Config.Toggles[k] = v
            local controlFunc = nil
            if self.Controls and self.Controls.Toggles then
                controlFunc = self.Controls.Toggles[k]
                if not controlFunc then
                    controlFunc = self.Controls.Toggles[k:gsub("[^%w]", "")]
                end
                if not controlFunc then
                    local normK = k:lower():gsub("[^%w]", "")
                    for ctrlName, fn in pairs(self.Controls.Toggles) do
                        if ctrlName:lower():gsub("[^%w]", "") == normK then
                            controlFunc = fn
                            break
                        end
                    end
                end
            end
            if controlFunc then
                pcall(controlFunc, v, true)
            end
        end
    end
    if type(data.Values) == "table" then
        for k, v in pairs(data.Values) do
            self.Config.Values[k] = v
            if self.Controls and self.Controls.Sliders and self.Controls.Sliders[k] then
                pcall(self.Controls.Sliders[k], v, true)
            elseif self.Controls and self.Controls.Dropdowns and self.Controls.Dropdowns[k] then
                pcall(self.Controls.Dropdowns[k], v, true)
            end
        end
    end
    if data.MenuKey and typeof(data.MenuKey) == "string" and Enum.KeyCode[data.MenuKey] then
        self.Config.MenuKey = Enum.KeyCode[data.MenuKey]
        if self.Controls and self.Controls.Keybinds and self.Controls.Keybinds["MenuKey"] then
            pcall(self.Controls.Keybinds["MenuKey"], self.Config.MenuKey, true)
        end
    end
    if data.ShootKey and typeof(data.ShootKey) == "string" then
        local key = nil
        if Enum.KeyCode[data.ShootKey] then
            key = Enum.KeyCode[data.ShootKey]
        elseif Enum.UserInputType[data.ShootKey] then
            key = Enum.UserInputType[data.ShootKey]
        end
        if key then
            self.Config.ShootKey = key
            if self.Controls and self.Controls.Keybinds and self.Controls.Keybinds["ShootKey"] then
                pcall(self.Controls.Keybinds["ShootKey"], self.Config.ShootKey, true)
            end
        end
    end
    return true, "Config '" .. cleanName .. "' loaded!"
end
function Hub:DeleteConfig(name)
    local path, cleanName = self:GetConfigFilePath(name)
    local df = delfile or (syn and syn.delfile) or removefile or deletefile
    local isf = isfile or (syn and syn.isfile)
    if not (df and isf) then
        return false, "delfile/isfile not supported"
    end
    if not isf(path) then
        return false, "Config does not exist"
    end
    local okDel, err = pcall(df, path)
    if not okDel then
        return false, "Delete failed: " .. tostring(err)
    end
    return true, "Config '" .. cleanName .. "' deleted!"
end
function Hub:GetAutoload()
    local path = self:GetAutoloadFilePath()
    local rf = readfile or (syn and syn.readfile)
    local isf = isfile or (syn and syn.isfile)
    if not (rf and isf and isf(path)) then
        return nil, false
    end
    local okRead, content = pcall(rf, path)
    if not okRead or not content or content == "" then
        return nil, false
    end
    local okJson, data = pcall(function()
        return self.Services.HttpService:JSONDecode(content)
    end)
    if okJson and type(data) == "table" then
        return data.ConfigName or "", data.Enabled == true
    end
    return nil, false
end
function Hub:SetAutoload(name, enabled)
    local path = self:GetAutoloadFilePath()
    local wf = writefile or (syn and syn.writefile)
    if not wf then return false, "writefile not supported" end
    local clean = self:SanitizeConfigName(name)
    local payload = {
        Enabled = enabled == true,
        ConfigName = (enabled == true) and clean or ""
    }
    local okJson, encoded = pcall(function()
        return self.Services.HttpService:JSONEncode(payload)
    end)
    if not okJson or not encoded then return false end
    pcall(wf, path, encoded)
    return true
end

function Hub:CheckAutoload()
    task.spawn(function()
        local autoName, isEnabled = self:GetAutoload()
        if isEnabled and autoName and autoName ~= "" then
            task.wait(0.6)
            local ok, msg = self:LoadConfig(autoName)
            if ok then
                print("[Dynamic Hub] Autoloaded config: " .. tostring(autoName))
            else
                warn("[Dynamic Hub] Failed to autoload config: " .. tostring(msg))
            end
        end
    end)
end
function Hub:UpdateWatermarkValues(measuredFps)
    if not (self.State.Watermark and (self.State.WatermarkFPSLabel or self.State.WatermarkPingLabel)) then return end

    local currentFps = measuredFps
    if not currentFps or currentFps <= 0 then
        pcall(function()
            currentFps = math.floor(workspace:GetRealPhysicsFPS())
        end)
    end
    if not currentFps or currentFps <= 0 then
        currentFps = 60
    end

    local pingMs = 0
    pcall(function()
        local lp = self.Services.Players.LocalPlayer
        if lp and lp.GetNetworkPing then
            pingMs = math.floor(lp:GetNetworkPing() * 1000)
        end
    end)
    if pingMs <= 0 then
        pcall(function()
            local stats = game:GetService("Stats")
            local perf = stats:FindFirstChild("PerformanceStats")
            local pingItem = perf and perf:FindFirstChild("Ping")
            if pingItem then
                pingMs = math.floor(pingItem:GetValue())
            end
        end)
    end
    if pingMs <= 0 then
        pcall(function()
            local stats = game:GetService("Stats")
            local net = stats:FindFirstChild("Network")
            local ssi = net and net:FindFirstChild("ServerStatsItem")
            local dp = ssi and ssi:FindFirstChild("Data Ping")
            if dp then
                pingMs = math.floor(dp:GetValue())
            end
        end)
    end

    if self.State.WatermarkFPSLabel then
        self.State.WatermarkFPSLabel.Text = string.format("%d fps", currentFps)
        if currentFps >= 50 then
            self.State.WatermarkFPSLabel.TextColor3 = Color3.fromRGB(200, 205, 215)
        elseif currentFps >= 30 then
            self.State.WatermarkFPSLabel.TextColor3 = self.Theme.HeroYellow
        else
            self.State.WatermarkFPSLabel.TextColor3 = self.Theme.MurderRed
        end
    end

    if self.State.WatermarkPingLabel then
        self.State.WatermarkPingLabel.Text = string.format("%d ms", pingMs)
        if pingMs <= 80 then
            self.State.WatermarkPingLabel.TextColor3 = Color3.fromRGB(200, 205, 215)
        elseif pingMs <= 140 then
            self.State.WatermarkPingLabel.TextColor3 = self.Theme.HeroYellow
        else
            self.State.WatermarkPingLabel.TextColor3 = self.Theme.MurderRed
        end
    end
end

function Hub:StartMainLoops()
    self.Services.RunService.RenderStepped:Connect(function()
        if self.Config.Toggles.ESPRoles or self.Config.Toggles.ESPGun then
            self:RenderESP()
        end
    end)
    local plRemConn = self.Services.Players.PlayerRemoving:Connect(function(p)
        if self.ESP.Highlights[p] then
            pcall(function() self.ESP.Highlights[p]:Destroy() end)
            self.ESP.Highlights[p] = nil
        end
        self.ESP.PlayerRoles[p] = nil
        local cache = self.ESP.GuiCache and self.ESP.GuiCache[p]
        if cache then
            if cache.TopGui then pcall(function() cache.TopGui:Destroy() end) end
            if cache.BotGui then pcall(function() cache.BotGui:Destroy() end) end
            self.ESP.GuiCache[p] = nil
        end
        if self.ESP.Drawings and self.ESP.Drawings[p] then
            local d = self.ESP.Drawings[p]
            if d.Box then pcall(function() d.Box.Visible = false; d.Box:Remove() end) end
            if d.Tracer then pcall(function() d.Tracer.Visible = false; d.Tracer:Remove() end) end
            self.ESP.Drawings[p] = nil
        end
    end)
    table.insert(self.State.Connections, plRemConn)
    task.spawn(function()
        while self.State.Gui and self.State.Gui.Parent do
            if self.Config.Toggles.AutoShotMurderer and self:IsRoundActive() and (os.clock() - self.Combat.LastShot > 1.4) then
                local lp = self.Services.Players.LocalPlayer
                local char = lp and lp.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local remote, gunTool = self:GetShootRemote()
                if gunTool and hum and hum.Health > 0 then
                    local target = self:GetMurderer()
                    if target and target.Character then
                        local mRoot = self:GetRoot(target.Character)
                        local myRoot = self:GetRoot(char)
                        if mRoot and myRoot then
                            -- No distance limit: auto shoot across entire map without any restrictions
                            if gunTool.Parent ~= char then
                                hum:EquipTool(gunTool)
                                task.wait(0.1)
                            end
                            self:ShootMurderer(self.Config.Toggles.AimWallbang, self.Config.Toggles.AimPrediction, false)
                        end
                    end
                end
            end
            task.wait(self.Config.Toggles.AutoShotMurderer and 0.25 or 1.0)
        end
    end)
    task.spawn(function()
        while self.State.Gui and self.State.Gui.Parent do
            if self.Config.Toggles.KillAll and self:IsRoundActive() then
                self:ExecuteKillAll()
            end
            task.wait(self.Config.Toggles.KillAll and 0.35 or 1.0)
        end
    end)
    task.spawn(function()
        while self.State.Gui and self.State.Gui.Parent do
            if self.Config.Toggles.KillAura then
                local knife = self:FindKnife()
                local lp = self.Services.Players.LocalPlayer
                local myRoot = self:GetRoot(lp.Character)
                if knife and myRoot then
                    local mode = self.Config.Values.KillMode or "Classic"
                    local maxDist = self.Config.Values.KillAuraDist or 18
                    for _, p in ipairs(self.Services.Players:GetPlayers()) do
                        if p ~= lp then
                            local ch = p.Character
                            local root = self:GetRoot(ch)
                            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                            if root and hum and hum.Health > 0 then
                                local dist = (root.Position - myRoot.Position).Magnitude
                                if dist <= maxDist then
                                    task.spawn(function()
                                        if mode == "Silent" then
                                            self:StabSilent(p, knife)
                                        else
                                            self:StabClassic(p, knife)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
            end
            task.wait(self.Config.Toggles.KillAura and 0.1 or 1.0)
        end
    end)
    task.spawn(function()
        while self.State.Gui and self.State.Gui.Parent do
            if self.Config.Toggles.AutoKillSheriff then
                self:KillSheriff()
            end
            task.wait(self.Config.Toggles.AutoKillSheriff and 0.2 or 1.0)
        end
    end)
    task.spawn(function()
        while self.State.Gui and self.State.Gui.Parent do
            if self.Config.Toggles.AutoGrabGun then
                local lp = self.Services.Players.LocalPlayer
                local myRole = self:GetPlayerRole(lp)
                if myRole ~= "Murderer" and myRole ~= "Zombie" then
                    self:GrabDroppedGun()
                end
            end
            task.wait(self.Config.Toggles.AutoGrabGun and 0.25 or 1.0)
        end
    end)
    self.Services.RunService.Heartbeat:Connect(function()
        if self.Config.Toggles.SpeedHack then
            local lp = self.Services.Players.LocalPlayer
            local char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= self.Config.Values.WalkSpeed then
                hum.WalkSpeed = self.Config.Values.WalkSpeed
            end
        end
    end)
    local wasNoClip = false
    self.Services.RunService.Stepped:Connect(function()
        if self.Config.Toggles.NoClip then
            wasNoClip = true
            local char = self.Services.Players.LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        else
            if wasNoClip then
                wasNoClip = false
                self:RestoreCollisions()
            end
        end
    end)
    local flingTargetTouching = false
    self.Services.RunService.Stepped:Connect(function()
        if self.Config.Toggles.AntiFling and (not self.Config.Toggles.WalkFling) then
            local lp = self.Services.Players.LocalPlayer
            for _, p in ipairs(self.Services.Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    for _, part in ipairs(p.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end)
    self.Services.RunService.Heartbeat:Connect(function()
        if not (self.Config.Toggles.AntiFling or self.AutoFarm.IsActive or self.Config.Toggles.WalkFling) then return end
        local lp = self.Services.Players.LocalPlayer
        local char = lp and lp.Character
        local root = char and self:GetRoot(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not (root and hum and hum.Health > 0) then return end
        if not self.AutoFarm.IsActive then
            if not (self.Config.Toggles.WalkFling and flingTargetTouching) then
                if root.AssemblyAngularVelocity.Magnitude > 25 then
                    root.AssemblyAngularVelocity = Vector3.zero
                end
            end
            local vel = root.AssemblyLinearVelocity
            local horizSpeed = Vector2.new(vel.X, vel.Z).Magnitude
            if horizSpeed > 85 then
                root.AssemblyLinearVelocity = Vector3.new(0, math.clamp(vel.Y, -80, 50), 0)
            end
            if math.abs(vel.Y) > 90 then
                root.AssemblyLinearVelocity = Vector3.new(vel.X, math.clamp(vel.Y, -80, 50), vel.Z)
            end
            if hum.PlatformStand and (not self.Config.Toggles.NoClip) then
                hum.PlatformStand = false
            end
            if hum.Sit and not hum.SeatPart then
                hum.Sit = false
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
        if self.Config.Toggles.AntiFling and (not self.Config.Toggles.WalkFling) and root then
            if root.AssemblyAngularVelocity.Magnitude > 15 then
                root.AssemblyAngularVelocity = Vector3.zero
            end
            local vel = root.AssemblyLinearVelocity
            if vel.Magnitude > 75 then
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
    self.Services.RunService.Stepped:Connect(function()
        if self.Config.Toggles.WalkFling then
            local lp = self.Services.Players.LocalPlayer
            local char = lp and lp.Character
            local root = char and self:GetRoot(char)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not (root and hum and hum.Health > 0) then
                flingTargetTouching = false
                return
            end
            hum.PlatformStand = false
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
            local myPos = root.Position
            local touchingRoot = nil
            for _, other in ipairs(self.Services.Players:GetPlayers()) do
                if other ~= lp and other.Character then
                    local oChar = other.Character
                    local oRoot = self:GetRoot(oChar) or oChar:FindFirstChild("HumanoidRootPart") or oChar:FindFirstChild("Torso")
                    local oHum = oChar:FindFirstChildOfClass("Humanoid")
                    if oRoot and oHum and oHum.Health > 0 then
                        local dist = (oRoot.Position - myPos).Magnitude
                        if dist <= 3.8 then -- Реальный радиус физического касания
                            touchingRoot = oRoot
                            break
                        end
                    end
                end
            end
            if touchingRoot then
                flingTargetTouching = true
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
                root.AssemblyAngularVelocity = Vector3.new(0, 85000, 0)
            else
                flingTargetTouching = false
                root.AssemblyAngularVelocity = Vector3.zero
            end
        else
            if flingTargetTouching then
                flingTargetTouching = false
            end
        end
    end)
    self.Services.RunService.Heartbeat:Connect(function()
        if self.Config.Toggles.WalkFling then
            local lp = self.Services.Players.LocalPlayer
            local char = lp and lp.Character
            local root = char and self:GetRoot(char)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                root.AssemblyAngularVelocity = Vector3.zero
                local moveDir = hum.MoveDirection
                local walkSpeed = math.max(hum.WalkSpeed, 16)
                local curY = math.clamp(root.AssemblyLinearVelocity.Y, -25, 15)
                root.AssemblyLinearVelocity = Vector3.new(moveDir.X * walkSpeed, curY, moveDir.Z * walkSpeed)
            end
        end
    end)
    self.Services.RunService.Heartbeat:Connect(function()
        if self.Animations and self.Animations.EmoteWalk and self.Animations.EmoteTrack then
            local track = self.Animations.EmoteTrack
            local ok, playing = pcall(function() return track.IsPlaying end)
            if ok and not playing then
                pcall(function()
                    if track.Length and track.Length > 0 then
                        track:Play()
                    end
                end)
            end
        end
    end)
    self.Services.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
        self.Animations.CurrentTrack = nil
        self.Animations.EmoteTrack = nil
        task.wait(0.25)
        local hum = newChar:WaitForChild("Humanoid", 3)
        if hum and self.Config.Toggles.SpeedHack then
            hum.WalkSpeed = self.Config.Values.WalkSpeed
        end
        self:CloneLocalPlayerModel()
        self:ApplyWorldSettings()
        if self.Config.Toggles.LocalESP then
            self:UpdatePreviewLocalESP()
        end
        if self.SkinSystem.AutoReapply then
            for slot, rec in pairs(self.SkinSystem.Picked) do
                self:ApplySkinToDisplay(rec)
                self:ApplySkinToTool(rec)
            end
        end
    end)
    self:SetupAntiAFK()
    self:LoadCachedValues()
    task.spawn(function()
        self:FetchValues()
        while true do
            task.wait(300) -- Fetches every 5 minutes from GitHub even if content hasn't changed
            self:FetchValues()
            if self.Config.Toggles.ShowSkinValues then
                self:UpdateInventoryValues()
                self:UpdateTradeValues()
            end
        end
    end)
    task.spawn(function()
        while self.State.Gui and self.State.Gui.Parent do
            if self.Config.Toggles.ShowSkinValues then
                local isInvOpen = false
                local lp = self.Services.Players.LocalPlayer
                local pg = lp and lp:FindFirstChild("PlayerGui")
                local gameGui = pg and pg:FindFirstChild("MainGUI") and pg.MainGUI:FindFirstChild("Game")
                if gameGui then
                    local inv = gameGui:FindFirstChild("Inventory")
                    local vp = gameGui:FindFirstChild("ViewProfile")
                    local inv2 = gameGui:FindFirstChild("Inventory2")
                    if (inv and inv.Visible) or (vp and vp.Visible) or (inv2 and inv2.Visible) then
                        isInvOpen = true
                    end
                end
                local isTradeOpen = (self:FindTradeGui() ~= nil)

                if isInvOpen then
                    self:UpdateInventoryValues()
                end
                if isTradeOpen then
                    self:UpdateTradeValues()
                end

                -- Sleep longer when windows are closed to consume 0% CPU
                if isInvOpen or isTradeOpen then
                    task.wait(0.5)
                else
                    task.wait(1.5)
                end
            else
                task.wait(2.0)
            end
        end
    end)
    task.spawn(function()
        self:LoadSkinDatabase()
    end)
    task.spawn(function()
        local lastTime = os.clock()
        local frameCount = 0
        local currentFps = 0
        pcall(function() currentFps = math.floor(workspace:GetRealPhysicsFPS()) end)
        if currentFps <= 0 then currentFps = 60 end
        local wmTimer = self.Services.RunService.RenderStepped:Connect(function()
            if not (self.Config.Toggles.Watermark and self.State.Watermark) then return end
            frameCount = frameCount + 1
            local now = os.clock()
            if now - lastTime >= 0.5 then
                currentFps = math.floor(frameCount / (now - lastTime))
                frameCount = 0
                lastTime = now
                if self.State.Watermark.Visible then
                    self:UpdateWatermarkValues(currentFps)
                end
            end
        end)
        self.State.WatermarkTimer = wmTimer
    end)
    pcall(function()
        local rep = self.Services.ReplicatedStorage
        local remotes = rep:FindFirstChild("Remotes")
        local gp = remotes and remotes:FindFirstChild("Gameplay")
        if gp then
            for _, evName in ipairs({ "GameOver", "RoundEndFade", "VictoryScreen" }) do
                local ev = gp:FindFirstChild(evName)
                if ev and ev:IsA("RemoteEvent") then
                    local c = ev.OnClientEvent:Connect(function()
                        self:StopAutoFarmTween()
                        self.State.DroppedGunPart = nil
                        self:ClearGunESP()
                    end)
                    table.insert(self.State.Connections, c)
                end
            end
        end
    end)
    task.spawn(function()
        while self.State.Gui and self.State.Gui.Parent do
            task.wait(2.0)
            if self.Config.Toggles.AntiStuckLoading then
                local lp = self.Services.Players.LocalPlayer
                local pgui = lp and (lp:FindFirstChildOfClass("PlayerGui") or lp:FindFirstChild("PlayerGui"))
                if pgui then
                    local loading = pgui:FindFirstChild("Loading")
                    if loading and loading.Enabled then
                        local char = lp.Character
                        local root = char and self:GetRoot(char)
                        if root then
                            self:FixStuckLoadingScreen()
                        end
                    end
                end
            end
        end
    end)
    self:StartAutoFarmLoop()
end
function Hub:FixStuckLoadingScreen(force)
    local lp = self.Services.Players.LocalPlayer
    local pgui = lp and (lp:FindFirstChildOfClass("PlayerGui") or lp:FindFirstChild("PlayerGui"))
    if not pgui then return false end
    local fixedAny = false
    local loading = pgui:FindFirstChild("Loading")
    if loading then
        pcall(function()
            loading.Enabled = false
            local container = loading:FindFirstChild("Container")
            if container then
                container.Visible = false
                container.BackgroundTransparency = 1
                for _, ch in ipairs(container:GetDescendants()) do
                    if ch:IsA("GuiObject") then
                        ch.Visible = false
                        if ch:IsA("Frame") or ch:IsA("ScrollingFrame") then
                            ch.BackgroundTransparency = 1
                        elseif ch:IsA("ImageLabel") or ch:IsA("ImageButton") then
                            ch.ImageTransparency = 1
                        elseif ch:IsA("TextLabel") or ch:IsA("TextButton") then
                            ch.TextTransparency = 1
                        end
                    end
                end
            end
            loading:Destroy()
            fixedAny = true
        end)
    end
    local fadeNames = { "CameraFade", "SpawnFade", "Fade" }
    for _, fadeName in ipairs(fadeNames) do
        local fadeGui = pgui:FindFirstChild(fadeName)
        if fadeGui then
            pcall(function()
                fadeGui.Enabled = false
                for _, item in ipairs(fadeGui:GetDescendants()) do
                    if item:IsA("GuiObject") then
                        item.Visible = false
                        if item:IsA("Frame") or item:IsA("ScrollingFrame") then
                            item.BackgroundTransparency = 1
                        elseif item:IsA("ImageLabel") or item:IsA("ImageButton") then
                            item.ImageTransparency = 1
                        end
                    end
                end
                fadeGui:Destroy()
                fixedAny = true
            end)
        end
    end
    pcall(function()
        local sg = self.Services.StarterGui or game:GetService("StarterGui")
        if sg then
            sg:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
        end
    end)
    pcall(function()
        local cam = self.Services.Workspace.CurrentCamera
        if cam and cam.CameraType == Enum.CameraType.Scriptable then
            local char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                cam.CameraType = Enum.CameraType.Custom
                cam.CameraSubject = hum
            end
        end
    end)
    return fixedAny
end

function Hub:PlayCatalogAnimation(assetId, category)
    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    self:StopAnimation()
    task.spawn(function()
        local realAnimId = self:ResolveAnimationId(assetId)
        local anim = Instance.new("Animation")
        anim.AnimationId = realAnimId
        local animator = hum:FindFirstChildOfClass("Animator") or hum
        local track = animator:LoadAnimation(anim)
        if category == "Animations" or category == "Walk Styles" then
            track.Priority = Enum.AnimationPriority.Movement
            track.Looped = true
            track:Play()
            self.Animations.CurrentTrack = track
            self.Animations.EmoteTrack = nil
        else
            track.Priority = Enum.AnimationPriority.Action4
            track.Looped = true
            track:Play()
            self.Animations.CurrentTrack = track
            self.Animations.EmoteTrack = track
        end
    end)
end

function Hub:StopAnimation()
    if self.Animations and self.Animations.CurrentTrack then
        pcall(function() self.Animations.CurrentTrack:Stop() end)
        self.Animations.CurrentTrack = nil
    end
    if self.Animations then
        self.Animations.EmoteTrack = nil
    end
    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
            if t.Priority == Enum.AnimationPriority.Action or t.Priority == Enum.AnimationPriority.Action4 then
                pcall(function() t:Stop() end)
            end
        end
    end
end

function Hub:Notify(title, text, duration)
    pcall(function()
        local sg = self.Services.StarterGui or game:GetService("StarterGui")
        if sg then
            sg:SetCore("SendNotification", {
                Title = tostring(title or "Dynamic Hub"),
                Text = tostring(text or ""),
                Duration = tonumber(duration) or 3,
            })
        end
    end)
end

function Hub:Unload()
    self.State.IsOpen = false
    self:StopAutoFarmTween()
    if self.State.Connections then
        for _, c in ipairs(self.State.Connections) do
            pcall(function() c:Disconnect() end)
        end
        self.State.Connections = {}
    end
    if self.Crosshair.Connection then
        pcall(function() self.Crosshair.Connection:Disconnect() end)
        self.Crosshair.Connection = nil
    end
    if self.Crosshair.Gui then
        pcall(function() self.Crosshair.Gui:Destroy() end)
        self.Crosshair.Gui = nil
    end
    local lp = self.Services.Players.LocalPlayer
    local mm2Crosshair = lp and lp:FindFirstChild("PlayerGui")
        and lp.PlayerGui:FindFirstChild("GameTopbar")
        and lp.PlayerGui.GameTopbar:FindFirstChild("Crosshair")
    if mm2Crosshair and self.Crosshair.OriginalTransparency then
        mm2Crosshair.ImageTransparency = self.Crosshair.OriginalTransparency
    end
    pcall(function() self:StopAnimation() end)
    pcall(function() self:ClearAllESP() end)
    pcall(function() self:DisableXRay() end)
    if self.State.WatermarkTimer then
        pcall(function() self.State.WatermarkTimer:Disconnect() end)
        self.State.WatermarkTimer = nil
    end
    if self.State.Watermark then
        pcall(function() self.State.Watermark:Destroy() end)
        self.State.Watermark = nil
    end
    if self.State.Gui then
        pcall(function() self.State.Gui:Destroy() end)
        self.State.Gui = nil
    end
end

_G.DynamicHub = Hub
if getgenv then pcall(function() getgenv().DynamicHub = Hub end) end
pcall(function() shared.DynamicHub = Hub end)
function Hub:GetSlotItemDetails(slot)
    if not slot or not slot:IsA("Instance") then return nil end
    local details = {
        itemName = self:GetItemNameFromSlot(slot),
        itemType = nil,
        rarity = nil,
        isChroma = false,
        year = nil,
        dataId = nil,
    }
    local tags = slot:FindFirstChild("Tags")
    local chromaTag = tags and tags:FindFirstChild("Chroma")
    local hasVisualChroma = (tags and tags.Visible == true and chromaTag and chromaTag.Visible == true)
    if hasVisualChroma then
        details.isChroma = true
    else
        details.isChroma = false
    end
    if tags and tags.Visible then
        local xmas = tags:FindFirstChild("Christmas")
        if xmas and xmas.Visible then
            local yLbl = xmas:FindFirstChild("Year") or xmas:FindFirstChild("Year2")
            if yLbl and yLbl:IsA("TextLabel") and yLbl.Text ~= "" then
                details.year = tonumber(yLbl.Text) or yLbl.Text
            end
        end
        local hal = tags:FindFirstChild("Halloween")
        if hal and hal.Visible then
            local yLbl = hal:FindFirstChild("Year") or hal:FindFirstChild("Year2")
            if yLbl and yLbl:IsA("TextLabel") and yLbl.Text ~= "" then
                details.year = tonumber(yLbl.Text) or yLbl.Text
            end
        end
    end
    local inFrame = slot:FindFirstChild("ItemName")
    if inFrame and inFrame:IsA("Frame") then
        local bg = inFrame.BackgroundColor3
        local cR, cG, cB = bg.R * 255, bg.G * 255, bg.B * 255
        local rarityDefs = {
            { name = "Ancient",   r = 100, g = 10,  b = 255 },
            { name = "Godly",     r = 255, g = 0,   b = 179 },
            { name = "Vintage",   r = 230, g = 200, b = 0   },
            { name = "Legendary", r = 220, g = 0,   b = 5   },
            { name = "Rare",      r = 0,   g = 200, b = 0   },
            { name = "Uncommon",  r = 0,   g = 255, b = 255 },
            { name = "Common",    r = 106, g = 106, b = 106 },
            { name = "Unique",    r = 240, g = 140, b = 0   },
        }
        local bestRarity = nil
        local bestDist = math.huge
        for _, def in ipairs(rarityDefs) do
            local dr = cR - def.r
            local dg = cG - def.g
            local db = cB - def.b
            local dist = dr*dr + dg*dg + db*db
            if dist < bestDist then
                bestDist = dist
                bestRarity = def.name
            end
        end
        if bestDist < 12000 then
            details.rarity = bestRarity
        end
    end
    local cur = slot.Parent
    while cur and cur ~= game do
        local n = cur.Name:lower()
        if n == "pets" or n == "pet" then
            details.itemType = "Pet"
            break
        elseif n == "radios" or n == "radio" then
            details.itemType = "Radio"
            break
        elseif n == "effects" or n == "effect" then
            details.itemType = "Effect"
            break
        end
        cur = cur.Parent
    end
    pcall(function()
        local icon = slot:FindFirstChild("Icon", true)
        local img = icon and icon.Image
        if img and type(img) == "string" and img ~= "" then
            local cleanImg = img:gsub("&bust=%d+", "")
            local aid = cleanImg:match("[?&]assetId=(%d+)")
                or cleanImg:match("[?&]id=(%d+)")
                or cleanImg:match("rbxassetid://(%d+)")
                or cleanImg:match("asset/%?id=(%d+)")
                or cleanImg:match("(%d+)$") or ""
            if aid ~= "" then
                local map = self:GetItemAssetMap()
                local it = map[aid] or map[cleanImg]
                if it then
                    details.itemName = it.itemName or details.itemName
                    details.itemType = it.itemType or details.itemType
                    details.rarity = it.rarity or details.rarity
                    details.year = it.year or details.year
                    details.dataId = it.dataId
                    if hasVisualChroma or (it.isChroma == true and (tags == nil or not tags.Visible)) then
                        details.isChroma = true
                    else
                        details.isChroma = false
                    end
                    return
                end
            end
        end
    end)
    if not details.itemType or not details.rarity then
        pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            local imod = rs:FindFirstChild("Modules") and rs.Modules:FindFirstChild("InventoryModule")
            if imod then
                local myInv = require(imod).MyInventory
                if myInv and myInv.Data and myInv.Data.Weapons then
                    for catName, catList in pairs(myInv.Data.Weapons) do
                        if type(catList) == "table" then
                            for dId, item in pairs(catList) do
                                if item.LayoutOrder == slot.LayoutOrder or (details.itemName and item.ItemName == details.itemName and item.LayoutOrder == slot.LayoutOrder) then
                                    details.itemType = item.ItemType or details.itemType
                                    if item.Rarity and item.Rarity ~= "" then
                                        details.rarity = (item.Rarity == "Classic" and "Vintage") or item.Rarity
                                    end
                                    details.year = details.year or item.Year
                                    details.dataId = details.dataId or dId
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    if details.itemName and details.itemName ~= "" and (not details.itemType or not details.rarity) then
        pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            local syncObj = rs:FindFirstChild("Database") and rs.Database:FindFirstChild("Sync")
            if syncObj then
                local sync = require(syncObj)
                if sync and sync.Item then
                    local exactMatch = nil
                    local chromaRarityMatch = nil
                    local chromaMatch = nil
                    local anyMatch = nil
                    for id, it in pairs(sync.Item) do
                        if it.ItemName == details.itemName then
                            local itRarity = (it.Rarity == "Classic" and "Vintage") or it.Rarity
                            local cMatch = (details.isChroma and it.Chroma) or ((not details.isChroma) and (not it.Chroma))
                            local rMatch = details.rarity and (itRarity:lower() == details.rarity:lower())
                            local yMatch = details.year and (tostring(it.Year) == tostring(details.year))
                            if cMatch and rMatch and yMatch then
                                exactMatch = it
                                break
                            elseif cMatch and rMatch and not chromaRarityMatch then
                                chromaRarityMatch = it
                            elseif cMatch and not chromaMatch then
                                chromaMatch = it
                            end
                            anyMatch = anyMatch or it
                        end
                    end
                    local chosen = exactMatch or chromaRarityMatch or chromaMatch or anyMatch
                    if chosen then
                        details.itemType = details.itemType or chosen.ItemType
                        local r = chosen.Rarity
                        if r == "Classic" then r = "Vintage" end
                        details.rarity = details.rarity or r
                        details.year = details.year or chosen.Year
                    end
                end
                if (not details.itemType or not details.rarity) and sync and sync.Pets then
                    for _, p in pairs(sync.Pets) do
                        if (p.Name and p.Name == details.itemName) or (p.ItemName and p.ItemName == details.itemName) then
                            details.itemType = "Pet"
                            details.rarity = details.rarity or p.Rarity
                            details.year = details.year or p.Year
                            break
                        end
                    end
                end
            end
        end)
    end
    if (not details.itemType or not details.rarity) and details.itemName then
        local lowName = details.itemName:lower()
        local sv = self.ValuesSystem.StructuredValues and self.ValuesSystem.StructuredValues[lowName]
        if sv and #sv > 0 then
            for _, entry in ipairs(sv) do
                if entry.rarity and not details.rarity then
                    details.rarity = entry.rarity
                end
                if entry.itemType and not details.itemType then
                    details.itemType = entry.itemType
                end
                if details.rarity and details.itemType then break end
            end
        end
    end
    if not details.itemType and details.itemName then
        local nLow = details.itemName:lower()
        if nLow:find("gun") or nLow:find("revolver") or nLow:find("luger") or nLow:find("blaster") or nLow:find("shotgun") then
            details.itemType = "Gun"
        elseif nLow:find("knife") or nLow:find("blade") or nLow:find("dagger") or nLow:find("scythe") or nLow:find("sword") or nLow:find("axe") then
            details.itemType = "Knife"
        end
    end
    return details
end


local Icons = {
    Combat = "rbxassetid://10734975692",
    Visuals = "rbxassetid://10723346959",
    Avatar = "rbxassetid://10747373176",
    Skins = "rbxassetid://7734021595",      -- Lucide palette
    Farm = "rbxassetid://7743866529",       -- Lucide coins
    Misc = "rbxassetid://10709782497",
    Fun = "rbxassetid://74221781983156",
    Maps = "rbxassetid://10723395215",
    Animation = "rbxassetid://10747372992",
    Settings = "rbxassetid://10734950309",
    Config = "rbxassetid://10734950309",
    Gauge = "rbxassetid://7733799969",      -- Lucide gauge
    StarOutline = "rbxassetid://10709790948",
    StarFilled = "rbxassetid://10709790807",
    Search = "rbxassetid://10734883986",
    Close = "rbxassetid://10747384394",
    MapFallback = "rbxassetid://6527581691",
}
function Hub:GetSafeParent()
    local ok, res = pcall(function()
        if gethui then return gethui() end
        return self.Services.CoreGui
    end)
    if ok and res then return res end
    return self.Services.Players.LocalPlayer:WaitForChild("PlayerGui")
end
function Hub:Tween(instance, properties, duration, style, direction)
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    duration = duration or 0.25
    local tw = self.Services.TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties)
    tw:Play()
    return tw
end
function Hub:Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end
function Hub:Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or self.Theme.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end
function Hub:SetupPreview(container)
    local vp = Instance.new("ViewportFrame")
    vp.Name = "CharacterPreview"
    vp.Size = UDim2.new(1, 0, 0, 260)
    vp.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    vp.BorderSizePixel = 0
    vp.Ambient = Color3.fromRGB(230, 230, 240)
    vp.LightColor = Color3.fromRGB(255, 255, 255)
    vp.LightDirection = Vector3.new(-1, -1.5, -2)
    vp.Parent = container
    self:Corner(vp, 8)
    self:Stroke(vp, self.Theme.Border, 1)
    local world = Instance.new("WorldModel")
    world.Parent = vp
    local cam = Instance.new("Camera")
    cam.FieldOfView = 50
    cam.Parent = vp
    vp.CurrentCamera = cam
    self.Preview.Viewport = vp
    self.Preview.World = world
    self.Preview.Camera = cam
    vp.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Preview.Dragging = true
            self.Preview.LastMouse = Vector2.new(input.Position.X, input.Position.Y)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    self.Preview.Dragging = false
                end
            end)
        end
    end)
    self.Services.UserInputService.InputChanged:Connect(function(input)
        if self.Preview.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local current = Vector2.new(input.Position.X, input.Position.Y)
            local delta = current - self.Preview.LastMouse
            self.Preview.LastMouse = current
            self.Preview.Yaw = self.Preview.Yaw - delta.X * 0.015
            self.Preview.Pitch = math.clamp(self.Preview.Pitch - delta.Y * 0.015, -1.35, 1.35)
            self:UpdatePreviewCamera()
        end
    end)
    vp.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            self.Preview.ZoomOffset = math.clamp((self.Preview.ZoomOffset or 0) - input.Position.Z * 0.6, -8, 12)
            self:UpdatePreviewCamera()
        end
    end)
    task.spawn(function()
        task.wait(0.2)
        self:CloneLocalPlayerModel()
    end)
    self.Services.RunService.RenderStepped:Connect(function(dt)
        if self.State.IsOpen and (self.Config.ActiveTab == "Visuals") then
            if not self.Preview.Dragging and self.Config.Toggles.PreviewRotate then
                local spd = (self.Config.Values.PreviewRotateSpeed or 3) * 0.2
                self.Preview.Yaw = (self.Preview.Yaw or 0) + dt * spd
                self:UpdatePreviewCamera()
            end
            self:SyncPreviewRig()
        end
    end)
end
function Hub:CloneLocalPlayerModel()
    if self.Preview.Model then
        pcall(function() self.Preview.Model:Destroy() end)
        self.Preview.Model = nil
    end
    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character
    if not (char and char.Parent) then return end
    local wasArchivable = char.Archivable
    char.Archivable = true
    local clone = nil
    pcall(function()
        clone = char:Clone()
    end)
    char.Archivable = wasArchivable
    if not clone then return end
    clone.Name = "PreviewRig"
    for _, desc in ipairs(clone:GetDescendants()) do
        if desc:IsA("LuaSourceContainer") or desc:IsA("Sound") or desc:IsA("Highlight") or desc:IsA("BillboardGui") or desc:IsA("SurfaceGui") or desc:IsA("JointInstance") then
            pcall(function() desc:Destroy() end)
        elseif desc:IsA("BasePart") then
            desc.Anchored = true
            desc.CanCollide = false
            desc.CanTouch = false
            desc.CanQuery = false
            desc.CastShadow = false
        end
    end
    local hum = clone:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            hum.PlatformStand = true
        end)
    end
    local cframeOrigin = char:GetPivot()
    local turnFront = CFrame.Angles(0, math.pi, 0)
    for _, desc in ipairs(clone:GetDescendants()) do
        if desc:IsA("BasePart") then
            local livePart = char:FindFirstChild(desc.Name, true)
            if livePart and livePart:IsA("BasePart") then
                local rel = cframeOrigin:ToObjectSpace(livePart.CFrame)
                desc.CFrame = turnFront * rel
            else
                local rel = cframeOrigin:ToObjectSpace(desc.CFrame)
                desc.CFrame = turnFront * rel
            end
        end
    end
    clone.Parent = self.Preview.World
    self.Preview.Model = clone
    self.Preview.ZoomOffset = 0
    self:UpdatePreviewCamera()
    self:TogglePreviewAura(true)
    self:UpdatePreviewLocalESP()
end
function Hub:SyncPreviewRig()
    if not (self.Preview.Model and self.Preview.Model.Parent) then return end
    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character
    if not (char and char.Parent) then return end
    local cframeOrigin = char:GetPivot()
    local turnFront = CFrame.Angles(0, math.pi, 0)
    for _, part in ipairs(self.Preview.Model:GetDescendants()) do
        if part:IsA("BasePart") then
            local livePart = char:FindFirstChild(part.Name, true)
            if livePart and livePart:IsA("BasePart") then
                local rel = cframeOrigin:ToObjectSpace(livePart.CFrame)
                part.CFrame = turnFront * rel
            end
        end
    end
end
function Hub:GetPreviewFraming()
    local defaultDist = 6.8
    local defaultCenterY = 0.0
    if not self.Preview.Model then
        return defaultDist, defaultCenterY
    end
    local bboxCf, bboxSize = nil, nil
    pcall(function()
        bboxCf, bboxSize = self.Preview.Model:GetBoundingBox()
    end)
    if not bboxSize or bboxSize.Y < 0.5 then
        return defaultDist, defaultCenterY
    end
    local fov = (self.Preview.Camera and self.Preview.Camera.FieldOfView) or 50
    local fovRad = math.rad(fov)
    local halfTan = math.tan(fovRad / 2)
    local vp = self.Preview.Viewport
    local vpSize = vp and vp.AbsoluteSize or Vector2.new(220, 260)
    local aspect = (vpSize.X > 0 and vpSize.Y > 0) and (vpSize.X / vpSize.Y) or 0.85
    local distY = (bboxSize.Y / 2) / halfTan
    local maxHorizontal = math.max(bboxSize.X, bboxSize.Z)
    local distX = (maxHorizontal / 2) / (halfTan * aspect)
    local idealDist = math.max(distY, distX) * 1.25
    local clampedDist = math.clamp(idealDist, 2.5, 25.0)
    local centerY = bboxCf.Position.Y
    return clampedDist, centerY
end
function Hub:UpdatePreviewCamera()
    if not self.Preview.Camera then return end
    local autoDist, centerY = self:GetPreviewFraming()
    local manualZoom = self.Preview.ZoomOffset or 0
    local dist = math.clamp(autoDist + manualZoom, 2.0, 30.0)
    local target = Vector3.new(0, centerY, 0)
    local cf = CFrame.new(target)
        * CFrame.Angles(0, self.Preview.Yaw or 0, 0)
        * CFrame.Angles(self.Preview.Pitch or 0, 0, 0)
        * CFrame.new(0, 0, dist)
    self.Preview.Camera.CFrame = CFrame.lookAt(cf.Position, target)
end
function Hub:TogglePreviewAura(state)
    self.Config.Toggles.PreviewAura = state
    if not self.Preview.Model then return end
    local root = self:GetRoot(self.Preview.Model) or self.Preview.Model:FindFirstChildWhichIsA("BasePart")
    if not root then return end
    if state then
        if not self.Preview.AuraEmitter then
            local p = Instance.new("ParticleEmitter")
            p.Name = "PreviewAuraEmitter"
            p.Texture = "rbxassetid://243098098"
            p.Rate = 24
            p.Lifetime = NumberRange.new(0.8, 1.4)
            p.Speed = NumberRange.new(1.5, 3)
            p.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.4),
                NumberSequenceKeypoint.new(1, 1.2),
            })
            p.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(1, 1),
            })
            p.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
            p.LightEmission = 0.8
            p.Parent = root
            self.Preview.AuraEmitter = p
        end
    else
        if self.Preview.AuraEmitter then
            pcall(function() self.Preview.AuraEmitter:Destroy() end)
            self.Preview.AuraEmitter = nil
        end
    end
end
function Hub:UpdatePreviewLocalESP()
    if not self.Preview.Model then return end
    local lp = self.Services.Players.LocalPlayer
    local role = self:GetPlayerRole(lp)
    local color = self:GetRoleColor(role)
    local selBox = self.Preview.Model:FindFirstChild("PreviewESP_Box")
    if self.Config.Toggles.LocalESP then
        if not selBox then
            selBox = Instance.new("SelectionBox")
            selBox.Name = "PreviewESP_Box"
            selBox.LineThickness = 0.04
            selBox.SurfaceTransparency = 1 -- Полностью прозрачная поверхность, руки и кожа сохраняют естественный цвет
            selBox.Adornee = self.Preview.Model
            selBox.Parent = self.Preview.Model
        end
        selBox.Color3 = color
        selBox.SurfaceColor3 = color
        selBox.Visible = true
        if self.Preview.AuraEmitter then
            self.Preview.AuraEmitter.Color = ColorSequence.new(color)
        end
    else
        if selBox then
            selBox.Visible = false
        end
        if self.Preview.AuraEmitter then
            self.Preview.AuraEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        end
    end
end
function Hub:SetupSidePanel(screen, main)
    local sidePanel = Instance.new("Frame")
    sidePanel.Name = "SidePreviewPanel"
    sidePanel.AnchorPoint = Vector2.new(0, 0.5)
    sidePanel.Size = UDim2.new(0, 240, 0, 360)
    sidePanel.BackgroundColor3 = self.Theme.MainBg
    sidePanel.BorderSizePixel = 0
    sidePanel.Visible = false
    sidePanel.ZIndex = 8
    sidePanel.Parent = screen
    self:Corner(sidePanel, 16)
    self:Stroke(sidePanel, self.Theme.Border, 1)
    self.State.SidePanel = sidePanel
    self.State.SidePanelOpen = false
    local sideShadow = Instance.new("ImageLabel")
    sideShadow.Name = "SideDropShadow"
    sideShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    sideShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    sideShadow.Size = UDim2.new(1, 40, 1, 40)
    sideShadow.BackgroundTransparency = 1
    sideShadow.Image = "rbxassetid://6014261993"
    sideShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    sideShadow.ImageTransparency = 0.35
    sideShadow.ScaleType = Enum.ScaleType.Slice
    sideShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    sideShadow.ZIndex = 7
    sideShadow.Parent = sidePanel
    self.State.SideShadow = sideShadow
    local sideHeader = Instance.new("Frame")
    sideHeader.Name = "SideHeader"
    sideHeader.Size = UDim2.new(1, 0, 0, 40)
    sideHeader.BackgroundColor3 = self.Theme.TopBarBg
    sideHeader.BorderSizePixel = 0
    sideHeader.ZIndex = 9
    sideHeader.Parent = sidePanel
    self:Corner(sideHeader, 16)
    local sideFiller = Instance.new("Frame")
    sideFiller.Position = UDim2.new(0, 0, 1, -12)
    sideFiller.Size = UDim2.new(1, 0, 0, 12)
    sideFiller.BackgroundColor3 = self.Theme.TopBarBg
    sideFiller.BorderSizePixel = 0
    sideFiller.ZIndex = 9
    sideFiller.Parent = sideHeader
    local sideDivider = Instance.new("Frame")
    sideDivider.Size = UDim2.new(1, 0, 0, 1)
    sideDivider.Position = UDim2.new(0, 0, 1, -1)
    sideDivider.BackgroundColor3 = self.Theme.Border
    sideDivider.BorderSizePixel = 0
    sideDivider.ZIndex = 10
    sideDivider.Parent = sideHeader
    local sideIcon = Instance.new("ImageLabel")
    sideIcon.Name = "SideIcon"
    sideIcon.Position = UDim2.new(0, 12, 0.5, -8)
    sideIcon.Size = UDim2.new(0, 16, 0, 16)
    sideIcon.BackgroundTransparency = 1
    sideIcon.Image = Icons.Avatar or "rbxassetid://10747373176"
    sideIcon.ImageColor3 = self.Theme.Accent
    sideIcon.ZIndex = 10
    sideIcon.Parent = sideHeader
    local sideTitle = Instance.new("TextLabel")
    sideTitle.Name = "Title"
    sideTitle.Position = UDim2.new(0, 34, 0, 0)
    sideTitle.Size = UDim2.new(1, -70, 1, 0)
    sideTitle.BackgroundTransparency = 1
    sideTitle.Font = Enum.Font.GothamBold
    sideTitle.Text = "Avatar Preview"
    sideTitle.TextColor3 = self.Theme.TextPrimary
    sideTitle.TextSize = 13
    sideTitle.TextXAlignment = Enum.TextXAlignment.Left
    sideTitle.ZIndex = 10
    sideTitle.Parent = sideHeader
    local sideCloseBtn = Instance.new("ImageButton")
    sideCloseBtn.Name = "CloseBtn"
    sideCloseBtn.Size = UDim2.new(0, 24, 0, 24)
    sideCloseBtn.Position = UDim2.new(1, -34, 0.5, -12)
    sideCloseBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    sideCloseBtn.Image = Icons.Close
    sideCloseBtn.ImageColor3 = self.Theme.TextDim
    sideCloseBtn.AutoButtonColor = false
    sideCloseBtn.ZIndex = 10
    sideCloseBtn.Parent = sideHeader
    self:Corner(sideCloseBtn, 6)
    self:Stroke(sideCloseBtn, self.Theme.Border, 1)
    sideCloseBtn.MouseEnter:Connect(function()
        self:Tween(sideCloseBtn, { BackgroundColor3 = Color3.fromRGB(220, 50, 70), ImageColor3 = Color3.fromRGB(255, 255, 255) }, 0.15)
    end)
    sideCloseBtn.MouseLeave:Connect(function()
        self:Tween(sideCloseBtn, { BackgroundColor3 = Color3.fromRGB(24, 24, 32), ImageColor3 = self.Theme.TextDim }, 0.15)
    end)
    sideCloseBtn.MouseButton1Click:Connect(function()
        self:ToggleSidePanel(false)
    end)
    local sideContent = Instance.new("ScrollingFrame")
    sideContent.Name = "SideContent"
    sideContent.Position = UDim2.new(0, 10, 0, 48)
    sideContent.Size = UDim2.new(1, -20, 1, -58)
    sideContent.BackgroundTransparency = 1
    sideContent.BorderSizePixel = 0
    sideContent.ScrollBarThickness = 3
    sideContent.ScrollBarImageColor3 = self.Theme.Accent
    sideContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    sideContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sideContent.ZIndex = 9
    sideContent.Parent = sidePanel
    local sideLayout = Instance.new("UIListLayout")
    sideLayout.Padding = UDim.new(0, 8)
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideLayout.Parent = sideContent
    self:SetupPreview(sideContent)
    local idleCard = Instance.new("Frame")
    idleCard.Name = "IdleCard"
    idleCard.Size = UDim2.new(1, 0, 0, 36)
    idleCard.BackgroundColor3 = self.Theme.CardBg
    idleCard.BorderSizePixel = 0
    idleCard.ZIndex = 9
    idleCard.Parent = sideContent
    self:Corner(idleCard, 8)
    self:Stroke(idleCard, self.Theme.Border, 1)
    local idlePad = Instance.new("UIPadding")
    idlePad.PaddingLeft = UDim.new(0, 12)
    idlePad.PaddingRight = UDim.new(0, 12)
    idlePad.Parent = idleCard
    local idleLabel = Instance.new("TextLabel")
    idleLabel.Size = UDim2.new(1, -50, 1, 0)
    idleLabel.BackgroundTransparency = 1
    idleLabel.Font = Enum.Font.GothamMedium
    idleLabel.Text = "Auto Rotation (Вращение)"
    idleLabel.TextColor3 = self.Theme.TextPrimary
    idleLabel.TextSize = 11
    idleLabel.TextXAlignment = Enum.TextXAlignment.Left
    idleLabel.ZIndex = 10
    idleLabel.Parent = idleCard
    local switch = Instance.new("TextButton")
    switch.Name = "Switch"
    switch.Size = UDim2.new(0, 36, 0, 18)
    switch.Position = UDim2.new(1, -36, 0.5, -9)
    switch.BackgroundColor3 = self.Config.Toggles.PreviewRotate and self.Theme.Accent or Color3.fromRGB(36, 36, 46)
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.ZIndex = 10
    switch.Parent = idleCard
    self:Corner(switch, 9)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = self.Config.Toggles.PreviewRotate and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = self.Config.Toggles.PreviewRotate and Color3.fromRGB(20, 22, 30) or Color3.fromRGB(210, 215, 225)
    knob.BorderSizePixel = 0
    knob.ZIndex = 11
    knob.Parent = switch
    self:Corner(knob, 7)
    switch.MouseButton1Click:Connect(function()
        self.Config.Toggles.PreviewRotate = not self.Config.Toggles.PreviewRotate
        local state = self.Config.Toggles.PreviewRotate
        local knobColor = state and Color3.fromRGB(20, 22, 30) or Color3.fromRGB(210, 215, 225)
        self:Tween(switch, { BackgroundColor3 = state and self.Theme.Accent or Color3.fromRGB(36, 36, 46) }, 0.2)
        self:Tween(knob, { Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = knobColor }, 0.2)
    end)
    local sideArrowBtn = Instance.new("TextButton")
    sideArrowBtn.Name = "SideArrowBtn"
    sideArrowBtn.AnchorPoint = Vector2.new(0, 0.5)
    sideArrowBtn.Position = UDim2.new(1, 4, 0.5, 0)
    sideArrowBtn.Size = UDim2.new(0, 24, 0, 56)
    sideArrowBtn.BackgroundColor3 = self.Theme.TopBarBg
    sideArrowBtn.BorderSizePixel = 0
    sideArrowBtn.Text = ""
    sideArrowBtn.AutoButtonColor = false
    sideArrowBtn.ZIndex = 10
    sideArrowBtn.Parent = main
    self:Corner(sideArrowBtn, 8)
    self:Stroke(sideArrowBtn, self.Theme.Border, 1)
    self.State.SideArrowBtn = sideArrowBtn
    local btnAvatarIcon = Instance.new("ImageLabel")
    btnAvatarIcon.Name = "Icon"
    btnAvatarIcon.Size = UDim2.new(0, 16, 0, 16)
    btnAvatarIcon.Position = UDim2.new(0.5, -8, 0, 8)
    btnAvatarIcon.BackgroundTransparency = 1
    btnAvatarIcon.Image = Icons.Avatar or "rbxassetid://10747373176"
    btnAvatarIcon.ImageColor3 = self.Theme.Accent
    btnAvatarIcon.ZIndex = 11
    btnAvatarIcon.Parent = sideArrowBtn
    local btnArrowLbl = Instance.new("TextLabel")
    btnArrowLbl.Name = "ArrowLabel"
    btnArrowLbl.Size = UDim2.new(1, 0, 0, 22)
    btnArrowLbl.Position = UDim2.new(0, 0, 0, 28)
    btnArrowLbl.BackgroundTransparency = 1
    btnArrowLbl.Font = Enum.Font.GothamBold
    btnArrowLbl.Text = ">"
    btnArrowLbl.TextColor3 = self.Theme.Accent
    btnArrowLbl.TextSize = 14
    btnArrowLbl.TextXAlignment = Enum.TextXAlignment.Center
    btnArrowLbl.ZIndex = 11
    btnArrowLbl.Parent = sideArrowBtn
    self.State.SideArrowLabel = btnArrowLbl
    sideArrowBtn.MouseEnter:Connect(function()
        self:Tween(sideArrowBtn, { BackgroundColor3 = self.Theme.CardHover }, 0.15)
    end)
    sideArrowBtn.MouseLeave:Connect(function()
        self:Tween(sideArrowBtn, { BackgroundColor3 = self.Theme.TopBarBg }, 0.15)
    end)
    sideArrowBtn.MouseButton1Click:Connect(function()
        self:ToggleSidePanel()
    end)
    self:UpdateSidePanelPosition()
end
function Hub:UpdateSidePanelPosition()
    local panel = self.State.SidePanel
    local main = self.State.MainFrame
    if not (panel and main) then return end
    local halfMainW = main.Size.X.Offset / 2
    local panelW = panel.Size.X.Offset
    local cam = self.Services.Workspace.CurrentCamera
    local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
    local rightPos = main.Position.X.Offset + halfMainW + 44
    if (main.Position.X.Scale * vp.X + rightPos + panelW) > vp.X then
        panel.Position = UDim2.new(
            main.Position.X.Scale,
            main.Position.X.Offset - halfMainW - panelW - 14,
            main.Position.Y.Scale,
            main.Position.Y.Offset
        )
    else
        panel.Position = UDim2.new(
            main.Position.X.Scale,
            rightPos,
            main.Position.Y.Scale,
            main.Position.Y.Offset
        )
    end
end
function Hub:ToggleSidePanel(forceState)
    local panel = self.State.SidePanel
    if not panel then return end
    local isOpen = not self.State.SidePanelOpen
    if forceState ~= nil then isOpen = forceState end
    self.State.SidePanelOpen = isOpen
    if self.State.SideArrowLabel then
        self.State.SideArrowLabel.Text = isOpen and "<" or ">"
    end
    if isOpen then
        self:UpdateSidePanelPosition()
        panel.Visible = true
        self:Tween(panel, { BackgroundTransparency = 0 }, 0.2)
        task.spawn(function()
            task.wait(0.05)
            self:CloneLocalPlayerModel()
        end)
    else
        local tw = self:Tween(panel, { BackgroundTransparency = 1 }, 0.15)
        tw.Completed:Connect(function()
            if not self.State.SidePanelOpen then
                panel.Visible = false
            end
        end)
    end
end
function Hub:InitCrosshair()
    if self.Crosshair.Gui then return end
    local screen = Instance.new("ScreenGui")
    screen.Name = "DynamicHub_Crosshair"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.DisplayOrder = 999999
    screen.Parent = self:GetSafeParent()
    self.Crosshair.Gui = screen
    local container = Instance.new("Frame")
    container.Name = "CrosshairContainer"
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.Size = UDim2.new(0, 80, 0, 80)
    container.BackgroundTransparency = 1
    container.Visible = false
    container.Parent = screen
    self.Crosshair.Container = container
    local dot = Instance.new("Frame")
    dot.Name = "CenterDot"
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.new(0.5, 0, 0.5, 0)
    dot.Size = UDim2.new(0, 3, 0, 3)
    dot.BackgroundColor3 = self.Theme.Accent
    dot.BorderSizePixel = 0
    dot.Parent = container
    self:Corner(dot, 2)
    self:Stroke(dot, Color3.fromRGB(0, 0, 0), 1)
    self.Crosshair.Dot = dot
    local lines = {}
    local directions = {
        Top = Vector2.new(0.5, 1),
        Bottom = Vector2.new(0.5, 0),
        Left = Vector2.new(1, 0.5),
        Right = Vector2.new(0, 0.5),
    }
    for name, anchor in pairs(directions) do
        local line = Instance.new("Frame")
        line.Name = name .. "Line"
        line.AnchorPoint = anchor
        line.BackgroundColor3 = self.Theme.Accent
        line.BorderSizePixel = 0
        line.Parent = container
        self:Corner(line, 2)
        self:Stroke(line, Color3.fromRGB(0, 0, 0), 1)
        lines[name] = line
    end
    self.Crosshair.Lines = lines
    self:UpdateCrosshairGeometry()
    if self.Crosshair.Connection then
        self.Crosshair.Connection:Disconnect()
    end
    self.Crosshair.Connection = self.Services.RunService.RenderStepped:Connect(function(dt)
        self:UpdateCrosshairFrame(dt)
    end)
end
function Hub:UpdateCrosshairGeometry()
    if not self.Crosshair.Container then return end
    local color = self.Theme.Accent
    if self.Config.Values.CrosshairColor == "White" then
        color = Color3.fromRGB(255, 255, 255)
    elseif self.Config.Values.CrosshairColor == "Cyan" then
        color = Color3.fromRGB(0, 240, 255)
    elseif self.Config.Values.CrosshairColor == "Green" then
        color = Color3.fromRGB(60, 255, 120)
    elseif self.Config.Values.CrosshairColor == "Red" then
        color = Color3.fromRGB(255, 60, 80)
    elseif self.Config.Values.CrosshairColor == "Yellow" then
        color = Color3.fromRGB(255, 220, 50)
    end
    if self.Crosshair.Dot then
        self.Crosshair.Dot.Visible = self.Config.Toggles.CrosshairDot
        self.Crosshair.Dot.BackgroundColor3 = color
    end
    local size = self.Config.Values.CrosshairSize or 12
    local thick = self.Config.Values.CrosshairThickness or 2
    local gap = self.Config.Values.CrosshairGap or 5
    local lines = self.Crosshair.Lines
    if lines.Top then
        lines.Top.Size = UDim2.new(0, thick, 0, size)
        lines.Top.Position = UDim2.new(0.5, 0, 0.5, -gap)
        lines.Top.BackgroundColor3 = color
    end
    if lines.Bottom then
        lines.Bottom.Size = UDim2.new(0, thick, 0, size)
        lines.Bottom.Position = UDim2.new(0.5, 0, 0.5, gap)
        lines.Bottom.BackgroundColor3 = color
    end
    if lines.Left then
        lines.Left.Size = UDim2.new(0, size, 0, thick)
        lines.Left.Position = UDim2.new(0.5, -gap, 0.5, 0)
        lines.Left.BackgroundColor3 = color
    end
    if lines.Right then
        lines.Right.Size = UDim2.new(0, size, 0, thick)
        lines.Right.Position = UDim2.new(0.5, gap, 0.5, 0)
        lines.Right.BackgroundColor3 = color
    end
end
function Hub:HasGunInHand()
    local lp = self.Services.Players.LocalPlayer
    local char = lp and lp.Character
    if not char then return false end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name == "Gun" or string.find(string.lower(tool.Name), "gun")) then
            return true
        end
    end
    return false
end
function Hub:UpdateCrosshairFrame(dt)
    if not self.Crosshair.Container then return end
    local enabled = self.Config.Toggles.CustomCrosshair
    if not enabled then
        if self.Crosshair.Container.Visible then
            self.Crosshair.Container.Visible = false
            local lp = self.Services.Players.LocalPlayer
            local mm2Crosshair = lp and lp:FindFirstChild("PlayerGui")
                and lp.PlayerGui:FindFirstChild("GameTopbar")
                and lp.PlayerGui.GameTopbar:FindFirstChild("Crosshair")
            if mm2Crosshair and self.Crosshair.OriginalTransparency then
                mm2Crosshair.ImageTransparency = self.Crosshair.OriginalTransparency
                self.Crosshair.OriginalTransparency = nil
            end
        end
        return
    end
    local hasGun = self:HasGunInHand()
    local shouldShow = enabled
    if self.Config.Toggles.CrosshairOnlyGun then
        shouldShow = enabled and hasGun
    end
    local lp = self.Services.Players.LocalPlayer
    local mm2Crosshair = lp and lp:FindFirstChild("PlayerGui")
        and lp.PlayerGui:FindFirstChild("GameTopbar")
        and lp.PlayerGui.GameTopbar:FindFirstChild("Crosshair")
    if shouldShow then
        if self.Config.Toggles.CrosshairHideDefault and mm2Crosshair then
            if not self.Crosshair.OriginalTransparency then
                self.Crosshair.OriginalTransparency = mm2Crosshair.ImageTransparency
            end
            mm2Crosshair.ImageTransparency = 1
        end
        local uis = self.Services.UserInputService
        local mPos
        if uis.MouseBehavior == Enum.MouseBehavior.LockCenter then
            local cam = self.Services.Workspace.CurrentCamera
            local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
            mPos = Vector2.new(vp.X / 2, vp.Y / 2)
        else
            mPos = uis:GetMouseLocation()
        end
        self.Crosshair.Container.Position = UDim2.new(0, mPos.X, 0, mPos.Y)
        self.Crosshair.Container.Visible = true
        if self.Config.Toggles.CrosshairSpin then
            local speed = self.Config.Values.CrosshairSpinSpeed or 3
            self.Crosshair.Container.Rotation = (self.Crosshair.Container.Rotation + (speed * dt * 60)) % 360
        else
            self.Crosshair.Container.Rotation = 0
        end
    else
        self.Crosshair.Container.Visible = false
        if mm2Crosshair and self.Crosshair.OriginalTransparency then
            mm2Crosshair.ImageTransparency = self.Crosshair.OriginalTransparency
            self.Crosshair.OriginalTransparency = nil
        end
    end
end
function Hub:GetItemAssetMap()
    if self.ItemAssetMap then return self.ItemAssetMap end
    local map = {}
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local syncObj = rs:FindFirstChild("Database") and rs.Database:FindFirstChild("Sync")
        if syncObj then
            local sync = require(syncObj)
            if sync and sync.Item then
                for id, it in pairs(sync.Item) do
                    local itImg = tostring(it.Image or ""):gsub("&bust=%d+", "")
                    local aid = itImg:match("[?&]assetId=(%d+)")
                        or itImg:match("[?&]id=(%d+)")
                        or itImg:match("rbxassetid://(%d+)")
                        or itImg:match("asset/%?id=(%d+)")
                        or itImg:match("(%d+)$") or ""
                    local r = it.Rarity
                    if r == "Classic" then r = "Vintage" end
                    local data = {
                        itemName = it.ItemName,
                        itemType = it.ItemType,
                        rarity = r,
                        year = it.Year,
                        dataId = id,
                        isChroma = (it.Chroma == true)
                    }
                    if aid ~= "" then map[aid] = data end
                    map[tostring(id)] = data
                    if it.ItemID and not map[tostring(it.ItemID)] then
                        map[tostring(it.ItemID)] = data
                    end
                end
            end
            if sync and sync.Pets then
                for id, p in pairs(sync.Pets) do
                    local pImg = tostring(p.Image or ""):gsub("&bust=%d+", "")
                    local aid = pImg:match("[?&]assetId=(%d+)")
                        or pImg:match("[?&]id=(%d+)")
                        or pImg:match("rbxassetid://(%d+)")
                        or pImg:match("asset/%?id=(%d+)")
                        or pImg:match("(%d+)$") or ""
                    local data = {
                        itemName = p.Name or p.ItemName,
                        itemType = "Pet",
                        rarity = p.Rarity,
                        year = p.Year,
                        dataId = id,
                        isChroma = false
                    }
                    if aid ~= "" then map[aid] = data end
                    if p.ItemID then map[tostring(p.ItemID)] = data end
                    map[tostring(id)] = data
                end
            end
        end
    end)
    self.ItemAssetMap = map
    return map
end
function Hub:GetSkinValue(skinName, details)
    if not skinName or type(skinName) ~= "string" then return nil end
    local clean = skinName:gsub("^%s+", ""):gsub("%s+$", "")
    if clean == "" or clean == "Loading..." or clean == "None" then return nil end
    local lowerClean = clean:lower()
    if lowerClean == "default knife" or lowerClean == "default gun" or lowerClean == "defaultknife" or lowerClean == "defaultgun" then
        return nil
    end
    local function checkVal(v)
        if type(v) == "number" and v > 0 then
            return v
        elseif type(v) == "string" and v ~= "" and v ~= "0" and v ~= "None" then
            local n = tonumber(v)
            if n then
                return n > 0 and n or nil
            end
            return v
        end
        return nil
    end
    local function lookup(key)
        if not key or key == "" then return nil end
        local val = checkVal(self.ValuesSystem.CachedValues[key])
            or checkVal(self.ValuesSystem.CachedValues[key:lower()])
        return val
    end
    local d = details or {}
    local r = d.rarity
    local t = d.itemType
    local isChroma = d.isChroma
    local year = d.year
    if isChroma == true then
        local cv = lookup("Chroma " .. clean .. " (" .. (t or "Knife") .. ")")
            or lookup("Chroma " .. clean)
            or lookup("Chroma " .. clean .. " [Godly]")
            or lookup("Chroma " .. clean .. " [Ancient]")
            or lookup(clean .. "Chroma")
            or lookup(clean .. " Chroma")
        if cv then return cv end
        return nil
    end
    if t == "Pet" then
        local pv = lookup(clean .. " (Pet)") or lookup(clean .. " (pet)") or lookup(clean)
        if pv then return pv end
    end
    if year then
        local yStr = tostring(year)
        if t then
            local yv = lookup(clean .. " (" .. t .. ") [XMAS" .. yStr .. "]")
                or lookup(clean .. " (" .. t .. ") [HALLOWS" .. yStr .. "]")
                or lookup(clean .. " (" .. t .. ") [" .. yStr .. "]")
            if yv then return yv end
        end
        local yvGeneric = lookup(clean .. " [XMAS" .. yStr .. "]")
            or lookup(clean .. " [HALLOWS" .. yStr .. "]")
            or lookup(clean .. " [" .. yStr .. "]")
        if yvGeneric then return yvGeneric end
    end
    if t and r then
        local trv = lookup(clean .. " (" .. t .. ") [" .. r .. "]")
            or lookup(clean .. " [" .. r .. "]")
        if trv then return trv end
    elseif r then
        local rv = lookup(clean .. " [" .. r .. "]")
        if rv then return rv end
    end
    local svList = self.ValuesSystem.StructuredValues and self.ValuesSystem.StructuredValues[lowerClean]
    if svList and #svList > 0 then
        for _, entry in ipairs(svList) do
            local chromaMatch = (isChroma and (entry.is_chroma or (entry.rawKey and entry.rawKey:find("Chroma"))))
                or ((not isChroma) and (not entry.is_chroma and not (entry.rawKey and entry.rawKey:find("Chroma"))))
            if chromaMatch then
                if t and r and entry.itemType and entry.itemType:lower() == t:lower() and entry.rarity and entry.rarity:lower() == r:lower() then
                    local val = checkVal(entry.value)
                    if val then return val end
                end
            end
        end
        if r then
            for _, entry in ipairs(svList) do
                local chromaMatch = (isChroma and (entry.is_chroma or (entry.rawKey and entry.rawKey:find("Chroma"))))
                    or ((not isChroma) and (not entry.is_chroma and not (entry.rawKey and entry.rawKey:find("Chroma"))))
                if chromaMatch and entry.rarity and entry.rarity:lower() == r:lower() then
                    if not t or not entry.itemType or entry.itemType:lower() == t:lower() then
                        local val = checkVal(entry.value)
                        if val then return val end
                    end
                end
            end
        end
        if t then
            for _, entry in ipairs(svList) do
                local chromaMatch = (isChroma and (entry.is_chroma or (entry.rawKey and entry.rawKey:find("Chroma"))))
                    or ((not isChroma) and (not entry.is_chroma and not (entry.rawKey and entry.rawKey:find("Chroma"))))
                if chromaMatch and entry.itemType and entry.itemType:lower() == t:lower() then
                    if not r or not entry.rarity or entry.rarity:lower() == r:lower() then
                        local val = checkVal(entry.value)
                        if val then return val end
                    end
                end
            end
        end
    end
    if t == "Gun" then
        local valGun = lookup(clean .. " (Gun)") or lookup(lowerClean .. " (gun)")
        if valGun then
            if svList and r then
                local conflict = false
                for _, entry in ipairs(svList) do
                    if entry.value == valGun and entry.rarity and entry.rarity:lower() ~= r:lower() then
                        conflict = true
                        break
                    end
                end
                if not conflict then return valGun end
            else
                return valGun
            end
        end
    elseif t == "Knife" then
        local valKnife = lookup(clean .. " (Knife)") or lookup(lowerClean .. " (knife)")
        if valKnife then
            if svList and r then
                local conflict = false
                for _, entry in ipairs(svList) do
                    if entry.value == valKnife and entry.rarity and entry.rarity:lower() ~= r:lower() then
                        conflict = true
                        break
                    end
                end
                if not conflict then return valKnife end
            else
                return valKnife
            end
        end
    end
    local plain = lookup(clean)
    if plain then
        if svList and #svList > 0 and r then
            for _, entry in ipairs(svList) do
                if entry.value == plain and entry.rarity and entry.rarity:lower() ~= r:lower() then
                    plain = nil
                    break
                end
            end
        end
        if plain then return plain end
    end
    return nil
end
function Hub:GetItemNameFromSlot(slot)
    if not slot or not slot:IsA("Instance") then return nil end
    local inFrame = slot:FindFirstChild("ItemName")
    local inLabel = inFrame and inFrame:FindFirstChild("Label")
    if inLabel and inLabel:IsA("TextLabel") and inLabel.Text ~= "" and inLabel.Text ~= "..." and inLabel.Text ~= "Loading..." then
        return inLabel.Text
    end
    for _, name in ipairs({ "Label", "ItemName", "WeaponName", "Weapon", "Item", "Title" }) do
        local lbl = slot:FindFirstChild(name, true)
        if lbl and lbl:IsA("TextLabel") and lbl.Text ~= "" and lbl.Text ~= "..." and lbl.Text ~= "Loading..." and lbl.Name ~= "ValText" and lbl.Name ~= "TotalText" and lbl.Name ~= "Amount" and lbl.Name ~= "TradeAmount" then
            return lbl.Text
        end
    end
    local sName = slot.Name
    if sName and sName ~= "Slot" and sName ~= "Item" and sName ~= "Template" and sName ~= "NewItem" and sName ~= "ImageButton" and sName ~= "Frame" and not sName:find("^%d+$") then
        return sName
    end
    return nil
end
function Hub:RegisterValueEntry(rawKey, valData)
    if not rawKey or valData == nil then return end
    local sKey = tostring(rawKey):gsub("^%s+", ""):gsub("%s+$", "")
    if type(valData) == "table" and (valData.Knife ~= nil or valData.Gun ~= nil or valData.Pet ~= nil) then
        if valData.Knife ~= nil then
            self:RegisterValueEntry(sKey .. " (Knife)", valData.Knife)
        end
        if valData.Gun ~= nil then
            self:RegisterValueEntry(sKey .. " (Gun)", valData.Gun)
        end
        if valData.Pet ~= nil then
            self:RegisterValueEntry(sKey .. " (Pet)", valData.Pet)
        end
        return
    end
    if type(valData) == "table" and valData[1] ~= nil then
        for _, sub in ipairs(valData) do
            self:RegisterValueEntry(sKey, sub)
        end
        return
    end
    local finalVal = nil
    local rarity = nil
    local itemType = nil
    local isChroma = nil
    if type(valData) == "number" or type(valData) == "string" then
        finalVal = valData
    elseif type(valData) == "table" then
        finalVal = valData.value or valData.val or (valData.meta and valData.meta.Value)
        rarity = valData.rarity or valData.Rarity or (valData.meta and valData.meta.Rarity)
        itemType = valData.itemType or valData.type or valData.ItemType or (valData.meta and valData.meta.ItemType)
        if valData.is_chroma ~= nil then
            isChroma = valData.is_chroma
        elseif valData.isChroma ~= nil then
            isChroma = valData.isChroma
        end
    end
    if finalVal == nil then return end
    local parenType = sKey:match("%((%a+)%)")
    if parenType then
        local pLow = parenType:lower()
        if pLow == "gun" or pLow == "knife" or pLow == "pet" then
            itemType = itemType or (pLow:sub(1,1):upper() .. pLow:sub(2))
        elseif pLow == "vintage" or pLow == "ancient" then
            rarity = rarity or (pLow:sub(1,1):upper() .. pLow:sub(2))
        end
    end
    local bracketRarity = sKey:match("%[([%a%s]+)%]")
    if bracketRarity and not bracketRarity:find("%d") then
        rarity = rarity or bracketRarity:gsub("^%s+", ""):gsub("%s+$", "")
    end
    local cleanName = sKey:gsub("%s*%b()", ""):gsub("%s*%b[]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    if cleanName == "" then cleanName = sKey end
    local cleanLower = cleanName:lower()
    if not self.ValuesSystem.StructuredValues then
        self.ValuesSystem.StructuredValues = {}
    end
    if not self.ValuesSystem.StructuredValues[cleanLower] then
        self.ValuesSystem.StructuredValues[cleanLower] = {}
    end
    local entryIsChroma = isChroma or (sKey:find("Chroma") ~= nil)
    table.insert(self.ValuesSystem.StructuredValues[cleanLower], {
        value = finalVal,
        rarity = rarity,
        itemType = itemType,
        is_chroma = entryIsChroma,
        rawKey = sKey,
    })
    self.ValuesSystem.CachedValues[sKey] = finalVal
    self.ValuesSystem.CachedValues[sKey:lower()] = finalVal
    local alpha = sKey:lower():gsub("%W", "")
    if alpha ~= "" then self.ValuesSystem.CachedValues[alpha] = finalVal end
    if itemType and rarity then
        self.ValuesSystem.CachedValues[cleanLower .. " (" .. itemType:lower() .. ") [" .. rarity:lower() .. "]"] = finalVal
    end
    if itemType then
        self.ValuesSystem.CachedValues[cleanLower .. " (" .. itemType:lower() .. ")"] = finalVal
    end
    if rarity then
        self.ValuesSystem.CachedValues[cleanLower .. " [" .. rarity:lower() .. "]"] = finalVal
    end
    if not itemType and not rarity then
        self.ValuesSystem.CachedValues[cleanLower] = finalVal
    end
end
function Hub:GetValuesDir()
    pcall(function()
        if makefolder and isfolder then
            if not isfolder("Dynamic_Hub_MM2") then makefolder("Dynamic_Hub_MM2") end
            if not isfolder("Dynamic_Hub_MM2/Dynamic_values") then makefolder("Dynamic_Hub_MM2/Dynamic_values") end
        end
    end)
    return "Dynamic_Hub_MM2/Dynamic_values/"
end
function Hub:GetValuesCacheFilePath()
    local dir = self:GetValuesDir()
    return dir .. "values.json"
end
function Hub:ApplyValuesData(data)
    if not data or type(data) ~= "table" then return end
    if data.entries and type(data.entries) == "table" then
        for _, entry in pairs(data.entries) do
            local n = entry.name or (entry.meta and entry.meta.ItemName)
            if n then
                self:RegisterValueEntry(n, entry)
            end
        end
    end
    local map = data.values or (not data.entries and data) or nil
    if map and type(map) == "table" then
        for k, v in pairs(map) do
            self:RegisterValueEntry(k, v)
        end
    end
end
function Hub:LoadCachedValues()
    local filePath = self:GetValuesCacheFilePath()
    local rf = readfile or (syn and syn.readfile)
    local isf = isfile or (syn and syn.isfile)
    if not (rf and isf and isf(filePath)) then return false end
    if isf(filePath) then
        local ok, content = pcall(rf, filePath)
        if ok and type(content) == "string" and #content > 100 then
            local decodeOk, data = pcall(function()
                return self.Services.HttpService:JSONDecode(content)
            end)
            if decodeOk and type(data) == "table" then
                self:ApplyValuesData(data)
                return true
            end
        end
    end
    return false
end
function Hub:FetchValues()
    local url = self.Config.Values.ValuesURL or self.ValuesSystem.DatabaseURL
    if not url or url == "" then return end
    task.spawn(function()
        local function fetch(targetUrl)
            local ok, res = pcall(function()
                local bustUrl = targetUrl .. "?bust=" .. tostring(os.time())
                if game.HttpGet then
                    return game:HttpGet(bustUrl)
                end
                local req = (syn and syn.request) or (http and http.request) or http_request or request
                if req then
                    local resp = req({ Url = bustUrl, Method = "GET" })
                    return resp and resp.Body
                end
                return nil
            end)
            if ok and res and type(res) == "string" and #res > 100 then
                return res
            end
            return nil
        end
        local res = fetch(url)
        if res then
            local decodeOk, data = pcall(function()
                return self.Services.HttpService:JSONDecode(res)
            end)
            if decodeOk and type(data) == "table" then
                self:ApplyValuesData(data)
                self.ValuesSystem.LastFetch = os.clock()
                pcall(function()
                    local wf = writefile or (syn and syn.writefile)
                    if wf then
                        local filePath = self:GetValuesCacheFilePath()
                        wf(filePath, res)
                    end
                end)
            end
        end
    end)
end
function Hub:AttachItemValueBadge(slot, val)
    if not slot or not slot.Parent then return end
    if slot:FindFirstChildOfClass("UIGridLayout") or slot:FindFirstChildOfClass("UIListLayout") then
        return
    end
    if slot.Name == "Container" and slot.Parent and (slot.Parent.Name == "YourOffer" or slot.Parent.Name == "TheirOffer") then
        return
    end
    local badge = slot:FindFirstChild("ValueBadge")
    if not val or val == "" or val == 0 or val == "0" then
        if badge then badge.Visible = false end
        return
    end
    local numVal = (type(val) == "number") and val or tonumber(val)
    if numVal and numVal <= 0 then
        if badge then badge.Visible = false end
        return
    end
    if not badge then
        badge = Instance.new("Frame")
        badge.Name = "ValueBadge"
        badge.Position = UDim2.new(0, 4, 0, 4)
        badge.BackgroundColor3 = Color3.fromRGB(15, 17, 24)
        badge.BackgroundTransparency = 0.15
        badge.BorderSizePixel = 0
        badge.ZIndex = 9999
        badge.Parent = slot
        self:Corner(badge, 4)
        self:Stroke(badge, Color3.fromRGB(60, 72, 98), 1)
        local text = Instance.new("TextLabel")
        text.Name = "ValText"
        text.Size = UDim2.new(1, -4, 1, 0)
        text.Position = UDim2.new(0, 2, 0, 0)
        text.BackgroundTransparency = 1
        text.Font = Enum.Font.GothamBold
        text.TextSize = 9
        text.ZIndex = 10000
        text.Parent = badge
    end
    badge.Visible = true
    local text = badge:FindFirstChild("ValText")
    if text then
        local str
        if numVal then
            str = self:FormatNumber(numVal)
            text.TextColor3 = Color3.fromRGB(255, 215, 80) -- Gold for numeric currency
        else
            str = tostring(val)
            local cnt, tier, r = str:match("^x(%d+)%s*(T?%d*)%s*([%a]+)$")
            if cnt and r then
                local actualTier = (tier ~= "" and tier) or "T1"
                if not actualTier:lower():find("^t") then
                    actualTier = "T" .. actualTier
                end
                str = "x" .. cnt .. " " .. actualTier .. " " .. r
            end
            text.TextColor3 = Color3.fromRGB(255, 140, 140) -- Coral/Peach for tiered collectibles
        end
        text.Text = str
        local len = #str
        local w
        if len <= 4 then
            w = 26
        elseif len <= 8 then
            w = math.max(28, len * 7 + 8)
        else
            w = math.min(110, len * 5.8 + 10)
        end
        badge.Size = UDim2.new(0, math.floor(w), 0, 16)
    end
end
function Hub:FindInventoryGui()
    local lp = self.Services.Players.LocalPlayer
    local pg = lp and lp:FindFirstChild("PlayerGui")
    if not pg then return nil, nil end
    local mainGui = pg:FindFirstChild("MainGUI")
    local gameGui = mainGui and mainGui:FindFirstChild("Game")
    local inv = (gameGui and gameGui:FindFirstChild("Inventory")) or pg:FindFirstChild("Inventory", true)
    if not inv or not inv.Visible then return nil, nil end
    local weapons = inv:FindFirstChild("Main") and inv.Main:FindFirstChild("Weapons")
    if not weapons or not weapons.Visible then return inv, nil end
    local items = weapons:FindFirstChild("Items")
    local contWrapper = items and items:FindFirstChild("Container")
    return inv, contWrapper
end
function Hub:FindTradeGui()
    local lp = self.Services.Players.LocalPlayer
    local pg = lp and lp:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local mainGui = pg:FindFirstChild("MainGUI")
    local tradeGui = pg:FindFirstChild("TradeGUI") or (mainGui and mainGui:FindFirstChild("Trade", true))
    if not tradeGui then return nil end
    local isOpen = false
    if tradeGui:IsA("ScreenGui") then
        isOpen = tradeGui.Enabled
    elseif tradeGui:IsA("GuiObject") then
        isOpen = tradeGui.Visible
        local cur = tradeGui.Parent
        while cur and cur:IsA("GuiObject") do
            if not cur.Visible then
                isOpen = false
                break
            end
            cur = cur.Parent
        end
    end
    if not isOpen then return nil end
    return tradeGui
end
function Hub:CleanInventoryBadges()
    local lp = self.Services.Players.LocalPlayer
    local pg = lp and lp:FindFirstChild("PlayerGui")
    if not pg then return end
    for _, desc in ipairs(pg:GetDescendants()) do
        if desc.Name == "ValueBadge" or desc.Name == "MM2TotalValueHeader" or desc.Name == "TotalValHeader" then
            pcall(function() desc:Destroy() end)
        end
    end
end
function Hub:CleanTradePanel()
    local lp = self.Services.Players.LocalPlayer
    local pg = lp and lp:FindFirstChild("PlayerGui")
    if pg then
        for _, desc in ipairs(pg:GetDescendants()) do
            if desc.Name == "TradeStatusPanel" or desc.Name == "SV_Total" or desc.Name == "OfferValLabel" or desc.Name == "TradeDiffLabel" then
                pcall(function() desc:Destroy() end)
            end
        end
    end
    if self.State.Gui then
        local pnl = self.State.Gui:FindFirstChild("TradeStatusPanel")
        if pnl then pcall(function() pnl:Destroy() end) end
    end
end
function Hub:CleanValuesBadges()
    self:CleanInventoryBadges()
    self:CleanTradePanel()
end
function Hub:ProcessInventoryWindow(inv)
    if not inv or not inv:IsA("GuiObject") or not inv.Visible then
        local old = inv and inv:FindFirstChild("MM2TotalValueHeader", true)
        if old then old.Visible = false end
        return
    end
    local mainFrame = inv:FindFirstChild("Main")
    local weapons = mainFrame and mainFrame:FindFirstChild("Weapons")
    if inv.Name == "ViewProfile" and (not weapons or not weapons.Visible) then
        local profileTab = mainFrame and mainFrame:FindFirstChild("Profile")
        if profileTab and profileTab.Visible then
            local showcase = profileTab:FindFirstChild("ItemShowcase", true)
            local cont = showcase and showcase:FindFirstChild("Container")
            if cont then
                for _, desc in ipairs(cont:GetDescendants()) do
                    if desc.Name == "NewItem" then
                        local details = self:GetSlotItemDetails(desc)
                        local itemName = (details and details.itemName) or self:GetItemNameFromSlot(desc)
                        if itemName and itemName ~= "" and itemName ~= "Loading..." then
                            local val = self:GetSkinValue(itemName, details)
                            self:AttachItemValueBadge(desc, val)
                        end
                    end
                end
            end
        end
        local old = inv:FindFirstChild("MM2TotalValueHeader", true)
        if old then old.Visible = false end
        return
    end
    if not weapons or not weapons.Visible then
        local old = inv:FindFirstChild("MM2TotalValueHeader", true)
        if old then old.Visible = false end
        return
    end
    local itemsFrame = weapons:FindFirstChild("Items")
    if not itemsFrame then return end
    local seenSlots = {}
    local totalVal = 0
    local totalItems = 0
    for _, desc in ipairs(itemsFrame:GetDescendants()) do
        if desc.Name == "NewItem" and not seenSlots[desc] then
            seenSlots[desc] = true
            local details = self:GetSlotItemDetails(desc)
            local itemName = (details and details.itemName) or self:GetItemNameFromSlot(desc)
            if itemName and itemName ~= "" and itemName ~= "Loading..." then
                local amountLbl = desc:FindFirstChild("Container") and desc.Container:FindFirstChild("Amount")
                local amtText = amountLbl and amountLbl.Text or ""
                local qty = tonumber(amtText:match("(%d+)")) or 1
                local val = self:GetSkinValue(itemName, details)
                self:AttachItemValueBadge(desc, val)
                local numVal = (type(val) == "number") and val or tonumber(val)
                if numVal and numVal > 0 then
                    totalVal = totalVal + (numVal * qty)
                    totalItems = totalItems + qty
                end
            end
        end
    end
    local header = weapons:FindFirstChild("MM2TotalValueHeader")
    if not header then
        local inTabs = weapons:FindFirstChild("MM2TotalValueHeader", true)
        if inTabs and inTabs.Parent ~= weapons then inTabs:Destroy() end
        header = Instance.new("Frame")
        header.Name = "MM2TotalValueHeader"
        header.Size = UDim2.new(0, 115, 0, 24)
        header.Position = UDim2.new(1, -125, 0, 8)
        header.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
        header.BackgroundTransparency = 0.15
        header.ZIndex = 9999
        header.Parent = weapons
        self:Corner(header, 5)
        self:Stroke(header, Color3.fromRGB(55, 65, 90), 1)
        local txt = Instance.new("TextLabel")
        txt.Name = "TotalText"
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Font = Enum.Font.GothamBold
        txt.TextColor3 = Color3.fromRGB(255, 215, 80)
        txt.TextSize = 11
        txt.ZIndex = 10000
        txt.Parent = header
    end
    header.Visible = true
    local txt = header:FindFirstChild("TotalText")
    if txt then
        txt.Text = "Total: " .. self:FormatNumber(totalVal)
    end
end
function Hub:UpdateInventoryValues()
    if not self.Config.Toggles.ShowSkinValues then return end
    local lp = self.Services.Players.LocalPlayer
    local pg = lp and lp:FindFirstChild("PlayerGui")
    if not pg then return end
    local mainGui = pg:FindFirstChild("MainGUI")
    local gameGui = mainGui and mainGui:FindFirstChild("Game")
    if not gameGui then return end

    local localInv = gameGui:FindFirstChild("Inventory")
    local viewProfile = gameGui:FindFirstChild("ViewProfile")
    local inv2 = gameGui:FindFirstChild("Inventory2")

    local anyInvVisible = (localInv and localInv.Visible) or (viewProfile and viewProfile.Visible) or (inv2 and inv2.Visible)
    if not anyInvVisible then return end

    if localInv and localInv.Visible then
        self:ProcessInventoryWindow(localInv)
    end
    if viewProfile and viewProfile.Visible then
        self:ProcessInventoryWindow(viewProfile)
    else
        local oldVp = viewProfile and viewProfile:FindFirstChild("MM2TotalValueHeader", true)
        if oldVp then oldVp.Visible = false end
    end
    if inv2 and inv2.Visible then
        self:ProcessInventoryWindow(inv2)
    else
        local oldInv2 = inv2 and inv2:FindFirstChild("MM2TotalValueHeader", true)
        if oldInv2 then oldInv2.Visible = false end
    end
end
function Hub:UpdateTradeValues()
    if not self.Config.Toggles.ShowSkinValues then return end
    local tradeGui = self:FindTradeGui()
    if not tradeGui then
        if self.State.Gui then
            local pnl = self.State.Gui:FindFirstChild("TradeStatusPanel")
            if pnl then pnl.Visible = false end
        end
        local lp = self.Services.Players.LocalPlayer
        local pg = lp and lp:FindFirstChild("PlayerGui")
        if pg then
            for _, pnl in ipairs(pg:GetDescendants()) do
                if pnl.Name == "TradeStatusPanel" or pnl.Name == "SV_Total" then
                    pnl.Visible = false
                end
            end
        end
        return
    end
    local container = tradeGui:FindFirstChild("Container") or tradeGui
    local trade = container:FindFirstChild("Trade", true) or container
    local yourOffer = trade:FindFirstChild("YourOffer", true) or trade:FindFirstChild("MyOffer", true)
    local theirOffer = trade:FindFirstChild("TheirOffer", true) or trade:FindFirstChild("OtherOffer", true)
    local function processOffer(offer)
        if not offer then return 0 end
        local offerVal = 0
        local cont = offer:FindFirstChild("Container")
        if cont then
            for _, bad in ipairs(cont:GetChildren()) do
                if bad.Name == "ValueBadge" or bad.Name == "SV_Value" then
                    pcall(function() bad:Destroy() end)
                end
            end
        end
        local slots = {}
        if cont then
            for i = 1, 12 do
                local card = cont:FindFirstChild("NewItem" .. i)
                if card then
                    slots[#slots + 1] = card
                end
            end
            if #slots == 0 then
                for _, ch in ipairs(cont:GetChildren()) do
                    if ch:IsA("GuiObject") and not ch:IsA("UILayout") and ch.Name ~= "ValueBadge" and ch.Name ~= "SV_Value" then
                        slots[#slots + 1] = ch
                    end
                end
            end
        end
        if #slots == 0 then
            for _, ch in ipairs(offer:GetChildren()) do
                if ch:IsA("GuiObject") and not ch:IsA("UILayout") and ch.Name ~= "Container" and ch.Name ~= "Title" and ch.Name ~= "Username" and ch.Name ~= "ValueBadge" and ch.Name ~= "SV_Total" then
                    slots[#slots + 1] = ch
                end
            end
        end
        for _, slot in ipairs(slots) do
            local badge = slot:FindFirstChild("ValueBadge")
            if slot.Visible then
                local details = self:GetSlotItemDetails(slot)
                local itemName = (details and details.itemName) or self:GetItemNameFromSlot(slot)
                if itemName and itemName ~= "" and itemName ~= "Loading..." and itemName ~= "..." then
                    local inner = slot:FindFirstChild("Container")
                    local amtLbl = (inner and inner:FindFirstChild("Amount")) or slot:FindFirstChild("Amount")
                    local amtText = amtLbl and amtLbl.Text or ""
                    local qty = tonumber(amtText:match("(%d+)")) or 1
                    local val = self:GetSkinValue(itemName, details)
                    self:AttachItemValueBadge(slot, val)
                    local numVal = (type(val) == "number") and val or tonumber(val)
                    if numVal and numVal > 0 then
                        offerVal = offerVal + (numVal * qty)
                    end
                else
                    if badge then badge.Visible = false end
                end
            else
                if badge then badge.Visible = false end
            end
        end
        local svTotal = offer:FindFirstChild("SV_Total")
        if offerVal > 0 then
            if not svTotal then
                svTotal = Instance.new("TextLabel")
                svTotal.Name = "SV_Total"
                svTotal.BackgroundTransparency = 1
                svTotal.BorderSizePixel = 0
                svTotal.Font = Enum.Font.GothamBold
                svTotal.TextColor3 = Color3.fromRGB(255, 215, 80)
                svTotal.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                svTotal.TextStrokeTransparency = 0.2
                svTotal.TextSize = 13
                svTotal.TextXAlignment = Enum.TextXAlignment.Left
                svTotal.ZIndex = 50
                svTotal.Parent = offer
            end
            local title = offer:FindFirstChild("Title")
            if title and title:IsA("TextLabel") and title.AbsoluteSize.X > 5 then
                local left = (title.AbsolutePosition.X - offer.AbsolutePosition.X) + title.TextBounds.X + 12
                svTotal.Position = UDim2.new(0, math.floor(left), title.Position.Y.Scale, title.Position.Y.Offset)
                svTotal.Size = UDim2.new(0.4, 0, 0, math.max(18, title.AbsoluteSize.Y))
            else
                svTotal.Position = UDim2.new(0.05, 0, 0, 8)
                svTotal.Size = UDim2.new(0.4, 0, 0, 20)
            end
            svTotal.Text = "Val: " .. self:FormatNumber(offerVal)
            svTotal.Visible = true
        else
            if svTotal then svTotal.Visible = false end
        end
        return offerVal
    end
    local yourVal = processOffer(yourOffer)
    local theirVal = processOffer(theirOffer)
    local tradeItems = container:FindFirstChild("Items", true)
    if tradeItems then
        for _, slot in ipairs(tradeItems:GetDescendants()) do
            if slot.Name == "NewItem" and slot:IsA("Frame") then
                local details = self:GetSlotItemDetails(slot)
                local itemName = (details and details.itemName) or self:GetItemNameFromSlot(slot)
                if itemName and itemName ~= "" and itemName ~= "Loading..." and itemName ~= "..." then
                    local val = self:GetSkinValue(itemName, details)
                    self:AttachItemValueBadge(slot, val)
                else
                    local badge = slot:FindFirstChild("ValueBadge")
                    if badge then badge.Visible = false end
                end
            end
        end
    end
    -- Clean up old floating TradeStatusPanel if it exists
    pcall(function()
        local safeParent = self.State.Gui or self:GetSafeParent()
        local oldPnl = safeParent and safeParent:FindFirstChild("TradeStatusPanel")
        if oldPnl then oldPnl:Destroy() end
        local lp = self.Services.Players.LocalPlayer
        local pg = lp and lp:FindFirstChild("PlayerGui")
        if pg then
            for _, pnl in ipairs(pg:GetDescendants()) do
                if pnl.Name == "TradeStatusPanel" then pnl:Destroy() end
            end
        end
    end)

    -- Display offer values directly on YourOffer and TheirOffer
    local function attachOfferVal(offerFrame, textStr)
        if not (offerFrame and offerFrame:IsA("GuiObject")) then return end
        local valLbl = offerFrame:FindFirstChild("OfferValLabel")
        if not valLbl then
            valLbl = Instance.new("TextLabel")
            valLbl.Name = "OfferValLabel"
            valLbl.BackgroundTransparency = 1
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextColor3 = Color3.fromRGB(255, 215, 80)
            valLbl.TextSize = 13
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.Position = UDim2.new(0, 0, 0, 5)
            valLbl.Size = UDim2.new(0.975, 0, 0, 24)
            valLbl.ZIndex = 50
            valLbl.Parent = offerFrame
        end
        valLbl.Text = textStr
        valLbl.Visible = true
    end

    attachOfferVal(yourOffer, "Даёшь: " .. self:FormatNumber(yourVal))
    attachOfferVal(theirOffer, "Даёт: " .. self:FormatNumber(theirVal))

    -- Display net diff (+ or -) directly on the Accept button
    local actions = container:FindFirstChild("Actions", true) or trade:FindFirstChild("Actions")
    local accept = actions and actions:FindFirstChild("Accept")
    if accept then
        local title = accept:FindFirstChild("Title")
        if title then
            title.Position = UDim2.new(0, 0, 0.26, 0)
            title.Size = UDim2.new(1, 0, 0.45, 0)
        end
        local dLbl = accept:FindFirstChild("TradeDiffLabel")
        if not dLbl then
            dLbl = Instance.new("TextLabel")
            dLbl.Name = "TradeDiffLabel"
            dLbl.BackgroundTransparency = 1
            dLbl.Font = Enum.Font.GothamBold
            dLbl.TextSize = 13
            dLbl.TextXAlignment = Enum.TextXAlignment.Center
            dLbl.Position = UDim2.new(0, 0, 0.68, 0)
            dLbl.Size = UDim2.new(1, 0, 0.3, 0)
            dLbl.ZIndex = 50
            dLbl.Parent = accept
        end
        local diff = theirVal - yourVal
        if diff > 0 then
            dLbl.Text = "+" .. self:FormatNumber(diff)
            dLbl.TextColor3 = Color3.fromRGB(0, 255, 120)
        elseif diff < 0 then
            dLbl.Text = tostring(self:FormatNumber(diff))
            dLbl.TextColor3 = Color3.fromRGB(255, 75, 75)
        else
            dLbl.Text = "0"
            dLbl.TextColor3 = Color3.fromRGB(200, 205, 220)
        end
        dLbl.Visible = true
    end
end
local skinPropNope = {
    Anchored = true, Massless = true, CanCollide = true, CanQuery = true, CanTouch = true,
    Locked = true, Size = true, MeshId = true, MeshSize = true, Part0 = true, Part1 = true,
    Playing = true, TimeLength = true, IsLoaded = true, IsPlaying = true,
}
local skinFxClasses = {
    Attachment = true, Sound = true, ParticleEmitter = true, Beam = true, Trail = true,
    Decal = true, Texture = true, Fire = true, Smoke = true, Sparkles = true,
    PointLight = true, SpotLight = true, SurfaceLight = true, Highlight = true,
}
local skinOnHandleClasses = { Attachment = true, Sound = true, Beam = true }
function Hub:DetectDevice()
    local uis = self.Services.UserInputService
    local cam = self.Services.Workspace.CurrentCamera
    local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
    local devType = "Desktop"
    local isTouch = uis.TouchEnabled
    if uis.TouchEnabled and not uis.KeyboardEnabled then
        local minDim = math.min(vp.X, vp.Y)
        local maxDim = math.max(vp.X, vp.Y)
        if minDim < 540 or maxDim < 860 then
            devType = "Mobile"
        else
            devType = "Tablet"
        end
    elseif uis.GamepadEnabled and not uis.KeyboardEnabled and not uis.MouseEnabled then
        devType = "Console"
    elseif uis.TouchEnabled and vp.X < 920 then
        devType = "Mobile"
    elseif uis.TouchEnabled and vp.X < 1200 then
        devType = "Tablet"
    else
        devType = "Desktop"
    end
    self.State.Device = {
        Type = devType,
        IsTouch = isTouch,
        Viewport = vp,
        IsMobile = (devType == "Mobile"),
        IsTablet = (devType == "Tablet"),
        IsConsole = (devType == "Console"),
        IsDesktop = (devType == "Desktop"),
    }
    return self.State.Device
end
function Hub:GetAdaptiveWindowSize()
    local dev = self.State.Device or self:DetectDevice()
    local cam = self.Services.Workspace.CurrentCamera
    local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
    if dev.IsMobile then
        local w = math.clamp(math.floor(vp.X * 0.94), 320, 560)
        local h = math.clamp(math.floor(vp.Y * 0.90), 280, 390)
        return UDim2.new(0, w, 0, h), UDim2.new(0, w + 30, 0, h + 30)
    elseif dev.IsTablet then
        local w = math.clamp(math.floor(vp.X * 0.85), 560, 680)
        local h = math.clamp(math.floor(vp.Y * 0.82), 380, 480)
        return UDim2.new(0, w, 0, h), UDim2.new(0, w + 40, 0, h + 40)
    else
        local w = math.min(720, math.floor(vp.X - 60))
        local h = math.min(500, math.floor(vp.Y - 60))
        return UDim2.new(0, w, 0, h), UDim2.new(0, w + 40, 0, h + 40)
    end
end
function Hub:UpdateLayoutForDevice()
    self:DetectDevice()
    local winSize, shadowSize = self:GetAdaptiveWindowSize()
    self.State.WindowSize = winSize
    if self.State.MainFrame and self.State.IsOpen then
        self:Tween(self.State.MainFrame, { Size = winSize }, 0.2)
    end
    if self.State.Shadow then
        self.State.Shadow.Size = shadowSize
    end
    self:UpdateSidePanelPosition()
end
function Hub:GetLogoAsset()
    local fileName = "Dynamic_logo.png"
    local rawUrl = "https://raw.githubusercontent.com/Lisi-prime/Dynamic-Hub/main/Dynamic_logo.png"

    if isfile and not isfile(fileName) then
        pcall(function()
            local data = game:HttpGet(rawUrl)
            if data and #data > 100 then
                writefile(fileName, data)
            end
        end)
    end

    if isfile and isfile(fileName) and getcustomasset then
        return getcustomasset(fileName)
    end
    return rawUrl
end

function Hub:Init()
    self:StopAutoFarmTween()
    local parentTarget = self:GetSafeParent()
    local old = parentTarget:FindFirstChild("Dynamic_Hub_MM2")
    if old then old:Destroy() end
    local lp = self.Services.Players.LocalPlayer
    if lp then
        local function bindDeathFling(c)
            if not c then return end
            local h = c:FindFirstChildOfClass("Humanoid") or c:WaitForChild("Humanoid", 2)
            if h then
                local conn
                conn = h.Died:Connect(function()
                    if conn then conn:Disconnect(); conn = nil end
                    if (self.Config.Toggles.AutoFarm or self.AutoFarm.IsActive) and self.Config.Toggles.AutoFarmFlingMurderOnDeath then
                        if not self.AutoFarm.DeathFlingTriggered then
                            self.AutoFarm.DeathFlingTriggered = true
                            self:FlingMurdererOnDeath(c)
                        end
                    end
                end)
                table.insert(self.State.Connections, conn)
            end
        end
        bindDeathFling(lp.Character)
        local charConn = lp.CharacterAdded:Connect(function(c)
            self.AutoFarm.DeathFlingTriggered = false
            task.wait(0.2)
            self:StopAutoFarmTween()
            bindDeathFling(c)
        end)
        table.insert(self.State.Connections, charConn)
    end
    local screen = Instance.new("ScreenGui")
    screen.Name = "Dynamic_Hub_MM2"
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = parentTarget
    self.State.Gui = screen

    local logoAsset = self:GetLogoAsset()
    task.spawn(function()
        pcall(function()
            local pImg = Instance.new("ImageLabel")
            pImg.Image = logoAsset
            self.Services.ContentProvider:PreloadAsync({ pImg })
            pImg:Destroy()
        end)
    end)
    local watermark = Instance.new("TextButton")
    watermark.Name = "DynamicWatermark"
    watermark.AnchorPoint = Vector2.new(0.5, 0)
    watermark.Position = UDim2.new(0.5, 0, 0, 12)
    watermark.Size = UDim2.new(0, 0, 0, 30)
    watermark.AutomaticSize = Enum.AutomaticSize.X
    watermark.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
    watermark.BackgroundTransparency = 0
    watermark.BorderSizePixel = 0
    watermark.Text = ""
    watermark.AutoButtonColor = false
    watermark.Visible = false -- Kept hidden during intro; shown when intro finishes
    watermark.ZIndex = 50
    watermark.Parent = screen
    self.State.Watermark = watermark
    local wmScale = Instance.new("UIScale")
    wmScale.Scale = 1.0
    wmScale.Parent = watermark
    self:Corner(watermark, 15)
    self:Stroke(watermark, Color3.fromRGB(34, 34, 46), 1)
    local wmLayout = Instance.new("UIListLayout")
    wmLayout.FillDirection = Enum.FillDirection.Horizontal
    wmLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    wmLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    wmLayout.SortOrder = Enum.SortOrder.LayoutOrder
    wmLayout.Padding = UDim.new(0, 9)
    wmLayout.Parent = watermark
    local wmPad = Instance.new("UIPadding")
    wmPad.PaddingLeft = UDim.new(0, 14)
    wmPad.PaddingRight = UDim.new(0, 14)
    wmPad.Parent = watermark
    local function makeDivider(order)
        local div = Instance.new("Frame")
        div.Name = "Div" .. order
        div.Size = UDim2.new(0, 1, 0, 13)
        div.BackgroundColor3 = Color3.fromRGB(48, 48, 62)
        div.BackgroundTransparency = 0.5
        div.BorderSizePixel = 0
        div.LayoutOrder = order
        div.Parent = watermark
        return div
    end
    local brandGroup = Instance.new("Frame")
    brandGroup.Name = "BrandGroup"
    brandGroup.Size = UDim2.new(0, 0, 1, 0)
    brandGroup.AutomaticSize = Enum.AutomaticSize.X
    brandGroup.BackgroundTransparency = 1
    brandGroup.LayoutOrder = 1
    brandGroup.Parent = watermark

    local brandLayout = Instance.new("UIListLayout")
    brandLayout.FillDirection = Enum.FillDirection.Horizontal
    brandLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    brandLayout.SortOrder = Enum.SortOrder.LayoutOrder
    brandLayout.Padding = UDim.new(0, 6)
    brandLayout.Parent = brandGroup

    local wmLogo = Instance.new("ImageLabel")
    wmLogo.Name = "WatermarkLogo"
    wmLogo.Size = UDim2.new(0, 16, 0, 16)
    wmLogo.BackgroundTransparency = 1
    wmLogo.Image = logoAsset
    wmLogo.ScaleType = Enum.ScaleType.Fit
    wmLogo.LayoutOrder = 1
    wmLogo.Parent = brandGroup

    local brandLbl = Instance.new("TextLabel")
    brandLbl.Name = "BrandLabel"
    brandLbl.Text = "DYNAMIC"
    brandLbl.Font = Enum.Font.GothamBold
    brandLbl.TextSize = 13
    brandLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    brandLbl.Size = UDim2.new(0, 0, 1, 0)
    brandLbl.AutomaticSize = Enum.AutomaticSize.X
    brandLbl.BackgroundTransparency = 1
    brandLbl.LayoutOrder = 2
    brandLbl.Parent = brandGroup

    makeDivider(2)
    local fpsFrame = Instance.new("Frame")
    fpsFrame.Name = "FPS"
    fpsFrame.BackgroundTransparency = 1
    fpsFrame.Size = UDim2.new(0, 0, 1, 0)
    fpsFrame.AutomaticSize = Enum.AutomaticSize.X
    fpsFrame.LayoutOrder = 3
    fpsFrame.Parent = watermark
    local fpsLayout = Instance.new("UIListLayout")
    fpsLayout.FillDirection = Enum.FillDirection.Horizontal
    fpsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    fpsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    fpsLayout.Padding = UDim.new(0, 5)
    fpsLayout.Parent = fpsFrame
    local fpsIcon = Instance.new("ImageLabel")
    fpsIcon.Name = "Icon"
    fpsIcon.Size = UDim2.new(0, 14, 0, 14)
    fpsIcon.BackgroundTransparency = 1
    fpsIcon.Image = "rbxassetid://10734934585"
    fpsIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    fpsIcon.LayoutOrder = 1
    fpsIcon.Parent = fpsFrame
    local initFps = 0
    pcall(function() initFps = math.floor(workspace:GetRealPhysicsFPS()) end)
    if initFps <= 0 then initFps = 60 end

    local fpsLbl = Instance.new("TextLabel")
    fpsLbl.Name = "FPSLabel"
    fpsLbl.Text = string.format("%d fps", initFps)
    fpsLbl.Font = Enum.Font.GothamMedium
    fpsLbl.TextSize = 12
    fpsLbl.TextColor3 = Color3.fromRGB(205, 210, 220)
    fpsLbl.Size = UDim2.new(0, 0, 1, 0)
    fpsLbl.AutomaticSize = Enum.AutomaticSize.X
    fpsLbl.BackgroundTransparency = 1
    fpsLbl.LayoutOrder = 2
    fpsLbl.Parent = fpsFrame
    self.State.WatermarkFPSLabel = fpsLbl
    makeDivider(4)
    local pingFrame = Instance.new("Frame")
    pingFrame.Name = "Ping"
    pingFrame.BackgroundTransparency = 1
    pingFrame.Size = UDim2.new(0, 0, 1, 0)
    pingFrame.AutomaticSize = Enum.AutomaticSize.X
    pingFrame.LayoutOrder = 5
    pingFrame.Parent = watermark
    local pingLayout = Instance.new("UIListLayout")
    pingLayout.FillDirection = Enum.FillDirection.Horizontal
    pingLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    pingLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pingLayout.Padding = UDim.new(0, 5)
    pingLayout.Parent = pingFrame
    local pingIcon = Instance.new("ImageLabel")
    pingIcon.Name = "Icon"
    pingIcon.Size = UDim2.new(0, 14, 0, 14)
    pingIcon.BackgroundTransparency = 1
    pingIcon.Image = "rbxassetid://7733799969"
    pingIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    pingIcon.LayoutOrder = 1
    pingIcon.Parent = pingFrame

    local initPing = 0
    pcall(function()
        local lp = self.Services.Players.LocalPlayer
        if lp and lp.GetNetworkPing then
            initPing = math.floor(lp:GetNetworkPing() * 1000)
        end
    end)
    if initPing <= 0 then
        pcall(function()
            local stats = game:GetService("Stats")
            local perf = stats:FindFirstChild("PerformanceStats")
            local pingItem = perf and perf:FindFirstChild("Ping")
            if pingItem then
                initPing = math.floor(pingItem:GetValue())
            end
        end)
    end
    if initPing <= 0 then
        pcall(function()
            local stats = game:GetService("Stats")
            local net = stats:FindFirstChild("Network")
            local ssi = net and net:FindFirstChild("ServerStatsItem")
            local dp = ssi and ssi:FindFirstChild("Data Ping")
            if dp then
                initPing = math.floor(dp:GetValue())
            end
        end)
    end

    local pingLbl = Instance.new("TextLabel")
    pingLbl.Name = "PingLabel"
    pingLbl.Text = string.format("%d ms", initPing)
    pingLbl.Font = Enum.Font.GothamMedium
    pingLbl.TextSize = 12
    pingLbl.TextColor3 = Color3.fromRGB(205, 210, 220)
    pingLbl.Size = UDim2.new(0, 0, 1, 0)
    pingLbl.AutomaticSize = Enum.AutomaticSize.X
    pingLbl.BackgroundTransparency = 1
    pingLbl.LayoutOrder = 2
    pingLbl.Parent = pingFrame
    self.State.WatermarkPingLabel = pingLbl
    self.State.WatermarkLabel = fpsLbl
    local wmDragging = false
    local wmDragStart = Vector3.new(0, 0, 0)
    local wmStartPos = UDim2.new()
    local wmHasMoved = false
    local isHovered = false
    watermark.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            wmDragging = true
            wmDragStart = input.Position
            wmStartPos = watermark.Position
            wmHasMoved = false
            self.Services.TweenService:Create(wmScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Scale = 0.98
            }):Play()
            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    wmDragging = false
                    if conn then
                        conn:Disconnect()
                    end
                    self.Services.TweenService:Create(wmScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Scale = isHovered and 1.05 or 1.0
                    }):Play()
                    if not wmHasMoved then
                        self:ToggleMenu()
                    end
                end
            end)
        end
    end)
    local dragMoveConn = self.Services.UserInputService.InputChanged:Connect(function(input)
        if wmDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - wmDragStart
            if delta.Magnitude > 4 then
                wmHasMoved = true
            end
            if wmHasMoved then
                watermark.Position = UDim2.new(
                    wmStartPos.X.Scale,
                    wmStartPos.X.Offset + delta.X,
                    wmStartPos.Y.Scale,
                    wmStartPos.Y.Offset + delta.Y
                )
            end
        end
    end)
    table.insert(self.State.Connections, dragMoveConn)
    watermark.MouseEnter:Connect(function()
        isHovered = true
        if not wmDragging then
            self.Services.TweenService:Create(wmScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Scale = 1.05
            }):Play()
        end
    end)
    watermark.MouseLeave:Connect(function()
        isHovered = false
        if not wmDragging then
            self.Services.TweenService:Create(wmScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Scale = 1.0
            }):Play()
        end
    end)
    self:DetectDevice()
    local winSize, shadowSize = self:GetAdaptiveWindowSize()
    self.State.WindowSize = winSize
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = shadowSize
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.35
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Visible = false
    shadow.Parent = screen
    self.State.Shadow = shadow
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.Size = self.State.WindowSize
    main.BackgroundColor3 = self.Theme.MainBg
    main.BorderSizePixel = 0
    main.ClipsDescendants = false
    main.Visible = false
    main.Parent = screen
    self.State.MainFrame = main
    self:Corner(main, 14)
    self:Stroke(main, self.Theme.Border, 1)

    -- TopBar (Header)
    local topbar = Instance.new("Frame")
    topbar.Name = "TopBar"
    topbar.Size = UDim2.new(1, 0, 0, 48)
    topbar.BackgroundColor3 = self.Theme.TopBarBg
    topbar.BorderSizePixel = 0
    topbar.ZIndex = 20
    topbar.Parent = main
    self.State.TopBar = topbar
    self:Corner(topbar, 14)

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
    topDivider.BackgroundColor3 = self.Theme.Border
    topDivider.BorderSizePixel = 0
    topDivider.ZIndex = 21
    topDivider.Parent = topbar

    -- LEFT HEADER: TopBar Logo + Title "DYNAMIC"
    local topLogo = Instance.new("ImageLabel")
    topLogo.Name = "TopBarLogo"
    topLogo.AnchorPoint = Vector2.new(0, 0.5)
    topLogo.Position = UDim2.new(0, 12, 0.5, 0)
    topLogo.Size = UDim2.new(0, 22, 0, 22)
    topLogo.BackgroundTransparency = 1
    topLogo.Image = logoAsset
    topLogo.ScaleType = Enum.ScaleType.Fit
    topLogo.ZIndex = 23
    topLogo.Parent = topbar

    local logoShadow = Instance.new("TextLabel")
    logoShadow.Name = "LogoShadow"
    logoShadow.Position = UDim2.new(0, 40, 0.5, 1)
    logoShadow.AnchorPoint = Vector2.new(0, 0.5)
    logoShadow.Size = UDim2.new(0, 130, 0, 26)
    logoShadow.BackgroundTransparency = 1
    logoShadow.Font = Enum.Font.GothamBold
    logoShadow.Text = "DYNAMIC"
    logoShadow.TextColor3 = self.Theme.Accent
    logoShadow.TextTransparency = 0.5
    logoShadow.TextSize = 17
    logoShadow.TextXAlignment = Enum.TextXAlignment.Left
    logoShadow.ZIndex = 22
    logoShadow.Parent = topbar

    local logoLabel = Instance.new("TextLabel")
    logoLabel.Name = "LogoLabel"
    logoLabel.Position = UDim2.new(0, 40, 0.5, 0)
    logoLabel.AnchorPoint = Vector2.new(0, 0.5)
    logoLabel.Size = UDim2.new(0, 130, 0, 26)
    logoLabel.BackgroundTransparency = 1
    logoLabel.Font = Enum.Font.GothamBold
    logoLabel.Text = "DYNAMIC"
    logoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoLabel.TextSize = 17
    logoLabel.TextXAlignment = Enum.TextXAlignment.Left
    logoLabel.ZIndex = 23
    logoLabel.Parent = topbar

    local logoGlow = Instance.new("UIStroke")
    logoGlow.Color = Color3.fromRGB(255, 255, 255)
    logoGlow.Transparency = 0.65
    logoGlow.Thickness = 1.2
    logoGlow.Parent = logoLabel

    -- LEFT HEADER: Config selector pill next to title
    self.State.CurrentConfigName = self.State.CurrentConfigName or "Default"
    local cfgPill = Instance.new("TextButton")
    cfgPill.Name = "ConfigPill"
    cfgPill.Position = UDim2.new(0, 158, 0.5, 0)
    cfgPill.AnchorPoint = Vector2.new(0, 0.5)
    cfgPill.Size = UDim2.new(0, 115, 0, 26)
    cfgPill.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    cfgPill.AutoButtonColor = false
    cfgPill.Text = ""
    cfgPill.ZIndex = 23
    cfgPill.Parent = topbar
    self:Corner(cfgPill, 7)
    local cfgPillStroke = self:Stroke(cfgPill, Color3.fromRGB(42, 42, 58), 1)

    local cfgIcon = Instance.new("ImageLabel")
    cfgIcon.Name = "ConfigIcon"
    cfgIcon.Size = UDim2.new(0, 13, 0, 13)
    cfgIcon.Position = UDim2.new(0, 7, 0.5, -6.5)
    cfgIcon.BackgroundTransparency = 1
    cfgIcon.Image = Icons.Config
    cfgIcon.ImageColor3 = Color3.fromRGB(180, 185, 205)
    cfgIcon.ZIndex = 24
    cfgIcon.Parent = cfgPill

    local cfgLabel = Instance.new("TextLabel")
    cfgLabel.Name = "CurrentConfigLabel"
    cfgLabel.Position = UDim2.new(0, 24, 0, 0)
    cfgLabel.Size = UDim2.new(1, -40, 1, 0)
    cfgLabel.BackgroundTransparency = 1
    cfgLabel.Font = Enum.Font.GothamMedium
    cfgLabel.Text = self.State.CurrentConfigName
    cfgLabel.TextColor3 = Color3.fromRGB(225, 230, 240)
    cfgLabel.TextSize = 11
    cfgLabel.TextXAlignment = Enum.TextXAlignment.Left
    cfgLabel.TextTruncate = Enum.TextTruncate.AtEnd
    cfgLabel.ZIndex = 24
    cfgLabel.Parent = cfgPill
    self.State.CurrentConfigLabel = cfgLabel

    local cfgArrow = Instance.new("TextLabel")
    cfgArrow.Name = "ArrowLabel"
    cfgArrow.Position = UDim2.new(1, -15, 0, 0)
    cfgArrow.Size = UDim2.new(0, 12, 1, 0)
    cfgArrow.BackgroundTransparency = 1
    cfgArrow.Font = Enum.Font.GothamBold
    cfgArrow.Text = "▼"
    cfgArrow.TextColor3 = Color3.fromRGB(150, 155, 175)
    cfgArrow.TextSize = 9
    cfgArrow.ZIndex = 24
    cfgArrow.Parent = cfgPill

    cfgPill.MouseEnter:Connect(function()
        self:Tween(cfgPill, { BackgroundColor3 = Color3.fromRGB(30, 30, 42) }, 0.15)
        self:Tween(cfgPillStroke, { Color = self.Theme.Accent }, 0.15)
    end)
    cfgPill.MouseLeave:Connect(function()
        self:Tween(cfgPill, { BackgroundColor3 = Color3.fromRGB(24, 24, 32) }, 0.15)
        self:Tween(cfgPillStroke, { Color = Color3.fromRGB(42, 42, 58) }, 0.15)
    end)

    -- Config Dropdown List
    local cfgDropdown = Instance.new("Frame")
    cfgDropdown.Name = "ConfigDropdown"
    cfgDropdown.Position = UDim2.new(0, 158, 0, 50)
    cfgDropdown.Size = UDim2.new(0, 130, 0, 120)
    cfgDropdown.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    cfgDropdown.BorderSizePixel = 0
    cfgDropdown.ZIndex = 80
    cfgDropdown.Visible = false
    cfgDropdown.Parent = main
    self:Corner(cfgDropdown, 8)
    self:Stroke(cfgDropdown, Color3.fromRGB(45, 45, 62), 1)

    local cfgDropShadow = Instance.new("ImageLabel")
    cfgDropShadow.Name = "DropdownShadow"
    cfgDropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    cfgDropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    cfgDropShadow.Size = UDim2.new(1, 20, 1, 20)
    cfgDropShadow.BackgroundTransparency = 1
    cfgDropShadow.Image = "rbxassetid://6014261993"
    cfgDropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    cfgDropShadow.ImageTransparency = 0.4
    cfgDropShadow.ScaleType = Enum.ScaleType.Slice
    cfgDropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    cfgDropShadow.ZIndex = 79
    cfgDropShadow.Parent = cfgDropdown

    local cfgScroll = Instance.new("ScrollingFrame")
    cfgScroll.Name = "ConfigsList"
    cfgScroll.Position = UDim2.new(0, 2, 0, 2)
    cfgScroll.Size = UDim2.new(1, -4, 1, -4)
    cfgScroll.BackgroundTransparency = 1
    cfgScroll.BorderSizePixel = 0
    cfgScroll.ScrollBarThickness = 3
    cfgScroll.ScrollBarImageColor3 = self.Theme.Accent
    cfgScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    cfgScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    cfgScroll.ZIndex = 81
    cfgScroll.Parent = cfgDropdown

    local cfgScrollPad = Instance.new("UIPadding")
    cfgScrollPad.PaddingTop = UDim.new(0, 4)
    cfgScrollPad.PaddingBottom = UDim.new(0, 4)
    cfgScrollPad.PaddingLeft = UDim.new(0, 4)
    cfgScrollPad.PaddingRight = UDim.new(0, 4)
    cfgScrollPad.Parent = cfgScroll

    local cfgLayout = Instance.new("UIListLayout")
    cfgLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    cfgLayout.Padding = UDim.new(0, 4)
    cfgLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cfgLayout.Parent = cfgScroll

    local function refreshTopConfigDropdown()
        for _, ch in ipairs(cfgScroll:GetChildren()) do
            if ch:IsA("TextButton") or ch:IsA("TextLabel") then
                ch:Destroy()
            end
        end
        local configs = self:GetConfigsList()
        local allItems = {}
        for _, c in ipairs(configs) do
            if c:lower() ~= "default" then
                table.insert(allItems, c)
            end
        end

        cfgDropdown.Size = UDim2.new(0, 140, 0, 140)

        if #allItems == 0 then
            local emptyLbl = Instance.new("TextLabel")
            emptyLbl.Size = UDim2.new(1, -8, 0, 24)
            emptyLbl.BackgroundTransparency = 1
            emptyLbl.Font = Enum.Font.GothamMedium
            emptyLbl.Text = "No saved configs"
            emptyLbl.TextColor3 = Color3.fromRGB(120, 125, 140)
            emptyLbl.TextSize = 10
            emptyLbl.ZIndex = 82
            emptyLbl.Parent = cfgScroll
            return
        end

        for idx, cName in ipairs(allItems) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Name = "CfgItem_" .. idx
            itemBtn.Size = UDim2.new(1, -6, 0, 24)
            local isCur = (cfgLabel.Text == cName)
            itemBtn.BackgroundColor3 = isCur and Color3.fromRGB(34, 34, 48) or Color3.fromRGB(22, 22, 30)
            itemBtn.Text = ""
            itemBtn.AutoButtonColor = false
            itemBtn.ZIndex = 82
            itemBtn.Parent = cfgScroll
            self:Corner(itemBtn, 6)

            local itemStroke = self:Stroke(itemBtn, isCur and self.Theme.Accent or Color3.fromRGB(34, 34, 46), 1)

            local itemLbl = Instance.new("TextLabel")
            itemLbl.Position = UDim2.new(0, 8, 0, 0)
            itemLbl.Size = UDim2.new(1, -12, 1, 0)
            itemLbl.BackgroundTransparency = 1
            itemLbl.Font = isCur and Enum.Font.GothamBold or Enum.Font.GothamMedium
            itemLbl.Text = cName
            itemLbl.TextColor3 = isCur and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(175, 180, 195)
            itemLbl.TextSize = 10
            itemLbl.TextXAlignment = Enum.TextXAlignment.Left
            itemLbl.TextTruncate = Enum.TextTruncate.AtEnd
            itemLbl.ZIndex = 83
            itemLbl.Parent = itemBtn

            itemBtn.MouseEnter:Connect(function()
                if cfgLabel.Text ~= cName then
                    self:Tween(itemBtn, { BackgroundColor3 = Color3.fromRGB(28, 28, 38) }, 0.15)
                end
            end)
            itemBtn.MouseLeave:Connect(function()
                if cfgLabel.Text ~= cName then
                    self:Tween(itemBtn, { BackgroundColor3 = Color3.fromRGB(22, 22, 30) }, 0.15)
                end
            end)
            itemBtn.MouseButton1Click:Connect(function()
                cfgLabel.Text = cName
                self.State.CurrentConfigName = cName
                cfgDropdown.Visible = false
                self:LoadConfig(cName)
            end)
        end
    end

    cfgPill.MouseButton1Click:Connect(function()
        local willOpen = not cfgDropdown.Visible
        if willOpen then
            if self.State.SearchDropdown then
                self.State.SearchDropdown.Visible = false
            end
            refreshTopConfigDropdown()
        end
        cfgDropdown.Visible = willOpen
    end)

    -- RIGHT HEADER: Close button [X]
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -12, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    closeBtn.Image = Icons.Close
    closeBtn.ImageColor3 = self.Theme.TextDim
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 23
    closeBtn.Parent = topbar
    self:Corner(closeBtn, 7)
    self:Stroke(closeBtn, self.Theme.Border, 1)

    closeBtn.MouseEnter:Connect(function()
        self:Tween(closeBtn, { BackgroundColor3 = Color3.fromRGB(220, 50, 70), ImageColor3 = Color3.fromRGB(255, 255, 255) }, 0.2)
    end)
    closeBtn.MouseLeave:Connect(function()
        self:Tween(closeBtn, { BackgroundColor3 = Color3.fromRGB(24, 24, 32), ImageColor3 = self.Theme.TextDim }, 0.2)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        self:ToggleMenu(false)
    end)

    -- RIGHT HEADER: Search Box (Immediately left of Close button, compact)
    local searchFrame = Instance.new("Frame")
    searchFrame.Name = "SearchFrame"
    searchFrame.Position = UDim2.new(1, -44, 0.5, 0)
    searchFrame.AnchorPoint = Vector2.new(1, 0.5)
    searchFrame.Size = UDim2.new(0, 135, 0, 24)
    searchFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    searchFrame.BorderSizePixel = 0
    searchFrame.ZIndex = 23
    searchFrame.Parent = topbar
    self:Corner(searchFrame, 6)
    self:Stroke(searchFrame, Color3.fromRGB(38, 38, 52), 1)

    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Name = "SearchIcon"
    searchIcon.Position = UDim2.new(0, 7, 0.5, -5.5)
    searchIcon.Size = UDim2.new(0, 11, 0, 11)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = Icons.Search
    searchIcon.ImageColor3 = self.Theme.TextDim
    searchIcon.ZIndex = 24
    searchIcon.Parent = searchFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Position = UDim2.new(0, 23, 0, 0)
    searchBox.Size = UDim2.new(1, -27, 1, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.Gotham
    searchBox.PlaceholderText = "Search..."
    searchBox.PlaceholderColor3 = self.Theme.TextMuted
    searchBox.Text = ""
    searchBox.TextColor3 = self.Theme.TextPrimary
    searchBox.TextSize = 10
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.ZIndex = 24
    searchBox.Parent = searchFrame
    self.State.SearchBox = searchBox

    -- Search Dropdown (Aligned right below SearchFrame)
    local searchDropdown = Instance.new("Frame")
    searchDropdown.Name = "SearchDropdown"
    searchDropdown.Position = UDim2.new(1, -179, 0, 48)
    searchDropdown.Size = UDim2.new(0, 135, 0, 200)
    searchDropdown.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    searchDropdown.BorderSizePixel = 0
    searchDropdown.ZIndex = 80
    searchDropdown.Visible = false
    searchDropdown.Parent = main
    self:Corner(searchDropdown, 8)
    self:Stroke(searchDropdown, self.Theme.Border, 1)
    self.State.SearchDropdown = searchDropdown

    local searchDropShadow = Instance.new("ImageLabel")
    searchDropShadow.Name = "DropdownShadow"
    searchDropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    searchDropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    searchDropShadow.Size = UDim2.new(1, 24, 1, 24)
    searchDropShadow.BackgroundTransparency = 1
    searchDropShadow.Image = "rbxassetid://6014261993"
    searchDropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    searchDropShadow.ImageTransparency = 0.4
    searchDropShadow.ScaleType = Enum.ScaleType.Slice
    searchDropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    searchDropShadow.ZIndex = 79
    searchDropShadow.Parent = searchDropdown

    local searchHeader = Instance.new("Frame")
    searchHeader.Name = "SearchHeader"
    searchHeader.Size = UDim2.new(1, 0, 0, 26)
    searchHeader.BackgroundTransparency = 1
    searchHeader.ZIndex = 81
    searchHeader.Parent = searchDropdown

    local searchHeaderLbl = Instance.new("TextLabel")
    searchHeaderLbl.Position = UDim2.new(0, 10, 0, 0)
    searchHeaderLbl.Size = UDim2.new(1, -20, 1, 0)
    searchHeaderLbl.BackgroundTransparency = 1
    searchHeaderLbl.Font = Enum.Font.GothamMedium
    searchHeaderLbl.Text = "Search Results (All Tabs)"
    searchHeaderLbl.TextColor3 = self.Theme.TextMuted
    searchHeaderLbl.TextSize = 10
    searchHeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    searchHeaderLbl.ZIndex = 81
    searchHeaderLbl.Parent = searchHeader

    local searchDivider = Instance.new("Frame")
    searchDivider.Size = UDim2.new(1, 0, 0, 1)
    searchDivider.Position = UDim2.new(0, 0, 1, -1)
    searchDivider.BackgroundColor3 = self.Theme.Border
    searchDivider.BorderSizePixel = 0
    searchDivider.ZIndex = 81
    searchDivider.Parent = searchHeader

    local searchScroll = Instance.new("ScrollingFrame")
    searchScroll.Name = "ResultsList"
    searchScroll.Position = UDim2.new(0, 4, 0, 28)
    searchScroll.Size = UDim2.new(1, -8, 1, -32)
    searchScroll.BackgroundTransparency = 1
    searchScroll.BorderSizePixel = 0
    searchScroll.ScrollBarThickness = 3
    searchScroll.ScrollBarImageColor3 = self.Theme.Accent
    searchScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    searchScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    searchScroll.ZIndex = 81
    searchScroll.Parent = searchDropdown

    local searchLayout = Instance.new("UIListLayout")
    searchLayout.Padding = UDim.new(0, 3)
    searchLayout.SortOrder = Enum.SortOrder.LayoutOrder
    searchLayout.Parent = searchScroll

    local function performGlobalSearch()
        local rawQ = searchBox.Text
        local q = rawQ:lower():gsub("^%s+", ""):gsub("%s+$", "")
        for _, ch in ipairs(searchScroll:GetChildren()) do
            if ch:IsA("TextButton") or ch:IsA("Frame") or ch:IsA("TextLabel") then
                ch:Destroy()
            end
        end
        if q == "" then
            searchDropdown.Visible = false
            for _, tabFrame in pairs(self.State.Tabs) do
                for _, obj in ipairs(tabFrame:GetDescendants()) do
                    if obj:IsA("Frame") and obj.Name:find("^Card_") then
                        obj.Visible = true
                    end
                end
            end
            return
        end
        local matches = {}
        local tabOrder = { "Combat", "Visuals", "Misc", "Skins", "Animation", "Maps", "Settings" }
        if q:find("avat") or q:find("rig") or q:find("3d") then
            table.insert(matches, 1, {
                Tab = "Visuals",
                Title = "3D Avatar Preview",
                Sub = "3D Rig Preview",
                IsSidePreview = true
            })
        end
        for _, tabName in ipairs(tabOrder) do
            local tabFrame = self.State.Tabs[tabName]
            if tabFrame then
                for _, obj in ipairs(tabFrame:GetDescendants()) do
                    if obj:IsA("Frame") and obj.Name:find("^Card_") then
                        local cardHeader = obj:FindFirstChild("CardHeader")
                        local titleObj = cardHeader and cardHeader:FindFirstChild("CardTitle")
                        local cardTitle = titleObj and titleObj:IsA("TextLabel") and titleObj.Text or obj.Name:gsub("^Card_", "")
                        local matched = false
                        local matchedSub = nil
                        local tabAliases = {
                            Combat = "silent aim hitbox shoot murderer sheriff target",
                            Visuals = "esp tracers chams crosshair box names",
                            Misc = "speed jump flight noclip supreme values autofarm fling",
                            Skins = "skins custom gun knife model pistol",
                            Animation = "catalog emotes dances anim",
                            Maps = "vote voting barn hospital map priority",
                            Settings = "configs binds colors ui theme watermark autoload",
                        }
                        local aliasText = tabAliases[tabName] or ""
                        if tabName:lower():find(q, 1, true) or aliasText:find(q, 1, true) then
                            matched = true
                        elseif cardTitle:lower():find(q, 1, true) then
                            matched = true
                        else
                            for _, desc in ipairs(obj:GetDescendants()) do
                                if desc:IsA("TextLabel") and desc ~= titleObj and desc.Text:lower():find(q, 1, true) then
                                    matched = true
                                    matchedSub = desc.Text
                                    break
                                end
                            end
                        end
                        if matched then
                            table.insert(matches, {
                                Tab = tabName,
                                Card = obj,
                                Title = cardTitle,
                                Sub = matchedSub
                            })
                        end
                        if tabName == self.Config.ActiveTab then
                            obj.Visible = matched
                        end
                    end
                end
            end
        end
        searchDropdown.Visible = true
        searchHeaderLbl.Text = "Results: " .. #matches .. " found"
        if #matches == 0 then
            local emptyLbl = Instance.new("TextLabel")
            emptyLbl.Size = UDim2.new(1, 0, 0, 36)
            emptyLbl.BackgroundTransparency = 1
            emptyLbl.Font = Enum.Font.Gotham
            emptyLbl.Text = "No modules found"
            emptyLbl.TextColor3 = self.Theme.TextMuted
            emptyLbl.TextSize = 11
            emptyLbl.ZIndex = 82
            emptyLbl.Parent = searchScroll
        else
            for idx, item in ipairs(matches) do
                local itemBtn = Instance.new("TextButton")
                itemBtn.Name = "Result_" .. idx
                itemBtn.Size = UDim2.new(1, 0, 0, 30)
                itemBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
                itemBtn.BorderSizePixel = 0
                itemBtn.Text = ""
                itemBtn.AutoButtonColor = false
                itemBtn.ZIndex = 82
                itemBtn.Parent = searchScroll
                self:Corner(itemBtn, 6)

                local badge = Instance.new("Frame")
                badge.Size = UDim2.new(0, 48, 0, 16)
                badge.Position = UDim2.new(0, 6, 0.5, -8)
                badge.BackgroundColor3 = Color3.fromRGB(38, 38, 50)
                badge.BorderSizePixel = 0
                badge.ZIndex = 83
                badge.Parent = itemBtn
                self:Corner(badge, 4)

                local badgeLbl = Instance.new("TextLabel")
                badgeLbl.Size = UDim2.new(1, 0, 1, 0)
                badgeLbl.BackgroundTransparency = 1
                badgeLbl.Font = Enum.Font.GothamBold
                badgeLbl.Text = item.IsSidePreview and "Avatar" or item.Tab
                badgeLbl.TextColor3 = self.Theme.Accent
                badgeLbl.TextSize = 9
                badgeLbl.ZIndex = 84
                badgeLbl.Parent = badge

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Position = UDim2.new(0, 58, 0, 0)
                titleLbl.Size = UDim2.new(1, -62, 1, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.Text = item.Sub and (item.Title .. " > " .. item.Sub) or item.Title
                titleLbl.TextColor3 = self.Theme.TextPrimary
                titleLbl.TextSize = 10
                titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.ZIndex = 83
                titleLbl.Parent = itemBtn

                itemBtn.MouseEnter:Connect(function()
                    self:Tween(itemBtn, { BackgroundColor3 = self.Theme.CardHover }, 0.15)
                end)
                itemBtn.MouseLeave:Connect(function()
                    self:Tween(itemBtn, { BackgroundColor3 = Color3.fromRGB(26, 26, 34) }, 0.15)
                end)
                itemBtn.MouseButton1Click:Connect(function()
                    searchDropdown.Visible = false
                    searchBox.Text = ""
                    if item.IsSidePreview then
                        self:ToggleSidePanel(true)
                        return
                    end
                    self:SwitchTab(item.Tab)
                    task.spawn(function()
                        task.wait(0.05)
                        local page = self.State.Tabs[item.Tab]
                        if page and page:IsA("ScrollingFrame") and item.Card then
                            local cardY = item.Card.AbsolutePosition.Y - page.AbsolutePosition.Y + page.CanvasPosition.Y
                            page.CanvasPosition = Vector2.new(0, math.clamp(cardY - 20, 0, 99999))
                            local stroke = item.Card:FindFirstChildOfClass("UIStroke")
                            if stroke then
                                local origColor = stroke.Color
                                local origThick = stroke.Thickness
                                stroke.Color = self.Theme.AccentGlow
                                stroke.Thickness = 2
                                task.wait(1.2)
                                self:Tween(stroke, { Color = origColor, Thickness = origThick }, 0.4)
                            end
                        end
                    end)
                end)
            end
        end
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(performGlobalSearch)
    searchBox.FocusLost:Connect(function(enterPressed)
        if not enterPressed then
            task.delay(0.25, function()
                if not searchBox:IsFocused() then
                    searchDropdown.Visible = false
                end
            end)
        end
    end)

    -- LEFT SIDEBAR (разделы слева)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Position = UDim2.new(0, 0, 0, 48)
    sidebar.Size = UDim2.new(0, 146, 1, -48)
    sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 5
    sidebar.Parent = main
    self.State.Sidebar = sidebar

    local sidebarDivider = Instance.new("Frame")
    sidebarDivider.Name = "SidebarDivider"
    sidebarDivider.Position = UDim2.new(0, 146, 0, 48)
    sidebarDivider.Size = UDim2.new(0, 1, 1, -48)
    sidebarDivider.BackgroundColor3 = self.Theme.Border
    sidebarDivider.BorderSizePixel = 0
    sidebarDivider.ZIndex = 6
    sidebarDivider.Parent = main

    local buttonsHolder = Instance.new("ScrollingFrame")
    buttonsHolder.Name = "ButtonsHolder"
    buttonsHolder.Size = UDim2.new(1, 0, 1, 0)
    buttonsHolder.BackgroundTransparency = 1
    buttonsHolder.BorderSizePixel = 0
    buttonsHolder.ScrollBarThickness = 2
    buttonsHolder.ScrollBarImageColor3 = Color3.fromRGB(45, 45, 60)
    buttonsHolder.ScrollingDirection = Enum.ScrollingDirection.Y
    buttonsHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    buttonsHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    buttonsHolder.ZIndex = 7
    buttonsHolder.Parent = sidebar
    self.State.ButtonsHolder = buttonsHolder

    local navPad = Instance.new("UIPadding")
    navPad.PaddingLeft = UDim.new(0, 8)
    navPad.PaddingRight = UDim.new(0, 8)
    navPad.PaddingTop = UDim.new(0, 10)
    navPad.PaddingBottom = UDim.new(0, 10)
    navPad.Parent = buttonsHolder

    local navLayout = Instance.new("UIListLayout")
    navLayout.FillDirection = Enum.FillDirection.Vertical
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    navLayout.Padding = UDim.new(0, 5)
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = buttonsHolder

    -- RIGHT CONTENT AREA
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Position = UDim2.new(0, 147, 0, 48)
    contentArea.Size = UDim2.new(1, -147, 1, -48)
    contentArea.BackgroundTransparency = 1
    contentArea.ClipsDescendants = true
    contentArea.ZIndex = 4
    contentArea.Parent = main

    -- Tabs in requested order: Combat, Visuals, Misc, Farm, Skins, Animation, Maps, Settings
    local tabDefinitions = {
        { Name = "Combat", Icon = Icons.Combat, LayoutOrder = 1 },
        { Name = "Visuals", Icon = Icons.Visuals, LayoutOrder = 2 },
        { Name = "Misc", Icon = Icons.Misc, LayoutOrder = 3 },
        { Name = "Farm", Icon = "rbxassetid://7743866529", LayoutOrder = 4 }, -- Lucide coins
        { Name = "Skins", Icon = "rbxassetid://7734021595", LayoutOrder = 5 }, -- Lucide palette
        { Name = "Animation", Icon = Icons.Animation, LayoutOrder = 6 },
        { Name = "Maps", Icon = Icons.Maps, LayoutOrder = 7 },
        { Name = "Settings", Icon = Icons.Settings or Icons.Config, LayoutOrder = 8 },
    }

    for _, def in ipairs(tabDefinitions) do
        self:CreateTabButton(buttonsHolder, contentArea, def)
    end

    self:BuildCombatTab(self.State.Tabs["Combat"])
    self:BuildVisualsTab(self.State.Tabs["Visuals"])
    self:BuildMiscTab(self.State.Tabs["Misc"])
    self:BuildFarmTab(self.State.Tabs["Farm"])
    self:BuildSkinsTab(self.State.Tabs["Skins"])
    self:BuildAnimationTab(self.State.Tabs["Animation"])
    self:BuildMapsTab(self.State.Tabs["Maps"])
    self:BuildConfigTab(self.State.Tabs["Settings"])
    self.State.Tabs["Config"] = self.State.Tabs["Settings"]
    self.State.TabButtons["Config"] = self.State.TabButtons["Settings"]

    self:SwitchTab("Combat")

    self:SetupWindowDragging()
    self:SetupKeybinds()
    self:SetupSkinWatchers()
    self:SetupGunDropWatcher()
    self:HookSilentAim()
    self:InitCrosshair()
    self:StartMainLoops()
    self:WatchCharacterMorphs()
    self:SetupAutoRejoin()
    self:CheckAutoload()

    local cam = self.Services.Workspace.CurrentCamera
    if cam then
        local vpConn = cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            self:UpdateLayoutForDevice()
        end)
        table.insert(self.State.Connections, vpConn)
    end

    self:PlayIntroAnimation()
end

function Hub:PlayIntroAnimation()
    local screen = self.State.Gui
    local main = self.State.MainFrame
    local shadow = self.State.Shadow
    if not (screen and main) then
        if self.Config.Toggles.Watermark and self.State.Watermark then
            self:UpdateWatermarkValues()
            self.State.Watermark.Visible = true
        end
        return
    end

    local logoAsset = self:GetLogoAsset()

    -- Intro Stage Card (Transforms from badge -> horizontal title card -> full hub)
    local stage = Instance.new("Frame")
    stage.Name = "IntroStage"
    stage.AnchorPoint = Vector2.new(0.5, 0.5)
    stage.Position = UDim2.new(0.5, 0, 0.5, 0)
    stage.Size = UDim2.new(0, 100, 0, 100)
    stage.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    stage.BackgroundTransparency = 1
    stage.ClipsDescendants = true
    stage.ZIndex = 80
    stage.Parent = screen
    self:Corner(stage, 14)
    local stageStroke = self:Stroke(stage, Color3.fromRGB(38, 40, 54), 1.5)
    stageStroke.Transparency = 1

    -- Ambient Glow behind the logo
    local glow = Instance.new("ImageLabel")
    glow.Name = "AmbientGlow"
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.Size = UDim2.new(0, 130, 0, 130)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = Color3.fromRGB(230, 235, 255)
    glow.ImageTransparency = 1
    glow.ZIndex = 81
    glow.Parent = stage

    -- Logo Image
    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.Position = UDim2.new(0.5, 0, 0.5, 0)
    logo.Size = UDim2.new(0, 20, 0, 20)
    logo.BackgroundTransparency = 1
    logo.Image = logoAsset
    logo.ScaleType = Enum.ScaleType.Fit
    logo.ImageTransparency = 1
    logo.ZIndex = 83
    logo.Parent = stage

    -- Text Container (Positioned at X = 114 to give breathing room)
    local textContainer = Instance.new("Frame")
    textContainer.Name = "TextContainer"
    textContainer.AnchorPoint = Vector2.new(0, 0.5)
    textContainer.Position = UDim2.new(0, 114, 0.5, 0)
    textContainer.Size = UDim2.new(0, 0, 0, 70)
    textContainer.BackgroundTransparency = 1
    textContainer.ClipsDescendants = true
    textContainer.ZIndex = 84
    textContainer.Parent = stage

    -- Title row: "DYNAMIC" + " HUB"
    local titleHolder = Instance.new("Frame")
    titleHolder.Name = "TitleHolder"
    titleHolder.Position = UDim2.new(0, 6, 0, 4)
    titleHolder.Size = UDim2.new(1, -6, 0, 26)
    titleHolder.BackgroundTransparency = 1
    titleHolder.Parent = textContainer

    local titleLayout = Instance.new("UIListLayout")
    titleLayout.FillDirection = Enum.FillDirection.Horizontal
    titleLayout.SortOrder = Enum.SortOrder.LayoutOrder
    titleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    titleLayout.Padding = UDim.new(0, 6)
    titleLayout.Parent = titleHolder

    local lblDynamic = Instance.new("TextLabel")
    lblDynamic.Name = "1_Dynamic"
    lblDynamic.LayoutOrder = 1
    lblDynamic.Size = UDim2.new(0, 96, 1, 0)
    lblDynamic.BackgroundTransparency = 1
    lblDynamic.Font = Enum.Font.GothamBold
    lblDynamic.Text = "DYNAMIC"
    lblDynamic.TextColor3 = Color3.fromRGB(255, 255, 255)
    lblDynamic.TextSize = 20
    lblDynamic.TextXAlignment = Enum.TextXAlignment.Left
    lblDynamic.Parent = titleHolder

    local lblHub = Instance.new("TextLabel")
    lblHub.Name = "2_Hub"
    lblHub.LayoutOrder = 2
    lblHub.Size = UDim2.new(0, 52, 1, 0)
    lblHub.BackgroundTransparency = 1
    lblHub.Font = Enum.Font.GothamBold
    lblHub.Text = "HUB"
    lblHub.TextColor3 = Color3.fromRGB(175, 180, 200)
    lblHub.TextSize = 20
    lblHub.TextXAlignment = Enum.TextXAlignment.Left
    lblHub.Parent = titleHolder

    -- Sleek accent line
    local accentLine = Instance.new("Frame")
    accentLine.Name = "AccentLine"
    accentLine.Position = UDim2.new(0, 6, 0, 36)
    accentLine.Size = UDim2.new(0, 0, 0, 2)
    accentLine.BackgroundColor3 = Color3.fromRGB(240, 245, 255)
    accentLine.BorderSizePixel = 0
    accentLine.Parent = textContainer
    self:Corner(accentLine, 1)

    local lineGradient = Instance.new("UIGradient")
    lineGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(180, 185, 215)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 75, 95))
    })
    lineGradient.Parent = accentLine

    -- Subtitle Tagline
    local lblSubtitle = Instance.new("TextLabel")
    lblSubtitle.Name = "Subtitle"
    lblSubtitle.Position = UDim2.new(0, 6, 0, 44)
    lblSubtitle.Size = UDim2.new(1, -6, 0, 18)
    lblSubtitle.BackgroundTransparency = 1
    lblSubtitle.Font = Enum.Font.GothamMedium
    lblSubtitle.Text = "MURDER MYSTERY 2  •  LOADED"
    lblSubtitle.TextColor3 = Color3.fromRGB(120, 125, 145)
    lblSubtitle.TextSize = 9
    lblSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    lblSubtitle.TextTransparency = 1
    lblSubtitle.Parent = textContainer

    -- Welcome Label (Reveals with smooth transition after title display)
    local lblWelcome = Instance.new("TextLabel")
    lblWelcome.Name = "Welcome"
    lblWelcome.AnchorPoint = Vector2.new(0, 0.5)
    lblWelcome.Position = UDim2.new(0, 6, 0.5, 10)
    lblWelcome.Size = UDim2.new(1, -6, 0, 32)
    lblWelcome.BackgroundTransparency = 1
    lblWelcome.Font = Enum.Font.GothamBold
    lblWelcome.Text = "Welcome"
    lblWelcome.TextColor3 = Color3.fromRGB(255, 255, 255)
    lblWelcome.TextSize = 25
    lblWelcome.TextXAlignment = Enum.TextXAlignment.Left
    lblWelcome.TextTransparency = 1
    lblWelcome.ZIndex = 85
    lblWelcome.Parent = textContainer

    local welcomeGradient = Instance.new("UIGradient")
    welcomeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(235, 240, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 190, 220))
    })
    welcomeGradient.Parent = lblWelcome

    -- Animation sequence
    task.spawn(function()
        -- 1. Stage Card & Glow Fade In smoothly
        self:Tween(stage, { BackgroundTransparency = 0.05 }, 0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        self:Tween(stageStroke, { Transparency = 0 }, 0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        self:Tween(glow, { ImageTransparency = 0.5 }, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        -- 2. Logo smooth scale-up into center
        self:Tween(logo, {
            Size = UDim2.new(0, 68, 0, 68),
            ImageTransparency = 0
        }, 0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        task.wait(0.65)

        -- 3. Simultaneous fluid expansion (Logo glides left while text unrolls to the right)
        self:Tween(stage, {
            Size = UDim2.new(0, 375, 0, 100)
        }, 0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        self:Tween(logo, {
            Position = UDim2.new(0, 52, 0.5, 0)
        }, 0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        self:Tween(glow, {
            Position = UDim2.new(0, 52, 0.5, 0)
        }, 0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        self:Tween(textContainer, {
            Size = UDim2.new(0, 250, 0, 70)
        }, 0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        task.delay(0.2, function()
            self:Tween(accentLine, { Size = UDim2.new(0, 230, 0, 2) }, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            self:Tween(lblSubtitle, { TextTransparency = 0 }, 0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        end)

        task.wait(2.2) -- Display title

        -- 4. Animate out the title & subtitle smoothly
        self:Tween(titleHolder, { Position = UDim2.new(0, 6, 0, -8) }, 0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        self:Tween(lblDynamic, { TextTransparency = 1 }, 0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        self:Tween(lblHub, { TextTransparency = 1 }, 0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        self:Tween(accentLine, { Size = UDim2.new(0, 0, 0, 2), BackgroundTransparency = 1 }, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        self:Tween(lblSubtitle, { Position = UDim2.new(0, 6, 0, 38), TextTransparency = 1 }, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

        task.wait(0.22)

        -- 5. Animate in "Welcome" with graceful slide & fade
        self:Tween(lblWelcome, {
            Position = UDim2.new(0, 6, 0.5, 0),
            TextTransparency = 0
        }, 0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        self:Tween(glow, { ImageTransparency = 0.35, Size = UDim2.new(0, 140, 0, 140) }, 0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        task.wait(1.1) -- Display Welcome

        -- 6. Seamless continuous morph directly into the real Hub Window!
        self:Tween(logo, { ImageTransparency = 1 }, 0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        self:Tween(glow, { ImageTransparency = 1 }, 0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        self:Tween(lblWelcome, {
            Position = UDim2.new(0, 6, 0.5, -8),
            TextTransparency = 1
        }, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

        local targetSize = self.State.WindowSize or UDim2.new(0, 720, 0, 500)
        local morphTween = self:Tween(stage, {
            Size = targetSize,
            BackgroundColor3 = self.Theme.MainBg
        }, 0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        task.delay(0.18, function()
            main.Visible = true
            main.BackgroundTransparency = 1
            if shadow then
                shadow.Visible = true
                shadow.ImageTransparency = 1
                self:Tween(shadow, { ImageTransparency = 0.35 }, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            end
            self:Tween(main, { BackgroundTransparency = 0 }, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        end)

        morphTween.Completed:Wait()
        stage:Destroy()
        self.State.IsOpen = true
        if self.Config.Toggles.Watermark and self.State.Watermark then
            self:UpdateWatermarkValues()
            self.State.Watermark.Visible = true
        end
    end)
end

function Hub:CreateTabButton(navContainer, contentArea, def)
    local name = def.Name
    local btn = Instance.new("TextButton")
    btn.Name = "TabBtn_" .. name
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = def.LayoutOrder
    btn.ZIndex = 8
    btn.Parent = navContainer
    self:Corner(btn, 8)
    local btnStroke = self:Stroke(btn, Color3.fromRGB(42, 44, 60), 1)
    btnStroke.Transparency = 1

    -- Left glowing accent indicator
    local activeBar = Instance.new("Frame")
    activeBar.Name = "ActiveIndicator"
    activeBar.Size = UDim2.new(0, 3, 0.55, 0)
    activeBar.Position = UDim2.new(0, 4, 0.5, 0)
    activeBar.AnchorPoint = Vector2.new(0, 0.5)
    activeBar.BackgroundColor3 = self.Theme.Accent
    activeBar.BorderSizePixel = 0
    activeBar.BackgroundTransparency = 1
    activeBar.ZIndex = 9
    activeBar.Parent = btn
    self:Corner(activeBar, 2)

    -- Tab Icon (FIRST, on the left)
    local icon = Instance.new("ImageLabel")
    icon.Name = "TabIcon"
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(0, 14, 0.5, -8)
    icon.BackgroundTransparency = 1
    icon.Image = def.Icon or Icons[name] or Icons.Combat
    icon.ImageColor3 = Color3.fromRGB(150, 155, 175)
    icon.ZIndex = 9
    icon.Parent = btn

    -- Tab Title (AFTER icon)
    local title = Instance.new("TextLabel")
    title.Name = "TabTitle"
    title.Position = UDim2.new(0, 38, 0, 0)
    title.Size = UDim2.new(1, -42, 1, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamMedium
    title.Text = name
    title.TextColor3 = Color3.fromRGB(150, 155, 175)
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 9
    title.Parent = btn

    -- Content Area Page
    local page = Instance.new("ScrollingFrame")
    page.Name = "Page_" .. name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = self.Theme.Accent
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ZIndex = 5
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

    btn.MouseEnter:Connect(function()
        if self.Config.ActiveTab ~= name then
            self:Tween(btn, { BackgroundTransparency = 0.8 }, 0.15)
            self:Tween(title, { TextColor3 = Color3.fromRGB(225, 230, 245) }, 0.15)
            self:Tween(icon, { ImageColor3 = Color3.fromRGB(225, 230, 245) }, 0.15)
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.Config.ActiveTab ~= name then
            self:Tween(btn, { BackgroundTransparency = 1 }, 1)
            self:Tween(title, { TextColor3 = Color3.fromRGB(150, 155, 175) }, 0.15)
            self:Tween(icon, { ImageColor3 = Color3.fromRGB(150, 155, 175) }, 0.15)
        end
    end)
    btn.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)

    self.State.Tabs[name] = page
    self.State.TabButtons[name] = {
        Button = btn,
        Stroke = btnStroke,
        ActiveBar = activeBar,
        Icon = icon,
        Title = title,
        LayoutOrder = def.LayoutOrder
    }
end

function Hub:SwitchTab(tabName)
    self.Config.ActiveTab = tabName
    if self.State.SearchBox then
        self.State.SearchBox.Text = ""
    end

    for name, data in pairs(self.State.TabButtons) do
        local page = self.State.Tabs[name]
        if page then
            if name == tabName then
                page.Visible = true
                task.defer(function()
                    local wrapper = page:FindFirstChild("DualColWrapper")
                    if wrapper then
                        local leftCol = wrapper:FindFirstChild("LeftCol")
                        local rightCol = wrapper:FindFirstChild("RightCol")
                        local leftLayout = leftCol and leftCol:FindFirstChildOfClass("UIListLayout")
                        local rightLayout = rightCol and rightCol:FindFirstChildOfClass("UIListLayout")
                        local lh = (leftLayout and leftLayout.AbsoluteContentSize.Y) or (leftCol and leftCol.AbsoluteSize.Y) or 0
                        local rh = (rightLayout and rightLayout.AbsoluteContentSize.Y) or (rightCol and rightCol.AbsoluteSize.Y) or 0
                        local maxH = math.max(lh, rh)
                        if maxH > 40 then
                            wrapper.Size = UDim2.new(1, 0, 0, maxH + 20)
                            page.CanvasSize = UDim2.new(0, 0, 0, maxH + 50)
                        end
                    end
                end)
                task.delay(0.08, function()
                    local wrapper = page:FindFirstChild("DualColWrapper")
                    if wrapper then
                        local leftCol = wrapper:FindFirstChild("LeftCol")
                        local rightCol = wrapper:FindFirstChild("RightCol")
                        local leftLayout = leftCol and leftCol:FindFirstChildOfClass("UIListLayout")
                        local rightLayout = rightCol and rightCol:FindFirstChildOfClass("UIListLayout")
                        local lh = (leftLayout and leftLayout.AbsoluteContentSize.Y) or (leftCol and leftCol.AbsoluteSize.Y) or 0
                        local rh = (rightLayout and rightLayout.AbsoluteContentSize.Y) or (rightCol and rightCol.AbsoluteSize.Y) or 0
                        local maxH = math.max(lh, rh)
                        if maxH > 40 then
                            wrapper.Size = UDim2.new(1, 0, 0, maxH + 20)
                            page.CanvasSize = UDim2.new(0, 0, 0, maxH + 50)
                        end
                    end
                end)

                data.Title.Font = Enum.Font.GothamBold
                data.Button.BackgroundColor3 = Color3.fromRGB(28, 30, 44)
                self:Tween(data.Button, { BackgroundTransparency = 0 }, 0.2)
                if data.Stroke then
                    self:Tween(data.Stroke, { Transparency = 0 }, 0.2)
                end
                if data.ActiveBar then
                    self:Tween(data.ActiveBar, { BackgroundTransparency = 0 }, 0.2)
                end
                self:Tween(data.Title, { TextColor3 = Color3.fromRGB(255, 255, 255) }, 0.2)
                if data.Icon then
                    self:Tween(data.Icon, { ImageColor3 = self.Theme.Accent }, 0.2)
                end
            else
                page.Visible = false
                data.Title.Font = Enum.Font.GothamMedium
                self:Tween(data.Button, { BackgroundTransparency = 1 }, 0.2)
                if data.Stroke then
                    self:Tween(data.Stroke, { Transparency = 1 }, 0.2)
                end
                if data.ActiveBar then
                    self:Tween(data.ActiveBar, { BackgroundTransparency = 1 }, 0.2)
                end
                self:Tween(data.Title, { TextColor3 = Color3.fromRGB(150, 155, 175) }, 0.2)
                if data.Icon then
                    self:Tween(data.Icon, { ImageColor3 = Color3.fromRGB(150, 155, 175) }, 0.2)
                end
            end
        end
    end

    if tabName == "Visuals" then
        if self.State.VisualSubTabs then
            self.State.VisualSubTabs.Visible = true
        end
        task.spawn(function() self:CloneLocalPlayerModel() end)
        if self.World.Section then
            self.World.Section.Visible = true
            self:Tween(self.World.Section, { BackgroundTransparency = 0 }, 0.3)
        end
    else
        if self.State.VisualSubTabs then
            self.State.VisualSubTabs.Visible = false
        end
        if self.World.Section then
            self.World.Section.Visible = false
        end
    end
end
function Hub:CreateDualColumnPage(container)
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
    local function syncHeight()
        task.defer(function()
            if not (leftCol and rightCol and wrapper) then return end
            local function calcColHeight(col, layout)
                local h = (layout and layout.AbsoluteContentSize.Y) or 0
                for _, ch in ipairs(col:GetChildren()) do
                    if ch:IsA("GuiObject") and ch.Visible then
                        local chH = ch.AbsoluteSize.Y
                        if chH <= 0 and ch:FindFirstChildOfClass("UIListLayout") then
                            chH = ch:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + 40
                        end
                        h = math.max(h, (ch.Position.Y.Offset or 0) + chH)
                    end
                end
                return math.max(h, col.AbsoluteSize.Y)
            end
            local lh = calcColHeight(leftCol, leftLayout)
            local rh = calcColHeight(rightCol, rightLayout)
            local maxH = math.max(lh, rh)
            if maxH > 40 then
                wrapper.Size = UDim2.new(1, 0, 0, maxH + 20)
                if container and container:IsA("ScrollingFrame") then
                    container.AutomaticCanvasSize = Enum.AutomaticSize.None
                    container.CanvasSize = UDim2.new(0, 0, 0, maxH + 50)
                end
            end
        end)
    end
    leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(syncHeight)
    rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(syncHeight)
    leftCol:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncHeight)
    rightCol:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncHeight)
    wrapper:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncHeight)
    if container then
        container:GetPropertyChangedSignal("Visible"):Connect(syncHeight)
    end
    task.delay(0.1, syncHeight)
    task.delay(0.3, syncHeight)
    return leftCol, rightCol
end
function Hub:CreateSection(parent, title, description)
    local sec = Instance.new("Frame")
    sec.Name = "Card_" .. (title:gsub("%s+", ""))
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.AutomaticSize = Enum.AutomaticSize.Y
    sec.BackgroundColor3 = self.Theme.CardBg
    sec.BorderSizePixel = 0
    sec.Parent = parent
    self:Corner(sec, 12)
    self:Stroke(sec, self.Theme.Border, 1)
    local secPad = Instance.new("UIPadding")
    secPad.PaddingTop = UDim.new(0, 10)
    secPad.PaddingBottom = UDim.new(0, 10)
    secPad.PaddingLeft = UDim.new(0, 12)
    secPad.PaddingRight = UDim.new(0, 12)
    secPad.Parent = sec
    local secLayout = Instance.new("UIListLayout")
    secLayout.Padding = UDim.new(0, 8)
    secLayout.SortOrder = Enum.SortOrder.LayoutOrder
    secLayout.Parent = sec
    local headerContainer = Instance.new("Frame")
    headerContainer.Name = "CardHeader"
    headerContainer.Size = UDim2.new(1, 0, 0, 20)
    headerContainer.BackgroundTransparency = 1
    headerContainer.Parent = sec
    local star = Instance.new("ImageLabel")
    star.Name = "StarIcon"
    star.Size = UDim2.new(0, 13, 0, 13)
    star.Position = UDim2.new(0, 0, 0.5, -6)
    star.BackgroundTransparency = 1
    star.Image = Icons.StarFilled
    star.ImageColor3 = self.Theme.Accent
    star.Parent = headerContainer
    local header = Instance.new("TextLabel")
    header.Name = "CardTitle"
    header.Position = UDim2.new(0, 20, 0, 0)
    header.Size = UDim2.new(1, -20, 1, 0)
    header.BackgroundTransparency = 1
    header.Font = Enum.Font.GothamBold
    header.Text = title
    header.TextColor3 = self.Theme.TextPrimary
    header.TextSize = 12
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = headerContainer
    return sec
end
function Hub:ResolveToggleKey(title, configKey)
    if configKey and configKey ~= "" then
        return configKey
    end
    local toggleMap = {
        ["Silent Aim"] = "SilentAim",
        ["Wallbang"] = "AimWallbang",
        ["Prediction"] = "AimPrediction",
        ["Auto Shoot"] = "AutoShotMurderer",
        ["Auto Grab"] = "AutoGrabGun",
        ["Auto Farm"] = "AutoFarm",
        ["Avoid Murderer"] = "AutoFarmAvoidMurder",
        ["Fling Murderer on Death"] = "AutoFarmFlingMurderOnDeath",
        ["Kill All on Full Bag"] = "AutoFarmKillAllOnFull",
        ["Shoot Murderer on Full Bag"] = "AutoFarmShootMurdererOnFull",
        ["Teleport to Lobby on Full Bag"] = "AutoFarmSafeZone",
        ["Reset on Full Bag"] = "AutoFarmAutoReset",
        ["Auto Prestige"] = "AutoPrestige",
        ["Anti-AFK"] = "AntiAFK",
        ["Anti-AFK (Anti-Kick)"] = "AntiAFK",
        ["Auto Rejoin"] = "AutoRejoin",
        ["Auto Rejoin on Kick"] = "AutoRejoin",
        ["Anti-Lag"] = "PotatoOptimizer",
        ["Anti-Fling"] = "AntiFling",
        ["Kill All"] = "KillAll",
        ["Kill Aura"] = "KillAura",
        ["Auto Kill Sheriff"] = "AutoKillSheriff",
        ["ESP"] = "ESPRoles",
        ["Only Roles"] = "OnlyImportantRoles",
        ["Role Text"] = "ESPRoleText",
        ["Nicknames"] = "ESPNickname",
        ["Distance"] = "ESPDist",
        ["2D Boxes"] = "ESPBoxes",
        ["Tracers"] = "ESPTracers",
        ["Gun ESP"] = "ESPGun",
        ["Local ESP"] = "LocalESP",
        ["Auto Rotation"] = "PreviewRotate",
        ["Enable Crosshair"] = "CustomCrosshair",
        ["Only With Gun"] = "CrosshairOnlyGun",
        ["Spinning Crosshair"] = "CrosshairSpin",
        ["Hide Default Crosshair"] = "CrosshairHideDefault",
        ["Center Dot"] = "CrosshairDot",
        ["FullBright"] = "FullBright",
        ["No Fog"] = "NoFog",
        ["World Shadows"] = "WorldShadows",
        ["X-Ray Wallhack"] = "XRay",
        ["Show Values"] = "ShowSkinValues",
        ["Speed Hack"] = "SpeedHack",
        ["Infinite Jump"] = "InfiniteJump",
        ["NoClip"] = "NoClip",
        ["Walk Fling"] = "WalkFling",
        ["Enable Vote Duplicator"] = "VoteDup",
        ["Watermark HUD"] = "Watermark",
    }
    if toggleMap[title] then
        return toggleMap[title]
    end
    local baseTitle = title:gsub("%b()", ""):gsub("%b[]", ""):match("^%s*(.-)%s*$")
    if baseTitle and toggleMap[baseTitle] then
        return toggleMap[baseTitle]
    end
    for k, v in pairs(toggleMap) do
        if string.find(title, k, 1, true) then
            return v
        end
    end
    local genKey = (baseTitle and baseTitle ~= "" and baseTitle:gsub("[^%w]", "")) or title:gsub("[^%w]", "")
    if genKey and genKey ~= "" then
        return genKey
    end
    return title
end
function Hub:CreateToggle(section, title, defaultState, callback, configKey)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    row.Parent = section
    self:Corner(row, 6)
    self:Stroke(row, Color3.fromRGB(32, 32, 42), 1)
    local lbl = Instance.new("TextLabel")
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(1, -54, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = title
    lbl.TextColor3 = defaultState and self.Theme.TextPrimary or self.Theme.TextDim
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 36, 0, 18)
    switch.Position = UDim2.new(1, -44, 0.5, -9)
    switch.BackgroundColor3 = defaultState and self.Theme.Accent or Color3.fromRGB(34, 34, 44)
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.Parent = row
    self:Corner(switch, 10)
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = defaultState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    circle.BackgroundColor3 = defaultState and Color3.fromRGB(20, 22, 30) or Color3.fromRGB(210, 215, 225)
    circle.Parent = switch
    self:Corner(circle, 7)
    local state = defaultState
    local regKey = self:ResolveToggleKey(title, configKey)
    if regKey and self.Config.Toggles[regKey] == nil then
        self.Config.Toggles[regKey] = defaultState
    end
    local function setVisual(newState, fireCallback)
        state = newState
        if regKey then
            self.Config.Toggles[regKey] = state
        end
        local targetColor = state and self.Theme.Accent or Color3.fromRGB(34, 34, 44)
        local targetPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local knobColor = state and Color3.fromRGB(20, 22, 30) or Color3.fromRGB(210, 215, 225)
        local textColor = state and self.Theme.TextPrimary or self.Theme.TextDim
        self:Tween(switch, { BackgroundColor3 = targetColor }, 0.2)
        self:Tween(circle, { Position = targetPos, BackgroundColor3 = knobColor }, 0.2)
        self:Tween(lbl, { TextColor3 = textColor }, 0.2)
        if fireCallback and callback then
            callback(state)
        end
    end
    switch.MouseButton1Click:Connect(function()
        setVisual(not state, true)
    end)
    if self.Controls and self.Controls.Toggles and regKey then
        self.Controls.Toggles[regKey] = setVisual
        self.Controls.Toggles[title] = setVisual
        local clean = title:gsub("[^%w]", "")
        if clean ~= "" then
            self.Controls.Toggles[clean] = setVisual
        end
        local base = title:gsub("%b()", ""):gsub("%b[]", ""):match("^%s*(.-)%s*$")
        if base and base ~= "" then
            self.Controls.Toggles[base] = setVisual
            local baseClean = base:gsub("[^%w]", "")
            if baseClean ~= "" then
                self.Controls.Toggles[baseClean] = setVisual
            end
        end
    end
    return row
end
function Hub:CreateDropdown(section, title, options, default, callback, configKey)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    row.Parent = section
    self:Corner(row, 6)
    self:Stroke(row, Color3.fromRGB(32, 32, 42), 1)
    local lbl = Instance.new("TextLabel")
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(0.48, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = title
    lbl.TextColor3 = self.Theme.TextDim
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 105, 0, 20)
    btn.Position = UDim2.new(1, -112, 0.5, -10)
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    btn.Font = Enum.Font.GothamBold
    btn.Text = default or "Select"
    btn.TextColor3 = self.Theme.Accent
    btn.TextSize = 10
    btn.AutoButtonColor = false
    btn.Parent = row
    self:Corner(btn, 5)
    self:Stroke(btn, Color3.fromRGB(38, 43, 58), 1)
    local curr = default
    local function setVisual(newVal, fireCallback)
        curr = newVal
        btn.Text = tostring(newVal)
        if fireCallback and callback then
            callback(curr)
        end
    end
    btn.MouseEnter:Connect(function()
        self:Tween(btn, { BackgroundColor3 = Color3.fromRGB(34, 40, 56) }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        self:Tween(btn, { BackgroundColor3 = Color3.fromRGB(26, 26, 34) }, 0.15)
    end)
    btn.MouseButton1Click:Connect(function()
        local opts = (type(options) == "function") and options() or options
        if not opts or #opts == 0 then
            btn.Text = "None"
            return
        end
        local found = false
        for idx, val in ipairs(opts) do
            if val == curr then
                curr = opts[(idx % #opts) + 1]
                found = true
                break
            end
        end
        if not found then
            curr = opts[1]
        end
        btn.Text = tostring(curr)
        if callback then callback(curr) end
    end)
    local dropMap = {
        ["Farm Mode"] = "AutoFarmMode",
        ["Kill All Mode"] = "KillAllMode",
        ["Aura Mode"] = "KillMode",
        ["Kill Sheriff Mode"] = "KillSheriffMode",
        ["Color"] = "CrosshairColor",
        ["Atmosphere Tint"] = "AmbientTint",
    }
    local regKey = configKey or dropMap[title] or title:gsub("%b()", ""):gsub("[^%w]", "")
    if regKey and self.Controls and self.Controls.Dropdowns then
        self.Controls.Dropdowns[regKey] = setVisual
        self.Controls.Dropdowns[title] = setVisual
    end
    return btn
end
function Hub:CreateSlider(section, title, minVal, maxVal, defaultVal, suffix, callback, configKey)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    row.Parent = section
    self:Corner(row, 6)
    self:Stroke(row, Color3.fromRGB(32, 32, 42), 1)
    local lbl = Instance.new("TextLabel")
    lbl.Position = UDim2.new(0, 10, 0, 3)
    lbl.Size = UDim2.new(0.65, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = title
    lbl.TextColor3 = self.Theme.TextDim
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local badge = Instance.new("Frame")
    badge.Size = UDim2.new(0, 48, 0, 16)
    badge.Position = UDim2.new(1, -56, 0, 3)
    badge.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    badge.Parent = row
    self:Corner(badge, 4)
    self:Stroke(badge, Color3.fromRGB(38, 43, 58), 1)
    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(1, 0, 1, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Font = Enum.Font.GothamBold
    valLbl.Text = tostring(defaultVal) .. (suffix or "")
    valLbl.TextColor3 = self.Theme.Accent
    valLbl.TextSize = 10
    valLbl.TextXAlignment = Enum.TextXAlignment.Center
    valLbl.Parent = badge
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, 6)
    bar.Position = UDim2.new(0, 10, 0, 25)
    bar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    bar.Parent = row
    self:Corner(bar, 3)
    local fill = Instance.new("Frame")
    local pct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = self.Theme.Accent
    fill.Parent = bar
    self:Corner(fill, 3)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(1, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = fill
    self:Corner(knob, 5)
    local function setVisual(newVal, fireCallback)
        local clamped = math.clamp(math.floor(newVal), minVal, maxVal)
        local ratio = math.clamp((clamped - minVal) / (maxVal - minVal), 0, 1)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        valLbl.Text = tostring(clamped) .. (suffix or "")
        if fireCallback and callback then
            callback(clamped)
        end
    end
    local dragging = false
    local function update(input)
        local x = input.Position.X - bar.AbsolutePosition.X
        local ratio = math.clamp(x / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * ratio)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        valLbl.Text = tostring(val) .. (suffix or "")
        if callback then callback(val) end
    end
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    self.Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    self.Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    local sliderMap = {
        ["Prediction Scale"] = "PredictionPercent",
        ["Aura Distance"] = "KillAuraDist",
        ["Spin Speed"] = "CrosshairSpinSpeed",
        ["Size"] = "CrosshairSize",
        ["Thickness"] = "CrosshairThickness",
        ["Gap"] = "CrosshairGap",
        ["X-Ray Transparency"] = "XRayTransparency",
        ["Camera FOV"] = "CameraFOV",
        ["Time of Day"] = "ClockTime",
        ["Speed Value"] = "WalkSpeed",
    }
    local regKey = configKey or sliderMap[title] or title:gsub("%b()", ""):gsub("[^%w]", "")
    if regKey and self.Controls and self.Controls.Sliders then
        self.Controls.Sliders[regKey] = setVisual
        self.Controls.Sliders[title] = setVisual
    end
    return row
end
function Hub:CreateButton(section, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    btn.Text = text
    btn.Font = Enum.Font.GothamMedium
    btn.TextColor3 = self.Theme.TextPrimary
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.Parent = section
    self:Corner(btn, 6)
    self:Stroke(btn, Color3.fromRGB(36, 36, 48), 1)
    btn.MouseEnter:Connect(function()
        self:Tween(btn, { BackgroundColor3 = Color3.fromRGB(32, 32, 42), TextColor3 = Color3.fromRGB(255, 255, 255) }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        self:Tween(btn, { BackgroundColor3 = Color3.fromRGB(22, 22, 28), TextColor3 = self.Theme.TextPrimary }, 0.15)
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then callback(btn) end
    end)
    return btn
end
function Hub:CreateLabel(section, text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = text
    lbl.TextColor3 = color or self.Theme.TextDim
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = section
    return lbl
end
function Hub:CreateKeybind(section, title, defaultKey, callback, configKey)
    local bindRow = Instance.new("Frame")
    bindRow.Size = UDim2.new(1, 0, 0, 30)
    bindRow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    bindRow.Parent = section
    self:Corner(bindRow, 6)
    self:Stroke(bindRow, Color3.fromRGB(32, 32, 42), 1)
    local bLbl = Instance.new("TextLabel")
    bLbl.Position = UDim2.new(0, 10, 0, 0)
    bLbl.Size = UDim2.new(0.6, 0, 1, 0)
    bLbl.BackgroundTransparency = 1
    bLbl.Font = Enum.Font.GothamMedium
    bLbl.Text = title
    bLbl.TextColor3 = self.Theme.TextDim
    bLbl.TextSize = 11
    bLbl.TextXAlignment = Enum.TextXAlignment.Left
    bLbl.Parent = bindRow
    local bBtn = Instance.new("TextButton")
    bBtn.Size = UDim2.new(0, 60, 0, 20)
    bBtn.Position = UDim2.new(1, -68, 0.5, -10)
    bBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    bBtn.Font = Enum.Font.GothamBold
    local keyName = (defaultKey == Enum.KeyCode.Unknown or not defaultKey) and "None" or (typeof(defaultKey) == "EnumItem" and defaultKey.Name or tostring(defaultKey))
    bBtn.Text = keyName
    bBtn.TextColor3 = self.Theme.TextPrimary
    bBtn.TextSize = 10
    bBtn.AutoButtonColor = false
    bBtn.Parent = bindRow
    self:Corner(bBtn, 5)
    self:Stroke(bBtn, Color3.fromRGB(40, 40, 52), 1)
    local function setVisual(newKey, fireCallback)
        local kn = (newKey == Enum.KeyCode.Unknown or not newKey) and "None" or (typeof(newKey) == "EnumItem" and newKey.Name or tostring(newKey))
        bBtn.Text = kn
        if fireCallback and callback then
            callback(newKey)
        end
    end
    local isListening = false
    bBtn.MouseButton1Click:Connect(function()
        isListening = true
        bBtn.Text = "..."
    end)
    self.Services.UserInputService.InputBegan:Connect(function(input)
        if isListening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local chosen = input.KeyCode
                if chosen == Enum.KeyCode.Escape or chosen == Enum.KeyCode.Backspace then
                    chosen = Enum.KeyCode.Unknown
                    bBtn.Text = "None"
                else
                    bBtn.Text = chosen.Name
                end
                isListening = false
                if callback then callback(chosen) end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.MouseButton2
                or input.UserInputType == Enum.UserInputType.MouseButton3 then
                bBtn.Text = input.UserInputType.Name
                isListening = false
                if callback then callback(input.UserInputType) end
            end
        end
    end)
    local regKey = configKey or (title:find("Menu") and "MenuKey" or (title:find("Shoot") and "ShootKey" or nil))
    if regKey and self.Controls and self.Controls.Keybinds then
        self.Controls.Keybinds[regKey] = setVisual
    end
    return bindRow
end
function Hub:BuildFarmTab(container)
    local leftCol, rightCol = self:CreateDualColumnPage(container)
    local farmSec = self:CreateSection(leftCol, "Auto Farm")
    self:CreateToggle(farmSec, "Auto Farm", self.Config.Toggles.AutoFarm, function(v)
        self.Config.Toggles.AutoFarm = v
        if not v then
            self:StopAutoFarm()
        end
    end)
    self:CreateDropdown(farmSec, "Farm Mode", { "Basic", "Down", "Teleport" }, self.Config.Values.AutoFarmMode or "Basic", function(v)
        self.Config.Values.AutoFarmMode = v
        if (v == "Basic" or v == "Teleport") and self.AutoFarm.WasDown then
            self.AutoFarm.WasDown = false
            self:ReturnToSurface()
        end
    end)
    self:CreateToggle(farmSec, "Avoid Murderer", self.Config.Toggles.AutoFarmAvoidMurder, function(v)
        self.Config.Toggles.AutoFarmAvoidMurder = v
        self.AutoFarm.Target = nil
    end)
    self:CreateToggle(farmSec, "Fling Murderer on Death", self.Config.Toggles.AutoFarmFlingMurderOnDeath, function(v)
        self.Config.Toggles.AutoFarmFlingMurderOnDeath = v
    end)
    self:CreateToggle(farmSec, "Auto Prestige", self.Config.Toggles.AutoPrestige, function(v)
        self.Config.Toggles.AutoPrestige = v
        if v then self:CheckAutoPrestige() end
    end)

    local bagSec = self:CreateSection(rightCol, "Full Bag & Safety")
    self:CreateToggle(bagSec, "Teleport to Lobby on Full Bag", self.Config.Toggles.AutoFarmSafeZone, function(v)
        self.Config.Toggles.AutoFarmSafeZone = v
    end)
    self:CreateToggle(bagSec, "Reset on Full Bag", self.Config.Toggles.AutoFarmAutoReset, function(v)
        self.Config.Toggles.AutoFarmAutoReset = v
    end)
    self:CreateToggle(bagSec, "Kill All on Full Bag", self.Config.Toggles.AutoFarmKillAllOnFull, function(v)
        self.Config.Toggles.AutoFarmKillAllOnFull = v
    end)
    self:CreateToggle(bagSec, "Shoot Murderer on Full Bag", self.Config.Toggles.AutoFarmShootMurdererOnFull, function(v)
        self.Config.Toggles.AutoFarmShootMurdererOnFull = v
    end)
end

function Hub:BuildCombatTab(container)
    local leftCol, rightCol = self:CreateDualColumnPage(container)
    local sheriffSec = self:CreateSection(leftCol, "Sheriff")
    self:CreateToggle(sheriffSec, "Silent Aim", self.Config.Toggles.SilentAim, function(v)
        self.Config.Toggles.SilentAim = v
    end)
    self:CreateToggle(sheriffSec, "Wallbang", self.Config.Toggles.AimWallbang, function(v)
        self.Config.Toggles.AimWallbang = v
    end)
    self:CreateToggle(sheriffSec, "Prediction", self.Config.Toggles.AimPrediction, function(v)
        self.Config.Toggles.AimPrediction = v
    end)
    self:CreateToggle(sheriffSec, "Bullet Tracers (Цепи)", self.Config.Toggles.BulletTracers, function(v)
        self.Config.Toggles.BulletTracers = v
    end, "BulletTracers")
    self:CreateToggle(sheriffSec, "Auto Shoot", self.Config.Toggles.AutoShotMurderer, function(v)
        self.Config.Toggles.AutoShotMurderer = v
    end)
    self:CreateToggle(sheriffSec, "Auto Grab", self.Config.Toggles.AutoGrabGun, function(v)
        self.Config.Toggles.AutoGrabGun = v
    end)
    self:CreateKeybind(sheriffSec, "Shoot Keybind", self.Config.ShootKey, function(key)
        self.Config.ShootKey = key
    end)

    local murdererSec = self:CreateSection(rightCol, "Murderer")
    self:CreateToggle(murdererSec, "Kill All", self.Config.Toggles.KillAll, function(v)
        self.Config.Toggles.KillAll = v
    end)
    self:CreateDropdown(murdererSec, "Kill All Mode", { "Classic", "Silent" }, self.Config.Values.KillAllMode, function(v)
        self.Config.Values.KillAllMode = v
    end)
    self:CreateToggle(murdererSec, "Kill Aura", self.Config.Toggles.KillAura, function(v)
        self.Config.Toggles.KillAura = v
    end)
    self:CreateDropdown(murdererSec, "Aura Mode", { "Classic", "Silent" }, self.Config.Values.KillMode, function(v)
        self.Config.Values.KillMode = v
    end)
    self:CreateSlider(murdererSec, "Aura Distance", 10, 45, self.Config.Values.KillAuraDist, "m", function(v)
        self.Config.Values.KillAuraDist = v
    end)
    self:CreateToggle(murdererSec, "Auto Kill Sheriff", self.Config.Toggles.AutoKillSheriff, function(v)
        self.Config.Toggles.AutoKillSheriff = v
    end)
    self:CreateDropdown(murdererSec, "Kill Sheriff Mode", { "Classic", "Silent" }, self.Config.Values.KillSheriffMode, function(v)
        self.Config.Values.KillSheriffMode = v
    end)
end
function Hub:BuildVisualsTab(container)
    local subBar = Instance.new("Frame")
    subBar.Name = "VisualSubTabs"
    subBar.Position = UDim2.new(0, 130, 0.5, -13)
    subBar.Size = UDim2.new(0, 290, 0, 26)
    subBar.BackgroundTransparency = 1
    subBar.Visible = (self.Config.ActiveTab == "Visuals")
    subBar.Parent = self.State.SubHeader or container
    self.State.VisualSubTabs = subBar
    local subLayout = Instance.new("UIListLayout")
    subLayout.FillDirection = Enum.FillDirection.Horizontal
    subLayout.Padding = UDim.new(0, 6)
    subLayout.SortOrder = Enum.SortOrder.LayoutOrder
    subLayout.Parent = subBar
    local pageESP = Instance.new("Frame")
    pageESP.Size = UDim2.new(1, 0, 1, 0)
    pageESP.Position = UDim2.new(0, 0, 0, 0)
    pageESP.BackgroundTransparency = 1
    pageESP.Parent = container
    local pageWorld = Instance.new("Frame")
    pageWorld.Size = UDim2.new(1, 0, 1, 0)
    pageWorld.Position = UDim2.new(0, 0, 0, 0)
    pageWorld.BackgroundTransparency = 1
    pageWorld.Visible = false
    pageWorld.Parent = container
    local visualTabs = { "ESP", "World" }
    local visualBtns = {}
    local function switchVisualSub(activeName)
        pageESP.Visible = (activeName == "ESP")
        pageWorld.Visible = (activeName == "World")
        for name, btn in pairs(visualBtns) do
            if name == activeName then
                btn.BackgroundColor3 = Color3.fromRGB(36, 36, 52)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                btn.TextColor3 = self.Theme.TextDim
            end
        end
    end
    for _, vName in ipairs(visualTabs) do
        local b = Instance.new("TextButton")
        b.Size = (vName == "ESP") and UDim2.new(0, 142, 1, 0) or UDim2.new(0, 134, 1, 0)
        b.BackgroundColor3 = (vName == "ESP") and Color3.fromRGB(36, 36, 52) or Color3.fromRGB(22, 22, 28)
        b.Text = (vName == "ESP") and "ESP (Players & Items)" or "World & Crosshair"
        b.Font = Enum.Font.GothamBold
        b.TextColor3 = (vName == "ESP") and Color3.fromRGB(255, 255, 255) or self.Theme.TextDim
        b.TextSize = 10
        b.AutoButtonColor = false
        b.Parent = subBar
        self:Corner(b, 6)
        self:Stroke(b, self.Theme.Border, 1)
        visualBtns[vName] = b
        b.MouseButton1Click:Connect(function()
            switchVisualSub(vName)
        end)
    end
    local leftColESP, rightColESP = self:CreateDualColumnPage(pageESP)
    local espSec = self:CreateSection(leftColESP, "ESP")
    self:CreateToggle(espSec, "ESP", self.Config.Toggles.ESPRoles, function(v)
        self.Config.Toggles.ESPRoles = v
        self:RenderESP()
    end)
    self:CreateToggle(espSec, "Only Roles", self.Config.Toggles.OnlyImportantRoles, function(v)
        self.Config.Toggles.OnlyImportantRoles = v
        self:RenderESP()
    end)
    self:CreateToggle(espSec, "Role Text", self.Config.Toggles.ESPRoleText, function(v)
        self.Config.Toggles.ESPRoleText = v
        self:RenderESP()
    end)
    self:CreateToggle(espSec, "Nicknames", self.Config.Toggles.ESPNickname, function(v)
        self.Config.Toggles.ESPNickname = v
        self:RenderESP()
    end)
    self:CreateToggle(espSec, "Distance", self.Config.Toggles.ESPDist, function(v)
        self.Config.Toggles.ESPDist = v
        self:RenderESP()
    end)
    self:CreateToggle(espSec, "2D Boxes", self.Config.Toggles.ESPBoxes, function(v)
        self.Config.Toggles.ESPBoxes = v
        if not v then
            for _, d in pairs(self.ESP.Drawings) do
                if d.Box then d.Box.Visible = false end
            end
        end
        self:RenderESP()
    end)
    self:CreateToggle(espSec, "Tracers", self.Config.Toggles.ESPTracers, function(v)
        self.Config.Toggles.ESPTracers = v
        if not v then
            for _, d in pairs(self.ESP.Drawings) do
                if d.Tracer then d.Tracer.Visible = false end
            end
        end
        self:RenderESP()
    end)
    self:CreateToggle(espSec, "Gun ESP", self.Config.Toggles.ESPGun, function(v)
        self.Config.Toggles.ESPGun = v
        if not v then
            self:ClearGunESP()
        end
        self:RenderESP()
    end)
    self:CreateToggle(espSec, "Local ESP", self.Config.Toggles.LocalESP, function(v)
        self.Config.Toggles.LocalESP = v
        self:UpdatePreviewLocalESP()
        self:RenderESP()
    end)
    local previewCard = self:CreateSection(rightColESP, "Character Preview")
    self:SetupPreview(previewCard)
    self:CreateToggle(previewCard, "Auto Rotation", self.Config.Toggles.PreviewRotate, function(v)
        self.Config.Toggles.PreviewRotate = v
    end)
    local leftColWorld, rightColWorld = self:CreateDualColumnPage(pageWorld)
    local crossSec = self:CreateSection(leftColWorld, "Custom Crosshair")
    self:CreateToggle(crossSec, "Enable Crosshair", self.Config.Toggles.CustomCrosshair, function(v)
        self.Config.Toggles.CustomCrosshair = v
        self:UpdateCrosshairGeometry()
    end)
    self:CreateToggle(crossSec, "Only With Gun (В руках)", self.Config.Toggles.CrosshairOnlyGun, function(v)
        self.Config.Toggles.CrosshairOnlyGun = v
    end)
    self:CreateToggle(crossSec, "Spinning Crosshair (Крутящийся)", self.Config.Toggles.CrosshairSpin, function(v)
        self.Config.Toggles.CrosshairSpin = v
    end)
    self:CreateToggle(crossSec, "Hide Default Crosshair", self.Config.Toggles.CrosshairHideDefault, function(v)
        self.Config.Toggles.CrosshairHideDefault = v
    end)
    self:CreateToggle(crossSec, "Center Dot", self.Config.Toggles.CrosshairDot, function(v)
        self.Config.Toggles.CrosshairDot = v
        self:UpdateCrosshairGeometry()
    end)
    self:CreateSlider(crossSec, "Spin Speed", 1, 10, self.Config.Values.CrosshairSpinSpeed, "x", function(v)
        self.Config.Values.CrosshairSpinSpeed = v
    end)
    self:CreateSlider(crossSec, "Size", 6, 24, self.Config.Values.CrosshairSize, "px", function(v)
        self.Config.Values.CrosshairSize = v
        self:UpdateCrosshairGeometry()
    end)
    self:CreateSlider(crossSec, "Thickness", 1, 5, self.Config.Values.CrosshairThickness, "px", function(v)
        self.Config.Values.CrosshairThickness = v
        self:UpdateCrosshairGeometry()
    end)
    self:CreateSlider(crossSec, "Gap", 1, 15, self.Config.Values.CrosshairGap, "px", function(v)
        self.Config.Values.CrosshairGap = v
        self:UpdateCrosshairGeometry()
    end)
    self:CreateDropdown(crossSec, "Color", { "Accent", "Sheriff Blue", "Murder Red", "Green", "White" }, self.Config.Values.CrosshairColor, function(v)
        self.Config.Values.CrosshairColor = v
        self:UpdateCrosshairGeometry()
    end)
    local worldSec = self:CreateSection(rightColWorld, "World & Visual Tweaks")
    self:CreateToggle(worldSec, "FullBright (ПНВ)", self.Config.Toggles.FullBright, function(v)
        self.Config.Toggles.FullBright = v
        self:ApplyWorldSettings()
    end)
    self:CreateToggle(worldSec, "No Fog (Без тумана)", self.Config.Toggles.NoFog, function(v)
        self.Config.Toggles.NoFog = v
        self:ApplyWorldSettings()
    end)
    self:CreateToggle(worldSec, "World Shadows", self.Config.Toggles.WorldShadows, function(v)
        self.Config.Toggles.WorldShadows = v
        self:ApplyWorldSettings()
    end)
    self:CreateToggle(worldSec, "X-Ray Wallhack", self.Config.Toggles.XRay, function(v)
        self.Config.Toggles.XRay = v
        if v then
            self:ApplyXRay(true)
        else
            self:DisableXRay()
        end
    end)
    self:CreateSlider(worldSec, "X-Ray Transparency", 30, 90, self.Config.Values.XRayTransparency, "%", function(v)
        self.Config.Values.XRayTransparency = v
        if self.Config.Toggles.XRay then
            self:ApplyXRay(true)
        end
    end)
    self:CreateSlider(worldSec, "Camera FOV", 50, 120, self.Config.Values.CameraFOV, "", function(v)
        self.Config.Values.CameraFOV = v
        self:ApplyWorldSettings()
    end)
    self:CreateSlider(worldSec, "Time of Day", 0, 24, self.Config.Values.ClockTime, "h", function(v)
        self.Config.Values.ClockTime = v
        self:ApplyWorldSettings()
    end)
    self:CreateDropdown(worldSec, "Atmosphere Tint", { "Default", "Midnight", "Warm Sunset", "Matrix Green", "Cyberpunk Violet" }, self.Config.Values.AmbientTint, function(v)
        self.Config.Values.AmbientTint = v
        self:ApplyWorldSettings()
    end)
end
function Hub:BuildMiscTab(container)
    local leftCol, rightCol = self:CreateDualColumnPage(container)
    local valSec = self:CreateSection(leftCol, "Supreme Values")
    self:CreateToggle(valSec, "Show Values", self.Config.Toggles.ShowSkinValues, function(st)
        self.Config.Toggles.ShowSkinValues = st
        self.Config.Toggles.ShowInventoryValues = st
        self.Config.Toggles.ShowTradeValues = st
        if not st then
            self:CleanValuesBadges()
        else
            self:UpdateInventoryValues()
            self:UpdateTradeValues()
        end
    end)
    local moveSec = self:CreateSection(leftCol, "Movement")
    self:CreateToggle(moveSec, "Speed Hack", self.Config.Toggles.SpeedHack, function(v)
        self.Config.Toggles.SpeedHack = v
        local hum = self.Services.Players.LocalPlayer.Character and self.Services.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v and self.Config.Values.WalkSpeed or 16 end
    end)
    self:CreateSlider(moveSec, "Speed Value", 16, 120, self.Config.Values.WalkSpeed, " ws", function(v)
        self.Config.Values.WalkSpeed = v
        if self.Config.Toggles.SpeedHack then
            local hum = self.Services.Players.LocalPlayer.Character and self.Services.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end
    end)
    self:CreateToggle(moveSec, "Infinite Jump", self.Config.Toggles.InfiniteJump, function(v)
        self.Config.Toggles.InfiniteJump = v
    end)
    self:CreateToggle(moveSec, "NoClip", self.Config.Toggles.NoClip, function(v)
        self.Config.Toggles.NoClip = v
        if not v then
            local char = self.Services.Players.LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end)
    self:CreateToggle(moveSec, "Walk Fling", self.Config.Toggles.WalkFling, function(v)
        self.Config.Toggles.WalkFling = v
    end)
    local utilSec = self:CreateSection(rightCol, "Utilities")
    self:CreateToggle(utilSec, "Anti-AFK (Anti-Kick)", self.Config.Toggles.AntiAFK, function(v)
        self.Config.Toggles.AntiAFK = v
    end, "AntiAFK")
    self:CreateToggle(utilSec, "Auto Rejoin on Kick", self.Config.Toggles.AutoRejoin, function(v)
        self.Config.Toggles.AutoRejoin = v
    end, "AutoRejoin")
    self:CreateToggle(utilSec, "Anti-Lag", self.Config.Toggles.PotatoOptimizer, function(v)
        self.Config.Toggles.PotatoOptimizer = v
        self:ApplyPotatoOptimizer(v)
    end)
    self:CreateToggle(utilSec, "Anti-Fling", self.Config.Toggles.AntiFling, function(v)
        self.Config.Toggles.AntiFling = v
    end)

    local extraSec = self:CreateSection(rightCol, "Extra Actions")
    self:CreateButton(extraSec, "Teleport to Lobby", function()
        self:TeleportToLobby(true)
    end)
    self:CreateButton(extraSec, "Teleport to Map", function()
        self:TeleportToMap()
    end)
end
Hub.BuildFunTab = Hub.BuildMiscTab
function Hub:BuildSkinsTab(container)
    local curSlot = "Gun"
    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1, 0, 0, 32)
    topRow.BackgroundTransparency = 1
    topRow.Parent = container

    -- Gun and Knife buttons on the LEFT
    local btnGun = Instance.new("TextButton")
    btnGun.Name = "Btn_Gun"
    btnGun.Position = UDim2.new(0, 0, 0, 0)
    btnGun.Size = UDim2.new(0, 85, 1, 0)
    btnGun.BackgroundColor3 = Color3.fromRGB(32, 28, 48)
    btnGun.Font = Enum.Font.GothamBold
    btnGun.Text = "Gun"
    btnGun.TextColor3 = Color3.fromRGB(240, 240, 255)
    btnGun.TextSize = 11
    btnGun.Parent = topRow
    self:Corner(btnGun, 6)
    local strokeGun = self:Stroke(btnGun, self.Theme.Accent, 1.5)

    local btnKnife = Instance.new("TextButton")
    btnKnife.Name = "Btn_Knife"
    btnKnife.Position = UDim2.new(0, 93, 0, 0)
    btnKnife.Size = UDim2.new(0, 85, 1, 0)
    btnKnife.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    btnKnife.Font = Enum.Font.GothamBold
    btnKnife.Text = "Knife"
    btnKnife.TextColor3 = Color3.fromRGB(140, 140, 155)
    btnKnife.TextSize = 11
    btnKnife.Parent = topRow
    self:Corner(btnKnife, 6)
    local strokeKnife = self:Stroke(btnKnife, Color3.fromRGB(30, 30, 42), 1)

    -- Search box on the RIGHT and smaller (width 155px)
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.AnchorPoint = Vector2.new(1, 0)
    searchBox.Position = UDim2.new(1, 0, 0, 0)
    searchBox.Size = UDim2.new(0, 155, 1, 0)
    searchBox.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    searchBox.Font = Enum.Font.Gotham
    searchBox.PlaceholderText = "Search skin..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(85, 85, 100)
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(240, 240, 255)
    searchBox.TextSize = 11
    searchBox.Parent = topRow
    self:Corner(searchBox, 6)
    self:Stroke(searchBox, Color3.fromRGB(32, 32, 44), 1)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, -40)
    scroll.Position = UDim2.new(0, 0, 0, 40)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 75)
    scroll.Parent = container

    local grid = Instance.new("UIGridLayout")
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = scroll

    -- Dynamically calculate CellSize so 5 columns fill 100% of the available width with ZERO blank right gap
    local function updateGrid()
        local w = scroll.AbsoluteSize.X
        if w < 100 then return end
        local pad = 8
        local cols = 5
        if w < 480 then cols = 4 end
        local totalPad = (cols - 1) * pad
        local cellW = math.floor((w - totalPad - 2) / cols)
        local cellH = math.floor(cellW * 1.22)
        grid.CellSize = UDim2.new(0, cellW, 0, cellH)
        grid.CellPadding = UDim2.new(0, pad, 0, pad)
    end
    scroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateGrid)
    task.defer(updateGrid)

    local function updateTabButtons()
        if curSlot == "Gun" then
            btnGun.BackgroundColor3 = Color3.fromRGB(32, 28, 48)
            btnGun.TextColor3 = Color3.fromRGB(240, 240, 255)
            strokeGun.Color = self.Theme.Accent
            strokeGun.Thickness = 1.5

            btnKnife.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
            btnKnife.TextColor3 = Color3.fromRGB(140, 140, 155)
            strokeKnife.Color = Color3.fromRGB(30, 30, 42)
            strokeKnife.Thickness = 1
        else
            btnKnife.BackgroundColor3 = Color3.fromRGB(32, 28, 48)
            btnKnife.TextColor3 = Color3.fromRGB(240, 240, 255)
            strokeKnife.Color = self.Theme.Accent
            strokeKnife.Thickness = 1.5

            btnGun.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
            btnGun.TextColor3 = Color3.fromRGB(140, 140, 155)
            strokeGun.Color = Color3.fromRGB(30, 30, 42)
            strokeGun.Thickness = 1
        end
    end

    local function refreshGrid()
        for _, ch in ipairs(scroll:GetChildren()) do
            if ch:IsA("GuiObject") then ch:Destroy() end
        end
        local list = (self.SkinSystem.BySlot and self.SkinSystem.BySlot[curSlot]) or {}
        local filter = searchBox.Text:lower():gsub("^%s+", ""):gsub("%s+$", "")
        for idx, rec in ipairs(list) do
            local sName = rec.name or (rec.meta and rec.meta.ItemName) or "Unknown"
            if filter == "" or sName:lower():find(filter, 1, true) then
                local isEquipped = (curSlot == "Gun" and self.SkinSystem.CurrentGun == sName) or (curSlot == "Knife" and self.SkinSystem.CurrentKnife == sName)
                local card = Instance.new("TextButton")
                card.Name = "Skin_" .. sName
                card.BackgroundColor3 = isEquipped and Color3.fromRGB(30, 25, 45) or Color3.fromRGB(16, 16, 22)
                card.Text = ""
                card.AutoButtonColor = false
                card.LayoutOrder = idx
                card.Parent = scroll
                self:Corner(card, 6)
                local strk = self:Stroke(card, isEquipped and self.Theme.Accent or Color3.fromRGB(30, 30, 40), isEquipped and 2 or 1)
                
                local img = Instance.new("ImageLabel")
                img.Size = UDim2.new(1, -10, 1, -40)
                img.Position = UDim2.new(0, 5, 0, 5)
                img.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
                local skinImg = (rec.meta and rec.meta.Image)
                    or (rec.tool and rec.tool.root and rec.tool.root.attrs and rec.tool.root.attrs.Image)
                    or (rec.tool and rec.tool.root and rec.tool.root.props and rec.tool.root.props.TextureId)
                    or (rec.display and rec.display.root and rec.display.root.props and rec.display.root.props.TextureID)
                    or Icons.Skins
                img.Image = skinImg
                img.ScaleType = Enum.ScaleType.Fit
                img.Parent = card
                self:Corner(img, 4)
                
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, -8, 0, 30)
                lbl.Position = UDim2.new(0, 4, 1, -34)
                lbl.BackgroundTransparency = 1
                lbl.Font = Enum.Font.GothamMedium
                lbl.Text = sName
                lbl.TextColor3 = isEquipped and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 195)
                lbl.TextSize = 10
                lbl.TextTruncate = Enum.TextTruncate.AtEnd
                lbl.TextWrapped = true
                lbl.Parent = card

                card.MouseButton1Click:Connect(function()
                    if isEquipped then
                        self:UnequipSkin(curSlot)
                    else
                        self:EquipSkin(sName)
                    end
                    refreshGrid()
                end)
            end
        end
        updateGrid()
        scroll.CanvasSize = UDim2.new(0, 0, 0, grid.AbsoluteContentSize.Y + 16)
    end

    btnGun.MouseButton1Click:Connect(function()
        curSlot = "Gun"
        updateTabButtons()
        refreshGrid()
    end)
    btnKnife.MouseButton1Click:Connect(function()
        curSlot = "Knife"
        updateTabButtons()
        refreshGrid()
    end)
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        refreshGrid()
    end)
    task.spawn(function()
        while not self.SkinSystem.Loaded do task.wait(0.5) end
        refreshGrid()
    end)
end
function Hub:BuildMapsTab(container)
    local dupSec = self:CreateSection(container, "Vote Duplicator (Дюп голосов)")
    self:CreateToggle(dupSec, "Enable Vote Duplicator", self.Config.Toggles.VoteDup, function(v)
        self.Config.Toggles.VoteDup = v
        if v then
            self.Maps.SelectedPad = nil
            self:UpdateMapCardsHighlight()
            self:StartVoteDuplicator()
        else
            self.Maps.SelectedPad = nil
            self:UpdateMapCardsHighlight()
        end
    end)
    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(1, 0, 0, 18)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Font = Enum.Font.GothamMedium
    statusLbl.Text = "Статус: Ожидание голосования..."
    statusLbl.TextColor3 = self.Theme.TextMuted
    statusLbl.TextSize = 11
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.Parent = dupSec
    self.Maps.StatusLabel = statusLbl
    local infoDesc = Instance.new("TextLabel")
    infoDesc.Size = UDim2.new(1, 0, 0, 20)
    infoDesc.BackgroundTransparency = 1
    infoDesc.Font = Enum.Font.Gotham
    infoDesc.Text = "Click any map card below to vote. With Duplicator ON, it will duplicate votes for that card."
    infoDesc.TextColor3 = self.Theme.TextDim
    infoDesc.TextSize = 10
    infoDesc.TextXAlignment = Enum.TextXAlignment.Left
    infoDesc.Parent = dupSec
    local cardsSec = self:CreateSection(container, "Active Voting Maps")
    local cardsRow = Instance.new("Frame")
    cardsRow.Size = UDim2.new(1, 0, 0, 160)
    cardsRow.BackgroundTransparency = 1
    cardsRow.Parent = cardsSec
    local rowLayout = Instance.new("UIListLayout")
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding = UDim.new(0, 8)
    rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rowLayout.Parent = cardsRow
    local padKeys = { "VotePad1", "VotePad2", "VotePad3" }
    for idx, padName in ipairs(padKeys) do
        local card = Instance.new("Frame")
        card.Name = "MapCard_" .. padName
        card.Size = UDim2.new(0, 142, 1, 0)
        card.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
        card.LayoutOrder = idx
        card.Parent = cardsRow
        self:Corner(card, 8)
        local cardStroke = self:Stroke(card, self.Theme.Border, 1)
        local img = Instance.new("ImageLabel")
        img.Name = "MapImage"
        img.Size = UDim2.new(1, -12, 0, 78)
        img.Position = UDim2.new(0, 6, 0, 6)
        img.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
        img.Image = self.Maps.Cached[padName].Image
        img.ScaleType = Enum.ScaleType.Crop
        img.Parent = card
        self:Corner(img, 6)
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Name = "MapName"
        nameLbl.Position = UDim2.new(0, 6, 0, 88)
        nameLbl.Size = UDim2.new(1, -12, 0, 18)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.Text = self.Maps.Cached[padName].MapName
        nameLbl.TextColor3 = self.Theme.TextPrimary
        nameLbl.TextSize = 12
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.TextXAlignment = Enum.TextXAlignment.Center
        nameLbl.Parent = card
        local voteLbl = Instance.new("TextLabel")
        voteLbl.Name = "VoteCount"
        voteLbl.Position = UDim2.new(0, 6, 0, 106)
        voteLbl.Size = UDim2.new(1, -12, 0, 16)
        voteLbl.BackgroundTransparency = 1
        voteLbl.Font = Enum.Font.GothamMedium
        voteLbl.Text = "Votes: " .. tostring(self.Maps.Cached[padName].Votes)
        voteLbl.TextColor3 = self.Theme.TextDim
        voteLbl.TextSize = 11
        voteLbl.TextXAlignment = Enum.TextXAlignment.Center
        voteLbl.Parent = card
        local actionBtn = Instance.new("TextButton")
        actionBtn.Size = UDim2.new(1, -16, 0, 24)
        actionBtn.Position = UDim2.new(0, 8, 1, -30)
        actionBtn.BackgroundColor3 = self.Theme.CardHover
        actionBtn.Font = Enum.Font.GothamBold
        actionBtn.Text = "Vote"
        actionBtn.TextColor3 = self.Theme.TextPrimary
        actionBtn.TextSize = 10
        actionBtn.AutoButtonColor = false
        actionBtn.Parent = card
        self:Corner(actionBtn, 5)
        local function handleCardClick()
            if self.Config.Toggles.VoteDup then
                self.Maps.SelectedPad = padName
                self:UpdateMapCardsHighlight()
                if not self.Maps.DupRunning then
                    self:StartVoteDuplicator()
                end
            else
                self:TeleportToPad(padName)
            end
        end
        actionBtn.MouseButton1Click:Connect(handleCardClick)
        local clickCatcher = Instance.new("TextButton")
        clickCatcher.Size = UDim2.new(1, 0, 1, -34)
        clickCatcher.BackgroundTransparency = 1
        clickCatcher.Text = ""
        clickCatcher.Parent = card
        clickCatcher.MouseButton1Click:Connect(handleCardClick)
        self.Maps.Cards[padName] = {
            Card = card,
            CardStroke = cardStroke,
            Image = img,
            NameLabel = nameLbl,
            VoteLabel = voteLbl,
            Button = actionBtn,
        }
    end
    local allMaps = {
        "Bank", "Bio Lab", "Factory", "Hospital", "Hotel",
        "House", "Mansion", "MilBase", "Mineshaft", "Police Station",
        "Research Facility", "Workplace", "Office", "Barn", "Log Cabin", "Workshop"
    }
    self.Maps.Priorities = self.Maps.Priorities or {}
    local prioSec = self:CreateSection(container, "Map Voting Priorities (Приоритеты 0-10)")
    local prioScroll = Instance.new("ScrollingFrame")
    prioScroll.Size = UDim2.new(1, 0, 0, 125)
    prioScroll.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    prioScroll.BorderSizePixel = 0
    prioScroll.ScrollBarThickness = 3
    prioScroll.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 65)
    prioScroll.Parent = prioSec
    self:Corner(prioScroll, 6)
    self:Stroke(prioScroll, Color3.fromRGB(28, 28, 38), 1)

    local pGrid = Instance.new("UIGridLayout")
    pGrid.CellSize = UDim2.new(0.5, -6, 0, 26)
    pGrid.CellPadding = UDim2.new(0, 6, 0, 4)
    pGrid.Parent = prioScroll

    for _, mapName in ipairs(allMaps) do
        if self.Maps.Priorities[mapName] == nil then
            self.Maps.Priorities[mapName] = 5
        end
        local mRow = Instance.new("Frame")
        mRow.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        mRow.Parent = prioScroll
        self:Corner(mRow, 4)
        local mLbl = Instance.new("TextLabel")
        mLbl.Size = UDim2.new(1, -70, 1, 0)
        mLbl.Position = UDim2.new(0, 6, 0, 0)
        mLbl.BackgroundTransparency = 1
        mLbl.Font = Enum.Font.GothamMedium
        mLbl.Text = mapName
        mLbl.TextColor3 = Color3.fromRGB(210, 215, 225)
        mLbl.TextSize = 10
        mLbl.TextXAlignment = Enum.TextXAlignment.Left
        mLbl.Parent = mRow

        local prioLbl = Instance.new("TextLabel")
        prioLbl.Size = UDim2.new(0, 20, 1, 0)
        prioLbl.Position = UDim2.new(1, -44, 0, 0)
        prioLbl.BackgroundTransparency = 1
        prioLbl.Font = Enum.Font.GothamBold
        prioLbl.Text = tostring(self.Maps.Priorities[mapName])
        prioLbl.TextColor3 = self.Theme.Accent
        prioLbl.TextSize = 11
        prioLbl.Parent = mRow

        local minusBtn = Instance.new("TextButton")
        minusBtn.Size = UDim2.new(0, 18, 0, 18)
        minusBtn.Position = UDim2.new(1, -64, 0.5, -9)
        minusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        minusBtn.Font = Enum.Font.GothamBold
        minusBtn.Text = "-"
        minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        minusBtn.TextSize = 12
        minusBtn.Parent = mRow
        self:Corner(minusBtn, 3)

        local plusBtn = Instance.new("TextButton")
        plusBtn.Size = UDim2.new(0, 18, 0, 18)
        plusBtn.Position = UDim2.new(1, -22, 0.5, -9)
        plusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        plusBtn.Font = Enum.Font.GothamBold
        plusBtn.Text = "+"
        plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        plusBtn.TextSize = 12
        plusBtn.Parent = mRow
        self:Corner(plusBtn, 3)

        minusBtn.MouseButton1Click:Connect(function()
            local cur = self.Maps.Priorities[mapName] or 0
            if cur > 0 then
                self.Maps.Priorities[mapName] = cur - 1
                prioLbl.Text = tostring(cur - 1)
            end
        end)
        plusBtn.MouseButton1Click:Connect(function()
            local cur = self.Maps.Priorities[mapName] or 0
            if cur < 10 then
                self.Maps.Priorities[mapName] = cur + 1
                prioLbl.Text = tostring(cur + 1)
            end
        end)
    end
    prioScroll.CanvasSize = UDim2.new(0, 0, 0, (math.ceil(#allMaps / 2) * 30) + 10)

    task.spawn(function()
        while self.State.Gui and self.State.Gui.Parent do
            if self.State.IsOpen and (self.Config.ActiveTab == "Maps") then
                local maps = self:ScanMaps()
                local isVoting = self:IsVotingActive()
                if not isVoting then
                    if not self.Config.Toggles.VoteDup and self.Maps.SelectedPad ~= nil then
                        self.Maps.SelectedPad = nil
                        self:UpdateMapCardsHighlight()
                    end
                    if self.Maps.StatusLabel then
                        self.Maps.StatusLabel.Text = "Статус: Ожидание голосования..."
                        self.Maps.StatusLabel.TextColor3 = self.Theme.TextMuted
                    end
                else
                    if self.Config.Toggles.VoteDup then
                        local bestPad = nil
                        local bestPriority = 0
                        for _, m in ipairs(maps) do
                            for mName, prio in pairs(self.Maps.Priorities or {}) do
                                if prio > bestPriority and m.MapName:lower():find(mName:lower(), 1, true) then
                                    bestPriority = prio
                                    bestPad = m.PadName
                                end
                            end
                        end
                        if bestPad and self.Maps.SelectedPad ~= bestPad then
                            self.Maps.SelectedPad = bestPad
                            self:UpdateMapCardsHighlight()
                        end
                    end
                end
                for _, m in ipairs(maps) do
                    local uiCard = self.Maps.Cards[m.PadName]
                    if uiCard then
                        if m.Image and m.Image ~= "" then
                            uiCard.Image.Image = m.Image
                        end
                        uiCard.NameLabel.Text = m.MapName
                        uiCard.VoteLabel.Text = "Votes: " .. tostring(m.Votes)
                    end
                end
                task.wait(0.5)
            else
                task.wait(1.5)
            end
        end
    end)
end
function Hub:ResolveAnimationId(assetId)
    local rawId = tostring(assetId)
    local ok, objs = pcall(game.GetObjects, game, "rbxassetid://" .. rawId)
    if ok and objs and #objs > 0 then
        for _, obj in ipairs(objs) do
            if obj:IsA("Animation") and obj.AnimationId ~= "" then
                return obj.AnimationId
            end
            local found = obj:FindFirstChildWhichIsA("Animation", true)
            if found and found.AnimationId ~= "" then
                return found.AnimationId
            end
        end
    end
    return "rbxassetid://" .. rawId
end
function Hub:BuildAnimationTab(container)
    local topPanel = Instance.new("Frame")
    topPanel.Size = UDim2.new(1, 0, 0, 76)
    topPanel.BackgroundTransparency = 1
    topPanel.Parent = container
    local searchBar = Instance.new("TextBox")
    searchBar.Size = UDim2.new(1, -225, 0, 30)
    searchBar.BackgroundColor3 = self.Theme.CardBg
    searchBar.PlaceholderText = "Search animations & emotes..."
    searchBar.PlaceholderColor3 = self.Theme.TextMuted
    searchBar.Text = ""
    searchBar.Font = Enum.Font.GothamMedium
    searchBar.TextColor3 = self.Theme.TextPrimary
    searchBar.TextSize = 11
    searchBar.TextXAlignment = Enum.TextXAlignment.Left
    searchBar.Parent = topPanel
    self:Corner(searchBar, 6)
    self:Stroke(searchBar, self.Theme.Border, 1)
    local searchPad = Instance.new("UIPadding")
    searchPad.PaddingLeft = UDim.new(0, 10)
    searchPad.Parent = searchBar
    local walkBtn = Instance.new("TextButton")
    walkBtn.Size = UDim2.new(0, 110, 0, 30)
    walkBtn.Position = UDim2.new(1, -215, 0, 0)
    walkBtn.BackgroundColor3 = self.Animations.EmoteWalk and Color3.fromRGB(25, 45, 30) or Color3.fromRGB(24, 24, 32)
    walkBtn.Text = self.Animations.EmoteWalk and "Emote Walk: ON" or "Emote Walk: OFF"
    walkBtn.Font = Enum.Font.GothamBold
    walkBtn.TextColor3 = self.Animations.EmoteWalk and Color3.fromRGB(90, 240, 120) or self.Theme.TextDim
    walkBtn.TextSize = 10
    walkBtn.AutoButtonColor = false
    walkBtn.Parent = topPanel
    self:Corner(walkBtn, 6)
    self:Stroke(walkBtn, self.Animations.EmoteWalk and Color3.fromRGB(40, 80, 50) or self.Theme.Border, 1)
    walkBtn.MouseButton1Click:Connect(function()
        self.Animations.EmoteWalk = not self.Animations.EmoteWalk
        walkBtn.Text = self.Animations.EmoteWalk and "Emote Walk: ON" or "Emote Walk: OFF"
        walkBtn.BackgroundColor3 = self.Animations.EmoteWalk and Color3.fromRGB(25, 45, 30) or Color3.fromRGB(24, 24, 32)
        walkBtn.TextColor3 = self.Animations.EmoteWalk and Color3.fromRGB(90, 240, 120) or self.Theme.TextDim
        walkBtn.BorderColor3 = self.Animations.EmoteWalk and Color3.fromRGB(40, 80, 50) or self.Theme.Border
    end)
    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0, 95, 0, 30)
    stopBtn.Position = UDim2.new(1, -95, 0, 0)
    stopBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 25)
    stopBtn.Text = "Stop Anim"
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextColor3 = Color3.fromRGB(255, 90, 100)
    stopBtn.TextSize = 10
    stopBtn.AutoButtonColor = false
    stopBtn.Parent = topPanel
    self:Corner(stopBtn, 6)
    stopBtn.MouseButton1Click:Connect(function()
        self:StopAnimation()
    end)
    local subTabs = Instance.new("Frame")
    subTabs.Size = UDim2.new(1, 0, 0, 28)
    subTabs.Position = UDim2.new(0, 0, 0, 40)
    subTabs.BackgroundTransparency = 1
    subTabs.Parent = topPanel
    local subLayout = Instance.new("UIListLayout")
    subLayout.FillDirection = Enum.FillDirection.Horizontal
    subLayout.Padding = UDim.new(0, 8)
    subLayout.Parent = subTabs
    local cats = { "Animations", "Emotes", "Favorites" }
    local subBtns = {}
    for _, cat in ipairs(cats) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 130, 1, 0)
        b.BackgroundColor3 = (cat == "Animations") and Color3.fromRGB(35, 35, 48) or Color3.fromRGB(18, 18, 24)
        local labelName = (cat == "Animations") and "Walk Animations" or (cat == "Emotes" and "Emotes (Walkable)" or "Favorites")
        b.Text = labelName
        b.Font = Enum.Font.GothamBold
        b.TextColor3 = (cat == "Animations") and Color3.fromRGB(255, 255, 255) or self.Theme.TextDim
        b.TextSize = 10
        b.AutoButtonColor = false
        b.Parent = subTabs
        self:Corner(b, 5)
        subBtns[cat] = b
        b.MouseButton1Click:Connect(function()
            self.Animations.ActiveTab = cat
            for cName, cBtn in pairs(subBtns) do
                if cName == cat then
                    cBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
                    cBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    cBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
                    cBtn.TextColor3 = self.Theme.TextDim
                end
            end
            self:RenderAnimationList()
        end)
    end
    local gridScroll = Instance.new("ScrollingFrame")
    gridScroll.Position = UDim2.new(0, 0, 0, 84)
    gridScroll.Size = UDim2.new(1, 0, 1, -84)
    gridScroll.BackgroundTransparency = 1
    gridScroll.BorderSizePixel = 0
    gridScroll.ScrollBarThickness = 3
    gridScroll.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 65)
    gridScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    gridScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    gridScroll.Parent = container
    self.Animations.ListContainer = gridScroll
    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.new(0, 134, 0, 150)
    grid.CellPadding = UDim2.new(0, 10, 0, 10)
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = gridScroll
    searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        self.Animations.SearchQuery = searchBar.Text:lower()
        self:RenderAnimationList()
    end)
    self:RenderAnimationList()
end
function Hub:RenderAnimationList()
    local container = self.Animations.ListContainer
    if not container then return end
    for _, c in ipairs(container:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    local tab = self.Animations.ActiveTab
    local q = self.Animations.SearchQuery
    for _, anim in ipairs(self.Animations.List) do
        local matchesTab = (tab == "Favorites" and self.Animations.Favorites[anim.Id]) or (anim.Category == tab)
        local matchesSearch = (q == "") or (anim.Name:lower():find(q) ~= nil)
        if matchesTab and matchesSearch then
            local card = Instance.new("Frame")
            card.BackgroundColor3 = self.Theme.CardBg
            card.Parent = container
            self:Corner(card, 8)
            self:Stroke(card, self.Theme.Border, 1)
            local thumb = Instance.new("ImageLabel")
            thumb.Size = UDim2.new(1, -12, 0, 80)
            thumb.Position = UDim2.new(0, 6, 0, 6)
            thumb.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
            thumb.Image = anim.Icon
            thumb.ScaleType = Enum.ScaleType.Fit
            thumb.Parent = card
            self:Corner(thumb, 6)
            local starBtn = Instance.new("ImageButton")
            starBtn.Size = UDim2.new(0, 18, 0, 18)
            starBtn.Position = UDim2.new(1, -24, 0, 8)
            starBtn.BackgroundTransparency = 1
            starBtn.Image = self.Animations.Favorites[anim.Id] and Icons.StarFilled or Icons.StarOutline
            starBtn.ImageColor3 = self.Animations.Favorites[anim.Id] and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(180, 180, 190)
            starBtn.Parent = card
            starBtn.MouseButton1Click:Connect(function()
                self.Animations.Favorites[anim.Id] = not self.Animations.Favorites[anim.Id]
                starBtn.Image = self.Animations.Favorites[anim.Id] and Icons.StarFilled or Icons.StarOutline
                starBtn.ImageColor3 = self.Animations.Favorites[anim.Id] and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(180, 180, 190)
                if tab == "Favorites" then self:RenderAnimationList() end
            end)
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -12, 0, 24)
            title.Position = UDim2.new(0, 6, 0, 90)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamMedium
            title.Text = anim.Name
            title.TextColor3 = self.Theme.TextPrimary
            title.TextSize = 10
            title.TextWrapped = true
            title.Parent = card
            local playBtn = Instance.new("TextButton")
            playBtn.Size = UDim2.new(1, -12, 0, 22)
            playBtn.Position = UDim2.new(0, 6, 1, -28)
            playBtn.BackgroundColor3 = self.Theme.CardHover
            playBtn.Font = Enum.Font.GothamBold
            playBtn.Text = "Play"
            playBtn.TextColor3 = self.Theme.TextPrimary
            playBtn.TextSize = 10
            playBtn.AutoButtonColor = false
            playBtn.Parent = card
            self:Corner(playBtn, 5)
            playBtn.MouseButton1Click:Connect(function()
                self:PlayCatalogAnimation(anim.Id, anim.Category)
            end)
        end
    end
end
function Hub:BuildConfigTab(container)
    local leftCol, rightCol = self:CreateDualColumnPage(container)
    local cfgSec = Instance.new("Frame")
    cfgSec.Name = "Card_Configs"
    cfgSec.Size = UDim2.new(1, 0, 0, 0)
    cfgSec.AutomaticSize = Enum.AutomaticSize.Y
    cfgSec.BackgroundColor3 = self.Theme.CardBg
    cfgSec.BorderSizePixel = 0
    cfgSec.Parent = leftCol
    self:Corner(cfgSec, 12)
    self:Stroke(cfgSec, self.Theme.Border, 1)
    local secPad = Instance.new("UIPadding")
    secPad.PaddingTop = UDim.new(0, 10)
    secPad.PaddingBottom = UDim.new(0, 10)
    secPad.PaddingLeft = UDim.new(0, 12)
    secPad.PaddingRight = UDim.new(0, 12)
    secPad.Parent = cfgSec
    local secLayout = Instance.new("UIListLayout")
    secLayout.Padding = UDim.new(0, 8)
    secLayout.SortOrder = Enum.SortOrder.LayoutOrder
    secLayout.Parent = cfgSec
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
    listContainer.Size = UDim2.new(1, 0, 0, 146)
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
        btn.Parent = iconsRow
        self:Corner(btn, 6)
        local stroke = self:Stroke(btn, Color3.fromRGB(34, 34, 44), 1)
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, 16, 0, 16)
        img.Position = UDim2.new(0.5, -8, 0.5, -8)
        img.BackgroundTransparency = 1
        img.Image = iconAsset
        img.ImageColor3 = Color3.fromRGB(215, 215, 225)
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
        local rawConfigs = self:GetConfigsList()
        local configs = {}
        for _, c in ipairs(rawConfigs) do
            if c:lower() ~= "default" then
                table.insert(configs, c)
            end
        end
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
                updateAutoloadBtnVisual()
                refreshConfigList()
            end)
        end
    end
    saveBtn.MouseButton1Click:Connect(function()
        local name = nameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if name == "" then return end
        local ok, msg = self:SaveConfig(name)
        if ok then
            self.State.CurrentConfigName = name
            if self.State.CurrentConfigLabel then self.State.CurrentConfigLabel.Text = name end
            refreshConfigList()
            updateAutoloadBtnVisual()
        end
    end)
    loadBtn.MouseButton1Click:Connect(function()
        local name = nameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if name == "" then return end
        local ok, msg = self:LoadConfig(name)
        if ok then
            self.State.CurrentConfigName = name
            if self.State.CurrentConfigLabel then self.State.CurrentConfigLabel.Text = name end
            refreshConfigList()
            updateAutoloadBtnVisual()
        end
    end)
    autoBtn.MouseButton1Click:Connect(function()
        local name = nameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if name == "" then return end
        local autoName, isAuto = self:GetAutoload()
        if isAuto and autoName == name then
            self:SetAutoload(name, false)
            self:Notify("Autoload Removed", "Config '" .. name .. "' will not autoload.", 2)
        else
            local path = self:GetConfigFilePath(name)
            local isf = isfile or (syn and syn.isfile)
            if not (isf and isf(path)) then
                self:SaveConfig(name)
            end
            self:SetAutoload(name, true)
            self:Notify("Autoload Set", "Config '" .. name .. "' will autoload on start!", 2.5)
        end
        refreshConfigList()
        updateAutoloadBtnVisual()
    end)
    delBtn.MouseButton1Click:Connect(function()
        local name = nameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if name == "" then return end
        local ok, msg = self:DeleteConfig(name)
        if ok then
            nameBox.Text = ""
            refreshConfigList()
            updateAutoloadBtnVisual()
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
    local menuSec = self:CreateSection(rightCol, "Interface & HUD")
    self:CreateToggle(menuSec, "Watermark HUD", self.Config.Toggles.Watermark, function(v)
        self.Config.Toggles.Watermark = v
        if self.State.Watermark then
            if v then
                self:UpdateWatermarkValues()
            end
            self.State.Watermark.Visible = v
        end
    end, "Watermark")
    self:CreateKeybind(menuSec, "Toggle Menu Key", self.Config.MenuKey, function(key)
        self.Config.MenuKey = key
        if self.State.TopBarKeybindBtn and key and key.Name then
            self.State.TopBarKeybindBtn.Text = "[ " .. key.Name .. " ]"
        end
    end, "MenuKey")
    local colorSec = self:CreateSection(rightCol, "Colors & Palettes (Палитры)")
    local palettes = {
        { Name = "UI Accent", Key = "Accent", Desc = "Основной акцент кнопок и меню", Def = self.Theme.Accent },
        { Name = "Gun Drop ESP", Key = "GunDrop", Desc = "Подсветка пистолета на полу", Def = self.Theme.HeroYellow },
        { Name = "Bullet Tracers", Key = "BulletTracers", Desc = "Цвет линий трассеров пуль", Def = Color3.fromRGB(255, 215, 60) },
        { Name = "Watermark", Key = "Watermark", Desc = "Цвет текста вотермарки FPS", Def = Color3.fromRGB(200, 205, 215) },
    }
    local quickColors = {
        Color3.fromRGB(255, 65, 85),
        Color3.fromRGB(50, 150, 255),
        Color3.fromRGB(40, 240, 90),
        Color3.fromRGB(255, 215, 60),
        Color3.fromRGB(255, 130, 45),
        Color3.fromRGB(180, 80, 255),
        Color3.fromRGB(255, 100, 200),
        Color3.fromRGB(0, 230, 255),
        Color3.fromRGB(255, 255, 255),
    }
    for _, pal in ipairs(palettes) do
        local crow = Instance.new("Frame")
        crow.Size = UDim2.new(1, 0, 0, 36)
        crow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        crow.Parent = colorSec
        self:Corner(crow, 6)
        self:Stroke(crow, Color3.fromRGB(30, 30, 40), 1)
        local ctitle = Instance.new("TextLabel")
        ctitle.Size = UDim2.new(1, -28, 0, 14)
        ctitle.Position = UDim2.new(0, 8, 0, 2)
        ctitle.BackgroundTransparency = 1
        ctitle.Font = Enum.Font.GothamBold
        ctitle.Text = pal.Name .. " — " .. pal.Desc
        ctitle.TextColor3 = Color3.fromRGB(220, 225, 235)
        ctitle.TextSize = 10
        ctitle.TextXAlignment = Enum.TextXAlignment.Left
        ctitle.Parent = crow
        local previewDot = Instance.new("Frame")
        previewDot.Size = UDim2.new(0, 12, 0, 12)
        previewDot.Position = UDim2.new(1, -18, 0, 4)
        previewDot.BackgroundColor3 = self.Theme[pal.Key] or pal.Def
        previewDot.Parent = crow
        self:Corner(previewDot, 6)
        local btnRow = Instance.new("Frame")
        btnRow.Size = UDim2.new(1, -16, 0, 14)
        btnRow.Position = UDim2.new(0, 8, 0, 18)
        btnRow.BackgroundTransparency = 1
        btnRow.Parent = crow
        local btnLay = Instance.new("UIListLayout")
        btnLay.FillDirection = Enum.FillDirection.Horizontal
        btnLay.Padding = UDim.new(0, 6)
        btnLay.Parent = btnRow
        for _, clr in ipairs(quickColors) do
            local dot = Instance.new("TextButton")
            dot.Size = UDim2.new(0, 14, 0, 14)
            dot.BackgroundColor3 = clr
            dot.Text = ""
            dot.AutoButtonColor = false
            dot.Parent = btnRow
            self:Corner(dot, 3)
            dot.MouseButton1Click:Connect(function()
                self.Theme[pal.Key] = clr
                previewDot.BackgroundColor3 = clr
                if pal.Key == "Accent" and self.State.SubHeaderIcon then
                    self.State.SubHeaderIcon.ImageColor3 = clr
                end
            end)
        end
    end
    local actSec = self:CreateSection(rightCol, "Script Control")
    self:CreateButton(actSec, "Rejoin", function()
        self:RejoinServer()
    end)
    local unloadBtn = self:CreateButton(actSec, "Unload Script (Clean Exit)", function()
        self:Unload()
    end)
    unloadBtn.TextColor3 = Color3.fromRGB(255, 90, 100)
    unloadBtn.BackgroundColor3 = Color3.fromRGB(45, 18, 24)
end
function Hub:ToggleMenu(state)
    if state == nil then state = not self.State.IsOpen end
    self.State.IsOpen = state
    local targetSize = self.State.WindowSize or UDim2.new(0, 720, 0, 500)
    if state then
        self.State.MainFrame.Visible = true
        if self.State.Shadow then self.State.Shadow.Visible = true end
        self:Tween(self.State.MainFrame, { Size = targetSize }, 0.25)
        if self.State.SidePanelOpen and self.State.SidePanel then
            self:UpdateSidePanelPosition()
            self.State.SidePanel.Visible = true
            self:Tween(self.State.SidePanel, { BackgroundTransparency = 0 }, 0.2)
        end
    else
        if self.State.Shadow then self.State.Shadow.Visible = false end
        if self.State.SidePanel then self.State.SidePanel.Visible = false end
        if self.State.SideTooltip then self.State.SideTooltip.Visible = false end
        local tw = self:Tween(self.State.MainFrame, { Size = UDim2.new(0, targetSize.X.Offset, 0, 0) }, 0.2)
        tw.Completed:Connect(function()
            if not self.State.IsOpen then
                self.State.MainFrame.Visible = false
            end
        end)
    end
end
function Hub:SetupWindowDragging()
    local drag = { Dragging = false, Start = Vector3.new(0, 0, 0), Pos = UDim2.new() }
    local topbar = self.State.TopBar
    local main = self.State.MainFrame
    local shadow = self.State.Shadow
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag.Dragging = true
            drag.Start = input.Position
            drag.Pos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    drag.Dragging = false
                end
            end)
        end
    end)
    self.Services.UserInputService.InputChanged:Connect(function(input)
        if drag.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - drag.Start
            local newPos = UDim2.new(
                drag.Pos.X.Scale,
                drag.Pos.X.Offset + delta.X,
                drag.Pos.Y.Scale,
                drag.Pos.Y.Offset + delta.Y
            )
            main.Position = newPos
            if shadow then shadow.Position = newPos end
            self:UpdateSidePanelPosition()
        end
    end)
end
function Hub:IsMouseOverGui()
    if not (self.State.Gui and self.State.Gui.Parent and self.State.Gui.Enabled) then
        return false
    end
    local main = self.State.Main
    if not (main and main.Visible) then
        return false
    end
    local mouse = self.Services.Players.LocalPlayer:GetMouse()
    local mx, my = mouse.X, mouse.Y
    local pos = main.AbsolutePosition
    local size = main.AbsoluteSize
    if mx >= pos.X and mx <= (pos.X + size.X) and my >= pos.Y and my <= (pos.Y + size.Y) then
        return true
    end
    return false
end
function Hub:SetupKeybinds()
    self.Services.UserInputService.InputBegan:Connect(function(input, gp)
        if self.Config.IsListeningMenuKey then return end
        if input.KeyCode == self.Config.MenuKey then
            self:ToggleMenu()
            return
        end
        if self.Config.IsListeningShootKey then return end
        if self.Config.ShootKey and self.Config.ShootKey ~= Enum.KeyCode.Unknown then
            if input.KeyCode == self.Config.ShootKey or input.UserInputType == self.Config.ShootKey then
                self:ShootMurderer(self.Config.Toggles.AimWallbang, self.Config.Toggles.AimPrediction, false)
                return
            end
        end
        -- Mouse shooting: execute identical high-precision shot as the bind when Gun is held
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not gp then
            if self.Config.Toggles.SilentAim and self:IsRoundActive() then
                local lp = self.Services.Players.LocalPlayer
                local char = lp and lp.Character
                local gun = self:FindGun()
                if gun and char and (gun.Parent == char or char:FindFirstChild("Gun") or char:FindFirstChildWhichIsA("Tool")) then
                    if (os.clock() - self.Combat.LastShot) >= 0.25 then
                        self:ShootMurderer(self.Config.Toggles.AimWallbang, self.Config.Toggles.AimPrediction, false)
                    end
                end
            end
        end
    end)
    self.Services.UserInputService.JumpRequest:Connect(function()
        if self.Config.Toggles.InfiniteJump then
            local hum = self.Services.Players.LocalPlayer.Character and self.Services.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end

Hub:Init()


_G.DynamicHub = Hub
if getgenv then pcall(function() getgenv().DynamicHub = Hub end) end
pcall(function() shared.DynamicHub = Hub end)
return Hub
