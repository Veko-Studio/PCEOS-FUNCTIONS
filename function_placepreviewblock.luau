-- Simple left click simulator for target script
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Global flag to control simulated click
_G.simulateLeftClick = false

-- Set your target script path here
local function getTargetScript()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end
    
    local buildGui = playerGui:FindFirstChild("BuildGui")
    if not buildGui then return nil end
    
    local buildObjects = buildGui:FindFirstChild("BuildObjects", true)
    if not buildObjects then return nil end
    
    return buildObjects.Parent
end

-- Wait for the target script to load
local TARGET_SCRIPT
repeat
    task.wait(0.5)
    TARGET_SCRIPT = getTargetScript()
until TARGET_SCRIPT

print("Target script found:", TARGET_SCRIPT:GetFullName())

-- Get the environment of the target script
local targetEnv = getsenv(TARGET_SCRIPT)

if not targetEnv then
    warn("Failed to get target script environment!")
    return
end

-- Store original UserInputService reference
local originalUIS = targetEnv.UserInputService or UserInputService

-- Create a proxy UserInputService
local proxyUIS = newproxy(true)
local proxyMT = getmetatable(proxyUIS)

-- Store original functions
local originalIsMouseButtonPressed = originalUIS.IsMouseButtonPressed
local originalGetMouseButtonsPressed = originalUIS.GetMouseButtonsPressed

proxyMT.__index = function(self, key)
    if key == "IsMouseButtonPressed" then
        return function(s, buttonType)
            if _G.simulateLeftClick and buttonType == Enum.UserInputType.MouseButton1 then
                return true
            end
            return originalIsMouseButtonPressed(originalUIS, buttonType)
        end
    end
    
    if key == "GetMouseButtonsPressed" then
        return function(s)
            local result = originalGetMouseButtonsPressed(originalUIS)
            
            if _G.simulateLeftClick then
                local found = false
                for _, btn in ipairs(result) do
                    if btn == Enum.UserInputType.MouseButton1 then
                        found = true
                        break
                    end
                end
                
                if not found then
                    local newResult = {}
                    for i, v in ipairs(result) do
                        newResult[i] = v
                    end
                    table.insert(newResult, Enum.UserInputType.MouseButton1)
                    return newResult
                end
            end
            
            return result
        end
    end
    
    return originalUIS[key]
end

proxyMT.__namecall = function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "IsMouseButtonPressed" then
        local buttonType = args[1]
        if _G.simulateLeftClick and buttonType == Enum.UserInputType.MouseButton1 then
            return true
        end
        return originalIsMouseButtonPressed(originalUIS, buttonType)
    end
    
    if method == "GetMouseButtonsPressed" then
        local result = originalGetMouseButtonsPressed(originalUIS)
        
        if _G.simulateLeftClick then
            local found = false
            for _, btn in ipairs(result) do
                if btn == Enum.UserInputType.MouseButton1 then
                    found = true
                    break
                end
            end
            
            if not found then
                local newResult = {}
                for i, v in ipairs(result) do
                    newResult[i] = v
                end
                table.insert(newResult, Enum.UserInputType.MouseButton1)
                return newResult
            end
        end
        
        return result
    end
    
    return originalUIS[method](originalUIS, ...)
end

proxyMT.__tostring = function()
    return "UserInputService"
end

-- Replace UserInputService in the target script's environment
targetEnv.UserInputService = proxyUIS

print("UserInputService override injected!")

-- MAIN FUNCTION: Simulate a short left click
_G.placepreviewblock = function()
    _G.simulateLeftClick = true
    task.wait(0.05) -- Short click duration (50ms)
    _G.simulateLeftClick = false
end

print("Function ready: _G.placepreviewblock()")
print("Call _G.placepreviewblock() to simulate a left click")

-- Handle respawns
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    local newTarget = getTargetScript()
    if newTarget and newTarget ~= TARGET_SCRIPT then
        TARGET_SCRIPT = newTarget
        local newEnv = getsenv(TARGET_SCRIPT)
        if newEnv then
            newEnv.UserInputService = proxyUIS
            print("UserInputService re-injected after respawn!")
        end
    end
end)
--_G.placepreviewblock()
