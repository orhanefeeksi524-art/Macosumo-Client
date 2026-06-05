-- MACOSUMO CLIENT - FINAL STABLE
local UIS, RunService, Players, Player, Camera = game:GetService("UserInputService"), game:GetService("RunService"), game:GetService("Players"), game:GetService("Players").LocalPlayer, workspace.CurrentCamera
local SG = Instance.new("ScreenGui", Player.PlayerGui); SG.ResetOnSpawn = false 

local Main = Instance.new("Frame", SG); Main.Size = UDim2.new(0, 450, 0, 350); Main.Position = UDim2.new(0.5, -225, 0.5, -175); Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.Active = true; Main.Draggable = true
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "MACOSUMO CLIENT"; Title.Font = Enum.Font.GothamBold; Title.TextColor3 = Color3.new(1,1,1); Title.TextSize = 30 

local AimEnabled, AimTarget, AimKey, ESPEnabled = false, "Head", Enum.UserInputType.MouseButton2, false
local R, G, B, IsRainbow, FovRadius = 255, 255, 255, false, 100
local fovCircle = Drawing.new("Circle"); fovCircle.Thickness = 1; fovCircle.Radius = FovRadius; fovCircle.Visible = false

-- Sayfaları oluştur
local Pages = {
    ["COMBAT ⚔️"] = Instance.new("Frame", Main), 
    ["Visuals"] = Instance.new("Frame", Main), 
    ["Settings"] = Instance.new("Frame", Main)
}

for n, f in pairs(Pages) do 
    f.Size = UDim2.new(1, -130, 1, -40); f.Position = UDim2.new(0, 130, 0, 40); f.BackgroundTransparency = 1; f.Visible = false 
end

-- [İçerik Oluşturucu]
local function createButton(page, text, pos, callback)
    local b = Instance.new("TextButton", page)
    b.Size = UDim2.new(0.8, 0, 0, 40); b.Position = pos; b.Text = text; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(function() callback(b) end)
end

-- COMBAT
createButton(Pages["COMBAT ⚔️"], "Aimbot: OFF", UDim2.new(0.1, 0, 0.05, 0), function(b) AimEnabled = not AimEnabled; b.Text = "Aimbot: "..(AimEnabled and "ON" or "OFF") end)
createButton(Pages["COMBAT ⚔️"], "Hedef: Head", UDim2.new(0.1, 0, 0.2, 0), function(b) AimTarget = (AimTarget == "Head" and "HumanoidRootPart" or "Head"); b.Text = "Hedef: "..AimTarget end)

-- VISUALS
createButton(Pages["Visuals"], "ESP: OFF", UDim2.new(0.1, 0, 0.05, 0), function(b) ESPEnabled = not ESPEnabled; b.Text = "ESP: "..(ESPEnabled and "ON" or "OFF") end)
createButton(Pages["Visuals"], "Circle: OFF", UDim2.new(0.1, 0, 0.2, 0), function(b) fovCircle.Visible = not fovCircle.Visible; b.Text = "Circle: "..(fovCircle.Visible and "ON" or "OFF") end)

-- SETTINGS (RENKLER)
for i, name in pairs({"R", "G", "B"}) do
    createButton(Pages["Settings"], name.." Ayarla", UDim2.new(0.1, 0, 0.05+(i-1)*0.15, 0), function() end).MouseButton1Down:Connect(function() 
        local c; c = RunService.RenderStepped:Connect(function() 
            local rel = math.clamp((UIS:GetMouseLocation().X - Main.AbsolutePosition.X)/450, 0, 1)
            if name == "R" then R = rel*255 elseif name == "G" then G = rel*255 elseif name == "B" then B = rel*255 end
            IsRainbow = false
            if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then c:Disconnect() end 
        end) 
    end)
end

-- [Motor ve Menü Geçişleri]
RunService.RenderStepped:Connect(function()
    local c = IsRainbow and Color3.fromHSV(tick()%5/5, 1, 1) or Color3.fromRGB(R,G,B)
    fovCircle.Position = UIS:GetMouseLocation(); fovCircle.Color = c
    Title.BackgroundColor3 = c; for _, o in pairs(Main:GetDescendants()) do if o:IsA("TextButton") then o.BackgroundColor3 = c end end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local hl = plr.Character:FindFirstChild("CHAMS") or Instance.new("Highlight", plr.Character); hl.Name = "CHAMS"
            hl.Enabled = ESPEnabled; hl.FillColor = c; hl.OutlineColor = c; hl.FillTransparency = 0.5
        end
    end
end)

local Sid = Instance.new("Frame", Main); Sid.Size = UDim2.new(0, 130, 1, -40); Sid.Position = UDim2.new(0, 0, 0, 40); Sid.BackgroundTransparency = 1
local tabs = {"COMBAT ⚔️", "Visuals", "Settings"}
for i, name in pairs(tabs) do 
    local b = Instance.new("TextButton", Sid)
    b.Size = UDim2.new(1,0,0,50); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1); b.Position = UDim2.new(0,0,0,(i-1)*50)
    b.MouseButton1Click:Connect(function() 
        for n, p in pairs(Pages) do p.Visible = (n == name) end 
    end) 
end
UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end end)
