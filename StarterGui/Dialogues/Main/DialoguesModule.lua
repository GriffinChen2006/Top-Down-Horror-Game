-- // DialoguesModule // ModuleScript

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local enter = ReplicatedStorage:WaitForChild("EnterDialogue")
local exit = ReplicatedStorage:WaitForChild("ExitDialogue")

local dialogues = {}
local ticktock = 0

local baseTime = 0.1 -- Time for a small turn
local maxTime = 0.5 -- Max time for a 180-degree turn

local DefaultDialogueFrame = script.Parent.Parent.DialogueFrame
local DefaultDialogueText = DefaultDialogueFrame.DialogueText.DialogueTextLabel
local DefaultContinueButton = DefaultDialogueFrame.ContinueButton.ContinueButton
local DefaultDialogueTitle = DefaultDialogueFrame.DialogueTitle.DialogueTitleText
local DefaultDialogueReplies = DefaultDialogueFrame.DialogueReplies
local DefaultDialogueIcon = DefaultDialogueFrame:FindFirstChild("DialogueIcon")

local DialogueFrame = DefaultDialogueFrame
local DialogueText = DefaultDialogueText
local ContinueButton = DefaultContinueButton
local DialogueTitle = DefaultDialogueTitle
local DialogueReplies = DefaultDialogueReplies
local DialogueIcon = DefaultDialogueIcon

local CinematicBar1 = DialogueFrame.Parent:FindFirstChild("CinematicBar1")
local CinematicBar2 = DialogueFrame.Parent:FindFirstChild("CinematicBar2")
local TypewriterSound = script.Parent:FindFirstChild("TypewriterSound")
local BackgroundSound = script.Parent:FindFirstChild("BackgroundSound")
local ContentSound = script.Parent:FindFirstChild("ContentSound")
local anchorPlayer = ReplicatedStorage:WaitForChild("AnchorPlayer")

local DefaultReplyFrame = script.Reply
local ReplyFrame = DefaultReplyFrame

local currentDialogue = nil
local currentLayer = nil
local dialogueIndex = 1
local typewriterCoroutine = nil
local isTyping = false
local dialogueActive = false
local autoScrollCoroutine = nil
local stopAutoScroll = false

local MainTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local initialUIStrokeTransparency = {}
local originalWalkSpeed = nil -- We will set this when the dialogue starts

local ContinueButtonConnection = nil
local humanoidDiedConnection = nil -- Connection for Humanoid.Died event
local characterAddedConnection = nil -- Connection for CharacterAdded event

local function storeInitialUIStrokeTransparency(elements)
	initialUIStrokeTransparency = {}
	for _, element in ipairs(elements) do
		local uiStroke = element:FindFirstChildOfClass("UIStroke")
		if uiStroke then
			initialUIStrokeTransparency[element] = uiStroke.Transparency
		end
	end
end

local elements = {
	DialogueFrame.ContinueButton,
	DialogueFrame.DialogueText,
	DialogueFrame.DialogueIcon,
	DialogueFrame.DialogueTitle,
}

storeInitialUIStrokeTransparency(elements)

function disableReplyButtons()
	for _, descendant in ipairs(DialogueReplies:GetDescendants()) do
		if descendant:IsA("TextButton") then
			descendant.Visible = false
		end
	end
end

function executeLayerFunctions(contentIndex, replyName)
	if currentLayer.Exec then
		for _, func in pairs(currentLayer.Exec) do
			if (replyName and func.ExecuteContent == replyName) or (not replyName and func.ExecuteContent == contentIndex) then
				if func.Function then
					func.Function()
				else
					warn("Function not defined for ExecuteContent:", func.ExecuteContent)
				end
			end
		end
	end
end

