local function L(key)
    local lang = Library.Lang[Library.Language] or Library.Lang.VI
    return lang[key] or key
end


local Sounds = {
    Click  = "rbxassetid://6895079853",
    Toggle = "rbxassetid://6895079853",
    Hover  = "rbxassetid://10066931761",
    Open   = "rbxassetid://6042053626",
    Notify = "rbxassetid://4590662766",
}

Library.SoundVolume = 0.35
local function PlaySound(name, vol)
    if not Library.SoundsEnabled then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = Sounds[name] or Sounds.Click
        s.Volume = vol or Library.SoundVolume or 0.35
        s.Parent = SoundService
        s:Play()
        s.Ended:Connect(function() s:Destroy() end)
        task.delay(3, function() if s then s:Destroy() end end)
    end)
end

local ThemedObjects = {}
local function RegisterTheme(obj, prop, key)
    if obj then table.insert(ThemedObjects, {obj = obj, prop = prop, key = key}) end
end

local function ApplyTheme()
    for _, item in ipairs(ThemedObjects) do
        if item.obj and item.obj.Parent then
            pcall(function()
                if item.key == "Accent" then
                    item.obj[item.prop] = Library.AccentColor
                else
                    item.obj[item.prop] = Library.Theme[item.key]
                end
            end)
        end
    end
end

task.spawn(function()
    local h = 0
    while true do
        if Library.RainbowEnabled then
            h = (h + 0.005 * (Library.RainbowSpeed or 1)) % 1
            Library.AccentColor = Color3.fromHSV(h, 0.85, 1)
            ApplyTheme()
        end
        task.wait(0.03)
    end
end)

local function Tween(obj, props, t)
    local tw = TweenService:Create(obj, TweenInfo.new(t or 0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local function Corner(p, r)
    if r and r > 0 then
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, r)
        c.Parent = p
        return c
    end
end

local function Stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color = col or Library.Theme.Stroke
    s.Thickness = th or 1
    s.Parent = p
    return s
end

local function Create(class, props)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then i[k] = v end
    end
    if props and props.Parent then i.Parent = props.Parent end
    return i
end


local TipGui
local TooltipDelay = 0.35
local CurrentTooltip

local function CreateTooltip(obj, text)
    if not obj or not text or text == "" then return end

    local hoverConn, leaveConn, moveConn

    local function show(x, y)
        if not TipGui then
            TipGui = Create("ScreenGui", {
                Name = "x9_Tip",
                ResetOnSpawn = false,
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                Parent = PlayerGui
            })
        end

        local old = TipGui:FindFirstChild("Tooltip")
        if old then old:Destroy() end

        local f = Create("Frame", {
            Name = "Tooltip",
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundColor3 = Color3.fromRGB(18, 18, 24),
            Position = UDim2.fromOffset(x + 14, y + 10),
            ZIndex = 500,
            Parent = TipGui
        })
        Corner(f, 5)
        Stroke(f, Library.AccentColor, 1)

        Create("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundTransparency = 1,
            Text = "  " .. text .. "  ",
            TextColor3 = Color3.fromRGB(240, 240, 245),
            Font = Enum.Font.Gotham,
            TextSize = 11,
            ZIndex = 501,
            Parent = f
        })

        if moveConn then moveConn:Disconnect() end
        moveConn = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and f and f.Parent then
                f.Position = UDim2.fromOffset(input.Position.X + 14, input.Position.Y + 10)
            end
        end)
    end

    local function hide()
        CurrentTooltip = nil
        if TipGui then
            local t = TipGui:FindFirstChild("Tooltip")
            if t then t:Destroy() end
        end
        if moveConn then
            moveConn:Disconnect()
            moveConn = nil
        end
    end

    -- Fix: set CurrentTooltip on enter, check after delay
    hoverConn = obj.MouseEnter:Connect(function()
        CurrentTooltip = obj
        task.delay(TooltipDelay, function()
            if obj and obj.Parent and CurrentTooltip == obj then
                show(Mouse.X, Mouse.Y)
            end
        end)
    end)

    leaveConn = obj.MouseLeave:Connect(function()
        hide()
    end)

    obj:SetAttribute("TooltipText", text)
end


local ContextMenuGui
