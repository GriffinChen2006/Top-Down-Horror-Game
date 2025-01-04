local ReplicatedStorage= game:GetService("ReplicatedStorage")
local enter = ReplicatedStorage:WaitForChild("EnterDialogue")
local exit = ReplicatedStorage:WaitForChild("ExitDialogue")
local players = game:GetService("Players")
local firstDialogue = true

enter.OnServerEvent:Connect(function(plr)
	if plr == players:GetPlayerFromCharacter(script.Parent.Parent) then
		script.Parent.Value = true
	end
end)

exit.OnServerEvent:Connect(function(plr)
	if plr == players:GetPlayerFromCharacter(script.Parent.Parent) then
		script.Parent.Value = false
		if firstDialogue then
			firstDialogue = false
			for _, v in pairs(script.Parent.Parent:GetDescendants()) do
				if v:IsA("BasePart") and not (v.Name == "HumanoidRootPart" or v.Name == "Light Part") then
					v.Transparency = 0
				end
				if v:IsA("Decal") then
					v.Transparency = 0
				end
			end
		end
	end
end)