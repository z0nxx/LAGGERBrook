-- Custom Count Multi-Item Giver (with Retry System) & Infinite Spam
-- Дизайн в стиле z0nxx Hub (Monochrome)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Цветовая палитра (ч/б)
local BG_DARK = Color3.fromRGB(18, 18, 18)
local BG_MEDIUM = Color3.fromRGB(28, 28, 28)
local BG_LIGHT = Color3.fromRGB(42, 42, 42)
local ACCENT = Color3.fromRGB(100, 100, 100)
local TEXT_PRIMARY = Color3.fromRGB(235, 235, 235)

-- Флаг управления спамом
local isSpamming = false

-- ИТОГОВЫЙ МЕГА-СПИСОК ПРЕДМЕТОВ (77 штук)
local itemsToGrab = {
    "Phone", "Tablet", "PropMaker", "Laptop", "ShoppingCart", "GeigerCounter", "Paperbag", "Sign",
    "Score Card", "Book", "Newspaper", "Envelope", "Paper", "ClipBoard", "Ticket", "Licence", 
    "BabyBoy", "BabyGirl", "BabyBottle", "BabyRattle", "Stroller", "BabyMonkey", "BabyHippo",
    "Wagon", "Stretcher", "Stethoscope", "Medicine", "Ear", "Teapot", "Teacup", "Jug", 
    "HandheldFan", "Toothbrush", "Trophy", "Hairbrush", "PlaneTicket", "SWATShield", 
    "RiotShield", "Baton", "Cuffs", "Taser",
    "Bow", "SwordWood", "Katana", "Bomb", "Sceptre", "RoyalScroll", "DuffleBag", "DuffleBagMoney",
    "Money", "CreditCardBoy", "CreditCardGirl", "Binocks", "HandRadio", "GhostMeter", "FlashLight",
    "Candle", "Marshmello", "TinCup", "Sparkler", "FishingRod", "Balloon", "Present", "Roses",
    "Boombox", "PowderCompactBrush", "Lipstick", "ClapperBoard", "Microphone", "Megaphone",
    "DSLR Camera", "Camcorder", "Guitar", "ElectricGuitar", "Axe", "Hammer", "FireX"
}

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MassEquipLoopGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 280, 0, 235) -- Уменьшил высоту, так как кнопку убрали
main.Position = UDim2.new(0.5, -140, 0.5, -117)
main.BackgroundColor3 = BG_DARK
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.ZIndex = 1
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 2
mainStroke.Color = ACCENT
mainStroke.Transparency = 0.3

-- Заголовок
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundColor3 = BG_MEDIUM
header.BorderSizePixel = 0
header.ZIndex = 2
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -30, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "z0nxx Hub — Smart Pack v10"
title.TextColor3 = TEXT_PRIMARY
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -32, 0, 3)
closeBtn.BackgroundColor3 = ACCENT
closeBtn.Text = "X"
closeBtn.TextColor3 = TEXT_PRIMARY
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 16
closeBtn.ZIndex = 3
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function()
    isSpamming = false
    screenGui:Destroy()
end)

-- Информационная панель статуса
local infoLabel = Instance.new("TextLabel", main)
infoLabel.Size = UDim2.new(1, -20, 0, 32)
infoLabel.Position = UDim2.new(0, 10, 0, 44)
infoLabel.BackgroundColor3 = BG_LIGHT
infoLabel.Text = "Status: Enter amount (1-77)"
infoLabel.TextColor3 = TEXT_PRIMARY
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 15
infoLabel.ZIndex = 2
Instance.new("UICorner", infoLabel).CornerRadius = UDim.new(0, 6)

-- Поле Ввода Количество предметов (TextBox)
local amountInput = Instance.new("TextBox", main)
amountInput.Size = UDim2.new(1, -20, 0, 32)
amountInput.Position = UDim2.new(0, 10, 0, 84)
amountInput.BackgroundColor3 = BG_MEDIUM
amountInput.Text = "77"
amountInput.PlaceholderText = "Enter amount (1-77)"
amountInput.TextColor3 = Color3.fromRGB(255, 255, 255)
amountInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
amountInput.Font = Enum.Font.SourceSansBold
amountInput.TextSize = 15
amountInput.ZIndex = 2
Instance.new("UICorner", amountInput).CornerRadius = UDim.new(0, 6)
local inputStroke = Instance.new("UIStroke", amountInput)
inputStroke.Thickness = 1
inputStroke.Color = ACCENT

-- Кнопка 1: Сбор предметов
local grabBtn = Instance.new("TextButton", main)
grabBtn.Size = UDim2.new(1, -20, 0, 34)
grabBtn.Position = UDim2.new(0, 10, 0, 124)
grabBtn.BackgroundColor3 = ACCENT
grabBtn.Text = "1. GET CUSTOM ITEMS"
grabBtn.TextColor3 = TEXT_PRIMARY
grabBtn.Font = Enum.Font.SourceSansBold
grabBtn.TextSize = 14
grabBtn.ZIndex = 2
Instance.new("UICorner", grabBtn).CornerRadius = UDim.new(0, 6)

