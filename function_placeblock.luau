loadstring(game:HttpGet("https://raw.githubusercontent.com/Veko-Studio/PCEOS-FUNCTIONS/main/function_rotatepreviewblock.luau"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Veko-Studio/PCEOS-FUNCTIONS/main/function_selectpreviewblock.luau"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Veko-Studio/PCEOS-FUNCTIONS/main/function_positionpreviewblock.luau"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Veko-Studio/PCEOS-FUNCTIONS/main/function_placepreviewblock.luau"))()
local function PlotVecToGlobalVec(plotvec:Vector3,zone)
    local vec1 = zone.Position + Vector3.new(plotvec.X*2.5,(plotvec.Y+0.4)*2.5,plotvec.Z*2.5)
    return vec1
end
local function GetZone(player)
    local zone
    for _, zonei in workspace.BuildingZones:GetChildren() do
        if zonei.Owner.Value == player then zone = zonei end
    end
    return zone
end

function _G.placeblock(id,position,rotation)
    local plotpos = PlotVecToGlobalVec(position,GetZone(game.Players.LocalPlayer))
    _G.selectpreviewblock(id)
    _G.rotatepreviewblock(rotation)
    _G.positionpreviewblock(plotpos)
    _G.placepreviewblock()
    task.wait(0.1) --place block rate limit fix
    _G.positionpreviewblock(nil)
end

--_G.placeblock(id,position,rotation)