function dialogues.CreateReply(replyInfo)
	local replyClone = ReplyFrame:Clone()
	replyClone.Name = replyInfo.ReplyName or "ReplyClone"
	replyClone.TextLabel.Text = replyInfo.ReplyText
	replyClone.ReplyButton.MouseButton1Click:Connect(function()
		disableReplyButtons()

		-- Execute functions related to this reply before ending the dialogue if ReplyLayer is nil
		if not replyInfo.ReplyLayer then
			dialogues.EndDialogue() -- End dialogue first
		end

		executeLayerFunctions(nil, replyInfo.ReplyName)

		if replyInfo.ReplyLayer then
			currentLayer = currentDialogue[replyInfo.ReplyLayer]
			dialogueIndex = 1

			local tweenOutReplies = TweenService:Create(DialogueReplies, MainTweenInfo, {GroupTransparency = 1})
			tweenOutReplies:Play()
			tweenOutReplies.Completed:Connect(function()
				for _, child in ipairs(DialogueReplies:GetChildren()) do
					if child:IsA("Frame") then
						child:Destroy()
					end
				end
				dialogues.DisplayDialogue()
				if currentDialogue.Settings.Autoscroll > 0 then
					startAutoScroll()
				end
			end)
		else
			dialogues.EndDialogue()
		end
	end)
	return replyClone
end

function dialogues.DisplayReplies(replies)
	for _, reply in ipairs(replies) do
		local replyFrame = dialogues.CreateReply(reply)
		replyFrame.Parent = DialogueReplies
	end

	local tweenInReplies = TweenService:Create(DialogueReplies, MainTweenInfo, {GroupTransparency = 0})
	tweenInReplies:Play()

	if not currentDialogue.Settings.ContinueButtonVisibleDuringReply then
		tweenContinueButtonTransparency(1)
		ContinueButton.Visible = false
		ContinueButton.Active = false -- Make sure it's not clickable
	else
		tweenContinueButtonTransparency(0)
		ContinueButton.Visible = false
		ContinueButton.Active = false
	end

	stopAutoScroll = true
end

function playTypewriterSound()
	if TypewriterSound and currentDialogue.Settings.TypewriterSound then
		--TypewriterSound.SoundId = currentDialogue.Settings.TypewriterSound
		TypewriterSound.SoundId = currentDialogue.Settings.TypewriterSound.SoundId
		if currentDialogue.Settings.TypewriterVolume then
			TypewriterSound.Volume = currentDialogue.Settings.TypewriterVolume
		else
			TypewriterSound.Volume = 0.5
		end
		if currentDialogue.Settings.TypeWriterSoundSpeed then
			TypewriterSound.PlaybackSpeed = currentDialogue.Settings.TypeWriterSoundSpeed
		else
			TypewriterSound.PlaybackSpeed = 1
		end
		if not (TypewriterSound.Playing) or TypewriterSound.TimePosition >= TypewriterSound.TimeLength/currentDialogue.Settings.TypewriterTrimFactor then
			TypewriterSound:Play()
		end
	end
end

function playContentSound(index)
	if ContentSound and currentLayer.DialogueSounds and currentLayer.DialogueSounds[index] then
		local soundId = currentLayer.DialogueSounds[index]
		if currentLayer.SoundVolumes and currentLayer.SoundVolumes[index] then
			ContentSound.Volume = currentLayer.SoundVolumes[index]
		end
		if currentLayer.PlaybackPositions and currentLayer.PlaybackPositions[index] then
			ContentSound.TimePosition = currentLayer.PlaybackPositions[index]
		end
		if soundId then
			ContentSound.SoundId = "rbxassetid://" .. tostring(soundId)
			ContentSound:Play()
		end
	end
end

function updateDialogueIcon()
	if DialogueIcon and currentLayer.DialogueImage then
		DialogueIcon.ImageLabel.Image = currentLayer.DialogueImage
	end
end

function updateDialogueTitle()
	if currentLayer.LayerTitle then
		DialogueTitle.Text = currentLayer.LayerTitle
	else
		DialogueTitle.Text = currentDialogue.DialogueTitle
	end
end

function tweenContinueButtonTransparency(targetTransparency)
	local tween = TweenService:Create(ContinueButton.Parent, MainTweenInfo, {GroupTransparency = targetTransparency})
	tween:Play()
	local uiStroke = ContinueButton.Parent:FindFirstChildOfClass("UIStroke")
	if uiStroke then
		local initialTransparency = initialUIStrokeTransparency[ContinueButton.Parent] or 0
		local targetUIStrokeTransparency = targetTransparency == 1 and 1 or initialTransparency
		TweenService:Create(uiStroke, MainTweenInfo, {Transparency = targetUIStrokeTransparency}):Play()
	end
