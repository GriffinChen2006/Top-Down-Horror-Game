local config = {}

-- # Settings
config.enemy_char 		= script.Parent.Parent
config.enemy_hrt 		= config.enemy_char:WaitForChild("HumanoidRootPart")
config.enemy_human 		= config.enemy_char:WaitForChild("Humanoid")

config.AI_Init_Time 				= 3 		-- In order to prevent errors, this is recommended.
config.seeThroughTransparent 		= true		-- Whether or not the AI can see through transparent parts
config.isActive 					= true		
config.AntiLag 						= true		-- Dictates whether the AI antilag is activated. (goto Forbidden.AI and use the included anti-lag script there. dont touch this)
config.PreventAIFromSitting			= true
config.recoverSlowdownFactor 		= 4
config.hitboxes						= {}		-- As default, HumanoidRootPart is used (NOT recommended to do GetChildren() on AI).
config.damageDelay 					= 1		-- In seconds, how long until the AI can damage again (or move if setting below is enabled)
config.disable_ai_while_damaging 	= true -- Slowdown
config.damageDone 					= 10
config.chaseSpeed					= 22
config.crouchFactor 				= 0
config.walkFactor 					= 5
config.sprintFactor					= 15
config.wanderPenaltyFactor 			= 1
config.wanderFOVFactor 				= 1
config.enragedPenaltyFactor			= 2
config.enragedFOVFactor 			= 1.25
config.penaltyFactor 				= 1
config.FOVFactor 					= 1
config.chaseMusic 					= 1
config.optimalChasing				= true		-- If there are nodes in front of the NPC when it reaches a corner where a player was, it will go to a random one before wandering anywhere again.
config.NotInSightDoSprint			= true		-- if the player is not in sight, yet the AI is pathing to a location where it last saw it, should it sprint?
config.BadPathProtection			= true		-- if the target is unable to path to, repath to different target or wander?
config.detectionRange				= 25
config.detectionFOV					= 70		-- In degrees, the detection FOV of the AI. LIMIT: 180 for full 360 degrees.
config.detectionBubble				= 2.5		-- In studs, if the AI should autodetect a player, regardless of angle, within a range. will be fixed asap
config.doWander 					= true		-- Whether or not the AI will use the wander function when not chasing.
config.doRandomWander				= false		-- If true, calls "getRandomLocationInMap", otherwise, calls "getRandomNode" for a part to go to.
config.nodes_table					= {script.Parent.Parent.PatrolPath:GetChildren()}		-- If using random wander, give all valid floors. If not, give manually made nodes. (any models use primary part, if not, they are tossed)
config.wanderSpeed					= 12
config.debug_rand_pos 				= false 	-- If using the random wander function
config.Visualize					= false		-- Visualizes the pathfinding algorithm.
-- Chase AI with hiding settings
config.LockerChase					= true				-- If true, the AI chases the player to the locker. (should it see them hide.)
	-- for further editing, go to the script and add things to the functions. 

-- Pathfinding Settings
config.standardPathfindSettings 	= {AgentCanJump = false}		-- should your AI get stuck on corners, tweak these as followed in https://create.roblox.com/docs/characters/pathfinding (Agent-Radius, etc..).

--[[ Example
config.standardPathfindSettings 	= {			-- optimized for default dummies.
	AgentRadius = 2.25, 	-- default 2
	AgentHeight = 5.5, 		-- default 5
	AgentCanJump = true,	-- default true
	AgentCanClimb = false,	-- default false
	Cost = {}				-- default {}
}		-- should your AI get stuck on corners, tweak these as followed in https://create.roblox.com/docs/characters/pathfinding (Agent-Radius, etc..).

]]--






return config