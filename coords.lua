--==============================
-- COORDINATES VIEWER (FIXED)
-- Mobile + Simulator Safe
--==============================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

local function getHRP()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local HRP = getHRP()

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "CoordsUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = LP:WaitForChild("PlayerGui")

-- Frame
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 260, 0, 130)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.ZIndex = 100

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundTransparency = 1
title.Text = "📍 Coordinates"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.ZIndex = 101

-- Coordinates text
local coords = Instance.new("TextLabel")
coords.Parent = frame
coords.Position = UDim2.new(0, 10, 0, 35)
coords.Size = UDim2.new(1, -20, 0, 55)
coords.BackgroundTransparency = 1
coords.TextWrapped = true
coords.TextXAlignment = Enum.TextXAlignment.Left
coords.TextYAlignment = Enum.TextYAlignment.Top
coords.Font = Enum.Font.Code
coords.TextSize = 15
coords.TextColor3 = Color3.fromRGB(0, 255, 180)
coords.Text = "Waiting..."
coords.ZIndex = 101

-- Copy button
local copy = Instance.new("TextButton")
copy.Parent = frame
copy.Size = UDim2.new(0.7, 0, 0, 26)
copy.Position = UDim2.new(0.15, 0, 1, -32)
copy.Text = "Copy Coordinates"
copy.Font = Enum.Font.GothamBold
copy.TextSize = 14
copy.TextColor3 = Color3.fromRGB(255,255,255)
copy.BackgroundColor3 = Color3.fromRGB(40, 140, 100)
copy.ZIndex = 101

Instance.new("UICorner", copy).CornerRadius = UDim.new(0, 8)

local lastText = ""

-- Update loop (more stable)
RunService.Heartbeat:Connect(function()
    if HRP and HRP.Parent then
        local p = HRP.Position
        lastText = string.format(
            "X: %.2f\nY: %.2f\nZ: %.2f",
            p.X, p.Y, p.Z
        )
        coords.Text = lastText
    end
end)

-- Copy
copy.MouseButton1Click:Connect(function()
    if typeof(setclipboard) == "function" then
        setclipboard(lastText)
        copy.Text = "Copied!"
        task.delay(1, function()
            copy.Text = "Copy Coordinates"
        end)
    else
        copy.Text = "No Clipboard"
    end
end)

-- Respawn fix
LP.CharacterAdded:Connect(function()
    HRP = getHRP()
end)