--[[
  @ CW TAKT 
  @ D 12/16/23
]]

---- Service definitions
local RunService = game:GetService("RunService")

---- Array definitions
local StunUtility = { }
StunUtility.Stuns = { }

--[[
  Heartbeat Function: Deducts Stun's lengths
  by one each second until the status is off.
]]
local function Heartbeat(DeltaTime: Number)
	for String: String, Array: Array in pairs(StunUtility.Stuns) do
		for String: String, Content: Any in pairs(Array) do
			if Content.Length > 0 and tick() - Content.LastSecond >= 1 then
				Content.LastSecond = tick()
				Content.Length -= 1
			end
			
			if Content.Length > 0 then
				Content.Humanoid.WalkSpeed = Content.WalkSpeed
				Content.Humanoid.JumpHeight = Content.JumpHeight
			end
			
			if Content.Length <= 0 then
				Content.Humanoid.WalkSpeed = 16
				Content.Humanoid.JumpHeight = 7.2
			end
		end
	end
end

---- Connecting functions to events
RunService.Heartbeat:Connect(Heartbeat)

--[[
  SetStun Function: Sets a Stun to
  the Character with the key for the bigger
  Stun length.
]]
function StunUtility:SetStun(Character: Model, Key: String, Length: Number, WalkSpeed: Number, JumpHeight: Number)
	if not StunUtility.Stuns[Character.Name] then
		StunUtility.Stuns[Character.Name] = { }
		StunUtility.Stuns[Character.Name][Key] = { Humanoid = Character:WaitForChild("Humanoid"), Length = Length, LastSecond = tick(), WalkSpeed = WalkSpeed, JumpHeight = JumpHeight }
	end

	if not StunUtility.Stuns[Character.Name][Key] then
		StunUtility.Stuns[Character.Name][Key] = { Humanoid = Character:WaitForChild("Humanoid"), Length = Length, LastSecond = tick(), WalkSpeed = WalkSpeed, JumpHeight = JumpHeight }
	end

	StunUtility.Stuns[Character.Name][Key].Humanoid = Character:WaitForChild("Humanoid")

	---- Checking whatever value is bigger, it's stun's value(s) priority.
	if StunUtility.Stuns[Character.Name][Key].Length < Length then
		StunUtility.Stuns[Character.Name][Key].Length = Length
	end

	if StunUtility.Stuns[Character.Name][Key].WalkSpeed > WalkSpeed then
		StunUtility.Stuns[Character.Name][Key].WalkSpeed = WalkSpeed
	end

	if StunUtility.Stuns[Character.Name][Key].JumpHeight > JumpHeight then
		StunUtility.Stuns[Character.Name][Key].JumpHeight = JumpHeight
	end
	
	
	print('setstun')
	---- Resetting the LastSecond timer
	StunUtility.Stuns[Character.Name][Key].LastSecond = tick()
end


--[[
  RemoveStun Function: Delays parameter amount before
  setting key's length to zero, disabling it.
]]
function StunUtility:RemoveStun(Character: Model, Key: String, Defer: Number)
	Defer = Defer or 0

	if StunUtility[Character.Name] then
		if StunUtility[Character.Name][Key] then
			task.delay(Defer, function()
				StunUtility[Character.Name][Key].WalkSpeed = 16
				StunUtility[Character.Name][Key].JumpHeight = 7.2
				StunUtility[Character.Name][Key].Length = 0
			end)
		end
	end
end

--[[
  CheckStun Function: Checks if the Character has a on-going
  Stun matching the key string, then returns the status.
]]
function StunUtility:CheckStun(Character: Model, Key: String)
	if StunUtility.Stuns[Character.Name] then
		if StunUtility.Stuns[Character.Name][Key] and StunUtility.Stuns[Character.Name][Key].Length > 0 then
			return true
		end
	end

	---- Returning false if the conditions weren't fulfilled
	return false
end

---- Returning array for referencing
return StunUtility
