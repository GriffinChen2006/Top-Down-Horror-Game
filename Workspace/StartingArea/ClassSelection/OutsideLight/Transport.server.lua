local playerService = game.Players
local dest = workspace:WaitForChild("Old Town"):WaitForChild("InitSpawn")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lighting = game:GetService("Lighting")
local changed = false

local difficultyTweak = ReplicatedStorage:WaitForChild("ScaleDifficulty")

local playLocal = ReplicatedStorage:WaitForChild("PlayLocally")

local changeLightColor = ReplicatedStorage:WaitForChild("lightChange")

local lightColor = Color3.fromRGB(255, 156, 35)

script.Parent.Touched:Connect(function(hit)
	if not changed then
		changed = true
		
		local Players = playerService:GetPlayers()
		local atmosphere = ReplicatedStorage:WaitForChild("OldTown"):Clone()
		difficultyTweak:Fire()

		for _, player in Players do
			local character = player.Character
			if character then
				local currentPos = character:GetPrimaryPartCFrame().Position
				local offset = dest.Position - currentPos
				character:TranslateBy(offset)
				player.Character:FindFirstChild("Music").Value = 0
				player.Character:FindFirstChild("Checkpoint").Value = 1
				playLocal:FireClient(player, "forestAmbient")
				changeLightColor:FireClient(player, lightColor)
			end
		end

		atmosphere.Parent = lighting
		lighting.ClockTime = 5.6
		lighting.Brightness = 0.05
		lighting.OutdoorAmbient = Color3.fromRGB(8, 3, 0)
		lighting.Ambient = Color3.fromRGB(8, 3, 0)
	else
		local tped = false
		local function isValidCharacter(target)
			local player = playerService:GetPlayerFromCharacter(target)
			return player ~= nil
		end

		-- Determine if the hit object belongs to a valid character
		local targetChar = nil
		if hit.Parent and isValidCharacter(hit.Parent) then
			targetChar = hit.Parent
		elseif hit.Parent.Parent and isValidCharacter(hit.Parent.Parent) then
			targetChar = hit.Parent.Parent
		end

		if targetChar and not tped then
			tped = true
			local cp = targetChar:FindFirstChild("Checkpoint")
			if cp and cp.Value == 1 then
				local currentPos = targetChar:GetPrimaryPartCFrame().Position
				local offset = dest.Position - currentPos
				targetChar:TranslateBy(offset)
			end
			spawn(function()
				task.wait(1)
				tped = false
			end)
		end
	end
end)