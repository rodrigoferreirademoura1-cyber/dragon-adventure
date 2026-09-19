--===============================================
-- 🐉 DRAGON ADVENTURES PANEL v2 - CORRIGIDO
-- UI: Rayfield
--===============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
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
    autoFarmResource = false,
    autoFarmFood = false,
    autoFarmCoins = false,
    autoFarmExp = false,
    autoCollectChests = false,
    autoFarmMobs = false,
    autoFeed = false,
    autoHatch = false,
    autoTrain = false,
    godmodeDragon = false,
    noCooldown = false,
    espEggs = false,
    espResources = false,
    espFood = false,
    espChests = false,
    espMobs = false,
    espPlayers = false,
    espDragons = false,
    fly = false,
    infiniteJump = false,
    noclip = false,
    antiAfk = false,
}

local connections = {}
local espObjects = {}
local flyBV, flyBG, flyAttachment
local flySpeedValue = 100
local speedValue = 16
local espMaxDistance = 500 -- Distância máxima padrão

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
            pcall(function()
                if data.billboard then data.billboard:Destroy() end
                if data.highlight then data.highlight:Destroy() end
            end)
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
    Name = "🐉 Dragon Adventures Panel v2",
    LoadingTitle = "Carregando...",
    LoadingSubtitle = "v2 corrigido",
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
                if not state.autoFarmResource or not rootPart or not rootPart.Parent then return end
                pcall(function()
                    local closest, dist = nil, math.huge
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("tree")
                            or obj.Name:lower():find("rock")
                            or obj.Name:lower():find("ore")
                            or obj.Name:lower():find("wood")
                            or obj.Name:lower():find("stone")) then
                            local d = (obj.Position - rootPart.Position).Magnitude
                            if d < dist and d < 500 then dist = d closest = obj end
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
            connections.farmFood = RunService.Heartbeat:Connect(function()
                if not state.autoFarmFood or not rootPart or not rootPart.Parent then return end
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
            connections.farmCoins = RunService.Heartbeat:Connect(function()
                if not state.autoFarmCoins or not rootPart or not rootPart.Parent then return end
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
        if value then notify("Farm", "Auto Farm EXP ATIVADO", 3) end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Coletar Baús e Drops",
    CurrentValue = false,
    Flag = "AutoCollectChests",
    Callback = function(value)
        state.autoCollectChests = value
        if value then
            connections.collectChests = RunService.Heartbeat:Connect(function()
                if not state.autoCollectChests or not rootPart or not rootPart.Parent then return end
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
            connections.farmMobs = RunService.Heartbeat:Connect(function()
                if not state.autoFarmMobs or not rootPart or not rootPart.Parent then return end
                pcall(function()
                    local closest, dist = nil, math.huge
                    for _, model in ipairs(Workspace:GetDescendants()) do
                        if model:IsA("Model") and model ~= character then
                            local hum = model:FindFirstChildOfClass("Humanoid")
                            local hrp = model:FindFirstChild("HumanoidRootPart")
                            if hum and hrp and hum.Health > 0 and not Players:GetPlayerFromCharacter(model) then
                                local d = (hrp.Position - rootPart.Position).Magnitude
                                if d < dist and d < 500 then dist = d closest = hrp end
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
                -- AJUSTE AQUI
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
                -- AJUSTE AQUI
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
            connections.autoTrain = RunService.Heartbeat:Connect(function()
                if not state.autoTrain then return end
                -- AJUSTE AQUI
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
            notify("Dragon", "⚠️ Godmode client-side", 5)
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
        if value then notify("Dragon", "⚠️ Server-side", 5) end
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
-- ABA 3: ESP (COM LIMITE DE DISTÂNCIA)
--===============================================
local EspTab = Window:CreateTab("👁️ ESP", 4483362458)

EspTab:CreateSection("Configuração de Distância")

EspTab:CreateParagraph({
    Title = "⚠️ AVISO IMPORTANTE",
    Content = "Distância alta (acima de 500) pode CAUSAR LAG e até travar o jogo! Use com moderação. 0 = sem limite (NÃO recomendado)."
})

EspTab:CreateSlider({
    Name = "Distância Máxima do ESP",
    Range = {0, 1000},
    Increment = 50,
    Suffix = "studs",
    CurrentValue = 500,
    Flag = "EspMaxDistance",
    Callback = function(value)
        espMaxDistance = value
        if value == 0 then
            notify("ESP", "⚠️ Sem limite! Vai lagar se tiver muita coisa", 4)
        elseif value > 700 then
            notify("ESP", "⚠️ Distância alta, pode lagar", 3)
        end
    end,
})

EspTab:CreateSection("Objetos")

-- Função genérica ESP por nome
local function makeESPByName(key, color, searchTerms)
    return function(value)
        state[key] = value
        if value then
            espObjects[key] = espObjects[key] or {}
            connections[key] = RunService.Heartbeat:Connect(function()
                if not state[key] or not rootPart or not rootPart.Parent then return end
                pcall(function()
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and not obj:FindFirstChild("PanelESP") then
                            local name = obj.Name:lower()
                            for _, term in ipairs(searchTerms) do
                                if name:find(term) then
                                    local d = (obj.Position - rootPart.Position).Magnitude
                                    if espMaxDistance == 0 or d <= espMaxDistance then
                                        local data = createESP(obj, color, obj.Name)
                                        if data then table.insert(espObjects[key], data) end
                                    end
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

-- ESP DE MOBS
EspTab:CreateToggle({
    Name = "ESP de Mobs 👹",
    CurrentValue = false,
    Flag = "ESPMobs",
    Callback = function(value)
        state.espMobs = value
        if value then
            espObjects.espMobs = espObjects.espMobs or {}
            connections.espMobs = RunService.Heartbeat:Connect(function()
                if not state.espMobs or not rootPart or not rootPart.Parent then return end
                pcall(function()
                    for _, model in ipairs(Workspace:GetDescendants()) do
                        if model:IsA("Model") and model ~= character then
                            local hum = model:FindFirstChildOfClass("Humanoid")
                            local hrp = model:FindFirstChild("HumanoidRootPart")
                            if hum and hrp and not Players:GetPlayerFromCharacter(model) 
                                and not hrp:FindFirstChild("PanelESP") then
                                local d = (hrp.Position - rootPart.Position).Magnitude
                                if espMaxDistance == 0 or d <= espMaxDistance then
                                    local data = createESP(hrp, Color3.fromRGB(255, 100, 255), model.Name)
                                    if data then table.insert(espObjects.espMobs, data) end
                                end
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

-- ESP DE JOGADORES (CORRIGIDO - monitora respawns)
EspTab:CreateToggle({
    Name = "ESP de Jogadores 👤",
    CurrentValue = false,
    Flag = "ESPPlayers",
    Callback = function(value)
        state.espPlayers = value
        if value then
            espObjects.espPlayers = espObjects.espPlayers or {}
            connections.espPlayers = RunService.Heartbeat:Connect(function()
                if not state.espPlayers or not rootPart or not rootPart.Parent then return end
                pcall(function()
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= player and p.Character then
                            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and not hrp:FindFirstChild("PanelESP") then
                                local d = (hrp.Position - rootPart.Position).Magnitude
                                if espMaxDistance == 0 or d <= espMaxDistance then
                                    local data = createESP(hrp, Color3.fromRGB(0, 255, 255), p.Name)
                                    if data then table.insert(espObjects.espPlayers, data) end
                                end
                            end
                        end
                    end
                end)
            end)
            notify("ESP", "ESP de Jogadores ativado", 3)
        else
            if connections.espPlayers then connections.espPlayers:Disconnect() end
            clearESP("espPlayers")
        end
    end,
})

-- ESP DE DRAGÕES (CORRIGIDO - detecção ampliada)
EspTab:CreateToggle({
    Name = "ESP de Dragões 🐉",
    CurrentValue = false,
    Flag = "ESPDragons",
    Callback = function(value)
        state.espDragons = value
        if value then
            espObjects.espDragons = espObjects.espDragons or {}
            connections.espDragons = RunService.Heartbeat:Connect(function()
                if not state.espDragons or not rootPart or not rootPart.Parent then return end
                pcall(function()
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        -- Detecta qualquer coisa que seja dragão (Model ou MeshPart)
                        local isDragon = false
                        local target = nil
                        
                        if obj:IsA("Model") then
                            local n = obj.Name:lower()
                            -- Detecção ampla: procura "dragon", "wyvern", "drake", "dragão"
                            if n:find("dragon") or n:find("wyvern") 
                                or n:find("drake") or n:find("drac") then
                                isDragon = true
                                target = obj:FindFirstChild("HumanoidRootPart") 
                                    or obj.PrimaryPart 
                                    or obj:FindFirstChildWhichIsA("BasePart")
                            end
                            -- Também detecta modelos que contêm "Dragon" em filhos
                            if not isDragon then
                                for _, child in ipairs(obj:GetChildren()) do
                                    if child.Name:lower():find("dragon") then
                                        isDragon = true
                                        target = obj:FindFirstChild("HumanoidRootPart") 
                                            or obj.PrimaryPart 
                                            or obj:FindFirstChildWhichIsA("BasePart")
                                        break
                                    end
                                end
                            end
                        end
                        
                        if isDragon and target and not target:FindFirstChild("PanelESP") then
                            local d = (target.Position - rootPart.Position).Magnitude
                            if espMaxDistance == 0 or d <= espMaxDistance then
                                local data = createESP(target, Color3.fromRGB(255, 50, 50), target.Parent.Name)
                                if data then table.insert(espObjects.espDragons, data) end
                            end
                        end
                    end
                end)
            end)
            notify("ESP", "ESP de Dragões ativado", 3)
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

--===============================================
-- FLY CORRIGIDO (usando LinearVelocity + AlignOrientation)
--===============================================
local function startFly()
    if state.fly then return end
    state.fly = true
    
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    
    -- Limpar anterior
    if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
    if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
    if flyAttachment then pcall(function() flyAttachment:Destroy() end) flyAttachment = nil end
    
    -- Attachment
    flyAttachment = Instance.new("Attachment")
    flyAttachment.Name = "FlyAttachment"
    flyAttachment.Parent = root
    
    -- LinearVelocity (movimento)
    flyBV = Instance.new("LinearVelocity")
    flyBV.Attachment0 = flyAttachment
    flyBV.MaxForce = math.huge
    flyBV.VectorVelocity = Vector3.zero
    flyBV.RelativeTo = Enum.ActuatorRelativeTo.World
    flyBV.Parent = root
    
    -- AlignOrientation (evita bug de rotação)
    flyBG = Instance.new("AlignOrientation")
    flyBG.Attachment0 = flyAttachment
    flyBG.Mode = Enum.OrientationAlignmentMode.OneAttachment
    flyBG.MaxTorque = math.huge
    flyBG.Responsiveness = 25
    flyBG.PrimaryAxisOnly = false
    flyBG.Parent = root
    
    hum.PlatformStand = true
    hum.AutoRotate = false
    
    -- Loop de movimento
    connections.fly = RunService.RenderStepped:Connect(function()
        if not state.fly then return end
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root or not flyBV or not flyBG then return end
        
        local cam = Workspace.CurrentCamera
        if not cam then return end
        
        local moveDir = Vector3.zero
        local camCF = cam.CFrame
        local flatForward = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
        if flatForward.Magnitude > 0 then flatForward = flatForward.Unit end
        local flatRight = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z)
        if flatRight.Magnitude > 0 then flatRight = flatRight.Unit end
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + flatForward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - flatForward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - flatRight
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + flatRight
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) 
            or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * flySpeedValue
        end
        
        flyBV.VectorVelocity = moveDir
        
        -- Rotação suave na direção do movimento
        if moveDir.Magnitude > 0.1 then
            local lookDir = Vector3.new(moveDir.X, 0, moveDir.Z)
            if lookDir.Magnitude > 0.1 then
                flyBG.CFrame = CFrame.lookAt(Vector3.zero, lookDir.Unit)
            end
        end
    end)
    
    notify("Player", "Fly ATIVADO ✈️", 3)
end

local function stopFly()
    if not state.fly then return end
    state.fly = false
    
    if connections.fly then connections.fly:Disconnect() connections.fly = nil end
    if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
    if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
    if flyAttachment then pcall(function() flyAttachment:Destroy() end) flyAttachment = nil end
    
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
            hum.AutoRotate = true
        end
    end
    
    notify("Player", "Fly DESATIVADO", 3)
end

PlayerTab:CreateToggle({
    Name = "Fly ✈️",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(value)
        if value then startFly() else stopFly() end
    end,
})

--===============================================
-- SPEED HACK CORRIGIDO (com monitoramento contínuo)
--===============================================
PlayerTab:CreateSlider({
    Name = "Speed Hack 🏃",
    Range = {16, 500},
    Increment = 4,
    Suffix = "spd",
    CurrentValue = 16,
    Flag = "SpeedHack",
    Callback = function(value)
        speedValue = value
        -- Aplica imediatamente
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = value end
        end
    end,
})

-- Loop que mantém a velocidade aplicada (importante: jogo pode resetar)
connections.speedLoop = RunService.Heartbeat:Connect(function()
    if speedValue <= 16 then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.WalkSpeed ~= speedValue then
        hum.WalkSpeed = speedValue
    end
end)

--===============================================
-- INFINITE JUMP
--===============================================
PlayerTab:CreateToggle({
    Name = "Infinite Jump 🦘",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(value)
        state.infiniteJump = value
        if value then
            connections.infJump = UserInputService.JumpRequest:Connect(function()
                if not state.infiniteJump then return end
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end
            end)
            notify("Player", "Infinite Jump ATIVADO", 3)
        else
            if connections.infJump then connections.infJump:Disconnect() end
        end
    end,
})

--===============================================
-- NOCLIP
--===============================================
PlayerTab:CreateToggle({
    Name = "Noclip 🚫",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(value)
        state.noclip = value
        if value then
            connections.noclip = RunService.Stepped:Connect(function()
                if not state.noclip then return end
                local char = player.Character
                if not char then return end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end)
            notify("Player", "Noclip ATIVADO 🚫", 3)
        else
            if connections.noclip then connections.noclip:Disconnect() end
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
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
        -- AJUSTE AQUI
    end,
})

PlayerTab:CreateButton({
    Name = "Teleportar para Baú Mais Próximo 📦",
    Callback = function()
        pcall(function()
            local closest, dist = nil, math.huge
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("chest") then
                    local d = (obj.Position - root.Position).Magnitude
                    if d < dist then dist = d closest = obj end
                end
            end
            if closest then
                root.CFrame = CFrame.new(closest.Position + Vector3.new(0, 5, 0))
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
        if state.fly then stopFly() end
        for _, conn in pairs(connections) do
            pcall(function() conn:Disconnect() end)
        end
        for key, _ in pairs(espObjects) do
            clearESP(key)
        end
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        if flyAttachment then flyAttachment:Destroy() end
        Rayfield:Destroy()
    end,
})

SettingsTab:CreateSection("Info")

SettingsTab:CreateLabel("🐉 Dragon Adventures Panel v2")
SettingsTab:CreateLabel("Versão 2.0 - Bug fixes")
SettingsTab:CreateLabel("⚠️ Use por sua conta e risco")

--===============================================
-- INICIALIZAÇÃO
--===============================================
Rayfield:LoadConfiguration()
notify("🐉 Dragon Adventures", "Painel v2 carregado!", 5)

--===============================================
-- RESPAWN HANDLER (corrige fly, speed, ESP)
--===============================================
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    task.wait(1)
    
    -- Reaplica speed
    if humanoid and speedValue > 16 then
        humanoid.WalkSpeed = speedValue
    end
    
    -- Reativa fly se estava ativo
    if state.fly then
        state.fly = false
        startFly()
    end
    
    -- Limpa ESPs antigos (serão recriados)
    for key, _ in pairs(espObjects) do
        clearESP(key)
    end
end)

print("🐉 Dragon Adventures Panel v2 carregado!")
