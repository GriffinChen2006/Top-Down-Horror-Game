local rs = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local tool = script.Parent.Parent
local char = tool.Parent.Parent.Character
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local equippedAnim = tool.Equip
local raiseAnim = tool.Raise
local holdAnim = tool.RaiseHold
local swingAnim = tool.Swing
local animationTrack1 = humanoid:LoadAnimation(equippedAnim)
local animationTrack2 = humanoid:LoadAnimation(raiseAnim)
local animationTrack3 = humanoid:LoadAnimation(holdAnim)
local animationTrack4 = humanoid:LoadAnimation(swingAnim)
local hitbox = script.Parent.Parent.Hitbox
local action = script.Parent.Parent.Action
local canDmg = hitbox.Damage.CanDamage
local locked = char:WaitForChild("Locked")
local holdingDown = locked:WaitForChild("HoldingDown")
local weapon = holdingDown:WaitForChild("Weapon")

local forceStopped = false
local unequipExecuted = false

local hitSound = script.Parent.Hit
local baseHitVolume = hitSound.Volume
local rampedHitVolume = baseHitVolume
local maxHitVolume = baseHitVolume * 2

local swingSound = script.Parent.Swing
local baseSwingVolume = swingSound.Volume
local rampedSwingVolume = baseSwingVolume
local maxSwingVolume = baseSwingVolume * 2

local baseDmg = script.Parent.Parent.BaseDmg.Value
local maxDmg = script.Parent.Parent.MaxDmg.Value
local rampUpDuration = 2 -- Time over which the damage increases
local FADE_TIME = 0.1 -- Smooth transition time for animations
local cooldown = 5 -- Milliseconds

local plrCooldown = locked:WaitForChild("Cooldown")

local id = tool:WaitForChild("ID").Value

local dmg = baseDmg

local rampUpConnection
local endedConnection

local hitboxMove
local endedConnection
local endedConnection2
local clonedHitbox
local weld
local unequipped
local main

tool.Equipped:Connect(function()
	unequipExecuted = false
	forceStopped = true

	animationTrack1:Play(FADE_TIME)
	animationTrack2:Stop(FADE_TIME)
	animationTrack3:Stop(FADE_TIME)
	animationTrack4:Stop(FADE_TIME)
	
	weapon.Value = id

	forceStopped = false

	unequipped = tool.Unequipped:Connect(function()
		if not unequipExecuted then

			unequipExecuted = true
			forceStopped = true
			holdingDown.Value = false

			animationTrack1:Stop(FADE_TIME)
			animationTrack2:Stop(FADE_TIME)
			animationTrack3:Stop(FADE_TIME)
			animationTrack4:Stop(FADE_TIME)

			if rampUpConnection then
				rampUpConnection:Disconnect()
			end

			if endedConnection then
				endedConnection:Disconnect()
			end

			if hitboxMove then
				canDmg.Value = false
				plrCooldown.Value = cooldown
				clonedHitbox:Destroy()
				weld:Destroy()
				hitboxMove:Disconnect()
				endedConnection2:Disconnect()
			end

			if main then
				main:Disconnect()
			end

			action.Value = 0
			forceStopped = false

			unequipped:Disconnect()

			rampUpConnection = nil
			endedConnection = nil
			hitboxMove = nil
			endedConnection = nil
			endedConnection2 = nil
			unequipped = nil
			main = nil
		end
	end)
	main = action:GetPropertyChangedSignal("Value"):Connect(function()
		if action.Value == 0 then
			forceStopped = false
			hitSound.Volume = baseHitVolume
			swingSound.Volume = baseSwingVolume
			animationTrack1:Play(FADE_TIME)
			animationTrack4:Stop(FADE_TIME)
		elseif action.Value == 1 then
			if not animationTrack4.isPlaying then
				animationTrack2:Play(FADE_TIME)
				animationTrack1:Stop(FADE_TIME)

				local startTime = tick()

				rampUpConnection = runService.Heartbeat:Connect(function()
					local elapsedTime = tick() - startTime
					if elapsedTime > rampUpDuration or forceStopped then
						dmg = maxDmg
						if rampUpConnection then
							rampUpConnection:Disconnect()
						end
						return
					end
					-- Calculate damage based on elapsed time
					dmg = baseDmg + ((maxDmg - baseDmg) * (elapsedTime / rampUpDuration))
					rampedHitVolume = baseHitVolume + ((maxHitVolume - baseHitVolume) * (elapsedTime / rampUpDuration))
					rampedSwingVolume = baseSwingVolume + ((maxSwingVolume - baseSwingVolume) * (elapsedTime / rampUpDuration))
				end)

				endedConnection = animationTrack2.Stopped:Connect(function()
					if not forceStopped then
						action.Value = 2
					end
					if endedConnection then
						endedConnection:Disconnect()
					end
				end)
			end
		elseif action.Value == 2 then
			animationTrack3:Play(FADE_TIME)
		else
			forceStopped = true
			swingSound.Volume = rampedSwingVolume

			swingSound:Play()
			animationTrack4:Play(FADE_TIME)
			animationTrack2:Stop(FADE_TIME)
			animationTrack3:Stop(FADE_TIME)

			canDmg.Value = true
			hitSound.Volume = rampedHitVolume

			-- Clone the hitbox
			clonedHitbox = hitbox:Clone()
			clonedHitbox.Parent = hitbox.Parent -- Add the cloned hitbox to the game world
			clonedHitbox.CFrame = hrp.CFrame -- Start at the same position as the player's HRP
			clonedHitbox.Anchored = false
			clonedHitbox.Damage.Damage.Value = dmg

			-- Create a Weld for the cloned hitbox
			weld = Instance.new("Weld")
			weld.Part0 = hrp -- Attach to the player's HumanoidRootPart
			weld.Part1 = clonedHitbox -- Attach to the cloned hitbox
			weld.C0 = CFrame.new(0, 0, 0) -- Initial offset
			weld.Parent = clonedHitbox

			local forwardOffset = 0
			local speed = 20 -- Rate of forward movement per second

			hitboxMove = runService.Heartbeat:Connect(function(deltaTime)
				-- Update forwardOffset using deltaTime
				forwardOffset -= speed * deltaTime

				-- Update the weld's offset to move the cloned hitbox forward
				weld.C0 = CFrame.new(0, 0, forwardOffset)
			end)

			endedConnection2 = animationTrack4.Stopped:Connect(function()
				canDmg.Value = false
				action.Value = 0
				plrCooldown.Value = cooldown
				-- Cleanup
				if hitboxMove then
					hitboxMove:Disconnect()
					endedConnection2:Disconnect()
				end
				clonedHitbox:Destroy()
				weld:Destroy()
			end)
		end
	end)
end)