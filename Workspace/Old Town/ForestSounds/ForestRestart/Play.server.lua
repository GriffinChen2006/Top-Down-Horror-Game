local ss = game:GetService("SoundService")
local rs = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local playLocal = rs:WaitForChild("PlayLocally")

-- Table to track debounce per part
local debounceTable = {}

script.Parent.Touched:Connect(function(hit)
	local character = hit.Parent
	if players:GetPlayerFromCharacter(character) then
		local player = players:GetPlayerFromCharacter(character)

		-- Ensure we track touches by part
		if not debounceTable[hit] then
			debounceTable[hit] = true -- Mark this part as triggered

			playLocal:FireClient(player, "forestAmbient")

			-- Clear debounce after a short delay
			task.delay(1, function()
				debounceTable[hit] = nil
			end)
		end
	end
end)