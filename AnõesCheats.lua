
--==================================================
--          ANÕES CHEATS - ALL IN ONE
--              Painel Lua | Mobile
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Purple = Color3.fromRGB(145, 55, 255)
local Dark = Color3.fromRGB(13, 10, 20)
local White = Color3.fromRGB(255,255,255)

local Screen = Instance.new("ScreenGui")
Screen.Name = "ANOES_CHEATS"
Screen.ResetOnSpawn = false

pcall(function()
    Screen.Parent = game:GetService("CoreGui")
end)

if not Screen.Parent then
    Screen.Parent = Player:WaitForChild("PlayerGui")
end

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(490, 340)
Main.Position = UDim2.new(0.5,-245,0.5,-170)
Main.BackgroundColor3 = Dark
Main.BorderSizePixel = 0
Main.Parent = Screen

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,12)

local Border = Instance.new("UIStroke",Main)
Border.Color = Purple
Border.Thickness = 2

local function Create(class,parent,props)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

-- CABEÇALHO

local Header = Create("TextLabel",Main,{
    Size = UDim2.new(1,-50,0,45),
    Position = UDim2.fromOffset(12,0),
    BackgroundTransparency = 1,
    Text = "ANÕES CHEATS",
    TextColor3 = Purple,
    TextSize = 23,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
})

local Minimize = Create("TextButton",Main,{
    Size = UDim2.fromOffset(35,32),
    Position = UDim2.new(1,-42,0,7),
    BackgroundColor3 = Purple,
    Text = "—",
    TextColor3 = White,
    Font = Enum.Font.GothamBold,
    TextSize = 20
})
Instance.new("UICorner",Minimize).CornerRadius = UDim.new(0,7)

-- BOTÃO FLUTUANTE

local Open = Create("TextButton",Screen,{
    Size = UDim2.fromOffset(65,50),
    Position = UDim2.new(0,15,0.5,0),
    BackgroundColor3 = Dark,
    Text = "ANÕES",
    TextColor3 = White,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    Visible = false
})
Instance.new("UICorner",Open).CornerRadius = UDim.new(0,10)

Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    Open.Visible = true
end)

Open.MouseButton1Click:Connect(function()
    Main.Visible = true
    Open.Visible = false
end)

-- MENU LATERAL

local Menu = Create("Frame",Main,{
    Size = UDim2.fromOffset(125,280),
    Position = UDim2.fromOffset(8,50),
    BackgroundColor3 = Color3.fromRGB(25,18,35),
    BorderSizePixel = 0
})
Instance.new("UICorner",Menu).CornerRadius = UDim.new(0,8)

local MenuList = Create("UIListLayout",Menu,{
    Padding = UDim.new(0,6),
    HorizontalAlignment = Enum.HorizontalAlignment.Center
})

local Content = Create("ScrollingFrame",Main,{
    Size = UDim2.new(1,-150,1,-65),
    Position = UDim2.fromOffset(140,55),
    BackgroundColor3 = Color3.fromRGB(20,15,28),
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new(0,0,0,0)
})
Instance.new("UICorner",Content).CornerRadius = UDim.new(0,8)

local ContentList = Create("UIListLayout",Content,{
    Padding = UDim.new(0,7)
})

ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0,0,0,ContentList.AbsoluteContentSize.Y+10)
end)

local function ClearContent()
    for _,v in ipairs(Content:GetChildren()) do
        if v:IsA("GuiObject") and v ~= ContentList then
            v:Destroy()
        end
    end
end

local function AddButton(name,callback)
    local Button = Create("TextButton",Content,{
        Size = UDim2.new(1,-12,0,38),
        BackgroundColor3 = Color3.fromRGB(55,30,80),
        Text = name,
        TextColor3 = White,
        Font = Enum.Font.GothamBold,
        TextSize = 13
    })
    Instance.new("UICorner",Button).CornerRadius = UDim.new(0,7)

    Button.MouseButton1Click:Connect(callback)
    return Button
end

