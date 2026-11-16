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
        VirtualUser = (function()
            local vu = nil
            pcall(function() vu = cloneref(game:GetService("VirtualUser")) end)
            return vu
        end)(),
        VirtualInputManager = (function()
            local vim = nil
            pcall(function() vim = cloneref(game:GetService("VirtualInputManager")) end)
            return vim
        end)(),
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
        AntiAFK = false,
        AutoRejoinOnKick = true,
        AutoClaimBooth = false,
        AutoTpToMyBooth = true,
        AutoServerHop = false,
        MinPlayersThreshold = 6,
        EspMyBooth = false,
        MyBoothTracer = false,
        EspBooths = false,
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
        WindowSize = UDim2.new(0, 620, 0, 430),
        IsRejoining = false,
        IsServerHopping = false,
        AntiAfkConn = nil,
        SelectedConfig = "",
        SessionProfit = 0,
        SoldHistory = {},
        EspFolder = nil,
        MyBoothHighlight = nil,
        MyBoothBillboard = nil,
        MyBoothBeam = nil,
        MyBoothAtt0 = nil,
        MyBoothAtt1 = nil,
        LastSelectedBoothItem = "",
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

-- LOGO ASSET LOADER
function Hub:GetLogoAsset()
    local rawUrl = "https://raw.githubusercontent.com/Lisi-prime/Dynamic-Hub/main/Dynamic_logo.png"
    local customFn = getcustomasset or getsynasset or (syn and syn.get_custom_asset)
    local writeFn = writefile
    local isfileFn = isfile
    local req = (syn and syn.request) or (http and http.request) or request or http_request

    if type(customFn) == "function" and type(writeFn) == "function" then
        local fileName = "dynamic_hub_logo.png"
        if type(isfileFn) == "function" and isfileFn(fileName) then
            local ok, asset = pcall(customFn, fileName)
            if ok and asset then return asset end
        end

        if type(req) == "function" then
            local ok, res = pcall(req, { Url = rawUrl, Method = "GET" })
            if ok and res and (res.StatusCode == 200 or res.Success) and res.Body and #res.Body > 200 then
                pcall(writeFn, fileName, res.Body)
                local assetOk, assetId = pcall(customFn, fileName)
                if assetOk and assetId then
                    pcall(function()
                        local holder = Instance.new("ImageLabel")
                        holder.Image = assetId
                        Hub.Services.ContentProvider:PreloadAsync({ holder })
                        holder:Destroy()
                    end)
                    return assetId
                end
            end
        end
    end
    return rawUrl
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
        -- Only trigger on genuine kick or disconnect errors, never on normal teleport fails
        if lower:find("teleport failed") then return end
        if lower:find("kick") or lower:find("disconnect") or lower:find("lost connection") or lower:find("idle") or lower:find("267") or lower:find("268") or lower:find("277") then
            self:TriggerRejoin("GuiService Kick: " .. msg)
        end
    end)
    table.insert(self.State.Connections, errConn)

    pcall(function()
        local rPrompt = self.Services.CoreGui:FindFirstChild("RobloxPromptGui")
        if rPrompt then
            local overlay = rPrompt:FindFirstChild("promptOverlay")
            if overlay then
                local promptConn = overlay.ChildAdded:Connect(function(child)
                    if not self.Config.AutoRejoinOnKick then return end
                    if child.Name == "ErrorPrompt" then
                        task.wait(0.5)
                        local msgLabel = child:FindFirstChild("ErrorMessage", true)
                        local text = msgLabel and msgLabel.Text:lower() or ""
                        if text:find("teleport failed") then return end
                        self:TriggerRejoin("CoreGui ErrorPrompt: " .. text)
                    end
                end)
                table.insert(self.State.Connections, promptConn)
            end
        end
    end)
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

            local oldCF = root.CFrame
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

            if not self.Config.AutoTpToMyBooth then
                root.CFrame = oldCF
            else
                task.spawn(function()
                    task.wait(0.25)
                    self:TeleportToMyBooth(nearestStand)
                end)
            end

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
    for _, ch in ipairs(self.State.EspFolder:GetChildren()) do
        if ch.Name:find("StandOwner_") then
            ch:Destroy()
        end
    end

    if not enabled then return end

    local stands = Hub.Services.Workspace:FindFirstChild("Spawn") and Hub.Services.Workspace.Spawn:FindFirstChild("Hub") and Hub.Services.Workspace.Spawn.Hub:FindFirstChild("Stands")
    if not stands then return end

    for i, s in ipairs(stands:GetChildren()) do
        local ownerId = s:GetAttribute("Owner")
        if ownerId and ownerId ~= 0 and ownerId ~= LocalPlayer.UserId then
            local rootPart = s:FindFirstChild("Root") or s:FindFirstChildOfClass("BasePart")
            if rootPart then
                local ownerName = "ID: " .. tostring(ownerId)
                local p = Hub.Services.Players:GetPlayerByUserId(ownerId)
                if p then
                    ownerName = p.DisplayName
                else
                    for _, d in ipairs(s:GetDescendants()) do
                        if d:IsA("TextLabel") and d.Name == "Username" and d.Text ~= "" then
                            ownerName = d.Text:gsub("'s Booth", "")
                            break
                        end
                    end
                end

                local bb = Instance.new("BillboardGui")
                bb.Name = "StandOwner_" .. i
                bb.Size = UDim2.new(0, 130, 0, 26)
                bb.AlwaysOnTop = true
                bb.StudsOffset = Vector3.new(0, 4.5, 0)
                bb.Adornee = rootPart
                bb.Parent = self.State.EspFolder

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
                frame.BackgroundTransparency = 0.2
                frame.Parent = bb
                self:Corner(frame, 6)
                self:Stroke(frame, Color3.fromRGB(50, 50, 70), 1)

                local icon = Instance.new("ImageLabel")
                icon.Size = UDim2.new(0, 13, 0, 13)
                icon.Position = UDim2.new(0, 6, 0.5, -6.5)
                icon.BackgroundTransparency = 1
                icon.Image = Icons.User
                icon.ImageColor3 = Color3.fromRGB(180, 180, 210)
                icon.Parent = frame

                local title = Instance.new("TextLabel")
                title.Size = UDim2.new(1, -24, 1, 0)
                title.Position = UDim2.new(0, 22, 0, 0)
                title.BackgroundTransparency = 1
                title.Font = Enum.Font.GothamMedium
                title.Text = ownerName
                title.TextColor3 = Color3.fromRGB(220, 220, 240)
                title.TextSize = 10
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.Parent = frame
            end
        end
    end
