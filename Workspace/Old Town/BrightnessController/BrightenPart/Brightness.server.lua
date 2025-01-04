local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local event = ReplicatedStorage:WaitForChild("Brighten")

local invalidPlayers = {}

local maxDist = 100 -- Max distance for brightening logic
local touchThreshold = 1 -- Small distance to simulate touching
local restartPart = script.Parent.Parent.RestartBrighten
local stopPart = script.Parent.Parent.StopBrighten

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

			-- Handle RestartBrighten proximity (simulate touch)
			local restartDist = getShortestDistance(humanoidRootPart.Position, restartPart)
			if restartDist < touchThreshold and table.find(invalidPlayers, player) then
				table.remove(invalidPlayers, table.find(invalidPlayers, player))
			end

			-- Handle StopBrighten proximity (simulate touch)
			local stopDist = getShortestDistance(humanoidRootPart.Position, stopPart)
			if stopDist < touchThreshold and not table.find(invalidPlayers, player) then
				table.insert(invalidPlayers, player)
			end

			-- Main Brighten Logic
			local brightenDist = getShortestDistance(humanoidRootPart.Position, script.Parent)
			if brightenDist < maxDist and not table.find(invalidPlayers, player) then
				event:FireClient(player, brightenDist, maxDist)
			end
		end
	end
	task.wait(0.01)
end