local function AddInput(name,default,callback)
    local Box = Create("TextBox",Content,{
        Size = UDim2.new(1,-12,0,38),
        BackgroundColor3 = Color3.fromRGB(40,25,55),
        Text = tostring(default),
        PlaceholderText = name,
        TextColor3 = White,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        ClearTextOnFocus = false
    })
    Instance.new("UICorner",Box).CornerRadius = UDim.new(0,7)

    Box.FocusLost:Connect(function()
        local n = tonumber(Box.Text)
        if n then callback(n) end
    end)
end

local function Toggle(name,callback)
    local enabled = false
    local Button

    Button = AddButton(name.." : OFF",function()
        enabled = not enabled
        Button.Text = name..(enabled and " : ON" or " : OFF")
        Button.BackgroundColor3 = enabled and Purple
            or Color3.fromRGB(55,30,80)
        callback(enabled)
    end)
end

-- ESTADO

local FlyEnabled = false
local NoclipEnabled = false
local InfiniteJumpEnabled = false
local PlayerESPEnabled = false
local EggESPEnabled = false
local FlyConnection
local NoclipConnection
local JumpConnection

local function Character()
    return Player.Character
end

local function Humanoid()
    local char = Character()
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- MOVIMENTAÇÃO

local function SetFly(enabled)
    FlyEnabled = enabled

    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end

    local char = Character()
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not root then return end

    if enabled then
        local velocity = Instance.new("BodyVelocity")
        velocity.MaxForce = Vector3.new(1e6,1e6,1e6)
        velocity.Velocity = Vector3.zero
        velocity.Parent = root

        local gyro = Instance.new("BodyGyro")
        gyro.MaxTorque = Vector3.new(1e6,1e6,1e6)
        gyro.P = 10000
        gyro.Parent = root

        FlyConnection = RunService.RenderStepped:Connect(function()
            if not root.Parent then return end

            local move = Humanoid() and Humanoid().MoveDirection
                or Vector3.zero

            local vertical = 0

            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                vertical = 1
            elseif UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                vertical = -1
            end

            velocity.Velocity = move*55 + Vector3.new(0,vertical*45,0)
            gyro.CFrame = Camera.CFrame
        end)

        task.spawn(function()
            while FlyEnabled and root.Parent do
                task.wait()
            end
            velocity:Destroy()
            gyro:Destroy()
        end)
    end
end

local function SetNoclip(enabled)
    NoclipEnabled = enabled

    if NoclipConnection then
        NoclipConnection:Disconnect()
    end

    if enabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            local char = Character()
            if char then
                for _,part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- CATEGORIA MOVIMENTO

