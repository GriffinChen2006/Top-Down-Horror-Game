local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage:WaitForChild("DialogueTriggered")
local triggeredPlayers = {}
script.Parent.Touched:Connect(function(hit) 
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player then
		if not table.find(triggeredPlayers, player) then
			if not (player.Character:FindFirstChild("interactCD").Value or player.Character:FindFirstChild("inDialogue").Value) then
				player.Character:FindFirstChild("interactCD").Value = true
				event:FireClient(player, "Dummy")
				table.insert(triggeredPlayers, player)
			end
		end
	end
end)