--===============================================
-- 🐉 DRAGON ADVENTURES - PAINEL COMPLETO
-- UI: Rayfield
--===============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = Workspace.CurrentCamera

--===============================================
-- ESTADO GLOBAL
--===============================================
local state = {
    -- Farm
    autoFarmResource = false,
    autoFarmFood = false,
    autoFarmCoins = false,
    autoFarmExp = false,
    autoCollectChests = false,
    autoFarmMobs = false,
    -- Dragons
    autoFeed = false,
    autoHatch = false,
    autoTrain = false,
    godmodeDragon = false,
    noCooldown = false,
    -- ESP
    espEggs = false,
    espResources = false,
    espFood = false,
    espChests = false,
    espMobs = false,
    espPlayers = false,
    espDragons = false,
    -- Player
    fly = false,
    infiniteJump = false,
    noclip = false,
    -- Utils
    antiAfk = false,
}

local connections = {}
local espObjects = {}
local flyBV, flyBG
local flySpeedValue = 100
local speedValue = 16

--===============================================
-- HELPERS
--===============================================
local function notify(title, text, duration)
    Rayfield:Notify({
        Title = title,
        Content = text,
        Duration = duration or 5,
        Image = 4483362458,
    })
end

local function clearESP(key)
    if espObjects[key] then
        for _, data in ipairs(espObjects[key]) do
            if data.billboard then data.billboard:Destroy() end
            if data.highlight then data.highlight:Destroy() end
        end
        espObjects[key] = {}
    end
end

local function createESP(obj, color, text)
    if not obj or not obj:IsA("BasePart") then return end
    if obj:FindFirstChild("PanelESP") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PanelESP"
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = obj
    billboard.Parent = obj

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text or obj.Name
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    local highlight = Instance.new("Highlight")
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = obj
    highlight.Parent = obj

    return { billboard = billboard, highlight = highlight }
end

--===============================================
-- CRIAR JANELA
--===============================================
local Window = Rayfield:CreateWindow({
    Name = "🐉 Dragon Adventures Panel",
    LoadingTitle = "Carregando painel...",
    LoadingSubtitle = "aguarde",
    Theme = "DarkBlue",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DragonPanel",
        FileName = "Config"
    },
    KeySystem = false,
})

--===============================================
-- ABA 1: FARM
--===============================================
local FarmTab = Window:CreateTab("🌾 Farm", 4483362458)

FarmTab:CreateSection("Recursos")