end

-- Real-time ESP & Booth Watcher (Auto-Reclaim on booth loss)
function Hub:SetupEspUpdater()
    local stands = Hub.Services.Workspace:FindFirstChild("Spawn") and Hub.Services.Workspace.Spawn:FindFirstChild("Hub") and Hub.Services.Workspace.Spawn.Hub:FindFirstChild("Stands")
    if stands then
        for _, s in ipairs(stands:GetChildren()) do
            local conn = s:GetAttributeChangedSignal("Owner"):Connect(function()
                if self.Config.EspMyBooth then
                    self:UpdateMyBoothEsp(true)
                end
                if self.Config.MyBoothTracer then
                    self:UpdateMyBoothTracer(true)
                end
                if self.Config.EspBooths then
                    self:UpdateBoothsEsp(true)
                end
                -- If my booth was removed/lost while AutoClaimBooth is enabled:
                if self.Config.AutoClaimBooth and not self:HasClaimedBooth() then
                    task.spawn(function()
                        task.wait(0.4)
                        if self.Config.AutoClaimBooth and not self:HasClaimedBooth() then
                            self:ClaimNearestBooth()
                        end
                    end)
                end
            end)
            table.insert(self.State.Connections, conn)
        end
    end

    -- Background loop
    task.spawn(function()
        while task.wait(2.5) do
            if self.Config.AutoClaimBooth and not self:HasClaimedBooth() then
                self:ClaimNearestBooth()
            end
            if self.Config.MyBoothTracer then
                self:UpdateMyBoothTracer(true)
            end
        end
    end)
end

