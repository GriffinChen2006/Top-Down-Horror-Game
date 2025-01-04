local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local event = rs:WaitForChild("ToolAction")
local char = script.Parent.Parent.Parent.Parent.Character
local action = script.Parent
local locked = char:WaitForChild("Locked")
local holdingDown = locked:WaitForChild("HoldingDown")

event.OnServerEvent:Connect(function(plr, id)
	if id == 1 and not locked.Value then
		if players:GetPlayerFromCharacter(script.Parent.Parent.Parent) == plr then
			holdingDown.Value = true
			action.Value = id
		end
	end
	if id == 3 then
		if players:GetPlayerFromCharacter(script.Parent.Parent.Parent) == plr then
			locked.Value = true
			holdingDown.Value = false
			action.Value = id
		end
	end
end)