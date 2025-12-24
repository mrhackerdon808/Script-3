--=====================================
-- COORDINATE VIEWER & COPY TOOL
-- Luna / Delta Executor Compatible
--=====================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer

-- Wait for character
local function getHRP()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local HRP = getHRP()

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "CoordViewer"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 140)
frame.Position = UDim2.new(0.03, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "📍 Coordinates"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Coord Label
local coordLabel = Instance.new("TextLabel", frame)
coordLabel.Position = UDim2.new(0, 10, 0, 40)
coordLabel.Size = UDim2.new(1, -20, 0, 50)
coordLabel.BackgroundTransparency = 1
coordLabel.TextWrapped = true
coordLabel.TextXAlignment = Left
coordLabel.TextYAlignment = Top
coordLabel.Font = Enum.Font.Code
coordLabel.TextSize = 14
coordLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
coordLabel.Text = "Loading..."

-- Copy Button
local copyBtn = Instance.new("TextButton", frame)
copyBtn.Position = UDim2.new(0.1, 0, 1, -40)
copyBtn.Size = UDim2.new(0.8, 0, 0, 30)
copyBtn.Text = "📋 Copy Coordinates"
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 14
copyBtn.TextColor3 = Color3.new(1,1,1)
copyBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 90)

local btnCorner = Instance.new("UICorner", copyBtn)
btnCorner.CornerRadius = UDim.new(0, 10)

-- Update loop
local lastText = ""

RunService.RenderStepped:Connect(function()
    if HRP and HRP.Parent then
        local pos = HRP.Position
        lastText = string.format(
            "X: %.2f\nY: %.2f\nZ: %.2f",
            pos.X, pos.Y, pos.Z
        )
        coordLabel.Text = lastText
    end
end)

-- Copy to clipboard
copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(lastText)
        copyBtn.Text = "✅ Copied!"
        task.delay(1, function()
            copyBtn.Text = "📋 Copy Coordinates"
        end)
    else
        copyBtn.Text = "❌ Clipboard Not Supported"
    end
end)

-- Reconnect on respawn
LP.CharacterAdded:Connect(function()
    HRP = getHRP()

end)