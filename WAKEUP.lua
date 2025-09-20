local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local SubmitCommand = Remotes:FindFirstChild("SubmitCommand") -- No fallará si no existe

-- Crear GUI
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local MainGui = PlayerGui:FindFirstChild("MainGui") or Instance.new("ScreenGui")
MainGui.Name = "MainGui"
MainGui.ResetOnSpawn = false
MainGui.Parent = PlayerGui

local AdminPanel = Instance.new("Frame")
AdminPanel.Name = "AdminPanel"
AdminPanel.Size = UDim2.new(0, 500, 0, 350)
AdminPanel.Position = UDim2.new(0.5, -250, 0.5, -175)
AdminPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
AdminPanel.BorderSizePixel = 0
AdminPanel.Visible = true
AdminPanel.Parent = MainGui

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.Text = "Admin Panel GRATIS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Parent = AdminPanel

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(1, 0, 1, -30)
Main.Position = UDim2.new(0, 0, 0, 30)
Main.BackgroundTransparency = 1
Main.Parent = AdminPanel

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
TextBox.Parent = CommandInput

-- CommandList
local CommandList = Instance.new("Frame")
CommandList.Name = "CommandList"
CommandList.Size = UDim2.new(0, 180, 0, 250)
CommandList.Position = UDim2.new(0, 10, 0, 60)
CommandList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CommandList.Parent = Main

local Contents = Instance.new("Frame")
Contents.Name = "Contents"
Contents.Size = UDim2.new(1, -10, 1, -10)
Contents.Position = UDim2.new(0, 5, 0, 5)
Contents.BackgroundTransparency = 1
Contents.Parent = CommandList

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 3)
UIListLayout.Parent = Contents

-- PlayerList
local PlayerList = Instance.new("Frame")
PlayerList.Name = "PlayerList"
PlayerList.Size = UDim2.new(0, 280, 0, 250)
PlayerList.Position = UDim2.new(0, 200, 0, 60)
PlayerList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerList.BackgroundTransparency = 0 -- Asegurar visibilidad
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

-- Template para jugadores
local TemplateButton = Instance.new("TextButton")
TemplateButton.Name = "TemplateButton"
TemplateButton.Size = UDim2.new(1, -10, 0, 40)
TemplateButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TemplateButton.Text = ""
TemplateButton.Visible = false
TemplateButton.Parent = PlayerContents

local PlayerImage = Instance.new("ImageLabel")
PlayerImage.Name = "PlayerImage"
PlayerImage.Size = UDim2.new(0, 30, 0, 30)
PlayerImage.Position = UDim2.new(0, 5, 0, 5)
PlayerImage.BackgroundTransparency = 1
PlayerImage.Parent = TemplateButton

local PlayerName = Instance.new("TextLabel")
PlayerName.Name = "PlayerName"
PlayerName.Size = UDim2.new(1, -40, 1, 0)
PlayerName.Position = UDim2.new(0, 40, 0, 0)
PlayerName.BackgroundTransparency = 1
PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerName.TextXAlignment = Enum.TextXAlignment.Left
PlayerName.Parent = TemplateButton

-- Botones de comandos
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
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 0, 0)
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
        button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        button.TextColor3 = Color3.fromRGB(0, 0, 0)
        TextBox.Text = cmd
        print("Comando seleccionado: " .. cmd)
    end)
end

-- Funciones para jugadores
local playerButtons = {}
local function addPlayer(player)
    if playerButtons[player] then return end
    print("Añadiendo jugador: " .. player.Name) -- Debug
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
        print("Eliminando jugador: " .. player.Name) -- Debug
        playerButtons[player]:Destroy()
        playerButtons[player] = nil
    end
end

-- Cargar jugadores con retraso para asegurar sincronización
task.spawn(function()
    task.wait(1) -- Espera breve para que Players se inicialice
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

-- Toggle con tecla A
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        AdminPanel.Visible = not AdminPanel.Visible
        print("Panel toggled: " .. (AdminPanel.Visible and "Visible" or "Oculto"))
    end
end)

-- Botón toggle
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 60, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.Text = "Admin (A)"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Parent = MainGui
ToggleBtn.MouseButton1Click:Connect(function()
    AdminPanel.Visible = not AdminPanel.Visible
    print("Panel toggled: " .. (AdminPanel.Visible and "Visible" or "Oculto"))
end)

print("¡Admin Panel GRATIS cargado! Presiona 'A' para togglear. Lista de jugadores debería estar a la derecha.")
