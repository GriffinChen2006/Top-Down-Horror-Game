local config = require(script.Parent.Parent.Parent:WaitForChild("Settings"))

local cd = script.Parent:WaitForChild("Cooldown")
local timer = script.Parent

cd.Value = config.damageDelay

while true do
	if timer.Value > 0 then
		timer.Value -= 1
	else
		if timer.Parent.Value then
			timer.Parent.Value = false
		end
	end
	task.wait(1)
end
