--====================================================
-- NGP SCRIPT | CYBER HUB GUI
-- ESP Hitbox + ESP Tracer + Aimbot + GodMode + Infinite Jump + Movement Cheats
--====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local character = player.Character or player.CharacterAdded:Wait()

----------------------------------------------------
-- GUI
----------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "NGPScript"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(1000,600)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(18,18,22)
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.fromOffset(200,30)
title.Position = UDim2.fromOffset(15,8)
title.BackgroundTransparency = 1
title.Text = "ngp script"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(80,200,255)

-- Close button
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.fromOffset(30,30)
closeBtn.Position = UDim2.fromScale(1,0) + UDim2.fromOffset(-35,5)
closeBtn.Text = "✖"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.fromRGB(255,0,0)
closeBtn.BackgroundTransparency = 1
closeBtn.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

----------------------------------------------------
-- Sidebar
----------------------------------------------------
local sidebar = Instance.new("Frame", main)
sidebar.Position = UDim2.fromOffset(0,42)
sidebar.Size = UDim2.new(0,200,1,-42)
sidebar.BackgroundColor3 = Color3.fromRGB(20,20,26)

local layout = Instance.new("UIListLayout", sidebar)
layout.Padding = UDim.new(0,6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

----------------------------------------------------
-- Pages
----------------------------------------------------
local pages = Instance.new("Folder", main)
pages.Name = "Pages"

local function createPage(name)
	local f = Instance.new("Frame", pages)
	f.Name = name
	f.Position = UDim2.fromOffset(210,52)
	f.Size = UDim2.new(1,-220,1,-62)
	f.BackgroundTransparency = 1
	f.Visible = false
	return f
end

local MainFarm = createPage("Main")
local Settings = createPage("Settings")
local Help = createPage("Help")
local EmotesPage = createPage("Emotes")
MainFarm.Visible = true

local function sidebarButton(text,page)
	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(1,-20,0,40)
	btn.Text = "  "..text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.TextColor3 = Color3.fromRGB(220,220,220)
	btn.BackgroundColor3 = Color3.fromRGB(26,26,32)
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
	btn.MouseButton1Click:Connect(function()
		for _,p in pairs(pages:GetChildren()) do
			p.Visible = false
		end
		page.Visible = true
	end)
end

sidebarButton("Main", MainFarm)
sidebarButton("Settings", Settings)
sidebarButton("Help", Help)
sidebarButton("Emotes", EmotesPage)

----------------------------------------------------
-- UI Helpers
----------------------------------------------------
local function createToggle(parent,text,callback)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1,0,0,45)
	frame.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", frame)
	label.Text = text
	label.Size = UDim2.new(1,0,1,0)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.BackgroundTransparency = 1
	label.Position = UDim2.fromOffset(15,0)

	local toggle = Instance.new("Frame", frame)
	toggle.Size = UDim2.fromOffset(46,22)
	toggle.Position = UDim2.fromScale(1,0.5) + UDim2.fromOffset(-60,-11)
	toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame", toggle)
	knob.Size = UDim2.fromOffset(18,18)
	knob.Position = UDim2.fromOffset(2,2)
	knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

	local state = false
	toggle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			state = not state
			TweenService:Create(toggle,TweenInfo.new(0.2),{
				BackgroundColor3 = state and Color3.fromRGB(80,200,255) or Color3.fromRGB(60,60,60)
			}):Play()
			TweenService:Create(knob,TweenInfo.new(0.2),{
				Position = state and UDim2.fromOffset(26,2) or UDim2.fromOffset(2,2)
			}):Play()
			callback(state)
		end
	end)
	return frame
end

local function createCategory(parent,titleText)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1,0,0,400)
	frame.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout", frame)
	layout.Padding = UDim.new(0,15)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1,0,0,25)
	label.BackgroundTransparency = 1
	label.Text = titleText
	label.Font = Enum.Font.GothamBold
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Color3.fromRGB(150,150,150)
	label.LayoutOrder = 1

	return frame
end

----------------------------------------------------
-- ESP + Tracers Amélioré
----------------------------------------------------
ESPEnabled = false
TracerEnabled = false

local ESPObjects = {}

local function removeESP(p)
	if ESPObjects[p] then
		for _,obj in pairs(ESPObjects[p]) do
			obj:Remove()
		end
		ESPObjects[p] = nil
	end
end

local function createESP(p)
	local box = {}
	for i = 1,4 do
		local l = Drawing.new("Line")
		l.Color = Color3.fromRGB(255,0,0)
		l.Thickness = 2
		l.Visible = false
		box[i] = l
	end

	local tracer = Drawing.new("Line")
	tracer.Color = Color3.fromRGB(0,255,0)
	tracer.Thickness = 1
	tracer.Visible = false

	ESPObjects[p] = {box = box, tracer = tracer}
end

for _,p in ipairs(Players:GetPlayers()) do
	if p ~= player then createESP(p) end
end

