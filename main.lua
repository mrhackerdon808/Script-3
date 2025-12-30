--====================================
-- AVATAR MOD MENU (LOADER VERSION)
-- Long Legs | Width | Float | Toggle
-- Delta Safe | Client Side
--====================================

if getgenv().AVATAR_MOD_LOADED then return end
getgenv().AVATAR_MOD_LOADED = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- STATE
local ENABLED = true
local legScale = 1.5
local widthScale = 1
local FLOAT = false
local floatConn

-- LIMITS
local MIN = 1
local MAX = 2.5
local STEP = 0.1

-- Character
local function getHumanoid()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    if hum.RigType ~= Enum.HumanoidRigType.R15 then return nil end
    return hum
end

-- Apply avatar changes
local function apply()
    if not ENABLED then return end
    local hum = getHumanoid()
    if not hum then return end

    hum.BodyHeightScale.Value = legScale
    hum.BodyWidthScale.Value  = widthScale
end

-- Float
local function startFloat()
    if floatConn then return end
    floatConn = RunService.RenderStepped:Connect(function()
        if not FLOAT then return end
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 1.5, hrp.Velocity.Z)
        end
    end)
end

local function stopFloat()
    if floatConn then
        floatConn:Disconnect()
        floatConn = nil
    end
end

-- Respawn
LP.CharacterAdded:Connect(function()
    task.wait(1)
    apply()
    if FLOAT then startFloat() end
end)

--================ GUI =================

local gui = Instance.new("ScreenGui")
gui.Name = "AvatarMenu"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.35, 0.45)
frame.Position = UDim2.fromScale(0.05, 0.25)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.15)
title.BackgroundTransparency = 1
title.Text = "AVATAR MOD MENU"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local function button(txt, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.fromScale(0.9,0.11)
    b.Position = UDim2.fromScale(0.05,y)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
    return b
end

local toggleBtn = button("🟢 ENABLED", 0.17)
local legPlus   = button("🦵 Leg +",   0.30)
local legMinus  = button("🦵 Leg -",   0.42)
local widthBtn  = button("🧍 Width +", 0.54)
local floatBtn  = button("🛸 Float OFF",0.66)

-- Buttons
toggleBtn.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    toggleBtn.Text = ENABLED and "🟢 ENABLED" or "🔴 DISABLED"
    if ENABLED then apply() end
end)

legPlus.MouseButton1Click:Connect(function()
    legScale = math.clamp(legScale + STEP, MIN, MAX)
    apply()
end)

legMinus.MouseButton1Click:Connect(function()
    legScale = math.clamp(legScale - STEP, MIN, MAX)
    apply()
end)

widthBtn.MouseButton1Click:Connect(function()
    widthScale = math.clamp(widthScale + STEP, 0.6, 2)
    apply()
end)

floatBtn.MouseButton1Click:Connect(function()
    FLOAT = not FLOAT
    floatBtn.Text = FLOAT and "🛸 Float ON" or "🛸 Float OFF"
    if FLOAT then startFloat() else stopFloat() end
end)

-- Init
task.wait(1)
apply()

print("✅ Avatar Mod Menu Loaded via Loader")