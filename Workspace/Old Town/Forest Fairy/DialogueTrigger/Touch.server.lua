local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage:WaitForChild("DialogueTriggered")
local triggeredPlayers = {}
local triggeredPlayers2 = {}
script.Parent.Touched:Connect(function(hit) 
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player then
		local crystal = player.Character:FindFirstChild("Crystal") or player.Backpack:FindFirstChild("Crystal")
		if not table.find(triggeredPlayers2, player) and crystal then
			player.Character:FindFirstChild("interactCD").Value = true
			if not table.find(triggeredPlayers, player) then
				table.insert(triggeredPlayers, player)
				event:FireClient(player, "FairyQuestCompletedAlt")
			else
				event:FireClient(player, "FairyQuestCompleted")
				table.insert(triggeredPlayers2, player)
			end
			crystal:Destroy()
		elseif not table.find(triggeredPlayers, player) then
			player.Character:FindFirstChild("interactCD").Value = true
			event:FireClient(player, "FairyQuestStart")
			table.insert(triggeredPlayers, player)
		end
	end
end)