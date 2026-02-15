getgenv().Configs = {
    ["Melee"] = {
        ["Enable"] = false, -- เซ็ทค่าตอนแรกได้ว่าจะเปิดใช้งานฟังชั่นเลยไหม จะได้ไม่ต้องกดใน Ui
        ["Select"] = nil, -- "Sanguine Art", "Dragon Talon", "Sharkman Karate"
    },
    ["Setup"] = {
        ["Enable"] = false, -- เซ็ทค่าตอนแรกได้ว่าจะเปิดใช้งานฟังชั่นเลยไหม จะได้ไม่ต้องกดใน Ui
    },
    ["Craft&Farm"] = {
        ["Enable"] = false,
    }
}

loadstring(game:HttpGet('https://raw.githubusercontent.com/Gl1tchl-4r/buy-melee/refs/heads/main/script.lua'))()