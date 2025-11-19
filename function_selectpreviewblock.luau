--[[
local function checkstatus(ID)
    repeat task.wait() until workspace.Camera.BuildObjects:FindFirstChildOfClass("Model")
    return workspace.Camera.BuildObjects:FindFirstChildOfClass("Model").ID.Value ~= ID
end
local function e(ID)
    local blockdef = require(game:GetService("ReplicatedStorage").ModuIes.BlockDef)
    
    -- Keep retrying until button exists
    local button
    repeat
        game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.Bindables.CategoryPressed:Fire(blockdef[ID].Category)
        button = game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.BuildMenu:FindFirstChild(tostring(ID), true)
        if not button then
            task.wait() -- Wait a short time before retrying
        end
    until button
    
    firesignal(button.MouseButton1Click)
end
function _G.selectpreviewblock(BlockID)
  local ID = BlockID
  game:GetService("Players").LocalPlayer.PlayerGui.BuildGui.EnableBuilding:Fire()
  e(ID)
  task.wait(0.1)
end]]











local VIM = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function checkstatus(ID)
    repeat task.wait() until workspace.Camera.BuildObjects:FindFirstChildOfClass("Model")
    return workspace.Camera.BuildObjects:FindFirstChildOfClass("Model").ID.Value ~= ID
end
local function scrollToObject(guiObject)
    if not guiObject or not guiObject:IsA("GuiObject") then return end

    local scrollFrame = guiObject:FindFirstAncestorWhichIsA("ScrollingFrame")
    if not scrollFrame or not scrollFrame:IsA("ScrollingFrame") then
        warn("Parent is not a ScrollingFrame")
        return
    end

    local layout = scrollFrame:FindFirstChildOfClass("UIListLayout")
    if not layout then
        warn("No UIListLayout in ScrollFrame")
        return
    end

    -- Calculate pixel offset of guiObject inside the list
    local offsetY = 0
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            if child == guiObject then break end
            offsetY = offsetY + child.AbsoluteSize.Y + layout.Padding.Offset
        end
    end

    -- Center the target in the viewport
    local targetY = offsetY - (scrollFrame.AbsoluteSize.Y / 2) + (guiObject.AbsoluteSize.Y / 2)

    -- Clamp to scrollable range
    local canvasHeight = scrollFrame.CanvasSize.Y.Offset
    --local maxY = math.max(0, canvasHeight - scrollFrame.AbsoluteSize.Y)
    --print(maxY)
    --targetY = math.clamp(targetY, 0, maxY)
    print(targetY)
    scrollFrame.CanvasPosition = Vector2.new(scrollFrame.CanvasPosition.X, targetY)
end
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function flashCircle(position)
    -- Create the container ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "FlashCircleGUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = CoreGui

    -- Create the red circle
    local circle = Instance.new("Frame")
    circle.Size = UDim2.fromOffset(40, 40)
    circle.Position = UDim2.fromOffset(position.X - 20, position.Y - 20)
    circle.BackgroundColor3 = Color3.new(1, 0, 0)
    circle.BackgroundTransparency = 0
    circle.BorderSizePixel = 0
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle

    -- Fade-out tween
    local tween = TweenService:Create(circle, TweenInfo.new(1, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    })
    tween:Play()

    -- Cleanup after 1 second
    task.delay(1, function()
        gui:Destroy()
    end)
end


function clickThroughOverlays(guiObject)
    if not guiObject then return false end
    
    -- Scroll to make visible
    scrollToObject(guiObject.Parent.Parent.Parent)
    
    local disabledGuis = {}
    local count = 0
    local targetScreenGui = guiObject:FindFirstAncestorOfClass("ScreenGui")
    
    local playerGuiChildren = player.PlayerGui:GetChildren()
    for i = 1, #playerGuiChildren do
        local gui = playerGuiChildren[i]
        if gui:IsA("ScreenGui") and gui.Enabled and gui ~= targetScreenGui then
            count = count + 1
            disabledGuis[count] = gui
            gui.Enabled = false
        end
    end
    
    local success, coreGuiChildren = pcall(function() return CoreGui:GetChildren() end)
    if success then
        for i = 1, #coreGuiChildren do
            local gui = coreGuiChildren[i]
            if gui:IsA("ScreenGui") and gui.Enabled then
                count = count + 1
                disabledGuis[count] = gui
                gui.Enabled = false
            end
        end
    end
    
    local x = guiObject.AbsolutePosition.X + (guiObject.AbsoluteSize.X / 2)
    local y = guiObject.AbsolutePosition.Y + (guiObject.AbsoluteSize.Y / 2)
    
    local x2,y2 = x+20,y+80
    VIM:SendMouseButtonEvent(x2, y2, 0, true, guiObject, 1)
    VIM:SendMouseButtonEvent(x2, y2, 0, false, guiObject, 1)
    VIM:SendMouseButtonEvent(x2, y2, 0, false, guiObject, 1)
    flashCircle(Vector2.new(x2, y2))
    
    for i = 1, count do
        disabledGuis[i].Enabled = true
    end
    
    return true
end
function cleanString(text)
    -- Remove patterns like "2x2", "10x5", etc.
    text = string.gsub(text, "%d+x%d+", "")
    
    -- Remove "Std"
    text = string.gsub(text, "Std", "")
    
    -- Optional: trim extra spaces
    text = string.gsub(text, "^%s+", "") -- leading spaces
    text = string.gsub(text, "%s+$", "") -- trailing spaces
    text = string.gsub(text, "%s+", " ") -- multiple spaces to single space
    
    return text
end
local function e(ID)
    local blockdef = require(game:GetService("ReplicatedStorage").ModuIes.BlockDef)
        game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.Bindables.CategoryPressed:Fire(blockdef[ID].Category)
        local origname = blockdef[ID].Model.Name
        local subcategory = game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.BuildMenu:FindFirstChild(blockdef[ID].Category2,true)
        print("subcat",subcategory)
        for _, des in subcategory:GetDescendants() do
            if des:IsA("ViewportFrame") then
                local model = cleanString(des:FindFirstChildOfClass("Model").Name)
                print("viewport",des)
                print("model",model)
                if origname:find(model) then
                    local button = des.Parent
                    clickThroughOverlays(button)
                    warn("EEEEEEEEEEEEEEEEE",button,button:IsA("TextButton"))
                    if origname~=des:FindFirstChildOfClass("Model").Name then
                        for i=1,10 do
                            clickThroughOverlays(game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.ResizeMenu.Container.Left)
                        end
                        task.wait(0.1)
                        repeat
                            task.wait()
                            clickThroughOverlays(game:GetService("Players").LocalPlayer.PlayerGui.BuildGUI2.ResizeMenu.Container.Right)
                        until workspace.Camera.BuildObjects:FindFirstAncestorOfClass("Model") and workspace.Camera.BuildObjects:FindFirstAncestorOfClass("Model").ID.Value
                    end
                    return
                else
                    warn(origname,model)
                end
            end
        end
end
function _G.selectpreviewblock(BlockID)
  local ID = BlockID
  game:GetService("Players").LocalPlayer.PlayerGui.BuildGui.EnableBuilding:Fire()
  e(ID)
  task.wait(2)
end