FarmTab:CreateToggle({
    Name = "Auto Farm Recursos",
    CurrentValue = false,
    Flag = "AutoFarmResource",
    Callback = function(value)
        state.autoFarmResource = value
        if value then
            notify("Farm", "Auto Farm Recursos ATIVADO", 3)
            connections.farmRes = RunService.Heartbeat:Connect(function()
                if not state.autoFarmResource then return end
                pcall(function()
                    local closest, dist = nil, math.huge
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("tree")
                            or obj.Name:lower():find("rock")
                            or obj.Name:lower():find("ore")
                            or obj.Name:lower():find("wood")
                            or obj.Name:lower():find("stone")) then
                            local d = (obj.Position - rootPart.Position).Magnitude
                            if d < dist and d < 500 then
                                dist = d
                                closest = obj
                            end
                        end
                    end
                    if closest then
                        rootPart.CFrame = CFrame.new(closest.Position + Vector3.new(0, 5, 0))
                    end
                end)
            end)
        else
            if connections.farmRes then connections.farmRes:Disconnect() end
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Farm Comida",
    CurrentValue = false,
    Flag = "AutoFarmFood",
    Callback = function(value)
        state.autoFarmFood = value
        if value then
            notify("Farm", "Auto Farm Comida ATIVADO", 3)
            connections.farmFood = RunService.Heartbeat:Connect(function()
                if not state.autoFarmFood then return end
                pcall(function()
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("food")
                            or obj.Name:lower():find("meat")
                            or obj.Name:lower():find("fruit")) then
                            local d = (obj.Position - rootPart.Position).Magnitude
                            if d < 300 then
                                rootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                                break
                            end
                        end
                    end
                end)
            end)
        else
            if connections.farmFood then connections.farmFood:Disconnect() end
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Farm Coins",
    CurrentValue = false,
    Flag = "AutoFarmCoins",
    Callback = function(value)
        state.autoFarmCoins = value
        if value then
            notify("Farm", "Auto Farm Coins ATIVADO", 3)
            connections.farmCoins = RunService.Heartbeat:Connect(function()
                if not state.autoFarmCoins then return end
                pcall(function()
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("coin")
                            or obj.Name:lower():find("money")
                            or obj.Name:lower():find("cash")) then
                            local d = (obj.Position - rootPart.Position).Magnitude
                            if d < 300 then
                                rootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                                break
                            end
                        end
                    end
                end)
            end)
        else
            if connections.farmCoins then connections.farmCoins:Disconnect() end
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Farm EXP do Dragão",
    CurrentValue = false,
    Flag = "AutoFarmExp",
    Callback = function(value)
        state.autoFarmExp = value
        if value then
            notify("Farm", "Auto Farm EXP ATIVADO (treine o dragão)", 3)
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Coletar Baús e Drops",
    CurrentValue = false,
    Flag = "AutoCollectChests",
    Callback = function(value)
        state.autoCollectChests = value
        if value then
            notify("Farm", "Auto Coletar Baús ATIVADO", 3)
            connections.collectChests = RunService.Heartbeat:Connect(function()
                if not state.autoCollectChests then return end
                pcall(function()
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("chest")
                            or obj.Name:lower():find("crate")
                            or obj.Name:lower():find("drop")) then
                            local d = (obj.Position - rootPart.Position).Magnitude
                            if d < 400 then
                                rootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                                break
                            end
                        end
                    end
                end)
            end)
        else
            if connections.collectChests then connections.collectChests:Disconnect() end
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Farm Mobs",
    CurrentValue = false,
    Flag = "AutoFarmMobs",
    Callback = function(value)
        state.autoFarmMobs = value
        if value then
            notify("Farm", "Auto Farm Mobs ATIVADO", 3)
            connections.farmMobs = RunService.Heartbeat:Connect(function()
                if not state.autoFarmMobs then return end
                pcall(function()
                    local closest, dist = nil, math.huge
                    for _, model in ipairs(Workspace:GetDescendants()) do
                        if model:IsA("Model") and model ~= character then
                            local hum = model:FindFirstChildOfClass("Humanoid")
                            local hrp = model:FindFirstChild("HumanoidRootPart")
                            if hum and hrp and hum.Health > 0 and not Players:GetPlayerFromCharacter(model) then
                                local d = (hrp.Position - rootPart.Position).Magnitude
                                if d < dist and d < 500 then
                                    dist = d
                                    closest = hrp
                                end
                            end
                        end
                    end
                    if closest then
                        rootPart.CFrame = CFrame.new(closest.Position + Vector3.new(0, 3, 0))
                    end
                end)
            end)
        else
            if connections.farmMobs then connections.farmMobs:Disconnect() end
        end
    end,
})

--===============================================
-- ABA 2: DRAGONS
--===============================================
local DragonTab = Window:CreateTab("🐲 Dragons", 4483362458)

DragonTab:CreateSection("Automação")

DragonTab:CreateToggle({
    Name = "Auto Feed (Alimentar Dragão)",
    CurrentValue = false,
    Flag = "AutoFeed",
    Callback = function(value)
        state.autoFeed = value
        if value then
            notify("Dragon", "Auto Feed ATIVADO", 3)
            connections.autoFeed = RunService.Heartbeat:Connect(function()
                if not state.autoFeed then return end
                -- AJUSTE AQUI: ReplicatedStorage.Remotes.FeedDragon:FireServer()
            end)
        else
            if connections.autoFeed then connections.autoFeed:Disconnect() end
        end
    end,
})

DragonTab:CreateToggle({
    Name = "Auto Hatch (Chocar Ovos)",
    CurrentValue = false,
    Flag = "AutoHatch",
    Callback = function(value)
        state.autoHatch = value
        if value then
            notify("Dragon", "Auto Hatch ATIVADO", 3)
            connections.autoHatch = RunService.Heartbeat:Connect(function()
                if not state.autoHatch then return end
                -- AJUSTE AQUI: interaja com o ninho
            end)
        else
            if connections.autoHatch then connections.autoHatch:Disconnect() end
        end
    end,
})

