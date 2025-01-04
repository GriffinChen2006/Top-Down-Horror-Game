local executed = false
local players = game:GetService("Players")

script.Parent.Touched:Connect(function(hit)
	if players:GetPlayerFromCharacter(hit.Parent) and not executed then
		executed = true
		script.Parent.Parent.Enable.Enabled = true
		script:Destroy()
	end
end)