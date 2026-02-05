repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer

-- Config mặc định
local Settings = {
    AimKey = Enum.UserInputType.MouseButton2,
    HoldToAim = true,
    FOV = 100,
    Smooth = 0.2,
    TargetPlayer = nil,
    AimbotEnabled = true,
    PredictionSpeed = 200,
    AimFunction = "Normal", -- Normal / SkillLock
}

-- GUI
local ScreenGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
ScreenGui.Name = "BloxFruit_Aimbot_GUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 350)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "Aimbot Config"
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.TextColor3 = Color3.new(1,1,1)

-- FOV chỉnh
local FOVBox = Instance.new("TextBox", Frame)
FOVBox.Size = UDim2.new(1, -10, 0, 30)
FOVBox.Position = UDim2.new(0,5,0,40)
FOVBox.Text = tostring(Settings.FOV)
FOVBox.PlaceholderText = "Nhập FOV"
FOVBox.FocusLost:Connect(function()
    local val = tonumber(FOVBox.Text)
    if val then Settings.FOV = val end
end)

-- Smooth chỉnh
local SmoothBox = Instance.new("TextBox", Frame)
SmoothBox.Size = UDim2.new(1, -10, 0, 30)
SmoothBox.Position = UDim2.new(0,5,0,80)
SmoothBox.Text = tostring(Settings.Smooth)
SmoothBox.PlaceholderText = "Nhập Smooth"
SmoothBox.FocusLost:Connect(function()
    local val = tonumber(SmoothBox.Text)
    if val then Settings.Smooth = val end
end)

-- Prediction chỉnh
local PredictionBox = Instance.new("TextBox", Frame)
PredictionBox.Size = UDim2.new(1, -10, 0, 30)
PredictionBox.Position = UDim2.new(0,5,0,120)
PredictionBox.Text = tostring(Settings.PredictionSpeed)
PredictionBox.PlaceholderText = "Nhập Prediction Speed"
PredictionBox.FocusLost:Connect(function()
    local val = tonumber(PredictionBox.Text)
    if val then Settings.PredictionSpeed = val end
end)

-- Aim Mode toggle (Hold/Click)
local AimModeButton = Instance.new("TextButton", Frame)
AimModeButton.Size = UDim2.new(1, -10, 0, 30)
AimModeButton.Position = UDim2.new(0,5,0,160)
AimModeButton.Text = Settings.HoldToAim and "Aim Mode: Hold" or "Aim Mode: Toggle"
AimModeButton.MouseButton1Click:Connect(function()
    Settings.HoldToAim = not Settings.HoldToAim
    AimModeButton.Text = Settings.HoldToAim and "Aim Mode: Hold" or "Aim Mode: Toggle"
end)

-- Aim Function toggle (Normal / SkillLock)
local AimFunctionButton = Instance.new("TextButton", Frame)
AimFunctionButton.Size = UDim2.new(1, -10, 0, 30)
AimFunctionButton.Position = UDim2.new(0,5,0,190)
AimFunctionButton.Text = "Aim Function: "..Settings.AimFunction
AimFunctionButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
AimFunctionButton.TextColor3 = Color3.new(1,1,1)
AimFunctionButton.MouseButton1Click:Connect(function()
    if Settings.AimFunction == "Normal" then
        Settings.AimFunction = "SkillLock"
    else
        Settings.AimFunction = "Normal"
    end
    AimFunctionButton.Text = "Aim Function: "..Settings.AimFunction
end)

-- Danh sách player
local PlayerListFrame = Instance.new("ScrollingFrame", Frame)
PlayerListFrame.Size = UDim2.new(1, -10, 0, 60)
PlayerListFrame.Position = UDim2.new(0,5,0,230)
PlayerListFrame.CanvasSize = UDim2.new(0,0,0,0)
PlayerListFrame.ScrollBarThickness = 6
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)

local function refreshPlayerList()
    PlayerListFrame:ClearAllChildren()
    local y = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local btn = Instance.new("TextButton", PlayerListFrame)
            btn.Size = UDim2.new(1, -10, 0, 25)
            btn.Position = UDim2.new(0,5,0,y)
            btn.Text = p.Name
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.MouseButton1Click:Connect(function()
                Settings.TargetPlayer = p
            end)
            y = y + 25
        end
    end
    PlayerListFrame.CanvasSize = UDim2.new(0,0,0,y)
