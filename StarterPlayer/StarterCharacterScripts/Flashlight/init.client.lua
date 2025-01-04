local character = script.Parent
local part = Instance.new("Part", character)
local clone = script.LocalScript:Clone()
local light = Instance.new("SpotLight")
local light2 = Instance.new("PointLight")
local hrp = character:WaitForChild("HumanoidRootPart")
local weld = Instance.new("Weld", part)

for _, v in pairs(character:GetDescendants()) do
	if v:IsA("Part") or v:IsA("MeshPart") then
		v.CastShadow = false
		v.Transparency = 1
	end
	if v:IsA("Decal") then
		v.Transparency = 1
	end
end
local fire = Instance.new("Fire", hrp)
fire.Color = Color3.fromRGB(0,106,236)
fire.SecondaryColor = Color3.fromRGB(0,255,255)
fire.Heat = 0
fire.Size = 6
fire.TimeScale = 0.1
fire.Enabled = false
part.CanCollide = false
part.CanTouch = false
part.CanQuery = false
part.Massless = true
part.Name = "Light Part"
part.Transparency = 1
part.Size = Vector3.new(0.1,0.1,0.1)
light.Shadows = true
light.Range = 60
light.Brightness = 2.5
light.Angle = 75
light.Parent = part
light2.Shadows = true
light2.Range = 8
light2.Brightness = 0.05
light2.Parent = hrp
light2.Enabled = false
clone.Parent = light
clone.Enabled = true
weld.Part0 = part
weld.Part1 = hrp
weld.Part0.Position = hrp.Position + Vector3.new(0, -1.5, 0.8)