-- // Test Dialogue // LocalScript
local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local camera = workspace.CurrentCamera
local event = replicatedStorage:WaitForChild("MidnightInteract")
local badgeGet = replicatedStorage:WaitForChild("BadgeGet")

local Player = game:GetService('Players').LocalPlayer
local DialoguesModule = require(script.Parent.Parent.Main:WaitForChild("DialoguesModule")) -- References the DialoguesModule to run DialoguesModule.CreateDialogue
local Prompt = workspace:WaitForChild("StartingArea"):WaitForChild("ClassSelection") -- Reference the ProximityPrompt
local character = Player.Character
local coinGetEvent = Player.PlayerGui:WaitForChild("CoinGet")
local coinEvent = Player.PlayerGui:WaitForChild("CoinGet"):WaitForChild("CoinGet")

local midnight = workspace:WaitForChild("StartingArea"):WaitForChild("Midnight")

local interactionCount = 1

local function acc()
	interactionCount += 1
end

local function coinGet()
	local coin = Instance.new("IntValue")
	coin.Name = "Cool Coin"
	coin.Parent = Player
	coin.Value = 1
	coinEvent:Fire()
	badgeGet:FireServer(Player.UserId, 482927938147783)
end

local function noMoreRepeats()
	script.Enabled = false
end

event.OnClientEvent:Connect(function()
	local randomNum = math.random(1,4)
	local init
	if randomNum == 1 then
		init = "Layer0"
	elseif randomNum == 2 then
		init = "Layer1"
	elseif randomNum == 3 then
		init = "Layer2"
	else
		init = "Layer3"
	end
	if interactionCount > 3 then
		init = "Layer4"
	end
	DialoguesModule.CreateDialogue({
		Content = {
			
			InitialLayer = init, -- Which layer to start the dialogue on
			DialogueTitle = "", -- The starting title of the Dialogue
			DialogueFrame = "CinematicSkin", -- Which DialogueFrame to use. Set to a custom one if you're using one. ("DialogueFrame" is the default.)
			ReplyFrame = "Reply", -- Which ReplyFrame to use if you're using a custom one. ("Reply" is the default.)

			Settings  = {
				Speaker = midnight,
				
				Typewriter = true, -- Enable/Disable the typewriter. The typewriter writes every individual letter instead of displaying the text in full instantly.
				TypewriterSpeed = 0.001, -- How fast text is displayed on the typewriter.
				SpecialTypewriterSpeed = 0.5,
				TypewriterVolume = 0.5,
				TypewriterSound = script.Sound, -- Play Dialogue Sound
				TypewriterTrimFactor = 8,

				Autoscroll = 0, -- 0 disables autoscroll. If the player doesn't click continue after the specified time, the dialogue moves to the next piece of content

				DialogueWalkSpeed = 0, -- The WalkSpeed when inside the dialogue. Set to nil to keep the defailt WalkSpeed.

				CinematicBars = true, -- Adds some cinematic bars when in the dialogue. Recommended if you're using the Cinematic skin.

				BackgroundSound = nil, -- Sound to play for the duration of the dialogue. Format as "rbxassetid://000" and not just a number.
				BackgroundSoundVol = 0.1, -- Volume of the BackgroundSound.

				DisableBackpack = true, -- Disables the players backpack when in the dialogue.
				DisableChat = false, -- Disables the chat when in the dialogue.
				DisableLeaderboard = false, -- Disables the leaderboard when in the dialogue.

				ContinueButtonVisibleDuringReply = false, -- Should the continue button be visible when replies are visible?
				ContinueButtonVisibleDuringTypewriter = false, -- Should the continue button be visible when the typewriter is writing?
				ContinueTextTransparency = 0.5, -- The transparency of the Continue text when the continue button is unable to be clicked.

				DialogueCam = Prompt:WaitForChild("Cam"),
				DialogueLight = Prompt:WaitForChild("Light").SpotLight,

				StopDialogueOnDeath = true, -- If the players humanoid dies, the dialogue will stop.
				InteractWithDialogueWhendead = false -- Can the player start the dialogue when they are dead?
			},

			Layer0 = { -- This is the first layer.
				DialogueContent = {"What are you standing around for?"}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
				DialogueSounds = {}, -- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
				DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
				LayerTitle = "Midnight", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

				Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)

				},

				Exec = {
					acc1 = {
						Function = acc,
						ExecuteContent = "executeAtEnd"
					}
				}
			},
			
			Layer1 = { -- This is the first layer.
				DialogueContent = {"Get out."}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
				DialogueSounds = {}, -- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
				DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
				LayerTitle = "Midnight", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

				Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)

				},

				Exec = {
					acc2 = {
						Function = acc,
						ExecuteContent = "executeAtEnd"
					}
				}
			},
			
			Layer2 = { -- This is the first layer.
				DialogueContent = {"I'm gonna starve to death.", "You don't want me to die, do you?"}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
				DialogueSounds = {}, -- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
				DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
				LayerTitle = "Midnight", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

				Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)

				},

				Exec = {
					acc3 = {
						Function = acc,
						ExecuteContent = "executeAtEnd"
					}
				}
			},
			
			Layer3 = { -- This is the first layer.
				DialogueContent = {"Maybe I'll just order delivery at this rate."}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
				DialogueSounds = {}, -- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
				DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
				LayerTitle = "Midnight", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

				Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)

				},

				Exec = {
					acc4 = {
						Function = acc,
						ExecuteContent = "executeAtEnd"
					}
				}
			},
			
			Layer4 = { -- This is the first layer.
				DialogueContent = {"Do you need more incentives? Is that it? Are you just big and greedy?", "Fine.",
					"Here's a cool coin I found a while ago. It's one of a kind... I think.",
					"It might fetch some value if there's still someone out there sane enough to trade with you instead of trying to eat you or something.",
					"Now get out of my sight, you've put me in a bad mood."}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
				DialogueSounds = {nil, nil, 9060788686},
				SoundVolumes = {nil, nil, 0.85},-- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
				DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
				LayerTitle = "Midnight", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

				Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)

				},

				Exec = {
					coinGet1 = {
						Function = coinGet,
						ExecuteContent = 3
					},
					noMoreRepeats1 = {
						Function = noMoreRepeats,
						ExecuteContent = "executeAtEnd"
					}
				}
			},

		--[[
		
		Use this to copy and paste a new layer if you want a clean layer.
		
		LayerName = { -- Rename LayerName to the name of your layer. It can be whatever you want as long as it isnt the same as something else!
			DialogueContent = {""},
			DialogueSounds = {},
			DialogueImage = "rbxassetid://000",
			LayerTitle = nil,

			Replies = {
			
			},

			Exec = {
			
			}
		},
		
		]]--
		},
	})
end)