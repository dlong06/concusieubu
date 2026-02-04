-- Config
getgenv().MyConfig = {
    ["CameraLockPlayer"] = false, -- mặc định tắt
    ["SelectedPlayer"] = nil
}

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
ScreenGui.Name = "LockCamGUI"
ScreenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", ScreenGui)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

-- Danh sách player
local playerList = Instance.new("ScrollingFrame", frame)
playerList.Size = UDim2.new(0,200,0,200)
playerList.Position = UDim2.new(0,25,0,20)
playerList.CanvasSize = UDim2.new(0,0,0,0)
playerList.BackgroundColor3 = Color3.fromRGB(50,50,50)

-- Hàm refresh danh sách player
local function refreshPlayerList()
    playerList:ClearAllChildren()
    local y = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local btn = Instance.new("TextButton", playerList)
            btn.Size = UDim2.new(0,180,0,30)
            btn.Position = UDim2.new(0,10,0,y)
            btn.Text = p.Name
            btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
            btn.MouseButton1Click:Connect(function()
                getgenv().MyConfig["SelectedPlayer"] = p
            end)
            y = y + 35
        end
    end
    playerList.CanvasSize = UDim2.new(0,0,0,y)
end

-- Nút Refresh Player
local refreshBtn = Instance.new("TextButton", frame)
refreshBtn.Size = UDim2.new(0,200,0,30)
refreshBtn.Position = UDim2.new(0,25,0,230)
refreshBtn.Text = "Refresh Player"
refreshBtn.BackgroundColor3 = Color3.fromRGB(0,120,200)
refreshBtn.MouseButton1Click:Connect(refreshPlayerList)

-- Refresh lần đầu
refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- Toggle lockcam bằng phím G (ON/OFF)
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.G and not gpe then
        getgenv().MyConfig["CameraLockPlayer"] = not getgenv().MyConfig["CameraLockPlayer"]
        print("LockCam: " .. (getgenv().MyConfig["CameraLockPlayer"] and "ON" or "OFF"))
    end
end)

-- Vòng lặp chính
game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().MyConfig["CameraLockPlayer"] and getgenv().MyConfig["SelectedPlayer"] then
        local target = getgenv().MyConfig["SelectedPlayer"]
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)
