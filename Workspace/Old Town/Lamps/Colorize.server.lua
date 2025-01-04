for i, obj in script.Parent:GetDescendants() do
	if obj:IsA("SpotLight") or obj.Name == "LightPart" then
		obj.Color = Color3.fromRGB(255, 226, 121)
	end
	if obj:IsA("ImageLabel") then
		obj.ImageColor3 = Color3.fromRGB(255, 226, 121)
	end
end