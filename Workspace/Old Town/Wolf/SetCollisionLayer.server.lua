local cand = script.Parent:GetDescendants()
for _, obj in cand do
	if obj:IsA("BasePart") and obj.Name ~= "Hitbox" then
		obj.CollisionGroup = "Enemy"
	end
end