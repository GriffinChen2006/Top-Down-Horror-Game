local cand = script.Parent:GetChildren()
for _, obj in cand do
	if obj:IsA("Part") and not (obj.Name == "OutsideLight") then
		obj.Transparency = 1
	end
end