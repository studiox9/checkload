function Library:CreateContextMenu(items)
    items = items or {}

    if ContextMenuGui then
        ContextMenuGui:Destroy()
    end

    ContextMenuGui = Create("ScreenGui", {
        Name = "x9_ContextMenu",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = PlayerGui
    })

    local menu = Create("Frame", {
        Size = UDim2.new(0, 160, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(22, 22, 28),
        Visible = false,
        ZIndex = 600,
        Parent = ContextMenuGui
    })
    Corner(menu, 6)
    Stroke(menu, Library.AccentColor, 1)

    local list = Create("UIListLayout", {
        Padding = UDim.new(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = menu
    })

    local menuItems = {}

    for i, item in ipairs(items) do
        if item.type == "separator" then
            local sep = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Color3.fromRGB(45, 45, 52),
                LayoutOrder = i,
                Parent = menu
            })
        else
            local btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundColor3 = Color3.fromRGB(26, 26, 32),
                Text = "  " .. (item.text or "Item"),
                TextColor3 = item.danger and Color3.fromRGB(255, 120, 120) or Library.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                LayoutOrder = i,
                Parent = menu
            })

            if item.icon then
                Create("ImageLabel", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, 6, 0.5, -8),
                    BackgroundTransparency = 1,
                    Image = item.icon,
                    Parent = btn
                })
            end

            btn.MouseEnter:Connect(function()
                Tween(btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 48)}, 0.08)
            end)
            btn.MouseLeave:Connect(function()
                Tween(btn, {BackgroundColor3 = Color3.fromRGB(26, 26, 32)}, 0.08)
            end)

            btn.MouseButton1Click:Connect(function()
                PlaySound("Click", 0.3)
                if item.callback then
                    pcall(item.callback)
                end
                menu.Visible = false
            end)

            table.insert(menuItems, btn)
        end
    end

    local function show(x, y)
        menu.Position = UDim2.fromOffset(x, y)
        menu.Visible = true
        
        task.delay(0.1, function()
            local conn
            conn = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if menu and not menu:IsAncestorOf(input.Target) then
                        menu.Visible = false
                        if conn then conn:Disconnect() end
                    end
                end
            end)
        end)
    end

    local function hide()
        if menu then menu.Visible = false end
    end

    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Escape and menu.Visible then
            hide()
        end
    end)

    return {
        Show = show,
        Hide = hide,
        Destroy = function()
            if ContextMenuGui then ContextMenuGui:Destroy() end
        end
    }
end


function Library:BindContextMenu(element, items)
    if not element then return end

    element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
            local menu = Library:CreateContextMenu(items)
            menu.Show(Mouse.X + 5, Mouse.Y + 5)
        end
    end)
end


