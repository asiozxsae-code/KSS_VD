-- Mobile Shift Lock Script (with Button Position Lock)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local shiftLockEnabled = false
local buttonLocked = false

-- 1. สร้าง UI หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileShiftLockGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ปุ่ม Shift Lock
local ShiftBtn = Instance.new("ImageButton")
ShiftBtn.Name = "ShiftLockButton"
ShiftBtn.Size = UDim2.new(0, 55, 0, 55)
ShiftBtn.Position = UDim2.new(0.82, 0, 0.65, 0)
ShiftBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ShiftBtn.BackgroundTransparency = 0.4
ShiftBtn.Image = "rbxassetid://6031068433"
ShiftBtn.Draggable = true -- เริ่มต้นสามารถลากได้
ShiftBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(1, 0)
BtnCorner.Parent = ShiftBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(255, 255, 255)
BtnStroke.Thickness = 2
BtnStroke.Transparency = 0.5
BtnStroke.Parent = ShiftBtn

-- ปุ่มสำหรับ "ล็อคตำแหน่งปุ่ม" (Lock Position)
local PosLockBtn = Instance.new("TextButton")
PosLockBtn.Name = "PosLockBtn"
PosLockBtn.Size = UDim2.new(0, 30, 0, 30)
PosLockBtn.Position = UDim2.new(1, 5, 0, -10)
PosLockBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PosLockBtn.Text = "🔓"
PosLockBtn.TextSize = 14
PosLockBtn.Parent = ShiftBtn

local PosLockCorner = Instance.new("UICorner")
PosLockCorner.CornerRadius = UDim.new(1, 0)
PosLockCorner.Parent = PosLockBtn

-- จุด Center Dot กลางจอ
local CenterDot = Instance.new("Frame")
CenterDot.Size = UDim2.new(0, 5, 0, 5)
CenterDot.Position = UDim2.new(0.5, -2, 0.5, -2)
CenterDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CenterDot.Visible = false
CenterDot.Parent = ScreenGui

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = CenterDot

-- 2. ระบบเปิด/ปิด การลากปุ่ม (Lock Position)
PosLockBtn.MouseButton1Click:Connect(function()
	buttonLocked = not buttonLocked
	ShiftBtn.Draggable = not buttonLocked
	if buttonLocked then
		PosLockBtn.Text = "🔒"
		PosLockBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	else
		PosLockBtn.Text = "🔓"
		PosLockBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end
end)

-- 3. ระบบ Toggle Shift Lock
ShiftBtn.MouseButton1Click:Connect(function()
	shiftLockEnabled = not shiftLockEnabled
	CenterDot.Visible = shiftLockEnabled
	
	if shiftLockEnabled then
		ShiftBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
		ShiftBtn.BackgroundTransparency = 0.2
		BtnStroke.Color = Color3.fromRGB(0, 220, 255)
	else
		ShiftBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		ShiftBtn.BackgroundTransparency = 0.4
		BtnStroke.Color = Color3.fromRGB(255, 255, 255)
	end
end)

-- 4. Loop ให้ตัวละครหมุนตามกล้อง
RunService.RenderStepped:Connect(function()
	if shiftLockEnabled and LocalPlayer.Character then
		local char = LocalPlayer.Character
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		
		if hrp and hum then
			hum.AutoRotate = false
			local lookVector = Camera.CFrame.LookVector
			hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookVector.X, 0, lookVector.Z))
		end
	else
		if LocalPlayer.Character then
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.AutoRotate = true
			end
		end
	end
end)
