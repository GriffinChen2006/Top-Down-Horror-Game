local cand = script.Parent:GetChildren()
local covers = {}
local textures = script:GetChildren()
for _, obj in cand do
	if obj.Name == "Union" then
		table.insert(covers, obj)
	end
end
for _, cover in covers do
	for i, texture in textures do
		local copy = texture:Clone()
		copy.Parent = cover
		copy.Color3 = cover.Color
	end
end