-- Reference to the part
local part = script.Parent

-- Speed of rotation (degrees per second)
local rotationSpeed = 10 -- Adjust this value for faster/slower rotation

-- Service to handle frame updates
local RunService = game:GetService("RunService")

-- Rotation function
RunService.Heartbeat:Connect(function(deltaTime)
	-- Calculate the rotation amount
	local rotationAmount = rotationSpeed * deltaTime

	-- Rotate the part locally around the Y-axis (right)
	part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(rotationAmount), 0)
end)