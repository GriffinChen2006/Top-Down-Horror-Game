local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local event = rs:WaitForChild("GiveItem")

local items = rs:WaitForChild("Items")

event.OnServerEvent:Connect(function(plr, item)
	if plr == players:GetPlayerFromCharacter(script.Parent) then
		for i, obj in items:GetChildren() do
			if obj.Name == item then
				obj:Clone().Parent = plr.Backpack
			end
		end
	end
end)