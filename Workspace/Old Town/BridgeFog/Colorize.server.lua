for i, obj in script.Parent:GetDescendants() do
	if obj:IsA("Smoke") then
		obj.Color = Color3.fromRGB(195, 186, 141)
	end
end