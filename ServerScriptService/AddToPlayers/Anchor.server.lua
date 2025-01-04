local hrp = script.Parent:WaitForChild("HumanoidRootPart")
local humanoid = script.Parent:WaitForChild("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator")
local rs = game:GetService("ReplicatedStorage")
local event = rs:WaitForChild("AnchorPlayer")
local freeze = rs:WaitForChild("Freeze")
local players = game:GetService("Players")
local player = players:GetPlayerFromCharacter(script.Parent)

local mouseScript = script.Parent:WaitForChild("FollowMouse")

event.OnServerEvent:Connect(function(plr, state)
	if plr == player then
		if state then
			mouseScript.Enabled = false
			freeze:FireClient(plr, true)
		else
			mouseScript.Enabled = true
			freeze:FireClient(plr, false)
		end
	end
end)