DragonTab:CreateToggle({
    Name = "Auto Level / Auto Train",
    CurrentValue = false,
    Flag = "AutoTrain",
    Callback = function(value)
        state.autoTrain = value
        if value then
            notify("Dragon", "Auto Train ATIVADO", 3)
            connections.autoTrain = RunService.Heartbeat:Connect(function()
                if not state.autoTrain then return end
                -- AJUSTE AQUI: lógica de treino
            end)
        else
            if connections.autoTrain then connections.autoTrain:Disconnect() end
        end
    end,
})

DragonTab:CreateSection("Buffs")

DragonTab:CreateToggle({
    Name = "Godmode no Dragão",
    CurrentValue = false,
    Flag = "GodmodeDragon",
    Callback = function(value)
        state.godmodeDragon = value
        if value then
            notify("Dragon", "⚠️ Godmode client-side (pode não funcionar)", 5)
            connections.godmode = RunService.Heartbeat:Connect(function()
                if not state.godmodeDragon then return end
                pcall(function()
                    for _, d in ipairs(Workspace:GetDescendants()) do
                        if d:IsA("Humanoid") and d.Parent 
                            and d.Parent.Name:lower():find("dragon") then
                            d.MaxHealth = math.huge
                            d.Health = math.huge
                        end
                    end
                end)
            end)
        else
            if connections.godmode then connections.godmode:Disconnect() end
        end
    end,
})

DragonTab:CreateToggle({
    Name = "No Cooldown de Habilidades",
    CurrentValue = false,
    Flag = "NoCooldown",
    Callback = function(value)
        state.noCooldown = value
        if value then
            notify("Dragon", "⚠️ No Cooldown é server-side", 5)
        end
    end,
})

DragonTab:CreateSlider({
    Name = "Velocidade de Voo",
    Range = {50, 500},
    Increment = 10,
    Suffix = "spd",
    CurrentValue = 100,
    Flag = "FlySpeedBoost",
    Callback = function(value)
        flySpeedValue = value
    end,
})

DragonTab:CreateSlider({
    Name = "Velocidade de Corrida",
    Range = {16, 300},
    Increment = 4,
    Suffix = "spd",
    CurrentValue = 16,
    Flag = "RunSpeedBoost",
    Callback = function(value)
        speedValue = value
        if humanoid then humanoid.WalkSpeed = value end
    end,
})

--===============================================
-- ABA 3: ESP
--===============================================
local EspTab = Window:CreateTab("👁️ ESP", 4483362458)

EspTab:CreateSection("Objetos")

-- Função genérica pra criar ESP por nome
local function makeESPByName(key, color, searchTerms)
    return function(value)
        state[key] = value
        if value then
            espObjects[key] = espObjects[key] or {}
            connections[key] = RunService.Heartbeat:Connect(function()
                if not state[key] then return end
                pcall(function()
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and not obj:FindFirstChild("PanelESP") then
                            local name = obj.Name:lower()
                            for _, term in ipairs(searchTerms) do
                                if name:find(term) then
                                    local data = createESP(obj, color, obj.Name)
                                    if data then table.insert(espObjects[key], data) end
                                    break
                                end
                            end
                        end
                    end
                end)
            end)
        else
            if connections[key] then connections[key]:Disconnect() end
            clearESP(key)
        end
    end
end

EspTab:CreateToggle({
    Name = "ESP de Ovos 🥚",
    CurrentValue = false,
    Flag = "ESPEggs",
    Callback = makeESPByName("espEggs", Color3.fromRGB(255, 200, 100), {"egg", "ovo"}),
})

EspTab:CreateToggle({
    Name = "ESP de Recursos 🪵",
    CurrentValue = false,
    Flag = "ESPResources",
    Callback = makeESPByName("espResources", Color3.fromRGB(100, 255, 100), {"tree", "rock", "ore", "wood", "stone"}),
})

EspTab:CreateToggle({
    Name = "ESP de Comida 🍖",
    CurrentValue = false,
    Flag = "ESPFood",
    Callback = makeESPByName("espFood", Color3.fromRGB(255, 100, 100), {"food", "meat", "fruit", "berry"}),
})

EspTab:CreateToggle({
    Name = "ESP de Baús 📦",
    CurrentValue = false,
    Flag = "ESPChests",
    Callback = makeESPByName("espChests", Color3.fromRGB(255, 215, 0), {"chest", "crate", "drop"}),
})

EspTab:CreateSection("Seres Vivos")

