-- MACOSUMO CLIENT V0.1
local UIS, RunService, Players, Player, Camera = game:GetService("UserInputService"), game:GetService("RunService"), game:GetService("Players"), game:GetService("Players").LocalPlayer, workspace.CurrentCamera
local SG = Instance.new("ScreenGui", Player.PlayerGui)
SG.ResetOnSpawn = false -- 

local Main = Instance.new("Frame", SG); Main.Size = UDim2.new(0, 450, 0, 350); Main.Position = UDim2.new(0.5, -225, 0.5, -175); Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.Active = true; Main.Draggable = true


local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "MACOSUMO CLIENT"; Title.Font = Enum.Font.GothamBold; Title.TextColor3 = Color3.new(1,1,1); Title.TextSize = 30 

local AimEnabled, AimTarget, AimKey, ESPEnabled = false, "Head", Enum.UserInputType.MouseButton2, false
local R, G, B, IsRainbow, FovRadius = 255, 255, 255, false, 100
local fovCircle = Drawing.new("Circle"); fovCircle.Thickness = 1; fovCircle.Radius = FovRadius; fovCircle.Visible = false

local Pages = {["COMBAT ⚔️"] = Instance.new("Frame", Main), ["Visusals"] = Instance.new("Frame", Main), ["Settings"] = Instance.new("Frame", Main)}
for n, f in pairs(Pages) do f.Size = UDim2.new(1, -130, 1, -40); f.Position = UDim2.new(0, 130, 0, 40); f.BackgroundTransparency = 1; f.Visible = false end

-- [Savaş şeyleri]
local btnA = Instance.new("TextButton", Pages["COMBAT ⚔️"]); btnA.Size = UDim2.new(0.8, 0, 0, 40); btnA.Position = UDim2.new(0.1, 0, 0.05, 0); btnA.Text = "Aimbot: OFF"
btnA.MouseButton1Click:Connect(function() AimEnabled = not AimEnabled; btnA.Text = "Aimbot: "..(AimEnabled and "ON" or "OFF") end)
local btnT = Instance.new("TextButton", Pages["COMBAT ⚔️"]); btnT.Size = UDim2.new(0.8, 0, 0, 40); btnT.Position = UDim2.new(0.1, 0, 0.2, 0); btnT.Text = "Hedef: Head"
btnT.MouseButton1Click:Connect(function() AimTarget = (AimTarget == "Head" and "HumanoidRootPart" or "Head"); btnT.Text = "Hedef: "..AimTarget end)
local btnK = Instance.new("TextButton", Pages["COMBAT ⚔️"]); btnK.Size = UDim2.new(0.8, 0, 0, 40); btnK.Position = UDim2.new(0.1, 0, 0.35, 0); btnK.Text = "Tuş: Sağ Tık"
btnK.MouseButton1Click:Connect(function() btnK.Text = "..."; local c; c = UIS.InputBegan:Connect(function(i) if i.UserInputType ~= Enum.UserInputType.MouseButton1 then AimKey = i.UserInputType ~= Enum.UserInputType.Keyboard and i.UserInputType or i.KeyCode; btnK.Text = "Tuş: "..tostring(AimKey.Name); c:Disconnect() end end) end)

-- [Görsel şeyler dayı]
local btnE = Instance.new("TextButton", Pages["Visusals"]); btnE.Size = UDim2.new(0.8, 0, 0, 40); btnE.Position = UDim2.new(0.1, 0, 0.05, 0); btnE.Text = "ESP: OFF"
btnE.MouseButton1Click:Connect(function() ESPEnabled = not ESPEnabled; btnE.Text = "ESP: "..(ESPEnabled and "ON" or "OFF") end)
local btnF = Instance.new("TextButton", Pages["Visusals"]); btnF.Size = UDim2.new(0.8, 0, 0, 40); btnF.Position = UDim2.new(0.1, 0, 0.2, 0); btnF.Text = "Circle: OFF"
btnF.MouseButton1Click:Connect(function() fovCircle.Visible = not fovCircle.Visible; btnF.Text = "Circle: "..(fovCircle.Visible and "ON" or "OFF") end)
local sF = Instance.new("TextButton", Pages["Visusals"]); sF.Size = UDim2.new(0.8, 0, 0, 40); sF.Position = UDim2.new(0.1, 0, 0.35, 0); sF.Text = "Circle Boyut (Kaydır)"
sF.MouseButton1Down:Connect(function() local c; c = RunService.RenderStepped:Connect(function() FovRadius = math.clamp((UIS:GetMouseLocation().X - Main.AbsolutePosition.X), 5, 600); fovCircle.Radius = FovRadius; if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then c:Disconnect() end end) end)

