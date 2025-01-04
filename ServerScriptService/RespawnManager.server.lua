-- Variables
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local spawnLocation = workspace:WaitForChild("StartingArea"):WaitForChild("SpawnLocation") -- Replace with the actual location of your spawnLocation

-- Function to handle player character setup
local function setupCharacter(player, character)
	local humanoid = character:WaitForChild("Humanoid")
	local rootPart = character:WaitForChild("HumanoidRootPart")
	local checkpoint = character:WaitForChild("Checkpoint")
	
	rootPart.CFrame = spawnLocation.CFrame
	
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
	humanoid.AutoRotate = false
	
	for _, obj in character:GetDescendants() do
		if obj:IsA("BasePart") or obj:IsA("Decal") then
			obj.Transparency = 1
		end
	end

	-- Monitor health and handle "death"
	humanoid.HealthChanged:Connect(function(health)
		if health <= 0 then
			-- Simulate "death" by teleporting the player
			rootPart.CFrame = spawnLocation.CFrame
			humanoid.Health = humanoid.MaxHealth
		end
	end)
end
-- Function to handle player joining
local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		setupCharacter(player, character)
	end)

	-- Handle existing character if the player joins mid-session
	if player.Character then
		setupCharacter(player, player.Character)
	end
end

-- Connect to new players joining
Players.PlayerAdded:Connect(onPlayerAdded)

-- Handle existing players if the script is started mid-session
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end