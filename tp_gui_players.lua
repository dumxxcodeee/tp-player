-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ================= GUI =================
local Gui = Instance.new("ScreenGui")
Gui.Name = "TeleportGui"
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Gui.ResetOnSpawn = false

local BackGround = Instance.new("Frame")
BackGround.Parent = Gui
BackGround.Size = UDim2.new(0,220,0,90)
BackGround.Position = UDim2.new(0.4,0,0.45,0)
BackGround.BackgroundColor3 = Color3.fromRGB(50,50,50)
BackGround.Active = true
BackGround.Draggable = true
BackGround.BorderSizePixel = 0

-- ================= BUTTONS =================
local ExitGuiButton = Instance.new("TextButton")
ExitGuiButton.Parent = BackGround
ExitGuiButton.Size = UDim2.new(0,20,0,20)
ExitGuiButton.Position = UDim2.new(1,-22,0,-22)
ExitGuiButton.Text = "X"
ExitGuiButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
ExitGuiButton.TextColor3 = Color3.fromRGB(255,255,255)

local TeleportButton = Instance.new("TextButton")
TeleportButton.Parent = BackGround
TeleportButton.Size = UDim2.new(0,20,0,20)
TeleportButton.Position = UDim2.new(1,-46,0,-22)
TeleportButton.Text = "TP"

local FastTeleportButton = Instance.new("TextButton")
FastTeleportButton.Parent = BackGround
FastTeleportButton.Size = UDim2.new(0,20,0,20)
FastTeleportButton.Position = UDim2.new(1,-70,0,-22)
FastTeleportButton.BackgroundColor3 = Color3.fromRGB(255,64,67)
FastTeleportButton.Text = ""

-- ================= PLAYER TABLE =================
local PlayerTable = Instance.new("ScrollingFrame")
PlayerTable.Parent = BackGround
PlayerTable.Position = UDim2.new(0.05,0,0.1,0)
PlayerTable.Size = UDim2.new(0,200,0,70)
PlayerTable.CanvasSize = UDim2.new(0,0,0,0)
PlayerTable.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerTable.ScrollBarImageTransparency = 0.3
PlayerTable.BackgroundColor3 = Color3.fromRGB(80,80,80)
PlayerTable.BorderSizePixel = 2

local Layout = Instance.new("UIListLayout")
Layout.Parent = PlayerTable
Layout.Padding = UDim.new(0,2)

-- ================= LOGIC =================
local selectedPlayer = nil
local fastTpMode = false
local guiMode = true

local function clearSelection()
	for _, v in pairs(PlayerTable:GetChildren()) do
		if v:IsA("TextButton") then
			v.BackgroundColor3 = Color3.fromRGB(60,60,60)
		end
	end
end

local function createPlayerRow(player)
	if player == LocalPlayer then return end

	local row = Instance.new("TextButton")
	row.Parent = PlayerTable
	row.Size = UDim2.new(1,0,0,22)
	row.BackgroundColor3 = Color3.fromRGB(60,60,60)
	row.BorderSizePixel = 0
	row.Text = "  "..player.Name
	row.TextXAlignment = Enum.TextXAlignment.Left
	row.Font = Enum.Font.JosefinSans
	row.TextSize = 14
	row.TextColor3 = Color3.fromRGB(255,255,255)

	row.MouseButton1Click:Connect(function()
		clearSelection()
		selectedPlayer = player
		row.BackgroundColor3 = Color3.fromRGB(67,255,67)
	end)
end

-- ================= PLAYER LOAD =================
for _, plr in ipairs(Players:GetPlayers()) do
	createPlayerRow(plr)
end

Players.PlayerAdded:Connect(createPlayerRow)

Players.PlayerRemoving:Connect(function(plr)
	for _, row in pairs(PlayerTable:GetChildren()) do
		if row:IsA("TextButton") and row.Text:find(plr.Name) then
			row:Destroy()
		end
	end
	if selectedPlayer == plr then
		selectedPlayer = nil
	end
end)

-- ================= TELEPORT =================
TeleportButton.MouseButton1Click:Connect(function()
	if selectedPlayer and selectedPlayer.Character and LocalPlayer.Character then
		LocalPlayer.Character.HumanoidRootPart.CFrame =
			selectedPlayer.Character.HumanoidRootPart.CFrame
	end
end)

FastTeleportButton.MouseButton1Click:Connect(function()
	fastTpMode = not fastTpMode
	FastTeleportButton.BackgroundColor3 =
		fastTpMode and Color3.fromRGB(67,255,67) or Color3.fromRGB(255,64,67)

	task.spawn(function()
		while fastTpMode do
			task.wait()
			if selectedPlayer and selectedPlayer.Character and LocalPlayer.Character then
				LocalPlayer.Character.HumanoidRootPart.CFrame =
					selectedPlayer.Character.HumanoidRootPart.CFrame
			end
		end
	end)
end)

-- ================= EXIT =================
ExitGuiButton.MouseButton1Click:Connect(function()
	Gui:Destroy()
end)

-- ================= HIDE GUI (INSERT) =================
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Insert then
		guiMode = not guiMode
		Gui.Enabled = guiMode
	end
end)