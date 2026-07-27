local Watermark = {
    Gui = nil,
    Frame = nil,
    Label = nil,
    Stroke = nil,
    BaseText = "x9runnerreal",
    ShowFPS = false,
    ShowPing = false,
    Visible = true,
    
    ConnUpdate = nil,
    ConnDrag = nil,
    ConnDragEnd = nil,
}

local function Watermark_Cleanup()
    
    if Watermark.ConnDrag then pcall(function() Watermark.ConnDrag:Disconnect() end) Watermark.ConnDrag = nil end
    if Watermark.ConnDragEnd then pcall(function() Watermark.ConnDragEnd:Disconnect() end) Watermark.ConnDragEnd = nil end
    local gui = Watermark.Gui
    Watermark.Gui = nil
    Watermark.Frame = nil
    Watermark.Label = nil
    Watermark.Stroke = nil
    Watermark.ConnUpdate = nil
    if gui then pcall(function() gui:Destroy() end) end
end

function Library:CreateWatermark(text, options)
    options = options or {}
    Watermark_Cleanup() 

    Watermark.BaseText = text or "x9runnerreal"
    Watermark.ShowFPS = options.ShowFPS == true
    Watermark.ShowPing = options.ShowPing == true
    Watermark.Visible = true

    local gui = Create("ScreenGui", {
        Name = "x9_WM",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = PlayerGui
    })

    local wm = Create("Frame", {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 0, options.Height or 22),
        Position = options.Position or UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = options.Background or Color3.fromRGB(18, 18, 24),
        BackgroundTransparency = options.Transparency or 0.12,
        Active = true,
        Parent = gui
    })
    Corner(wm, options.Corner or 5)

    local st = Stroke(wm, options.StrokeColor or Library.AccentColor, options.StrokeThickness or 1.2)
    RegisterTheme(st, "Color", "Accent")

    local label = Create("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "  " .. Watermark.BaseText .. "  ",
        TextColor3 = options.TextColor or Color3.fromRGB(240, 240, 245),
        Font = options.Font or Enum.Font.GothamBold,
        TextSize = options.TextSize or 11,
        Parent = wm
    })

    Watermark.Gui = gui
    Watermark.Frame = wm
    Watermark.Label = label
    Watermark.Stroke = st

    
    local dragging, dragStart, startPos
    wm.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = true
        dragStart = input.Position
        startPos = wm.Position

        if Watermark.ConnDrag then Watermark.ConnDrag:Disconnect() end
        Watermark.ConnDrag = UserInputService.InputChanged:Connect(function(move)
            if not dragging then return end
            if move.UserInputType == Enum.UserInputType.MouseMovement or move.UserInputType == Enum.UserInputType.Touch then
                local d = move.Position - dragStart
                wm.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end)

    Watermark.ConnDragEnd = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if Watermark.ConnDrag then
                Watermark.ConnDrag:Disconnect()
                Watermark.ConnDrag = nil
            end
        end
    end)

    
    if Watermark.ShowFPS or Watermark.ShowPing then
        local lastText = ""
        local fps = 60
        local StatsSvc = game:GetService("Stats")

        
        local function measureFPS()
            local ok, ft = pcall(function()
                return StatsSvc.FrameTime
            end)
            if ok and type(ft) == "number" and ft > 0 and ft < 1 then
                return math.clamp(math.floor(1 / ft + 0.5), 1, 1000)
            end
            
            local t0 = os.clock()
            RunService.Heartbeat:Wait()
            RunService.Heartbeat:Wait()
            RunService.Heartbeat:Wait()
            RunService.Heartbeat:Wait()
            local dt = os.clock() - t0
            return (dt > 0.001) and math.clamp(math.floor(4 / dt + 0.5), 1, 1000) or fps
        end

        Watermark.ConnUpdate = task.spawn(function()
            while Watermark.Gui and Watermark.Gui.Parent do
                if Watermark.ShowFPS then
                    fps = measureFPS()
                end

                local pingPart = ""
                if Watermark.ShowPing then
                    local ping = 0
                    pcall(function() ping = math.floor(Player:GetNetworkPing() * 1000) end)
                    pingPart = string.format("  |  Ping: %dms", ping)
                end

                local newText = Watermark.ShowFPS
                    and string.format("  %s  |  FPS: %d%s  ", Watermark.BaseText, fps, pingPart)
                    or string.format("  %s%s  ", Watermark.BaseText, pingPart)

                if newText ~= lastText and label and label.Parent then
                    label.Text = newText
                    lastText = newText
                end

                task.wait(1)
            end
        end)
    end

    
    local api = {}

    function api:SetText(newText)
        Watermark.BaseText = newText or ""
        if label and label.Parent and not Watermark.ShowFPS and not Watermark.ShowPing then
            label.Text = "  " .. Watermark.BaseText .. "  "
        end
    end

    function api:SetVisible(v)
        Watermark.Visible = v and true or false
        if wm then wm.Visible = Watermark.Visible end
    end

    function api:SetPosition(pos)
        if wm then wm.Position = pos end
    end

    function api:Destroy()
        Watermark_Cleanup()
    end

    function Library:UpdateWatermark(newText)
        api:SetText(newText)
    end

    function Library:SetWatermarkVisible(v)
        api:SetVisible(v)
    end

    return api
end


