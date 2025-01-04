-- Made by crit0271, Forbidden API <3

-- # Services
local players 			= game:GetService("Players")
local rs 				= game:GetService("ReplicatedStorage")
local run 				= game:GetService("RunService")
local debris			= game:GetService("Debris")

-- # Forbidden Modules
local forbidden_rs 		= rs:WaitForChild("Forbidden")
local std 				= require(forbidden_rs:WaitForChild("Standard"))
local ai 				= require(forbidden_rs:WaitForChild("AI"))

-- # Events
local events 			= script.Parent:WaitForChild("Events")

local BE_StartAI 		= events:WaitForChild("StartAI")
local BE_StopAI 		= events:WaitForChild("StopAI")
local BE_TargetSeen 	= events:WaitForChild("TargetSeen")
local BE_TargetLost 	= events:WaitForChild("TargetLost")

-- # Settings
local config = require(script:WaitForChild("Settings"))
local hooks = require(script:WaitForChild("Hooks")) 

-- variables (DO NOT TOUCH)
local isWandering 		= false
local isChasing 		= false
local plrChasing 		= nil
local lastCallTime		= 0
local doOptChase 		= false -- after a chase, an optimal chase will be done if active.

local creditKill 		= false
local damaged_recently 	= script.DamagedRecently

local badPathVictims	= {} -- tracks the players the AI cannot path to so it doesnt try to for a little while.