-- Helper: Get Booth Item under Mouse or Click Position (100% passive, no button hooking)
function Hub:GetBoothItemAtPosition(posX, posY)
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local guis = pg:GetGuiObjectsAtPosition(posX, posY)
    for _, g in ipairs(guis) do
        local pb = g:FindFirstAncestor("PlayersBooth")
        if pb then
            local card = g
            while card and card.Parent and card.Parent.Name ~= "ScrollingList" and card ~= pb do
                card = card.Parent
            end
            if card and card.Parent and card.Parent.Name == "ScrollingList" then
                local lbl = card:FindFirstChild("ItemName", true)
                if lbl and lbl:IsA("TextLabel") and lbl.Text ~= "" and lbl.Text ~= "ItemName" then
                    return lbl.Text
                end
            end
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

-- Helper: Look up item category and exact name from game database
function Hub:FindItemCategory(targetName)
    local targetLower = targetName:lower()
    local ok, ItemInfo = pcall(function()
        return require(Hub.Services.ReplicatedStorage.Shared.ItemInfo)
    end)
    if ok and type(ItemInfo) == "table" then
        -- 1. Exact match
        for catName, items in pairs(ItemInfo) do
            if type(items) == "table" then
                for name, data in pairs(items) do
                    if type(name) == "string" and name:lower() == targetLower then
                        return catName, name
                    end
                    if type(data) == "table" and type(data.DisplayName) == "string" and data.DisplayName:lower() == targetLower then
                        return catName, name
                    end
                end
            end
        end
        -- 2. Partial match
        for catName, items in pairs(ItemInfo) do
            if type(items) == "table" then
                for name, data in pairs(items) do
                    if type(name) == "string" and name:lower():find(targetLower, 1, true) then
                        return catName, name
                    end
                    if type(data) == "table" and type(data.DisplayName) == "string" and data.DisplayName:lower():find(targetLower, 1, true) then
                        return catName, name
                    end
                end
            end
        end
    end
    return "Sword", targetName
end

-- 6. Open Selected Item in Index (Opens native ShowRoom + RAP Chart like Screenshot 2)
function Hub:OpenSelectedItemInIndex()
    -- 1. Check currently hovered item on screen
    local itemName = self:GetHoveredBoothItem()

    -- 2. Fallback to last selected booth item
    if not itemName or itemName == "" then
        itemName = self.State.LastSelectedBoothItem
    end

    -- 3. Fallback to any visible item in open PlayersBooth
    if not itemName or itemName == "" then
        local boothGui = LocalPlayer.PlayerGui:FindFirstChild("Booth")
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
        self:Notify("Index", "Наведи мышь на скин или нажми на предмет на стенде!")
        return
    end

    local cat, exactName = self:FindItemCategory(itemName)

    local ok, IndexController = pcall(function()
        return require(Hub.Services.ReplicatedStorage.Controllers.Trading.IndexController)
    end)

    if ok and IndexController and type(IndexController.Preview) == "function" then
        pcall(function()
            local ml = LocalPlayer.PlayerGui.Index.Main.Left.MainLabel
            if ml.RapChart and ml.RapChart.Visible then
                ml.RapChart.Visible = false
            end
        end)

        IndexController:Preview(cat, exactName)
        task.wait(0.25)

        pcall(function()
            local itemPreview = LocalPlayer.PlayerGui.Index.Main.Left.MainLabel:FindFirstChild("ItemPreview")
            local rapBtn = itemPreview and itemPreview:FindFirstChild("RapButton", true)
            local firesignal = firesignal or function(sig, ...)
                for _, c in ipairs(getconnections(sig)) do c:Fire(...) end
            end
            if rapBtn then
                firesignal(rapBtn.Activated)
            end
        end)

        self:Notify("Index", "Открыт в Index: " .. exactName)
        return
    end

    -- Fallback manual UI navigation
    local indexGui = LocalPlayer.PlayerGui:FindFirstChild("Index")
    if not indexGui or not indexGui:FindFirstChild("Main") then
        self:Notify("Index", "GUI Index не найден!")
        return
    end

    indexGui.Enabled = true
    indexGui.Main.Visible = true

    local ml = indexGui.Main:FindFirstChild("Left") and indexGui.Main.Left:FindFirstChild("MainLabel")
    if not ml then return end

    local firesignal = firesignal or function(sig, ...)
        for _, c in ipairs(getconnections(sig)) do c:Fire(...) end
    end

    local searchBox = ml:FindFirstChild("ItemSearch") and ml.ItemSearch:FindFirstChildWhichIsA("TextBox", true)
    if not searchBox then return end

    local folder = ml:FindFirstChild("ItemsList") and ml.ItemsList:FindFirstChild("Folder")
    local top = ml:FindFirstChild("Top")
    local catBtn = top and top:FindFirstChild(cat)
    if catBtn then
        firesignal(catBtn.Activated)
        task.wait(0.06)
    end

    searchBox.Text = exactName
    firesignal(searchBox.FocusLost, true)
    task.wait(0.2)

    if folder then
        for _, itemBtn in ipairs(folder:GetChildren()) do
            if itemBtn:IsA("GuiObject") and itemBtn.Visible then
                local nameLbl = itemBtn:FindFirstChildWhichIsA("TextLabel", true)
                if nameLbl and nameLbl.Text:lower() == exactName:lower() then
                    firesignal(itemBtn.Activated)
                    task.wait(0.15)
                    local curPreview = ml:FindFirstChild("ItemPreview")
                    local rapBtn = curPreview and curPreview:FindFirstChild("RapButton", true)
                    if rapBtn then firesignal(rapBtn.Activated) end
                    break
                end
            end
        end
    end

    self:Notify("Index", "Открыт в Index: " .. exactName)
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

