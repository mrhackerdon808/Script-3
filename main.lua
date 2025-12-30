--====================================
-- AVATAR AIO + AUTO R6/R15 HELPER
-- Delta Safe | Client | Mobile
--====================================

if getgenv().AIO_RIG_HELP then return end
getgenv().AIO_RIG_HELP = true

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LP = Players.LocalPlayer

--================ STATE =================
local ENABLED = true
local IS_R15 = false
local legScale = 0.4
local widthScale = 1
local FLOAT = false
local floatHeight = 3
local FLOAT_MIN, FLOAT_MAX = 1, 10

--================ CHAR =================
local function getChar()
    return LP.Character or LP.CharacterAdded:Wait()
end

local function detectRig()
    local hum = getChar():WaitForChild("Humanoid")
    IS_R15 = hum.RigType == Enum.HumanoidRigType.R15
    return hum
end

--================ NOTIFY =================
local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Avatar Mod",
            Text = txt,
            Duration = 5
        })
    end)
end

--================ LONG LEGS (R15) =================
local function resetLegs()
    if not IS_R15 then return end
    for _,m in pairs(getChar():GetDescendants()) do
        if m:IsA("Motor6D") and (m.Name:find("Hip") or m.Name:find("Knee")) then
            m.Transform = CFrame.new()
        end
    end
end

local function setLongLegs(v)
    if not IS_R15 then return end
    for _,m in pairs(getChar():GetDescendants()) do
        if m:IsA("Motor6D") and (m.Name:find("Hip") or m.Name:find("Knee")) then
            m.Transform = CFrame.new(0, v, 0)
        end
    end
end

--================ APPLY =================
local function apply()
    if not ENABLED then return end
    local hum = detectRig()

    if not IS_R15 then
        notify("R6 detected! Switch to R15 to use avatar mods.")
        return
    end

    resetLegs()
    setLongLegs(legScale)
    hum.BodyWidthScale.Value = widthScale
end

--================ FLOAT =================
local bp, bg

local function startFloat()
    local hrp = getChar():FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    bp = Instance.new("BodyPosition", hrp)
    bp.MaxForce = Vector3.new(0, math.huge, 0)
    bp.P = 3000
    bp.D = 200
    bp.Position = hrp.Position + Vector3.new(0, floatHeight, 0)

    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 3000
    bg.CFrame = hrp.CFrame
end

local function stopFloat()
    if bp then bp:Destroy() bp=nil end
    if bg then bg:Destroy() bg=nil end
end

--================ RESPAWN =================
LP.CharacterAdded:Connect(function()
    task.wait(1)
    detectRig()
    apply()
    if FLOAT then startFloat() end
end)

--================ GUI =================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.36,0.62)
frame.Position = UDim2.fromScale(0.05,0.2)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

local function btn(txt,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.fromScale(0.9,0.09)
    b.Position = UDim2.fromScale(0.05,y)
    b.Text = txt
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
    return b
end

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.1)
title.BackgroundTransparency = 1
title.Text = "AVATAR AIO"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

local rigLabel = Instance.new("TextLabel", frame)
rigLabel.Size = UDim2.fromScale(1,0.07)
rigLabel.Position = UDim2.fromScale(0,0.1)
rigLabel.BackgroundTransparency = 1
rigLabel.TextScaled = true

local switchBtn = btn("🔄 SWITCH TO R15", 0.18)
local legP = btn("🦵 Long Legs +", 0.28)
local legM = btn("🦵 Long Legs -", 0.38)
local widthBtn = btn("🧍 Width +", 0.48)
local floatBtn = btn("🛸 Float OFF", 0.58)

-- SLIDER
local sliderBG = Instance.new("Frame", frame)
sliderBG.Size = UDim2.fromScale(0.9,0.06)
sliderBG.Position = UDim2.fromScale(0.05,0.70)
sliderBG.BackgroundColor3 = Color3.fromRGB(45,45,45)
Instance.new("UICorner", sliderBG).CornerRadius = UDim.new(1,0)

local slider = Instance.new("Frame", sliderBG)
slider.Size = UDim2.fromScale(floatHeight/FLOAT_MAX,1)
slider.BackgroundColor3 = Color3.fromRGB(80,170,255)
Instance.new("UICorner", slider).CornerRadius = UDim.new(1,0)

--================ BUTTON LOGIC =================
switchBtn.MouseButton1Click:Connect(function()
    notify("Avatar → Edit → Scale → Body Type = 100% → Save → Reset")
end)

legP.MouseButton1Click:Connect(function()
    if not IS_R15 then return end
    legScale = math.clamp(legScale + 0.1, 0, 1.2)
    apply()
end)

legM.MouseButton1Click:Connect(function()
    if not IS_R15 then return end
    legScale = math.clamp(legScale - 0.1, 0, 1.2)
    apply()
end)

widthBtn.MouseButton1Click:Connect(function()
    if not IS_R15 then return end
    widthScale = math.clamp(widthScale + 0.1, 0.6, 2)
    apply()
end)

floatBtn.MouseButton1Click:Connect(function()
    FLOAT = not FLOAT
    floatBtn.Text = FLOAT and "🛸 Float ON" or "🛸 Float OFF"
    if FLOAT then startFloat() else stopFloat() end
end)

sliderBG.InputBegan:Connect(function(i)
    if i.UserInputType ~= Enum.UserInputType.Touch then return end
    local x = math.clamp(
        (i.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X,
        0,1
    )
    floatHeight = math.max(FLOAT_MIN, math.floor(x * FLOAT_MAX))
    slider.Size = UDim2.fromScale(x,1)

    if bp then
        local hrp = getChar():FindFirstChild("HumanoidRootPart")
        if hrp then
            bp.Position = hrp.Position + Vector3.new(0, floatHeight, 0)
        end
    end
end)

--================ INIT =================
task.wait(1)
detectRig()
rigLabel.Text = IS_R15 and "✅ R15 DETECTED" or "⚠️ R6 DETECTED"
rigLabel.TextColor3 = IS_R15 and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,80,80)
apply()

print("✅ Avatar AIO + R6→R15 Helper Loaded")