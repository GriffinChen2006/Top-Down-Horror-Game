local rs = game:GetService("ReplicatedStorage")
local actEvent = rs:WaitForChild("ToolAction")
local tool = script.Parent
local char = tool.Parent.Parent.Character
local locked = char:WaitForChild("Locked")
local holdingDown = locked:WaitForChild("HoldingDown")
local weapon = holdingDown:WaitForChild("Weapon")
local lastInputTime = 0 -- Tracks the last time input was sent
local inputDebounce = 0.001 -- Minimum time between inputs
local localHoldingDown = false

local id = tool:WaitForChild("ID").Value

tool.Activated:Connect(function()
	if not locked.Value and weapon.Value == id then
		local currentTime = os.clock()
		if holdingDown.Value then
			-- Handle rapid inputs: Skip to animation 3 directly
			actEvent:FireServer(3)
		elseif currentTime - lastInputTime >= inputDebounce then
			-- Normal input: Trigger animation 1
			localHoldingDown = true
			lastInputTime = currentTime
			actEvent:FireServer(1)
		end
	end
end)

tool.Deactivated:Connect(function()
	if (holdingDown.Value or localHoldingDown) and weapon.Value == id then
		local currentTime = os.clock()
		if currentTime - lastInputTime >= inputDebounce then
			-- Normal deactivation
			localHoldingDown = false
			actEvent:FireServer(3)
		end
	end
end)

tool.Unequipped:Connect(function()
	localHoldingDown = false
end)