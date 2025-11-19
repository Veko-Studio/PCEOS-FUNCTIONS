local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Flash a red circle at a screen position
local function flashCircle(position)
    local gui = Instance.new("ScreenGui")
    gui.Name = "FlashCircleGUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = CoreGui

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

    local tween = TweenService:Create(circle, TweenInfo.new(1, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    })
    tween:Play()

    task.delay(1, function() gui:Destroy() end)
end

-- Click at a screen position, ignoring overlays
local function clickThroughPosition(x, y)
    -- Disable overlapping GUIs temporarily
    local disabledGuis = {}
    local count = 0
    for _, gui in ipairs(player.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled then
            count = count + 1
            disabledGuis[count] = gui
            gui.Enabled = false
        end
    end
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled then
            count = count + 1
            disabledGuis[count] = gui
            gui.Enabled = false
        end
    end

    -- Click the target
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)


    -- Re-enable the GUIs
    for i = 1, count do
        disabledGuis[i].Enabled = true
    end

    flashCircle(Vector2.new(x, y))
end

-- Find a clear position (optional fallback)
local function findClearPosition()
    local viewport = camera.ViewportSize
    local centerX, centerY = viewport.X / 2, viewport.Y / 2
    return centerX, centerY
end

-- Place a preview block at a clear position
function _G.placepreviewblock()
    local x, y = findClearPosition()
    clickThroughPosition(x, y)
end

-- Example usage:
-- _G.placepreviewblock()
