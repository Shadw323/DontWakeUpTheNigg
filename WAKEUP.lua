local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local SubmitCommand = Remotes:FindFirstChild("SubmitCommand")

-- Crear GUI
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local MainGui = PlayerGui:FindFirstChild("MainGui") or Instance.new("ScreenGui")
MainGui.Name = "MainGui"
MainGui.ResetOnSpawn = false
MainGui.Parent = PlayerGui

-- Texto de bienvenida
local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(0, 400, 0, 100)
WelcomeText.Position = UDim2.new(0.5, -200, 0.5, -50)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "Welcome To Shadow Panel"
WelcomeText.TextColor3 = Color3.fromRGB(106, 27, 154) -- Púrpura shadow
WelcomeText.TextScaled = true
WelcomeText.Font = Enum.Font.Gotham
WelcomeText.Parent = MainGui

-- Crear ShadowsPanel
local ShadowsPanel = Instance.new("Frame")
ShadowsPanel.Name = "ShadowsPanel"
ShadowsPanel.Size = UDim2.new(0, 400, 0, 300)
ShadowsPanel.Position = UDim2.new(0.5, -200, 0.5, -150)
ShadowsPanel.BackgroundColor3 = Color3.fromRGB(26, 26, 26) -- Negro elegante
ShadowsPanel.BorderSizePixel = 0
ShadowsPanel.Visible = false
ShadowsPanel.Parent = MainGui

-- Animación de entrada
local function animatePanelOpen()
    ShadowsPanel.BackgroundTransparency = 1
    ShadowsPanel.Size = UDim2.new(0, 200, 0, 150)
    ShadowsPanel.Visible = true
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = TweenService:Create(ShadowsPanel, tweenInfo, {
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 400, 0, 300)
    })
    tween:Play()
end

-- Animación de cierre
local function animatePanelClose(callback)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    local tween = TweenService:Create(ShadowsPanel, tweenInfo, {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 200, 0, 150)
    })
    tween:Play()
    tween.Completed:Connect(function()
        ShadowsPanel.Visible = false
        if callback then callback() end
    end)
end

-- Hacer arrastrable
local dragging = false
local dragStartPos = nil
local panelStartPos = nil

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position
        local panelPos = ShadowsPanel.AbsolutePosition
        local panelSize = ShadowsPanel.AbsoluteSize
        if pos.X >= panelPos.X and pos.X <= panelPos.X + panelSize.X and
           pos.Y >= panelPos.Y and pos.Y <= panelPos.Y + 30 then
            dragging = true
            dragStartPos = pos
            panelStartPos = ShadowsPanel.Position
        end
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartPos
        local newPos = UDim2.new(
            panelStartPos.X.Scale,
            panelStartPos.X.Offset + delta.X,
            panelStartPos.Y.Scale,
            panelStartPos.Y.Offset + delta.Y
        )
        ShadowsPanel.Position = newPos
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(106, 27, 154)
Title.Text = "ShadowsPanel - Épico y Elegante"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.Gotham
Title.Parent = ShadowsPanel

-- Botón cerrar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(106, 27, 154)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.Gotham
CloseButton.Parent = ShadowsPanel
CloseButton.MouseButton1Click:Connect(function()
    animatePanelClose(function()
        print("ShadowsPanel cerrado")
    end)
end)

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(1, 0, 1, -30)
Main.Position = UDim2.new(0, 0, 0, 30)
Main.BackgroundTransparency = 1
Main.Parent = ShadowsPanel

-- CommandInput
local CommandInput = Instance.new("Frame")
CommandInput.Name = "CommandInput"
CommandInput.Size = UDim2.new(1, -20, 0, 40)
CommandInput.Position = UDim2.new(0, 10, 0, 10)
CommandInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CommandInput.Parent = Main

local TextBox = Instance.new("TextBox")
TextBox.Name = "TextBox"
TextBox.Size = UDim2.new(1, -10, 1, -10)
TextBox.Position = UDim2.new(0, 5, 0, 5)
TextBox.BackgroundTransparency = 1
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.PlaceholderText = "Escribe comando (ej: huge)"
TextBox.Text = ""
TextBox.TextScaled = true
TextBox.Font = Enum.Font.Gotham
TextBox.Parent = CommandInput

-- CommandList
local CommandList = Instance.new("Frame")
CommandList.Name = "CommandList"
CommandList.Size = UDim2.new(0, 150, 0, 200)
CommandList.Position = UDim2.new(0, 10, 0, 60)
CommandList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CommandList.Parent = Main

local Contents = Instance.new("Frame")
Contents.Name = "Contents"
Contents.Size = UDim2.new(1, 0, 1, 0)
Contents.Position = UDim2.new(0, 0, 0, 0)
Contents.BackgroundTransparency = 1
Contents.Parent = CommandList

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 3)
UIListLayout.Parent = Contents

-- PlayerList
local PlayerList = Instance.new("Frame")
PlayerList.Name = "PlayerList"
PlayerList.Size = UDim2.new(0, 220, 0, 200)
PlayerList.Position = UDim2.new(0, 170, 0, 60)
PlayerList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerList.BackgroundTransparency = 0
PlayerList.Parent = Main

