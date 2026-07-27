local base = "https://raw.githubusercontent.com/trancuong2009na-code/xyz.X9.lua/refs/heads/main/"
local function get(file)
    local ok, res = pcall(function()
        return game:HttpGet(base .. file)
    end)
    if not ok or not res or #res < 50 then
        error("Unable to download the file: " .. file)
    end
    return res
end

local Players          = game:GetService("Players")
local Lighting         = game:GetService("Lighting")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local RunService       = game:GetService("RunService")
local SoundService     = game:GetService("SoundService")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Mouse     = Player:GetMouse()

local Library = {
    Version          = "3.0.0",
    Windows          = {},
    Notifications    = {},
    KeybindConnected = false,
    Configs          = {},
    CurrentTheme     = "Dark",
    AccentColor      = Color3.fromRGB(0, 200, 130),
    RainbowEnabled   = false,
    RainbowSpeed     = 1,
    Language         = "VI",
    SoundsEnabled    = true,
    ElementRegistry  = {},
}

local env = {
    Library          = Library,
    Players          = Players,
    Lighting         = Lighting,
    TweenService     = TweenService,
    UserInputService = UserInputService,
    HttpService      = HttpService,
    RunService       = RunService,
    SoundService     = SoundService,
    Player           = Player,
    PlayerGui        = PlayerGui,
    Mouse            = Mouse,
    game             = game,
}
setmetatable(env, {__index = getfenv()})

local function safeLoad(name)
    local src = get(name)
    -- Chỉ bỏ "local " ở function top-level để đưa vào env, tránh phá nested local
    src = src:gsub("local function ", "function ")
    local fn = loadstring(src, name)
    if not fn then
        error("Failed to loadstring: " .. name)
    end
    setfenv(fn, env)
    local ok, err = pcall(fn)
    if not ok then
        warn("[x9Library] Error loading " .. name .. ": " .. tostring(err))
    end
end

Library.Themes = loadstring(get("Themes.lua"))()
Library.Theme  = Library.Themes.Dark
Library.Lang   = loadstring(get("Languages.lua"))()

safeLoad("Utils.lua")
safeLoad("ContextMenu.lua")
safeLoad("Notify.lua")
safeLoad("Watermark.lua")
safeLoad("Language.lua")
safeLoad("Window.lua")

print("[x9Library] Tải thành công - Phiên bản " .. Library.Version)
Library:Notify("x9Library", "Thư viện đã tải thành công.", 3, "success")
return Library