EspTab:CreateToggle({
    Name = "ESP de Mobs 👹",
    CurrentValue = false,
    Flag = "ESPMobs",
    Callback = function(value)
        state.espMobs = value
        if value then
            espObjects.espMobs = espObjects.espMobs or {}
            connections.espMobs = RunService.Heartbeat:Connect(function()
                if not state.espMobs then return end
                pcall(function()
                    for _, model in ipairs(Workspace:GetDescendants()) do
                        if model:IsA("Model") and model ~= character then
                            local hum = model:FindFirstChildOfClass("Humanoid")
                            local hrp = model:FindFirstChild("HumanoidRootPart")
                            if hum and hrp and not Players:GetPlayerFromCharacter(model) 
                                and not hrp:FindFirstChild("PanelESP") then
                                local data = createESP(hrp, Color3.fromRGB(255, 100, 255), model.Name)
                                if data then table.insert(espObjects.espMobs, data) end
                            end
                        end
                    end
                end)
            end)
        else
            if connections.espMobs then connections.espMobs:Disconnect() end
            clearESP("espMobs")
        end
    end,
})

EspTab:CreateToggle({
    Name = "ESP de Jogadores 👤",
    CurrentValue = false,
    Flag = "ESPPlayers",
    Callback = function(value)
        state.espPlayers = value
        if value then
            espObjects.espPlayers = espObjects.espPlayers or {}
            connections.espPlayers = RunService.Heartbeat:Connect(function()
                if not state.espPlayers then return end
                pcall(function()
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= player and p.Character then
                            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and not hrp:FindFirstChild("PanelESP") then
                                local data = createESP(hrp, Color3.fromRGB(0, 255, 255), p.Name)
                                if data then table.insert(espObjects.espPlayers, data) end
                            end
                        end
                    end
                end)
            end)
        else
            if connections.espPlayers then connections.espPlayers:Disconnect() end
            clearESP("espPlayers")
        end
    end,
})

EspTab:CreateToggle({
    Name = "ESP de Dragões 🐉",
    CurrentValue = false,
    Flag = "ESPDragons",
    Callback = function(value)
        state.espDragons = value
        if value then
            espObjects.espDragons = espObjects.espDragons or {}
            connections.espDragons = RunService.Heartbeat:Connect(function()
                if not state.espDragons then return end
                pcall(function()
                    for _, model in ipairs(Workspace:GetDescendants()) do
                        if model:IsA("Model") and model.Name:lower():find("dragon") then
                            local hrp = model:FindFirstChild("HumanoidRootPart") 
                                or model:FindFirstChildWhichIsA("BasePart")
                            if hrp and not hrp:FindFirstChild("PanelESP") then
                                local data = createESP(hrp, Color3.fromRGB(255, 50, 50), model.Name)
                                if data then table.insert(espObjects.espDragons, data) end
                            end
                        end
                    end
                end)
            end)
        else
            if connections.espDragons then connections.espDragons:Disconnect() end
            clearESP("espDragons")
        end
    end,
})

--===============================================
-- ABA 4: PLAYER
--===============================================
local PlayerTab = Window:CreateTab("🎮 Player", 4483362458)

PlayerTab:CreateSection("Movimento")

-- FLY
PlayerTab:CreateToggle({
    Name = "Fly ✈️",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(value)
        state.fly = value
        if value then
            if flyBV then flyBV:Destroy() end
            if flyBG then flyBG:Destroy() end

            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyBV.Velocity = Vector3.zero
            flyBV.Parent = rootPart

            flyBG = Instance.new("BodyGyro")
            flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            flyBG.P = 1000
            flyBG.D = 50
            flyBG.Parent = rootPart

            humanoid.PlatformStand = true

            connections.fly = RunService.RenderStepped:Connect(function()
                if not state.fly then return end
                local moveDir = Vector3.zero
                local camCF = camera.CFrame

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + camCF.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - camCF.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - camCF.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + camCF.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end

                flyBV.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * flySpeedValue or Vector3.zero
                flyBG.CFrame = camCF
            end)

            notify("Player", "Fly ATIVADO ✈️", 3)
        else
            if connections.fly then connections.fly:Disconnect() end
            if flyBV then flyBV:Destroy() flyBV = nil end
            if flyBG then flyBG:Destroy() flyBG = nil end
            humanoid.PlatformStand = false
            notify("Player", "Fly DESATIVADO", 3)
        end
    end,
})

