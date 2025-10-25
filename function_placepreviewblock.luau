local lastclick = tick()
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end -- ignore if UI or game already used it

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		lastclick = tick()
	end
end)

local function clicksteps()
	repeat task.wait() until isrbxactive()
	---
	repeat
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		task.wait()
		repeat task.wait() until isrbxactive()
		mouse1click()
	until tick()-lastclick < 1
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

function _G.placepreviewblock()
	local screenguis = {}
	for _, des in game.Players.LocalPlayer.PlayerGui:GetDescendants() do
		if des:IsA("ScreenGui") then table.insert(screenguis,{des,des.Enabled}) end
	end
	repeat task.wait() until game:FindFirstChild("CoreGui")
	for _, des in game.CoreGui:GetDescendants() do
		if des:IsA("ScreenGui") then table.insert(screenguis,{des,des.Enabled}) end
	end

	for _, gui in screenguis do
		gui[1].Enabled = false
	end

	clicksteps()

	for _, gui in screenguis do
		gui[1].Enabled = gui[2]
	end
end
--_G.placepreviewblock()
