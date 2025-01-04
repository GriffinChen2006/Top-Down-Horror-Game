Figure = script.Parent

RunService = game:GetService("RunService")

Creator = Figure:FindFirstChild("Creator")

Humanoid = Figure:WaitForChild("Humanoid")
Head = Figure:WaitForChild("Head")
Torso = Figure:WaitForChild("Torso")

Neck = Torso:WaitForChild("Neck")
LeftHip = Torso:WaitForChild("Left Hip")
RightHip = Torso:WaitForChild("Right Hip")
RightShoulder = Torso:WaitForChild("Right Shoulder")
LeftShoulder = Torso:WaitForChild("Left Shoulder")

for i, v in pairs({LeftHip, RightHip, RightShoulder, LeftShoulder}) do
	if v and v.Parent then
		v.MaxVelocity = 0.1
		v.DesiredAngle = 0
		v.CurrentAngle = 0
	end
end

Pose = "None"
LastPose = Pose
PoseTime = tick()

function SetPose(pose)
	LastPose = Pose
	Pose = pose
	PoseTime = tick()
end

function OnRunning(Speed)
	if Speed > 0 then
		SetPose("Running")
	else
		SetPose("Standing")
	end
end

function OnDied()
	SetPose("Dead")
end

function OnJumping()
	SetPose("Jumping")
end

function OnClimbing()
	SetPose("Climbing")
end

function OnGettingUp()
	SetPose("GettingUp")
end

function OnFreeFall()
	SetPose("FreeFall")
end

function OnFallingDown()
	SetPose("FallingDown")
end

function OnSeated()
	SetPose("Seated")
end

function OnPlatformStanding()
	SetPose("PlatformStanding")
end

function OnSwimming(Speed)
	return OnRunning(Speed)
end

function MoveJump()
	LeftHip.DesiredAngle = 0.5
	RightHip.DesiredAngle = -0.5
	RightShoulder.DesiredAngle = 0.5
	LeftShoulder.DesiredAngle = -0.5
end

function MoveFreeFall()
	LeftHip.DesiredAngle = 0.5
	RightHip.DesiredAngle = -0.5
	RightShoulder.DesiredAngle = 0.5
	LeftShoulder.DesiredAngle = -0.5	
end

function MoveSit()
	RightHip.DesiredAngle = 0
	LeftHip.DesiredAngle = 0
	RightShoulder.DesiredAngle = 0
	LeftShoulder.DesiredAngle = 0	
end

function Move(Time)
	local LimbAmplitude
	local LimbFrequency
	local NeckAmplitude
	local NeckFrequency
	local NeckDesiredAngle
  
	if (Pose == "Jumping") then
		MoveJump()
		return
	elseif (Pose == "FreeFall") then
		MoveFreeFall()
		return
	elseif (Pose == "Seated") then
		MoveSit()
		return
	end

	local ClimbFudge = 0
	
	if (Pose == "Running") then
		LimbAmplitude = 1
		LimbFrequency = 9
		NeckAmplitude = 0
		NeckFrequency = 0
		NeckDesiredAngle = 0
		--[[if Creator and Creator.Value and Creator.Value:IsA("Player") and Creator.Value.Character then
			local CreatorCharacter = Creator.Value.Character
			local CreatorHead = CreatorCharacter:FindFirstChild("Head")
			if CreatorHead then
				local TargetPosition = CreatorHead.Position
				local Direction = Torso.CFrame.lookVector
				local HeadPosition = Head.Position
				NeckDesiredAngle = ((((HeadPosition - TargetPosition).Unit):Cross(Direction)).Y / 4)
			end
		end]]
	elseif (Pose == "Climbing") then
		LimbAmplitude = 1
		LimbFrequency = 9
		NeckAmplitude = 0
		NeckFrequency = 0
		NeckDesiredAngle = 0
		ClimbFudge = math.pi
	else
		LimbAmplitude = 0.1
		LimbFrequency = 1
		NeckAmplitude = 0.25
		NeckFrequency = 1.25
	end

	--local NeckDesiredAngle = ((not NeckDesiredAngle and (NeckAmplitude * math.sin(Time * NeckFrequency))) or NeckDesiredAngle)
	local LimbDesiredAngle = (LimbAmplitude * math.sin(Time * LimbFrequency))
	
	--Neck.DesiredAngle = NeckDesiredAngle
	RightHip.DesiredAngle = -LimbDesiredAngle
	LeftHip.DesiredAngle = -LimbDesiredAngle
	RightShoulder.DesiredAngle = LimbDesiredAngle
	LeftShoulder.DesiredAngle = LimbDesiredAngle	
	
end

Humanoid.Died:connect(OnDied)
Humanoid.Running:connect(OnRunning)
Humanoid.Jumping:connect(OnJumping)
Humanoid.Climbing:connect(OnClimbing)
Humanoid.GettingUp:connect(OnGettingUp)
Humanoid.FreeFalling:connect(OnFreeFall)
Humanoid.FallingDown:connect(OnFallingDown)
Humanoid.Seated:connect(OnSeated)
Humanoid.PlatformStanding:connect(OnPlatformStanding)
Humanoid.Swimming:connect(OnSwimming)

Humanoid:ChangeState(Enum.HumanoidStateType.None)

RunService.Stepped:connect(function()
	local _, Time = wait(0.1)
	Move(Time)
end)