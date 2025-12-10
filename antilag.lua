-- VoidWare.lua - Ultimate FPS Booster v1.1 (Dec 2025 - FIXED)
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/idk92972772/voidware.lua/main/voidware.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

_G.VoidWareEnabled = true
_G.VoidWareAntiLag = false

-- FPS Unlock
if setfpscap then setfpscap(9999) end

-- Remove Textures/Particles
for _, v in workspace:GetDescendants() do
    pcall(function()
        if v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v:Destroy()
        end
    end)
end

-- Lighting & Sky
Lighting.Brightness = 0
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
if Lighting:FindFirstChild("Sky") then Lighting.Sky:Destroy() end

-- Safe Chat Disable (2025 FIX)
pcall(function() StarterGui:SetCore("ChatActive", false) end)
pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false) end)

-- Grey Players
for _, plr in Players:GetPlayers() do
    if plr.Character then
        for _, part in plr.Character:GetDescendants() do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Color = Color3.new(0.5, 0.5, 0.5)
            elseif part:IsA("Accessory") or part:IsA("Shirt") or part:IsA("Pants") then
                part:Destroy()
            end
        end
    end
end

print("VoidWare v1.1 Loaded - No Errors | FPS Unlocked | Chat Disabled")
