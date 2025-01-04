-- GO TO THE BOTTOM TO EDIT.

local function nullbind() end

-- For functions to hook to in the script.
type BINDS_IN_TYPEDEF = {
	StopChasing: () -> Player?, 		-- If chasing, will stop chasing than start a wander, returns the player it was chasing or nil
	Wander: (optNode: BasePart) -> boolean,				-- Will wander to a different location as long as its not chasing someone, returns false if chasing.
	ForceStartWander: (optNode: BasePart) -> nil,		-- If chasing player, will stop that call and wander as well.
	GetPlayerChasing: () -> Player?,	-- Gets the current player the AI is chasing, or returns nil.
	PauseAI: (optionalPauseTimer: number?) -> nil,	-- Pauses the AI for x seconds
	ResumeAI: () -> nil,							-- Resumes the AI if it is paused.
	--SetListOfAlternativeTargets: (List: {Model}) -> nil -- A table of NPCs the AI could target. (since naturally it only targets players) -- TODO
}

-- For functions created by this.
type BINDS_OUT_TYPEDEF = {
	INIT: () -> nil,								
	TouchedTargetPlayer: (Player: Player) -> nil,		-- Calls when the target player is touched.
	TouchedOtherPlayer: (Character: Model) -> nil,		-- Calls when a player other than the target is touched.
	PlayerChaseBegan: (Player: Player) -> nil,			-- Passes the player the AI has begun to chase.
	PlayerChaseEnded: (Player: Player) -> nil,			-- Passes the player the AI has stopped chasing.
	WanderStarted: (location: Vector3) -> nil,			-- Passes the location the AI has started to wander to.
	ContinueChasing: (Player: Player) -> boolean,		-- Asks if the AI should continue chasing the TargetPlayer.
	IsATarget: (Player: Player?) -> boolean,			-- Should the player be considered as a target for the AI, could also be a model if an NPC (SetListOfAlternativeTargets) was passed.
}

type HOOKS_TYPEDEF = {
	In: BINDS_IN_TYPEDEF,
	Out: BINDS_OUT_TYPEDEF
}

-- look above for info
local Hooks: HOOKS_TYPEDEF = {
	In = { -- These are binds you can use.
		StopChasing = nullbind,
		Wander = nullbind,
		ForceStartWander = nullbind,
		GetPlayerChasing = nullbind,
		PauseAI = nullbind,
		ResumeAI = nullbind,
		--SetListOfAlternativeTargets = nullbind -- TODO
	},
	Out = {
		INIT = nullbind,
		TouchedTargetPlayer = nullbind,
		TouchedOtherPlayer = nullbind,
		PlayerChaseBegan = nullbind,
		PlayerChaseEnded = nullbind,
		WanderStarted = nullbind,
		ContinueChasing = nullbind,
		IsATarget = nullbind
	}
}

local ChaseAI: BINDS_IN_TYPEDEF = nil -- will be loaded. (these are hooks to the script)
local config = require(script.Parent:WaitForChild("Settings"))
-- i.e. ChaseAI.Damage(player)

local binds: BINDS_OUT_TYPEDEF = {}

-- EXAMPLE
-- CHASE AI WITH HIDING
-- EXAMPLE
-- # Events
local rs 				= game:GetService("ReplicatedStorage")

local remotes			= rs:WaitForChild("signals"):WaitForChild("remotes")

local RE_HideEvent		= remotes:WaitForChild("events"):WaitForChild("HideEvent")
local RF_RequestLocker	= remotes:WaitForChild("functions"):WaitForChild("RequestLocker")

local forbidden			= rs:WaitForChild("Forbidden")
local ai				= require(forbidden:WaitForChild("AI"))

local function isPlayerHiding(TargetedPlayer: Player)
	local tV = TargetedPlayer:FindFirstChild("TemporaryValues")
	if tV == nil then return false end

	local isHidingObj = tV:FindFirstChild("isHiding")
	if isHidingObj == nil then return false end

	return isHidingObj.Value
end

binds.TouchedTargetPlayer = function(Character: Model)
	--print("Target Player Touched: " .. Character.Name)
end

local function reachedLockerWherePlayerWasHiding(Player: Player)
	-- for testing purposes
	local char = Player.Character
	local human = char:WaitForChild("Humanoid")
	human.Health -= 100 -- insta kill!
end

local function sawPlayerHide(Player: Player)

	local lockerHidingIn = RF_RequestLocker:InvokeClient(Player)
	if lockerHidingIn == nil then warn("No locker found! Player: "  .. Player.Name) return end

	local partToGo: BasePart = lockerHidingIn:WaitForChild("front")
	if partToGo == nil then warn("No spot for the AI to go in front of the locker to!") return end
	
	ChaseAI.PauseAI()
	ai.Stop(config.enemy_char)
	
	local done = false
	local result = nil
	
	local escaped = false
	spawn(function()
		while result == nil do
			if not isPlayerHiding(Player) then ChaseAI.ResumeAI() ai.Stop() escaped = true return end -- Handoff to normalcy if the player stops hiding.
			task.wait()
		end
	end)
	
	if #config.standardPathfindSettings > 0 then 
		result = ai.SmartPathfind(config.enemy_char, partToGo, true, {StandardPathfindSettings = config.standardPathfindSettings, ["Hooks"] = {GoalReached = function() reachedLockerWherePlayerWasHiding(Player) end}})
	else
		result = ai.SmartPathfind(config.enemy_char, partToGo, true, {["Hooks"] = {GoalReached = function() reachedLockerWherePlayerWasHiding(Player) end}})
	end
	
	if escaped then return end -- if the player left the locker than let the handler, handle it.

	ai.Stop(config.enemy_char) -- idk if needed, just for insurance.
	ChaseAI.ResumeAI()
	if result == Enum.PathStatus.NoPath then done = true warn("No path found! (could be caused by locker chase cancel)") return end 
	
	return 
end

binds.TouchedOtherPlayer = function(Character: Model)
	--print("Other Player Touched: " .. Character.Name)
end


binds.PlayerChaseBegan = function(Player: Player)
	--print("Chasing Player: " .. Player.Name)
end

-- READ: Use WanderStarted for a true lost player, since this is also called when the AI tracks to the position it last saw the player.
binds.PlayerChaseEnded = function(Player: Player)
	--print("Player Line of Sight Lost: " .. Player.Name)
	if isPlayerHiding(Player) and config.LockerChase then 
		sawPlayerHide(Player)
	end
end


binds.WanderStarted = function(location: Vector3)
	--print("Wander Started to Location: " .. tostring(location))
	--print("Wander Started")
end


-- Add special code here to influence if the AI should keep chasing the player.
binds.ContinueChasing = function()
	return true
end


-- Return false to remove a player as a possible target (for that cycle)
binds.IsATarget = function()
	return true
end


-- Called when the script loads all the BINDS_IN.
binds.INIT = function()
	ChaseAI = Hooks.In
end

-- Set hooks out to the binds created.
Hooks.Out = binds

return Hooks