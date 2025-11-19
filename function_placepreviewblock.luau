local Players = game:GetService("Players") 
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
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
-- Check if a position on the screen is blocked by visible, active GUI
local function isPositionBlockedByGui(x, y)
    local function checkGuiList(guiList)
        for _, gui in ipairs(guiList) do
            if gui and gui.Visible then
                local ancestor = gui:FindFirstAncestorWhichIsA("ScreenGui")
                if ancestor and ancestor.Enabled then
                    if not ancestor.IgnoreGuiInset and not ancestor.ResetOnSpawn then
                        return true
                    end
                end
            end
        end
        return false
    end

    if checkGuiList(player.PlayerGui:GetGuiObjectsAtPosition(x, y)) then
        return true
    end
    if checkGuiList(CoreGui:GetGuiObjectsAtPosition(x, y)) then
        return true
    end

    return false
end

-- Find an on-screen position with no GUI obstruction
local function findClearPosition()
    local viewport = camera.ViewportSize
    local centerX, centerY = viewport.X / 2, viewport.Y / 2

    -- 1️⃣ Try the center first
    if not isPositionBlockedByGui(centerX, centerY) then
        return centerX, centerY
    end

    -- 2️⃣ Otherwise, check other common positions
    local testPositions = {
        {x = 50, y = 50},
        {x = viewport.X - 50, y = 50},
        {x = 50, y = viewport.Y - 50},
        {x = viewport.X - 50, y = viewport.Y - 50},
        {x = centerX, y = 50},
        {x = centerX, y = viewport.Y - 50},
        {x = 50, y = centerY},
        {x = viewport.X - 50, y = centerY},
    }

    for _, pos in ipairs(testPositions) do
        if not isPositionBlockedByGui(pos.x, pos.y) then
            return pos.x, pos.y
        end
    end

    -- 3️⃣ Random fallback search
    for _ = 1, 25 do
        local rx, ry = math.random(30, viewport.X - 30), math.random(30, viewport.Y - 30)
        if not isPositionBlockedByGui(rx, ry) then
            return rx, ry
        end
    end

    -- 4️⃣ Nothing found — return center anyway
    return centerX, centerY
end

-- Click at a clear screen position
function _G.placepreviewblock()
    local x, y = findClearPosition()
    VirtualInputManager:SendMouseMoveEvent(x, y, game)
    --task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    --task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    flashCircle(Vector2.new(x,y)
end



--_G.placepreviewblock()
