local inChase = script.Parent
local step = script.Parent.Parent.HumanoidRootPart.Step
while true do
	if inChase.Value then
		step:Play()
		task.wait(0.99)
	end
	task.wait(0.01)
end