end

function dialogues.TypewriterEffect(text, typewriterSpeed, specialTypewriterSpeed)
	DialogueText.Text = ""
	isTyping = true
	for i = 1, #text do
		if not isTyping then
			DialogueText.Text = text
			break
		end
		DialogueText.Text = text:sub(1, i)
		local char = text:sub(i, i)
		local speed = typewriterSpeed
		if i < #text and char:match("[%.,:;%[%]{}!?-]") then
			speed = specialTypewriterSpeed	
		end
		playTypewriterSound()
		wait(speed)
	end
	isTyping = false

	local isLastPieceOfContent = not currentLayer.DialogueContent[dialogueIndex]

	if currentLayer.Replies and #currentLayer.Replies > 0 and isLastPieceOfContent then
		dialogues.DisplayReplies(currentLayer.Replies)
	end

	if currentDialogue.Settings.Typewriter and not currentDialogue.Settings.ContinueButtonVisibleDuringTypewriter then
		tweenContinueButtonTransparency(0)
		ContinueButton.Visible = true
		ContinueButton.Active = true -- Ensure it's clickable
	end

	if isLastPieceOfContent and currentLayer.Replies and #currentLayer.Replies > 0 then
		if not currentDialogue.Settings.ContinueButtonVisibleDuringReply then
			tweenContinueButtonTransparency(1)
			ContinueButton.Visible = false
			ContinueButton.Active = false
		else
			tweenContinueButtonTransparency(0)
			ContinueButton.Visible = false
			ContinueButton.Active = false
		end
	end

	if currentDialogue.Settings.Autoscroll > 0 and not currentLayer.Replies then
		startAutoScroll()
	end
end

function dialogues.DisplayDialogue()
	if currentLayer.DialogueContent[dialogueIndex] then
		local text = currentLayer.DialogueContent[dialogueIndex]
		playContentSound(dialogueIndex)
		dialogueIndex = dialogueIndex + 1

		updateDialogueIcon()

		updateDialogueTitle()

		executeLayerFunctions(dialogueIndex - 1)

		if typewriterCoroutine and coroutine.status(typewriterCoroutine) == "suspended" then
			coroutine.resume(typewriterCoroutine)
		end

		typewriterCoroutine = coroutine.create(function()
			if currentDialogue.Settings.Typewriter then
				dialogues.TypewriterEffect(text, currentDialogue.Settings.TypewriterSpeed, currentDialogue.Settings.SpecialTypewriterSpeed)
			else
				DialogueText.Text = text
				isTyping = false

				local isLastPieceOfContent = not currentLayer.DialogueContent[dialogueIndex]

				if isLastPieceOfContent and currentLayer.Replies and #currentLayer.Replies > 0 then
					if not currentDialogue.Settings.ContinueButtonVisibleDuringReply then
						tweenContinueButtonTransparency(1)
						ContinueButton.Visible = false
						ContinueButton.Active = false
					else
						tweenContinueButtonTransparency(0)
						ContinueButton.Visible = false
						ContinueButton.Active = false
					end
				else
					tweenContinueButtonTransparency(0)
					ContinueButton.Visible = true
					ContinueButton.Active = true
				end
			end
		end)
		coroutine.resume(typewriterCoroutine)

		if currentDialogue.Settings.Typewriter and not currentDialogue.Settings.ContinueButtonVisibleDuringTypewriter then
			tweenContinueButtonTransparency(1)
			ContinueButton.Visible = false
			ContinueButton.Active = false
		else
			ContinueButton.Active = true -- Ensure it's clickable
		end
	else
		if currentLayer.Replies and #currentLayer.Replies > 0 then
			dialogues.DisplayReplies(currentLayer.Replies)
			if not currentDialogue.Settings.ContinueButtonVisibleDuringReply then
				tweenContinueButtonTransparency(1)
				ContinueButton.Visible = false
				ContinueButton.Active = false
			else
				tweenContinueButtonTransparency(0)
				ContinueButton.Visible = false
				ContinueButton.Active = false
			end
		else
			dialogues.EndDialogue()
		end
	end
