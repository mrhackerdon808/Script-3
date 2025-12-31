
--====================================
-- FAKE AVATAR SIZE (DELTA SAFE)
-- By mrhackerdon
--====================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Char, Hum, HRP

local function setup()
	Char = LP.Character or LP.CharacterAdded:Wait()
	Hum = Char:WaitForChild("Humanoid")
	HRP = Char:WaitForChild("HumanoidRootPart")
end

setup()
LP.CharacterAdded:Connect(function()
	task.wait(1)
	setup()
end)

-- SETTINGS
local SIZE_MULTIPLIER = 1.6   -- try 1.3 / 1.5 / 2
local CAM_HEIGHT = 6          -- camera height boost

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
	if not Char or not HRP then return end

	-- Fake height (camera + hip)
	Hum.HipHeight = 2 * SIZE_MULTIPLIER
	Camera.CFrame = Camera.CFrame + Vector3.new(0, CAM_HEIGHT * 0.01, 0)
end)