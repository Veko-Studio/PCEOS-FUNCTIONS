local function checkstatus(ID)
    repeat task.wait() until workspace.Camera.BuildObjects:FindFirstChildOfClass("Model")
    return workspace.Camera.BuildObjects:FindFirstChildOfClass("Model").ID.Value ~= ID
end
local function setblock(id)
	game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.Bindables.BlockSelected:Fire(id)
end
local function setblock2(id)
	game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.Bindables.BlockSelected2:Fire(id)
end

function _G.selectpreviewblock(BlockID)
  local ID = BlockID
  game:GetService("Players").LocalPlayer.PlayerGui.BuildGui.EnableBuilding:Fire()
  if checkstatus(ID) then setblock(ID) end
  if checkstatus(ID) then setblock2(ID) end
end
--_G.selectpreviewblock(BlockID)
