-- // Test Dialogue // LocalScript
local badgeService = game:GetService("BadgeService")
local tweenService = game:GetService("TweenService")
local camera = workspace.CurrentCamera

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cam1 = workspace:WaitForChild("StartingArea"):WaitForChild("ClassSelection"):WaitForChild("Cam")
local cam2 = workspace:WaitForChild("StartingArea"):WaitForChild("ClassSelection"):WaitForChild("Cam2")
local cam3 = workspace:WaitForChild("StartingArea"):WaitForChild("ClassSelection"):WaitForChild("Cam3")
local light = workspace:WaitForChild("StartingArea"):WaitForChild("ClassSelection"):WaitForChild("DoorLight"):WaitForChild("SpotLight")
local smoke = workspace:WaitForChild("StartingArea"):WaitForChild("ClassSelection"):WaitForChild("OutsideLight"):WaitForChild("Smoke")
local door = workspace:WaitForChild("StartingArea"):WaitForChild("ClassSelection"):WaitForChild("Door")
local doorOpen = workspace:WaitForChild("StartingArea"):WaitForChild("ClassSelection"):WaitForChild("DoorOpen")
local loaded = workspace:WaitForChild("StartingArea"):WaitForChild("Midnight"):WaitForChild("Dialogue")
local badgeGet = ReplicatedStorage:WaitForChild("BadgeGet")

local Player = game:GetService('Players').LocalPlayer
local DialoguesModule = require(script.Parent.Parent.Main:WaitForChild("DialoguesModule")) -- References the DialoguesModule to run DialoguesModule.CreateDialogue
local Prompt = workspace:WaitForChild("StartingArea"):WaitForChild("ClassSelection") -- Reference the ProximityPrompt
local info1 = TweenInfo.new(1 --[[Change this to how long you want it to take. This is in seconds]], Enum.EasingStyle.Linear --[[Change this to your preferred EasingStyle]], Enum.EasingDirection.Out)
local info2 = TweenInfo.new(1 --[[Change this to how long you want it to take. This is in seconds]], Enum.EasingStyle.Linear --[[Change this to your preferred EasingStyle]], Enum.EasingDirection.Out)
local info3 = TweenInfo.new(3 --[[Change this to how long you want it to take. This is in seconds]], Enum.EasingStyle.Linear --[[Change this to your preferred EasingStyle]], Enum.EasingDirection.Out)
local fire = Player.Character:WaitForChild("HumanoidRootPart"):WaitForChild("Fire")
local character = Player.Character
local soulEvent = ReplicatedStorage:WaitForChild("SoulEvent")

local panToNPC = tweenService:Create(camera, info1, {CFrame = cam1.CFrame})
local panToPlayer = tweenService:Create(camera, info1, {CFrame = cam2.CFrame})
local panToDoor = tweenService:Create(camera, info2, {CFrame = cam3.CFrame})
local openDoor = tweenService:Create(door, info3, {CFrame = doorOpen.CFrame})

local midnight = workspace:WaitForChild("StartingArea"):WaitForChild("Midnight")

local stareCount = 0

local function stareAcc()
	stareCount += 1
	if stareCount > 5 then
		badgeGet:FireServer(Player.UserId, 3898695146981098)
	end
end

local function panCam1()
	panToPlayer:Play()
end

local function panCam2()
	panToNPC:Play()
end

local function panCam3()
	panToDoor:Play()
	panToDoor.Completed:Connect(function()
		light.Enabled = true
		light.Parent.lightSound:Play()
		smoke.Enabled = true
		wait(1.5)
		script.DoorCreak:Play()
		openDoor:Play()
	end)
end

