--[[ ROST ALPHA | Premium UI + Silent Aim + Camera Lock + Full ESP ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local rnd = function() return tostring(math.random(1e6, 9e6)) end
local GuiParent = game:GetService("CoreGui")
pcall(function() if gethui then GuiParent = gethui() end end)

local KEY_DATABASE = {
    ["moder2563546"] = {role = "moder", user = "fooptit"},
    ["free-dlyvseh27636"] = {role = "free", user = "ALL"},
}
local UserRole = "free"

local Config = {
    Aim_Enabled = false, Aim_Mode = "Silent", -- "Silent" или "Camera"
    TargetPart = "Head", FOV = 150, WallCheck = false,
    ESP_Enabled = false, ESP_Box = true, ESP_Name = true, ESP_Dist = true, ESP_HP = true, ESP_Skeleton = false,
    Speed_Enabled = false, Speed_Value = 30, Fullbright = false
}

-- ==========================================
-- KEY SYSTEM UI
-- ==========================================
local KeyGui = Instance.new("ScreenGui"); KeyGui.Name = "sg_" .. rnd(); KeyGui.ResetOnSpawn = false; KeyGui.Parent = GuiParent
local KeyFrame = Instance.new("Frame"); KeyFrame.Size = UDim2.new(0, 250, 0, 120); KeyFrame.Position = UDim2.new(0.5, -125, 0.5, -60); KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 20); KeyFrame.Parent = KeyGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)
local KeyTitle = Instance.new("TextLabel"); KeyTitle.Size = UDim2.new(1, 0, 0, 30); KeyTitle.BackgroundTransparency = 1; KeyTitle.Text = "Введите ключ"; KeyTitle.TextColor3 = Color3.new(1,1,1); KeyTitle.Font = Enum.Font.GothamBold; KeyTitle.TextSize = 16; KeyTitle.Parent = KeyFrame
local KeyInput = Instance.new("TextBox"); KeyInput.Size = UDim2.new(1, -20, 0, 30); KeyInput.Position = UDim2.new(0, 10, 0, 40); KeyInput.BackgroundColor3 = Color3.fromRGB(30, 20, 40); KeyInput.TextColor3 = Color3.new(1,1,1); KeyInput.PlaceholderText = "Ключ..."; KeyInput.Font = Enum.Font.Gotham; KeyInput.TextSize = 14; KeyInput.Parent = KeyFrame
local KeySubmit = Instance.new("TextButton"); KeySubmit.Size = UDim2.new(1, -20, 0, 30); KeySubmit.Position = UDim2.new(0, 10, 0, 80); KeySubmit.BackgroundColor3 = Color3.fromRGB(150, 80, 255); KeySubmit.Text = "Активировать"; KeySubmit.TextColor3 = Color3.new(1,1,1); KeySubmit.Font = Enum.Font.GothamBold; KeySubmit.TextSize = 14; KeySubmit.Parent = KeyFrame

