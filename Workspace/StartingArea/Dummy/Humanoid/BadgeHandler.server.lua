local attackers = {}
local totalDmg = {}
local humanoid = script.Parent

local rs = game:GetService("ReplicatedStorage")
local event = rs:WaitForChild("DamageEvent")

local requiredDmgForBadge = 500

local id = 3476294098602663

event.Event:Connect(function(player, hum, dmg)
	if hum == humanoid then
		local index = table.find(attackers, player)
		if not index then
			table.insert(attackers, player)
			table.insert(totalDmg, dmg)
		else
			totalDmg[index] += dmg
			if totalDmg[index] >= requiredDmgForBadge then
				local userid = player.UserId
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
			end
		end
	end
end)