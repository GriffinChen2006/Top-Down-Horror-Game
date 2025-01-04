local light = script.Parent
local max = 100
local ascending = false
local Players: Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
local DefaultWalkingSpeed = Humanoid.WalkSpeed
local increases = 0
local decreases = 0
local bright_change = 1.025
local angle_change = 1.0025
while true do
	if math.random(0,200) == 1 then
		local flicker_factor = math.random(500,2000)/100
		if flicker_factor > 15 then
			light.Enabled = false
			wait(math.random(0,30)/100)
			light.Enabled = true
		else
			light.Brightness /= flicker_factor
			wait(math.random(0,30)/100)
			light.Brightness *= flicker_factor
		end
	end
	local flip = math.random(1, 2)
	if increases == max or decreases == max then
		if increases == max and not (decreases == max) then
			light.Brightness /= bright_change
			light.Angle /= angle_change
			decreases += 1
		elseif decreases == max and not (increases == max) then
			light.Brightness *= bright_change
			light.Angle *= angle_change
			increases += 1
		else
			increases = 0
			decreases = 0
		end
	else
		if flip == 1 then
			light.Brightness *= bright_change
			light.Angle *= angle_change
			increases += 1
		else
			light.Brightness /= bright_change
			light.Angle /= angle_change
			decreases += 1
		end
	end
	wait(0.05)
end
