-- // Test Dialogue // LocalScript
local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local camera = workspace.CurrentCamera
local event = replicatedStorage:WaitForChild("DialogueTriggered")
local badgeGet = replicatedStorage:WaitForChild("BadgeGet")

local Player = game:GetService('Players').LocalPlayer
local DialoguesModule = require(script.Parent.Parent.Main:WaitForChild("DialoguesModule")) -- References the DialoguesModule to run DialoguesModule.CreateDialogue
local Prompt = workspace:WaitForChild("StartingArea"):WaitForChild("Dummy") -- Reference the ProximityPrompt
local light = workspace:WaitForChild("StartingArea"):WaitForChild("DummyLight")
local character = Player.Character

local function activateLight()
	light.lightSound:Play()
	light.SpotLight.Enabled = true
end

event.OnClientEvent:Connect(function(NPC)
	if NPC == "Dummy" then
		DialoguesModule.CreateDialogue({
			Content = {
				InitialLayer = "Layer0", -- Which layer to start the dialogue on
				DialogueTitle = "Dummy", -- The starting title of the Dialogue
				DialogueFrame = "CinematicSkin", -- Which DialogueFrame to use. Set to a custom one if you're using one. ("DialogueFrame" is the default.)
				ReplyFrame = "Reply", -- Which ReplyFrame to use if you're using a custom one. ("Reply" is the default.)

				Settings  = {
					Speaker = Prompt,
					
					Typewriter = true, -- Enable/Disable the typewriter. The typewriter writes every individual letter instead of displaying the text in full instantly.
					TypewriterSpeed = 0.001, -- How fast text is displayed on the typewriter.
					SpecialTypewriterSpeed = 0.5, -- How fast text is displayed for special characters. (. , ! ? ")
					TypewriterSound = script.Sound, -- Play Dialogue Sound
					TypeWriterSoundSpeed = 1.5,
					TypewriterTrimFactor = 3.5,

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

					DialogueCam = nil,

					StopDialogueOnDeath = true, -- If the players humanoid dies, the dialogue will stop.
					InteractWithDialogueWhendead = false -- Can the player start the dialogue when they are dead?
				},

				Layer0 = { -- This is the first layer.
					DialogueContent = {"Good fellow! Come hither and hurt me! Prithee, show me what you're made of, you witless laggard!", "That is... lest thou art a coward!"}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
					DialogueSounds = {}, -- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
					DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
					LayerTitle = "Dummy", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

					Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)

					},

					Exec = {
						
						light1 = {
							
							Function = activateLight,
							ExecuteContent = 1
							
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
	end
end)