end

function dialogues.EndDialogue()
	disableReplyButtons()
	ContinueButton.Visible = false
	ContinueButton.Active = false
	
	stopAutoScroll = true
	
	executeLayerFunctions(nil, "executeAtEnd")
	
	exit:FireServer(player)

	local tweenOutFrame = TweenService:Create(DialogueFrame, MainTweenInfo, {Position = UDim2.new(0.5, 0, 0.6, 0)})
	local tweens = {}
	for _, element in ipairs(elements) do
		table.insert(tweens, TweenService:Create(element, MainTweenInfo, {GroupTransparency = 1}))
		local uiStroke = element:FindFirstChildOfClass("UIStroke")
		if uiStroke then
			table.insert(tweens, TweenService:Create(uiStroke, MainTweenInfo, {Transparency = 1}))
		end
	end
	table.insert(tweens, TweenService:Create(DialogueReplies, MainTweenInfo, {GroupTransparency = 1}))

	tweenOutFrame:Play()
	for _, tween in ipairs(tweens) do
		tween:Play()
	end

	if currentDialogue.Settings.CinematicBars then
		local tweenOutBar1 = TweenService:Create(CinematicBar1, MainTweenInfo, {Position = UDim2.new(0.5, 0, -0.2, 0)})
		local tweenOutBar2 = TweenService:Create(CinematicBar2, MainTweenInfo, {Position = UDim2.new(0.5, 0, 1.2, 0)})
		tweenOutBar1:Play()
		tweenOutBar2:Play()
	end

	if currentDialogue.Settings.BackgroundSound then
		local tweenOutBackgroundSound = TweenService:Create(BackgroundSound, MainTweenInfo, {Volume = 0})
		tweenOutBackgroundSound:Play()
		tweenOutBackgroundSound.Completed:Connect(function()
			BackgroundSound:Stop()
		end)
	end

	tweenOutFrame.Completed:Connect(function()
		DialogueText.Text = ""
		DialogueTitle.Text = ""
		DialogueFrame.Visible = false

		for _, element in ipairs(elements) do
			local uiStroke = element:FindFirstChildOfClass("UIStroke")
			if uiStroke and initialUIStrokeTransparency[element] then
				uiStroke.Transparency = initialUIStrokeTransparency[element]
			end
		end

		for _, child in ipairs(DialogueReplies:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end

		if currentDialogue.Settings.DialogueWalkSpeed ~= nil and player.Character then
			anchorPlayer:FireServer(false)
		end

		if currentDialogue.Settings.DisableBackpack then
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
		end
		if currentDialogue.Settings.DisableChat then
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
		end
		if currentDialogue.Settings.DisableLeaderboard then
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
		end

		if currentDialogue.Settings.DialogueCam then
			Camera.CameraType = Enum.CameraType.Scriptable
			player.Character:WaitForChild("Camera").Enabled = true
			player.Character:WaitForChild("Light Part").SpotLight.Enabled = true
			player.Character:WaitForChild("Light Part").SpotLight.LocalScript.Enabled = true
			if currentDialogue.Settings.DialogueLight then
				currentDialogue.Settings.DialogueLight.Enabled = false
			end
		end

		if humanoidDiedConnection then
			humanoidDiedConnection:Disconnect()
			humanoidDiedConnection = nil
		end

		if characterAddedConnection then
			characterAddedConnection:Disconnect()
			characterAddedConnection = nil
		end

		dialogueActive = false
	end)
end

local function connectContinueButton()
	if ContinueButtonConnection then
		ContinueButtonConnection:Disconnect()
	end
	ContinueButtonConnection = ContinueButton.MouseButton1Click:Connect(function()
		if isTyping then
			isTyping = false
		else
			stopAutoScroll = true
			dialogues.DisplayDialogue()
		end
	end)
end

function startAutoScroll()
	if autoScrollCoroutine then
		coroutine.close(autoScrollCoroutine)
	end
	stopAutoScroll = false
	autoScrollCoroutine = coroutine.create(function()
		while dialogueActive and not stopAutoScroll do
			wait(currentDialogue.Settings.Autoscroll)
			if dialogueActive and not isTyping and not stopAutoScroll then
				dialogues.DisplayDialogue()
			end
		end
	end)
	coroutine.resume(autoScrollCoroutine)
end

local function onCharacterAdded(character)
	if dialogueActive then
		if currentDialogue and currentDialogue.Settings.DialogueWalkSpeed ~= nil then
			local hrp = character:WaitForChild("HumanoidRootPart")
			local humanoid = character:WaitForChild("Humanoid")
			if hrp then
				anchorPlayer:FireServer(true)
				if currentDialogue.Settings.StopDialogueOnDeath then
					if humanoidDiedConnection then
						humanoidDiedConnection:Disconnect()
					end
					humanoidDiedConnection = humanoid.Died:Connect(function()
						dialogues.EndDialogue()
						anchorPlayer:FireServer(false) -- Reset WalkSpeed immediately if dialogue ends
					end)
				end
			end
		end
	else
		-- Do nothing; we don't want to reset originalWalkSpeed here
	end
end

-- Ensure WalkSpeed is reset correctly when dialogue ends or on respawn
player.CharacterAdded:Connect(onCharacterAdded)

function dialogues.CreateDialogue(dialogueInfo)
	
	enter:FireServer(player)
	
	if dialogueActive then return end

	-- Check if the player is allowed to interact with the dialogue while dead
	if not dialogueInfo.Content.Settings.InteractWithDialogueWhenDead then
		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health <= 0 then
			return -- Do not start dialogue if the player is dead
		end
	end

	dialogueActive = true

	currentDialogue = dialogueInfo.Content
	currentLayer = currentDialogue[dialogueInfo.Content.InitialLayer]
	DialogueTitle.Text = dialogueInfo.Content.DialogueTitle
	dialogueIndex = 1

	if currentDialogue.Settings.Speaker ~= nil then
		local hrp = player.Character:FindFirstChild("HumanoidRootPart")
		
		local Speaker = currentDialogue.Settings.Speaker
		
		local currentForward = hrp.CFrame.LookVector

		-- Get direction to the target part
		local targetDirection = (Speaker.PrimaryPart.Position - hrp.Position).Unit

		-- Calculate the angle (in radians)
		local angle = math.acos(currentForward:Dot(targetDirection))

		-- Convert angle to degrees (optional, for clarity)
		local angleDegrees = math.deg(angle)

		-- Set the tween time proportional to the angle
		local tweenTime = baseTime + (angle / math.pi) * (maxTime - baseTime)
		
		local turnSpeed = TweenInfo.new(tweenTime --[[Change this to how long you want it to take. This is in seconds]], Enum.EasingStyle.Linear --[[Change this to your preferred EasingStyle]], Enum.EasingDirection.Out)
		
		TweenService:Create(hrp, turnSpeed, {CFrame = (CFrame.lookAt(hrp.Position, Speaker.PrimaryPart.Position))}):Play()
	end

	if dialogueInfo.Content.DialogueFrame and script.Parent.Parent:FindFirstChild(dialogueInfo.Content.DialogueFrame) then
		DialogueFrame = script.Parent.Parent[dialogueInfo.Content.DialogueFrame]
		DialogueText = DialogueFrame.DialogueText.DialogueTextLabel
		ContinueButton = DialogueFrame.ContinueButton.ContinueButton
		DialogueTitle = DialogueFrame.DialogueTitle.DialogueTitleText
		DialogueReplies = DialogueFrame.DialogueReplies
		DialogueIcon = DialogueFrame:FindFirstChild("DialogueIcon")
		CinematicBar1 = DialogueFrame.Parent:FindFirstChild("CinematicBar1")
		CinematicBar2 = DialogueFrame.Parent:FindFirstChild("CinematicBar2")
	else
		DialogueFrame = DefaultDialogueFrame
		DialogueText = DefaultDialogueText
		ContinueButton = DefaultContinueButton
		DialogueTitle = DefaultDialogueTitle
		DialogueReplies = DefaultDialogueReplies
		DialogueIcon = DefaultDialogueIcon
	end

	if dialogueInfo.Content.ReplyFrame and script:FindFirstChild(dialogueInfo.Content.ReplyFrame) then
		ReplyFrame = script[dialogueInfo.Content.ReplyFrame]
	else
		ReplyFrame = DefaultReplyFrame
	end

	if ContinueButtonConnection then
		ContinueButtonConnection:Disconnect()
	end

	elements = {
		DialogueFrame.ContinueButton,
		DialogueFrame.DialogueText,
		DialogueFrame.DialogueIcon,
		DialogueFrame.DialogueTitle,
	}

	storeInitialUIStrokeTransparency(elements)

	for _, element in ipairs(elements) do
		element.GroupTransparency = 1
		local uiStroke = element:FindFirstChildOfClass("UIStroke")
		if uiStroke then
			uiStroke.Transparency = 1
		end
	end
	DialogueReplies.GroupTransparency = 1

	DialogueFrame.Position = UDim2.new(0.5, 0, 0.6, 0)
	DialogueFrame.Visible = true

	updateDialogueIcon()

	updateDialogueTitle()

	-- Store originalWalkSpeed once at the start of the dialogue
	if currentDialogue.Settings.DialogueWalkSpeed ~= nil and player.Character then
		anchorPlayer:FireServer(true)
	end

	local tweenInFrame = TweenService:Create(DialogueFrame, MainTweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)})
	local tweens = {}
	for _, element in ipairs(elements) do
		table.insert(tweens, TweenService:Create(element, MainTweenInfo, {GroupTransparency = 0}))
		local uiStroke = element:FindFirstChildOfClass("UIStroke")
		if uiStroke then
			local initialTransparency = initialUIStrokeTransparency[element] or 0
			table.insert(tweens, TweenService:Create(uiStroke, MainTweenInfo, {Transparency = initialTransparency}))
		end
	end

	tweenInFrame:Play()
	for _, tween in ipairs(tweens) do
		tween:Play()
	end

	if currentDialogue.Settings.CinematicBars then
		local tweenInBar1 = TweenService:Create(CinematicBar1, MainTweenInfo, {Position = UDim2.new(0.5, 0, 0, 0)})
		local tweenInBar2 = TweenService:Create(CinematicBar2, MainTweenInfo, {Position = UDim2.new(0.5, 0, 1, 0)})
		tweenInBar1:Play()
		tweenInBar2:Play()
	end

	if currentDialogue.Settings.BackgroundSound then
		BackgroundSound.SoundId = currentDialogue.Settings.BackgroundSound
		BackgroundSound.Volume = 0
		BackgroundSound:Play()
		local tweenInBackgroundSound = TweenService:Create(BackgroundSound, MainTweenInfo, {Volume = currentDialogue.Settings.BackgroundSoundVol})
		tweenInBackgroundSound:Play()
	end

	if currentDialogue.Settings.DialogueWalkSpeed ~= nil then
		characterAddedConnection = player.CharacterAdded:Connect(onCharacterAdded)
	end

	if currentDialogue.Settings.DisableBackpack then
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	end
	if currentDialogue.Settings.DisableChat then
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
	end
	if currentDialogue.Settings.DisableLeaderboard then
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	end

	if currentDialogue.Settings.DialogueCam then
		player.Character:WaitForChild("Camera").Enabled = false
		player.Character:WaitForChild("Light Part").SpotLight.Enabled = false
		player.Character:WaitForChild("Light Part").SpotLight.LocalScript.Enabled = false
		Camera.CameraType = Enum.CameraType.Scriptable
		Camera.CFrame = currentDialogue.Settings.DialogueCam.CFrame
		if currentDialogue.Settings.DialogueLight then
			currentDialogue.Settings.DialogueLight.Enabled = true
		end
	end

	dialogues.DisplayDialogue()

	connectContinueButton()

	if currentDialogue.Settings.Autoscroll > 0 then
		startAutoScroll()
	end
end

return dialogues
