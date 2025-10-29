_G.originalRaycast = _G.originalRaycast or workspace.Raycast
local originalRaycast = _G.originalRaycast


local workspacemt
if getrawmetatable then workspacemt = getrawmetatable(workspace) end

---raycast overwrite setup
_G.pceos_mousepos = nil
if workspacemt then
    setreadonly(workspacemt, false)
    local oldIndex = workspacemt.__index
    workspacemt.__index = newcclosure(function(self, key)
        if self == workspace and key == "Raycast" then
            return function(selfArg, origin, direction, raycastParams)
                -- Handle colon-style calls
                if typeof(origin) ~= "Vector3" then
                    raycastParams = direction
                    direction = origin
                    origin = selfArg
                end

                -- Call the original raycast
                local result = originalRaycast(selfArg, origin, direction, raycastParams)
                if result then
                    -- Offset the hit position by +5 on the X axis
                    local Players = game:GetService("Players")
                    local plr = Players.LocalPlayer
                    local newPosition
                    if not workspace:FindFirstChild("PCEOS_MOUSE_OVEWRITE") then
                        local p = Instance.new("Part",workspace)
                        p.Size = Vector3.new(1,1,1)
                        p.Name = "PCEOS_MOUSE_OVEWRITE"
                        p.CanCollide = false
                        p.CanTouch = false
                        p.CanQuery = false
                        p.Transparency = 0.5
                        p.Anchored = true
                        p.Color = Color3.new(1,0,0)
                    end
                    if _G.pceos_mousepos then
                        newPosition = _G.pceos_mousepos-Vector3.new(0,2.5,0)
                        newnormal = Vector3.new(0, 0, 0)
                        workspace:FindFirstChild("PCEOS_MOUSE_OVEWRITE").Position = _G.pceos_mousepos
                    end
                    -- Return a modified RaycastResult
                    print(result.Normal)
                    return {
                        Instance = result.Instance,
                        Position = newPosition or result.Position,
                        Normal = newnormal or result.Normal,
                        Material = result.Material,
                    }
                end

                return nil
            end
        end
        return oldIndex(self, key)
    end)
    setreadonly(workspacemt, true)
end
function _G.positionpreviewblock(pos)
    _G.pceos_mousepos = pos
end
--_G.positionpreviewblock(pos)
--set to nil to disable the overwrite
