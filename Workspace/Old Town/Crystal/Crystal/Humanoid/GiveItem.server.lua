local attackers = {}
local totalDmg = {}
local humanoid = script.Parent

local rs = game:GetService("ReplicatedStorage")
local event = rs:WaitForChild("DamageEvent")

local item = rs:WaitForChild("Items"):WaitForChild("Crystal")

event.Event:Connect(function(player, hum, dmg)
	if hum == humanoid and humanoid.Health <= 0 then
		local clone = item:Clone()
		local radSound = item.Handle.Radiation:Clone()
		local radScript = clone.Handle.RadiationDamage:Clone()
		radSound.Parent = player.Character:FindFirstChild("HumanoidRootPart")
		radScript.Parent = player.Character:FindFirstChild("HumanoidRootPart")
		clone.Parent = player.Backpack
		radScript.Enabled = true
		radSound:Play()
		for i, part in player.Character:GetDescendants() do
			if part:IsA("BasePart") and not (part.Parent:IsA("Accessory") or part.Parent:IsA("Tool") or part.Parent.Parent:IsA("Tool") or part.Name == "HumanoidRootPart" or part.Name == "Light Part") then
				if part.Name == "Head" then
					local clone = script.Lights:GetChildren()[1]:Clone()
					clone.Parent = part
					clone.Face = Enum.NormalId.Front
					clone.Range = 0.1
				else
					for j, light in script.Lights:GetChildren() do
						local clone = light:Clone()
						clone.Parent = part
					end
				end
			end
		end
		
		script.Enabled = false
	end
end)