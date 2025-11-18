local function checkstatus(ID)
    repeat task.wait() until workspace.Camera.BuildObjects:FindFirstChildOfClass("Model")
    return workspace.Camera.BuildObjects:FindFirstChildOfClass("Model").ID.Value ~= ID
end
local function e(ID)
local blockdef = require(game:GetService("ReplicatedStorage").ModuIes.BlockDef)
game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.Bindables.CategoryPressed:Fire(blockdef[ID].Category)
local button = game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.BuildMenu:FindFirstChild(tostring(ID),true)
firesignal(button.MouseButton1Click)
end
function _G.selectpreviewblock(BlockID)
  local ID = BlockID
  game:GetService("Players").LocalPlayer.PlayerGui.BuildGui.EnableBuilding:Fire()
  repeat
	task.wait()
    e(ID)
  until checkstatus(ID)
end
--_G.selectpreviewblock(BlockID)
