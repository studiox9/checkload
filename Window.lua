function Library:CreateWindow(cfg)
    cfg = cfg or {}
    local WindowName   = cfg.Name or "x9runnerreal"
    local SidebarImage = cfg.SidebarImage or ""
    local ToggleKey    = cfg.ToggleKey or Enum.KeyCode.Insert
    local SaveConfig   = cfg.SaveConfig == true
    local ConfigFolder = cfg.ConfigFolder or "x9runnerreal"
    local ConfigName   = cfg.ConfigName or "config.json"
    local ThemeName    = cfg.Theme or "Dark"
    local ToggleIcon   = cfg.ToggleIcon or 121505647119252
    local UpdateUrl    = cfg.UpdateUrl

    
    local Lang
    if cfg.Language and Library.Lang[cfg.Language] then
        Lang = cfg.Language
    elseif cfg.AutoLanguage == false then
        Lang = "EN"
    else
        Lang = Library:DetectSystemLanguage()
    end

    
    local KeyUrl       = cfg.KeyUrl or cfg.KeyAPI or nil
    local GetKeyLink   = cfg.GetKeyLink or cfg.KeyLink or nil
    local KeyNote      = cfg.KeyNote or "Enter the key to continue"
    local SaveKeyLocal = cfg.SaveKey ~= false
    local KeyFolder    = cfg.KeyFolder or ConfigFolder

    if Library.Lang[Lang] then Library.Language = Lang end
    if Library.Themes[ThemeName] then
        Library.Theme = Library.Themes[ThemeName]
        Library.CurrentTheme = ThemeName
    end

    if UpdateUrl then
        Library:CheckUpdate(UpdateUrl)
    end

    
    
    
    if KeyUrl and KeyUrl ~= "" then
        local keyVerified = false
        local savedKeyPath = KeyFolder .. "/key.txt"

        
        local function checkKey(inputKey)
            if not inputKey or inputKey == "" then return false end
            local ok, result = pcall(function()
                return game:HttpGet(KeyUrl)
            end)
            if not ok or not result then return false end

            
            
            
            
            inputKey = tostring(inputKey):gsub("%s+", "")
            result = tostring(result)

            
            local jsonOk, jsonData = pcall(function()
                return HttpService:JSONDecode(result)
            end)
            if jsonOk and type(jsonData) == "table" then
                for _, k in pairs(jsonData) do
                    if tostring(k):gsub("%s+", "") == inputKey then return true end
                end
            end

            
            for line in string.gmatch(result, "[^\r\n]+") do
                if line:gsub("%s+", "") == inputKey then return true end
            end
            if string.find(result, inputKey, 1, true) then return true end

            return false
        end

        
        if SaveKeyLocal then
            pcall(function()
                if isfolder and not isfolder(KeyFolder) then makefolder(KeyFolder) end
                if isfile and isfile(savedKeyPath) then
                    local saved = readfile(savedKeyPath)
                    if checkKey(saved) then
                        keyVerified = true
                    end
                end
            end)
        end

        if not keyVerified then
            
            local keyGui = Create("ScreenGui", {
                Name = "x9_KeySystem", ResetOnSpawn = false,
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PlayerGui
            })

            local bg = Create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(12, 12, 16),
                BackgroundTransparency = 0.15,
                Parent = keyGui
            })

            local card = Create("Frame", {
                Size = UDim2.new(0, 340, 0, 220),
                Position = UDim2.new(0.5, -170, 0.5, -110),
                BackgroundColor3 = Color3.fromRGB(24, 24, 30),
                Parent = keyGui
            })
            Corner(card, 8)
            Stroke(card, Library.AccentColor, 1.5)

            Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 28), Position = UDim2.new(0, 10, 0, 12),
                BackgroundTransparency = 1, Text = WindowName .. " — Key System",
                TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = card
            })

            Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 42),
                BackgroundTransparency = 1, Text = KeyNote,
                TextColor3 = Color3.fromRGB(160, 160, 170), Font = Enum.Font.Gotham, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = card
            })

            local keyBox = Create("TextBox", {
                Size = UDim2.new(1, -24, 0, 32), Position = UDim2.new(0, 12, 0, 72),
                BackgroundColor3 = Color3.fromRGB(18, 18, 24), Text = "",
                PlaceholderText = "Enter key here...", TextColor3 = Color3.new(1,1,1),
                PlaceholderColor3 = Color3.fromRGB(100, 100, 110), Font = Enum.Font.Gotham,
                TextSize = 13, ClearTextOnFocus = false, Parent = card
            })
            Corner(keyBox, 5)
            Stroke(keyBox, Color3.fromRGB(50, 50, 58), 1)

            local statusLbl = Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 18), Position = UDim2.new(0, 10, 0, 110),
                BackgroundTransparency = 1, Text = "",
                TextColor3 = Color3.fromRGB(255, 100, 100), Font = Enum.Font.Gotham, TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = card
            })

            local submitBtn = Create("TextButton", {
                Size = UDim2.new(0.48, -8, 0, 34), Position = UDim2.new(0, 12, 0, 140),
                BackgroundColor3 = Library.AccentColor, Text = "Confirm",
                TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13,
                AutoButtonColor = false, Parent = card
            })
            Corner(submitBtn, 5)

            local getKeyBtn = Create("TextButton", {
                Size = UDim2.new(0.48, -8, 0, 34), Position = UDim2.new(0.52, 0, 0, 140),
                BackgroundColor3 = Color3.fromRGB(40, 40, 48), Text = "Get Key",
                TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13,
                AutoButtonColor = false, Parent = card
            })
            Corner(getKeyBtn, 5)

            Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 16), Position = UDim2.new(0, 10, 0, 188),
                BackgroundTransparency = 1, Text = "Don't have a key? Click Get Key to receive one.",
                TextColor3 = Color3.fromRGB(100, 100, 110), Font = Enum.Font.Gotham, TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = card
            })

            getKeyBtn.MouseButton1Click:Connect(function()
                PlaySound("Click")
                if GetKeyLink and GetKeyLink ~= "" then
                    pcall(function()
                        if setclipboard then setclipboard(GetKeyLink) end
                    end)
                    statusLbl.TextColor3 = Color3.fromRGB(100, 200, 255)
                    statusLbl.Text = "Key link copied to clipboard!"
                    
                    pcall(function()
                        if typeof(request) == "function" then
                            
                        end
                    end)
                else
                    statusLbl.TextColor3 = Color3.fromRGB(255, 180, 80)
                    statusLbl.Text = "Get key link not configured"
                end
            end)

            local verifying = false
            local function tryVerify()
                if verifying then return end
                verifying = true
                local input = keyBox.Text
                statusLbl.TextColor3 = Color3.fromRGB(200, 200, 100)
                statusLbl.Text = "Checking key..."
                task.spawn(function()
                    local valid = checkKey(input)
                    if valid then
                        statusLbl.TextColor3 = Color3.fromRGB(80, 220, 120)
                        statusLbl.Text = "Valid key! Loading..."
                        if SaveKeyLocal then
                            pcall(function()
                                if isfolder and not isfolder(KeyFolder) then makefolder(KeyFolder) end
                                writefile(savedKeyPath, tostring(input):gsub("%s+", ""))
                            end)
                        end
                        task.wait(0.6)
                        keyVerified = true
                        keyGui:Destroy()
                    else
                        statusLbl.TextColor3 = Color3.fromRGB(255, 90, 90)
                        statusLbl.Text = "Invalid key!"
                        verifying = false
                    end
                end)
            end

            submitBtn.MouseButton1Click:Connect(function()
                PlaySound("Click")
                tryVerify()
            end)
            keyBox.FocusLost:Connect(function(enter)
                if enter then tryVerify() end
            end)

            
            while not keyVerified do
                task.wait(0.15)
            end
        end
    end
    

    pcall(function()
        local o = PlayerGui:FindFirstChild("MainUI")
        if o then o:Destroy() end
        local b = Lighting:FindFirstChild("MainUIBlur")
        if b then b:Destroy() end
    end)

    local Blur = Create("BlurEffect", {Name = "MainUIBlur", Size = 10, Parent = Lighting})
    local ScreenGui = Create("ScreenGui", {
        Name = "MainUI", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PlayerGui
    })

    
    local Intro = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(12, 12, 16),
        BackgroundTransparency = 0,
        ZIndex = 100,
        Parent = ScreenGui
    })
    local introTitle = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0.45, 0),
        BackgroundTransparency = 1,
        Text = WindowName,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 28,
        ZIndex = 101,
        Parent = Intro
    })
    local introBarBg = Create("Frame", {
        Size = UDim2.new(0, 200, 0, 4),
        Position = UDim2.new(0.5, -100, 0.55, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 48),
        ZIndex = 101,
        Parent = Intro
    })
    Corner(introBarBg, 2)
    local introBar = Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Library.AccentColor,
        ZIndex = 102,
        Parent = introBarBg
    })
    Corner(introBar, 2)

    local Main = Create("Frame", {
        Name = "Main", Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0, ClipsDescendants = true, Active = true,
        BackgroundTransparency = 1,
        Parent = ScreenGui
    })
    RegisterTheme(Main, "BackgroundColor3", "Background")
    local mStroke = Stroke(Main, Library.Theme.Stroke, 1.3)
    RegisterTheme(mStroke, "Color", "Stroke")

    
    task.spawn(function()
        PlaySound("Open", 0.4)
        Tween(introBar, {Size = UDim2.new(1, 0, 1, 0)}, 0.7)
        task.wait(0.85)
        Tween(Intro, {BackgroundTransparency = 1}, 0.35)
        Tween(introTitle, {TextTransparency = 1}, 0.3)
        Tween(introBarBg, {BackgroundTransparency = 1}, 0.3)
        Tween(introBar, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.35)
        Intro:Destroy()
        
        Main.Size = UDim2.new(0, 0, 0, 0)
        Main.Position = UDim2.new(0.5, 0, 0.5, 0)
        Main.BackgroundTransparency = 0
        Tween(Main, {
            Size = UDim2.new(0, 760, 0, 480),
            Position = UDim2.new(0.5, -380, 0.5, -240),
            BackgroundTransparency = 0
        }, 0.4)
    end)

    
    
    local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local floatSize = isMobile and 58 or 48

    local FloatToggle = Create("ImageButton", {
        Name = "FloatToggle",
        Size = UDim2.new(0, floatSize, 0, floatSize),
        Position = UDim2.new(0.02, 0, 0.5, -floatSize/2),
        BackgroundColor3 = Library.Theme.Sidebar,
        BackgroundTransparency = 0.15,
        Image = "rbxthumb://type=Asset&id=" .. tostring(ToggleIcon) .. "&w=420&h=420",
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 50,
        Parent = ScreenGui
    })
    Corner(FloatToggle, isMobile and 14 or 12)
    local floatStroke = Stroke(FloatToggle, Library.AccentColor, isMobile and 2.5 or 2)
    RegisterTheme(floatStroke, "Color", "Accent")
    RegisterTheme(FloatToggle, "BackgroundColor3", "Sidebar")

    local fDragging, fDragStart, fStartPos
    FloatToggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            fDragging = true
            fDragStart = input.Position
            fStartPos = FloatToggle.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then fDragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if fDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - fDragStart
            FloatToggle.Position = UDim2.new(fStartPos.X.Scale, fStartPos.X.Offset + delta.X, fStartPos.Y.Scale, fStartPos.Y.Offset + delta.Y)
        end
    end)
    FloatToggle.MouseButton1Click:Connect(function()
        PlaySound("Click")
        if Main and Main.Parent then
            Main.Visible = not Main.Visible
            if Blur then Blur.Enabled = Main.Visible end
        end
    end)

    
    FloatToggle.MouseEnter:Connect(function()
        Tween(FloatToggle, {BackgroundTransparency = 0.05, Size = UDim2.new(0, floatSize + 10, 0, floatSize + 10)}, 0.14)
    end)
    FloatToggle.MouseLeave:Connect(function()
        Tween(FloatToggle, {BackgroundTransparency = 0.15, Size = UDim2.new(0, floatSize, 0, floatSize)}, 0.14)
    end)

    
    if isMobile then
        task.delay(1.0, function()
            if Main and Main.Parent then
                Main.Size = UDim2.new(0, math.min(700, workspace.CurrentCamera.ViewportSize.X - 40), 0, math.min(460, workspace.CurrentCamera.ViewportSize.Y - 80))
                Main.Position = UDim2.new(0.5, -Main.Size.X.Offset/2, 0.5, -Main.Size.Y.Offset/2)
            end
        end)
    end

    
    local Header = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Library.Theme.Header,
        BorderSizePixel = 0, Parent = Main
    })
    RegisterTheme(Header, "BackgroundColor3", "Header")

    local Title = Create("TextLabel", {
        Size = UDim2.new(1, -220, 1, 0), Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1, Text = WindowName, TextSize = 15,
        Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center, TextColor3 = Library.Theme.Text, Parent = Header
    })
    RegisterTheme(Title, "TextColor3", "Text")

    local function HBtn(x, txt, col)
        local b = Create("TextButton", {
            Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, x, 0, 6),
            BackgroundColor3 = Color3.fromRGB(38, 38, 44), Text = txt,
            TextColor3 = col or Color3.fromRGB(220, 220, 230), TextSize = 13,
            Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = Header
        })
        Corner(b, 4)
        b.MouseButton1Click:Connect(function() PlaySound("Click", 0.3) end)
        return b
    end

    local ToggleBtn = HBtn(-182, "💤")
    local MinBtn    = HBtn(-148, "−", Library.Theme.Warning)
    local ThemeBtn  = HBtn(-114, "⚙")
    local RainBtn   = HBtn(-80, "★")
    local PanicBtn  = HBtn(-46, "!", Color3.fromRGB(255, 80, 80))
    local CloseBtn  = HBtn(-12, "×", Library.Theme.Danger)

    
    local Left = Create("Frame", {
        Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(0, 185, 1, -40),
        BackgroundColor3 = Library.Theme.Sidebar, BorderSizePixel = 0, Parent = Main
    })
    RegisterTheme(Left, "BackgroundColor3", "Sidebar")

    local ImgBox = Create("Frame", {
        Size = UDim2.new(1, -14, 0, 120), Position = UDim2.new(0, 7, 0, 7),
        BackgroundColor3 = Color3.fromRGB(36, 36, 42), Parent = Left
    })
    Corner(ImgBox, 4)
    if SidebarImage ~= "" then
        Create("ImageLabel", {
            Size = UDim2.new(1, -6, 1, -6), Position = UDim2.new(0, 3, 0, 3),
            BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit,
            Image = SidebarImage, Parent = ImgBox
        })
    else
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Text = "x9runnerreal", TextColor3 = Color3.fromRGB(65, 65, 75),
            Font = Enum.Font.GothamBold, TextSize = 12, Parent = ImgBox
        })
    end

    Create("Frame", {
        Position = UDim2.new(0, 7, 0, 136), Size = UDim2.new(1, -14, 0, 1),
        BackgroundColor3 = Color3.fromRGB(48, 48, 54), Parent = Left
    })

    local LeftScroll = Create("ScrollingFrame", {
        Position = UDim2.new(0, 0, 0, 145), Size = UDim2.new(1, 0, 1, -150),
        BackgroundTransparency = 1, ScrollBarThickness = 2,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(),
        Parent = Left
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 3), HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder, Parent = LeftScroll
    })

    
    local Right = Create("Frame", {
        Position = UDim2.new(0, 185, 0, 40), Size = UDim2.new(1, -185, 1, -40),
        BackgroundColor3 = Library.Theme.Content, BorderSizePixel = 0, Parent = Main
    })
    RegisterTheme(Right, "BackgroundColor3", "Content")

    local Search = Create("TextBox", {
        Size = UDim2.new(1, -16, 0, 24), Position = UDim2.new(0, 8, 0, 6),
        BackgroundColor3 = Color3.fromRGB(24, 24, 30), Text = "",
        PlaceholderText = L("Search"), TextColor3 = Library.Theme.Text,
        PlaceholderColor3 = Color3.fromRGB(95, 95, 105), Font = Enum.Font.Gotham,
        TextSize = 11.5, ClearTextOnFocus = false, Visible = false, Parent = Right
    })
    Corner(Search, 4)

    
    local sidebarCollapsed = false
    if isMobile then
        local toggleSidebarBtn = Create("TextButton", {
            Size = UDim2.new(0, 28, 0, 28),
            Position = UDim2.new(0, 6, 0, 6),
            BackgroundColor3 = Color3.fromRGB(40, 40, 48),
            Text = "☰", TextColor3 = Color3.new(1,1,1),
            Font = Enum.Font.GothamBold, TextSize = 14,
            ZIndex = 60, Parent = Header
        })
        Corner(toggleSidebarBtn, 4)

        toggleSidebarBtn.MouseButton1Click:Connect(function()
            sidebarCollapsed = not sidebarCollapsed
            if sidebarCollapsed then
                Tween(Left, {Size = UDim2.new(0, 0, 1, -40)}, 0.2)
                Tween(Right, {Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(1, 0, 1, -40)}, 0.2)
                toggleSidebarBtn.Text = "☰"
            else
                Tween(Left, {Size = UDim2.new(0, 185, 1, -40)}, 0.2)
                Tween(Right, {Position = UDim2.new(0, 185, 0, 40), Size = UDim2.new(1, -185, 1, -40)}, 0.2)
                toggleSidebarBtn.Text = "✕"
            end
        end)

        
        task.delay(1.1, function()
            if Left and Right then
                sidebarCollapsed = true
                Left.Size = UDim2.new(0, 0, 1, -40)
                Right.Position = UDim2.new(0, 0, 0, 40)
                Right.Size = UDim2.new(1, 0, 1, -40)
            end
        end)
    end

    
    local dragging, dStart, sPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dStart = input.Position
            sPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dStart
            Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
        end
    end)

    
    local RBtn = Create("TextButton", {
        Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -14, 1, -14),
        BackgroundTransparency = 1, Text = "⌟", TextColor3 = Color3.fromRGB(100, 100, 110),
        TextSize = 11, Font = Enum.Font.GothamBold, Parent = Main
    })
    local resizing, rStart, szStart
    RBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            rStart = input.Position
            szStart = Main.Size
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - rStart
            Main.Size = UDim2.new(0, math.clamp(szStart.X.Offset + d.X, 500, 1100), 0, math.clamp(szStart.Y.Offset + d.Y, 340, 800))
        end
    end)

    local Window = {
        Tabs = {}, CurrentTab = nil, ScreenGui = ScreenGui, Blur = Blur,
        Main = Main, ToggleKey = ToggleKey, SaveConfig = SaveConfig,
        ConfigFolder = ConfigFolder, ConfigName = ConfigName,
        Flags = {}, OpenPopups = {}, Elements = {}, FloatToggle = FloatToggle,
        SearchBox = Search, 
        LangElements = {} 
    }

    
    function Window:ApplyConfigs()
        for _, entry in ipairs(self.Elements) do
            local conf
            if entry.MultiFlag then
                
                local s = Library.Configs[entry.Flag .. "_S"]
                local k = Library.Configs[entry.Flag .. "_K"]
                local m = Library.Configs[entry.Flag .. "_M"]
                if entry.Object and entry.Object.SetFromConfig then
                    pcall(entry.Object.SetFromConfig, entry.Object, s, k, m)
                end
            else
                conf = Library.Configs[entry.Flag]
                if conf ~= nil and entry.Object and entry.Object.Set then
                    pcall(function() entry.Object:Set(conf) end)
                end
            end
        end
        Library:Notify("Config", L("Applied"), 1.5, "success")
    end

    local function ClosePopups()
        for _, p in pairs(Window.OpenPopups) do
            if p and p.Close then pcall(p.Close) end
        end
        table.clear(Window.OpenPopups)
    end

    ToggleBtn.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
        if Blur then Blur.Enabled = Main.Visible end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ClosePopups()
        PlaySound("Click")
        Tween(Main, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.22)
        Tween(FloatToggle, {BackgroundTransparency = 1}, 0.2)
        task.wait(0.24)
        pcall(function() Blur:Destroy() end)
        ScreenGui:Destroy()
    end)

    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            ClosePopups()
            Tween(Main, {Size = UDim2.new(0, Main.Size.X.Offset, 0, 46)}, 0.25)
            Left.Visible = false
            Right.Visible = false
        else
            Tween(Main, {Size = UDim2.new(0, Main.Size.X.Offset, 0, 480)}, 0.25)
            Left.Visible = true
            Right.Visible = true
        end
    end)

    local themes = {
        "Dark", "Light", "Purple", "Blue", "Red", "Green", "Pink", "Orange",
        "Cyan", "Gold", "Emerald", "Rose", "Midnight", "Discord", "Dracula",
        "Nord", "Ocean", "Neon"
    }
    local tIdx = 1
    for i, t in ipairs(themes) do if t == Library.CurrentTheme then tIdx = i end end
    ThemeBtn.MouseButton1Click:Connect(function()
        tIdx = tIdx % #themes + 1
        Library.Theme = Library.Themes[themes[tIdx]]
        Library.CurrentTheme = themes[tIdx]
        ApplyTheme()
        Library:Notify("Theme", L("Theme") .. ": " .. themes[tIdx], 1.5)
    end)

    RainBtn.MouseButton1Click:Connect(function()
        Library.RainbowEnabled = not Library.RainbowEnabled
        Library:Notify("Rainbow", Library.RainbowEnabled and L("RainbowOn") or L("RainbowOff"), 1.5)
    end)

    PanicBtn.MouseButton1Click:Connect(function()
        if Window.Panic then
            Window:Panic()
        end
    end)

    
    function Window:CreateTab(name, icon, badge)
        local cont = Create("Frame", {
            Size = UDim2.new(1, -10, 0, 32), BackgroundColor3 = Color3.fromRGB(38, 38, 44),
            BackgroundTransparency = 0.25, Parent = LeftScroll, LayoutOrder = #Window.Tabs
        })
        Corner(cont, 4)
        RegisterTheme(cont, "BackgroundColor3", "Element")

        local btn = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = cont
        })

        if icon and icon ~= "" then
            Create("ImageLabel", {
                Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 8, 0.5, -7),
                BackgroundTransparency = 1, Image = icon, Parent = cont
            })
        end

        Create("TextLabel", {
            Size = UDim2.new(1, icon and -48 or -18, 1, 0),
            Position = UDim2.new(0, icon and 28 or 9, 0, 0),
            BackgroundTransparency = 1, Text = name, TextColor3 = Library.Theme.Text,
            Font = Enum.Font.GothamSemibold, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = cont
        })

        if badge then
            local bf = Create("Frame", {
                Size = UDim2.new(0, 16, 0, 14), Position = UDim2.new(1, -22, 0.5, -7),
                BackgroundColor3 = Library.AccentColor, Parent = cont
            })
            Corner(bf, 7)
            RegisterTheme(bf, "BackgroundColor3", "Accent")
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                Text = tostring(badge), TextColor3 = Color3.new(1,1,1),
                Font = Enum.Font.GothamBold, TextSize = 9, Parent = bf
            })
        end

        local content = Create("ScrollingFrame", {
            Size = UDim2.new(1, -14, 1, -42), Position = UDim2.new(0, 7, 0, 36),
            BackgroundTransparency = 1, ScrollBarThickness = 2,
            AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(),
            Visible = false, Parent = Right
        })
        Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = content})

        cont.MouseEnter:Connect(function()
            if Window.CurrentTab ~= cont then Tween(cont, {BackgroundTransparency = 0.08}, 0.1) end
        end)
        cont.MouseLeave:Connect(function()
            if Window.CurrentTab ~= cont then Tween(cont, {BackgroundTransparency = 0.25}, 0.1) end
        end)

        
        local draggingTab = false
        local dragStartY, startLayoutOrder

        cont.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingTab = true
                dragStartY = input.Position.Y
                startLayoutOrder = cont.LayoutOrder

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        draggingTab = false
                        
                        local tabs = {}
                        for _, child in ipairs(LeftScroll:GetChildren()) do
                            if child:IsA("Frame") and child ~= cont then
                                table.insert(tabs, child)
                            end
                        end
                        table.sort(tabs, function(a, b) return a.LayoutOrder < b.LayoutOrder end)
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if draggingTab and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local deltaY = input.Position.Y - dragStartY
                local newOrder = startLayoutOrder + math.floor(deltaY / 34)

                
                for _, other in ipairs(LeftScroll:GetChildren()) do
                    if other:IsA("Frame") and other ~= cont then
                        if math.abs(other.LayoutOrder - newOrder) < 1 then
                            local temp = other.LayoutOrder
                            other.LayoutOrder = cont.LayoutOrder
                            cont.LayoutOrder = temp
                            break
                        end
                    end
                end
                cont.LayoutOrder = math.clamp(newOrder, 0, 50)
            end
        end)

        btn.MouseButton1Click:Connect(function()
            PlaySound("Click", 0.25)
            if Window.CurrentTab then
                
                local oldContent = Window.CurrentTab.Content
                Tween(oldContent, {ScrollBarImageTransparency = 1}, 0.12)
                Tween(Window.CurrentTab.Button, {BackgroundTransparency = 0.25}, 0.12)
                task.delay(0.12, function()
                    if oldContent then oldContent.Visible = false end
                end)
            end

            
            content.Visible = true
            content.ScrollBarImageTransparency = 1
            Tween(content, {ScrollBarImageTransparency = 0}, 0.18)
            Search.Visible = true
            Tween(cont, {BackgroundTransparency = 0}, 0.12)
            Window.CurrentTab = {Button = cont, Content = content, Name = name}
            ClosePopups()
        end)

        
        Search:GetPropertyChangedSignal("Text"):Connect(function()
            local q = string.lower(Search.Text)
            for _, tab in ipairs(Window.Tabs) do
                if tab.Content then
                    for _, c in ipairs(tab.Content:GetChildren()) do
                        if c:IsA("Frame") or c:IsA("TextLabel") or c:IsA("TextButton") then
                            if q == "" then
                                c.Visible = true
                            else
                                local t = ""
                                for _, d in ipairs(c:GetDescendants()) do
                                    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                                        t = t .. " " .. string.lower(d.Text or "")
                                    end
                                end
                                c.Visible = string.find(t, q) ~= nil
                            end
                        end
                    end
                end
            end
        end)

        local Tab = {Button = cont, Content = content, Name = name}

        local function EFrame(h)
            local f = Create("Frame", {
                Size = UDim2.new(1, 0, 0, h or 30),
                BackgroundColor3 = Library.Theme.Element, Parent = content
            })
            Corner(f, 4)
            RegisterTheme(f, "BackgroundColor3", "Element")
            return f
        end

        

        function Tab:AddSection(text, collapsed)
            local sec = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, Parent = content
            })
            local head = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "", Parent = sec
            })
            local arrow = Create("TextLabel", {
                Size = UDim2.new(0, 14, 1, 0), BackgroundTransparency = 1,
                Text = collapsed and "▶" or "▼", TextColor3 = Library.Theme.TextDim,
                Font = Enum.Font.GothamBold, TextSize = 9, Parent = head
            })
            Create("TextLabel", {
                Size = UDim2.new(1, -18, 1, 0), Position = UDim2.new(0, 16, 0, 0),
                BackgroundTransparency = 1, Text = tostring(text),
                TextColor3 = Library.Theme.TextDim, Font = Enum.Font.GothamBold,
                TextSize = 11.5, TextXAlignment = Enum.TextXAlignment.Left, Parent = head
            })
            local body = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, Visible = not collapsed, Parent = sec
            })
            Create("UIListLayout", {Padding = UDim.new(0, 4), Parent = body})
            Create("UIPadding", {PaddingTop = UDim.new(0, 2), Parent = body})
            local open = not collapsed
            
            local sectionKey = "Section_" .. tostring(text):gsub("%s+", "_")
            if Window.SectionStates and Window.SectionStates[sectionKey] ~= nil then
                open = Window.SectionStates[sectionKey]
            end
            body.Visible = open
            arrow.Text = open and "▼" or "▶"

            head.MouseButton1Click:Connect(function()
                PlaySound("Click", 0.2)
                open = not open
                body.Visible = open
                arrow.Text = open and "▼" or "▶"
                if not Window.SectionStates then Window.SectionStates = {} end
                Window.SectionStates[sectionKey] = open
            end)
            local proxy = {}
            for k, v in pairs(Tab) do
                if type(v) == "function" and k:sub(1, 3) == "Add" then
                    proxy[k] = function(_, ...)
                        local results = {v(Tab, ...)}
                        local last = results[1]
                        if last then
                            if type(last) == "table" and last.Frame then
                                last.Frame.Parent = body
                            elseif typeof(last) == "Instance" then
                                last.Parent = body
                            end
                        end
                        return unpack(results)
                    end
                end
            end
            proxy.Body = body
            return proxy
        end

        function Tab:AddLabel(text)
            return Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
                Text = "  " .. tostring(text), TextColor3 = Color3.fromRGB(155, 155, 165),
                Font = Enum.Font.Gotham, TextSize = 11.5,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = content
            })
        end

        function Tab:AddParagraph(title, body)
            local f = EFrame(0)
            f.AutomaticSize = Enum.AutomaticSize.Y
            Create("TextLabel", {
                Size = UDim2.new(1, -12, 0, 15), Position = UDim2.new(0, 8, 0, 5),
                BackgroundTransparency = 1, Text = title or "", TextColor3 = Library.Theme.Text,
                Font = Enum.Font.GothamBold, TextSize = 11.5,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            Create("TextLabel", {
                Size = UDim2.new(1, -12, 0, 0), Position = UDim2.new(0, 8, 0, 22),
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
                Text = body or "", TextColor3 = Library.Theme.TextDim, Font = Enum.Font.Gotham,
                TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = f
            })
            Create("UIPadding", {PaddingBottom = UDim.new(0, 7), Parent = f})
            return f
        end

        function Tab:AddSeparator()
            return Create("Frame", {
                Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Color3.fromRGB(48, 48, 54),
                BorderSizePixel = 0, Parent = content
            })
        end

        function Tab:AddButton(text, callback, tip, icon)
            local b = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Library.Theme.Element,
                Text = "  " .. text, TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamSemibold,
                TextSize = 12, AutoButtonColor = false, Parent = content
            })
            Corner(b, 4)
            RegisterTheme(b, "BackgroundColor3", "Element")

            if icon then
                Create("ImageLabel", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, 8, 0.5, -8),
                    BackgroundTransparency = 1,
                    Image = icon,
                    Parent = b
                })
                b.Text = "      " .. text
            end

            if tip then
                CreateTooltip(b, tip)
            end

            b.MouseEnter:Connect(function()
                Tween(b, {BackgroundColor3 = Library.Theme.ElementHover}, 0.1)
            end)
            b.MouseLeave:Connect(function()
                Tween(b, {BackgroundColor3 = Library.Theme.Element}, 0.1)
            end)
            b.MouseButton1Click:Connect(function()
                PlaySound("Click")
                if callback then pcall(callback) end
            end)
            return b
        end

        function Tab:AddToggle(text, default, callback, flag, onT, offT)
            onT = onT or "ON"
            offT = offT or "OFF"
            local f = EFrame(30)
            Create("TextLabel", {
                Size = UDim2.new(1, -110, 1, 0), Position = UDim2.new(0, 9, 0, 0),
                BackgroundTransparency = 1, Text = text, TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            local st = Create("TextLabel", {
                Size = UDim2.new(0, 55, 0, 16), Position = UDim2.new(1, -100, 0.5, -8),
                BackgroundTransparency = 1, Text = default and onT or offT,
                TextColor3 = default and Library.AccentColor or Library.Theme.TextDim,
                Font = Enum.Font.GothamSemibold, TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Right, Parent = f
            })
            local bg = Create("Frame", {
                Size = UDim2.new(0, 36, 0, 16), Position = UDim2.new(1, -44, 0.5, -8),
                BackgroundColor3 = default and Library.AccentColor or Color3.fromRGB(60, 60, 66), Parent = f
            })
            Corner(bg, 8)
            local kn = Create("Frame", {
                Size = UDim2.new(0, 12, 0, 12),
                Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
                BackgroundColor3 = Color3.new(1,1,1), Parent = bg
            })
            Corner(kn, 6)
            local state = default or false
            local function Up(s, fc)
                state = s
                PlaySound("Toggle", 0.2)
                Tween(bg, {BackgroundColor3 = state and Library.AccentColor or Color3.fromRGB(60, 60, 66)}, 0.12)
                Tween(kn, {Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}, 0.12)
                st.Text = state and onT or offT
                st.TextColor3 = state and Library.AccentColor or Library.Theme.TextDim
                if flag and not fc then Window.Flags[flag] = state end
                if callback then pcall(callback, state) end
            end
            f.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    Up(not state)
                end
            end)
            if flag then
                Window.Flags[flag] = state
                if Library.Configs[flag] ~= nil then Up(Library.Configs[flag], true) end
            end
            local o = {Frame = f}
            function o:Set(v) Up(v) end
            function o:Get() return state end
            if flag then table.insert(Window.Elements, {Flag = flag, Object = o, Type = "Toggle"}) end
            return o
        end

        function Tab:AddCheckbox(text, default, callback, flag)
            local f = EFrame(26)
            local box = Create("Frame", {
                Size = UDim2.new(0, 15, 0, 15), Position = UDim2.new(0, 8, 0.5, -7.5),
                BackgroundColor3 = default and Library.AccentColor or Color3.fromRGB(46, 46, 52), Parent = f
            })
            Corner(box, 3)
            local ck = Create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                Text = default and "✓" or "", TextColor3 = Color3.new(1,1,1),
                Font = Enum.Font.GothamBold, TextSize = 11, Parent = box
            })
            Create("TextLabel", {
                Size = UDim2.new(1, -32, 1, 0), Position = UDim2.new(0, 30, 0, 0),
                BackgroundTransparency = 1, Text = text, TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            local state = default or false
            local function Up(s)
                state = s
                PlaySound("Toggle", 0.2)
                box.BackgroundColor3 = state and Library.AccentColor or Color3.fromRGB(46, 46, 52)
                ck.Text = state and "✓" or ""
                if flag then Window.Flags[flag] = state end
                if callback then pcall(callback, state) end
            end
            f.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    Up(not state)
                end
            end)
            if flag then
                Window.Flags[flag] = state
                if Library.Configs[flag] ~= nil then Up(Library.Configs[flag]) end
            end
            local o = {Frame = f}
            function o:Set(v) Up(v) end
            function o:Get() return state end
            if flag then table.insert(Window.Elements, {Flag = flag, Object = o, Type = "Checkbox"}) end
            return o
        end

        function Tab:AddSlider(text, min, max, default, callback, flag, decimals)
            min, max, default = min or 0, max or 100, default or min
            decimals = decimals or 0
            local f = EFrame(48)
            Create("TextLabel", {
                Size = UDim2.new(1, -70, 0, 14), Position = UDim2.new(0, 8, 0, 4),
                BackgroundTransparency = 1, Text = text, TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham, TextSize = 11.5,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            local nb = Create("TextBox", {
                Size = UDim2.new(0, 44, 0, 16), Position = UDim2.new(1, -52, 0, 3),
                BackgroundColor3 = Color3.fromRGB(26, 26, 32), Text = tostring(default),
                TextColor3 = Library.AccentColor, Font = Enum.Font.GothamBold, TextSize = 11,
                ClearTextOnFocus = false, Parent = f
            })
            Corner(nb, 3)
            local track = Create("Frame", {
                Size = UDim2.new(1, -16, 0, 4), Position = UDim2.new(0, 8, 0, 32),
                BackgroundColor3 = Library.Theme.Track, Parent = f
            })
            Corner(track, 2)
            RegisterTheme(track, "BackgroundColor3", "Track")
            local fill = Create("Frame", {
                Size = UDim2.new((default-min)/math.max(max-min,1), 0, 1, 0),
                BackgroundColor3 = Library.AccentColor, Parent = track
            })
            Corner(fill, 2)
            RegisterTheme(fill, "BackgroundColor3", "Accent")
            local kn = Create("Frame", {
                Size = UDim2.new(0, 10, 0, 10),
                Position = UDim2.new((default-min)/math.max(max-min,1), -5, 0.5, -5),
                BackgroundColor3 = Color3.new(1,1,1), Parent = track
            })
            Corner(kn, 5)
            local drag, cur = false, default
            local function Up(v, fc)
                if decimals > 0 then
                    local mult = 10 ^ decimals
                    cur = math.clamp(math.floor(v * mult + 0.5) / mult, min, max)
                else
                    cur = math.clamp(math.floor(v + 0.5), min, max)
                end
                local p = (cur - min) / math.max(max - min, 1e-9)
                nb.Text = decimals > 0 and string.format("%."..decimals.."f", cur) or tostring(cur)
                Tween(fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.05)
                Tween(kn, {Position = UDim2.new(p, -5, 0.5, -5)}, 0.05)
                if flag and not fc then Window.Flags[flag] = cur end
                if callback then pcall(callback, cur) end
            end
            nb.FocusLost:Connect(function()
                local n = tonumber(nb.Text)
                if n then Up(n) else nb.Text = decimals > 0 and string.format("%."..decimals.."f", cur) or tostring(cur) end
            end)
            local function onIn(i)
                local r = math.clamp((i.Position.X - track.AbsolutePosition.X)/track.AbsoluteSize.X, 0, 1)
                Up(min + (max-min)*r)
            end
            kn.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true end
            end)
            track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then onIn(i) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then onIn(i) end
            end)
            if flag then
                Window.Flags[flag] = cur
                if Library.Configs[flag] ~= nil then Up(Library.Configs[flag], true) end
            end
            local o = {Frame = f}
            function o:Set(v) Up(v) end
            function o:Get() return cur end
            if flag then table.insert(Window.Elements, {Flag = flag, Object = o, Type = "Slider"}) end
            return o
        end

        function Tab:AddDropdown(text, options, default, callback, flag)
            options = options or {"A"}
            default = default or options[1]
            local f = EFrame(30)
            Create("TextLabel", {
                Size = UDim2.new(0.35, 0, 1, 0), Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1, Text = text, TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            local sel = Create("TextButton", {
                Size = UDim2.new(0.62, -4, 0, 20), Position = UDim2.new(0.36, 0, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(28, 28, 34), Text = "  " .. tostring(default),
                TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamSemibold, TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, Parent = f
            })
            Corner(sel, 3)
            local list = Create("ScrollingFrame", {
                Size = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(26, 26, 32),
                Visible = false, ZIndex = 120, AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2, Parent = Main
            })
            Corner(list, 4)
            Stroke(list, Color3.fromRGB(50, 50, 56), 1)
            Create("UIListLayout", {Padding = UDim.new(0, 1), Parent = list})
            local open, cur = false, default
            local function close()
                if not open then return end
                open = false
                Tween(list, {Size = UDim2.new(0, list.AbsoluteSize.X, 0, 0)}, 0.1)
                task.wait(0.11)
                list.Visible = false
            end
            sel.MouseButton1Click:Connect(function()
                PlaySound("Click", 0.25)
                if open then close() return end
                ClosePopups()
                table.insert(Window.OpenPopups, {Close = close})
                open = true
                list.Visible = true
                local ap, as, mp = sel.AbsolutePosition, sel.AbsoluteSize, Main.AbsolutePosition
                local listHeight = math.min(#options * 22 + 4, 130)
                local posY = ap.Y - mp.Y + as.Y + 2
                
                if ap.Y + as.Y + listHeight > workspace.CurrentCamera.ViewportSize.Y - 20 then
                    posY = ap.Y - mp.Y - listHeight - 2
                end
                list.Position = UDim2.fromOffset(ap.X - mp.X, posY)
                Tween(list, {Size = UDim2.new(0, as.X, 0, listHeight)}, 0.12)
            end)
            for _, opt in ipairs(options) do
                local b = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 21), BackgroundColor3 = Color3.fromRGB(26, 26, 32),
                    Text = "  " .. opt, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham,
                    TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false, ZIndex = 121, Parent = list
                })
                b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = Color3.fromRGB(40, 40, 46)}, 0.07) end)
                b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = Color3.fromRGB(26, 26, 32)}, 0.07) end)
                b.MouseButton1Click:Connect(function()
                    PlaySound("Click", 0.25)
                    cur = opt
                    sel.Text = "  " .. opt
                    if flag then Window.Flags[flag] = opt end
                    if callback then pcall(callback, opt) end
                    close()
                end)
            end
            if flag then
                Window.Flags[flag] = cur
                if Library.Configs[flag] then sel.Text = "  " .. Library.Configs[flag] cur = Library.Configs[flag] end
            end
            local o = {Frame = f}
            function o:Set(v) sel.Text = "  " .. tostring(v) cur = v if flag then Window.Flags[flag] = v end end
            function o:Get() return cur end
            if flag then table.insert(Window.Elements, {Flag = flag, Object = o, Type = "Dropdown"}) end
            return o
        end

        
        function Tab:AddSearchDropdown(text, options, default, callback, flag)
            options = options or {"A", "B", "C"}
            default = default or options[1]

            local f = EFrame(30)
            Create("TextLabel", {
                Size = UDim2.new(0.35, 0, 1, 0), Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1, Text = text, TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })

            local sel = Create("TextButton", {
                Size = UDim2.new(0.62, -4, 0, 20), Position = UDim2.new(0.36, 0, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(28, 28, 34), Text = "  " .. tostring(default),
                TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamSemibold, TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, Parent = f
            })
            Corner(sel, 3)

            local list = Create("Frame", {
                Size = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(22, 22, 28),
                Visible = false, ZIndex = 130, Parent = Main
            })
            Corner(list, 4)
            Stroke(list, Color3.fromRGB(50, 50, 56), 1)

            
            local searchBox = Create("TextBox", {
                Size = UDim2.new(1, -8, 0, 22), Position = UDim2.new(0, 4, 0, 4),
                BackgroundColor3 = Color3.fromRGB(30, 30, 36), Text = "",
                PlaceholderText = "Search...", TextColor3 = Library.Theme.Text,
                PlaceholderColor3 = Color3.fromRGB(120, 120, 130), Font = Enum.Font.Gotham,
                TextSize = 11, ClearTextOnFocus = false, ZIndex = 131, Parent = list
            })
            Corner(searchBox, 3)

            local scroll = Create("ScrollingFrame", {
                Size = UDim2.new(1, -4, 1, -30), Position = UDim2.new(0, 2, 0, 28),
                BackgroundTransparency = 1, ScrollBarThickness = 2,
                AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 131, Parent = list
            })
            Create("UIListLayout", {Padding = UDim.new(0, 1), Parent = scroll})

            local open = false
            local cur = default
            local optionButtons = {}

            local function close()
                if not open then return end
                open = false
                Tween(list, {Size = UDim2.new(0, list.AbsoluteSize.X, 0, 0)}, 0.1)
                task.wait(0.1)
                list.Visible = false
                searchBox.Text = ""
            end

            local function refreshList(filter)
                for _, child in ipairs(scroll:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                optionButtons = {}

                for _, opt in ipairs(options) do
                    if not filter or string.find(string.lower(opt), string.lower(filter), 1, true) then
                        local b = Create("TextButton", {
                            Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = Color3.fromRGB(26, 26, 32),
                            Text = "  " .. opt, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham,
                            TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                            AutoButtonColor = false, ZIndex = 132, Parent = scroll
                        })
                        optionButtons[opt] = b

                        b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = Color3.fromRGB(40, 40, 46)}, 0.07) end)
                        b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = Color3.fromRGB(26, 26, 32)}, 0.07) end)

                        b.MouseButton1Click:Connect(function()
                            PlaySound("Click", 0.25)
                            cur = opt
                            sel.Text = "  " .. opt
                            if flag then Window.Flags[flag] = opt end
                            if callback then pcall(callback, opt) end
                            close()
                        end)
                    end
                end
            end

            sel.MouseButton1Click:Connect(function()
                PlaySound("Click", 0.25)
                if open then close() return end
                ClosePopups()
                table.insert(Window.OpenPopups, {Close = close})
                open = true
                list.Visible = true
                local ap, as, mp = sel.AbsolutePosition, sel.AbsoluteSize, Main.AbsolutePosition
                list.Position = UDim2.fromOffset(ap.X - mp.X, ap.Y - mp.Y + as.Y + 2)
                list.Size = UDim2.new(0, as.X, 0, 180)
                refreshList()
                searchBox:CaptureFocus()
            end)

            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                refreshList(searchBox.Text)
            end)

            
            if flag then
                Window.Flags[flag] = cur
                if Library.Configs[flag] then
                    cur = Library.Configs[flag]
                    sel.Text = "  " .. cur
                end
            end

            local o = {Frame = f}
            function o:Set(v)
                cur = v
                sel.Text = "  " .. tostring(v)
                if flag then Window.Flags[flag] = v end
            end
            function o:Get() return cur end

            if flag then table.insert(Window.Elements, {Flag = flag, Object = o, Type = "SearchDropdown"}) end
            return o
        end

        function Tab:AddMultiDropdown(text, options, default, callback, flag)
            options = options or {"A", "B"}
            default = default or {}
            local f = EFrame(30)
            Create("TextLabel", {
                Size = UDim2.new(0.35, 0, 1, 0), Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1, Text = text, TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            local selected = {}
            for _, v in ipairs(default) do selected[v] = true end
            
            if flag and Library.Configs[flag] and type(Library.Configs[flag]) == "table" then
                selected = {}
                for _, v in ipairs(Library.Configs[flag]) do selected[v] = true end
            end
            local function getSelectedList()
                local t = {}
                for k, v in pairs(selected) do if v then table.insert(t, k) end end
                return t
            end
            local sel = Create("TextButton", {
                Size = UDim2.new(0.62, -4, 0, 20), Position = UDim2.new(0.36, 0, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(28, 28, 34),
                Text = "  " .. (#getSelectedList() > 0 and table.concat(getSelectedList(), ", ") or L("None")),
                TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamSemibold, TextSize = 10.5,
                TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, Parent = f
            })
            Corner(sel, 3)
            local list = Create("ScrollingFrame", {
                Size = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(26, 26, 32),
                Visible = false, ZIndex = 120, AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2, Parent = Main
            })
            Corner(list, 4)
            Stroke(list, Color3.fromRGB(50, 50, 56), 1)
            Create("UIListLayout", {Padding = UDim.new(0, 1), Parent = list})
            local open = false
            local optionButtons = {}
            local function upd()
                local t = getSelectedList()
                sel.Text = "  " .. (#t > 0 and table.concat(t, ", ") or L("None"))
                if flag then Window.Flags[flag] = t end
                if callback then pcall(callback, t) end
            end
            local function close()
                if not open then return end
                open = false
                Tween(list, {Size = UDim2.new(0, list.AbsoluteSize.X, 0, 0)}, 0.1)
                task.wait(0.11)
                list.Visible = false
            end
            sel.MouseButton1Click:Connect(function()
                PlaySound("Click", 0.25)
                if open then close() return end
                ClosePopups()
                table.insert(Window.OpenPopups, {Close = close})
                open = true
                list.Visible = true
                local ap, as, mp = sel.AbsolutePosition, sel.AbsoluteSize, Main.AbsolutePosition
                list.Position = UDim2.fromOffset(ap.X - mp.X, ap.Y - mp.Y + as.Y + 2)
                Tween(list, {Size = UDim2.new(0, as.X, 0, math.min(#options*22+4, 130))}, 0.12)
            end)
            for _, opt in ipairs(options) do
                local b = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 21), BackgroundColor3 = Color3.fromRGB(26, 26, 32),
                    Text = "  " .. (selected[opt] and "✓ " or "   ") .. opt,
                    TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false,
                    ZIndex = 121, Parent = list
                })
                optionButtons[opt] = b
                b.MouseButton1Click:Connect(function()
                    selected[opt] = not selected[opt]
                    b.Text = "  " .. (selected[opt] and "✓ " or "   ") .. opt
                    upd()
                end)
            end
            local o = {Frame = f}
            function o:Get() return getSelectedList() end
            function o:Set(tbl)
                if type(tbl) ~= "table" then return end
                selected = {}
                for _, v in ipairs(tbl) do selected[v] = true end
                for opt, b in pairs(optionButtons) do
                    b.Text = "  " .. (selected[opt] and "✓ " or "   ") .. opt
                end
                upd()
            end
            if flag then
                Window.Flags[flag] = getSelectedList()
                table.insert(Window.Elements, {Flag = flag, Object = o, Type = "MultiDropdown"})
            end
            return o
        end

        function Tab:AddTextbox(text, default, ph, callback, flag)
            local f = EFrame(44)
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 8, 0, 3),
                BackgroundTransparency = 1, Text = text, TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham, TextSize = 11.5,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            local box = Create("TextBox", {
                Size = UDim2.new(1, -16, 0, 18), Position = UDim2.new(0, 8, 0, 20),
                BackgroundColor3 = Color3.fromRGB(24, 24, 30), Text = default or "",
                PlaceholderText = ph or "...", TextColor3 = Library.Theme.Text,
                PlaceholderColor3 = Color3.fromRGB(90, 90, 100), Font = Enum.Font.Gotham,
                TextSize = 11.5, ClearTextOnFocus = false, Parent = f
            })
            Corner(box, 3)
            box.FocusLost:Connect(function()
                if flag then Window.Flags[flag] = box.Text end
                if callback then pcall(callback, box.Text) end
            end)
            if flag then
                Window.Flags[flag] = box.Text
                if Library.Configs[flag] then box.Text = Library.Configs[flag] end
            end
            local o = {Frame = f, Box = box}
            function o:Set(v) box.Text = tostring(v or "") if flag then Window.Flags[flag] = box.Text end end
            function o:Get() return box.Text end
            if flag then table.insert(Window.Elements, {Flag = flag, Object = o, Type = "Textbox"}) end
            return o
        end

        function Tab:AddKeybind(text, default, callback, flag)
            default = default or Enum.KeyCode.Unknown
            local f = EFrame(30)
            Create("TextLabel", {
                Size = UDim2.new(1, -90, 1, 0), Position = UDim2.new(0, 9, 0, 0),
                BackgroundTransparency = 1, Text = text, TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            local btn = Create("TextButton", {
                Size = UDim2.new(0, 72, 0, 18), Position = UDim2.new(1, -82, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(28, 28, 34), Text = default.Name or "None",
                TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamSemibold, TextSize = 10.5,
                AutoButtonColor = false, Parent = f
            })
            Corner(btn, 3)
            local cur, listening = default, false
            local function Up(k)
                if type(k) == "string" then
                    local ok, enumK = pcall(function() return Enum.KeyCode[k] end)
                    k = (ok and enumK) or Enum.KeyCode.Unknown
                end
                cur = k
                btn.Text = (k and k.Name) or "None"
                if flag then Window.Flags[flag] = btn.Text end
            end
            
            if flag and Library.Configs[flag] then
                Up(Library.Configs[flag])
            end
            btn.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                btn.Text = "..."
                local c
                c = UserInputService.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.Keyboard then
                        Up(i.KeyCode == Enum.KeyCode.Escape and Enum.KeyCode.Unknown or i.KeyCode)
                        listening = false
                        c:Disconnect()
                    end
                end)
            end)
            UserInputService.InputBegan:Connect(function(i, gp)
                if gp or listening then return end
                if cur and cur ~= Enum.KeyCode.Unknown and i.KeyCode == cur then
                    if callback then pcall(callback) end
                end
            end)
            local o = {Frame = f}
            function o:Set(k) Up(k) end
            function o:Get() return cur end
            if flag then table.insert(Window.Elements, {Flag = flag, Object = o, Type = "Keybind"}) end
            return o
        end

        function Tab:AddBind(text, defaultKey, defaultState, mode, callback, flag)
            mode = mode or "Toggle"
            defaultKey = defaultKey or Enum.KeyCode.Unknown
            defaultState = defaultState or false
            local f = EFrame(30)
            Create("TextLabel", {
                Size = UDim2.new(1, -175, 1, 0), Position = UDim2.new(0, 9, 0, 0),
                BackgroundTransparency = 1, Text = text, TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            local modeBtn = Create("TextButton", {
                Size = UDim2.new(0, 46, 0, 16), Position = UDim2.new(1, -160, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(34, 34, 40), Text = mode,
                TextColor3 = Library.Theme.TextDim, Font = Enum.Font.GothamSemibold, TextSize = 9.5,
                AutoButtonColor = false, Parent = f
            })
            Corner(modeBtn, 3)
            local keyBtn = Create("TextButton", {
                Size = UDim2.new(0, 52, 0, 16), Position = UDim2.new(1, -108, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(28, 28, 34),
                Text = (defaultKey.Name or "None") .. " [" .. mode:sub(1,1) .. "]",
                TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamSemibold, TextSize = 9.5,
                AutoButtonColor = false, Parent = f
            })
            Corner(keyBtn, 3)
            local state = defaultState
            local tbg = Create("Frame", {
                Size = UDim2.new(0, 34, 0, 15), Position = UDim2.new(1, -44, 0.5, -7.5),
                BackgroundColor3 = state and Library.AccentColor or Color3.fromRGB(60, 60, 66), Parent = f
            })
            Corner(tbg, 7)
            local kn = Create("Frame", {
                Size = UDim2.new(0, 11, 0, 11),
                Position = state and UDim2.new(1, -13, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5),
                BackgroundColor3 = Color3.new(1,1,1), Parent = tbg
            })
            Corner(kn, 6)
            local curKey, listening, curMode = defaultKey, false, mode
            local function refreshKeyText()
                keyBtn.Text = (curKey.Name or "None") .. " [" .. curMode:sub(1,1) .. "]"
            end
            local function UpT(s)
                state = s
                PlaySound("Toggle", 0.2)
                Tween(tbg, {BackgroundColor3 = state and Library.AccentColor or Color3.fromRGB(60, 60, 66)}, 0.1)
                Tween(kn, {Position = state and UDim2.new(1, -13, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5)}, 0.1)
                if flag then Window.Flags[flag .. "_S"] = state end
                if callback then pcall(callback, state, curKey, curMode) end
            end
            modeBtn.MouseButton1Click:Connect(function()
                PlaySound("Click", 0.2)
                curMode = curMode == "Toggle" and "Hold" or "Toggle"
                modeBtn.Text = curMode
                refreshKeyText()
                if flag then Window.Flags[flag .. "_M"] = curMode end
            end)
            tbg.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    UpT(not state)
                end
            end)
            keyBtn.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                keyBtn.Text = "..."
                local c
                c = UserInputService.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.Keyboard then
                        if i.KeyCode ~= Enum.KeyCode.Escape then
                            curKey = i.KeyCode
                            if flag then Window.Flags[flag .. "_K"] = curKey.Name end
                        end
                        refreshKeyText()
                        listening = false
                        c:Disconnect()
                    end
                end)
            end)
            UserInputService.InputBegan:Connect(function(i, gp)
                if gp or listening then return end
                if curKey and curKey ~= Enum.KeyCode.Unknown and i.KeyCode == curKey then
                    if curMode == "Toggle" then UpT(not state) else UpT(true) end
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if curMode == "Hold" and curKey and i.KeyCode == curKey then UpT(false) end
            end)
            
            if flag then
                if Library.Configs[flag .. "_S"] ~= nil then state = Library.Configs[flag .. "_S"] UpT(state) end
                if Library.Configs[flag .. "_M"] then curMode = Library.Configs[flag .. "_M"] modeBtn.Text = curMode end
                if Library.Configs[flag .. "_K"] then
                    local kn = Library.Configs[flag .. "_K"]
                    local ok, ek = pcall(function() return Enum.KeyCode[kn] end)
                    if ok and ek then curKey = ek end
                end
                refreshKeyText()
                Window.Flags[flag .. "_S"] = state
                Window.Flags[flag .. "_M"] = curMode
                Window.Flags[flag .. "_K"] = curKey.Name
            end
            local o = {Frame = f}
            function o:Set(s) UpT(s) end
            function o:Get() return state, curKey, curMode end
            function o:SetFromConfig(s, kName, m)
                if s ~= nil then UpT(s) end
                if m then curMode = m modeBtn.Text = m end
                if kName then
                    local ok, ek = pcall(function() return Enum.KeyCode[kName] end)
                    if ok and ek then curKey = ek end
                end
                refreshKeyText()
                if flag then
                    Window.Flags[flag .. "_S"] = state
                    Window.Flags[flag .. "_M"] = curMode
                    Window.Flags[flag .. "_K"] = curKey.Name
                end
            end
            if flag then table.insert(Window.Elements, {Flag = flag, Object = o, Type = "Bind", MultiFlag = true}) end
            return o
        end

        function Tab:AddColorPicker(text, default, callback, flag)
            default = default or Library.AccentColor
            local f = EFrame(30)
            Create("TextLabel", {
                Size = UDim2.new(1, -48, 1, 0), Position = UDim2.new(0, 9, 0, 0),
                BackgroundTransparency = 1, Text = text, TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            local prev = Create("TextButton", {
                Size = UDim2.new(0, 22, 0, 16), Position = UDim2.new(1, -34, 0.5, -8),
                BackgroundColor3 = default, Text = "", AutoButtonColor = false, Parent = f
            })
            Corner(prev, 3)
            local cur, open = default, false
            local pal = Create("Frame", {
                Size = UDim2.new(0, 200, 0, 0), BackgroundColor3 = Color3.fromRGB(20, 20, 26),
                Visible = false, ZIndex = 130, Parent = Main
            })
            Corner(pal, 5)
            Stroke(pal, Color3.fromRGB(48, 48, 54), 1)

            local rBox = Create("TextBox", {
                Size = UDim2.new(0, 40, 0, 18), Position = UDim2.new(0, 8, 0, 8),
                BackgroundColor3 = Color3.fromRGB(30, 30, 36), Text = "R",
                TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham, TextSize = 10,
                ClearTextOnFocus = false, ZIndex = 131, Parent = pal
            })
            Corner(rBox, 3)
            local gBox = Create("TextBox", {
                Size = UDim2.new(0, 40, 0, 18), Position = UDim2.new(0, 52, 0, 8),
                BackgroundColor3 = Color3.fromRGB(30, 30, 36), Text = "G",
                TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham, TextSize = 10,
                ClearTextOnFocus = false, ZIndex = 131, Parent = pal
            })
            Corner(gBox, 3)
            local bBox = Create("TextBox", {
                Size = UDim2.new(0, 40, 0, 18), Position = UDim2.new(0, 96, 0, 8),
                BackgroundColor3 = Color3.fromRGB(30, 30, 36), Text = "B",
                TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham, TextSize = 10,
                ClearTextOnFocus = false, ZIndex = 131, Parent = pal
            })
            Corner(bBox, 3)
            local hexBox = Create("TextBox", {
                Size = UDim2.new(0, 54, 0, 18), Position = UDim2.new(0, 140, 0, 8),
                BackgroundColor3 = Color3.fromRGB(30, 30, 36), Text = "#00C882",
                TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham, TextSize = 10,
                ClearTextOnFocus = false, ZIndex = 131, Parent = pal
            })
            Corner(hexBox, 3)

            local function setColor(col)
                cur = col
                prev.BackgroundColor3 = col
                rBox.Text = tostring(math.floor(col.R * 255))
                gBox.Text = tostring(math.floor(col.G * 255))
                bBox.Text = tostring(math.floor(col.B * 255))
                hexBox.Text = string.format("#%02X%02X%02X", col.R*255, col.G*255, col.B*255)
                if flag then
                    Window.Flags[flag] = {R = math.floor(col.R*255), G = math.floor(col.G*255), B = math.floor(col.B*255)}
                end
                if callback then pcall(callback, col) end
            end

            local function applyRGB()
                local r = tonumber(rBox.Text) or 0
                local g = tonumber(gBox.Text) or 0
                local b = tonumber(bBox.Text) or 0
                setColor(Color3.fromRGB(math.clamp(r,0,255), math.clamp(g,0,255), math.clamp(b,0,255)))
            end
            rBox.FocusLost:Connect(applyRGB)
            gBox.FocusLost:Connect(applyRGB)
            bBox.FocusLost:Connect(applyRGB)
            hexBox.FocusLost:Connect(function()
                local h = hexBox.Text:gsub("#", "")
                if #h == 6 then
                    local r = tonumber(h:sub(1,2), 16) or 0
                    local g = tonumber(h:sub(3,4), 16) or 0
                    local b = tonumber(h:sub(5,6), 16) or 0
                    setColor(Color3.fromRGB(r, g, b))
                end
            end)

            local colors = {
                Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 130, 40),
                Color3.fromRGB(255, 210, 40), Color3.fromRGB(60, 210, 60),
                Color3.fromRGB(0, 200, 130), Color3.fromRGB(40, 170, 255),
                Color3.fromRGB(70, 90, 255), Color3.fromRGB(170, 60, 255),
                Color3.fromRGB(255, 60, 170), Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(140, 140, 140), Color3.fromRGB(40, 40, 45),
            }
            for i, col in ipairs(colors) do
                local b = Create("TextButton", {
                    Size = UDim2.new(0, 22, 0, 22),
                    Position = UDim2.new(0, 8 + ((i-1)%6)*30, 0, 34 + math.floor((i-1)/6)*28),
                    BackgroundColor3 = col, Text = "", AutoButtonColor = false,
                    ZIndex = 131, Parent = pal
                })
                Corner(b, 3)
                b.MouseButton1Click:Connect(function()
                    PlaySound("Click", 0.2)
                    setColor(col)
                end)
            end

            local function close()
                if not open then return end
                open = false
                Tween(pal, {Size = UDim2.new(0, 200, 0, 0)}, 0.1)
                task.wait(0.11)
                pal.Visible = false
            end

            prev.MouseButton1Click:Connect(function()
                PlaySound("Click", 0.25)
                if open then close() return end
                ClosePopups()
                table.insert(Window.OpenPopups, {Close = close})
                open = true
                pal.Visible = true
                setColor(cur)
                local ap, mp = prev.AbsolutePosition, Main.AbsolutePosition
                pal.Position = UDim2.fromOffset(ap.X - mp.X - 170, ap.Y - mp.Y + 22)
                Tween(pal, {Size = UDim2.new(0, 200, 0, 100)}, 0.12)
            end)

            if flag then
                Window.Flags[flag] = {R = math.floor(default.R*255), G = math.floor(default.G*255), B = math.floor(default.B*255)}
                if Library.Configs[flag] and type(Library.Configs[flag]) == "table" then
                    local c = Library.Configs[flag]
                    cur = Color3.fromRGB(c.R or 0, c.G or 0, c.B or 0)
                    prev.BackgroundColor3 = cur
                    setColor(cur)
                end
            end
            local o = {Frame = f}
            function o:Set(c)
                if type(c) == "table" then c = Color3.fromRGB(c.R or 0, c.G or 0, c.B or 0) end
                setColor(c)
            end
            function o:Get() return cur end
            if flag then table.insert(Window.Elements, {Flag = flag, Object = o, Type = "ColorPicker"}) end
            return o
        end

        function Tab:AddAccentPicker()
            return Tab:AddColorPicker(L("AccentColor"), Library.AccentColor, function(c)
                Library.AccentColor = c
                Library.RainbowEnabled = false
                ApplyTheme()
            end, "Accent")
        end

        
        function Tab:AddThemeEditor()
            local f = EFrame(0)
            f.AutomaticSize = Enum.AutomaticSize.Y

            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 18), Position = UDim2.new(0, 8, 0, 4),
                BackgroundTransparency = 1, Text = "Theme Editor",
                TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })

            Create("TextLabel", {
                Size = UDim2.new(1, -16, 0, 28), Position = UDim2.new(0, 8, 0, 24),
                BackgroundTransparency = 1,
                Text = "Change the current theme colors. Changes will be applied immediately",
                TextColor3 = Library.Theme.TextDim, Font = Enum.Font.Gotham, TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = f
            })

            
            Tab:AddDropdown("Theme Preset", {
                "Dark", "Light", "Purple", "Blue", "Red", "Green", "Pink", "Orange",
                "Cyan", "Gold", "Emerald", "Rose", "Midnight", "Discord", "Dracula",
                "Nord", "Ocean", "Neon"
            }, Library.CurrentTheme, function(v)
                if Library.Themes[v] then
                    Library.Theme = Library.Themes[v]
                    Library.CurrentTheme = v
                    ApplyTheme()
                    Library:Notify("Theme", "Switched to " .. v, 1.5)
                end
            end, "ThemePreset")

            
            Tab:AddColorPicker("Accent Color", Library.AccentColor, function(c)
                Library.AccentColor = c
                Library.RainbowEnabled = false
                ApplyTheme()
            end, "ThemeAccent")

            
            local themeKeys = {
                {key = "Background", name = "Background"},
                {key = "Header", name = "Header"},
                {key = "Sidebar", name = "Sidebar"},
                {key = "Content", name = "Content"},
                {key = "Element", name = "Element"},
                {key = "ElementHover", name = "Element Hover"},
                {key = "Text", name = "Text"},
                {key = "TextDim", name = "Text Dim"},
                {key = "Stroke", name = "Stroke"},
                {key = "Track", name = "Track"},
            }

            for _, info in ipairs(themeKeys) do
                local current = Library.Theme[info.key] or Color3.fromRGB(40,40,40)
                Tab:AddColorPicker(info.name, current, function(c)
                    Library.Theme[info.key] = c
                    ApplyTheme()
                end, "Theme_" .. info.key)
            end

            
            Tab:AddButton("Reset Theme to Default", function()
                Library.Theme = Library.Themes[Library.CurrentTheme] or Library.Themes.Dark
                ApplyTheme()
                Library:Notify("Theme", "Theme reset to default", 1.5, "success")
            end, "Reset to the original theme")

            return f
        end

        
        function Tab:AddHSVColorPicker(text, default, callback, flag)
            default = default or {H = 0.5, S = 0.85, V = 1, A = 1}

            
            if type(default) == "table" and default.R then
                local r, g, b = default.R / 255, default.G / 255, default.B / 255
                local max = math.max(r, g, b)
                local min = math.min(r, g, b)
                local h, s, v = 0, 0, max
                local d = max - min
                s = max == 0 and 0 or d / max
                if max == min then
                    h = 0
                elseif max == r then
                    h = (g - b) / d + (g < b and 6 or 0)
                elseif max == g then
                    h = (b - r) / d + 2
                elseif max == b then
                    h = (r - g) / d + 4
                end
                default = {H = h / 6, S = s, V = v, A = default.A or 1}
            end

            local f = EFrame(125)
            Create("TextLabel", {
                Size = UDim2.new(1, -12, 0, 16), Position = UDim2.new(0, 8, 0, 4),
                BackgroundTransparency = 1, Text = text or "Color (HSV)",
                TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })

            
            local preview = Create("Frame", {
                Size = UDim2.new(0, 55, 0, 55), Position = UDim2.new(0, 10, 0, 24),
                BackgroundColor3 = Color3.fromHSV(default.H, default.S, default.V),
                Parent = f
            })
            Corner(preview, 6)
            Stroke(preview, Color3.fromRGB(50, 50, 60), 1.5)

            local current = {
                H = default.H or 0.5,
                S = default.S or 0.85,
                V = default.V or 1,
                A = default.A or 1
            }

            local function updatePreview()
                preview.BackgroundColor3 = Color3.fromHSV(current.H, current.S, current.V)
                if flag then
                    Window.Flags[flag] = {H = current.H, S = current.S, V = current.V, A = current.A}
                end
                if callback then
                    pcall(callback, Color3.fromHSV(current.H, current.S, current.V), current.A)
                end
            end

            
            local function makeSlider(yPos, label, getVal, setVal, colorFunc)
                Create("TextLabel", {
                    Size = UDim2.new(0, 18, 0, 14), Position = UDim2.new(0, 75, 0, yPos),
                    BackgroundTransparency = 1, Text = label, TextColor3 = Library.Theme.TextDim,
                    Font = Enum.Font.Gotham, TextSize = 10, Parent = f
                })

                local track = Create("Frame", {
                    Size = UDim2.new(0, 155, 0, 8), Position = UDim2.new(0, 95, 0, yPos + 3),
                    BackgroundColor3 = Color3.fromRGB(35, 35, 42), Parent = f
                })
                Corner(track, 4)

                local fill = Create("Frame", {
                    Size = UDim2.new(getVal(), 0, 1, 0),
                    BackgroundColor3 = colorFunc and colorFunc() or Library.AccentColor,
                    Parent = track
                })
                Corner(fill, 4)

                local knob = Create("Frame", {
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(getVal(), -6, 0.5, -6),
                    BackgroundColor3 = Color3.new(1,1,1),
                    Parent = track
                })
                Corner(knob, 6)
                Stroke(knob, Color3.fromRGB(30,30,35), 1)

                local dragging = false

                local function updateFromPos(x)
                    local p = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    setVal(p)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    knob.Position = UDim2.new(p, -6, 0.5, -6)
                    updatePreview()
                end

                knob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end)

                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        updateFromPos(input.Position.X)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateFromPos(input.Position.X)
                    end
                end)

                return {
                    Set = function(v)
                        fill.Size = UDim2.new(v, 0, 1, 0)
                        knob.Position = UDim2.new(v, -6, 0.5, -6)
                    end
                }
            end

            
            local hVal = current.H
            local hSlider = makeSlider(24, "H", function() return hVal end, function(v) hVal = v; current.H = v end)

            
            local sVal = current.S
            local sSlider = makeSlider(44, "S", function() return sVal end, function(v) sVal = v; current.S = v end)

            
            local vVal = current.V
            local vSlider = makeSlider(64, "V", function() return vVal end, function(v) vVal = v; current.V = v end)

            
            local aVal = current.A
            local aSlider = makeSlider(84, "A", function() return aVal end, function(v) aVal = v; current.A = v end)

            
            local presets = {
                Color3.fromHSV(0, 0.9, 1), Color3.fromHSV(0.08, 0.9, 1),
                Color3.fromHSV(0.15, 0.9, 1), Color3.fromHSV(0.33, 0.85, 0.95),
                Color3.fromHSV(0.55, 0.85, 1), Color3.fromHSV(0.75, 0.8, 1),
                Color3.fromHSV(0.9, 0.85, 1), Color3.fromHSV(0, 0, 1)
            }

            for i, col in ipairs(presets) do
                local btn = Create("TextButton", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, 75 + ((i-1) % 4) * 20, 0, 102),
                    BackgroundColor3 = col, Text = "", Parent = f
                })
                Corner(btn, 3)
                btn.MouseButton1Click:Connect(function()
                    local h, s, v = Color3.toHSV(col)
                    current.H, current.S, current.V = h, s, v
                    hSlider.Set(h)
                    sSlider.Set(s)
                    vSlider.Set(v)
                    updatePreview()
                end)
            end

            updatePreview()

            if flag then
                Window.Flags[flag] = current
                if Library.Configs[flag] and type(Library.Configs[flag]) == "table" then
                    current = Library.Configs[flag]
                    hSlider.Set(current.H or 0.5)
                    sSlider.Set(current.S or 0.85)
                    vSlider.Set(current.V or 1)
                    aSlider.Set(current.A or 1)
                    updatePreview()
                end
            end

            local o = {Frame = f, Preview = preview}
            function o:Set(tbl)
                if type(tbl) == "table" then
                    current = tbl
                    hSlider.Set(current.H or 0)
                    sSlider.Set(current.S or 0)
                    vSlider.Set(current.V or 0)
                    aSlider.Set(current.A or 1)
                    updatePreview()
                end
            end
            function o:Get() return current end

            if flag then
                table.insert(Window.Elements, {Flag = flag, Object = o, Type = "HSVColorPicker"})
            end
            return o
        end

        
        function Tab:AddESPPreview()
            local f = EFrame(140)
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 8, 0, 3),
                BackgroundTransparency = 1, Text = "ESP Preview", TextColor3 = Library.Theme.Text,
                Font = Enum.Font.GothamBold, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            local canvas = Create("Frame", {
                Size = UDim2.new(1, -16, 1, -28), Position = UDim2.new(0, 8, 0, 22),
                BackgroundColor3 = Color3.fromRGB(18, 18, 24), ClipsDescendants = true, Parent = f
            })
            Corner(canvas, 4)

            
            local box = Create("Frame", {
                Size = UDim2.new(0, 40, 0, 70),
                Position = UDim2.new(0.5, -20, 0.5, -35),
                BackgroundTransparency = 1, Parent = canvas
            })
            Stroke(box, Library.AccentColor, 1.5)
            RegisterTheme(box:FindFirstChildOfClass("UIStroke"), "Color", "Accent")

            local head = Create("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0.5, -8, 0, -20),
                BackgroundTransparency = 1, Parent = box
            })
            Stroke(head, Library.AccentColor, 1.2)

            local nameTag = Create("TextLabel", {
                Size = UDim2.new(0, 80, 0, 14),
                Position = UDim2.new(0.5, -40, 0, -38),
                BackgroundTransparency = 1, Text = "Player",
                TextColor3 = Library.AccentColor, Font = Enum.Font.GothamBold, TextSize = 10, Parent = box
            })
            RegisterTheme(nameTag, "TextColor3", "Accent")

            local dist = Create("TextLabel", {
                Size = UDim2.new(0, 60, 0, 12),
                Position = UDim2.new(0.5, -30, 1, 4),
                BackgroundTransparency = 1, Text = "25m",
                TextColor3 = Color3.fromRGB(180, 180, 190), Font = Enum.Font.Gotham, TextSize = 9, Parent = box
            })

            return f
        end

        
        local ESPObjects = {}
        local ESPEnabled = false
        local FOVCircle = nil
        local ESPSettings = {
            Boxes = true,
            Names = true,
            Distance = true,
            Tracers = false,
            HealthBar = true,
            TeamCheck = false,
            MaxDistance = 1000,
            BoxColor = Color3.fromRGB(0, 255, 130),
            NameColor = Color3.fromRGB(255, 255, 255),
            TracerColor = Color3.fromRGB(255, 255, 255),
            HealthColor = Color3.fromRGB(0, 255, 100),
            
            FOVEnabled = false,
            FOVRadius = 120,
            FOVColor = Color3.fromRGB(255, 255, 255),
            FOVThickness = 1.5
        }

        local function ClearESP()
            for _, obj in pairs(ESPObjects) do
                for _, drawing in pairs(obj) do
                    pcall(function()
                        if drawing and drawing.Remove then drawing:Remove() end
                    end)
                end
            end
            table.clear(ESPObjects)
            if FOVCircle then
                pcall(function() FOVCircle:Remove() end)
                FOVCircle = nil
            end
        end

        local function CreateESP(plr)
            if plr == Player then return end
            if ESPObjects[plr] then return end

            local drawings = {}

            
            local box = Drawing.new("Square")
            box.Visible = false
            box.Color = ESPSettings.BoxColor
            box.Thickness = 1.5
            box.Filled = false
            box.Transparency = 1
            drawings.Box = box

            
            local name = Drawing.new("Text")
            name.Visible = false
            name.Color = ESPSettings.NameColor
            name.Size = 14
            name.Center = true
            name.Outline = true
            name.Font = 2
            drawings.Name = name

            
            local dist = Drawing.new("Text")
            dist.Visible = false
            dist.Color = Color3.fromRGB(180, 180, 190)
            dist.Size = 12
            dist.Center = true
            dist.Outline = true
            dist.Font = 2
            drawings.Distance = dist

            
            local tracer = Drawing.new("Line")
            tracer.Visible = false
            tracer.Color = ESPSettings.TracerColor
            tracer.Thickness = 1
            drawings.Tracer = tracer

            
            local healthBg = Drawing.new("Square")
            healthBg.Visible = false
            healthBg.Filled = true
            healthBg.Color = Color3.fromRGB(30, 30, 30)
            healthBg.Thickness = 0
            drawings.HealthBg = healthBg

            local healthFill = Drawing.new("Square")
            healthFill.Visible = false
            healthFill.Filled = true
            healthFill.Color = ESPSettings.HealthColor
            healthFill.Thickness = 0
            drawings.HealthFill = healthFill

            ESPObjects[plr] = drawings
        end

        local function UpdateESP()
            local camera = workspace.CurrentCamera
            if not camera then return end

            
            if ESPSettings.FOVEnabled then
                if not FOVCircle then
                    FOVCircle = Drawing.new("Circle")
                    FOVCircle.Filled = false
                    FOVCircle.NumSides = 64
                    FOVCircle.Transparency = 1
                end
                FOVCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                FOVCircle.Radius = ESPSettings.FOVRadius
                FOVCircle.Color = ESPSettings.FOVColor
                FOVCircle.Thickness = ESPSettings.FOVThickness
                FOVCircle.Visible = true
            elseif FOVCircle then
                FOVCircle.Visible = false
            end

            if not ESPEnabled then return end

            local localTeam = Player.Team

            for plr, drawings in pairs(ESPObjects) do
                local char = plr.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")

                
                local isEnemy = true
                if ESPSettings.TeamCheck and localTeam and plr.Team then
                    isEnemy = (plr.Team ~= localTeam)
                end

                if hrp and humanoid and humanoid.Health > 0 and isEnemy then
                    local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                    local distance = (camera.CFrame.Position - hrp.Position).Magnitude

                    if onScreen and distance <= ESPSettings.MaxDistance then
                        local size = 2000 / pos.Z
                        local boxSize = Vector2.new(size * 1.5, size * 2.5)
                        local boxPos = Vector2.new(pos.X - boxSize.X/2, pos.Y - boxSize.Y/2)

                        
                        if ESPSettings.Boxes then
                            drawings.Box.Size = boxSize
                            drawings.Box.Position = boxPos
                            drawings.Box.Color = ESPSettings.BoxColor
                            drawings.Box.Visible = true
                        else
                            drawings.Box.Visible = false
                        end

                        
                        if ESPSettings.Names then
                            drawings.Name.Text = plr.Name
                            drawings.Name.Position = Vector2.new(pos.X, boxPos.Y - 16)
                            drawings.Name.Color = ESPSettings.NameColor
                            drawings.Name.Visible = true
                        else
                            drawings.Name.Visible = false
                        end

                        
                        if ESPSettings.Distance then
                            drawings.Distance.Text = math.floor(distance) .. "m"
                            drawings.Distance.Position = Vector2.new(pos.X, boxPos.Y + boxSize.Y + 2)
                            drawings.Distance.Visible = true
                        else
                            drawings.Distance.Visible = false
                        end

                        
                        if ESPSettings.Tracers then
                            drawings.Tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                            drawings.Tracer.To = Vector2.new(pos.X, pos.Y)
                            drawings.Tracer.Color = ESPSettings.TracerColor
                            drawings.Tracer.Visible = true
                        else
                            drawings.Tracer.Visible = false
                        end

                        
                        if ESPSettings.HealthBar then
                            local healthPct = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                            local barWidth = 3
                            local barHeight = boxSize.Y
                            local barX = boxPos.X - barWidth - 3
                            local barY = boxPos.Y

                            drawings.HealthBg.Size = Vector2.new(barWidth, barHeight)
                            drawings.HealthBg.Position = Vector2.new(barX, barY)
                            drawings.HealthBg.Visible = true

                            local fillHeight = barHeight * healthPct
                            drawings.HealthFill.Size = Vector2.new(barWidth, fillHeight)
                            drawings.HealthFill.Position = Vector2.new(barX, barY + (barHeight - fillHeight))
                            drawings.HealthFill.Color = Color3.fromRGB(255 * (1 - healthPct), 255 * healthPct, 50)
                            drawings.HealthFill.Visible = true
                        else
                            drawings.HealthBg.Visible = false
                            drawings.HealthFill.Visible = false
                        end
                    else
                        drawings.Box.Visible = false
                        drawings.Name.Visible = false
                        drawings.Distance.Visible = false
                        drawings.Tracer.Visible = false
                        drawings.HealthBg.Visible = false
                        drawings.HealthFill.Visible = false
                    end
                else
                    drawings.Box.Visible = false
                    drawings.Name.Visible = false
                    drawings.Distance.Visible = false
                    drawings.Tracer.Visible = false
                    drawings.HealthBg.Visible = false
                    drawings.HealthFill.Visible = false
                end
            end
        end

        
        task.spawn(function()
            while true do
                if ESPEnabled then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        CreateESP(plr)
                    end
                    UpdateESP()
                else
                    ClearESP()
                end
                task.wait(0.03)
            end
        end)

        Players.PlayerRemoving:Connect(function(plr)
            if ESPObjects[plr] then
                for _, d in pairs(ESPObjects[plr]) do
                    pcall(function() d:Remove() end)
                end
                ESPObjects[plr] = nil
            end
        end)

        function Tab:AddESPControls()
            local f = EFrame(0)
            f.AutomaticSize = Enum.AutomaticSize.Y

            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 8, 0, 4),
                BackgroundTransparency = 1, Text = "ESP Controls (Drawing)",
                TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })

            
            local toggleF = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Parent = f
            })
            local mainToggle = Tab:AddToggle("Enable ESP", false, function(v)
                ESPEnabled = v
                if not v then ClearESP() end
            end, "ESP_Enabled")
            mainToggle.Frame.Parent = toggleF

            
            Tab:AddToggle("Boxes", true, function(v) ESPSettings.Boxes = v end, "ESP_Boxes")
            Tab:AddToggle("Names", true, function(v) ESPSettings.Names = v end, "ESP_Names")
            Tab:AddToggle("Distance", true, function(v) ESPSettings.Distance = v end, "ESP_Distance")
            Tab:AddToggle("Tracers", false, function(v) ESPSettings.Tracers = v end, "ESP_Tracers")
            Tab:AddToggle("Health Bar", true, function(v) ESPSettings.HealthBar = v end, "ESP_HealthBar")
            Tab:AddToggle("Team Check", false, function(v) ESPSettings.TeamCheck = v end, "ESP_TeamCheck")

            Tab:AddSlider("Max Distance", 50, 3000, 1000, function(v)
                ESPSettings.MaxDistance = v
            end, "ESP_MaxDist")

            
            Tab:AddToggle("FOV Circle", false, function(v) ESPSettings.FOVEnabled = v end, "FOV_Enabled")
            Tab:AddSlider("FOV Radius", 30, 400, 120, function(v)
                ESPSettings.FOVRadius = v
            end, "FOV_Radius")

            Tab:AddColorPicker("Box Color", ESPSettings.BoxColor, function(c)
                ESPSettings.BoxColor = c
            end, "ESP_BoxColor")

            Tab:AddColorPicker("Name Color", ESPSettings.NameColor, function(c)
                ESPSettings.NameColor = c
            end, "ESP_NameColor")

            Tab:AddColorPicker("FOV Color", ESPSettings.FOVColor, function(c)
                ESPSettings.FOVColor = c
            end, "FOV_Color")

            return f
        end

        function Tab:AddPlayerList(callback)
            local f = EFrame(160)
            Create("TextLabel", {
                Size = UDim2.new(1, -60, 0, 18), Position = UDim2.new(0, 8, 0, 3),
                BackgroundTransparency = 1, Text = L("PlayerList"), TextColor3 = Library.Theme.Text,
                Font = Enum.Font.GothamBold, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            local scroll = Create("ScrollingFrame", {
                Size = UDim2.new(1, -10, 1, -28), Position = UDim2.new(0, 5, 0, 24),
                BackgroundTransparency = 1, ScrollBarThickness = 2,
                AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = f
            })
            Create("UIListLayout", {Padding = UDim.new(0, 2), Parent = scroll})
            local function refresh()
                for _, c in ipairs(scroll:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= Player then
                        local b = Create("TextButton", {
                            Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = Color3.fromRGB(34, 34, 40),
                            Text = "  " .. plr.Name, TextColor3 = Library.Theme.Text,
                            Font = Enum.Font.Gotham, TextSize = 11,
                            TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, Parent = scroll
                        })
                        Corner(b, 3)
                        b.MouseButton1Click:Connect(function()
                            PlaySound("Click")
                            if callback then pcall(callback, plr) end
                            Library:Notify(L("Target"), plr.Name, 1.4)
                        end)
                    end
                end
            end
            refresh()
            Players.PlayerAdded:Connect(refresh)
            Players.PlayerRemoving:Connect(refresh)
            local rb = Create("TextButton", {
                Size = UDim2.new(0, 50, 0, 14), Position = UDim2.new(1, -58, 0, 4),
                BackgroundColor3 = Color3.fromRGB(46, 46, 52), Text = L("Refresh"),
                TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 9.5,
                AutoButtonColor = false, Parent = f
            })
            Corner(rb, 3)
            rb.MouseButton1Click:Connect(function() PlaySound("Click") refresh() end)
            return f
        end

        function Tab:AddConfigList()
            local f = EFrame(150)
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 8, 0, 3),
                BackgroundTransparency = 1, Text = L("ConfigManager"), TextColor3 = Library.Theme.Text,
                Font = Enum.Font.GothamBold, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            local nameBox = Create("TextBox", {
                Size = UDim2.new(1, -16, 0, 20), Position = UDim2.new(0, 8, 0, 24),
                BackgroundColor3 = Color3.fromRGB(24, 24, 30), Text = "",
                PlaceholderText = "Config name...", TextColor3 = Library.Theme.Text,
                PlaceholderColor3 = Color3.fromRGB(90, 90, 100), Font = Enum.Font.Gotham,
                TextSize = 11, Parent = f
            })
            Corner(nameBox, 3)
            local cfgSel = Create("TextButton", {
                Size = UDim2.new(1, -16, 0, 20), Position = UDim2.new(0, 8, 0, 50),
                BackgroundColor3 = Color3.fromRGB(28, 28, 34), Text = "  Select config...",
                TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, Parent = f
            })
            Corner(cfgSel, 3)
            local cfgList = Create("ScrollingFrame", {
                Size = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(24, 24, 30),
                Visible = false, ZIndex = 140, AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2, Parent = Main
            })
            Corner(cfgList, 4)
            Stroke(cfgList, Color3.fromRGB(50, 50, 56), 1)
            Create("UIListLayout", {Padding = UDim.new(0, 1), Parent = cfgList})
            local function refreshConfigs()
                for _, c in ipairs(cfgList:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                pcall(function()
                    if isfolder(ConfigFolder) then
                        for _, file in ipairs(listfiles(ConfigFolder)) do
                            local name = file:match("([^/\\]+)%.json$")
                            if name then
                                local b = Create("TextButton", {
                                    Size = UDim2.new(1, 0, 0, 20), BackgroundColor3 = Color3.fromRGB(24, 24, 30),
                                    Text = "  " .. name, TextColor3 = Library.Theme.Text,
                                    Font = Enum.Font.Gotham, TextSize = 11,
                                    TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false,
                                    ZIndex = 141, Parent = cfgList
                                })
                                b.MouseButton1Click:Connect(function()
                                    nameBox.Text = name
                                    cfgSel.Text = "  " .. name
                                    cfgList.Visible = false
                                end)
                            end
                        end
                    end
                end)
            end
            local openCfg = false
            cfgSel.MouseButton1Click:Connect(function()
                PlaySound("Click", 0.25)
                if openCfg then openCfg = false cfgList.Visible = false return end
                refreshConfigs()
                openCfg = true
                cfgList.Visible = true
                local ap, as, mp = cfgSel.AbsolutePosition, cfgSel.AbsoluteSize, Main.AbsolutePosition
                cfgList.Position = UDim2.fromOffset(ap.X - mp.X, ap.Y - mp.Y + as.Y + 2)
                cfgList.Size = UDim2.new(0, as.X, 0, 90)
            end)
            local saveBtn = Create("TextButton", {
                Size = UDim2.new(0.48, -6, 0, 22), Position = UDim2.new(0, 8, 0, 78),
                BackgroundColor3 = Library.AccentColor, Text = L("Save"),
                TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamSemibold, TextSize = 11,
                AutoButtonColor = false, Parent = f
            })
            Corner(saveBtn, 3)
            RegisterTheme(saveBtn, "BackgroundColor3", "Accent")
            local loadBtn = Create("TextButton", {
                Size = UDim2.new(0.48, -6, 0, 22), Position = UDim2.new(0.52, 0, 0, 78),
                BackgroundColor3 = Color3.fromRGB(46, 46, 52), Text = L("Load"),
                TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamSemibold, TextSize = 11,
                AutoButtonColor = false, Parent = f
            })
            Corner(loadBtn, 3)
            local delBtn = Create("TextButton", {
                Size = UDim2.new(1, -16, 0, 20), Position = UDim2.new(0, 8, 0, 108),
                BackgroundColor3 = Color3.fromRGB(60, 30, 30), Text = L("Delete"),
                TextColor3 = Color3.fromRGB(255, 150, 150), Font = Enum.Font.Gotham, TextSize = 11,
                AutoButtonColor = false, Parent = f
            })
            Corner(delBtn, 3)

            
            local exportBtn = Create("TextButton", {
                Size = UDim2.new(0.48, -6, 0, 20), Position = UDim2.new(0, 8, 0, 132),
                BackgroundColor3 = Color3.fromRGB(40, 60, 90), Text = "Export",
                TextColor3 = Color3.fromRGB(150, 200, 255), Font = Enum.Font.Gotham, TextSize = 11,
                AutoButtonColor = false, Parent = f
            })
            Corner(exportBtn, 3)

            
            local importBtn = Create("TextButton", {
                Size = UDim2.new(0.48, -6, 0, 20), Position = UDim2.new(0.52, 0, 0, 132),
                BackgroundColor3 = Color3.fromRGB(40, 60, 90), Text = "Import",
                TextColor3 = Color3.fromRGB(150, 200, 255), Font = Enum.Font.Gotham, TextSize = 11,
                AutoButtonColor = false, Parent = f
            })
            Corner(importBtn, 3)

            saveBtn.MouseButton1Click:Connect(function()
                PlaySound("Click")
                local n = nameBox.Text
                if n and n ~= "" then Window:SaveConfigAs(n) refreshConfigs()
                else Library:Notify("Error", "Enter name", 1.5, "error") end
            end)
            loadBtn.MouseButton1Click:Connect(function()
                PlaySound("Click")
                local n = nameBox.Text
                if n and n ~= "" then Window:LoadConfigByName(n) end
            end)
            delBtn.MouseButton1Click:Connect(function()
                PlaySound("Click")
                local n = nameBox.Text
                if n and n ~= "" then
                    pcall(function() delfile(ConfigFolder .. "/" .. n .. ".json") end)
                    Library:Notify("Config", "Deleted " .. n, 1.5, "warning")
                    refreshConfigs()
                    nameBox.Text = ""
                    cfgSel.Text = "  Select config..."
                end
            end)

            exportBtn.MouseButton1Click:Connect(function()
                PlaySound("Click")
                local n = nameBox.Text
                if n and n ~= "" and Window.Flags then
                    local json = HttpService:JSONEncode(Window.Flags)
                    setclipboard(json)
                    Library:Notify("Export", "Config copied to clipboard!", 2, "success")
                else
                    Library:Notify("Error", "Select a config to export", 1.5, "error")
                end
            end)

            importBtn.MouseButton1Click:Connect(function()
                PlaySound("Click")
                local json = getclipboard and getclipboard() or ""
                if json and json ~= "" then
                    pcall(function()
                        local data = HttpService:JSONDecode(json)
                        if type(data) == "table" then
                            Library.Configs = data
                            Window:ApplyConfigs()
                            Library:Notify("Import", "Config imported successfully", 2, "success")
                        end
                    end)
                else
                    Library:Notify("Error", "Empty or non-JSON clipboard", 1.5, "error")
                end
            end)

            return f
        end

        

        function Tab:AddSpacer(height)
            height = height or 8
            return Create("Frame", {
                Size = UDim2.new(1, 0, 0, height),
                BackgroundTransparency = 1,
                Parent = content
            })
        end

        function Tab:AddProgressBar(text, default, callback, flag)
            default = math.clamp(default or 0, 0, 100)
            local f = EFrame(42)
            Create("TextLabel", {
                Size = UDim2.new(1, -60, 0, 14), Position = UDim2.new(0, 8, 0, 4),
                BackgroundTransparency = 1, Text = text or L("Progress"),
                TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 11.5,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })
            local pct = Create("TextLabel", {
                Size = UDim2.new(0, 48, 0, 14), Position = UDim2.new(1, -56, 0, 4),
                BackgroundTransparency = 1, Text = tostring(default) .. "%",
                TextColor3 = Library.AccentColor, Font = Enum.Font.GothamBold, TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right, Parent = f
            })
            RegisterTheme(pct, "TextColor3", "Accent")
            local track = Create("Frame", {
                Size = UDim2.new(1, -16, 0, 8), Position = UDim2.new(0, 8, 0, 26),
                BackgroundColor3 = Library.Theme.Track, Parent = f
            })
            Corner(track, 4)
            RegisterTheme(track, "BackgroundColor3", "Track")
            local fill = Create("Frame", {
                Size = UDim2.new(default/100, 0, 1, 0),
                BackgroundColor3 = Library.AccentColor, Parent = track
            })
            Corner(fill, 4)
            RegisterTheme(fill, "BackgroundColor3", "Accent")
            local cur = default
            local function Up(v, fc)
                cur = math.clamp(math.floor(v + 0.5), 0, 100)
                pct.Text = cur .. "%"
                Tween(fill, {Size = UDim2.new(cur/100, 0, 1, 0)}, 0.18)
                if flag and not fc then Window.Flags[flag] = cur end
                if callback then pcall(callback, cur) end
            end
            if flag then
                Window.Flags[flag] = cur
                if Library.Configs[flag] ~= nil then Up(Library.Configs[flag], true) end
            end
            local o = {Frame = f}
            function o:Set(v) Up(v) end
            function o:Get() return cur end
            if flag then table.insert(Window.Elements, {Flag = flag, Object = o, Type = "Progress"}) end
            return o
        end

        function Tab:AddImage(image, height, text)
            height = height or 80
            local f = EFrame(height + (text and 22 or 8))
            if text then
                Create("TextLabel", {
                    Size = UDim2.new(1, -12, 0, 16), Position = UDim2.new(0, 8, 0, 4),
                    BackgroundTransparency = 1, Text = text,
                    TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = f
                })
            end
            local img = Create("ImageLabel", {
                Size = UDim2.new(1, -16, 0, height - (text and 8 or 0)),
                Position = UDim2.new(0, 8, 0, text and 22 or 4),
                BackgroundColor3 = Color3.fromRGB(20, 20, 26),
                Image = typeof(image) == "number" and ("rbxthumb://type=Asset&id=" .. image .. "&w=420&h=420") or (image or ""),
                ScaleType = Enum.ScaleType.Fit,
                Parent = f
            })
            Corner(img, 4)
            return f
        end

        function Tab:AddBanner(imageId, height)
            return Tab:AddImage(imageId, height or 90, nil)
        end

        
        function Tab:AddGif(image, frameWidth, frameHeight, frameCount, fps, height, text, loop)
            frameWidth = frameWidth or 128
            frameHeight = frameHeight or 128
            frameCount = frameCount or 1
            fps = fps or 12
            height = height or frameHeight
            loop = loop == nil and true or loop

            local f = EFrame(height + (text and 22 or 8))

            if text then
                Create("TextLabel", {
                    Size = UDim2.new(1, -12, 0, 16), Position = UDim2.new(0, 8, 0, 4),
                    BackgroundTransparency = 1, Text = text,
                    TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = f
                })
            end

            local img = Create("ImageLabel", {
                Size = UDim2.new(0, frameWidth, 0, height - (text and 8 or 0)),
                Position = UDim2.new(0.5, -frameWidth/2, 0, text and 22 or 4),
                BackgroundColor3 = Color3.fromRGB(20, 20, 26),
                Image = typeof(image) == "number" and ("rbxthumb://type=Asset&id=" .. image .. "&w=420&h=420") or tostring(image or ""),
                ScaleType = Enum.ScaleType.Crop,
                ImageRectSize = Vector2.new(frameWidth, frameHeight),
                Parent = f
            })
            Corner(img, 4)

            
            local currentFrame = 0
            local connection
            local isPlaying = true

            local function updateFrame()
                if not img or not img.Parent then
                    if connection then connection:Disconnect() end
                    return
                end
                currentFrame = currentFrame + 1
                if currentFrame > frameCount then
                    if loop then
                        currentFrame = 1
                    else
                        currentFrame = frameCount
                        if connection then connection:Disconnect() end
                        return
                    end
                end
                local col = (currentFrame - 1) % math.floor(img.ImageRectSize.X / frameWidth)   
                local row = math.floor((currentFrame - 1) / math.floor(img.ImageRectSize.X / frameWidth))
                img.ImageRectOffset = Vector2.new(col * frameWidth, row * frameHeight)
            end

            
            connection = RunService.Heartbeat:Connect(function()
                if isPlaying then
                    updateFrame()
                    task.wait(1 / fps)
                end
            end)

            
            local gifObj = {
                Frame = f,
                ImageLabel = img,
                Playing = true
            }

            function gifObj:Play()
                isPlaying = true
                gifObj.Playing = true
            end

            function gifObj:Pause()
                isPlaying = false
                gifObj.Playing = false
            end

            function gifObj:Stop()
                isPlaying = false
                gifObj.Playing = false
                currentFrame = 0
                if img then img.ImageRectOffset = Vector2.new(0, 0) end
            end

            function gifObj:SetFPS(newFps)
                fps = math.clamp(newFps or 12, 1, 60)
            end

            function gifObj:SetLoop(enabled)
                loop = enabled
            end

            
            f.AncestryChanged:Connect(function(_, parent)
                if not parent and connection then
                    connection:Disconnect()
                end
            end)

            return gifObj
        end

        
        function Tab:AddLanguageSwitcher()
            local langList = {
                "VI", "EN", "ZH", "JA", "KO", "TH", "ID", "MS", "TL", "HI",
                "AR", "RU", "UK", "FR", "DE", "ES", "PT", "IT", "TR", "PL",
                "NL", "SV", "NO", "DA", "FI", "CS", "RO", "HU", "EL"
            }
            return Tab:AddDropdown("Language", langList, Library.Language, function(v)
                Library:SetLanguage(v)
                if Window.SearchBox then
                    Window.SearchBox.PlaceholderText = L("Search")
                end
            end, "Language")
        end

        
        function Tab:AddKeybindManager()
            local f = EFrame(180)
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 8, 0, 4),
                BackgroundTransparency = 1, Text = "Keybind Manager",
                TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = f
            })

            local scroll = Create("ScrollingFrame", {
                Size = UDim2.new(1, -12, 1, -28), Position = UDim2.new(0, 6, 0, 24),
                BackgroundTransparency = 1, ScrollBarThickness = 2,
                AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = f
            })
            Create("UIListLayout", {Padding = UDim.new(0, 3), Parent = scroll})

            local function refresh()
                for _, c in ipairs(scroll:GetChildren()) do
                    if c:IsA("Frame") then c:Destroy() end
                end

                for _, entry in ipairs(Window.Elements) do
                    if entry.Type == "Keybind" or entry.Type == "Bind" or entry.MultiFlag then
                        local flag = entry.Flag or "Unknown"
                        local val = Window.Flags[flag] or Window.Flags[flag .. "_K"] or "None"

                        local row = Create("Frame", {
                            Size = UDim2.new(1, 0, 0, 24),
                            BackgroundColor3 = Color3.fromRGB(34, 34, 40),
                            Parent = scroll
                        })
                        Corner(row, 3)

                        Create("TextLabel", {
                            Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 8, 0, 0),
                            BackgroundTransparency = 1, Text = tostring(flag),
                            TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 11,
                            TextXAlignment = Enum.TextXAlignment.Left, Parent = row
                        })

                        Create("TextLabel", {
                            Size = UDim2.new(0.35, 0, 1, 0), Position = UDim2.new(0.6, 0, 0, 0),
                            BackgroundTransparency = 1, Text = tostring(val),
                            TextColor3 = Library.AccentColor, Font = Enum.Font.GothamBold, TextSize = 11,
                            TextXAlignment = Enum.TextXAlignment.Right, Parent = row
                        })
                    end
                end
            end

            refresh()

            
            task.spawn(function()
                while f and f.Parent do
                    task.wait(3)
                    pcall(refresh)
                end
            end)

            local refreshBtn = Create("TextButton", {
                Size = UDim2.new(0, 60, 0, 16), Position = UDim2.new(1, -68, 0, 4),
                BackgroundColor3 = Color3.fromRGB(46, 46, 52), Text = "Refresh",
                TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 10,
                AutoButtonColor = false, Parent = f
            })
            Corner(refreshBtn, 3)
            refreshBtn.MouseButton1Click:Connect(function()
                PlaySound("Click")
                refresh()
            end)

            return f
        end

        
        function Tab:AddSoundToggle()
            return Tab:AddToggle("UI Sounds", Library.SoundsEnabled, function(v)
                Library.SoundsEnabled = v
            end, "Sounds")
        end

        table.insert(Window.Tabs, Tab)
        return Tab
    end

    task.delay(1.2, function()
        if #Window.Tabs > 0 then
            Window.Tabs[1].Button.BackgroundTransparency = 0
            Window.Tabs[1].Content.Visible = true
            Search.Visible = true
            Window.CurrentTab = Window.Tabs[1]
        end
    end)

    if not Library.KeybindConnected then
        Library.KeybindConnected = true
        UserInputService.InputBegan:Connect(function(i, gp)
            if gp then return end
            for _, w in pairs(Library.Windows) do
                if i.KeyCode == w.ToggleKey then
                    w.Main.Visible = not w.Main.Visible
                    if w.Blur then w.Blur.Enabled = w.Main.Visible end
                end
            end
        end)
    end

    table.insert(Library.Windows, Window)

    if SaveConfig then
        pcall(function() if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end end)
        local path = ConfigFolder .. "/" .. ConfigName
        pcall(function()
            if isfile(path) then
                local d = HttpService:JSONDecode(readfile(path))
                if type(d) == "table" then Library.Configs = d end
            end
        end)

        
        task.delay(0.6, function()
            if Main and Main.Parent and isfile(path) then
                pcall(function()
                    Library.Configs = HttpService:JSONDecode(readfile(path))
                    if Window.ApplyConfigs then
                        Window:ApplyConfigs()
                    end
                end)
            end
        end)
        function Window:SaveConfig()
            pcall(function()
                writefile(path, HttpService:JSONEncode(Window.Flags))
                Library:Notify("Config", L("ConfigSaved"), 1.4, "success")
            end)
        end
        function Window:LoadConfig()
            pcall(function()
                if isfile(path) then
                    Library.Configs = HttpService:JSONDecode(readfile(path))
                    Window:ApplyConfigs()
                    Library:Notify("Config", L("ConfigLoaded"), 1.4, "success")
                end
            end)
        end
        function Window:SaveConfigAs(name)
            pcall(function()
                writefile(ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(Window.Flags))
                Library:Notify("Config", L("ConfigSaved") .. ": " .. name, 1.4, "success")
            end)
        end
        function Window:LoadConfigByName(name)
            pcall(function()
                local p = ConfigFolder .. "/" .. name .. ".json"
                if isfile(p) then
                    Library.Configs = HttpService:JSONDecode(readfile(p))
                    Window:ApplyConfigs()
                    Library:Notify("Config", L("ConfigLoaded") .. ": " .. name, 1.4, "success")
                else
                    Library:Notify("Error", "Profile not found", 1.5, "error")
                end
            end)
        end

        
        function Window:GetProfiles()
            local profiles = {}
            pcall(function()
                if isfolder(ConfigFolder) then
                    for _, file in ipairs(listfiles(ConfigFolder)) do
                        local name = file:match("([^/\\]+)%.json$")
                        if name then table.insert(profiles, name) end
                    end
                end
            end)
            return profiles
        end

        function Window:SwitchProfile(name)
            self:LoadConfigByName(name)
        end

        function Window:DeleteProfile(name)
            pcall(function()
                delfile(ConfigFolder .. "/" .. name .. ".json")
                Library:Notify("Config", "Profile deleted: " .. name, 1.5, "warning")
            end)
        end
        task.spawn(function()
            while Main and Main.Parent do
                task.wait(12)
                pcall(function()
                    if next(Window.Flags) then writefile(path, HttpService:JSONEncode(Window.Flags)) end
                end)
            end
        end)
    else
        function Window:SaveConfig() end
        function Window:LoadConfig() end
        function Window:SaveConfigAs() end
        function Window:LoadConfigByName() end
    end

    function Window:Destroy()
        ClosePopups()
        
        pcall(function()
            if ClearESP then ClearESP() end
            ESPEnabled = false
        end)
        pcall(function() self.Blur:Destroy() end)
        pcall(function() self.ScreenGui:Destroy() end)
    end

    function Window:SetVisible(v)
        self.Main.Visible = v
        if self.Blur then self.Blur.Enabled = v end
    end

    
    function Window:Panic()
        ClosePopups()
        
        for _, entry in ipairs(self.Elements) do
            pcall(function()
                if entry.Object and entry.Object.Set then
                    if entry.Type == "Toggle" or entry.Type == "Checkbox" or entry.Type == "Bind" then
                        entry.Object:Set(false)
                    end
                end
            end)
        end
        
        pcall(function()
            if ClearESP then ClearESP() end
            ESPEnabled = false
        end)
        Library:Notify("Panic", "All features have been turned off", 2, "warning")
        PlaySound("Click", 0.4)
    end

    task.delay(1.4, function()
        Library:Notify("x9runnerreal Hub", "v" .. Library.Version, 2.2, "success")
        Library:CreateWatermark("x9runnerreal Hub | " .. Library.Version, {
            ShowFPS = true,
            ShowPing = true
        })
    end)

    return Window
end

