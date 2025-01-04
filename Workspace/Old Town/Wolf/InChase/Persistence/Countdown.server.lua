while true do
	if script.Parent.Value > 0 then
		script.Parent.Value -= 1
	else
		script.Parent.Parent.Value = false
	end
	wait(1)
end