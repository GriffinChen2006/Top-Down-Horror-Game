local Players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local soundService = game:GetService("SoundService")
local mainLight = workspace:WaitForChild("StartingArea"):WaitForChild("MainLight")
local menuCam = workspace:WaitForChild("StartingArea"):WaitForChild("MenuCam")
local menuLight = workspace:WaitForChild("StartingArea"):WaitForChild("MenuLight")
local door1 = workspace:WaitForChild("StartingArea"):WaitForChild("ClassSelection"):WaitForChild("Door")
local door2 = workspace:WaitForChild("StartingArea"):WaitForChild("ClassSelection"):WaitForChild("DoorOpen")
local loaded = workspace:WaitForChild("StartingArea"):WaitForChild("Midnight"):WaitForChild("Dialogue")
local hrp = player.Character:WaitForChild("HumanoidRootPart")
local button1 = script.Parent.TextButton
local button2 = script.Parent.Test
local menuMusic = soundService:WaitForChild("menu")
local lobbyMusic = soundService:WaitForChild("lobby")
local exit = rs:WaitForChild("ExitDialogue")
local soulEvent = rs:WaitForChild("SoulEvent")

local scaleMult = 1.1

script.Parent.Enabled = true

menuMusic:Play()
player.Character:WaitForChild("Camera").Enabled = false
player.Character:WaitForChild("Light Part").SpotLight.Enabled = false
player.Character:WaitForChild("Light Part").SpotLight.LocalScript.Enabled = false
Camera.CameraType = Enum.CameraType.Scriptable
Camera.CFrame = menuCam.CFrame
player.Character:WaitForChild("HumanoidRootPart").Anchored = true
player.Character:WaitForChild("HumanoidRootPart"):WaitForChild("Running").Volume = 0

local buttons = {}

for _, obj in script.Parent:GetDescendants() do
	if obj:IsA("TextButton") then
		table.insert(buttons, obj)
	end
end

for _, button in buttons do
	local sound = script.Hovered:Clone()
	local scale = script.UIScale:Clone()
	sound.Parent = button
	scale.Parent = button
	button.MouseEnter:Connect(function()
		button.Hovered:Play()
		button.UIScale.Scale = scaleMult
	end)

	button.MouseLeave:Connect(function()
		button.UIScale.Scale = 1
	end)
end

button1.MouseButton1Click:Connect(function()
	menuMusic:Stop()
	lobbyMusic:Play()
	script.Parent.Enabled = false
	player.Character:WaitForChild("Camera").Enabled = false
	player.Character:WaitForChild("Light Part").SpotLight.Enabled = false
	player.Character:WaitForChild("Light Part").SpotLight.LocalScript.Enabled = false
	player.Character:WaitForChild("HumanoidRootPart"):WaitForChild("Fire").Enabled = true
	player.Character:WaitForChild("HumanoidRootPart"):WaitForChild("PointLight").Enabled = true
	Camera.CameraType = Enum.CameraType.Scriptable
	Camera.CFrame = mainLight.CFrame
	menuLight.SpotLight.Enabled = false
	wait(3)
	mainLight.SpotLight.Enabled = true
	mainLight.lightSound:Play()
	wait(2)
	loaded:Fire()
	player.Character:WaitForChild("HumanoidRootPart").Anchored = false
end)

local function skipIntro()
	menuMusic:Stop()
	lobbyMusic:Play()
	script.Parent.Enabled = false
	door1.Transparency = 1
	door2.Transparency = 0
	door1.CanCollide = false
	door2.CanCollide = true
	door2.Parent.OutsideLight.Smoke.Enabled = true
	door2.Parent.DoorLight.SpotLight.Enabled = true
	mainLight.SpotLight.Enabled = true
	player.Character:WaitForChild("Camera").Enabled = true
	player.Character:WaitForChild("Light Part").SpotLight.Enabled = true
	player.Character:WaitForChild("Light Part").SpotLight.LocalScript.Enabled = true
	player.Character:WaitForChild("HumanoidRootPart"):WaitForChild("PointLight").Enabled = true
	player.Character:WaitForChild("HumanoidRootPart").Anchored = false
	exit:FireServer()
	for _, v in pairs(player.Character:GetDescendants()) do
		if (v:IsA("Part") or v:IsA("MeshPart")) and not (v.Name == "HumanoidRootPart" or v.Name == "Light Part") then
			v.Transparency = 0
		end
		if v:IsA("Decal") then
			v.Transparency = 0
		end
	end
end

button2.MouseButton1Click:Connect(function()
	button1.Visible = false
	button1.Active = false
	button2.Visible = false
	button2.Active = false
	for i, button in script.Parent.Souls:GetChildren() do
		button.Visible = true
		button.Active = true
		button.MouseButton1Click:Connect(function()
			soulEvent:FireServer(i)
			skipIntro()
		end)
	end
end)

