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
----
local blockdef = require(game:GetService("ReplicatedStorage").ModuIes.BlockDef)
----
local realmath = math
math = {}

-- Copy everything from the original math
for k, v in pairs(realmath) do
    math[k] = v
end
math.trunc = function(n)
    if n > 0 then
        return realmath.floor(n)
    else
        return realmath.ceil(n)
    end
end
----



function _G.placeblock(id,position,rotation,realcenter)
    local plotpos = PlotVecToGlobalVec(position,GetZone(game.Players.LocalPlayer))
    _G.selectpreviewblock(id)
    _G.positionpreviewblock(plotpos)
    _G.rotatepreviewblock(rotation)


    local model = workspace.Camera.BuildObjects:FindFirstChildOfClass("Model")
    if realcenter then
            local box = model:FindFirstChild("HitBox") or model:FindFirstChild("SelectionBoxPart")
            if box.Size ~= Vector3.new(2.6, 2.6, 2.6) then
                local g_offset_wrong = (blockdef[id].Offset)
                print("g_offset_wrong:",g_offset_wrong)
                local g_offset = Vector3.new(
                math.trunc(g_offset_wrong.X),
                math.trunc(g_offset_wrong.Y),
                math.trunc(g_offset_wrong.Z))*1.25--g_offset_wrong.X
                print("g_offset:",g_offset)
                local pivot = model:GetPivot()
                local rotonly = CFrame.new(Vector3.new(0, 0, 0)) * CFrame.fromMatrix(Vector3.new(), pivot:vectorToWorldSpace(Vector3.new(1,0,0)), pivot:vectorToWorldSpace(Vector3.new(0,1,0)), pivot:vectorToWorldSpace(Vector3.new(0,0,1)))
                local offset = (rotonly * CFrame.new(g_offset)).Position
                print("offset",offset)
                _G.pceos_mousepos = _G.pceos_mousepos-offset
            end
        end

    task.wait()
    _G.placepreviewblock(rotation)
    task.wait(0.1) --place block rate limit fix
    _G.positionpreviewblock(nil)
end

--_G.placeblock(id,position,rotation,realcenter)
--[[
--example1:
for x=1,5 do
    for y=1,3 do
        for z=1,5 do
            local id = 5
            local position = Vector3.new(x-26,y,z-26)
            local rotation = CFrame.Angles(math.deg(y*90),0,0)
            placeblock(id,position,rotation,false)
        end
    end
end
--example2:
_G.placeblock(16,Vector3.new(0,1,0),CFrame.Angles(0,0,0),true)
]]