if config.PreventAIFromSitting then
	config.enemy_char:WaitForChild("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, false) -- prevents NPC from sitting
end

-- User Defineable Functions

local function setNetworkOwner(player: Player)
	-- basically anti-lag, (so people dont get killed where they were 3 seconds ago, though I would delete this if you make TouchedOther kill other people.)
	if config.AntiLag then return end
	config.enemy_char:WaitForChild("HumanoidRootPart"):SetNetworkOwner(player)
end

-- 10/18/24 @rman501, debug prints function.
local doPrints = false
if doPrints then
	print("[ChaseAI] Debug Prints")
end
local function debugPrint(message: any)
	if not doPrints then return end
	print(message)
end

-- disables AI for a while it is killing (if enabled)
local function damage_delay_handler()

	creditKill = true -- if the player is lost and it doesnt think it killed it (based on this variable) then it will call LostPlayer

	if config.disable_ai_while_damaging then
			-- config.isActive = false
		if not damaged_recently.Value then
			local currentSpd = script.Parent:WaitForChild("Humanoid").WalkSpeed
			script.Parent:WaitForChild("Humanoid").WalkSpeed = currentSpd / config.recoverSlowdownFactor
			damaged_recently.Value = true
			spawn(function()
				task.wait(config.damageDelay)
				script.Parent:WaitForChild("Humanoid").WalkSpeed = currentSpd
			end)
		end
			-- config.isActive = true
	end

	if not(config.disable_ai_while_damaging) then
		damaged_recently.Value = true
	end
end

-- Called if a player that is not targeted is touched.
local function TouchedOther(other_plr_char: Model)
	hooks.Out.TouchedOtherPlayer(other_plr_char)
end

-- Called when the targeted player is touched.
local function Damage(player: Player)


	if damaged_recently.Value then return end
	if not config.isActive then return end


	local plr_char = player.Character
	if plr_char == nil then return end
	if plr_char.Name ~= plrChasing.Name then return end -- redundant


	local plr_human = plr_char.Humanoid
	if plr_human.Health <= 0 then return end

	damage_delay_handler() -- mandatory ...
	
	-- Damage player, SFX, animations, etc...
	local plr_human = plr_char.Humanoid
	plr_human.Health -= config.damageDone
	print("damage")

	hooks.Out.TouchedTargetPlayer(player.Character)

	if plr_human.Health <= 0 then
		-- player is dead now.
		setNetworkOwner(nil)
	end
end

-- t3's purpose is for char.tool.Handle
local function partDescendantOfChar(part) -- HELPER FOR TOUCH HANDLER

	local t1 = part.Parent
	local t2 = nil
	local t3 = nil
	if t1 ~= nil then
		t2 = t1.Parent
		if t2 ~= nil then
			t3 = t2.Parent
		end
	end

	if t1 ~= nil then
		if t1:FindFirstChild("Humanoid") then return t1 end
	else
		return false
	end

	if t2 ~= nil then
		if t2:FindFirstChild("Humanoid") then return t2 end
	else
		return false
	end

	if t3 ~= nil then
		if t3:FindFirstChild("Humanoid") then return t3 end
	else
		return false
	end

	return false

end

-- Determines if a player was touched
local function touchHandler(hit) -- HELPER

	if not config.isActive then return end

	local char = partDescendantOfChar(hit)
	if not(char) then return end

	local player = players:FindFirstChild(char.Name)
	if player == nil then return end

	local plr_human = char:FindFirstChild("Humanoid")
	if plr_human == nil then return end
	if plr_human.Health <= 0 then return end

	if player == plrChasing then
		Damage(plrChasing)
	else
		TouchedOther(char)
	end

end

-- During the continous loop to ensure the player should still be chased, your own input. If false, it stops.
local function ContinueChasing(TargetedPlayer: Player)
	
	local inChase = TargetedPlayer.Character:WaitForChild("InChase")
	local chaseMusic = TargetedPlayer.Character:WaitForChild("InChase"):FindFirstChild("Monster")
	local persistence = inChase:FindFirstChild("Persistence")

	inChase.Value = true
	chaseMusic.Value = config.chaseMusic
	persistence.Value = 3
	config.penaltyFactor = config.enragedPenaltyFactor
	config.FOVFactor = config.enragedFOVFactor
	
	return true
end

-- In case you want to have a hiding feature, etc... (Once, see ContinueChasing for continous calls)
local function ConfirmPlayerChase(TargetedPlayer: Player)
	return true
end

local function IsATarget(TargetedPlayer: Player?)
	return true and hooks.Out.IsATarget(TargetedPlayer) -- for no effect.
end

-- CALLED WHENEVER THE AI STARTS TO CHASE A PLAYER
local function PlayerChaseBegan(TargetedPlayer: Player)
	BE_TargetSeen:Fire(TargetedPlayer)
	setNetworkOwner(TargetedPlayer)

	hooks.Out.PlayerChaseBegan(TargetedPlayer)
	
	return true
end

-- If you want ConfirmPlayerLost, you will need to go to Chase, due to a variety of reasons for the player to be lost.

-- CALLED WHENEVER THE AI LOSES THE TARGETED PLAYER!
local function LostPlayer(TargetedPlayer: Player, overrideNetworkReset: boolean)
	BE_TargetLost:Fire(TargetedPlayer)

	creditKill = false
	config.enemy_human.WalkSpeed = config.wanderSpeed

	if not overrideNetworkReset then
		setNetworkOwner(nil)
	end
	
	hooks.Out.PlayerChaseEnded(TargetedPlayer)
	
	local inChase = TargetedPlayer.Character:WaitForChild("InChase")
	local persistence = inChase:FindFirstChild("Persistence")
	persistence.Value = 3
	config.penaltyFactor = config.wanderPenaltyFactor
	config.FOVFactor = config.wanderFOVFactor
end

-- Called when the AI starts to wander.
local function WanderStarted(location: Vector3) -- wander ends when a player is begun to be chased.
	hooks.Out.WanderStarted(location)
	setNetworkOwner(nil)
end








-- Suggested not to mess with the functions below, they are the core functions, but if you need
-- to change something, by all means do it!







-- For optimal chasing, whenever the AI loses the player, the next wander will be a node in front of it (towards the where the player should be)
local function getPossibleNodes()

	if config.nodes_table == nil then error("config.nodes_table is nil.") end
	if #config.nodes_table <= 0 then error("No nodes!") end

	if not config.optimalChasing or not doOptChase then return config.nodes_table end

	-- If the nodes should be those in front of the NPC. (optimalChasing)
	local optNodes = {}

	for i, node in pairs(config.nodes_table) do 
		if not std.math.IsInView(config.enemy_char, node, 70, false) then continue end
		table.insert(optNodes, node)
	end

	if #optNodes <= 0 then
		return config.nodes_table
	end

	return optNodes 
end

-- If config.doRandomWander is TRUE
-- Uses the config.nodes_table and makes a node above those floors at a random point.
local prev_debug_nodes = {}
local function getRandomLocationInMap()

	local floors = getPossibleNodes()
	local randomFloor = nil

	-- Honestly, I do not know why, I do not want to know why, nor do I care why. But this loop fixed a bug! I love this loop! It is pointless! But I love it! I am going insane!
	while randomFloor == nil do
		run.Heartbeat:Wait()

		local randInt = math.random(1, #floors)
		local __randomFloor = floors[randInt]
		if __randomFloor:IsA("BasePart") then
			randomFloor = __randomFloor
		end
	end


	-- Gets a random location above the floor given.
	local rf_pos = randomFloor.Position
	local sizeRand = Vector3.new(math.random(- randomFloor.Size.X / 2, randomFloor.Size.X / 2), 0, math.random(- randomFloor.Size.Z / 2, randomFloor.Size.Z / 2))
	local vec3 = Vector3.new(rf_pos.X + sizeRand.X, rf_pos.Y + randomFloor.Size.Y / 2 + 2, rf_pos.Z + sizeRand.Z)

	--print("Making node at ")
	--print(vec3)
	for i, v in prev_debug_nodes do
		v:Destroy()
	end

	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Color = Color3.fromRGB(255,255,0)
	part.Size = Vector3.new(2,2,2)
	part.Position = vec3
	part.Parent = workspace
	--print(part)
	table.insert(prev_debug_nodes, part)

	if config.debug_rand_pos then part.Transparency = 0.25 end

	return part
end

-- If config.doRandomWander is FALSE
-- Returns a random node from the possible nodes for the AI to wander to.
local function getRandomNode()	
	local nodes = getPossibleNodes()
	return nodes[math.random(1, #nodes)]
end

-- Track to the last known position
local chasePart = Instance.new("Part")
chasePart.Shape = Enum.PartType.Ball
chasePart.Color = Color3.new(0.384314, 0.341176, 1)
chasePart.Material = Enum.Material.Neon
chasePart.Anchored = true
chasePart.Size = Vector3.new(1,1,1)
chasePart.CanCollide = false
chasePart.Transparency = 1
if config.Visualize then
	chasePart.Transparency = 0.5
end
chasePart.Name = "ChasePartForNPC-Forbidden"
chasePart.Parent = workspace

local function isInView(plr_char: Model) -- Determines if a model is in the view of the AI.

	-- idiot protection
	if config.detectionFOV < 0 then config.detectionFOV = 0 end
	if config.detectionFOV > 180 then config.detectionFOV = 180 end

	local plr_hrt = plr_char.HumanoidRootPart
	local detectionFactor = 0
	local class_factor = 1
	local class = plr_char:FindFirstChild("Soul").Value
	local status = plr_char:FindFirstChild("Movement").Value
	
	local FOV = config.detectionFOV
	
	if class == 2 then
		class_factor = 0.75
	end
	
	if status == 0 then
		detectionFactor = config.walkFactor
	elseif status == 1 then
		detectionFactor = config.sprintFactor
	else
		detectionFactor = config.crouchFactor
	end
	
	detectionFactor = config.detectionRange * config.penaltyFactor
	FOV = config.detectionFOV * config.FOVFactor
	
	local result = std.math.LineOfSight(config.enemy_char, plr_char, {range = config.detectionRange + detectionFactor, SeeThroughTransparentParts = config.seeThroughTransparent, filterTable = {config.enemy_char, chasePart}})

	if result then
		local isInfront = false
		local isNextTo = false
		local angle = math.acos(config.enemy_hrt.CFrame.LookVector:Dot((plr_hrt.Position-config.enemy_hrt.Position).Unit))
		local isInFOVAngle = angle < config.detectionFOV * (math.pi / 180) -- works on 0: Ahead to PI: Behind (symmetrical on left and right sides of AI)
		if isInFOVAngle then
			return true
		end
	end

	return false
end


local canChaseToCorner = false
local function Chase(player: Player?)
	if isChasing then return end
	isWandering = false

	local function stopChasing() -- if the AI stops chasing someone
		config.enemy_human.WalkSpeed = config.wanderSpeed
		plrChasing = nil
		isChasing = false
	end

	setNetworkOwner(player)

	local plr_char = player.Character
	if plr_char == nil then warn("Player is nil!") return end

	local core_failures = 0

	-- 9/28/24 Bad Pathing Protection Added.
	local function coreTrack_UnableToPath()
		core_failures += 1
		if core_failures > 5 then return end
		--print("Rerouting!")
		isWandering = false
		isChasing = false
		table.insert(badPathVictims, {player, os.clock()})
		stopChasing()
	end

	local function dummy_coreTrack_UnableToPath(goal, message)
		--print("Bad Path!")
		if not config.BadPathProtection then return end
		coreTrack_UnableToPath()
	end

	local function trackPlayer()
		if #config.standardPathfindSettings > 0 then 
			ai.SmartPathfind(config.enemy_char, player.Character, false, {Tracking = true, StandardPathfindingSettings = config.standardPathfindSettings, SMMD_RaycastParams = {range = 25, filterTable = {config.enemy_char, chasePart}}, Visualize = config.Visualize, Hooks = {UnableToPath = dummy_coreTrack_UnableToPath}}) -- start player chase.
		else
			ai.SmartPathfind(config.enemy_char, player.Character, false, {Tracking = true, SMMD_RaycastParams = {range = 25, filterTable = {config.enemy_char, chasePart}}, Visualize = config.Visualize, Hooks = {UnableToPath = dummy_coreTrack_UnableToPath}}) -- start player chase.
		end
		lastCallTime = os.clock()
	end

	-- Stop a previous pathfind. 10/20/24 @rman501, lastCallTime might be unimportant.
	if lastCallTime > 0 then lastCallTime = 0 end

	-- Start player tracking.
	trackPlayer()

	local plr_hrt = plr_char.HumanoidRootPart

	-- Chase
	isChasing = true
	plrChasing = player

	local specRelease = false

	PlayerChaseBegan(player)

	while isChasing do
		run.Heartbeat:Wait()
		
		if not (damaged_recently.Value) then
			config.enemy_human.WalkSpeed = config.chaseSpeed
		end

		if plr_char == nil then stopChasing() break end
		local plr_human = plr_char:FindFirstChild("Humanoid")
		if plr_human and plr_human.Health <= 0 then stopChasing() break end

		if not ContinueChasing(player) then break end

		-- If the NPC loses sight of the player, then chase to its last known location.
		if std.math.LineOfSight(config.enemy_char, plr_char, {range = config.detectionRange, SeeThroughTransparentParts = config.seeThroughTransparent, filterTable = {config.enemy_char, chasePart}}) then
			chasePart.Position = plr_hrt.Position
			canChaseToCorner = true
		else

			if plrChasing == nil then return end -- Player is gone, or the chase was cancelled.

			-- Make sure the call is not redundant, if it is then just update position.
			if not canChaseToCorner then break end
			canChaseToCorner = false

			-- Make the NPC believe it is wandering.
			isWandering = true 

			task.wait() -- prevents tracking from being idiotic.


			-- Announce the player is lost, so that if along the way the NPC finds another player, it will chase them instead
			specRelease = true
			doOptChase = true
			spawn(function()
				local result = nil
				local timeNow = os.clock()


				lastCallTime = timeNow
				if #config.standardPathfindSettings > 0 then 
					result = ai.SmartPathfind(config.enemy_char, chasePart, true, {SkipToWaypoint = 2, StandardPathfindingSettings = config.standardPathfindSettings, SMMD_RaycastParams = {range = 25}, Visualize = config.Visualize}) -- start player chase.
				else
					result = ai.SmartPathfind(config.enemy_char, chasePart, true, {SkipToWaypoint = 2, SMMD_RaycastParams = {range = 25, Visualize = config.Visualize}}) -- start player chase.
				end
				if result == Enum.PathStatus.NoPath then end

				-- When the pathfind is done, either because it got cancelled, or etc...
				if lastCallTime ~= timeNow then return end
				isWandering = false
				lastCallTime = 0

				--if config.NotInSightDoSprint then config.enemy_human.WalkSpeed = config.wanderSpeed end
			end)

			task.wait() -- always nice to wait a lil bit for the pathing to activate.

			break
		end
	end

	stopChasing()
	if config.NotInSightDoSprint and specRelease and (not damaged_recently.Value) then config.enemy_human.WalkSpeed = config.chaseSpeed end
	if not specRelease then lastCallTime = 0 end
	LostPlayer(player, specRelease)
end

local forcedNode: BasePart = nil -- 10/21/24 @rman501, for hooks.
local function Wander()

	if isChasing then 
		--print("A") 
		return 
	end
	if isWandering then 
		--print("B") 
		return 
	end
	if lastCallTime > 0 then 
		--print("C") 
		return 
	end 

	isWandering = true

	config.enemy_human.WalkSpeed = config.wanderSpeed

	-- 9/28/24 @rman501, refactored and taken out of async.
	local forcedNodeUsed = false
	local function tryPathfind()

		local randomLocation = nil

		if forcedNode == nil then
			if config.doRandomWander then
				randomLocation = getRandomLocationInMap()
			end

			if not config.doRandomWander then
				randomLocation = getRandomNode()
			end
		end

		-- 10/21/24 @rman501, allow people to choose a node to target with hooks
		if forcedNode ~= nil then
			randomLocation = forcedNode
			forcedNodeUsed = true
		end


		doOptChase = false

		if randomLocation == nil then warn("Random Location was nil, please make sure all the nodes are correct!") return Enum.PathStatus.NoPath end

		WanderStarted(randomLocation.Position)

		if #config.standardPathfindSettings > 0 then 
			return ai.SmartPathfind(config.enemy_char, randomLocation, true, {StandardPathfindingSettings = config.standardPathfindSettings, SMMD_RaycastParams = {range = 25, filterTable = {config.enemy_char, chasePart}}, Visualize = config.Visualize}) -- start player chase.
		else
			return ai.SmartPathfind(config.enemy_char, randomLocation, true, {SMMD_RaycastParams = {range = 25, filterTable = {config.enemy_char, chasePart}}, Visualize = config.Visualize}) -- start player chase.
		end
	end

	-- 9/28/24 @rman501, moved things around.
	local tStarted = os.clock()
	lastCallTime = tStarted
	spawn(function()

		-- Repeat a pathfind until it likes its location, while ensuring nothing is going haywire in the background.
		if tStarted ~= lastCallTime then return end

		while tryPathfind() == Enum.PathStatus.NoPath do
			if config.enemy_char == nil then return end
			run.Heartbeat:Wait()
			if tStarted ~= lastCallTime then return end
			if isChasing then return end
			if not isWandering then return end
			if forcedNodeUsed then forcedNode = nil forcedNodeUsed = false end -- 10/21/24 @rman501, allow people to choose a node to target with hooks
			tStarted = os.clock()
			lastCallTime = tStarted
		end

		if isChasing then return end
		if tStarted ~= lastCallTime then return end
		--print("opachki.")
		lastCallTime = 0
		isWandering = false
	end)

end

local NPC_List = {}
local function GetNearestVisiblePlayer()

	local playersInLOS = {}

	-- Make sure no bad paths exist.
	local newTable = {}

	for i, v: {player: Player, bpt: number} in pairs(badPathVictims) do
		if v[1] == nil then continue end
		if os.clock() - 3 < v[2] then
			table.insert(newTable, v)
		end
	end

	badPathVictims = newTable

	for i, player in players:GetChildren() do

		if not IsATarget(player) then continue end
		if not hooks.Out.IsATarget(player) then continue end


		local plr_char = player.Character
		if plr_char == nil then continue end

		local plr_hrt = plr_char:FindFirstChild("HumanoidRootPart") -- 9/28/24, FFC.
		if plr_hrt == nil then continue end

		local plr_human = plr_char:FindFirstChild("Humanoid")
		if plr_human == nil then continue end

		-- 10/20/24 @rman501, if dead, then consider it.
		if plr_human.Health <= 0 then continue end

		-- 9/28/24 BadPathProtection, Added.
		if config.BadPathProtection then
			local function isBPV()
				for i, v: {player: Player, bpt: number} in pairs(badPathVictims) do
					if v[1] == player then
						return true
					end
				end

				return false
			end

			if isBPV() then
				continue
			end
		end

		local dist = (config.enemy_hrt.Position - plr_hrt.Position).Magnitude

		if isInView(plr_char) then
			table.insert(playersInLOS, {dist, player})
			continue
		end

		if dist <= config.detectionBubble then --untested

			local plr_hrt = plr_char.HumanoidRootPart
			local result = std.math.LineOfSight(config.enemy_char, plr_char, {range = config.detectionRange, SeeThroughTransparentParts = config.seeThroughTransparent, filterTable = {config.enemy_char, chasePart}})

			if result then
				table.insert(playersInLOS, {dist, player})
				continue
			end
		end

	end

	local nearestPlr = nil
	local nearestDist = math.huge
	for i, data in pairs(playersInLOS) do

		if nearestDist > data[1] then
			nearestDist = data[1]
			nearestPlr = data[2]
		end

	end

	return nearestPlr
end

-- Protection against bad nodes.
local function cleanNodesTable()

	if config.nodes_table == nil then error("Nodes table is nil!") end

	-- If the user provides a folder, this converts it into the proper format.
	if typeof(config.nodes_table) == "Instance" then config.nodes_table = {config.nodes_table} end

	-- Recursively expands all provided tables
	local expandingComplete = false
	while not expandingComplete do
		expandingComplete = true
		for i, potentialTable in pairs(config.nodes_table) do

			local function doExpansion(tab)
				table.remove(config.nodes_table, i)
				for _, node in pairs(tab) do
					table.insert(config.nodes_table, node)
				end
				expandingComplete = false
			end

			if typeof(potentialTable) == "Instance" then
				if potentialTable:IsA("Folder") then
					doExpansion(potentialTable:GetChildren())
					break
				end
			end

			if typeof(potentialTable) == "table" then
				doExpansion(potentialTable)
				break
			end

		end
	end

	-- Removes unusable nodes.
	local indicesToRemove = {}
	for i, v: Instance in pairs(config.nodes_table) do
		if v:IsA("BasePart") then continue end -- good node.
		table.insert(indicesToRemove, 1, i)
	end

	-- Removes all bad nodes in reverse order.
	for _, index in ipairs(indicesToRemove) do
		table.remove(config.nodes_table, index)
	end

end

-- The core loop
local function Main()

	cleanNodesTable()

	while config.enemy_human.Health > 0 do -- 9/28/24 @rman501, make sure AI is alive :bangbang:

		run.Heartbeat:Wait()

		if config.isActive then

			local nearestVisPlayer = GetNearestVisiblePlayer()
			if nearestVisPlayer ~= nil then
				if ConfirmPlayerChase(nearestVisPlayer) then
					Chase(nearestVisPlayer)
				end
			else
				if config.enemy_human.MoveDirection.Magnitude < 0.25 and config.doWander then -- if its not chasing then wander
					Wander()
				end
			end
		end

	end

end

local function stopAI()
	config.isActive = false
	plrChasing = nil
	isChasing = false
	config.enemy_human.WalkSpeed = config.wanderSpeed
end
BE_StopAI.Event:Connect(stopAI)

local function startAI()
	config.isActive = true
end
BE_StartAI.Event:Connect(startAI)

config.enemy_hrt.Touched:Connect(touchHandler)
for i, hitbox in pairs(config.hitboxes) do
	hitbox.Touched:Connect(touchHandler)
end

--[[

HOOKING INITIALIZATION

]]--

local HOOKS_IN = {}

HOOKS_IN.StopChasing = function()

	if not plrChasing then return nil end
	local playerChased = plrChasing

	table.insert(badPathVictims, {plrChasing, os.clock()})
	plrChasing = nil
	isChasing = false
	config.enemy_human.WalkSpeed = config.wanderSpeed
	lastCallTime = 0
	LostPlayer(playerChased, true)

	return playerChased
end

HOOKS_IN.Wander = function(optNode: BasePart)
	if isChasing then return false end

	if optNode ~= nil then forcedNode = optNode end

	isChasing = false
	isWandering = false
	lastCallTime = 0
end

HOOKS_IN.ForceStartWander = function(optNode: BasePart)
	if isChasing then
		HOOKS_IN.StopChasing()
	end

	if not isChasing then
		HOOKS_IN.Wander(optNode)
	end
end

HOOKS_IN.GetPlayerChasing = function()
	return plrChasing
end

HOOKS_IN.PauseAI = function(optionalPauseTimer: number)
	if isChasing then
		config.isActive = false
		HOOKS_IN.StopChasing()
		if optionalPauseTimer == nil then return end
		if optionalPauseTimer <= 0 then return end
		task.wait(optionalPauseTimer)
		HOOKS_IN.ResumeAI()
	end
end

HOOKS_IN.ResumeAI = function()
	config.isActive = true

end

HOOKS_IN.SetListOfAlternativeTargets = function(newList: {Model})
	NPC_List = newList
end

hooks.In = HOOKS_IN

--[[

HOOKING INITIALIZATION

]]--
task.wait(config.AI_Init_Time) -- recommended

hooks.Out.INIT()
Main()

-- opachki