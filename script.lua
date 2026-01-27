-- getgenv().Configs = {
--     ["Melee"] = {
--         ["Enable"] = true, -- เซ็ทค่าตอนแรกได้ว่าจะเปิดใช้งานฟังชั่นเลยไหม จะได้ไม่ต้องกดใน Ui
--         ["Select"] = "Dragon Talon", -- "Sanguine Art", "Dragon Talon", "Sharkman Karate"
--     },
--     ["Setup"]= {
--         ["Enable"] = false, -- เซ็ทค่าตอนแรกได้ว่าจะเปิดใช้งานฟังชั่นเลยไหม จะได้ไม่ต้องกดใน Ui
--     }
-- }

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

local function tween(pos)
    local TweenPart = game.Workspace:FindFirstChild("TweenPart")
    if not TweenPart then TweenPart = creatTweenPart() end


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

getgenv().meleeConfigs = {
    ["Position"] = nil,
    ["Remote"] = nil
}

local function buyMelee()

    if player:GetAttribute("ExactLocation") == "Submerged Island" then
        tween(CFrame.new(11426.201171875, -2155.0634765625, 9730.7080078125))
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/SubmarineTransportation"):InvokeServer("InitiateTeleport", "Tiki Outpost")
        task.wait(2)
    else
        if not getgenv().meleeConfigs["Position"] or not getgenv().meleeConfigs["Remote"] then warn("return") return end
        tween(getgenv().meleeConfigs["Position"])
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(getgenv().meleeConfigs["Remote"])
    end

end

local function setupSharkSet()

    if player:GetAttribute("ExactLocation") == "Submerged Island" then
        tween(CFrame.new(11426.201171875, -2155.0634765625, 9730.7080078125))
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/SubmarineTransportation"):InvokeServer("InitiateTeleport", "Tiki Outpost")
        task.wait(2)
    end

    for _, name in game:GetDescendants() do
        if name:IsA("Tool") and name.ToolTip == "Melee" and name.Name ~= "Sharkman Karate" and (name.Parent == player.Backpack or name.Parent == player.Character) then
            tween(CFrame.new(-4972.06689453125, 314.4974365234375, -3218.112060546875))
            task.wait(1)
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("BuySharkmanKarate")
            break
        end
    end
    
    local itemList = {
        {name = "Saber", id = 16}
        -- {name = "Hallow Scythe", id = 160},
        -- {name = "Cursed Dual Katana", id = 175},
        -- {name = "Yama", id = 135},
        -- {name = "Tushita", id = 136},
        -- {name = "Spikey Trident", id = 168}
    }
    
    local InventoryController = require(game:GetService("ReplicatedStorage").Controllers.UI.Inventory)
    local ItemReplication = require(game:GetService("ReplicatedStorage").Util.ItemReplication)
    
    local foundItem = nil
    
    -- ตรวจสอบ Item ในกระเป๋า
    for _, item in ipairs(InventoryController:GetTiles()) do
        local itemId = item.ItemId
        local uid = item.NetworkedUID
        
        -- เช็คว่า Item ID ตรงกับในตารางหรือไม่
        for _, listItem in ipairs(itemList) do
            if itemId == listItem.id then
                if not foundItem then
                    foundItem = listItem.name
                end
            end
        end
    end
    
    -- สวมใส่ Item ที่เจอตัวแรก
    if foundItem then
        local args = {
            "LoadItem",
            foundItem
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    else
        print("not found any any item")
    end
end

spawn(function()
    while task.wait(0.5) do
        if getgenv().BuyMelee then
            buyMelee()
        end

        if getgenv().Setup then
            setupSharkSet()
        end
    end
end)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Setup item",
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
    Desc = "Buy selected melee",
    Icon = "status",
    Type = "Checkbox",
    Value = getgenv().Configs["Melee"]["Enable"], -- default value
    Callback = function(state)
        getgenv().BuyMelee = state
        if not state then getgenv().startTween:Cancel() end
    end
})

local Dropdown = Tab:Dropdown({
    Title = "Select Melee",
    Desc = "none",
    Values = { "Sanguine Art", "Dragon Talon", "Sharkman Karate" },
    Value = getgenv().Configs["Melee"]["Select"],
    Callback = function(option)
        if option == "Sanguine Art" then
            print(option)
            getgenv().meleeConfigs["Position"] = CFrame.new(-16516.1328125, 23.38727569580078, -189.69615173339844)
            getgenv().meleeConfigs["Remote"] = "BuySanguineArt"
        elseif option == "Dragon Talon" then
            getgenv().meleeConfigs["Position"] = CFrame.new(5661.89794921875, 1210.876953125, 863.176025390625)
            getgenv().meleeConfigs["Remote"] = "BuyDragonTalon"
        elseif option == "Sharkman Karate" then
            getgenv().meleeConfigs["Position"] = CFrame.new(-4971.2060546875, 313.8869323730469, -3223.0791015625)
            getgenv().meleeConfigs["Remote"] = "BuySharkmanKarate"
        end
    end
})

local SetupShark = Tab:Toggle({
    Title = "Setup",
    Desc = "Saber && Sharkman Melee",
    Icon = "status",
    Type = "Checkbox",
    Value = getgenv().Configs["Setup"]["Enable"], -- default value
    Callback = function(state)
        getgenv().Setup = state
        if not state then getgenv().startTween:Cancel() end
    end
})