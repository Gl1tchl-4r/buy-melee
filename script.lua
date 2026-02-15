-- getgenv().Configs = {
--     ["Melee"] = {
--         ["Enable"] = false, -- เซ็ทค่าตอนแรกได้ว่าจะเปิดใช้งานฟังชั่นเลยไหม จะได้ไม่ต้องกดใน Ui
--         ["Select"] = nil, -- "Sanguine Art", "Dragon Talon", "Sharkman Karate"
--     },
--     ["Setup"] = {
--         ["Enable"] = false, -- เซ็ทค่าตอนแรกได้ว่าจะเปิดใช้งานฟังชั่นเลยไหม จะได้ไม่ต้องกดใน Ui
--     },
--     ["Craft&Farm"] = {
--         ["Enable"] = false,
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

local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

local function tween(targetCFrame)
    local TweenPart = workspace:FindFirstChild("TweenPart") or creatTweenPart()
    
    -- หยุด Tween เก่าที่อาจจะค้างอยู่ทันที เพื่อเริ่มอันใหม่ไปที่เป้าหมายใหม่
    if getgenv().startTween then
        getgenv().startTween:Cancel()
    end

    local distance = (targetCFrame.Position - TweenPart.Position).Magnitude
    
    -- ถ้าใกล้มากให้วาร์ปไปเลยเพื่อความเนียน
    if distance < 2 then
        TweenPart.CFrame = targetCFrame
        isTweening = true
        return
    end

    local TweenService = game:GetService("TweenService")
    -- ใช้ความเร็วที่เหมาะสม (เช่น 300-350)
    local tweenInfo = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear)
    
    isTweening = true
    getgenv().startTween = TweenService:Create(TweenPart, tweenInfo, {CFrame = targetCFrame})
    getgenv().startTween:Play()
    
    -- ** ห้ามใช้ .Completed:Wait() ในลูปที่ต้อง Update ตำแหน่งตลอดเวลา **
    -- เพราะจะทำให้ Loop หลักโดน Yield (หยุดรอ) จนตามศัตรูไม่ทัน
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

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Setup item",
    Icon = "hand-fist", -- lucide icon. optional
    Author = "by: odyssey_0", -- optional
})

local Main = Window:Tab({
    Title = "Main",
    Icon = "code", -- optional
    Locked = false,
})

Main:Select()

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

local Toggle = Main:Toggle({
    Title = "Buy Melee",
    Desc = "Buy selected melee",
    Icon = "status",
    Type = "Checkbox",
    Value = getgenv().Configs["Melee"]["Enable"], -- default value
    Callback = function(state)
        getgenv().BuyMelee = state
        if not state then
            getgenv().startTween:Cancel()
            wait()
            isTweening = false
        end
    end
})

