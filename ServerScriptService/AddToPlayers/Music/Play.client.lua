local music = script.Parent
local soundService = game:GetService("SoundService")
local runService = game:GetService("RunService")

local locked = script.Parent.Locked

local function PlayWithRange(song, min, max, changeTimePos)
	song.LoopRegion = NumberRange.new(min, max)
	song.TimePosition = min - 0.15
	if changeTimePos then
		song.TimePosition = changeTimePos
	end
	song:Play()
end

local function crossFade(song1, song2)
	spawn(function()
		local song1Volume = song1.Volume
		local song2Volume = song2.Volume
		song2:Play()
		for i = 1, 100 do
			song1.Volume = song1Volume * (1 - i/100)
			song2.Volume = song2Volume * (i/100)
			wait(0.01)
		end
		song1:Stop()
	end)
end

local function fadeOut(exclude, rate)
	local amt = 0.025
	if rate then
		amt = rate
	end
	for i, song in soundService:GetChildren() do
		if song:IsA("Sound") then
			if exclude then
				if not table.find(exclude, song) then
					spawn(function()
						while true do
							if song.Volume > 0 then
								song.Volume -= amt
								wait(0.01)
							else
								song:Stop()
								break
							end
						end
					end)
				end
			else
				spawn(function()
					while true do
						if song.Volume > 0 then
							song.Volume -= amt
							wait(0.01)
						else
							song:Stop()
							break
						end
					end
				end)
			end
		end
	end
end

local function stopAll(exclude)
	for i, song in soundService:GetChildren() do
		if song:IsA("Sound") then
			if exclude then
				if not table.find(exclude, song) then
					song:Stop()
				end
			else
				song:Stop()
			end
		end
	end
end

music:GetPropertyChangedSignal("Value"):Connect(function()
	if not locked.Value then
		local val = script.Parent.Value
		if val == -2 then
			fadeOut({soundService.bridge, soundService.bridgeAmbient})
		elseif val == -1 then
			fadeOut({soundService.forestAmbient})
		elseif val == 0 then
			stopAll({soundService.forestAmbient})
			soundService.forestChill.Volume = 0.25
			soundService.forestChill:Play()
		elseif val == 1 then
			soundService.butlerChase.Volume = 1.5
			stopAll({soundService.forestAmbient})
			PlayWithRange(soundService.butlerChase, 25.893, 55.842, 22.507)
		elseif val == 2 then
			local calm = soundService.butlerChase:Clone()
			calm.Name = "butlerCalm"
			calm.Parent = soundService
			calm.Looped = false
			calm.PlaybackRegion = NumberRange.new(0, 116.427)
			calm.TimePosition = 85.917
			calm.Volume = 1
			crossFade(soundService.butlerChase, calm)
			local function manageClone()
				local fading = false
				local connection
				connection = runService.RenderStepped:Connect(function()
					local remainingTime = calm.PlaybackRegion.Max - calm.TimePosition
					if remainingTime <= 2 and not fading then
						fading = true
						-- Adjust fade duration to finish slightly before the end
						local fadeDuration = remainingTime - 1
						local fadeSteps = math.ceil(fadeDuration * 100) -- 100 steps per second
						local fadeIncrement = calm.Volume / fadeSteps
						for i = 1, fadeSteps do
							calm.Volume = math.max(0, calm.Volume - fadeIncrement)
							task.wait(fadeDuration / fadeSteps)
						end
						calm:Stop()
						calm:Destroy()
						connection:Disconnect() -- Properly disconnect the RenderStepped connection
					end
				end)
				local stopped
				stopped = calm.Stopped:Connect(function()
					calm:Destroy()
					stopped:Disconnect()
				end)
			end
			coroutine.wrap(manageClone)()
		elseif val == 3 then
			stopAll({soundService.forestAmbient})
			soundService.forestChase.Volume = 1
			soundService.forestChase:Play()
		end
	end
end)