-- Кнопка 2: Переключатель спама
local spamBtn = Instance.new("TextButton", main)
spamBtn.Size = UDim2.new(1, -20, 0, 34)
spamBtn.Position = UDim2.new(0, 10, 0, 164)
spamBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
spamBtn.Text = "2. START INF SPAM"
spamBtn.TextColor3 = TEXT_PRIMARY
spamBtn.Font = Enum.Font.SourceSansBold
spamBtn.TextSize = 14
spamBtn.ZIndex = 2
Instance.new("UICorner", spamBtn).CornerRadius = UDim.new(0, 6)

-- Метка статуса пути
local statusLabel = Instance.new("TextLabel", main)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 205)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Verification system checks for missed items"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.ZIndex = 2

-- Перетаскивание (Drag GUI)
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
header.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Фильтрация (только цифры)
amountInput:GetPropertyChangedSignal("Text"):Connect(function()
    amountInput.Text = amountInput.Text:gsub("%D", "")
end)

-- Проверка наличия конкретного предмета в рюкзаке или руках
local function isItemInInventory(itemName)
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local character = LocalPlayer.Character
    
    if backpack:FindFirstChild(itemName) then return true end
    if character and character:FindFirstChild(itemName) then return true end
    
    return false
end

local function getBackpackToolCount(backpack)
    local count = 0
    for _, child in ipairs(backpack:GetChildren()) do
        if child:IsA("Tool") then count = count + 1 end
    end
    return count
end

-- Логика Первой Кнопки (Сбор + Умная перепроверка)
local function runGrabItems()
    grabBtn.Interactable = false
    
    local targetCount = tonumber(amountInput.Text)
    if not targetCount or targetCount <= 0 then
        targetCount = 77
        amountInput.Text = "77"
    elseif targetCount > #itemsToGrab then
        targetCount = #itemsToGrab
        amountInput.Text = tostring(#itemsToGrab)
    end
    
    infoLabel.Text = "Clearing inventory..."
    local itemRemote = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l")
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not humanoid then
        infoLabel.Text = "Character error!"
        grabBtn.Interactable = true
        return
    end

    humanoid:UnequipTools()
    for _, child in ipairs(backpack:GetChildren()) do
        if child:IsA("Tool") then child:Destroy() end
    end

    -- Набор предметов для выдачи
    local selectedItems = {}
    for i = 1, targetCount do
        table.insert(selectedItems, itemsToGrab[i])
    end

    -- Круг 1: Первичная выдача предметов
    infoLabel.Text = "Sending requests..."
    for _, itemName in ipairs(selectedItems) do
        task.spawn(function()
            pcall(function() itemRemote:InvokeServer("PickingTools", itemName) end)
        end)
        task.wait(0.01) -- Микро-задержка для обхода лимитов
    end

    -- Круг 2-10: Проверка упущенных предметов
    local attempts = 0
    while attempts < 10 do
        local missingItems = {}
        
        for _, itemName in ipairs(selectedItems) do
            if not isItemInInventory(itemName) then
                table.insert(missingItems, itemName)
            end
        end
        
        if #missingItems == 0 then break end
        
        attempts = attempts + 1
        infoLabel.Text = "Retrying missed: " .. #missingItems
        
        for _, itemName in ipairs(missingItems) do
            task.spawn(function()
                pcall(function() itemRemote:InvokeServer("PickingTools", itemName) end)
            end)
            task.wait(0.01)
        end
        
        task.wait(0.3) -- Даем время серверу ответить
    end
    
    infoLabel.Text = "Ready! Pack total: " .. getBackpackToolCount(backpack)
    grabBtn.Interactable = true
end

-- Логика Второй Кнопки (Бесконечный спам)
local function toggleSpam()
    if isSpamming then
        isSpamming = false
        spamBtn.Text = "2. START INF SPAM"
        spamBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        infoLabel.Text = "Spam stopped."
    else
        local backpack = LocalPlayer:WaitForChild("Backpack")
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if not humanoid or getBackpackToolCount(backpack) == 0 then
            infoLabel.Text = "Get items first!"
            return
        end
        
        isSpamming = true
        spamBtn.Text = "STOP SPAM"
        spamBtn.BackgroundColor3 = Color3.fromRGB(140, 40, 40)
        infoLabel.Text = "Spamming current package..."
        
        task.spawn(function()
            while isSpamming do
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    isSpamming = false
                    spamBtn.Text = "2. START INF SPAM"
                    spamBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    infoLabel.Text = "Character reset. Spam stopped."
                    break
                end
                
                local currentCharacter = LocalPlayer.Character
                local currentHumanoid = currentCharacter:FindFirstChildOfClass("Humanoid")
                
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool.Parent = currentCharacter
                    end
                end
                
                task.wait()
                
                if currentHumanoid then
                    currentHumanoid:UnequipTools()
                end
                
                task.wait()
            end
        end)
    end
end

-- Назначение функций
grabBtn.MouseButton1Click:Connect(function()
    task.spawn(runGrabItems)
end)
spamBtn.MouseButton1Click:Connect(toggleSpam)

-- Анимация открытия
main.Position = UDim2.new(0.5, -140, 1.5, 0)
local openTween = TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -140, 0.5, -117)})
openTween:Play()
