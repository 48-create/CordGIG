-- Einfacher Koordinaten-Speicher (Neon & Grau Edition)
-- Von MK

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Ordner & Datei
local FOLDER = ".Cordinat"
local FILE = FOLDER .. "/kito.json"

-- Überprüfung der Executor-Unterstützung
local canWrite = (type(writefile) == "function" and type(readfile) == "function")
local canFS = (type(isfile) == "function" and type(isfolder) == "function" and type(makefolder) == "function")

-- Ordner erstellen, falls nicht vorhanden
if canFS and not isfolder(FOLDER) then
	pcall(makefolder, FOLDER)
end

-- Funktion: Daten laden
local function loadCoords()
	if not canWrite then return {} end
	if canFS and isfile(FILE) then
		local ok, data = pcall(readfile, FILE)
		if ok and data and #data > 0 then
			local success, tbl = pcall(function() return HttpService:JSONDecode(data) end)
			if success and type(tbl) == "table" then
				return tbl
			end
		end
	end
	return {}
end

-- Funktion: Daten speichern
local function saveCoords(tbl)
	if not canWrite then return false end
	local ok, json = pcall(function() return HttpService:JSONEncode(tbl) end)
	if ok then
		pcall(writefile, FILE, json)
		return true
	end
	return false
end

-- Spielerposition abrufen
local function getPos()
	local char = LocalPlayer.Character
	if not char then return nil end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end
	return hrp.Position
end

-- Koordinate hinzufügen
local function addCoord(name)
	local pos = getPos()
	if not pos then warn("Charakter nicht gefunden.") return end
	local coords = loadCoords()
	name = tostring(name or ("Pos_" .. math.random(1000,9999)))
	coords[name] = {pos.X, pos.Y, pos.Z}
	saveCoords(coords)
	print("[+] Gespeichert:", name)
end

-- Teleportieren
local function tpCoord(name)
	local coords = loadCoords()
	local t = coords[name]
	if not t then warn("Koordinate nicht gefunden:", name) return end
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = CFrame.new(t[1], t[2], t[3])
		print("[✔] Teleportiert zu:", name)
	end
end

-- Koordinate löschen
local function delCoord(name)
	local coords = loadCoords()
	if coords[name] then
		coords[name] = nil
		saveCoords(coords)
		print("[-] Gelöscht:", name)
	else
		warn("Name nicht gefunden:", name)
	end
end

-- Liste der Koordinaten anzeigen
local function listCoords()
	local coords = loadCoords()
	for n,v in pairs(coords) do
		print(string.format("%s -> (%.2f, %.2f, %.2f)", n, v[1], v[2], v[3]))
	end
	if next(coords) == nil then
		print("(leer)")
	end
end

-- ========= UI DESIGN (DRAGGABLE) ==========
local gui = Instance.new("ScreenGui")
gui.Name = "CoordsSaverUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0, 20, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Hintergrund Schwarz
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true 
frame.Parent = gui

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 255, 0) -- Neon Rahmen
stroke.Transparency = 0

local title = Instance.new("TextLabel", frame)
title.Text = "CordGIG"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Position = UDim2.new(0, 10, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Credits
local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, -20, 0, 14)
credit.Position = UDim2.new(0, 45, 0, 22)
credit.BackgroundTransparency = 1
credit.Text = "von @MK"
credit.TextColor3 = Color3.fromRGB(0, 200, 0)
credit.Font = Enum.Font.Gotham
credit.TextSize = 11
credit.TextXAlignment = Enum.TextXAlignment.Left

-- ===== Buttons: Minimieren & Schließen =====
local minimized = false

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 24)
closeBtn.Position = UDim2.new(1, -35, 0, 3)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Grau
closeBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 30, 0, 24)
minBtn.Position = UDim2.new(1, -70, 0, 3)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Grau
minBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
minBtn.BorderSizePixel = 0
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		frame.Size = UDim2.new(0, 300, 0, 38)
		for _,v in pairs(frame:GetChildren()) do
			if v ~= title and v ~= credit and v ~= closeBtn and v ~= minBtn and not v:IsA("UIStroke") then
				if v:IsA("GuiObject") then v.Visible = false end
			end
		end
	else
		frame.Size = UDim2.new(0, 300, 0, 250)
		for _,v in pairs(frame:GetChildren()) do
			if v:IsA("GuiObject") then v.Visible = true end
		end
	end
