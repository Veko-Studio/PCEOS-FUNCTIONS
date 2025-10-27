_G.placeblock = nil
loadstring(game:HttpGet("https://raw.githubusercontent.com/Veko-Studio/PCEOS-FUNCTIONS/main/function_rotatepreviewblock.luau"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Veko-Studio/PCEOS-FUNCTIONS/main/function_selectpreviewblock.luau"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Veko-Studio/PCEOS-FUNCTIONS/main/function_positionpreviewblock.luau"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Veko-Studio/PCEOS-FUNCTIONS/main/function_placepreviewblock.luau"))()
local blockdef = require(game:GetService("ReplicatedStorage").ModuIes.BlockDef)
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
local function math_trunc(x)
    if x > 0 then
        return math.floor(x)
    else
        return math.ceil(x)
    end
end
local function showshortpreview(pos,color)
    local p = Instance.new("Part",workspace)
    p.Size = Vector3.new(1,1,1)
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.Transparency = 0.5
    p.Anchored = true
    p.Color = color
    p.Position = pos
    task.spawn(function()
        task.wait(15)
        p:Destroy()
    end)
end

function _G.placeblock(id,position,rotation,forcecenter)
    _G.selectpreviewblock(id)
    _G.rotatepreviewblock(rotation)
    task.wait()


    local model = workspace.Camera.BuildObjects:FindFirstChildOfClass("Model")
    local box = model:FindFirstChild("HitBox") or model:FindFirstChild("SelectionBoxPart")
    local boxvec = Vector3.new(2.55, 2, 2.55)
    local plotpos = position
    if box.Size.X <= boxvec.X and box.Size.Y <= boxvec.Y  and box.Size.Z <= boxvec.Z then
        plotpos = Vector3.new(math.round(position.X),math.round(position.Y+0.1),math.round(position.Z))
    end
    showshortpreview(PlotVecToGlobalVec(
    plotpos,
    GetZone(game.Players.LocalPlayer)),
    Color3.fromRGB(0,255,0))
    plotpos = PlotVecToGlobalVec(plotpos,GetZone(game.Players.LocalPlayer))

    _G.positionpreviewblock(plotpos)
    task.wait()

    if forcecenter then
        --if box.Size ~= boxvec then
            local g_offset_wrong = (blockdef[id].Offset)
            print("g_offset_wrong:",g_offset_wrong)
            local g_offset = Vector3.new(
            math_trunc(g_offset_wrong.X),
            math_trunc(g_offset_wrong.Y),
            math_trunc(g_offset_wrong.Z))*1.25--g_offset_wrong.X
            print("g_offset:",g_offset)
            local pivot = model:GetPivot()
            local rotonly = CFrame.new(Vector3.new(0, 0, 0)) * CFrame.fromMatrix(Vector3.new(), pivot:vectorToWorldSpace(Vector3.new(1,0,0)), pivot:vectorToWorldSpace(Vector3.new(0,1,0)), pivot:vectorToWorldSpace(Vector3.new(0,0,1)))
            local offset = (rotonly * CFrame.new(g_offset)).Position
            print("offset",offset)
            _G.positionpreviewblock(_G.pceos_mousepos-offset)
        --end
    end
    showshortpreview(_G.pceos_mousepos,Color3.fromRGB(255,204,0))
    task.wait(0.1) --place block rate limit fix
    _G.placepreviewblock()
    task.wait()
    _G.positionpreviewblock(nil)
end
--_G.placeblock(id,position,rotation,forcecenter)
--⚠🟨rotation gets buggy if you loadstring this at the moment🟨⚠
