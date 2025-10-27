--values 
local envbuild = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.BuildGui:FindFirstChild("BuildObjects",true).Parent)
--helper functions
local function numround(numb)
    return math.round(numb / 90)
end
local function checkcorrect(preview, targetCFrame)
    local previewCFrame = preview.PrimaryPart.CFrame

    -- Compute the rotational difference CFrame
    local delta = previewCFrame:ToObjectSpace(targetCFrame)

    -- Extract axis-angle from delta
    local _, _, _, m00, m01, m02, m10, m11, m12, m20, m21, m22 = delta:GetComponents()

    -- Calculate the angle between orientations using trace of rotation matrix
    local trace = m00 + m11 + m22
    local angle = math.acos(math.clamp((trace - 1) / 2, -1, 1))

    local tolerance = math.rad(1)
    return angle <= tolerance
end
--function itself
function _G.rotatepreviewblock(cframe)
    ---getting the preview and checking if it exists
    local preview = workspace.Camera.BuildObjects:FindFirstChildOfClass("Model")
    if not preview then return end
    ---main code
    for i=1,7 do --loop since it needs to run twice to get to the correct rotation for some reason
        if checkcorrect(preview,cframe) then return end
        ---getting preview rotation
        local previewpivot = preview.PrimaryPart.CFrame * cframe:Inverse() --adding cframe offset so that it goes to the needed rotation instead of 0 0 0
        local preview_rot_x,preview_rot_y,preview_rot_z = previewpivot:ToOrientation()
        local preview_rot = Vector3.new(math.deg(preview_rot_x), math.deg(preview_rot_y), math.deg(preview_rot_z))
        ---reformating it into info ususable for the presses
        local preview_rot_rounded_flipped = Vector3.new(numround(-preview_rot.X),numround(-preview_rot.Y),numround(-preview_rot.Z))
        local preview_rot_result = Vector3.new(
            math.abs(preview_rot_rounded_flipped.X) * 3,
            math.abs(preview_rot_rounded_flipped.Y) * 3,
            math.abs(preview_rot_rounded_flipped.Z) * 3
        )
        ---removing tweens
        _G.origtween = _G.origtween or envbuild.TweenModelCFrame
        envbuild.TweenModelCFrame = function(...) end
        ---applying the presses
        local buttons = game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.Utilitybar2.Utilitybar2.BuildButtons
        for i=1,preview_rot_result.X do
                envbuild.RotateBlock(buttons.T, "X")
        end
        for i=1,preview_rot_result.Y do
            envbuild.RotateBlock(buttons.R, "Y")
        end
        for i=1,preview_rot_result.Z do
                envbuild.RotateBlock(buttons:FindFirstChild("Y") or buttons.Z, "Z")
        end
        task.wait()
    end
    --adding tweens
    envbuild.TweenModelCFrame = _G.origtween
end
--_G.rotatepreviewblock(cframe)
