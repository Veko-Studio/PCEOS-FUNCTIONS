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
    task.wait(3)
end

--_G.placeblock(id,position,rotation)
--[[
--example1:
for x=1,5 do
    for y=1,3 do
        for z=1,5 do
            local id = 5
            local position = Vector3.new(x-26,y,z-26)
            local rotation = CFrame.Angles(math.deg(y*90),0,0)
            placeblock(id,position,rotation)
        end
    end
end
--example2:
_G.placeblock(16,Vector3.new(0,1,0),CFrame.Angles(0,0,0))
]]
