--values
local envbuild = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.BuildGui:FindFirstChild("BuildObjects",true).Parent)
--helper functions
local function numround(numb)
    return math.round(numb / 90)
end
local function angleDifference(a, b)
	local diff = math.abs(a - b) % (2 * math.pi)
	if diff > math.pi then
		diff = 2 * math.pi - diff
	end
	return diff
end
--function itself
function _G.rotatepreviewblock(cframe)
    ---getting the preview and checking if it exists
    local preview = workspace.Camera.BuildObjects:FindFirstChildOfClass("Model")
    if not preview then return end
	---already correct rot check
    local _, _, previewRot = preview.PrimaryPart.CFrame:ToOrientation()
    local _, _, targetRot = cframe:ToOrientation()
    local tolerance = math.rad(1)
    if false and angleDifference(previewRot, targetRot) <= tolerance then
    	return
    end
    ---main code
	local preview_rot_result
    repeat --loop since it needs to run a few times to get to the correct rotation for some reason
        ---getting preview rotation
        local previewpivot = preview.PrimaryPart.CFrame * cframe:Inverse() --adding cframe offset so that it goes to the needed rotation instead of 0 0 0
        local preview_rot_x,preview_rot_y,preview_rot_z = previewpivot:ToOrientation()
        local preview_rot = Vector3.new(math.deg(preview_rot_x), math.deg(preview_rot_y), math.deg(preview_rot_z))
        ---reformating it into info ususable for the presses
        local preview_rot_rounded_flipped = Vector3.new(numround(-preview_rot.X),numround(-preview_rot.Y),numround(-preview_rot.Z))
        preview_rot_result = Vector3.new(
            math.abs(preview_rot_rounded_flipped.X) * 3,
            math.abs(preview_rot_rounded_flipped.Y) * 3,
            math.abs(preview_rot_rounded_flipped.Z) * 3
        )
        ---applying the presses
        local buttons = game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.Utilitybar2.Utilitybar2.BuildButtons
        for i=1,preview_rot_result.X do
            task.spawn(function()
                envbuild.RotateBlock(buttons.T, "X")
            end)
        end
        for i=1,preview_rot_result.Y do
            task.spawn(function()
            	envbuild.RotateBlock(buttons.R, "Y")
            end)
        end
        for i=1,preview_rot_result.Z do
            task.spawn(function()
                envbuild.RotateBlock(buttons:FindFirstChild("Y") or buttons.Z, "Z")
        	end)
        end
		task.wait(0.25)
        --if preview_rot_result==Vector3.new(0,0,0) then return end
        --if i == 1 then task.wait(0.25) end --wait to let the tweens finish so the second run doesn't get the mid tween values
		until preview_rot_result==Vector3.new(0,0,0)
    end
end
--_G.rotatepreviewblock(cframe)
