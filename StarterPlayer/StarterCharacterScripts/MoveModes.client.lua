local Players: Players = game:GetService("Players")
local UIS: UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local humanoid = Character:WaitForChild("Humanoid")
local Camera: Camera = workspace.CurrentCamera
local inDialogue = Character:WaitForChild("inDialogue")
local soul = Character:WaitForChild("Soul")

local DefaultWalkingSpeed = humanoid.WalkSpeed

local speed_Sneak = DefaultWalkingSpeed/1.5
local speed_Sprint = DefaultWalkingSpeed * 1.5
local ctrl = Enum.KeyCode.LeftControl
local shift = Enum.KeyCode.LeftShift

local s_pressed = false
local c_pressed = false

local light = Character:WaitForChild("Light Part").SpotLight
local player_light = Character:WaitForChild("HumanoidRootPart").PointLight

local sprinting = ReplicatedStorage:WaitForChild("Sprint")
local crouching = ReplicatedStorage:WaitForChild("Crouch")
local sprint_end = ReplicatedStorage:WaitForChild("SprintEnd")
local crouch_end = ReplicatedStorage:WaitForChild("CrouchEnd")

local endlessFactor = 1.2
local boostFactor = 1

UIS.InputBegan:Connect(function(Input: InputObject)
	if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == ctrl and not (inDialogue.Value or c_pressed) then
		s_pressed = true
		light.Range /= 2
		light.Brightness /= 1.5
		player_light.Range *= 1.25
		
		if soul.Value == 2 then
			boostFactor = endlessFactor
		end
		
		crouching:FireServer(humanoid, speed_Sneak * boostFactor)
	end
end)

UIS.InputEnded:Connect(function(Input: InputObject)
	if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == ctrl and s_pressed then 
		s_pressed = false
		light.Range *= 2
		light.Brightness *= 1.5
		player_light.Range /= 1.25
		crouch_end:FireServer(humanoid, DefaultWalkingSpeed)
	end
end)

UIS.InputBegan:Connect(function(Input: InputObject)
	if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == shift and not (inDialogue.Value or s_pressed) then 
		c_pressed = true
		light.Angle /= 1.5
		light.Brightness /= 1.5
		player_light.Range /= 1.5
		
		if soul.Value == 2 then
			boostFactor = endlessFactor
		end
		
		sprinting:FireServer(humanoid, speed_Sprint * boostFactor)
	end
end)

UIS.InputEnded:Connect(function(Input: InputObject)
	if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == shift and c_pressed then 
		c_pressed = false
		light.Angle *= 1.5
		light.Brightness *= 1.5
		player_light.Range *= 1.5
		sprint_end:FireServer(humanoid, DefaultWalkingSpeed)
	end
end)

Player.CharacterAdded:Connect(function(Char)
	humanoid = Char:FindFirstChildWhichIsA("Humanoid") or Char:WaitForChild("Humanoid")
end)