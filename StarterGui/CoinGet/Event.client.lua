local event = script.Parent.CoinGet

local function onEvent()
	script.Parent.Enabled = true
	while script.Parent.ImageLabel.ImageTransparency > 0 do
		script.Parent.ImageLabel.ImageTransparency -= 0.05
		task.wait(0.01)
	end
	task.wait(1)
	while script.Parent.ImageLabel.ImageTransparency < 1 do
		script.Parent.ImageLabel.ImageTransparency += 0.05
		task.wait(0.01)
	end
	script.Parent.Enabled = false
end

event.Event:Connect(onEvent)