local cs = game:GetService("CollectionService")
for i, obj in pairs(cs:GetTagged("IgnoreWhenPathing")) do
	if obj:IsA("Model") then
		for j, elem in obj:GetDescendants() do
			if elem:IsA("BasePart") then
				local mod = script.PassThrough:Clone()
				mod.Parent = elem
			end
		end
	elseif obj:IsA("BasePart") then
		local mod = script.PassThrough:Clone()
		mod.Parent = obj
	end
end