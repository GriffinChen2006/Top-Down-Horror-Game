local camera = game.Workspace:WaitForChild("Camera")

local char:Model = script.Parent
local hrp = char.HumanoidRootPart

local mouse = game.Players.LocalPlayer:GetMouse()

local distance = script.Distance
local up_rotation = script.UpRotation
local side_rotation = script.SideRotation

local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

SoundService:SetListener(Enum.ListenerType.ObjectPosition, hrp)
camera.CameraType = Enum.CameraType.Scriptable

RunService.RenderStepped:Connect(function()
	camera.CFrame = 
		CFrame.new(hrp.Position)
		* CFrame.Angles(0, math.rad(side_rotation.Value), 0) -- Side rotation relative to world axis
		* CFrame.Angles(math.rad(-up_rotation.Value), 0, 0) -- Up rotation
		* CFrame.new(0, 0, distance.Value) -- Move camera back
end)
