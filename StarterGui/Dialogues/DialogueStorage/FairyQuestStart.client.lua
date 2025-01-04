-- // Test Dialogue // LocalScript
local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local camera = workspace.CurrentCamera
local event = replicatedStorage:WaitForChild("DialogueTriggered")
local giveItem = replicatedStorage:WaitForChild("GiveItem")
local badgeGet = replicatedStorage:WaitForChild("BadgeGet")

local Player = game:GetService('Players').LocalPlayer
local DialoguesModule = require(script.Parent.Parent.Main:WaitForChild("DialoguesModule")) -- References the DialoguesModule to run DialoguesModule.CreateDialogue
local Prompt = workspace:WaitForChild("Old Town"):WaitForChild("FairyDialogue") -- Reference the ProximityPrompt
local Fairy = workspace:WaitForChild("Old Town"):WaitForChild("Forest Fairy")
local cam = Fairy:WaitForChild("Cam")
local character = Player.Character

local light = workspace:WaitForChild("Old Town"):WaitForChild("Forest Fairy"):WaitForChild("Light"):WaitForChild("SurfaceLight")

local function appear()
	spawn(function()
		local poof = Instance.new("Smoke")
		poof.Parent = Fairy.Fairy.Body
		poof.Size = 7.5
		poof.TimeScale = 2
		poof.RiseVelocity = 10
		poof.Opacity = 1
		Fairy.log.Poof:Play()
		wait(0.5)
		while poof.Opacity > 0 do
			poof.Opacity -= 0.05
			wait(0.01)
		end
		poof.Enabled = false
		poof:Destroy()
	end)
	for i, obj in Fairy.Fairy:GetChildren() do
		obj.Transparency = 0
	end
end

local function giveWeapon()
	giveItem:FireServer("Big Metal Pipe")
end

event.OnClientEvent:Connect(function(NPC)
	if NPC == "FairyQuestStart" then
		
		local replyType = "Layer1"
		local give = "executeAtEnd"
		
		if character:WaitForChild("Soul").Value == 1 then
			replyType = "Layer1Alt"
			give = -1
		end
		
		DialoguesModule.CreateDialogue({
			Content = {
				InitialLayer = "Layer0", -- Which layer to start the dialogue on
				DialogueTitle = "Forest Fairy", -- The starting title of the Dialogue
				DialogueFrame = "CinematicSkin", -- Which DialogueFrame to use. Set to a custom one if you're using one. ("DialogueFrame" is the default.)
				ReplyFrame = "Reply", -- Which ReplyFrame to use if you're using a custom one. ("Reply" is the default.)

				Settings  = {
					Speaker = Fairy,
					
					Typewriter = true, -- Enable/Disable the typewriter. The typewriter writes every individual letter instead of displaying the text in full instantly.
					TypewriterSpeed = 0.001, -- How fast text is displayed on the typewriter.
					SpecialTypewriterSpeed = 0.5, -- How fast text is displayed for special characters. (. , ! ? ")
					TypewriterSound = script.Sound, -- Play Dialogue Sound
					TypeWriterSoundSpeed = 1.5,
					TypewriterTrimFactor = 6,

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

					DialogueCam = cam,

					StopDialogueOnDeath = true, -- If the players humanoid dies, the dialogue will stop.
					InteractWithDialogueWhendead = false -- Can the player start the dialogue when they are dead?
				},

				Layer0 = { -- This is the first layer.
					DialogueContent = {"You look pretty lost.", "Not a bad thing by any means. Lost means you aren't with Him.",
					"What brings you to these woods?"}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
					DialogueSounds = {}, -- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
					DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
					LayerTitle = "Forest Fairy", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

					Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)
						{
							ReplyName = "reply", -- This is the name of the reply button. It can be used to reference in Exec so you can run code when this button is clicked.
							ReplyText = "\"I'm going to Sushi.\"", -- This is the text that will be displayed on your Reply Button.
							ReplyLayer = replyType -- This is what Layer the player will be sent to if the player selects this reply.
						}
					},

					Exec = {
						appear1 = {
							Function = appear,
							ExecuteContent = 1
						}
					}
				},
				
				Layer1 = { -- This is the first layer.
					DialogueContent = {"Ah, so you're headed all the way to The Factory.", "Hardly worth it if you ask me. It's hell out there these days.",
						"No offence, but you don't look like the type of person to survive the trip either.", "You're definitely going to need my help. However, I'm hesitant to offer it.",
						"Although I am a generous fairy, my trust is in short stock these days.", "I want you to do a little something for me and earn that trust.",
						"The trees have been complaining about some nasty crystal The Factory dumped here a while ago.",
						"Go and smash it, then bring me back what's left so I can dispose of it properly.", "Oh, and take this - those tiny little hands aren't going to do much."}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
					DialogueSounds = {}, -- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
					DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
					LayerTitle = "Forest Fairy", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

					Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)
						
					},

					Exec = {
						giveWeapon1 = {
							Function = giveWeapon,
							ExecuteContent = give
						}
					}
				},
				
				Layer1Alt = { -- This is the first layer.
					DialogueContent = {"Ah, so you're headed all the way to The Factory.", "Hardly worth it if you ask me. It's hell out there these days.",
						"No offence, but you don't look like the type of person to survive the trip either.", "You're definitely going to need my help. However, I'm hesitant to offer it.",
						"Although I am a generous fairy, my trust is in short stock these days.", "I want you to do a little something for me and earn that trust.",
						"The trees have been complaining about some nasty crystal The Factory dumped here a while ago.",
						"Go and smash it, then bring me back what's left so I can dispose of it properly.", "I'm sure you can handle it with that thuggish weapon of yours."}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
					DialogueSounds = {}, -- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
					DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
					LayerTitle = "Forest Fairy", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

					Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)

					},

					Exec = {
						
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