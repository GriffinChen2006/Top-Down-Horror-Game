local hunt = script.Parent.Parent.Animations:FindFirstChild("Hunt")
local npcHumanoid = script.Parent.Parent.Humanoid
local huntTrack = npcHumanoid:LoadAnimation(hunt)
local inChase = script.Parent

while true do
	if inChase.Value then
		if not huntTrack.IsPlaying then
			huntTrack:Play()
		end
	else
		huntTrack:Stop()
	end
	task.wait(0.01)
end