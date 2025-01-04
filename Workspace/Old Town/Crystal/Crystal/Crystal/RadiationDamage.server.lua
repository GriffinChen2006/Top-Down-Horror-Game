-- Settings
local DAMAGE_PROPORTION = 0.001 -- Proportion of current health dealt as damage per tick 
local TICK_INTERVAL = 0.1 -- Time (in seconds) between damage ticks
local DAMAGE_RADIUS = 13.5 -- Radius to apply damage

-- References
local part = script.Parent -- The object to attach the damage script

-- Function to apply damage to players in range
local function applyDamage()
	for _, player in pairs(game.Players:GetPlayers()) do
		local character = player.Character
		if character and character:FindFirstChild("Humanoid") then
			local humanoid = character.Humanoid
			local rootPart = character:FindFirstChild("HumanoidRootPart")
			if rootPart then
				local distance = (rootPart.Position - part.Position).Magnitude
				if distance <= DAMAGE_RADIUS then
					-- Calculate proportional damage based on current health
					local damage = humanoid.Health * DAMAGE_PROPORTION
					-- Apply damage if it won't outright kill the player
					if humanoid.Health - damage > 0 then
						humanoid:TakeDamage(damage)
					end
				end
			end
		end
	end
end

-- Damage loop
while true do
	applyDamage()
	wait(TICK_INTERVAL)
end