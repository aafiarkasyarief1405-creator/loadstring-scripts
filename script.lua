local P = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local PG = P:WaitForChild("PlayerGui")
for _, v in ipairs(PG:GetChildren()) do if v.Name == "DDS_Menu" then v:Destroy() end end

local function mk(cls, prp, par)
	local o = Instance.new(cls)
	for k, v in pairs(prp) do o[k] = v end
	o.Parent = par
	return o
end

local sg = mk("ScreenGui", {Name="DDS_Menu", ResetOnSpawn=false}, PG)
local fr = mk("Frame", {Size=UDim2.new(0,220,0,235), Position=UDim2.new(0.5,-110,0.2,0), BackgroundColor3=Color3.fromRGB(16,17,22), BorderSizePixel=1, Active=true, Draggable=true}, sg)
local hd = mk("Frame", {Size=UDim2.new(1,0,0,28), BackgroundColor3=Color3.fromRGB(24,26,34), BorderSizePixel=0}, fr)
mk("Frame", {Size=UDim2.new(0,3,0,14), Position=UDim2.new(0,8,0,7), BackgroundColor3=Color3.fromRGB(0,215,125), BorderSizePixel=0}, hd)
mk("TextLabel", {Size=UDim2.new(1,-45,1,0), Position=UDim2.new(0,16,0,0), BackgroundTransparency=1, Text="DDS | hijiro.mp4", TextColor3=Color3.fromRGB(235,240,250), Font=Enum.Font.SourceSansBold, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left}, hd)

local minB = mk("TextButton", {Size=UDim2.new(0,24,0,20), Position=UDim2.new(1,-28,0,4), BackgroundColor3=Color3.fromRGB(35,38,48), BorderSizePixel=0, Text="-", TextColor3=Color3.new(1,1,1), Font=Enum.Font.SourceSansBold, TextSize=15}, hd)
local ct = mk("Frame", {Size=UDim2.new(1,0,1,-28), Position=UDim2.new(0,0,0,28), BackgroundTransparency=1}, fr)

local mini = false
minB.MouseButton1Click:Connect(function()
	mini = not mini
	ct.Visible = not mini
	fr.Size = mini and UDim2.new(0,220,0,28) or UDim2.new(0,220,0,235)
	minB.Text = mini and "+" or "-"
end)

local bstB = mk("TextButton", {Size=UDim2.new(0.9,0,0,34), Position=UDim2.new(0.05,0,0,10), BackgroundColor3=Color3.fromRGB(28,30,38), BorderSizePixel=1, TextColor3=Color3.new(1,1,1), Font=Enum.Font.SourceSansBold, TextSize=14, Text="  BOOST LOCK [ OFF ]", TextXAlignment=Enum.TextXAlignment.Left}, ct)
local sBar = mk("Frame", {Size=UDim2.new(0,4,1,0), BackgroundColor3=Color3.fromRGB(220,65,75), BorderSizePixel=0}, bstB)

local c1 = mk("Frame", {Size=UDim2.new(0.43,0,0,44), Position=UDim2.new(0.05,0,0,52), BackgroundColor3=Color3.fromRGB(24,26,34), BorderSizePixel=1}, ct)
mk("TextLabel", {Size=UDim2.new(1,-6,0,15), Position=UDim2.new(0,5,0,2), BackgroundTransparency=1, Text="TOP SPEED", TextColor3=Color3.fromRGB(150,160,180), Font=Enum.Font.SourceSansBold, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left}, c1)
local spdBox = mk("TextBox", {Size=UDim2.new(1,-6,0,22), Position=UDim2.new(0,5,0,18), BackgroundTransparency=1, TextColor3=Color3.new(1,1,1), Text="315", Font=Enum.Font.SourceSansBold, TextSize=15, TextXAlignment=Enum.TextXAlignment.Left}, c1)

local c2 = mk("Frame", {Size=UDim2.new(0.43,0,0,44), Position=UDim2.new(0.52,0,0,52), BackgroundColor3=Color3.fromRGB(24,26,34), BorderSizePixel=1}, ct)
mk("TextLabel", {Size=UDim2.new(1,-6,0,15), Position=UDim2.new(0,5,0,2), BackgroundTransparency=1, Text="RAMP (DETIK)", TextColor3=Color3.fromRGB(150,160,180), Font=Enum.Font.SourceSansBold, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left}, c2)
local rmpBox = mk("TextBox", {Size=UDim2.new(1,-6,0,22), Position=UDim2.new(0,5,0,18), BackgroundTransparency=1, TextColor3=Color3.new(1,1,1), Text="3.0", Font=Enum.Font.SourceSansBold, TextSize=15, TextXAlignment=Enum.TextXAlignment.Left}, c2)

mk("TextLabel", {Size=UDim2.new(0.9,0,0,16), Position=UDim2.new(0.05,0,0,104), BackgroundTransparency=1, Text="SENTUL STEALTH TELEPORT", TextColor3=Color3.fromRGB(130,140,160), Font=Enum.Font.SourceSansBold, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left}, ct)
local tpB = mk("TextButton", {Size=UDim2.new(0.9,0,0,34), Position=UDim2.new(0.05,0,0,122), BackgroundColor3=Color3.fromRGB(18,150,90), BorderSizePixel=0, TextColor3=Color3.new(1,1,1), Font=Enum.Font.SourceSansBold, TextSize=14, Text="TP KE START (STEALTH)"}, ct)
local setB = mk("TextButton", {Size=UDim2.new(0.9,0,0,32), Position=UDim2.new(0.05,0,0,162), BackgroundColor3=Color3.fromRGB(32,36,48), BorderSizePixel=1, TextColor3=Color3.fromRGB(180,200,235), Font=Enum.Font.SourceSansBold, TextSize=13, Text="SET TITIK START LURUS"}, ct)

