local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ss = game:GetService("SoundService")
local lighting = game:GetService("Lighting")

local origAtmosphere = ReplicatedStorage:WaitForChild("OldTown")
local event = ReplicatedStorage:WaitForChild("NearingBarrier")
local brighten = ReplicatedStorage:WaitForChild("Brighten")
local ambience = ReplicatedStorage:WaitForChild("AmbientSound")
local bridgeAtmosphere = ReplicatedStorage:WaitForChild("BridgeAtmosphere")
local initDensity = origAtmosphere.Density

local player = script.Parent.Parent
local cam = (player.Character or player.CharacterAdded:Wait()):WaitForChild("Camera")
local distance = cam:WaitForChild("Distance")
local up = cam:WaitForChild("UpRotation")
local side = cam:WaitForChild("SideRotation")

local lightColor = nil
local smallLightColor = nil
local lightColorInit = nil

local spawned = false

local initAmbientColor = Color3.fromRGB(8, 3, 0)
local initSmogColor = origAtmosphere.Color
local initDiffuse = lighting.EnvironmentDiffuseScale
local initBrightness = lighting.Brightness
local initDist = distance.Value
local initUp = up.Value
local initSide = side.Value
local initSideNew

local adjustedSide = 15
local targetDiffuse = 0.3
local targetBrightness = 3
local targetDist = 60
local targetUp = 20
local targetSide = 103
local targetColor = Color3.fromRGB(255, 226, 121)
local targetSmogColor = Color3.fromRGB(85, 70, 16)
local targetAmbientColor = Color3.fromRGB(28, 31, 0)
local targetDensity = 0.4

event.OnClientEvent:Connect(function(dist, maxDist)
	local clonedAtmosphere = lighting:FindFirstChild("OldTown")
	if clonedAtmosphere then
		clonedAtmosphere.Density = initDensity + (1 - initDensity) * (maxDist - dist)/maxDist
	end
end)

brighten.OnClientEvent:Connect(function(dist, maxDist)
	
	local interpolationFactor = (maxDist - dist) / maxDist
	
	if not lightColor then
		lightColor = player.Character:FindFirstChild("Light Part"):FindFirstChild("SpotLight")
		smallLightColor = player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("PointLight")
		lightColorInit = lightColor.Color -- Save the initial color of the light
	end
	
	local clonedAtmosphere = lighting:FindFirstChild("OldTown")
	
	if clonedAtmosphere then
		clonedAtmosphere.Density = initDensity + (targetDensity - initDensity) * (maxDist - dist)/maxDist
		clonedAtmosphere.Color = initSmogColor:Lerp(targetSmogColor, interpolationFactor)
	end

	-- Update the light's color using Lerp
	lighting.Ambient = initAmbientColor:Lerp(targetAmbientColor, interpolationFactor)
	lighting.OutdoorAmbient = initAmbientColor:Lerp(targetAmbientColor, interpolationFactor)
	lightColor.Color = lightColorInit:Lerp(targetColor, interpolationFactor)
	smallLightColor.Color = lightColorInit:Lerp(targetColor, interpolationFactor)

	-- Update other lighting properties
	lighting.EnvironmentDiffuseScale = initDiffuse + (targetDiffuse - initDiffuse) * interpolationFactor
	lighting.Brightness = initBrightness + (targetBrightness - initBrightness) * interpolationFactor
	side.Value = initSide + (adjustedSide - initSide) * interpolationFactor
	initSideNew = side.Value
end)

ambience.OnClientEvent:Connect(function(dist, maxDist, id)
	if id == 1 then
		local ambience = ss:WaitForChild("bridgeAmbient")
		ambience.Volume = 1 * (maxDist - dist)/maxDist
	end
end)

bridgeAtmosphere.OnClientEvent:Connect(function(dist, maxDist)
	distance.Value = initDist + (targetDist - initDist) * (maxDist - dist)/maxDist
	up.Value = initUp + (targetUp - initUp) * (maxDist - dist)/maxDist
	side.Value = initSideNew + (targetSide - initSideNew) * (maxDist - dist)/maxDist
end)