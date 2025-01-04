local humanoid = script.Parent
local currentHP = humanoid.Health
local newHP
local change

-- Define a table of bright colors
local brightColors = {
	Color3.new(1, 0, 0), -- Red
	Color3.new(0, 1, 0), -- Green
	Color3.new(0, 0, 1), -- Blue
	Color3.new(1, 1, 0), -- Yellow
	Color3.new(1, 0, 1), -- Magenta
	Color3.new(0, 1, 1), -- Cyan
	Color3.new(1, 0.5, 0), -- Orange
	Color3.new(0.5, 0, 1) -- Purple
}

local function createFloatingText(change)
	local char = humanoid.Parent
	local head = char:FindFirstChild("Head")
	if not head then return end -- Ensure the character has a head

	-- Create a BillboardGui
	local billboard = Instance.new("BillboardGui")

	-- Generate a random position around the head within a radius (parallel to the ground)
	local radius = 3
	local angle = math.random() * 2 * math.pi
	local offsetX = math.cos(angle) * radius
	local offsetZ = math.sin(angle) * radius
	local height = math.random(100,300)/100
	billboard.StudsOffset = Vector3.new(offsetX, height, offsetZ) -- Random position around the head, fixed height

	-- Scale text size based on damage within the range of 20 to 200, and add randomization
	local normalizedDamage = math.clamp((change - 20) / (400 - 20), 0, 5) -- Normalize damage to a 0-1 scale
	local baseSize = 1 + normalizedDamage * 4 -- Base size ranges from 1 to 5
	local randomMultiplier = math.random(90, 110) / 100 -- Random size between 90% and 110%
	local finalSize = baseSize * randomMultiplier
	billboard.Size = UDim2.new(4 * finalSize, 0, 2 * finalSize, 0) -- Adjust size based on final calculation

	billboard.Adornee = head
	billboard.Parent = head
	billboard.AlwaysOnTop = true

	-- Create the TextLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0) -- Fill the BillboardGui
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5) -- Center the text within the label
	textLabel.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center position
	textLabel.BackgroundTransparency = 1
	textLabel.Text = tostring(-change) -- Negative change as damage
	textLabel.TextTransparency = 0
	textLabel.TextColor3 = brightColors[math.random(1, #brightColors)] -- Random bright color
	textLabel.TextStrokeTransparency = 0
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = billboard

	-- Animate the text (e.g., fade out and move up)
	local tweenService = game:GetService("TweenService")
	local info = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
	local tweenGoal = {TextTransparency = 1, TextStrokeTransparency = 1, Position = UDim2.new(0.5, 0, 0.2, 0)} -- Move text slightly up
	local tween = tweenService:Create(textLabel, info, tweenGoal)

	tween:Play()
	tween.Completed:Connect(function()
		billboard:Destroy()
	end)
end

humanoid:GetPropertyChangedSignal("Health"):Connect(function()
	newHP = humanoid.Health
	change = currentHP - newHP
	humanoid.Health = currentHP
	if change ~= 0 then
		createFloatingText(change)
	end
end)