end)

-- Eingabefeld
local nameBox = Instance.new("TextBox", frame)
nameBox.PlaceholderText = "Name eingeben..."
nameBox.PlaceholderColor3 = Color3.fromRGB(0, 100, 0)
nameBox.Size = UDim2.new(1, -20, 0, 28)
nameBox.Position = UDim2.new(0, 10, 0, 40)
nameBox.Text = ""
nameBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
nameBox.TextColor3 = Color3.fromRGB(0, 255, 0)
nameBox.BorderSizePixel = 0
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 14
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 5)

-- Speichern Button
local saveBtn = Instance.new("TextButton", frame)
saveBtn.Text = "Speichern"
saveBtn.Size = UDim2.new(0.5, -15, 0, 30)
saveBtn.Position = UDim2.new(0, 10, 0, 80)
saveBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Grau
saveBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
saveBtn.BorderSizePixel = 0
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 14
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)

-- Aktualisieren Button
local refreshBtn = Instance.new("TextButton", frame)
refreshBtn.Text = "Liste laden"
refreshBtn.Size = UDim2.new(0.5, -15, 0, 30)
refreshBtn.Position = UDim2.new(0.5, 5, 0, 80)
refreshBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Grau
refreshBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
refreshBtn.BorderSizePixel = 0
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 14
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 8)

-- Liste (Scrollbereich)
local listFrame = Instance.new("ScrollingFrame", frame)
listFrame.Size = UDim2.new(1, -20, 0, 100)
listFrame.Position = UDim2.new(0, 10, 0, 120)
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
listFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
listFrame.BorderSizePixel = 0
listFrame.ScrollBarThickness = 6
listFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)

local layout = Instance.new("UIListLayout", listFrame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

local function refreshList()
	for _,v in pairs(listFrame:GetChildren()) do
		if v:IsA("Frame") then v:Destroy() end
	end

	local coords = loadCoords()
	local keys = {}
	for name in pairs(coords) do table.insert(keys, name) end
	table.sort(keys, function(a, b) return string.lower(a) < string.lower(b) end)

	for _, name in ipairs(keys) do
		local item = Instance.new("Frame", listFrame)
		item.Size = UDim2.new(1, 0, 0, 30)
		item.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		item.BorderSizePixel = 0
		Instance.new("UICorner", item).CornerRadius = UDim.new(0, 7)

		local lbl = Instance.new("TextLabel", item)
		lbl.Size = UDim2.new(0.5, 0, 1, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = name
		lbl.TextColor3 = Color3.fromRGB(0, 255, 0)
		lbl.Font = Enum.Font.Gotham
		lbl.TextSize = 13

		local tpBtn = Instance.new("TextButton", item)
		tpBtn.Size = UDim2.new(0.25, -5, 1, -6)
		tpBtn.Position = UDim2.new(0.5, 5, 0, 3)
		tpBtn.Text = "TP"
		tpBtn.Font = Enum.Font.GothamBold
		tpBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
		tpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Grau
		Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
		tpBtn.MouseButton1Click:Connect(function() tpCoord(name) end)

		local delBtn = Instance.new("TextButton", item)
		delBtn.Size = UDim2.new(0.25, -5, 1, -6)
		delBtn.Position = UDim2.new(0.75, 5, 0, 3)
		delBtn.Text = "DEL"
		delBtn.Font = Enum.Font.GothamBold
		delBtn.TextColor3 = Color3.fromRGB(255, 50, 50) -- Rot zum Löschen
		delBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Grau
		Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
		delBtn.MouseButton1Click:Connect(function()
			delCoord(name)
			refreshList()
		end)
	end
end

saveBtn.MouseButton1Click:Connect(function()
	addCoord(nameBox.Text)
	refreshList()
end)

refreshBtn.MouseButton1Click:Connect(refreshList)
refreshList()

-- Globale Befehle für Executor Konsole
getgenv().Coords = {
	add = addCoord,
	tp = tpCoord,
	remove = delCoord,
	list = listCoords
}