-- ==========================================
-- ОСНОВНОЙ ФУНКЦИОНАЛ
-- ==========================================
local function StartCheat()
    local playerCache = {}
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then playerCache[p] = true end end
    Players.PlayerAdded:Connect(function(p) playerCache[p] = true end)
    Players.PlayerRemoving:Connect(function(p) playerCache[p] = nil end)

    -- Меню
    local MenuGui = Instance.new("ScreenGui"); MenuGui.Name = "sg_" .. rnd(); MenuGui.ResetOnSpawn = false; MenuGui.IgnoreGuiInset = true; MenuGui.DisplayOrder = 50; MenuGui.Parent = GuiParent
    
    -- FOV Круг
    local FOV_Gui = Instance.new("ScreenGui"); FOV_Gui.Name = "sg_" .. rnd(); FOV_Gui.ResetOnSpawn = false; FOV_Gui.IgnoreGuiInset = true; FOV_Gui.DisplayOrder = 40; FOV_Gui.Parent = GuiParent
    local FOV_Frame = Instance.new("Frame"); FOV_Frame.Name = "f_" .. rnd(); FOV_Frame.BackgroundTransparency = 1; FOV_Frame.AnchorPoint = Vector2.new(0.5, 0.5); FOV_Frame.Position = UDim2.new(0.5, 0, 0.5, 0); FOV_Frame.Size = UDim2.new(0, Config.FOV * 2, 0, Config.FOV * 2); FOV_Frame.Visible = false; FOV_Frame.Parent = FOV_Gui
    local FOV_Corner = Instance.new("UICorner"); FOV_Corner.CornerRadius = UDim.new(1, 0); FOV_Corner.Parent = FOV_Frame
    local FOV_Stroke = Instance.new("UIStroke"); FOV_Stroke.Color = Color3.fromRGB(150, 80, 255); FOV_Stroke.Thickness = 1.5; FOV_Stroke.Transparency = 0.3; FOV_Stroke.Parent = FOV_Frame

    -- Кнопка "F"
    local ToggleBtn = Instance.new("TextButton"); ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Position = UDim2.new(0.5, -25, 0.5, -25); ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 80, 255); ToggleBtn.Text = "F"; ToggleBtn.TextColor3 = Color3.new(1,1,1); ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.TextSize = 20; ToggleBtn.Parent = MenuGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    ToggleBtn.ZIndex = 100
    
    local dragging, dragInput, dragStart, startPos
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = ToggleBtn.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    ToggleBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Главное окно
    local MainFrame = Instance.new("Frame"); MainFrame.Size = UDim2.new(0, 380, 0, 280); MainFrame.Position = UDim2.new(0.5, -190, 0.5, -140); MainFrame.BackgroundColor3 = Color3.fromRGB(18, 12, 24); MainFrame.Visible = false; MainFrame.Parent = MenuGui
    MainFrame.ZIndex = 5
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    local Sidebar = Instance.new("Frame"); Sidebar.Size = UDim2.new(0, 100, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(12, 8, 18); Sidebar.Parent = MainFrame
    Sidebar.ZIndex = 6
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
    
    local Content = Instance.new("Frame"); Content.Size = UDim2.new(1, -100, 1, -10); Content.Position = UDim2.new(0, 100, 0, 5); Content.BackgroundTransparency = 1; Content.Parent = MainFrame
    Content.ZIndex = 7

    local Tabs = {}
    local function CreateTab(name, icon)
        local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1, -10, 0, 25); btn.Position = UDim2.new(0, 5, 0, 50 + (#Tabs * 30)); btn.BackgroundTransparency = 1; btn.Text = " " .. icon .. " " .. name; btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.Parent = Sidebar
        btn.ZIndex = 8
        table.insert(Tabs, {btn = btn, name = name})
        btn.MouseButton1Click:Connect(function()
            for _, t in ipairs(Tabs) do t.btn.TextColor3 = Color3.fromRGB(150, 150, 150) end
            btn.TextColor3 = Color3.fromRGB(150, 80, 255)
            for _, v in pairs(Content:GetChildren()) do v:Destroy() end
            
            if name == "Combat" then
                local function AddToggle(tName, key, pos)
                    local b = Instance.new("TextButton"); b.Size = UDim2.new(1, -10, 0, 30); b.Position = UDim2.new(0, 5, 0, pos); b.BackgroundColor3 = Color3.fromRGB(25, 15, 35); b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 13; b.Parent = Content
                    b.ZIndex = 9
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                    b.MouseButton1Click:Connect(function() Config[key] = not Config[key]; b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF") end)
                end
                AddToggle("Aim (Master)", "Aim_Enabled", 5)
                AddToggle("Wall Check", "WallCheck", 40)
                
                -- Переключатель режима (Silent / Camera)
                local modeBtn = Instance.new("TextButton"); modeBtn.Size = UDim2.new(1, -10, 0, 30); modeBtn.Position = UDim2.new(0, 5, 0, 80); modeBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 70); modeBtn.Text = "Mode: " .. Config.Aim_Mode; modeBtn.TextColor3 = Color3.new(1,1,1); modeBtn.Font = Enum.Font.GothamBold; modeBtn.TextSize = 13; modeBtn.Parent = Content
                modeBtn.ZIndex = 9
                Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 4)
                modeBtn.MouseButton1Click:Connect(function()
                    if Config.Aim_Mode == "Silent" then Config.Aim_Mode = "Camera" else Config.Aim_Mode = "Silent" end
                    modeBtn.Text = "Mode: " .. Config.Aim_Mode
                end)

                -- FOV Slider
                local fovFrame = Instance.new("Frame"); fovFrame.Size = UDim2.new(1, -10, 0, 45); fovFrame.Position = UDim2.new(0, 5, 0, 120); fovFrame.BackgroundColor3 = Color3.fromRGB(25, 15, 35); fovFrame.Parent = Content
                fovFrame.ZIndex = 9
                Instance.new("UICorner", fovFrame).CornerRadius = UDim.new(0, 4)
                local fovText = Instance.new("TextLabel"); fovText.Size = UDim2.new(1, -20, 0, 15); fovText.Position = UDim2.new(0, 10, 0, 5); fovText.BackgroundTransparency = 1; fovText.Text = "FOV Radius: " .. Config.FOV; fovText.TextColor3 = Color3.new(1,1,1); fovText.Font = Enum.Font.Gotham; fovText.TextSize = 12; fovText.TextXAlignment = Enum.TextXAlignment.Left; fovText.Parent = fovFrame
                fovText.ZIndex = 10
                local fovBar = Instance.new("Frame"); fovBar.Size = UDim2.new(1, -20, 0, 4); fovBar.Position = UDim2.new(0, 10, 0, 25); fovBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60); fovBar.Parent = fovFrame
                fovBar.ZIndex = 10
                local fovFill = Instance.new("Frame"); fovFill.Size = UDim2.new((Config.FOV - 20) / 280, 0, 1, 0); fovFill.BackgroundColor3 = Color3.fromRGB(150, 80, 255); fovFill.Parent = fovBar
                fovFill.ZIndex = 11
                local fovInput = Instance.new("TextButton"); fovInput.Size = UDim2.new(1, 20, 1, 20); fovInput.Position = UDim2.new(0, -10, 0, -10); fovInput.BackgroundTransparency = 1; fovInput.Text = ""; fovInput.Parent = fovBar
                fovInput.ZIndex = 12
                local fovDragging = false
                fovInput.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then fovDragging = true end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then fovDragging = false end end)
                UserInputService.InputChanged:Connect(function(i)
                    if fovDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        local p = math.clamp((i.Position.X - fovBar.AbsolutePosition.X) / fovBar.AbsoluteSize.X, 0, 1)
                        local v = math.floor(20 + 280 * p)
                        Config.FOV = v
                        fovText.Text = "FOV Radius: " .. v
                        fovFill.Size = UDim2.new(p, 0, 1, 0)
                        FOV_Frame.Size = UDim2.new(0, v * 2, 0, v * 2)
                        FOV_Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
                    end
                end)
            elseif name == "Visual" then
                local function AddToggle(tName, key, pos)
                    local b = Instance.new("TextButton"); b.Size = UDim2.new(1, -10, 0, 30); b.Position = UDim2.new(0, 5, 0, pos); b.BackgroundColor3 = Color3.fromRGB(25, 15, 35); b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 13; b.Parent = Content
                    b.ZIndex = 9
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                    b.MouseButton1Click:Connect(function() Config[key] = not Config[key]; b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF") end)
                end
                AddToggle("ESP Enabled", "ESP_Enabled", 5)
                AddToggle("Box", "ESP_Box", 40)
                AddToggle("Name", "ESP_Name", 75)
                AddToggle("Distance", "ESP_Dist", 110)
                AddToggle("Health Bar", "ESP_HP", 145)
                AddToggle("Skeleton", "ESP_Skeleton", 180)
                AddToggle("Fullbright", "Fullbright", 215)
            elseif name == "Player" then
                local function AddToggle(tName, key, pos)
                    local b = Instance.new("TextButton"); b.Size = UDim2.new(1, -10, 0, 30); b.Position = UDim2.new(0, 5, 0, pos); b.BackgroundColor3 = Color3.fromRGB(25, 15, 35); b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF"); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 13; b.Parent = Content
                    b.ZIndex = 9
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                    b.MouseButton1Click:Connect(function() Config[key] = not Config[key]; b.Text = tName .. ": " .. (Config[key] and "ON" or "OFF") end)
                end
                AddToggle("Speed", "Speed_Enabled", 5)
            end
        end)
    end
    CreateTab("Combat", "🎯"); CreateTab("Visual", "👁️"); CreateTab("Player", "🏃")
    Tabs[1].btn.TextColor3 = Color3.fromRGB(150, 80, 255)

    -- ESP
    local ESP = {}
    local function CreateESP(pl)
        if pl == LP or ESP[pl] then return end
        local e = {}
        if Drawing then
            e.box = Drawing.new("Square"); e.box.Thickness = 1; e.box.Color = Color3.new(1,1,1); e.box.Filled = false
            e.name = Drawing.new("Text"); e.name.Size = 13; e.name.Center = true; e.name.Outline = true; e.name.Color = Color3.new(1,1,1)
            e.dist = Drawing.new("Text"); e.dist.Size = 12; e.dist.Center = true; e.dist.Outline = true; e.dist.Color = Color3.new(200,200,200)
            e.hpBg = Drawing.new("Line"); e.hpBg.Thickness = 2; e.hpBg.Color = Color3.new(0,0,0)
            e.hpFill = Drawing.new("Line"); e.hpFill.Thickness = 2
        end
        ESP[pl] = e
    end

    for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end
    Players.PlayerAdded:Connect(function(p) CreateESP(p) end)

    local OldLighting = {Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient, Brightness = Lighting.Brightness}
    local CurrentTarget = nil

    -- Главный цикл (ESP + FOV)
    RunService.RenderStepped:Connect(function()
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local closest, minDist = nil, Config.FOV

        FOV_Frame.Visible = Config.Aim_Enabled

        if Config.Fullbright then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255); Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255); Lighting.Brightness = 2
        else
            Lighting.Ambient = OldLighting.Ambient; Lighting.OutdoorAmbient = OldLighting.OutdoorAmbient; Lighting.Brightness = OldLighting.Brightness
        end

        for plr, e in pairs(ESP) do
            local ch = plr.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            local head = ch and ch:FindFirstChild("Head")
            local hum = ch and ch:FindFirstChild("Humanoid")
            
            if Config.ESP_Enabled and hrp and head and hum and hum.Health > 0 then
                local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                local hpos = Camera:WorldToViewportPoint(head.Position)
                if vis and hpos.Z > 0 then
                    local size = math.abs(hpos.Y - pos.Y) * 1.5
                    local dist = (LP.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if e.box and Config.ESP_Box then e.box.Visible = true; e.box.Size = Vector2.new(size * 0.6, size); e.box.Position = Vector2.new(pos.X - size*0.3, pos.Y - size/2) elseif e.box then e.box.Visible = false end
                    if e.name and Config.ESP_Name then e.name.Visible = true; e.name.Text = plr.Name; e.name.Position = Vector2.new(pos.X, hpos.Y - 20) elseif e.name then e.name.Visible = false end
                    if e.dist and Config.ESP_Dist then e.dist.Visible = true; e.dist.Text = math.floor(dist) .. "m"; e.dist.Position = Vector2.new(pos.X, pos.Y + size/2 + 5) elseif e.dist then e.dist.Visible = false end
                    if e.hpBg and e.hpFill and Config.ESP_HP then
                        e.hpBg.Visible = true; e.hpBg.From = Vector2.new(pos.X - size*0.3 - 5, pos.Y - size/2); e.hpBg.To = Vector2.new(pos.X - size*0.3 - 5, pos.Y + size/2)
                        local hp = hum.Health / hum.MaxHealth
                        e.hpFill.Visible = true; e.hpFill.From = Vector2.new(pos.X - size*0.3 - 5, pos.Y + size/2); e.hpFill.To = Vector2.new(pos.X - size*0.3 - 5, pos.Y + size/2 - (size * hp)); e.hpFill.Color = Color3.fromRGB(255*(1-hp), 255*hp, 0)
                    elseif e.hpBg then e.hpBg.Visible = false; e.hpFill.Visible = false end
                else
                    if e.box then e.box.Visible = false end; if e.name then e.name.Visible = false end; if e.dist then e.dist.Visible = false end; if e.hpBg then e.hpBg.Visible = false; e.hpFill.Visible = false end
                end
            else
                if e.box then e.box.Visible = false end; if e.name then e.name.Visible = false end; if e.dist then e.dist.Visible = false end; if e.hpBg then e.hpBg.Visible = false; e.hpFill.Visible = false end
            end

            if Config.Aim_Enabled and hum and hum.Health > 0 and head then
                local sp, vis2 = Camera:WorldToViewportPoint(head.Position)
                if vis2 then
                    local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if d < minDist then minDist = d; closest = head end
                end
            end
        end

        CurrentTarget = closest
        _G.CurrentTarget = closest

        if Config.Speed_Enabled and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            local hum = LP.Character:FindFirstChild("Humanoid")
            if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                hrp.Velocity = Vector3.new(hum.MoveDirection.X * Config.Speed_Value, hrp.Velocity.Y, hum.MoveDirection.Z * Config.Speed_Value)
            end
        end
    end)

    -- Camera Lock (Для луков)
    local oldCFrame = nil
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and Config.Aim_Enabled and Config.Aim_Mode == "Camera" and CurrentTarget then
            oldCFrame = Camera.CFrame
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, CurrentTarget.Position)
            task.wait(0.05)
            if oldCFrame then Camera.CFrame = oldCFrame end
        end
    end)

    -- Silent Aim Hook (Для пуль)
    if hookmetamethod and getnamecallmethod then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "Raycast" and self == Workspace then
                if checkcaller() then return oldNamecall(self, ...) end
                local args = {...}
                local origin, direction = args[1], args[2]
                if typeof(origin) == "Vector3" and typeof(direction) == "Vector3" and direction.Magnitude > 50 then
                    if Config.Aim_Enabled and Config.Aim_Mode == "Silent" and _G.CurrentTarget then
                        local newDir = (_G.CurrentTarget.Position - origin).Unit * direction.Magnitude
                        return oldNamecall(self, origin, newDir, args[3])
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
    end
end

KeySubmit.MouseButton1Click:Connect(function()
    local data = KEY_DATABASE[KeyInput.Text]
    if data then
        if data.user == "ALL" or data.user == LP.Name then
            UserRole = data.role
            KeyGui:Destroy()
            StartCheat()
        else
            KeyInput.Text = ""; KeyInput.PlaceholderText = "Ключ привязан к " .. data.user
        end
    else
        KeyInput.Text = ""; KeyInput.PlaceholderText = "Неверный ключ!"
    end
end)