local function skippedAll()
	local poof = Instance.new("Smoke")
	local poofScript = script.PoofScript:Clone()
	poof.Parent = character:FindFirstChild("HumanoidRootPart")
	poof.Size = 7.5
	poof.TimeScale = 2
	poof.RiseVelocity = 10
	poof.Opacity = 1
	poofScript.Parent = poof
	poofScript.Enabled = true
	fire:Destroy()
	script.Poof:Play()
	for _, v in pairs(character:GetDescendants()) do
		if (v:IsA("Part") or v:IsA("MeshPart")) and not (v.Name == "HumanoidRootPart" or v.Name == "Light Part") then
			v.Transparency = 0
		end
		if v:IsA("Decal") then
			v.Transparency = 0
		end
	end
	task.wait(3)
	light.Enabled = true
	light.Parent.lightSound:Play()
	smoke.Enabled = true
	task.wait(1.5)
	script.DoorCreak:Play()
	openDoor:Play()
end

local function makeVisible()
	local poof = Instance.new("Smoke")
	local poofScript = script.PoofScript:Clone()
	poof.Parent = character:FindFirstChild("HumanoidRootPart")
	poof.Size = 7.5
	poof.TimeScale = 2
	poof.RiseVelocity = 10
	poof.Opacity = 1
	poofScript.Parent = poof
	poofScript.Enabled = true
	fire:Destroy()
	script.Poof:Play()
	for _, v in pairs(character:GetDescendants()) do
		if v:IsA("BasePart") and not (v.Name == "HumanoidRootPart" or v.Name == "Light Part") then
			v.Transparency = 0
		end
		if v:IsA("Decal") then
			v.Transparency = 0
		end
	end
end

local function changeFireColor1()
	script.SoulTransform:Play()
	fire.Color = Color3.fromRGB(154,113,0)
	fire.SecondaryColor = Color3.fromRGB(255,255,0)
	soulEvent:FireServer(1)
end

local function changeFireColor2()
	script.SoulTransform:Play()
	fire.Color = Color3.fromRGB(0,94,47)
	fire.SecondaryColor = Color3.fromRGB(0,255,42)
	soulEvent:FireServer(2)
end

local function changeFireColor3()
	script.SoulTransform:Play()
	fire.Color = Color3.fromRGB(255,244,96)
	fire.SecondaryColor = Color3.fromRGB(255,255,255)
	soulEvent:FireServer(3)
end

local function changeFireColor4()
	script.SoulTransform:Play()
	fire.Color = Color3.fromRGB(49,0,2)
	fire.SecondaryColor = Color3.fromRGB(255,0,4)
	soulEvent:FireServer(4)
end

