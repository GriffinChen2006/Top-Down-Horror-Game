local mouse = game.Players.LocalPlayer:GetMouse()
local imagelabel = script.Parent
local player = game.Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
imagelabel.ImageLabel.ImageTransparency = 0
game:GetService("UserInputService").MouseIconEnabled = false

mouse.Move:Connect(function()
	imagelabel.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
end)