local savedRot, savedPos, boosting, lockedDir, conn, tping = nil, nil, false, nil, nil, false

local function getSeat()
	local h = P.Character and P.Character:FindFirstChildOfClass("Humanoid")
	return (h and h.SeatPart and h.SeatPart:IsA("VehicleSeat")) and h.SeatPart or nil
end

local function offBoost()
	boosting = false
	bstB.Text = "  BOOST LOCK [ OFF ]"
	bstB.BackgroundColor3 = Color3.fromRGB(28,30,38)
	sBar.BackgroundColor3 = Color3.fromRGB(220,65,75)
	if conn then conn:Disconnect() end
end

bstB.MouseButton1Click:Connect(function()
	if tping then return end
	if boosting then offBoost() return end
	local s = getSeat()
	if not s then bstB.Text = "  NAIK MOTOR DULU!" task.wait(1) bstB.Text = "  BOOST LOCK [ OFF ]" return end
	local lk = s.CFrame.LookVector
	lockedDir = Vector3.new(lk.X, 0, lk.Z).Unit
	boosting = true
	bstB.Text = "  BOOST LOCK [ ON ]"
	bstB.BackgroundColor3 = Color3.fromRGB(20,48,36)
	sBar.BackgroundColor3 = Color3.fromRGB(0,235,135)
	local initSpd = Vector3.new(s.Velocity.X, 0, s.Velocity.Z).Magnitude
	local el = 0
	conn = RS.Heartbeat:Connect(function(dt)
		local cs = getSeat()
		if not boosting or not cs then offBoost() return end
		local tgt, rmp = tonumber(spdBox.Text) or 315, tonumber(rmpBox.Text) or 3.0
		local spd = tgt
		if rmp > 0 then
			el = el + dt
			local a = math.clamp(el / rmp, 0, 1)
			spd = initSpd + (tgt - initSpd) * (1 - (1 - a) * (1 - a))
		end
		cs.RotVelocity = Vector3.zero
		cs.CFrame = CFrame.new(cs.Position, cs.Position + lockedDir)
		cs.Velocity = Vector3.new(lockedDir.X * spd, cs.Velocity.Y, lockedDir.Z * spd)
	end)
end)

setB.MouseButton1Click:Connect(function()
	local s = getSeat()
	local m = s and s:FindFirstAncestorOfClass("Model")
	local r = P.Character and P.Character:FindFirstChild("HumanoidRootPart")
	if m then
		local piv = m:GetPivot()
		savedPos = piv.Position
		savedRot = piv - piv.Position
	elseif r then
		local cf = r.CFrame
		savedPos = cf.Position
		savedRot = cf - cf.Position
	else return end
	setB.Text = "TITIK TERSIMPAN!" task.wait(1) setB.Text = "SET TITIK START LURUS"
end)

-- STEALTH UNDERGROUND GLIDE TELEPORT
tpB.MouseButton1Click:Connect(function()
	if tping then return end
	if not savedPos or not savedRot then tpB.Text = "SET TITIK DULU!" task.wait(1) tpB.Text = "TP KE START (STEALTH)" return end
	if boosting then offBoost() end
	local char = P.Character
	local s = getSeat()
	local obj = (s and s:FindFirstAncestorOfClass("Model")) or (char and char:FindFirstChild("HumanoidRootPart"))
	if not obj then return end
	tping = true
	tpB.Text = "OTW BAWAH TANAH..."

	-- Simpan status CanCollide asli agar tidak nyangkut di aspal saat mendelep
	local colCache = {}
	local function setNoclip(state)
		for _, target in ipairs({obj, char}) do
			if target then
				for _, p in ipairs(target:GetDescendants()) do
					if p:IsA("BasePart") then
						if state then
							if colCache[p] == nil then colCache[p] = p.CanCollide end
							p.CanCollide = false
						elseif colCache[p] ~= nil then
							p.CanCollide = colCache[p]
						end
					end
				end
			end
		end
	end

	setNoclip(true)
	local startPos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
	-- Mendelep 12 studs ke bawah tanah di awal perjalanan
	local curPos = Vector3.new(startPos.X, startPos.Y - 12, startPos.Z)
	local underTarget = Vector3.new(savedPos.X, savedPos.Y - 12, savedPos.Z)
	local surfaceTarget = savedPos + Vector3.new(0, 1.5, 0)

	local tc
	tc = RS.Heartbeat:Connect(function(dt)
		local diff = underTarget - curPos
		if diff.Magnitude <= 6 then
			-- Muncul kembali ke atas permukaan jalan tepat di garis start
			local finalCF = CFrame.new(surfaceTarget) * savedRot
			if obj:IsA("Model") then
				for _, p in ipairs(obj:GetDescendants()) do if p:IsA("BasePart") then p.Velocity, p.RotVelocity = Vector3.zero, Vector3.zero end end
				obj:PivotTo(finalCF)
			else obj.Velocity, obj.CFrame = Vector3.zero, finalCF end
			setNoclip(false)
			tc:Disconnect()
			tping = false
			tpB.Text = "TP KE START (STEALTH)"
			return
		end

		curPos = curPos + diff.Unit * math.min(diff.Magnitude, 350 * dt)
		local nCF = CFrame.new(curPos) * savedRot
		if obj:IsA("Model") then
			for _, p in ipairs(obj:GetDescendants()) do if p:IsA("BasePart") then p.Velocity, p.RotVelocity = Vector3.zero, Vector3.zero end end
			obj:PivotTo(nCF)
		else obj.Velocity, obj.CFrame = Vector3.zero, nCF end
	end)
end)
