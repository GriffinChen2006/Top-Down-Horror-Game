local soundService = game:GetService("SoundService")

script.Parent:GetPropertyChangedSignal("Value"):Connect(function()
	local music = script.Parent.Parent:FindFirstChild("Music")
	local monster = script.Parent.Monster.Value
	if monster == 1 then
		if script.Parent.Value then
			music.Value = 1
		else
			music.Value = 2
			local song = soundService:WaitForChild("butlerCalm")
			local acc = 0
			local tail = song.PlaybackRegion.Max - song.TimePosition + 2
			while acc < tail do
				if script.Parent.Value then
					acc = tail
				end
				acc += 1
				wait(1)
			end
			if not script.Parent.Value then
				music.Value = 0
			end
		end
	elseif monster == 2 then
		if script.Parent.Value then
			music.Value = 3
		else
			local acc = 0
			local tail = 5
			while acc < tail do
				if script.Parent.Value then
					acc = tail
				end
				acc += 1
				wait(1)
			end
			if not script.Parent.Value then
				music.Value = -1	
				acc = 0
				tail = 10
				while acc < tail do
					if script.Parent.Value then
						acc = tail
					end
					acc += 1
					wait(1)
				end
				if not script.Parent.Value then
					music.Value = 0
				end
			end
		end
	end
end)