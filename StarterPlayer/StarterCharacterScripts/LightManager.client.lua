local rs = game:GetService("ReplicatedStorage")
local event = rs:WaitForChild("lightChange")

event.OnClientEvent:Connect(function(lightColor)
	script.Parent:FindFirstChild("HumanoidRootPart"):WaitForChild("PointLight").Color = lightColor
	script.Parent:FindFirstChild("Light Part"):WaitForChild("SpotLight").Color = lightColor
end)