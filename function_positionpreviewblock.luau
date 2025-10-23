---raycast overwrite setup for specific script
local pceos_mousepos = pceos_mousepos or nil

if workspacemt then
    setreadonly(workspacemt, false)
    local oldIndex = workspacemt.__index
    
    workspacemt.__index = newcclosure(function(self, key)
        if self == workspace and key == "Raycast" then
            return function(selfArg, origin, direction, raycastParams)
                -- Check if the calling script is the target script
                local callingScript = getcallingscript and getcallingscript()
                local shouldOverride = callingScript == game:GetService("Players").LocalPlayer.PlayerGui.BuildGui:FindFirstChild("BuildObjects",true).Parent
                
                -- Handle colon-style calls
                if typeof(origin) ~= "Vector3" then
                    raycastParams = direction
                    direction = origin
                    origin = selfArg
                end
                
                -- Call the original raycast
                local result = originalRaycast(selfArg, origin, direction, raycastParams)
                
                if result and shouldOverride then
                    local newPosition
                    
                    if not workspace:FindFirstChild("PCEOS_MOUSE_OVEWRITE") then
                        local p = Instance.new("Part", workspace)
                        p.Size = Vector3.new(1,1,1)
                        p.Name = "PCEOS_MOUSE_OVEWRITE"
                        p.CanCollide = false
                        p.CanTouch = false
                        p.CanQuery = false
                        p.Transparency = 0.5
                        p.Anchored = true
                        p.Color = Color3.new(1,0,0)
                    end
                    
                    if pceos_mousepos then
                        newPosition = pceos_mousepos - Vector3.new(0,2.5,0)
                        workspace:FindFirstChild("PCEOS_MOUSE_OVEWRITE").Position = pceos_mousepos
                    end
                    
                    return {
                        Instance = result.Instance,
                        Position = newPosition or result.Position,
                        Normal = result.Normal,
                        Material = result.Material,
                    }
                end
                
                return result
            end
        end
        return oldIndex(self, key)
    end)
    
    setreadonly(workspacemt, true)
end
_G.positionpreviewblock(world_vec)
    pceos_mousepos = world_vec
end
--_G.positionpreviewblock(world_vec)
--set to nil to disable
