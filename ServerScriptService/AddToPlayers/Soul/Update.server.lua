local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local event = rs:WaitForChild("ExitDialogue")
local soulEvent = rs:WaitForChild("SoulEvent")
local executed = false

local soul = script.Parent

local items = rs:WaitForChild("Items")
local bat = items:WaitForChild("Spiked Bat")

event.OnServerEvent:Connect(function(plr)
	if not soul.Parent:IsA("Script") then
		if plr == players:GetPlayerFromCharacter(soul.Parent) and not (executed or script.Parent.Value == 0) then
			executed = true
			if soul.Value == 1 then
				local weapon = bat:Clone()
				weapon.Parent = plr.Backpack
			elseif soul.Value == 2 then
				--
			elseif soul.Value == 3 then
				--
			else
				plr.Character:FindFirstChild("Humanoid").MaxHealth = 200
				plr.Character:FindFirstChild("Humanoid").Health = 200
			end
		end
	end
end)

soulEvent.OnServerEvent:Connect(function(plr, num)
	script.Parent.Value = num
end)