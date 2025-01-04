local StarterPlayer = game:GetService("StarterPlayer")
local rs = game:GetService("ReplicatedStorage")
local event = rs:WaitForChild("Freeze")
local humanoid = game.Players.LocalPlayer.Character.Humanoid
local animator = humanoid:FindFirstChildOfClass("Animator")
local noMove = false

local pausedAnims = {}

event.OnClientEvent:Connect(function(status)
	if status then
		noMove = true
		humanoid.WalkSpeed = 0
	else
		noMove = false
		humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
	end
end)

while true do
	if noMove then
		humanoid.WalkSpeed = 0
	end
	task.wait(0.01)
end