local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sprinting = ReplicatedStorage:WaitForChild("Sprint")
local crouching = ReplicatedStorage:WaitForChild("Crouch")
local sprint_end = ReplicatedStorage:WaitForChild("SprintEnd")
local crouch_end = ReplicatedStorage:WaitForChild("CrouchEnd")
local status = script.Parent

sprinting.OnServerEvent:Connect(function(player, humanoid, spd)
	humanoid.WalkSpeed = spd
	status.Value = 1
end)
crouching.OnServerEvent:Connect(function(player, humanoid, spd)
	humanoid.WalkSpeed = spd
	status.Value = 2
end)
sprint_end.OnServerEvent:Connect(function(player, humanoid, spd)
	humanoid.WalkSpeed = spd
	status.Value = 0
end)
crouch_end.OnServerEvent:Connect(function(player, humanoid, spd)
	humanoid.WalkSpeed = spd
	status.Value = 0
end)