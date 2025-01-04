local bark = script.Parent.Parent.Head.Bark

script.Parent:GetPropertyChangedSignal("Value"):Connect(function()
	if script.Parent.Value == true then
		bark:Play()
	else
		bark:Stop()
	end
end)