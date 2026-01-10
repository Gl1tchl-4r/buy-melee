repeat wait() until game:IsLoaded() and game.Players.LocalPlayer and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") or game:GetService("Players").LocalPlayer.Character

task.spawn(function ()
    local args = {
        "SetTeam",
        "Marines"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
        
    repeat wait() until game:IsLoaded() and game.Players.LocalPlayer.Character
        
    if game.PlaceId ~= 7449423635 then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
    else
        return
    end
end)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")
local isTweening = false

player.CharacterAdded:Connect(function(newCharacter)
    getgenv().startTween:Cancel()
    character = newCharacter
    hrp = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    isTweening = false
    workspace:FindFirstChild("TweenPart"):Destroy()
end)

RunService.Heartbeat:Connect(function ()
    pcall(function ()
        if isTweening and character and workspace:FindFirstChild("TweenPart") then
            hrp.CFrame = workspace.TweenPart.CFrame
        end
    end)
end)

local function creatTweenPart()
    local part = Instance.new("Part")
    part.Size = Vector3.new(1, 1, 1)
    part.Anchored = true
    part.CanCollide = false
    part.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    part.Transparency = 1
    part.Name = "TweenPart"
    part.Parent = workspace
    return part
end

local function tp(pos)
    isTweening = false
    hrp.CFrame = pos
end

local function tween(pos)
    local TweenPart = game.Workspace:FindFirstChild("TweenPart")
    if not TweenPart then TweenPart = creatTweenPart()end
    if (hrp.Position - (pos.Position or pos)).Magnitude < 60 then
        TweenPart.CFrame = pos
        return
    end
    if TweenPart.CFrame ~= game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame then
        TweenPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    end
    isTweening = true
    local distance = (pos.Position - hrp.Position).Magnitude
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear)
    getgenv().startTween = TweenService:Create(TweenPart, tweenInfo, { CFrame = pos })

    getgenv().startTween:Play()
    getgenv().startTween.Completed:Wait()
    isTweening = false
end

local function main()

    if player:GetAttribute("ExactLocation") == "Submerged Island" then
        tween(CFrame.new(11426.201171875, -2155.0634765625, 9730.7080078125))
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/SubmarineTransportation"):InvokeServer("InitiateTeleport", "Tiki Outpost")
    end

    if (Vector3.new(-16516.1328125, 23.38727569580078, -189.69615173339844) - hrp.Position).Magnitude >= 5 then
        tween(CFrame.new(-16516.1328125, 23.38727569580078, -189.69615173339844))
    else
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("BuySanguineArt")
    end
end

spawn(function()
    while task.wait() do
        if getgenv().Autobuy then
            main()
        end
    end
end)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "BuySanguineArt",
    Icon = "hand-fist", -- lucide icon. optional
    Author = "by: odyssey_0", -- optional
})

local Tab = Window:Tab({
    Title = "Main",
    Icon = "code", -- optional
    Locked = false,
})

Tab:Select()

Window:EditOpenButton({
    Title = "Open Example UI",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local Toggle = Tab:Toggle({
    Title = "Buy Melee",
    Desc = "Buy item (SanguineArt)",
    Icon = "status",
    Type = "Checkbox",
    Value = true, -- default value
    Callback = function(state) 
        if not state then getgenv().startTween:Cancel() end
        getgenv().Autobuy = state
    end
})
