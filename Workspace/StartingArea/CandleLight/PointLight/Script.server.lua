local inc = 100
local dec = 100
while true do
	local flip = math.random(0,1)
	if flip == 0 then
		if inc > 0 then
			inc -= 1
			script.Parent.Brightness += 0.1
			script.Parent.Range += 0.02
		end
	else
		if dec > 0 then
			dec -= 1
			script.Parent.Brightness -= 0.1
			script.Parent.Range -= 0.02
		end
	end
	if inc == 0 and dec == 0 then
		inc = 100
		dec = 100
	end
	wait(0.01)
end