-- 7. Monitor Booth Sales (Session Profit Tracker & Webhook)
function Hub:SetupProfitWatcher()
    for _, v in ipairs(Hub.Services.ReplicatedStorage:GetDescendants()) do
        if v.Name == "RE/AddToBoothHistory" and v:IsA("RemoteEvent") then
            local conn = v.OnClientEvent:Connect(function(data, extra)
                local name = "Unknown Item"
                local price = 0
                local icon = "rbxassetid://7734053495"
                local buyer = "Plaza Buyer"

                if type(data) == "table" then
                    name = tostring(data.ItemName or data.Name or data.Item or "Item")
                    price = tonumber(data.Price or data.Tokens or data.Amount) or 0
                    icon = tostring(data.Icon or data.Image or icon)
                    buyer = tostring(data.Buyer or data.BuyerName or buyer)
                elseif type(data) == "string" then
                    name = data
                    price = tonumber(extra) or 0
                end

                Hub.State.SessionProfit = Hub.State.SessionProfit + price
                table.insert(Hub.State.SoldHistory, 1, {
                    Name = name,
                    Price = price,
                    Icon = icon,
                    Time = os.date and os.date("%H:%M:%S") or "Now"
                })

                if Hub.State.RefreshProfitUI then
                    Hub.State.RefreshProfitUI()
                end
                Hub:Notify("Продажа на стенде!", name .. " продан за " .. tostring(price) .. " токенов!")

                -- Trigger Discord Webhook
                Hub:SendDiscordWebhook({
                    Name = name,
                    Price = price,
                    Icon = icon,
                    Buyer = buyer
                })
            end)
            table.insert(Hub.State.Connections, conn)
            break
        end
    end
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

    -- LOGO
    local logoAsset = self:GetLogoAsset()
    local topLogo = Instance.new("ImageLabel")
    topLogo.Name = "TopBarLogo"
    topLogo.AnchorPoint = Vector2.new(0, 0.5)
    topLogo.Position = UDim2.new(0, 14, 0.5, 0)
    topLogo.Size = UDim2.new(0, 24, 0, 24)
    topLogo.BackgroundTransparency = 1
    topLogo.Image = logoAsset
    topLogo.ScaleType = Enum.ScaleType.Fit
    topLogo.ZIndex = 23
    topLogo.Parent = topbar

    -- TITLE: DYNAMIC
    local logoShadow = Instance.new("TextLabel")
    logoShadow.Name = "LogoShadow"
    logoShadow.Position = UDim2.new(0, 46, 0.5, 1)
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
    logoLabel.Position = UDim2.new(0, 46, 0.5, 0)
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
    self:SetupProfitWatcher()
    self:SetupEspUpdater()
    self:SetupBoothItemTracker()
    self:SetupAutoServerHopWatcher()
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
function Hub:CreateToggle(parent, title, defaultState, callback)
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
    local function setVisual(newState)
        state = newState
        local targetColor = state and self.Theme.Accent or Color3.fromRGB(34, 34, 44)
        local targetPos = state and UDim2.new(1, -14, 0.5, -6.5) or UDim2.new(0, 1, 0.5, -6.5)
        local knobColor = state and Color3.fromRGB(20, 22, 30) or Color3.fromRGB(210, 215, 225)
        local textColor = state and self.Theme.TextPrimary or self.Theme.TextDim

        self:Tween(switch, { BackgroundColor3 = targetColor }, 0.18)
        self:Tween(circle, { Position = targetPos, BackgroundColor3 = knobColor }, 0.18)
        self:Tween(lbl, { TextColor3 = textColor }, 0.18)

        if callback then
            callback(state)
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

