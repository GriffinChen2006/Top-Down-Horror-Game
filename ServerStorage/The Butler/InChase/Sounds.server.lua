local cand = script.Parent.Parent.Head.LowerJaw:GetChildren()
local inChase = script.Parent
local sounds = {}
for _, obj in cand do
	if obj:IsA("Sound") then
		table.insert(sounds, obj)
	end
end
while true do
	if inChase.Value then
		local playing = false
		for _, sound in sounds do
			if sound.Playing == true then
				playing = true
			end
		end
		if not playing then
			sounds[math.random(1, #sounds)]:Play()
		end
	end
	task.wait(math.random(10,20)/10)
end