local function MovementPage()
    ClearContent()

    AddButton("FLY",function()
        SetFly(not FlyEnabled)
    end)

    AddInput("Velocidade (16 padrão)",16,function(value)
        local h = Humanoid()
        if h then h.WalkSpeed = math.clamp(value,0,200) end
    end)

    AddInput("Pulo (50 padrão)",50,function(value)
        local h = Humanoid()
        if h then
            h.UseJumpPower = true
            h.JumpPower = math.clamp(value,0,300)
        end
    end)

    Toggle("NOCLIP",SetNoclip)

    Toggle("INFINITE JUMP",function(enabled)
        InfiniteJumpEnabled = enabled

        if JumpConnection then
            JumpConnection:Disconnect()
            JumpConnection = nil
        end

        if enabled then
            JumpConnection = UIS.JumpRequest:Connect(function()
                local h = Humanoid()
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end
    end)
end

-- CATEGORIA MUNDO

local function WorldPage()
    ClearContent()

    AddButton("CÉU ROXO",function()
        Lighting.Ambient = Purple
        Lighting.OutdoorAmbient = Purple
    end)

    AddButton("CÉU AZUL",function()
        Lighting.Ambient = Color3.fromRGB(50,100,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(50,100,255)
    end)

    AddButton("CÉU ORIGINAL",function()
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
    end)

    AddInput("Brilho (1 padrão)",1,function(value)
        Lighting.Brightness = math.clamp(value,0,10)
    end)

    AddInput("Gravidade (196 padrão)",196,function(value)
        workspace.Gravity = math.clamp(value,0,500)
    end)
end

-- CATEGORIA TELEPORTE

local function TeleportPage()
    ClearContent()

    AddButton("MINHA BASE",function()
        -- Integração necessária com o sistema de bases do jogo.
        Content.Visible = true
    end)

    AddButton("ATUALIZAR JOGADORES",function()
        TeleportPage()
    end)

    for _,target in ipairs(Players:GetPlayers()) do
        if target ~= Player then
            AddButton("IR ATÉ: "..target.Name,function()
                local char = Character()
                local targetChar = target.Character

                if char and targetChar then
                    local a = char:FindFirstChild("HumanoidRootPart")
                    local b = targetChar:FindFirstChild("HumanoidRootPart")

                    if a and b then
                        a.CFrame = b.CFrame * CFrame.new(0,0,4)
                    end
                end
            end)
        end
    end
end

-- CATEGORIA OVOS

local function EggPage()
    ClearContent()

    AddButton("PROCURAR OVOS",function()
        EggPage()

        local found = 0

        for _,obj in ipairs(workspace:GetDescendants()) do
            if string.find(string.lower(obj.Name),"egg") then
                found += 1
                AddButton("OVO: "..obj.Name,function()
                    local char = Character()
                    local root = char and char:FindFirstChild("HumanoidRootPart")

                    local part = obj:IsA("BasePart") and obj
                        or obj:FindFirstChildWhichIsA("BasePart",true)

                    if root and part then
                        root.CFrame = part.CFrame * CFrame.new(0,3,0)
                    end
                end)
            end
        end

        if found == 0 then
            AddButton("Nenhum ovo encontrado",function() end)
        end
    end)

    AddButton("INFORMAÇÕES",function()
        AddButton("Os ovos dependem das mecânicas do jogo.",function() end)
    end)

    AddButton("ROUBAR OVO",function()
        AddButton("Use a interação normal do jogo para roubar.",function() end)
    end)
end

-- CATEGORIA EXTRAS

local function ExtrasPage()
    ClearContent()

    AddButton("JOGADORES ONLINE",function()
        ClearContent()
        for _,p in ipairs(Players:GetPlayers()) do
            AddButton(p.Name,function() end)
        end
    end)

    Toggle("ESP JOGADORES",function(enabled)
        PlayerESPEnabled = enabled

        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= Player then
                local char = p.Character
                if char then
                    local old = char:FindFirstChild("AnoesPlayerESP")
                    if old then old:Destroy() end

                    if enabled then
                        local h = Instance.new("Highlight")
                        h.Name = "AnoesPlayerESP"
                        h.FillColor = Purple
                        h.OutlineColor = White
                        h.Parent = char
                    end
                end
            end
        end
    end)

    Toggle("ESP OVOS",function(enabled)
        EggESPEnabled = enabled

        for _,obj in ipairs(workspace:GetDescendants()) do
            if string.find(string.lower(obj.Name),"egg") then
                local old = obj:FindFirstChild("AnoesEggESP")
                if old then old:Destroy() end

                if enabled then
                    local h = Instance.new("Highlight")
                    h.Name = "AnoesEggESP"
                    h.FillColor = Color3.fromRGB(255,200,0)
                    h.OutlineColor = White
                    h.Parent = obj
                end
            end
        end
    end)
end

-- ABAS

local Pages = {
    MOVIMENTO = MovementPage,
    MUNDO = WorldPage,
    TELEPORTE = TeleportPage,
    OVOS = EggPage,
    EXTRAS = ExtrasPage
}

for name,callback in pairs(Pages) do
    local Button = Create("TextButton",Menu,{
        Size = UDim2.new(1,-10,0,42),
        BackgroundColor3 = Color3.fromRGB(65,30,95),
        Text = name,
        TextColor3 = White,
        Font = Enum.Font.GothamBold,
        TextSize = 11
    })

    Instance.new("UICorner",Button).CornerRadius = UDim.new(0,6)

    Button.MouseButton1Click:Connect(callback)
end

-- ARRASTAR PAINEL

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- INICIALIZAÇÃO

MovementPage()

print("ANÕES CHEATS carregado!")
