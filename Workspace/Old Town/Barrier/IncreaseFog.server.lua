local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lighting = game:GetService("Lighting")

local event = ReplicatedStorage:WaitForChild("NearingBarrier")

local maxDist = 30

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
	if lighting:FindFirstChild("OldTown") then
		local Players = game.Players:GetChildren()
		for _, player in Players do
			local dist = getShortestDistance(player.Character:FindFirstChild("HumanoidRootPart").Position, script.Parent, 26)
			if dist and dist < maxDist then
				event:FireClient(player, dist, maxDist)
			end
		end
	end
	game:GetService("RunService").Heartbeat:Wait()
end