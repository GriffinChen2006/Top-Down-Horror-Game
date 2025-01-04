local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local ss = game:GetService("SoundService")
local event = ReplicatedStorage:WaitForChild("AmbientSound")
local playLocally = ReplicatedStorage:WaitForChild("PlayLocally")

local invalidPlayers = {}
local enteredPlayers = {}
local restoredPlayers = {}

local maxDist = 100 -- Max distance for brightening logic
local touchThreshold = 1 -- Small distance to simulate touching
local restartPart = script.Parent.Parent.OceanRestart
local stopPart = script.Parent.Parent.OceanStop

local function getShortestDistance(point, union, rayCount)
	local maxDistance = 1000 -- Maximum raycast distance
	local directions = {} -- Table to store ray directions
	local shortestDistance = math.huge -- Start with a very large number

	-- Generate ray directions (e.g., along axes and diagonals)
	for x = -1, 1 do
		for y = -1, 1 do
			for z = -1, 1 do
				if not (x == 0 and y == 0 and z == 0) then
					table.insert(directions, Vector3.new(x, y, z).Unit)
				end
			end
		end
	end

	-- Cast rays in all directions
	for _, direction in ipairs(directions) do
		local ray = Ray.new(point, direction * maxDistance)
		local hitPart, hitPosition = workspace:FindPartOnRayWithWhitelist(ray, {union})

		if hitPart then
			local distance = (point - hitPosition).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance -- Update shortest distance
			end
		end
	end

	return nil or shortestDistance -- Return nil if no hit
end

while true do
	local Players = players:GetChildren()
	for _, player in Players do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local humanoidRootPart = player.Character.HumanoidRootPart
			local music = player.Character:WaitForChild("Music")
			
			local restartDist = getShortestDistance(humanoidRootPart.Position, restartPart)
			if restartDist < touchThreshold and table.find(invalidPlayers, player) then
				table.remove(invalidPlayers, table.find(invalidPlayers, player))
			end

			local stopDist = getShortestDistance(humanoidRootPart.Position, stopPart)
			if stopDist < touchThreshold and not table.find(invalidPlayers, player) then
				table.insert(invalidPlayers, player)
			end
			
			local dist = getShortestDistance(humanoidRootPart.Position, script.Parent)
			if not table.find(invalidPlayers, player) then
				if dist < maxDist then
					if not table.find(enteredPlayers, player) then
						table.insert(enteredPlayers, player)
					end
					if table.find(restoredPlayers, player) then
						table.remove(restoredPlayers, table.find(restoredPlayers, player))
					end
					if not music:FindFirstChild("Locked").Value then
						music.Value = -2
						task.wait(1)
						music:FindFirstChild("Locked").Value = true
					end
					event:FireClient(player, dist, maxDist, 1)
					
					playLocally:FireClient(player, "bridgeAmbient")

					if not spawned then
						spawned = true
						spawn(function()
							task.wait(3)
							playLocally:FireClient(player, "bridge")
						end)
					end
				elseif dist > maxDist + 30 and dist < math.huge and table.find(enteredPlayers, player) and not table.find(restoredPlayers, player) then
					table.insert(restoredPlayers, player)
					spawned = false
					music:FindFirstChild("Locked").Value = false
					music.Value = -1
					task.wait(2)
					music.Value = 0
				end
			end
		end
	end
	game:GetService("RunService").Heartbeat:Wait()
end