local PlayerContents = Instance.new("Frame")
PlayerContents.Name = "Contents"
PlayerContents.Size = UDim2.new(1, 0, 1, 0)
PlayerContents.Position = UDim2.new(0, 0, 0, 0)
PlayerContents.BackgroundTransparency = 1
PlayerContents.Parent = PlayerList

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Padding = UDim.new(0, 3)
PlayerListLayout.Parent = PlayerContents

-- Template jugadores
local TemplateButton = Instance.new("TextButton")
TemplateButton.Name = "TemplateButton"
TemplateButton.Size = UDim2.new(1, -10, 0, 35)
TemplateButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TemplateButton.Text = ""
TemplateButton.Visible = false
TemplateButton.Parent = PlayerContents

local PlayerImage = Instance.new("ImageLabel")
PlayerImage.Name = "PlayerImage"
PlayerImage.Size = UDim2.new(0, 30, 0, 30)
PlayerImage.Position = UDim2.new(0, 5, 0, 2)
PlayerImage.BackgroundTransparency = 1
PlayerImage.Parent = TemplateButton

local PlayerName = Instance.new("TextLabel")
PlayerName.Name = "PlayerName"
PlayerName.Size = UDim2.new(1, -40, 1, 0)
PlayerName.Position = UDim2.new(0, 40, 0, 0)
PlayerName.BackgroundTransparency = 1
PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerName.TextXAlignment = Enum.TextXAlignment.Left
PlayerName.TextScaled = true
PlayerName.Font = Enum.Font.Gotham
PlayerName.Parent = TemplateButton

-- Comandos
local commands = {"Huge", "Tiny", "Explode", "Fling", "Ragdoll", "Jail", "Spin", "Teleport", "Jumpscare"}
local selectedCommand = nil
local selectedButton = nil

for _, cmd in ipairs(commands) do
    local button = Instance.new("TextButton")
    button.Name = cmd
    button.Size = UDim2.new(1, -10, 0, 25)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Text = cmd
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(106, 27, 154)
    stroke.Thickness = 1
    stroke.Parent = button
    button.Parent = Contents
    button.MouseButton1Click:Connect(function()
        if selectedButton then
            selectedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            selectedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        selectedCommand = cmd
        selectedButton = button
        button.BackgroundColor3 = Color3.fromRGB(106, 27, 154)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.Text = cmd
        print("Comando seleccionado: " .. cmd)
    end)
end

-- Jugadores
local playerButtons = {}
local function addPlayer(player)
    if playerButtons[player] then return end
    print("Añadiendo jugador: " .. player.Name)
    local button = TemplateButton:Clone()
    playerButtons[player] = button
    button.PlayerImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
    button.PlayerName.Text = player.Name
    button.Parent = PlayerContents
    button.Visible = true
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.MouseButton1Click:Connect(function()
        if selectedCommand then
            if SubmitCommand then
                local success, result = pcall(function()
                    return SubmitCommand:InvokeServer(selectedCommand, player.Name)
                end)
                if success and result then
                    print("Comando '" .. selectedCommand .. "' ejecutado en " .. player.Name)
                else
                    print("Error al ejecutar comando en " .. player.Name .. ": " .. (result or "Sin respuesta del servidor"))
                end
            else
                print("SubmitCommand no encontrado. Comandos no funcionarán.")
            end
        else
            print("Selecciona un comando primero.")
        end
    end)
end

local function removePlayer(player)
    if playerButtons[player] then
        print("Eliminando jugador: " .. player.Name)
        playerButtons[player]:Destroy()
        playerButtons[player] = nil
    end
end

task.spawn(function()
    task.wait(1)
    local playerCount = 0
    for _, player in pairs(Players:GetPlayers()) do
        addPlayer(player)
        playerCount = playerCount + 1
    end
    print("Cargados " .. playerCount .. " jugadores en la lista")
end)

Players.PlayerAdded:Connect(addPlayer)
Players.PlayerRemoving:Connect(removePlayer)

-- Comando manual
TextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        selectedCommand = TextBox.Text
        print("Comando manual: " .. selectedCommand)
    end
end)

-- Toggle tecla G
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        if ShadowsPanel.Visible then
            animatePanelClose(function()
                print("ShadowsPanel toggled: Oculto")
            end)
        else
            animatePanelOpen()
            print("ShadowsPanel toggled: Visible")
        end
    end
end)

-- Botón toggle flotante
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 60, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(106, 27, 154)
ToggleBtn.Text = "Shadows (G)"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.Gotham
ToggleBtn.Parent = MainGui
ToggleBtn.MouseButton1Click:Connect(function()
    if ShadowsPanel.Visible then
        animatePanelClose(function()
            print("ShadowsPanel toggled: Oculto")
        end)
    else
        animatePanelOpen()
        print("ShadowsPanel toggled: Visible")
    end
end)

-- Mostrar texto de bienvenida y luego el panel
task.spawn(function()
    WelcomeText.Visible = true
    task.wait(2) -- Retraso de 2 segundos
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    local tween = TweenService:Create(WelcomeText, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        WelcomeText:Destroy()
        animatePanelOpen()
    end)
end)

print("¡ShadowsPanel ÉPICO cargado! Bienvenida en pantalla, toggle con G, animaciones suaves. 😈")
