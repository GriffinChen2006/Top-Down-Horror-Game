local npc = script.Parent -- The NPC model containing this script

local function createRagdoll(character)
	for _, joint in pairs(character:GetDescendants()) do
		if joint:IsA("Motor6D") then
			-- Get the parts connected by the Motor6D
			local part0 = joint.Part0
			local part1 = joint.Part1

			if part0 and part1 then
				-- Create Attachments
				local attachment0 = Instance.new("Attachment", part0)
				attachment0.CFrame = joint.C0

				local attachment1 = Instance.new("Attachment", part1)
				attachment1.CFrame = joint.C1

				-- Create BallSocketConstraint
				local ballSocket = Instance.new("BallSocketConstraint")
				ballSocket.Attachment0 = attachment0
				ballSocket.Attachment1 = attachment1
				ballSocket.Parent = part0
			end

			-- Remove the Motor6D
			joint:Destroy()
		end
	end

	-- Unanchor all parts to enable physics
	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = false
			part.CanCollide = true
		end
	end
end

local function onDeath(humanoid)
	local character = humanoid.Parent
	if character then
		-- Destroy unnecessary parts
		local hitbox = character:FindFirstChild("Hitbox")
		if hitbox then hitbox:Destroy() end

		local hitboxAnchor = character:FindFirstChild("HitboxAnchor")
		if hitboxAnchor then hitboxAnchor:Destroy() end

		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then humanoidRootPart:Destroy() end

		-- Create the ragdoll
		createRagdoll(character)
	end
end

local humanoid = npc:FindFirstChildOfClass("Humanoid")
if humanoid then
	humanoid.BreakJointsOnDeath = false -- Disable automatic breaking of joints
	humanoid.Died:Connect(function()
		onDeath(humanoid)
	end)
else
	warn("No Humanoid found in the NPC model!")
end