local Dropdown = Main:Dropdown({
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

local SetupShark = Main:Toggle({
    Title = "Setup",
    Desc = "Saber && Sharkman Melee",
    Icon = "status",
    Type = "Checkbox",
    Value = getgenv().Configs["Setup"]["Enable"], -- default value
    Callback = function(state)
        getgenv().Setup = state
        if not state then
            getgenv().startTween:Cancel()
            wait()
            isTweening = false 
        end
    end
})

local One_click = Window:Tab({
    Title = "One-Click",
    Icon = "guitar", -- optional
    Locked = false,
})

local Craft_Farm_Toggle = One_click:Toggle({
    Title = "Craft and farm",
    Desc = "craft item then farm mastery",
    Icon = "status",
    Type = "Checkbox",
    Value = getgenv().Configs["Craft&Farm"]["Enable"], -- default value
    Callback = function(state)
        getgenv().CraftFarm = state
        if not state then 
            getgenv().startTween:Cancel()
            wait()
            isTweening = false 
        end
    end
})

local function getEnemies(range)
    local targets = {}
    local pos = player.Character:GetPivot().Position
    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        local root = enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChild("Humanoid")
        if root and humanoid and humanoid.Health > 0 then
            if (root.Position - pos).Magnitude <= range then
                table.insert(targets, enemy)
            end
        end
    end
    return targets
end

local function attack(method)
    local char = player.Character
    if not char or not char:FindFirstChildOfClass("Tool") then return end
    
    local enemies = method
    if #enemies == 0 then return end
    
    local modules = ReplicatedStorage.Modules
    local attackEvent = modules.Net["RE/RegisterAttack"]
    local hitEvent = modules.Net["RE/RegisterHit"]
    
    local targets, mainTarget = {}, nil
    local limbs = {"RightLowerArm", "RightUpperArm", "LeftLowerArm", "LeftUpperArm", "RightHand", "LeftHand"}
    
    for _, enemy in pairs(enemies) do
        local hitbox = enemy:FindFirstChild(limbs[math.random(#limbs)]) or enemy.PrimaryPart
        if hitbox then
            table.insert(targets, {enemy, hitbox})
            mainTarget = hitbox
        end
    end
    
    if mainTarget then
        attackEvent:FireServer(0)
        
        local success, combatThread = pcall(function()
            return require(modules.Flags).COMBAT_REMOTE_THREAD
        end)
        
        local hitFunc
        if getsenv then
            local env = getsenv(player.PlayerScripts:FindFirstChildOfClass("LocalScript"))
            if env then hitFunc = env._G.SendHitsToServer end
        end
        
        if success and combatThread and hitFunc then
            hitFunc(mainTarget, targets)
        else
            hitEvent:FireServer(mainTarget, targets)
        end
    end
end

local function checkItem(_item)
    local InventoryController = require(game:GetService("ReplicatedStorage").Controllers.UI.Inventory)
    local ItemReplication = require(game:GetService("ReplicatedStorage").Util.ItemReplication)

    local targets = {}
    if _item.id then
        table.insert(targets, _item)
    else
        targets = _item
    end

    for _, item in ipairs(InventoryController:GetTiles()) do
        local itemId = item.ItemId
        local uid = item.NetworkedUID

        for _, target in ipairs(targets) do
            if itemId == target.id then
                local mastery = ItemReplication.Mastery.readClient(itemId, uid)
                
                return mastery
            end
        end
    end

    return nil
end

local function getNearestEnemy(allowedNames)

    local nearestEnemy = nil
    local shortestDistance = math.huge
    
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local playerPos = char:GetPivot().Position
    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        local root = enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChild("Humanoid")
        
        local isAllowed = false
        for _, name in pairs(allowedNames) do
            if enemy.Name == name then
                isAllowed = true
                break
            end
        end
        if isAllowed and root and humanoid and humanoid.Health > 0 then
            local distance = (root.Position - playerPos).Magnitude
            
            if distance < shortestDistance then
                shortestDistance = distance
                nearestEnemy = enemy
            end
        end
    end

    return nearestEnemy
end

local enemylist = {
    "Demonic Soul",
    "Living Zombie",
    "Posessed Mummy",
    "Reborn Skeleton"
}

local weaponsFlags = {
    ["equipedSword"] = false,
    ["equipedGun"] = false,
}

local function equipTool(typeTool)
    pcall(function()
        local backpack = game:GetService("Players").LocalPlayer.Backpack:GetChildren()
        for _, v in pairs(backpack) do
            if v:IsA("Tool") and (v.ToolTip == typeTool or v.Name == typeTool) then
                humanoid:EquipTool(v)
            end
        end
    end)
end

local TargetPos;

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    -- ดักจับเมื่อสคริปต์พยายามอ่านค่า Hit หรือ Target จาก Mouse
    if not checkcaller() and (key == "Hit" or key == "Target") then
        if key == "Hit" then
            return TargetPos -- บังคับให้เมาส์ชี้ไปที่ตำแหน่งนี้เสมอ
        elseif key == "Target" then
            -- เลือกส่งค่า Instance บางอย่างกลับไป (เช่น ส่วนหัวของศัตรู)
            return workspace.Baseplate 
        end
    end
    return oldIndex(self, key)
end)

local function craftAndfarm()
    local itemName;
    local craftRemot = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/Craft")
    local itemList = {
        { name = "Dragonheart", id = 207 },
        { name = "Dragonstorm", id = 224 },
        -- { name = "Dual Flintlock", id = 6 },
    }

    if not checkItem(itemList[1]) then
        tween(CFrame.new(5865.9189453125, 1209.7281494140625, 810.3138427734375))
        itemName = itemList[1].name
        craftRemot:InvokeServer("Craft", itemName, {})
    elseif not checkItem(itemList[2]) then
        tween(CFrame.new(5865.9189453125, 1209.7281494140625, 810.3138427734375))
        itemName = itemList[2].name
        craftRemot:InvokeServer("Craft", itemName, {})
    else
        if player:GetAttribute("ExactLocation") ~= "Haunted Castle" then
            tween(CFrame.new(-9515.0947265625, 164.0069122314453, 5787.0087890625))
        else
            pcall(function()
                local enemies = getNearestEnemy(enemylist)
                if checkItem(itemList[1]) < 500 then
                    if not weaponsFlags["equipedSword"] then
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("LoadItem",itemList[1].name)
                        weaponsFlags["equipedSword"] = true
                    end

                    repeat task.wait()
                        equipTool("Melee")
                        tween(CFrame.new(enemies.HumanoidRootPart.Position) * CFrame.new(0,30,0))
                        attack(getEnemies(60))
                    until not getgenv().CraftFarm or not enemies.Humanoid or enemies.Humanoid.Health <= 0 or not enemies.Parent

                elseif checkItem(itemList[2]) < 500 then
                    if not weaponsFlags["equipedGun"] then
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("LoadItem",itemList[3].name)
                        weaponsFlags["equipedGun"] = true
                    end

                    repeat task.wait()
                        tween(enemies.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                        TargetPos = enemies.HumanoidRootPart.CFrame
                        equipTool("Gun")
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    until not getgenv().CraftFarm or not enemies.Humanoid or enemies.Humanoid.Health <= 0 or not enemies.Parent
                end
            end)
        end
    end
end

spawn(function()
    while task.wait(0.5) do
        print("aaaaaaafsdfa;;jofjwopfj")
        if getgenv().BuyMelee then
            buyMelee()
        end

        if getgenv().Setup then
            setupSharkSet()
        end

        if getgenv().CraftFarm then
            craftAndfarm()
        end

    end
end)

