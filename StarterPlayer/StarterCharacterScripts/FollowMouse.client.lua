local Player = game.Players.LocalPlayer
local Character = Player.Character
local Root = Character:WaitForChild("HumanoidRootPart")
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local humanoid = Character:WaitForChild("Humanoid")

RunService.RenderStepped:Connect(function()
	local unitRay = camera:ViewportPointToRay(Mouse.X, Mouse.Y)
	local raycastParams = RaycastParams.new()
	
	humanoid.AutoRotate = false

	raycastParams.FilterType = Enum.RaycastFilterType.Include
	raycastParams.FilterDescendantsInstances = {
		workspace:FindFirstChild("Old Town"):FindFirstChild("BridgeMouseParts"),
		workspace:FindFirstChild("Old Town"):FindFirstChild("Floor"),
		workspace:FindFirstChild("StartingArea"):FindFirstChild("Floor")
	}
	local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 400, raycastParams)

	if raycastResult then
		local RootPos, MousePos = Root.Position, raycastResult.Position
		Root.CFrame = CFrame.new(RootPos, Vector3.new(MousePos.X, RootPos.Y, MousePos.Z))
	end
end)