local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Hauptfenster
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 260, 0, 250)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 255, 0)
MainStroke.Thickness = 2

-- Überschrift fett
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -4, 0, 35)
Title.Position = UDim2.new(0, 2, 0, 2)
Title.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Title.Text = "GIG HUB"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.SourceSansBold -- fett
Title.TextScaled = false
Title.TextSize = 22
Title.BorderSizePixel = 0
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

-- ScrollFrame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6

local Layout = Instance.new("UIListLayout")
Layout.Parent = ScrollFrame
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Top
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end)

-- Button Funktion (dünne Schrift)
local function CreateButton(text, url)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Button.TextColor3 = Color3.fromRGB(0, 255, 0)
    Button.Font = Enum.Font.SourceSansLight -- dünne Schrift für Buttons
    Button.TextScaled = false
    Button.TextSize = 25
    Button.Text = text
    Button.Parent = ScrollFrame
    Button.BorderSizePixel = 0

    local Corner = Instance.new("UICorner", Button)
    Corner.CornerRadius = UDim.new(0, 4)

    local Stroke = Instance.new("UIStroke", Button)
    Stroke.Color = Color3.fromRGB(0, 255, 0)
    Stroke.Thickness = 1.5

    Button.MouseButton1Click:Connect(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(url, true))()
        end)
        if not success then
            warn("Fehler beim Laden von " .. text .. ": " .. err)
        end
    end)
end

-- Buttons erstellen
CreateButton("AK Admin", "https://absent.wtf/AKADMIN.lua")
CreateButton("talentPiano", "https://hellohellohell0.com/talentless-raw/TALENTLESS.lua")
CreateButton("Fly GIG", "https://raw.githubusercontent.com/user2345600/FlyGiG/main/FlyGiG.lua")
CreateButton("DrivingEmp", "https://raw.githubusercontent.com/Marco8642/science/main/drivingempire")
CreateButton("Auto TP", "loadstring(game:HttpGet("https://raw.githubusercontent.com/48-create/CordGIG/refs/heads/main/maincode.lua", true))()")

-- K-Taste Toggle
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
