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
    Language         = "EN",
    SoundsEnabled    = true,
    ElementRegistry  = {},
}
print("[x9Library] Base loaded. Version " .. Library.Version)
return Library
