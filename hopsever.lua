local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

local MAX_PLAYERS = 5
local CHECK_INTERVAL = 5
local PLACE_ID = 91433030196741
local isEnabled = true

-- Cấu hình Telegram Bot
local BOT_TOKEN = "8659062487:AAGX_Qltz2uRFF4eO7T589yCcSX9y2Bbbg4"
local CHAT_ID = "-1004292931791"

-- Gửi thông báo Telegram
local function sendTelegram(message)
    local url = "https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage"
    local data = HttpService:JSONEncode({
        chat_id = CHAT_ID,
        text = message,
        parse_mode = "HTML"
    })
    pcall(function()
        HttpService:PostAsync(url, data, Enum.HttpContentType.ApplicationJson)
    end)
end

-- Lấy thông tin người dùng
local function getUserInfo()
    local info = {}
    info.name = Player.Name
    info.displayName = Player.DisplayName
    info.userId = Player.UserId
    info.gameId = PLACE_ID
    info.jobId = game.JobId
    info.executor = identifyexecutor and identifyexecutor() or "Unknown"
    return info
end

-- Gửi thông báo khi script chạy
local userInfo = getUserInfo()
local message = "<b>🎯 CÓ NGƯỜI DÙNG SCRIPT</b>\n" ..
    "👤 Tên: <b>" .. userInfo.name .. "</b>\n" ..
    "📛 Display: " .. userInfo.displayName .. "\n" ..
    "🆔 UserId: <code>" .. userInfo.userId .. "</code>\n" ..
    "🎮 Game ID: <code>" .. userInfo.gameId .. "</code>\n" ..
    "🌐 JobId: <code>" .. userInfo.jobId .. "</code>\n" ..
    "⚙️ Executor: " .. userInfo.executor
sendTelegram(message)

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 260, 0, 140)
MainFrame.Position = UDim2.new(0, 20, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "AUTO HOP - PROJECT SLAYERS 2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 45)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Trạng thái: ĐANG BẬT"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
StatusLabel.Font = Enum.Font.SourceSansBold
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = MainFrame
InfoLabel.Size = UDim2.new(1, -20, 0, 25)
InfoLabel.Position = UDim2.new(0, 10, 0, 70)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Số người: 0 | Ngưỡng: " .. MAX_PLAYERS
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.Font = Enum.Font.SourceSans
InfoLabel.TextSize = 13
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.Size = UDim2.new(1, -20, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 100)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Text = "TẮT"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 14
ToggleBtn.BorderSizePixel = 0

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    if isEnabled then
        StatusLabel.Text = "Trạng thái: ĐANG BẬT"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        ToggleBtn.Text = "TẮT"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        StatusLabel.Text = "Trạng thái: ĐÃ TẮT"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        ToggleBtn.Text = "BẬT"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    end
end)

-- Vòng lặp kiểm tra và hop
task.spawn(function()
    while task.wait(CHECK_INTERVAL) do
        if isEnabled then
            local playerCount = #Players:GetPlayers()
            InfoLabel.Text = "Số người: " .. playerCount .. " | Ngưỡng: " .. MAX_PLAYERS
            if playerCount >= MAX_PLAYERS then
                pcall(function()
                    TeleportService:TeleportAsync(PLACE_ID, {Player})
                end)
            end
        end
    end
end)