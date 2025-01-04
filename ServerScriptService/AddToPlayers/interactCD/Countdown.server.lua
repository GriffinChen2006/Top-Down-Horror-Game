local acc = math.random(30,40)
local inDialogue = script.Parent.Parent:WaitForChild("inDialogue")
while true do
	if not (inDialogue.Value) then
		if script.Parent.Value then
			if acc > 0 then
				acc -= 1
			else
				acc = math.random(30,40)
				script.Parent.Value = false
			end
		end
	end
	wait(0.1)
end