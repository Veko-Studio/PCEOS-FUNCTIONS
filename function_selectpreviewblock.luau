local function setblock(id)
	game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.Bindables.BlockSelected:Fire(id)
end
local function setblock2(id)
	game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.Bindables.BlockSelected2:Fire(id)
end

_G.selectpreviewblock(BlockID)
  local ID = BlockID
  if checkstatus(ID) then setblock(ID) end
  if checkstatus(ID) then setblock2(ID) end
end
--_G.selectpreviewblock(BlockID)
