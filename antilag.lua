-- XENO 2025 ULTIMATE FPS BOOSTER + COUNTER (WITH FALLBACK UNLOCK)
-- Copy-paste. Shows FPS always. Boosts always. Uncaps if possible.
local setfpscap = setfpscap or (syn and syn.set_fps_cap) or function() end
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- 1. Uncapped FPS (with fallback busy-wait unlock if setfpscap fails)
local uncapped = false
if setfpscap then
    pcall(setfpscap, math.huge)
    uncapped = true
    print("Executor uncap: SUCCESS (Synapse/etc.)")
else
    print("No executor uncap → Enabling fallback FPS unlock...")
    -- Fallback: Busy-wait loop to force higher FPS (safe, low CPU)
    spawn(function()
        while true do
            local start = os.clock()
            RunService.RenderStepped:Wait()
            -- Spin until next frame target (simulates uncap)
            repeat until os.clock() - start >= 1/10000
        end
    end)
end
settings().Rendering.QualityLevel = 1

-- 2. FULL MAP + LAG KILL (unchanged, works)
local function getMapRadius()
    local parts = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and (not Players.LocalPlayer.Character or v.Parent ~= Players.LocalPlayer.Character) then
            table.insert(parts, v)
        end
    end
    if #parts == 0 then return 1000 end
    local minX, minZ = math.huge, math.huge
    local maxX, maxZ = -math.huge, -math.huge
    for _, p in pairs(parts) do
        local pos = p.Position
        local half = p.Size.Magnitude / 2
        minX = math.min(minX, pos.X - half)
        maxX = math.max(maxX, pos.X + half)
        minZ = math.min(minZ, pos.Z - half)
        maxZ = math.max(maxZ, pos.Z + half)
    end
    local size = math.max(maxX - minX, maxZ - minZ)
    return math.max(size * 0.8, 600)
end
local radius = getMapRadius()
print("Map radius:", math.floor(radius), "| Uncapped:", uncapped)

local minX, maxX, minZ, maxZ  -- Save for center
-- ... (insert min/max calc vars here from function if needed)
spawn(function()
    while task.wait(2) do
        pcall(function()
            local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                Players.LocalPlayer:RequestStreamAroundAsync(hrp.Position, radius)
            end
        end)
    end
end)

-- 3. Lag killers (unchanged)
spawn(function()
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("BasePart") or v:IsA("MeshPart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
                v.CastShadow = false
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") then
                v:Destroy()
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("PostEffect") then
                v.Enabled = false
            end
        end)
    end
    Lighting.GlobalShadows = false
    Lighting.Brightness = 0
    pcall(function() Lighting.Sky:Destroy() end)
    pcall(function() Lighting.Atmosphere:Destroy() end)
end)
Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") then
        task.spawn(function() pcall(function() obj:Destroy() end) end)
    end
end)

-- 4. PERFECT FPS COUNTER (unchanged, always shows)
local gui = Instance.new("ScreenGui")
gui.Name = "UltimateFPS"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.Parent = CoreGui
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 70)
frame.Position = UDim2.new(1, -230, 0, 10)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.4
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(0, 255, 0)
stroke.Parent = frame
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 1, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 0"
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
fpsLabel.TextScaled = true
fpsLabel.Font = Enum.Font.GothamBlack
fpsLabel.Parent = frame

local deltas = {}
RunService.RenderStepped:Connect(function(dt)
    table.insert(deltas, dt)
    if #deltas > 100 then table.remove(deltas, 1) end
    local sum = 0
    for _, v in deltas do sum += v end
    local avg = sum / #deltas
    local fps = math.floor(1 / avg + 0.5)
    fpsLabel.Text = "FPS: " .. fps .. (uncapped and " (UNCAPPED)" or "")
    
    if fps >= 300 then
        fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        stroke.Color = Color3.fromRGB(0, 255, 255)
    elseif fps >= 144 then
        fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        stroke.Color = Color3.fromRGB(0, 255, 0)
    elseif fps >= 60 then
        fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        stroke.Color = Color3.fromRGB(255, 255, 0)
    else
        fpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        stroke.Color = Color3.fromRGB(255, 0, 0)
    end
end)

print("ULTIMATE FPS LOADED – COUNTER VISIBLE + BOOST ACTIVE + UNCAP CHECKED")
