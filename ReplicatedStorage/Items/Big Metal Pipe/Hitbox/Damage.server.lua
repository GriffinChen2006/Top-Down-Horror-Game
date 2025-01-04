local damagedEntities = {}
local canDmg = script.CanDamage
local damage = script.Damage

local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local damageEvent = rs:WaitForChild("DamageEvent")

local hitSound = script.Parent.Parent.Handle.Hit
local playedHit = false

-- Identify the player holding the tool
local tool = script.Parent.Parent
local character = tool.Parent

-- Create OverlapParams to filter results
local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Blacklist
overlapParams.FilterDescendantsInstances = {tool, character} -- Exclude tool and player character

local function processTouchingParts()
	if not canDmg.Value then return end

	-- Define bounding box parameters
	local boundingCFrame = script.Parent.CFrame
	local boundingSize = script.Parent.Size

	-- Get parts within the bounding box
	local touchingParts = workspace:GetPartBoundsInBox(boundingCFrame, boundingSize, overlapParams)

	for _, part in ipairs(touchingParts) do
		local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
		local validTarget = part.Parent:HasTag("Damagable")
		if humanoid and not table.find(damagedEntities, humanoid) and validTarget then
			table.insert(damagedEntities, humanoid)
			damageEvent:Fire(players:GetPlayerFromCharacter(script.Parent.Parent.Parent), humanoid, damage.Value)
			humanoid.Health -= damage.Value
			if not playedHit then
				playedHit = true
				hitSound:Play()
				hitSound.Stopped:Wait()
			end
		end
	end
end

canDmg:GetPropertyChangedSignal("Value"):Connect(function()
	if not canDmg.Value then
		damagedEntities = {}
	end
end)

RunService.Heartbeat:Connect(function()
	processTouchingParts()
end)