-- [Ayarlar]
for i, name in pairs({"R", "G", "B"}) do
    local b = Instance.new("TextButton", Pages["Settings"]); b.Size = UDim2.new(0.8, 0, 0, 40); b.Position = UDim2.new(0.1, 0, 0.05+(i-1)*0.15, 0); b.Text = name.." Ayarla"
    b.MouseButton1Down:Connect(function() local c; c = RunService.RenderStepped:Connect(function() local rel = math.clamp((UIS:GetMouseLocation().X - Main.AbsolutePosition.X)/450, 0, 1); if name == "R" then R = rel*255 elseif name == "G" then G = rel*255 elseif name == "B" then B = rel*255 end; IsRainbow = false; if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then c:Disconnect() end end) end)
end
local btnR = Instance.new("TextButton", Pages["Settings"]); btnR.Size = UDim2.new(0.8, 0, 0, 40); btnR.Position = UDim2.new(0.1, 0, 0.55, 0); btnR.Text = "ARGB MOD: OFF"
btnR.MouseButton1Click:Connect(function() IsRainbow = not IsRainbow; btnR.Text = "ARGB MOD: "..(IsRainbow and "ON" or "OFF") end)

-- [AnaKod]
RunService.RenderStepped:Connect(function()
    local c = IsRainbow and Color3.fromHSV(tick()%5/5, 1, 1) or Color3.fromRGB(R,G,B)
    fovCircle.Position = UIS:GetMouseLocation(); fovCircle.Color = c
    Title.BackgroundColor3 = c; for _, o in pairs(Main:GetDescendants()) do if o:IsA("TextButton") then o.BackgroundColor3 = c end end
    
    local isDown = typeof(AimKey) == "EnumItem" and (AimKey.EnumType == Enum.UserInputType and UIS:IsMouseButtonPressed(AimKey) or UIS:IsKeyDown(AimKey))
    if AimEnabled and isDown then
        local closest, dist = nil, FovRadius
        for _, plr in pairs(Players:GetPlayers()) do 
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild(AimTarget) then 
                local p, v = Camera:WorldToViewportPoint(plr.Character[AimTarget].Position)
                local d = (Vector2.new(p.X, p.Y) - UIS:GetMouseLocation()).Magnitude
                if v and d < dist then closest = plr.Character[AimTarget]; dist = d end 
            end 
        end
        if closest then Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position) end
    end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local hl = plr.Character:FindFirstChild("CHAMS") or Instance.new("Highlight", plr.Character); hl.Name = "CHAMS"
            hl.Enabled = ESPEnabled; hl.FillColor = c; hl.OutlineColor = c; hl.FillTransparency = 0.5
        end
    end
end)

local Sid = Instance.new("Frame", Main); Sid.Size = UDim2.new(0, 130, 1, -40); Sid.Position = UDim2.new(0, 0, 0, 40); Sid.BackgroundTransparency = 1
for _, name in pairs({"COMBAT ⚔️", "Visusals", "Settings"}) do local b = Instance.new("TextButton", Sid); b.Size = UDim2.new(1,0,0,50); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1); b.Position = UDim2.new(0,0,0,(name=="COMBAT ⚔️" and 0 or (name=="Visusals" and 50 or 100))); b.MouseButton1Click:Connect(function() for n, p in pairs(Pages) do p.Visible = (n == name) end end) end
UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end end)
