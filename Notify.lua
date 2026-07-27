function Library:Notify(title, content, duration, ntype, actions)
    duration = duration or 2.5
    ntype = ntype or "info"
    actions = actions or {}
    PlaySound("Notify", 0.25)

    local gui = PlayerGui:FindFirstChild("x9_Notifs") or Create("ScreenGui", {
        Name = "x9_Notifs", ResetOnSpawn = false, Parent = PlayerGui
    })

    local accent = Library.AccentColor
    if ntype == "success" then accent = Color3.fromRGB(60, 200, 100)
    elseif ntype == "error" then accent = Color3.fromRGB(255, 70, 70)
    elseif ntype == "warning" then accent = Color3.fromRGB(255, 190, 40)
    elseif ntype == "info" then accent = Library.AccentColor end

    local height = 58
    if #actions > 0 then height = 82 end

    local function restack()
        for i, notif in ipairs(Library.Notifications) do
            if notif and notif.Parent then
                local y = -78 - (i - 1) * (notif.Size.Y.Offset + 10)
                Tween(notif, {Position = UDim2.new(1, -308, 1, y)}, 0.2)
            end
        end
    end

    local function removeNotif(n)
        for i, v in ipairs(Library.Notifications) do
            if v == n then
                table.remove(Library.Notifications, i)
                break
            end
        end
        if n and n.Parent then
            n:Destroy()
        end
        restack()
    end

    local n = Create("Frame", {
        Size = UDim2.new(0, 290, 0, height),
        Position = UDim2.new(1, 25, 1, -78 - #Library.Notifications * (height + 10)),
        BackgroundColor3 = Color3.fromRGB(22, 22, 28),
        Parent = gui
    })
    Corner(n, 5)
    Stroke(n, accent, 1.2)

    Create("Frame", {
        Size = UDim2.new(0, 3, 1, -8), Position = UDim2.new(0, 5, 0, 4),
        BackgroundColor3 = accent, Parent = n
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 18), Position = UDim2.new(0, 16, 0, 6),
        BackgroundTransparency = 1, Text = title or "Notify",
        TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 12.5,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = n
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 24), Position = UDim2.new(0, 16, 0, 26),
        BackgroundTransparency = 1, Text = content or "",
        TextColor3 = Color3.fromRGB(155, 155, 165), Font = Enum.Font.Gotham, TextSize = 11.5,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = n
    })

    if #actions > 0 then
        local btnY = 52
        for i, action in ipairs(actions) do
            local btn = Create("TextButton", {
                Size = UDim2.new(0, 70, 0, 22),
                Position = UDim2.new(0, 16 + (i-1) * 78, 0, btnY),
                BackgroundColor3 = action.danger and Color3.fromRGB(60, 30, 30) or Color3.fromRGB(45, 45, 52),
                Text = action.text or "OK",
                TextColor3 = action.danger and Color3.fromRGB(255, 150, 150) or (Library.Theme and Library.Theme.Text or Color3.new(1,1,1)),
                Font = Enum.Font.GothamSemibold, TextSize = 11,
                AutoButtonColor = false, Parent = n
            })
            Corner(btn, 4)

            btn.MouseButton1Click:Connect(function()
                if action.callback then pcall(action.callback) end
                if n and n.Parent then
                    Tween(n, {Position = UDim2.new(1, 40, 1, n.Position.Y.Offset)}, 0.2)
                    task.wait(0.22)
                    removeNotif(n)
                end
            end)
        end
    end

    table.insert(Library.Notifications, n)
    Tween(n, {Position = UDim2.new(1, -308, 1, n.Position.Y.Offset)}, 0.32)

    if #actions == 0 then
        task.delay(duration, function()
            if n and n.Parent then
                Tween(n, {Position = UDim2.new(1, 40, 1, n.Position.Y.Offset)}, 0.25)
                task.wait(0.26)
                removeNotif(n)
            end
        end)
    end
end
