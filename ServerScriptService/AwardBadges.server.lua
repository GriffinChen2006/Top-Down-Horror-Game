local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage:WaitForChild("BadgeGet")

event.OnServerEvent:Connect(function(plr, userid, id)
	local badgeService = game:GetService("BadgeService")
	local badgeInfo = badgeService:GetBadgeInfoAsync(id)
	if badgeInfo.IsEnabled then
		local success, hasBadge = pcall(function()
			return badgeService:UserHasBadgeAsync(userid, id)
		end)
		if not hasBadge then
			badgeService:AwardBadge(userid, id)
		end
	end
end)