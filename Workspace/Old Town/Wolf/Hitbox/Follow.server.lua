local anchor = script.Parent.Parent.HitboxAnchor
local rs = game:GetService("RunService")
rs.Heartbeat:Connect(function()
	script.Parent.CFrame = anchor.CFrame
end)