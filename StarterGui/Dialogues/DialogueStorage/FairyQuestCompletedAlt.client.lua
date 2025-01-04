-- // Test Dialogue // LocalScript
local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local camera = workspace.CurrentCamera
local event = replicatedStorage:WaitForChild("DialogueTriggered")
local giveItemEvent = replicatedStorage:WaitForChild("GiveItem")
local badgeGet = replicatedStorage:WaitForChild("BadgeGet")
local cleanseEvent = replicatedStorage:WaitForChild("Cleanse")

local Player = game:GetService('Players').LocalPlayer
local DialoguesModule = require(script.Parent.Parent.Main:WaitForChild("DialoguesModule")) -- References the DialoguesModule to run DialoguesModule.CreateDialogue
local Prompt = workspace:WaitForChild("Old Town"):WaitForChild("FairyDialogue") -- Reference the ProximityPrompt
local Fairy = workspace:WaitForChild("Old Town"):WaitForChild("Forest Fairy")
local cam = Fairy:WaitForChild("Cam")
local character = Player.Character

local light = workspace:WaitForChild("Old Town"):WaitForChild("Forest Fairy"):WaitForChild("Light"):WaitForChild("SurfaceLight")

local function cleanse()
	script.Cleansed:Play()
	cleanseEvent:FireServer()
end

local function giveBadge()
	badgeGet:FireServer(Player.UserId, 4209020399276363)
end

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

local function giveGrimoire()
	giveItemEvent:FireServer("Grimoire of Nature")
end

event.OnClientEvent:Connect(function(NPC)
	if NPC == "FairyQuestCompletedAlt" then
		
		local infoType = "LayerInfo"
		
		if character:WaitForChild("Soul").Value == 3 then
			infoType = "LayerInfoAlt"
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
					DialogueContent = {"...Why are you blue?"}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
					DialogueSounds = {}, -- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
					DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
					LayerTitle = "Forest Fairy", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

					Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)
						{
							ReplyName = "reply", -- This is the name of the reply button. It can be used to reference in Exec so you can run code when this button is clicked.
							ReplyText = "\"I found a radioactive crystal.\"", -- This is the text that will be displayed on your Reply Button.
							ReplyLayer = "Layer1" -- This is what Layer the player will be sent to if the player selects this reply.
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
					DialogueContent = {"That's... convenient for me, I was actually going to ask you to find that very same crystal. Let me fix you up real quick.", "There, back to normal.",
						"I feel obligated to give you something, so here, have this. That crystal was a real nuisance - the forest is in your debt."}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
					DialogueSounds = {}, -- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
					DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
					LayerTitle = "Forest Fairy", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

					Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)
						{
							ReplyName = "reply1", -- This is the name of the reply button. It can be used to reference in Exec so you can run code when this button is clicked.
							ReplyText = "\"What is this?\"", -- This is the text that will be displayed on your Reply Button.
							ReplyLayer = "LayerInfo" -- This is what Layer the player will be sent to if the player selects this reply.
						},
						{
							ReplyName = "reply2", -- This is the name of the reply button. It can be used to reference in Exec so you can run code when this button is clicked.
							ReplyText = "\"Thank you.\"", -- This is the text that will be displayed on your Reply Button.
							ReplyLayer = "LayerEnd" -- This is what Layer the player will be sent to if the player selects this reply.
						}
					},

					Exec = {
						cleanse1 = {
							Function = cleanse,
							ExecuteContent = 2
						},
						giveItem1 = {
							Function = giveGrimoire,
							ExecuteContent = 3
						},
						giveBadge1 = {
							Function = giveBadge,
							ExecuteContent = 3
						}
					}
				},
				
				LayerInfo = { -- This is the first layer.
					DialogueContent = {"It's a Grimoire of Nature, silly. The spell held within releases a healing mist - in case you have any friends to heal.", "You'll only be able to use it three times, then the book crumbles into dust."}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
					DialogueSounds = {}, -- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
					DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
					LayerTitle = "Forest Fairy", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

					Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)
						
					},

					Exec = {
						
					}
				},
				
				LayerInfoAlt = { -- This is the first layer.
					DialogueContent = {"Oh? I'm surprised you don't recognize it. It's a Grimoire of Nature. The spell held within releases a healing mist - in case you have any friends to heal.",
						"The average person could only use it three times, but I've seen your type. I'm sure you'll make it last longer."}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
					DialogueSounds = {}, -- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
					DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
					LayerTitle = "Forest Fairy", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

					Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)

					},

					Exec = {

					}
				},
				
				LayerEnd = { -- This is the first layer.
					DialogueContent = {"It's a fairy's nature to reward good deeds."}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
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