-- SPEED HACK
PlayerTab:CreateSlider({
    Name = "Speed Hack 🏃",
    Range = {16, 500},
    Increment = 4,
    Suffix = "spd",
    CurrentValue = 16,
    Flag = "SpeedHack",
    Callback = function(value)
        speedValue = value
        if humanoid then humanoid.WalkSpeed = value end
    end,
})

-- INFINITE JUMP
PlayerTab:CreateToggle({
    Name = "Infinite Jump 🦘",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(value)
        state.infiniteJump = value
        if value then
            connections.infJump = UserInputService.JumpRequest:Connect(function()
                if state.infiniteJump and humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            notify("Player", "Infinite Jump ATIVADO", 3)
        else
            if connections.infJump then connections.infJump:Disconnect() end
        end
    end,
})

-- NOCLIP
PlayerTab:CreateToggle({
    Name = "Noclip 🚫",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(value)
        state.noclip = value
        if value then
            connections.noclip = RunService.Stepped:Connect(function()
                if not state.noclip or not character then return end
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end)
            notify("Player", "Noclip ATIVADO 🚫", 3)
        else
            if connections.noclip then connections.noclip:Disconnect() end
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

PlayerTab:CreateSection("Teleporte")

PlayerTab:CreateDropdown({
    Name = "Teleporte para Mundo 🌍",
    Options = {"Home", "Prehistoric", "Jungle", "Fantasy", "Ocean", "Desert", "Tundra", "Volcano"},
    CurrentOption = {"Home"},
    Flag = "TPWorld",
    Callback = function(option)
        local worldName = type(option) == "table" and option[1] or option
        notify("Teleporte", "Teleportando para: " .. worldName, 3)
        -- AJUSTE AQUI: ReplicatedStorage.Remotes.Teleport:FireServer(worldName)
    end,
})

PlayerTab:CreateButton({
    Name = "Teleportar para Baú Mais Próximo 📦",
    Callback = function()
        pcall(function()
            local closest, dist = nil, math.huge
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("chest") then
                    local d = (obj.Position - rootPart.Position).Magnitude
                    if d < dist then dist = d closest = obj end
                end
            end
            if closest then
                rootPart.CFrame = CFrame.new(closest.Position + Vector3.new(0, 5, 0))
                notify("Teleporte", "Teleportado!", 3)
            else
                notify("Teleporte", "Nenhum baú encontrado", 3)
            end
        end)
    end,
})

--===============================================
-- ABA 5: SETTINGS
--===============================================
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)

SettingsTab:CreateSection("Utilidades")

SettingsTab:CreateButton({
    Name = "Auto Claim Recompensas 🎁",
    Callback = function()
        notify("Utils", "Coletando recompensas...", 3)
        pcall(function()
            for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("claim")
                    or remote.Name:lower():find("reward")) then
                    remote:FireServer()
                end
            end
        end)
    end,
})

SettingsTab:CreateToggle({
    Name = "Anti-AFK 😴",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(value)
        state.antiAfk = value
        if value then
            connections.antiAfk = player.Idled:Connect(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
            notify("Utils", "Anti-AFK ATIVADO", 3)
        else
            if connections.antiAfk then connections.antiAfk:Disconnect() end
        end
    end,
})

SettingsTab:CreateSection("Painel")

SettingsTab:CreateButton({
    Name = "Minimizar Painel ➖",
    Callback = function()
        Rayfield:Minimize()
    end,
})

SettingsTab:CreateButton({
    Name = "Destruir Painel ❌",
    Callback = function()
        for _, conn in pairs(connections) do
            pcall(function() conn:Disconnect() end)
        end
        for key, _ in pairs(espObjects) do
            clearESP(key)
        end
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        if humanoid then
            humanoid.PlatformStand = false
            humanoid.WalkSpeed = 16
        end
        Rayfield:Destroy()
    end,
})

SettingsTab:CreateSection("Info")

SettingsTab:CreateLabel("🐉 Dragon Adventures Panel")
SettingsTab:CreateLabel("Versão 1.0")
SettingsTab:CreateLabel("⚠️ Use por sua conta e risco")

--===============================================
-- INICIALIZAÇÃO
--===============================================
Rayfield:LoadConfiguration()
notify("🐉 Dragon Adventures", "Painel carregado!", 5)

--===============================================
-- RESPAWN
--===============================================
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    task.wait(1)
    if humanoid and speedValue > 16 then
        humanoid.WalkSpeed = speedValue
    end
end)

print("🐉 Dragon Adventures Panel carregado!")