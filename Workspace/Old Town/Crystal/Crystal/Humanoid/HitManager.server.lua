local humanoid = script.Parent
local crystal = script.Parent.Parent.Crystal

local listener

listener = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
	crystal.Hit:Play()
	if humanoid.Health <= 0 then
		crystal.Parent.Parent.Lights:Destroy()
		crystal.Radiation:Stop()
		crystal.Shatter:Play()
		crystal.Transparency = 1
		crystal.CanCollide = false
		crystal.RadiationDamage.Enabled = false
		spawn(function()
			local clones = {}
			for i, particle in crystal:GetChildren() do
				if particle:IsA("ParticleEmitter") then
					local clone = particle:Clone()
					clone.Size = NumberSequence.new(0.6)
					clone.Enabled = true
					clone.Parent = particle.Parent
					table.insert(clones, clone)
				end
			end
			task.wait(0.4)
			for i, clone in clones do
				clone.Enabled = false
			end
			task.wait(crystal:GetChildren()[3].Lifetime.Max)
			for i, clone in clones do
				clone:Destroy()
			end
			listener:Disconnect()
		end)
	else
		spawn(function()
			local clones = {}
			for i, particle in crystal:GetChildren() do
				if particle:IsA("ParticleEmitter") then
					local clone = particle:Clone()
					clone.Size = NumberSequence.new(0.2)
					clone.Enabled = true
					clone.Parent = particle.Parent
					table.insert(clones, clone)
				end
			end
			task.wait(0.1)
			for i, clone in clones do
				clone.Enabled = false
			end
			task.wait(crystal:GetChildren()[3].Lifetime.Max)
			for i, clone in clones do
				clone:Destroy()
			end
		end)
	end
end)
