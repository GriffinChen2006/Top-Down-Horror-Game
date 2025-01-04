local rs = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local event = rs:WaitForChild("Cleanse")
local character = script.Parent

event.OnServerEvent:Connect(function(plr)
	if plr == players:GetPlayerFromCharacter(character) then
		for i, obj in character:GetDescendants() do
			if obj.Name == "RadiationLight" or obj.Name == "Radiation" or obj.Name == "RadiationDamage" then
				obj:Destroy()
			end
		end
	end
end)