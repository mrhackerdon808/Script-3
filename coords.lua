--==============================
-- SIMPLE COORDINATE VIEWER
-- Luna / Delta Safe
--==============================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

-- get HRP safely
local function getHRP()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart", 5)
end

local HRP = getHRP()

-- UI Parent (safer than CoreGui)
local gui = Instance.new("ScreenGui")
gui.Name = "CoordUI"
gui.Parent = LP:WaitForChild("PlayerGui")

-- Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 110)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,25)
title.BackgroundTransparency = 1
title.Text = "📍 Coordinates"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15

-- Text
local text = Instance.new("TextLabel", frame)
text.Position = UDim2.new(0,10,0,30)
text.Size = UDim2.new(1,-20,0,45)
text.BackgroundTransparency = 1
text.TextWrapped = true
text.TextXAlignment = Enum.TextXAlignment.Left
text.TextYAlignment = Enum.TextYAlignment.Top
text.Font = Enum.Font.Code
text.TextSize = 14
text.TextColor3 = Color3.fromRGB(0,255,170)
text.Text = "Loading..."

-- Button
local btn = Instance.new("TextButton", frame)
btn.Position = UDim2.new(0.15,0,1,-30)
btn.Size = UDim2.new(0.7,0,0,25)
btn.Text = "Copy"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.TextColor3 = Color3.new(1,1,1)
btn.BackgroundColor3 = Color3.fromRGB(60,130,100)

Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

local last = ""

-- Update
RunService.RenderStepped:Connect(function()
    if HRP and HRP.Parent then
        local p = HRP.Position
        last = string.format("X: %.1f\nY: %.1f\nZ: %.1f", p.X, p.Y, p.Z)
        text.Text = last
    end
end)

-- Copy
btn.MouseButton1Click:Connect(function()
    if typeof(setclipboard) == "function" then
        setclipboard(last)
        btn.Text = "Copied!"
        task.delay(1, function()
            btn.Text = "Copy"
        end)
    else
        btn.Text = "No Clipboard"
    end
end)

-- Respawn fix
LP.CharacterAdded:Connect(function()
    HRP = getHRP()
end)