--==============================
-- 2 STUDS FORWARD TELEPORT
-- FLOATING BUTTON (MOBILE)
--==============================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer

-- Character function
local function getHRP()
	local char = LP.Character or LP.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "Teleport2StudsGUI"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 130, 0, 50)
btn.Position = UDim2.new(0.05, 0, 0.6, 0)
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "➡ TP +2"
btn.TextSize = 18
btn.Font = Enum.Font.GothamBold
btn.Active = true
btn.Draggable = true
btn.Parent = gui

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = btn

-- Teleport Function
btn.MouseButton1Click:Connect(function()
	local hrp = getHRP()
	local forward = hrp.CFrame.LookVector * 5
	hrp.CFrame = hrp.CFrame + forward
end)