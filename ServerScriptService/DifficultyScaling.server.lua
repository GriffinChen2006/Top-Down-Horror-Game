local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ENEMY_TAG = "Enemy"

-- Function to calculate dynamic scaling factor
local function getScalingFactor(playerCount)
	if playerCount == 1 then
		return 0
	elseif playerCount == 2 then
		return 1.25
	elseif playerCount == 3 then
		return 1.5
	elseif playerCount >= 4 then
		return 1.75
	end
end

-- Function to scale NPC health
local function scaleNPCHealth()
	local playerCount = #Players:GetPlayers()
	if playerCount == 0 then return end

	local scalingMultiplier = getScalingFactor(playerCount)
	local npcs = CollectionService:GetTagged(ENEMY_TAG)
	for _, npc in ipairs(npcs) do
		if npc:IsA("Model") then
			local humanoid = npc:FindFirstChildOfClass("Humanoid")
			if humanoid then
				local currentMaxHP = humanoid.MaxHealth
				local currentHP = humanoid.Health
				-- Scale the health and max health
				humanoid.MaxHealth = currentMaxHP + currentMaxHP * scalingMultiplier * playerCount
				humanoid.Health = currentHP + currentHP * scalingMultiplier * playerCount
			end
		end
	end
end

-- Listen for an event to trigger the scaling
local HealthScalingEvent = game:GetService("ReplicatedStorage"):WaitForChild("ScaleDifficulty")

HealthScalingEvent.Event:Connect(scaleNPCHealth)