-- HELPER: Dynamic block key / mouse reader for Blade Ball
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

function Hub:PerformBlockStrike()
    local keyInfo = self:GetBlockKeyInfo()
    local vim = self.Services.VirtualInputManager
    if not vim then
        if self.Services.VirtualUser then
            self.Services.VirtualUser:CaptureController()
            self.Services.VirtualUser:ClickButton2(Vector2.new())
        end
        return
    end

    if keyInfo == "Mouse1" then
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.04)
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    elseif keyInfo == "Mouse2" then
        vim:SendMouseButtonEvent(0, 0, 1, true, game, 0)
        task.wait(0.04)
        vim:SendMouseButtonEvent(0, 0, 1, false, game, 0)
    elseif typeof(keyInfo) == "EnumItem" then
        vim:SendKeyEvent(true, keyInfo, false, game)
        task.wait(0.04)
        vim:SendKeyEvent(false, keyInfo, false, game)
    end
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

    local fpsCounter, lastFpsTime = 0, os.clock()
    local renderConn = Hub.Services.RunService.RenderStepped:Connect(function()
        fpsCounter = fpsCounter + 1
        local now = os.clock()
        if now - lastFpsTime >= 0.5 then
            local currentFps = math.floor(fpsCounter / (now - lastFpsTime))
            fpsLabel.Text = currentFps .. " FPS"
            fpsCounter = 0
            lastFpsTime = now

            local pingVal = 0
            pcall(function()
                if LocalPlayer and LocalPlayer.GetNetworkPing then
                    pingVal = math.floor(LocalPlayer:GetNetworkPing() * 1000)
                end
            end)
            if pingVal <= 0 then
                pcall(function()
                    local perf = Hub.Services.Stats:FindFirstChild("PerformanceStats")
                    local pingStat = perf and perf:FindFirstChild("Ping")
                    if pingStat then pingVal = math.floor(pingStat:GetValue()) end
                end)
            end
            pingLabel.Text = pingVal .. " ms"
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

    -- AUTO SERVER HOP & MIN PLAYERS SLIDER
    self:CreateToggle(secServer, "Auto Server Hop", self.Config.AutoServerHop, function(val)
        self.Config.AutoServerHop = val
    end)

    self:CreateSlider(secServer, "Мин. игроков для хопа", 2, 20, self.Config.MinPlayersThreshold or 6, function(val)
        self.Config.MinPlayersThreshold = val
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

    self:CreateButton(secBooth, "Телепорт к своему стенду", function()
        self:TeleportToMyBooth()
    end, self.Theme.SuccessGreen)

    self:CreateToggle(secBooth, "Auto Claim Booth", self.Config.AutoClaimBooth, function(val)
        self.Config.AutoClaimBooth = val
        if val then
            self:ClaimNearestBooth()
        end
    end)

    self:CreateToggle(secBooth, "Auto TP to My Booth", self.Config.AutoTpToMyBooth, function(val)
        self.Config.AutoTpToMyBooth = val
    end)

    self:CreateToggle(secBooth, "ESP My Booth", self.Config.EspMyBooth, function(val)
        self.Config.EspMyBooth = val
        self:UpdateMyBoothEsp(val)
    end)

    self:CreateToggle(secBooth, "My Booth Tracer", self.Config.MyBoothTracer, function(val)
        self.Config.MyBoothTracer = val
        self:UpdateMyBoothTracer(val)
    end)

    self:CreateToggle(secBooth, "ESP Booths", self.Config.EspBooths, function(val)
        self.Config.EspBooths = val
        self:UpdateBoothsEsp(val)
    end)

    -- CARD 2: UTILITIES
    local secUtil = self:CreateSection(left, "Utilities")

    self:CreateToggle(secUtil, "Anti-AFK", self.Config.AntiAFK, function(val)
        self.Config.AntiAFK = val
        if val then
            self.State.AntiAfkConn = LocalPlayer.Idled:Connect(function()
                pcall(function()
                    if Hub.Services.VirtualUser then
                        Hub.Services.VirtualUser:CaptureController()
                        Hub.Services.VirtualUser:ClickButton2(Vector2.new())
                    end
                end)
            end)
            -- Periodic slash / parry strike immediately once off cooldown (~1.6s) even when minimized
            task.spawn(function()
                local lastStrike = 0
                while self.Config.AntiAFK do
                    local now = os.clock()
                    if now - lastStrike >= 1.6 then
                        pcall(function()
                            self:PerformBlockStrike()
                        end)
                        lastStrike = now
                    end
                    task.wait(0.2)
                end
            end)
            self:Notify("Anti-AFK", "Включен (удары каждые 1.6 сек по активной кнопке)")
        else
            if self.State.AntiAfkConn then
                self.State.AntiAfkConn:Disconnect()
                self.State.AntiAfkConn = nil
            end
            self:Notify("Anti-AFK", "Выключен")
        end
    end)

    self:CreateToggle(secUtil, "Auto-Rejoin on Kick", self.Config.AutoRejoinOnKick, function(val)
        self.Config.AutoRejoinOnKick = val
    end)

    -- CARD 3: SESSION PROFIT TRACKER
    local secProfit = self:CreateSection(right, "Session Profit Tracker")

    local profitRow = Instance.new("Frame")
    profitRow.Size = UDim2.new(1, 0, 0, 32)
    profitRow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    profitRow.Parent = secProfit
    self:Corner(profitRow, 6)
    self:Stroke(profitRow, Color3.fromRGB(34, 34, 46), 1)

    local profitTitle = Instance.new("TextLabel")
    profitTitle.Size = UDim2.new(0.5, -10, 1, 0)
    profitTitle.Position = UDim2.new(0, 10, 0, 0)
    profitTitle.BackgroundTransparency = 1
    profitTitle.Font = Enum.Font.GothamMedium
    profitTitle.Text = "Заработано токенов:"
    profitTitle.TextColor3 = self.Theme.TextDim
    profitTitle.TextSize = 11
    profitTitle.TextXAlignment = Enum.TextXAlignment.Left
    profitTitle.Parent = profitRow

    local profitValLbl = Instance.new("TextLabel")
    profitValLbl.Size = UDim2.new(0.5, -10, 1, 0)
    profitValLbl.Position = UDim2.new(0.5, 0, 0, 0)
    profitValLbl.BackgroundTransparency = 1
    profitValLbl.Font = Enum.Font.GothamBold
    profitValLbl.Text = "0 Tokens"
    profitValLbl.TextColor3 = self.Theme.SuccessGreen
    profitValLbl.TextSize = 12
    profitValLbl.TextXAlignment = Enum.TextXAlignment.Right
    profitValLbl.Parent = profitRow

    -- Sold items history list
    local histScroll = Instance.new("ScrollingFrame")
    histScroll.Size = UDim2.new(1, 0, 0, 110)
    histScroll.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    histScroll.BorderSizePixel = 0
    histScroll.ScrollBarThickness = 3
    histScroll.ScrollBarImageColor3 = self.Theme.Accent
    histScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    histScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    histScroll.Parent = secProfit
    self:Corner(histScroll, 6)
    self:Stroke(histScroll, Color3.fromRGB(30, 30, 42), 1)

    local histPad = Instance.new("UIPadding")
    histPad.PaddingTop = UDim.new(0, 4)
    histPad.PaddingBottom = UDim.new(0, 4)
    histPad.PaddingLeft = UDim.new(0, 4)
    histPad.PaddingRight = UDim.new(0, 6)
    histPad.Parent = histScroll

    local histLayout = Instance.new("UIListLayout")
    histLayout.Padding = UDim.new(0, 4)
    histLayout.SortOrder = Enum.SortOrder.LayoutOrder
    histLayout.Parent = histScroll

    local function refreshHistoryUI()
        profitValLbl.Text = tostring(Hub.State.SessionProfit) .. " Tokens"

        for _, ch in ipairs(histScroll:GetChildren()) do
            if ch:IsA("Frame") or ch:IsA("TextLabel") then
                ch:Destroy()
            end
        end

        if #Hub.State.SoldHistory == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, 0, 0, 30)
            empty.BackgroundTransparency = 1
            empty.Font = Enum.Font.GothamMedium
            empty.Text = "Продаж за сессию пока нет"
            empty.TextColor3 = Hub.Theme.TextMuted
            empty.TextSize = 10
            empty.Parent = histScroll
            return
        end

        for _, item in ipairs(Hub.State.SoldHistory) do
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 36)
            card.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
            card.Parent = histScroll
            Hub:Corner(card, 5)
            Hub:Stroke(card, Color3.fromRGB(36, 36, 48), 1)

            local iconImg = Instance.new("ImageLabel")
            iconImg.Size = UDim2.new(0, 26, 0, 26)
            iconImg.Position = UDim2.new(0, 5, 0.5, -13)
            iconImg.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            iconImg.Image = item.Icon or "rbxassetid://7734053495"
            iconImg.ScaleType = Enum.ScaleType.Fit
            iconImg.Parent = card
            Hub:Corner(iconImg, 4)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, -125, 0, 16)
            nameLbl.Position = UDim2.new(0, 36, 0, 3)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.Text = item.Name
            nameLbl.TextColor3 = Hub.Theme.TextPrimary
            nameLbl.TextSize = 11
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent = card

            local timeLbl = Instance.new("TextLabel")
            timeLbl.Size = UDim2.new(1, -125, 0, 14)
            timeLbl.Position = UDim2.new(0, 36, 0, 19)
            timeLbl.BackgroundTransparency = 1
            timeLbl.Font = Enum.Font.Gotham
            timeLbl.Text = "Время: " .. item.Time
            timeLbl.TextColor3 = Hub.Theme.TextMuted
            timeLbl.TextSize = 9
            timeLbl.TextXAlignment = Enum.TextXAlignment.Left
            timeLbl.Parent = card

            local priceLbl = Instance.new("TextLabel")
            priceLbl.Size = UDim2.new(0, 80, 1, 0)
            priceLbl.Position = UDim2.new(1, -85, 0, 0)
            priceLbl.BackgroundTransparency = 1
            priceLbl.Font = Enum.Font.GothamBold
            priceLbl.Text = "+" .. tostring(item.Price) .. " T"
            priceLbl.TextColor3 = Hub.Theme.SuccessGreen
            priceLbl.TextSize = 11
            priceLbl.TextXAlignment = Enum.TextXAlignment.Right
            priceLbl.Parent = card
        end
    end

    Hub.State.RefreshProfitUI = refreshHistoryUI
    refreshHistoryUI()

    -- CARD 4: DISCORD WEBHOOK
    local secWebhook = self:CreateSection(right, "Discord Webhook")

    self:CreateToggle(secWebhook, "Отправлять чеки в Webhook", self.Config.WebhookEnabled, function(val)
        self.Config.WebhookEnabled = val
        self:Notify("Webhook", val and "Webhook включен!" or "Webhook выключен")
    end)

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
                self:OpenSelectedItemInIndex()
            end
        end
    end)
    table.insert(self.State.Connections, conn)
end

-- INITIALIZE
Hub:BuildUI()
print("[Dynamic Hub] Blade Ball Trade Plaza Edition loaded with Booth Modules & Profit Tracker! Toggle: [Right Control].")
