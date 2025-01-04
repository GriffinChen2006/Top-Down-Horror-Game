local cand = script.Parent:GetDescendants()

local leafColor = Color3.fromRGB(52,44,3)
local branchColor = Color3.fromRGB(101,79,39)

for _, obj in cand do
	if obj:IsA("Part") then
		if obj.Name == "Leaves" then
			obj.Color = leafColor
		else
			obj.Color = branchColor
		end
	end
end