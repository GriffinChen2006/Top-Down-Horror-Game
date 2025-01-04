local cd = script.Parent:WaitForChild("Cooldown")
local timer = script.Parent

timer.Parent:GetPropertyChangedSignal("Value"):Connect(function()
	if timer.Parent.Value == true then
		timer.Value = cd.Value
	end
end)