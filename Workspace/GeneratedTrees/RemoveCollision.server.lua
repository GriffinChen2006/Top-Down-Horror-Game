local cand = script.Parent:GetDescendants()

for _, obj in cand do
	if obj:IsA("Part") then
		obj.CanCollide = false
		obj.CanTouch = false
		obj.CanQuery = false
	end
end