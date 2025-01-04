local poof = script.Parent
wait(0.5)
while poof.Opacity > 0 do
	poof.Opacity -= 0.05
	wait(0.01)
end
poof:Destroy()