--wheels------------------------suffer from the motor6d issue (unfixable at the moment)
--control panels----------------suffer from the motor6d issue (unfixable at the moment)
--NO TESTING WAS DONE FOR BLOCKS YOU CAN ONLY GET FROM EVENTS ETC
local deweldblacklist = {
	--HingeBlock = true,
	--ControlSurface1x2 = true,
}
local reweldwhitelist = {
	PilotSeat = true,
	PilotSeatExtra = true,
	Seat = true,
	ControlSurface1x1 = true,
	ControlSurface1x2 = true,
	Wheel = true,
	WaterPropeller = true,
	WaterPropeller2 = true,
	DisconnectBlock = true,
	Gyro = true,
	Rocket = true,
	HingeBlock = true,
	GearSmall = true,
	BallJoint = true,
	SmokeEmitter = true,
	UniversalJoint = true,
	Horn = true,
	MicBlock = true,
	GearTiny = true,
	SmallJet = true,
	LargeJet = true,
	HugeJet = true,
	Propeller = true,
	SmallProp = true,
	GiantPropeller = true,
	OPRocketEngine = true,
	RocketEngine = true,
	WaterPropeller2 = true,
	HoverThruster = true,
}
local function findNonMainWelds(root: Instance)
    local e = {}
    for _, descendant in ipairs(root:GetDescendants()) do
        if (descendant:IsA("ManualWeld") or descendant:IsA("Weld") or descendant:IsA("Motor6D")) and descendant.Name ~= "MainWeld" then
            table.insert(e,{descendant.Part1,descendant.Part0,descendant.C0,descendant.C1,descendant.Name,descendant.Parent}) 
        end
    end
    return e
end
local function recreateWelds(weldPairs)
    for _, weldData in ipairs(weldPairs) do
        local part1, part2, c0, c1, name, parent = weldData[1], weldData[2], weldData[3], weldData[4], weldData[5], weldData[6]
		if part1 and part2 and c0 and c1 and name then
            local offset = c1*c0:Inverse()
            warn("recreating weld",parent:GetFullName().."."..name)
			if (parent.Name == "ControlSurface1x1" or parent.Name == "ControlSurface1x2" or parent.Name == "DeltaControlSurface1x2") and name == "Motor" then name = "Motor6D" end
            local args = {
                [1] = name,  -- Required
                [2] = parent,   -- A MotorBlock on your plot
                [3] = true,         -- Required flag
                [4] = part1,        -- Part 1
                [5] = part2,        -- Part 2
                [6] = offset,       -- Use C0 * C1^-1 for correct alignment
                [7] = true          -- Keep true
            }

            if true
			and not (name == "BallWeld"											and (parent.Name == "BallJoint"))
			and not (name == "SeatWeld"											and (parent.Name == "PilotSeat" or parent.Name == "PilotSeatExtra" or parent.Name == "Seat"))
			and not (name == "Motor"											and (parent.Name == "WaterPropeller2"))
			and not (name == "Motor" 											and (parent.Name == "Propeller" or parent.Name == "SmallProp" or parent.Name == "GiantPropeller")) 
			and not ((name == "RetractMotor" or name == "SteerMotor") 			and (parent.Name == "GearTiny" or parent.Name == "GearSmall"))
			then game.ReplicatedStorage.BlockRemotes.MotorLock:FireServer(unpack(args)) end
		else
			warn(part1,part2,c0,c1)
        end
    end
end


function _G.deweldblock(block1,block2)
	local success, result = pcall(function()
	for i=1,2 do
		if model1==model2 then return end
		if not (model1 and model2) then return end
		if not (model1:IsA("Model") and model2:IsA("Model")) then return end
		if model1.Parent ~= model2.Parent then return end
		if model1.Parent.Name ~= game.Players.LocalPlayer.Name .. " Aircraft" then return end
		if model1.Parent.Parent ~= workspace then return end
		if (model1.PrimaryPart.Position - model2.PrimaryPart.Position).Magnitude >= 8 then return end
		if model1:FindFirstChild("MainWeld", true) and not deweldblacklist[model1.Name] then
			print("1",model1:FindFirstChild("MainWeld", true):GetFullName())
			local e = findNonMainWelds(model1)
			game.ReplicatedStorage.Remotes.UnanchorWelds:FireServer(model1:FindFirstChild("MainWeld", true).Parent,"Break")
			repeat task.wait() until not model1:FindFirstChild("MainWeld", true)
			if reweldwhitelist[model1.Name] then recreateWelds(e) end
		end
		if model2:FindFirstChild("MainWeld", true) and not deweldblacklist[model2.Name] then
			print("2",model2:FindFirstChild("MainWeld", true):GetFullName())
			local e = findNonMainWelds(model2)
			game.ReplicatedStorage.Remotes.UnanchorWelds:FireServer(model2:FindFirstChild("MainWeld", true).Parent,"Break")
			repeat task.wait() until not model2:FindFirstChild("MainWeld", true)
			if reweldwhitelist[model2.Name] then recreateWelds(e) end
		end
	end
	end)
	print(success and "" or result)
end
--_G.deweldblock(block1,block2)
