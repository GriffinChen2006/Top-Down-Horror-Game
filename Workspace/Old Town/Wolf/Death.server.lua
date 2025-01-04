local humanoid = script.Parent.Humanoid
humanoid:GetPropertyChangedSignal("Health"):Connect(function()
	if humanoid.Health <= 0 then
		script.Parent.Head.Bark:Stop()
		script.Parent.Head.Death:Play()
		script.Parent.ChaseAIWithHiding.Enabled = false
		script:Destroy()
	end
end)