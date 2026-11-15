--[[ ROST ALPHA | Custom UI + Key System ]]
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
    Aim_Enabled = false, TargetPart = "Head", FOV = 150, WallCheck = false,
    ESP_Enabled = false, Speed_Enabled = false, Speed_Value = 30,
}

-- Key System
local KeyGui = Instance.new("ScreenGui"); KeyGui.Name = "sg_" .. rnd(); KeyGui.ResetOnSpawn = false; KeyGui.Parent = GuiParent
local KeyFrame = Instance.new("Frame"); KeyFrame.Size = UDim2.new(0, 250, 0, 120); KeyFrame.Position = UDim2.new(0.5, -125, 0.5, -60); KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); KeyFrame.Parent = KeyGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)
local KeyTitle = Instance.new("TextLabel"); KeyTitle.Size = UDim2.new(1, 0, 0, 30); KeyTitle.BackgroundTransparency = 1; KeyTitle.Text = "Введите ключ"; KeyTitle.TextColor3 = Color3.new(1,1,1); KeyTitle.Font = Enum.Font.GothamBold; KeyTitle.TextSize = 16; KeyTitle.Parent = KeyFrame
local KeyInput = Instance.new("TextBox"); KeyInput.Size = UDim2.new(1, -20, 0, 30); KeyInput.Position = UDim2.new(0, 10, 0, 40); KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45); KeyInput.TextColor3 = Color3.new(1,1,1); KeyInput.PlaceholderText = "Ключ..."; KeyInput.Font = Enum.Font.Gotham; KeyInput.TextSize = 14; KeyInput.Parent = KeyFrame
local KeySubmit = Instance.new("TextButton"); KeySubmit.Size = UDim2.new(1, -20, 0, 30); KeySubmit.Position = UDim2.new(0, 10, 0, 80); KeySubmit.BackgroundColor3 = Color3.fromRGB(150, 80, 255); KeySubmit.Text = "Активировать"; KeySubmit.TextColor3 = Color3.new(1,1,1); KeySubmit.Font = Enum.Font.GothamBold; KeySubmit.TextSize = 14; KeySubmit.Parent = KeyFrame

