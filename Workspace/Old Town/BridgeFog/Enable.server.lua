for i, obj in script.Parent:GetDescendants() do
	if obj:IsA("Smoke") then
		spawn(function()
			obj.Enabled = true
			obj.TimeScale = 100000
			task.wait(3.5)
			obj.TimeScale = 0.2
		end)
	end
end