local function onLoaded()
	DialoguesModule.CreateDialogue({
		Content = {
			
			InitialLayer = "Layer0", -- Which layer to start the dialogue on
			DialogueTitle = "", -- The starting title of the Dialogue
			DialogueFrame = "CinematicSkin", -- Which DialogueFrame to use. Set to a custom one if you're using one. ("DialogueFrame" is the default.)
			ReplyFrame = "Reply", -- Which ReplyFrame to use if you're using a custom one. ("Reply" is the default.)

			Settings  = {
				Speaker = midnight,
				Typewriter = true, -- Enable/Disable the typewriter. The typewriter writes every individual letter instead of displaying the text in full instantly.
				TypewriterSpeed = 0.001,
				TypewriterVolume = 0.5,
				SpecialTypewriterSpeed = 0.5, -- How fast text is displayed for special characters. (. , ! ? ")
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
				DialogueContent = {"Hello there.", "I'm Midnight. Cool name, I know. What's yours?"}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
				DialogueSounds = {}, -- Put in a SoundId to play per piece of content. If you don't want a sound for a piece of content then just set it as nil. Do not format as "rbxassetid://000" and just use the Soundid.
				DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
				LayerTitle = "???", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

				Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)
					{
						ReplyName = "reply1", -- This is the name of the reply button. It can be used to reference in Exec so you can run code when this button is clicked.
						ReplyText = "\"My name is " .. tostring(Player.Name) .. ".\"", -- This is the text that will be displayed on your Reply Button.
						ReplyLayer = "Layer1Replied" -- This is what Layer the player will be sent to if the player selects this reply.
					},

					{
						ReplyName = "reply2", -- This is the name of the reply button.
						ReplyText = "Ignore her.", -- This is the text that will be displayed on your Reply Button.
						ReplyLayer = "Layer1Ignored" -- Since the Layer is nil, the dialogue will just end as nil is not a layer and is nothing.
					},
					
					{
						ReplyName = "replySkip",
						ReplyText = "(Skip to character select.)",
						ReplyLayer = "reselect"
					},
					
					{
						ReplyName = "skipAll",
						ReplyText = "(Skip everything for testing purposes.)",
						ReplyLayer = nil
					}
				},

				Exec = { -- This is where you can run code in your dialogue if you want any custom functions. (Quests, Animations, etc.)
					
					skip = {
						Function = panCam1,
						ExecuteContent = "replySkip"
					},
					
					skipAll1 = {
						Function = skippedAll,
						ExecuteContent = "skipAll"
					}
				}
			},

			Layer1Replied = { -- This is the first layer.
				DialogueContent = {"Nice to meet you " .. Player.Name .. ". Not a bad name at all.",
					"I'm a curator of sorts for this library.", "...Er, excuse me for that. I skipped lunch today.", "Say, you don't look like you have anything better to do.",
					"As you can see, I'm pretty busy, so I don't have time to run errands.",
					"Luckily, you're here.", "Why don't you go fetch me something to eat?"}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
				DialogueSounds = {nil, nil, "2184044761"},
				SoundVolumes = {nil, nil, 1},
				PlaybackPositions = {nil, nil, 0.35}, 
				DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
				LayerTitle = "Midnight", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

				Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)
					{
						ReplyName = "reply3", -- This is the name of the reply button. It can be used to reference in Exec so you can run code when this button is clicked.
						ReplyText = "\"Okay.\"", -- This is the text that will be displayed on your Reply Button.
						ReplyLayer = "Layer2" -- This is what Layer the player will be sent to if the player selects this reply.
					},

					{
						ReplyName = "reply4", -- This is the name of the reply button.
						ReplyText = "\"No way.\"", -- This is the text that will be displayed on your Reply Button.
						ReplyLayer = "Layer3" -- Since the Layer is nil, the dialogue will just end as nil is not a layer and is nothing.
					}
				},

				Exec = { -- This is where you can run code in your dialogue if you want any custom functions. (Quests, Animations, etc.)
				--[[
				
				func1 = { 
					Function = customFunction1, -- Set this to a function you have created. Do not leave the brackets at the end.
					ExecuteContent = "_<\>continuebutton\\", -- Set to a number or the name of a Reply. If set to 1, it will execute at the first piece of content on the dialogue.
				},
				
				]]--

				}
			},

			Layer1Ignored = { -- This is the first layer.
				DialogueContent = {"...Don't just stare at me.", "Fine, maybe social cues aren't your thing. Let's just go back to talking about me.",
					"I'm a curator of sorts for this library.", "...Er, excuse me for that. I skipped lunch today.", "Say, you don't look like you have anything better to do.",
					"As you can see, I'm pretty busy, so I don't have time to run errands.",
					"Luckily, you're here.", "Why don't you go fetch me something to eat?"}, -- This is what will be displayed on the Dialogue. Seperate content by commas.
				DialogueSounds = {nil, nil, nil, "2184044761"},
				SoundVolumes = {nil, nil, nil, 1},
				PlaybackPositions = {nil, nil, nil, 0.35},
				DialogueImage = "rbxassetid://13877485530", -- This is the image that will be displayed, you can probably use it as an icon of your NPC. Not all Dialogue Skins support this.
				LayerTitle = "Midnight", -- Set the text of your title again. This is the first layer so this isn't really needed, but you might want it for your 2nd layer.

				Replies = { -- This is a table of stuff the player can reply with to the Dialogue. They always appear at the last piece of content on the layer. ("Content2" in this case.)
					{
						ReplyName = "reply3", -- This is the name of the reply button. It can be used to reference in Exec so you can run code when this button is clicked.
						ReplyText = "Nod.", -- This is the text that will be displayed on your Reply Button.
						ReplyLayer = "Layer2" -- This is what Layer the player will be sent to if the player selects this reply.
					},

					{
						ReplyName = "goodbye4", -- This is the name of the reply button.
						ReplyText = "Ignore her.", -- This is the text that will be displayed on your Reply Button.
						ReplyLayer = "Layer3" -- Since the Layer is nil, the dialogue will just end as nil is not a layer and is nothing.
					}
				},

				Exec = { -- This is where you can run code in your dialogue if you want any custom functions. (Quests, Animations, etc.)
				--[[
				
				func1 = { 
					Function = customFunction1, -- Set this to a function you have created. Do not leave the brackets at the end.
					ExecuteContent = "_<\>continuebutton\\", -- Set to a number or the name of a Reply. If set to 1, it will execute at the first piece of content on the dialogue.
				},
				
				]]--

				}
			},


			Layer2 = { -- This is the second layer.
				DialogueContent = {"Great! I'm really feeling some sushi right now.", "Hmm... I know just the place. I'll send you right over.",
					"Ah, I almost forgot, we need to address your current state. You're certainly in no shape to get my sushi.", "Don't look so worried. You only need to answer a question for me and you'll be ready.",
					"What kind of soul do you have?"}, -- This is your next piece of content if the player selects Reply1
				DialogueSounds = {},
				DialogueImage = "rbxassetid://13877485530", -- You can change the image to display here.
				LayerTitle = "Midnight", -- You can change your Dialogue Title here. Keep as nil if you don't want it to change.

				Replies = {
					{
						ReplyName = "dominating",
						ReplyText = "\"A dominating one.\"",
						ReplyLayer = "dominatingInfo"
					},

					{
						ReplyName = "endless",
						ReplyText = "\"An endless one.\"",
						ReplyLayer = "endlessInfo"
					},

					{
						ReplyName = "enlightened",
						ReplyText = "\"An enlightened one.\"",
						ReplyLayer = "enlightenedInfo"
					},

					{
						ReplyName = "tormented",
						ReplyText = "\"A tormented one.\"",
						ReplyLayer = "tormentedInfo"
					}
				},

				Exec = {
					-- Exec is empty so you can add your own stuff to execute.
					panCamPlayer = {
						Function = panCam1,
						ExecuteContent = 3
					}
				}
			},

			Layer3 = { -- Rename LayerName to the name of your layer. It can be whatever you want as long as it isnt the same as something else!
				DialogueContent = {"Seriously?", "What else are you gonna do around here?", "(Sigh...) Suit yourself."},
				DialogueSounds = {},
				DialogueImage = "rbxassetid://000",
				LayerTitle = "Midnight",

				Replies = {
					{
						ReplyName = "reply1",
						ReplyText = "\"I've changed my mind\"",
						ReplyLayer = "Layer2"
					},

					{
						ReplyName = "reply4",
						ReplyText = "Stare at her.",
						ReplyLayer = "Layer4"
					}
				},

				Exec = {

				}
			},

			Layer4 = { -- Rename LayerName to the name of your layer. It can be whatever you want as long as it isnt the same as something else!
				DialogueContent = {"...", "Stop that."},
				DialogueSounds = {},
				DialogueImage = "rbxassetid://000",
				LayerTitle = "Midnight",

				Replies = {
					{
						ReplyName = "reply1",
						ReplyText = "\"I've changed my mind\"",
						ReplyLayer = "Layer2"
					},

					{
						ReplyName = "reply4",
						ReplyText = "Continue to stare at her.",
						ReplyLayer = "Layer4"
					}
				},

				Exec = {
					staring = {
						Function = stareAcc,
						ExecuteContent = "reply4"
					},
				}
			},

			dominatingInfo = { -- Rename LayerName to the name of your layer. It can be whatever you want as long as it isnt the same as something else!
				DialogueContent = {"A dominating soul, you are a natural leader, but you might often end up blind to self-criticism. People around you bend to your will.",
					"(Build up stun on enemies 100% faster when hitting them. Start with a spiked bat - a powerful weapon against minor enemies.)", "Do you believe this to be the reflection of your soul?"},
				DialogueSounds = {},
				DialogueImage = "rbxassetid://000",
				LayerTitle = "Midnight",

				Replies = {
					{
						ReplyName = "confirm",
						ReplyText = "\"Yes.\"",
						ReplyLayer = "Layer5"
					},
					{
						ReplyName = "return",
						ReplyText = "\"No.\"",
						ReplyLayer = "reselect"
					},
					{
						ReplyName = "skipRest",
						ReplyText = "Confirm and skip rest of her dialogue. (Testing)",
						ReplyLayer = nil
					}
				},

				Exec = {
					fireColor1 = {
						Function = changeFireColor1,
						ExecuteContent = 1
					},
					restoreAppearance = {
						Function = makeVisible,
						ExecuteContent = "confirm"
					},
					skipAll2 = {
						Function = skippedAll,
						ExecuteContent = "skipRest"
					}
				}
			},

			endlessInfo = { -- Rename LayerName to the name of your layer. It can be whatever you want as long as it isnt the same as something else!
				DialogueContent = {"An endless soul, you yearn for freedom. That yearning forces you to push your creativity to its limits.",
					"(Run and crouch faster and possess a lower detection factor. Start with one unseen pepper - a consumable that allows you to become undetectable for a short duration.)", "Do you believe this to be the reflection of your soul?"},
				DialogueSounds = {},
				DialogueImage = "rbxassetid://000",
				LayerTitle = "Midnight",

				Replies = {
					{
						ReplyName = "confirm",
						ReplyText = "\"Yes.\"",
						ReplyLayer = "Layer5"
					},
					{
						ReplyName = "return",
						ReplyText = "\"No.\"",
						ReplyLayer = "reselect"
					},
					{
						ReplyName = "skipRest",
						ReplyText = "Confirm and skip rest of her dialogue. (Testing)",
						ReplyLayer = nil
					}
				},

				Exec = {
					fireColor2 = {
						Function = changeFireColor2,
						ExecuteContent = 1
					},
					restoreAppearance = {
						Function = makeVisible,
						ExecuteContent = "confirm"
					},
					skipAll3 = {
						Function = skippedAll,
						ExecuteContent = "skipRest"
					}
				}
			},

			enlightenedInfo = { -- Rename LayerName to the name of your layer. It can be whatever you want as long as it isnt the same as something else!
				DialogueContent = {"An enlightened soul, you are always seeking restlessly for new knowledge and secrets hidden from the common folk. This cycle of learning and self-growth knows no end.",
					"(Consume half as many charges when using grimoires. Start with a radiant tome - a grimoire which can stun enemies and possesses two charges.)", "Do you believe this to be the reflection of your soul?"},
				DialogueSounds = {},
				DialogueImage = "rbxassetid://000",
				LayerTitle = "Midnight",

				Replies = {
					{
						ReplyName = "confirm",
						ReplyText = "\"Yes.\"",
						ReplyLayer = "Layer5"
					},
					{
						ReplyName = "return",
						ReplyText = "\"No.\"",
						ReplyLayer = "reselect"
					},
					{
						ReplyName = "skipRest",
						ReplyText = "Confirm and skip rest of her dialogue. (Testing)",
						ReplyLayer = nil
					}
				},

				Exec = {
					fireColor3 = {
						Function = changeFireColor3,
						ExecuteContent = 1
					},
					restoreAppearance = {
						Function = makeVisible,
						ExecuteContent = "confirm"
					},
					skipAll4 = {
						Function = skippedAll,
						ExecuteContent = "skipRest"
					}
				}
			},

			tormentedInfo = { -- Rename LayerName to the name of your layer. It can be whatever you want as long as it isnt the same as something else!
				DialogueContent = {"A tormented soul, you are destined to struggle in every step you take in life. Ultimately this makes you stronger physically and tempers your iron will that rivals the will of the gods themselves.",
					"(Gain more health and become immune to stuns. Start with a rusty shield - an activatable item capable of blocking up to 10 attacks.)", "Do you believe this to be the reflection of your soul?"},
				DialogueSounds = {},
				DialogueImage = "rbxassetid://000",
				LayerTitle = "Midnight",

				Replies = {
					{
						ReplyName = "confirm",
						ReplyText = "\"Yes.\"",
						ReplyLayer = "Layer5"
					},
					{
						ReplyName = "return",
						ReplyText = "\"No.\"",
						ReplyLayer = "reselect"
					},
					{
						ReplyName = "skipRest",
						ReplyText = "Confirm and skip rest of her dialogue. (Testing)",
						ReplyLayer = nil
					}
				},

				Exec = {
					fireColor4 = {
						Function = changeFireColor4,
						ExecuteContent = 1
					},
					restoreAppearance = {
						Function = makeVisible,
						ExecuteContent = "confirm"
					},
					skipAll5 = {
						Function = skippedAll,
						ExecuteContent = "skipRest"
					}
				}
			},

			reselect = { -- This is the second layer.
				DialogueContent = {"What kind of soul do you have?"},
				DialogueSounds = {},
				DialogueImage = "rbxassetid://13877485530", -- You can change the image to display here.
				LayerTitle = "Midnight", -- You can change your Dialogue Title here. Keep as nil if you don't want it to change.

				Replies = {
					{
						ReplyName = "dominating",
						ReplyText = "\"A dominating one.\"",
						ReplyLayer = "dominatingInfo"
					},

					{
						ReplyName = "endless",
						ReplyText = "\"An endless one.\"",
						ReplyLayer = "endlessInfo"
					},

					{
						ReplyName = "enlightened",
						ReplyText = "\"An enlightened one.\"",
						ReplyLayer = "enlightenedInfo"
					},

					{
						ReplyName = "tormented",
						ReplyText = "\"A tormented one.\"",
						ReplyLayer = "tormentedInfo"
					}
				},

				Exec = {
					-- Exec is empty so you can add your own stuff to execute.
					panCamPlayer = {
						Function = panCam1,
						ExecuteContent = 3
					}
				}
			},

			Layer5 = { -- Rename LayerName to the name of your layer. It can be whatever you want as long as it isnt the same as something else!
				DialogueContent = {"There you go, already looking much better.", "Now, you must be wondering where exactly I'm sending you off to.",
					"The place is a factory run by an eccentric food baron with a super silly name - Wonka or something.",
					"Not many people have names around here anymore. It's a privilege, and he does that with his...",
					"(Sigh.) If it wasn’t already obvious, I find him quite distasteful.",
					"Regretfully, he does have one redeeming factor - he produces some exceptional sushi.",
					"Of course, the greedy bastard that he is - he isn't very insistent on sharing, so you'll have to go up through his entire factory to his office and take it from him.",
					"I can't give you all the details - I've never actually been inside myself - but I'm sure with your fresh new body you can figure it out.", "It's right through the door over there.",
					"Good luck.", "Oh, and get back quickly - I'm starving."},
				DialogueSounds = {},
				SoundVolumes = {},
				DialogueImage = "rbxassetid://000",
				LayerTitle = "Midnight",

				Replies = {

				},

				Exec = {
					panBack = {
						Function = panCam2,
						ExecuteContent = 2
					},
					panDoor = {
						Function = panCam3,
						ExecuteContent = 9
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

loaded.Event:Connect(onLoaded)