end

-- Nút refresh danh sách
local RefreshButton = Instance.new("TextButton", Frame)
RefreshButton.Size = UDim2.new(1, -10, 0, 30)
RefreshButton.Position = UDim2.new(0,5,0,290)
RefreshButton.Text = "Refresh Player List"
RefreshButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
RefreshButton.TextColor3 = Color3.new(1,1,1)
RefreshButton.MouseButton1Click:Connect(refreshPlayerList)

-- Nút B: bật/tắt aimbot
local ToggleAimbotButton = Instance.new("TextButton", Frame)
ToggleAimbotButton.Size = UDim2.new(1, -10, 0, 30)
ToggleAimbotButton.Position = UDim2.new(0,5,0,320)
ToggleAimbotButton.Text = Settings.AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
ToggleAimbotButton.BackgroundColor3 = Color3.fromRGB(90,90,90)
ToggleAimbotButton.TextColor3 = Color3.new(1,1,1)
ToggleAimbotButton.MouseButton1Click:Connect(function()
    Settings.AimbotEnabled = not Settings.AimbotEnabled
    ToggleAimbotButton.Text = Settings.AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
end)

-- load lần đầu
refreshPlayerList()

-- Aimbot Function
local aiming = false
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Settings.AimKey or input.KeyCode == Settings.AimKey then
        if Settings.HoldToAim then
            aiming = true
        else
            aiming = not aiming
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if Settings.HoldToAim and (input.UserInputType == Settings.AimKey or input.KeyCode == Settings.AimKey) then
        aiming = false
    end
end)

-- Hàm chọn target
local function getClosestEnemy()
    if Settings.TargetPlayer and Settings.TargetPlayer.Character and Settings.TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local body = Settings.TargetPlayer.Character.HumanoidRootPart
        local pos, onScreen = Camera:WorldToViewportPoint(body.Position)
        local mag = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
        if onScreen and mag < Settings.FOV then
            return body
        else
            return nil
        end
    end

    local closest, dist = nil, math.huge
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = lp.Character.HumanoidRootPart.Position

        for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp 
           and p.Team ~= lp.Team 
           and p.Character 
           and p.Character:FindFirstChild("HumanoidRootPart") then

            local body = p.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(body.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                local distance = (myPos - body.Position).Magnitude
                if mag < Settings.FOV and distance <= 900 and distance < dist then
                    dist = distance
                    closest = body
                end
            end
        end
    end
    return closest
end

-- Vẽ vòng FOV
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(0,255,0)
circle.Thickness = 1
circle.NumSides = 64
circle.Filled = false
circle.Visible = true

RS.RenderStepped:Connect(function()
    circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    circle.Radius = Settings.FOV

    if aiming and Settings.AimbotEnabled then
        local target = getClosestEnemy()
        if target then
            local pos, onScreen = Camera:WorldToViewportPoint(target.Position)
            local mag = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude

            if onScreen and mag < Settings.FOV then
                local aimPos

                -- Prediction riêng cho Buddy Sword
                local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
                if tool and tool.Name == "Buddy Sword" then
                    local hrp = target
                    local velocity = hrp.Velocity
                    local distance = (lp.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    local travelTime = distance / Settings.PredictionSpeed
                    aimPos = hrp.Position + (velocity * travelTime)
                else
                    aimPos = target.Position
                end

                if Settings.AimFunction == "Normal" then
                    -- Quay camera bình thường
                    local current = Camera.CFrame
                    local goal = CFrame.new(Camera.CFrame.Position, aimPos)
                    Camera.CFrame = current:Lerp(goal, Settings.Smooth)
                elseif Settings.AimFunction == "SkillLock" then
                    -- Skill/Click auto-hit: ép camera nhìn vào target
                    local current = Camera.CFrame
                    local goal = CFrame.new(Camera.CFrame.Position, aimPos)
                    Camera.CFrame = current:Lerp(goal, Settings.Smooth)
                end
            end
        end
    end
end)
