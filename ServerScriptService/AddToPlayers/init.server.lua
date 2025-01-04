game.Players.PlayerAdded:Connect(function(plr)
	local chr = plr.Character or plr.CharacterAdded:Wait()
	local cand = script:GetChildren()
	for _, obj in cand do
		local temp = obj:Clone()
		if temp:IsA("Script") then
			temp.Enabled = true
		end
		if temp:GetDescendants() then
			for _, desc in temp:GetDescendants() do
					if desc:IsA("Script") and not desc:HasTag("noEnable") then
						desc.Enabled = true
					end
				end
		end
		temp.Parent = chr
	end
end)