Players.PlayerAdded:Connect(function(p)
	if p ~= player then createESP(p) end
end)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
	for p,data in pairs(ESPObjects) do
		local char = p.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")

		if not char or not hrp or not hum or hum.Health <= 0 then
			for _,l in pairs(data.box) do l.Visible = false end
			data.tracer.Visible = false
			continue
		end

		local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
		if not onScreen then
			for _,l in pairs(data.box) do l.Visible = false end
			data.tracer.Visible = false
			continue
		end

		-- BOX ESP
		if ESPEnabled then
			local scale = 1 / (Camera.CFrame.Position - hrp.Position).Magnitude * 100
			local width = 35 * scale
			local height = 50 * scale

			local tl = Vector2.new(pos.X - width, pos.Y - height)
			local tr = Vector2.new(pos.X + width, pos.Y - height)
			local br = Vector2.new(pos.X + width, pos.Y + height)
			local bl = Vector2.new(pos.X - width, pos.Y + height)

			data.box[1].From, data.box[1].To = tl, tr
			data.box[2].From, data.box[2].To = tr, br
			data.box[3].From, data.box[3].To = br, bl
			data.box[4].From, data.box[4].To = bl, tl

			for _,l in pairs(data.box) do l.Visible = true end
		else
			for _,l in pairs(data.box) do l.Visible = false end
		end

		-- TRACER
		if TracerEnabled then
			data.tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
			data.tracer.To = Vector2.new(pos.X, pos.Y)
			data.tracer.Visible = true
		else
			data.tracer.Visible = false
		end
	end
end)

----------------------------------------------------
-- CHEATS
----------------------------------------------------
local AimbotEnabled = false
local NoclipEnabled = false
local SpeedEnabled = false
local FlyEnabled = false
local GodModeEnabled = false
local InfiniteJumpEnabled = false
local SpeedValue = 50
local FlySpeed = 50
local CheatClosed = false

local function noclip()
	while NoclipEnabled do
		for _,v in pairs(player.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
		RunService.Heartbeat:Wait()
	end
end

local function fly()
	local hv = Instance.new("BodyVelocity")
	hv.MaxForce = Vector3.new(400000,400000,400000)
	hv.Velocity = Vector3.new(0,0,0)
	hv.Parent = player.Character.HumanoidRootPart
	while FlyEnabled do
		local dir = Vector3.new(0,0,0)
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
		if dir.Magnitude > 0 then
			hv.Velocity = dir.Unit * FlySpeed
		else
			hv.Velocity = Vector3.new(0,0,0)
		end
		RunService.Heartbeat:Wait()
	end
	hv:Destroy()
end

-- Speed + GodMode combiné pour éviter conflits
RunService.RenderStepped:Connect(function()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		local hum = player.Character.Humanoid

		-- Speed
		if SpeedEnabled then hum.WalkSpeed = SpeedValue
		else if hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end end

		-- God Mode
		if GodModeEnabled and hum.Health < hum.MaxHealth then
			hum.Health = hum.MaxHealth
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if AimbotEnabled then
		local closestDist = math.huge
		local target = nil
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = p.Character.HumanoidRootPart
				local dist = (hrp.Position - Camera.CFrame.Position).Magnitude
				if dist < closestDist then
					closestDist = dist
					target = hrp
				end
			end
		end
		if target then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
		end
	end
end)

----------------------------------------------------
-- MAIN CATEGORY
----------------------------------------------------
local mainCat = createCategory(MainFarm,"Combat / Movement")
createToggle(mainCat,"Aimbot",function(v) AimbotEnabled = v end)
createToggle(mainCat,"Speed",function(v) SpeedEnabled = v end)
createToggle(mainCat,"Noclip",function(v)
	NoclipEnabled = v
	if v then coroutine.wrap(noclip)() end
end)
createToggle(mainCat,"Fly",function(v) FlyEnabled = v
	if v then coroutine.wrap(fly)() end
end)
createToggle(mainCat,"God Mode",function(v) GodModeEnabled = v end)
createToggle(mainCat,"Infinite Jump",function(v) InfiniteJumpEnabled = v end)

-- Slider FlySpeed
local function createSlider(parent,text,min,max,default,callback)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1,0,0,45)
	frame.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", frame)
	label.Text = text.." : "..default
	label.Size = UDim2.new(1,0,1,0)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.BackgroundTransparency = 1
	label.Position = UDim2.fromOffset(15,0)

	local slider = Instance.new("Frame", frame)
	slider.Size = UDim2.fromOffset(150,10)
	slider.Position = UDim2.fromScale(1,0.5) + UDim2.fromOffset(-160,-5)
	slider.BackgroundColor3 = Color3.fromRGB(60,60,60)
	Instance.new("UICorner", slider).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame", slider)
	knob.Size = UDim2.fromOffset(10,10)
	knob.Position = UDim2.fromOffset((default-min)/(max-min)*140,0)
	knob.BackgroundColor3 = Color3.fromRGB(80,200,255)
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

	local dragging = false
	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
	end)
	knob.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local pos = math.clamp(input.Position.X - slider.AbsolutePosition.X,0,140)
			knob.Position = UDim2.fromOffset(pos,0)
			local value = min + (pos/140)*(max-min)
			label.Text = text.." : "..math.floor(value)
			callback(value)
		end
	end)
