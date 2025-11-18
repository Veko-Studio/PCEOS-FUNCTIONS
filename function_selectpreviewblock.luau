local function checkstatus(ID)
    repeat task.wait() until workspace.Camera.BuildObjects:FindFirstChildOfClass("Model")
    return workspace.Camera.BuildObjects:FindFirstChildOfClass("Model").ID.Value ~= ID
end
local function e(ID)
    local blockdef = require(game:GetService("ReplicatedStorage").ModuIes.BlockDef)
    game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.Bindables.CategoryPressed:Fire(blockdef[ID].Category)
    
    -- Keep retrying until button exists
    local button
    repeat
        button = game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.BuildMenu:FindFirstChild(tostring(ID), true)
        if not button then
            task.wait() -- Wait a short time before retrying
        end
    until button
    
    firesignal(button.MouseButton1Click)
end
function _G.selectpreviewblock(BlockID)
  local ID = BlockID
  game:GetService("Players").LocalPlayer.PlayerGui.BuildGui.EnableBuilding:Fire()
  e(ID)
  task.wait(0.1)
end
