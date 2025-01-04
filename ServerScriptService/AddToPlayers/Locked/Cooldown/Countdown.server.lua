local disabled = false
while true do
	if script.Parent.Value > 0 then
		disabled = false
		script.Parent.Value -= 1
	else
		if not disabled then
			disabled = true
			script.Parent.Parent.Value = false
		end
	end
	task.wait(0.1)
end