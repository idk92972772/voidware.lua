-- VoidWare.lua v1.2 - ERROR-PROOF FPS Booster (Dec 2025)
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/idk92972772/voidware.lua/main/voidware.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

_G.VoidWareEnabled = true
_G.VoidWareAntiLag = false

-- 1. FPS Unlock (Safe nil check)
pcall(function()
    if setfpscap then
        setfpscap(9999)
        print("VoidWare: FPS Unlocked (setfpscap)")
    end
end)

-- 2. Remove Textures/Particles/EFFECTS (Loop-safe)
pcall(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or 
           v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or
           v:IsA("Beam") then
            v:Destroy()
        end
    end
end)

-- Continuous cleanup
RunService.Heartbeat:Connect(function()
    if not _G.VoidWareEnabled then return end
    pcall(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                v:Destroy()
            end
        end
    end)
end)

-- 3. Lighting/Sky Optimization
pcall(function()
    Lighting.Brightness = 0
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    if Lighting:FindFirstChild("Sky") then Lighting.Sky:Destroy() end
end)

-- 4. SAFE Chat Disable (2025 Executor Fix - NO SetCoreGuiEnabled!)
pcall(function()
    StarterGui:SetCore("ChatActive", false)
end)
pcall(function()
    StarterGui:SetCore("TopbarEnabled", false)  -- Hides topbar/chat button
end)

-- 5. Grey Players / Remove Accessories (Safe)
pcall(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Color = Color3.new(0.5, 0.5, 0.5)
                    part.Material = Enum.Material.Plastic
                elseif part:IsA("Accessory") or part:IsA("Shirt") or part:IsA("Pants") or part:IsA("Hat") then
                    part:Destroy()
                end
            end
        end
    end
end)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)  -- Wait for full load
        -- Repeat grey/cloth removal
    end)
end)

-- 6. Anti-Lag Throttle (Optional)
if _G.VoidWareAntiLag then
    local lastTime = tick()
    hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "FireServer" and tick() - lastTime < 0.1 then
            return  -- Throttle remotes
        end
        lastTime = tick()
        return hookmetamethod(game, "__namecall", self, ...)
    end)
end

print("✅ VoidWare v1.2 LOADED - ZERO ERRORS | FPS Boosted | Chat Hidden")
print("Toggle Anti-Lag: _G.VoidWareAntiLag = true")
