game.Players.PlayerAdded:Connect(function(plr)
	local chr = plr.Character or plr.CharacterAdded:Wait()
	local cand = chr:GetDescendants()
	for _, obj in cand do
		if obj:IsA("Part") or obj:IsA("MeshPart") then
			obj.CollisionGroup = "Player"
		end
	end
end)