end

createSlider(mainCat,"Fly Speed",10,200,50,function(v) FlySpeed = v end)

----------------------------------------------------
-- TP PLAYER (AJOUT)
----------------------------------------------------
local tpFrame = Instance.new("Frame", mainCat)
tpFrame.Size = UDim2.new(1,0,0,45)
tpFrame.BackgroundTransparency = 1

local tpLabel = Instance.new("TextLabel", tpFrame)
tpLabel.Size = UDim2.new(0.35,0,1,0)
tpLabel.Position = UDim2.fromOffset(15,0)
tpLabel.Text = "TP Player:"
tpLabel.Font = Enum.Font.GothamBold
tpLabel.TextSize = 14
tpLabel.TextXAlignment = Enum.TextXAlignment.Left
tpLabel.TextColor3 = Color3.fromRGB(255,255,255)
tpLabel.BackgroundTransparency = 1

local tpBox = Instance.new("TextBox", tpFrame)
tpBox.Size = UDim2.new(0.4,0,0.65,0)
tpBox.Position = UDim2.new(0.38,0,0.18,0)
tpBox.PlaceholderText = "Username"
tpBox.Text = ""
tpBox.ClearTextOnFocus = false
tpBox.Font = Enum.Font.Gotham
tpBox.TextSize = 14
tpBox.TextColor3 = Color3.fromRGB(255,255,255)
tpBox.BackgroundColor3 = Color3.fromRGB(40,40,50)
Instance.new("UICorner", tpBox).CornerRadius = UDim.new(0,6)

local tpBtn = Instance.new("TextButton", tpFrame)
tpBtn.Size = UDim2.new(0.18,0,0.65,0)
tpBtn.Position = UDim2.new(0.8,0,0.18,0)
tpBtn.Text = "TP"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 14
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0,6)

tpBtn.MouseButton1Click:Connect(function()
	local targetName = tpBox.Text
	if targetName and targetName ~= "" then
		local targetPlayer = Players:FindFirstChild(targetName)
		if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = targetPlayer.Character.HumanoidRootPart
			character:SetPrimaryPartCFrame(hrp.CFrame + Vector3.new(0,3,0))
		end
	end
end)

----------------------------------------------------
-- SETTINGS
----------------------------------------------------
local visualsCat = createCategory(Settings,"Visuals")
createToggle(visualsCat,"ESP Hitbox",function(v) ESPEnabled = v end)
createToggle(visualsCat,"ESP Tracer",function(v) TracerEnabled = v end)

----------------------------------------------------
-- HELP PAGE
----------------------------------------------------
local helpText = Instance.new("TextLabel", Help)
helpText.Size = UDim2.new(1,0,1,0)
helpText.BackgroundTransparency = 1
helpText.TextWrapped = true
helpText.Font = Enum.Font.GothamBold
helpText.TextSize = 16
helpText.TextColor3 = Color3.fromRGB(255,255,255)
helpText.Text = "Press E to close/open the GUI. Tracers always visible, hitboxes visible only if you look at the player."

----------------------------------------------------
-- EMOTES CATEGORY
----------------------------------------------------
local emotesCat = createCategory(EmotesPage,"Emotes")
local emoteAnimations = {
    Wave = "rbxassetid://507771019",
    Dance = "rbxassetid://507770239"
}

local animator = character:WaitForChild("Humanoid"):WaitForChild("Animator") or Instance.new("Animator", character.Humanoid)
local activeEmotes = {}

for name,id in pairs(emoteAnimations) do
	createToggle(emotesCat,name,function(v)
		if v then
			if activeEmotes[name] then return end
			local anim = Instance.new("Animation")
			anim.AnimationId = id
			local success, track = pcall(function() return animator:LoadAnimation(anim) end)
			if success and track then track:Play(); activeEmotes[name]=track
			else warn("Animation "..name.." ne peut pas être jouée.") end
		else
			if activeEmotes[name] then activeEmotes[name]:Stop(); activeEmotes[name]:Destroy(); activeEmotes[name]=nil end
		end
	end)
end

----------------------------------------------------
-- Infinite Jump
----------------------------------------------------
UIS.JumpRequest:Connect(function()
	if InfiniteJumpEnabled then
		if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

----------------------------------------------------
-- Keybinds
----------------------------------------------------
UIS.InputBegan:Connect(function(i,gp)
	if not gp then
		if i.KeyCode == Enum.KeyCode.E and not CheatClosed then
			gui.Enabled = not gui.Enabled
		elseif i.KeyCode == Enum.KeyCode.KeypadMultiply then
			gui:Destroy()
			CheatClosed = true
		end
	end
end)