local function StartCheat()
    local playerCache = {}
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then playerCache[p] = true end end
    Players.PlayerAdded:Connect(function(p) playerCache[p] = true end)
    Players.PlayerRemoving:Connect(function(p) playerCache[p] = nil end)

    local function getClosestPlayer()
        local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        local best, bestDist = nil, math.huge
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        for plr in pairs(playerCache) do
            local ch = plr.Character
            if ch then
                local part = ch:FindFirstChild(Config.TargetPart) or ch:FindFirstChild("HumanoidRootPart")
                local hum = ch:FindFirstChild("Humanoid")
                if part and hum and hum.Health > 0 then
                    local sp, vis = Camera:WorldToViewportPoint(part.Position)
                    if vis then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if d < Config.FOV then
                            if Config.WallCheck then
                                local rayParams = RaycastParams.new(); rayParams.FilterDescendantsInstances = {LP.Character, ch}
                                local ray = Workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, rayParams)
                                if ray then continue end
                            end
                            if d < bestDist then bestDist = d; best = part end
                        end
                    end
                end
            end
        end
        return best
    end

    local MenuGui = Instance.new("ScreenGui"); MenuGui.Name = "sg_" .. rnd(); MenuGui.ResetOnSpawn = false; MenuGui.Parent = GuiParent
    
    local ToggleBtn = Instance.new("TextButton"); ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Position = UDim2.new(0.5, -25, 0.5, -25); ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 80, 255); ToggleBtn.Text = "F"; ToggleBtn.TextColor3 = Color3.new(1,1,1); ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.TextSize = 20; ToggleBtn.Parent = MenuGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    
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

    local MainFrame = Instance.new("Frame"); MainFrame.Size = UDim2.new(0, 300, 0, 350); MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175); MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); MainFrame.Visible = false; MainFrame.Parent = MenuGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    local TabContainer = Instance.new("Frame"); TabContainer.Size = UDim2.new(1, 0, 0, 30); TabContainer.BackgroundTransparency = 1; TabContainer.Parent = MainFrame
    local Content = Instance.new("Frame"); Content.Size = UDim2.new(1, -20, 1, -40); Content.Position = UDim2.new(0, 10, 0, 35); Content.BackgroundTransparency = 1; Content.Parent = MainFrame

    local function CreateTab(name, posX)
        local btn = Instance.new("TextButton"); btn.Size = UDim2.new(0, 80, 1, 0); btn.Position = UDim2.new(0, posX, 0, 0); btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45); btn.Text = name; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.Parent = TabContainer
        btn.MouseButton1Click:Connect(function()
            for _, v in pairs(Content:GetChildren()) do v:Destroy() end
            if name == "Combat" then
                local t1 = Instance.new("TextButton"); t1.Size = UDim2.new(1, 0, 0, 30); t1.BackgroundColor3 = Color3.fromRGB(40, 40, 45); t1.Text = "Silent Aim: " .. (Config.Aim_Enabled and "ON" or "OFF"); t1.TextColor3 = Color3.new(1,1,1); t1.Parent = Content
                t1.MouseButton1Click:Connect(function() Config.Aim_Enabled = not Config.Aim_Enabled; t1.Text = "Silent Aim: " .. (Config.Aim_Enabled and "ON" or "OFF") end)
                local t2 = Instance.new("TextButton"); t2.Size = UDim2.new(1, 0, 0, 30); t2.Position = UDim2.new(0, 0, 0, 35); t2.BackgroundColor3 = Color3.fromRGB(40, 40, 45); t2.Text = "Wall Check: " .. (Config.WallCheck and "ON" or "OFF"); t2.TextColor3 = Color3.new(1,1,1); t2.Parent = Content
                t2.MouseButton1Click:Connect(function() Config.WallCheck = not Config.WallCheck; t2.Text = "Wall Check: " .. (Config.WallCheck and "ON" or "OFF") end)
            elseif name == "Visual" then
                local t1 = Instance.new("TextButton"); t1.Size = UDim2.new(1, 0, 0, 30); t1.BackgroundColor3 = Color3.fromRGB(40, 40, 45); t1.Text = "ESP: " .. (Config.ESP_Enabled and "ON" or "OFF"); t1.TextColor3 = Color3.new(1,1,1); t1.Parent = Content
                t1.MouseButton1Click:Connect(function() Config.ESP_Enabled = not Config.ESP_Enabled; t1.Text = "ESP: " .. (Config.ESP_Enabled and "ON" or "OFF") end)
            elseif name == "Player" then
                local t1 = Instance.new("TextButton"); t1.Size = UDim2.new(1, 0, 0, 30); t1.BackgroundColor3 = Color3.fromRGB(40, 40, 45); t1.Text = "Speed: " .. (Config.Speed_Enabled and "ON" or "OFF"); t1.TextColor3 = Color3.new(1,1,1); t1.Parent = Content
                t1.MouseButton1Click:Connect(function() Config.Speed_Enabled = not Config.Speed_Enabled; t1.Text = "Speed: " .. (Config.Speed_Enabled and "ON" or "OFF") end)
            end
        end)
    end
    CreateTab("Combat", 0); CreateTab("Visual", 80); CreateTab("Player", 160)

    if hookmetamethod and getnamecallmethod then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "Raycast" and self == Workspace then
                if checkcaller() then return oldNamecall(self, ...) end
                local args = {...}
                local origin, direction = args[1], args[2]
                if typeof(origin) == "Vector3" and typeof(direction) == "Vector3" and direction.Magnitude > 50 then
                    if Config.Aim_Enabled then
                        local target = getClosestPlayer()
                        if target then
                            local newDir = (target.Position - origin).Unit * direction.Magnitude
                            return oldNamecall(self, origin, newDir, args[3])
                        end
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
    end

    RunService.Heartbeat:Connect(function()
        if Config.Speed_Enabled and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            local hum = LP.Character:FindFirstChild("Humanoid")
            if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                hrp.Velocity = Vector3.new(hum.MoveDirection.X * Config.Speed_Value, hrp.Velocity.Y, hum.MoveDirection.Z * Config.Speed_Value)
            end
        end
    end)
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
