--[[
    Extra info: 
    -> Library has notifications
    -> Library has an unload function and doesnt have auto unload on re-execute.
    -> Please credit me this lib took SOOO long
]]

local dim_offset = UDim2.fromOffset 
local dim2 = UDim2.new 
local Camera = workspace.CurrentCamera -- DETECTED WTFFF
local rgb = Color3.fromRGB 
local Players = cloneref(game:GetService("Players")) -- Thanks peke for the bullying 
local LocalPlayer = Players.LocalPlayer

local Library, Esp, MiscOptions, Options = loadstring(game:HttpGet("https://raw.githubusercontent.com/vertb1/Libraries/refs/heads/main/Octohook/Library.lua"))()
local Holder = Library:Window({Name = "vert$! | " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name})

local Window = Holder:Panel({
    Name = "vert$! | " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, 
    ButtonName = "Menu", 
    Size = dim_offset(550, 709), 
    Position = dim2(0, (Camera.ViewportSize.X / 2) - 550/2, 0, (Camera.ViewportSize.Y / 2) - 709/2), -- offset based on sizing 
})

local Tabs = {
    Combat = Window:Tab({Name = "Combat"}),
    Players = Window:Tab({Name = "Players"}),
}

-- Main documentation
    local tab = Tabs.Combat
    local col1 = tab:Column({})
    local col2 = tab:Column({})

    -- Hitbox expansion variables
    local expandedHitboxes = {}
    local originalSizes = {}
    local hitboxEnabled = false
    local hitboxSize = 10
    local hitboxColor = rgb(255, 0, 0)
    local hitboxMaterial = Enum.Material.ForceField
    local hitboxTransparency = 0.5

    -- Function to expand player hitboxes
    local function expandPlayerHitbox(player)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end

        local hrp = player.Character.HumanoidRootPart
        
        -- Store original size if not already stored
        if not originalSizes[player] then
            originalSizes[player] = hrp.Size
        end

        -- Create or update expanded hitbox
        if hitboxEnabled then
            hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
            hrp.Color = hitboxColor
            hrp.Material = hitboxMaterial
            hrp.Transparency = hitboxTransparency
            expandedHitboxes[player] = true
        else
            -- Restore original hitbox
            if originalSizes[player] then
                hrp.Size = originalSizes[player]
                hrp.Material = Enum.Material.Plastic
                hrp.Transparency = 1
            end
            expandedHitboxes[player] = nil
        end
    end

    -- Function to clean up player data
    local function cleanupPlayer(player)
        expandedHitboxes[player] = nil
        originalSizes[player] = nil
    end

    -- Function to update all players
    local function updateAllPlayers()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                expandPlayerHitbox(player)
            end
        end
    end

    local main = col1:Section({Name = "Main"})
    main:Toggle({
        Name = "Expand Hitboxes", 
        Default = false,
        Tooltip = {
            Title = "Expand Hitboxes",
            Text = "Makes player hitboxes larger and visible.\nUseful for easier targeting in combat.",
            Width = 250
        },
        Callback = function(state)
            hitboxEnabled = state
            updateAllPlayers()
        end
    })
    :Colorpicker({
        Color = hitboxColor, 
        Alpha = 1,
        Callback = function(color, alpha)
            hitboxColor = color
            if hitboxEnabled then
                updateAllPlayers()
            end
        end
    })

    main:Slider({
        Name = "Hitbox Size", 
        Min = 1, 
        Max = 50, 
        Default = 10, 
        Decimal = 1,
        Tooltip = {
            Title = "Hitbox Size",
            Text = "Controls how large the expanded hitboxes will be.\nHigher values = larger hitboxes.",
            Width = 230
        },
        Callback = function(value)
            hitboxSize = value
            if hitboxEnabled then
                updateAllPlayers()
            end
        end
    })

    main:Dropdown({
        Name = "Material", 
        Options = {
            "Plastic", "Wood", "Slate", "Concrete", "CorrodedMetal", 
            "DiamondPlate", "Foil", "Grass", "Ice", "Marble", "Granite", 
            "Brick", "Pebble", "Sand", "Fabric", "SmoothPlastic", 
            "Metal", "WoodPlanks", "Cobblestone", "Air", "Water", 
            "Rock", "Glacier", "Snow", "Sandstone", "Mud", "Basalt", 
            "Ground", "CrackedLava", "Neon", "Glass", "ForceField"
        }, 
        Default = "ForceField", 
        Multi = false,
        Scrolling = true,
        Size = 100,
        Tooltip = {
            Title = "Hitbox Material",
            Text = "Changes the visual appearance of expanded hitboxes.\nForceField and Neon are most visible.",
            Width = 240
        },
        Callback = function(option)
            hitboxMaterial = Enum.Material[option]
            if hitboxEnabled then
                updateAllPlayers()
            end
        end
    })

    main:Slider({
        Name = "Transparency", 
        Min = 0, 
        Max = 1, 
        Default = 0.5, 
        Decimal = 0.1,
        Tooltip = {
            Title = "Hitbox Transparency",
            Text = "Controls how see-through the hitboxes are.\n0 = Fully visible, 1 = Invisible",
            Width = 230
        },
        Callback = function(value)
            hitboxTransparency = value
            if hitboxEnabled then
                updateAllPlayers()
            end
        end
    })

-- 

-- Esp preview 
    local Column = Tabs.Players:Column({})
    local EspPreviewSection = Column:Section({Name = "ESP"})
    local EspPreview = EspPreviewSection:EspPreview({})
    local PlayersTab = EspPreview:AddTab({
        Name = "Players", 
        Model = "rbxassetid://14966982841",
        Chams = true
    });
    -- EspPreview:AddTab({Name = "Idk", Model = "rbxassetid://12340371165", Scale = 0.5})
    

    --[[
        READ IF YOU WANT TO MODIFY THE ESP SOURCE CODE

        Adding a new text or bar means you have to go to the createobject code and make a new element for said item 
            -> (Also you have to call addbar or addtext to add a suffix to the esp) 
           
        For adding static text (like usernames), make the text and filter it in the refreshelements function. 
            -> Yes the filter looks like yandere dev code and can be easily rewritten.
        
        For updating text, eg distance or tools or whatever, update it in the update function
            -> Look at the distance text for more info 

        Bars aren't filtered I didnt add code for it, if you want you can modify it to filter through like healthbars
            -> If you make the filter then you can follow same instructions as the text. 
        
        Boxes just exist, you dont need to do anything to them I believe

        Yes multi tabs exist however I didnt find a use for 2 tabs yet so the code may not be compatible, you will need to code a filter for that aswell.
        (Literally can be added in like under 5 minutes if you know lua)

        Extra Info: 
        + CHAMS ARE HARDCODED TO PLAYERS TAB
        + For the tab where the 3d character is held, there is a scale parameter for larger models. 
        + Esp relies on miscoptions and options for the newindex where each element is filtered and updated. Dont ask why.  
    ]]
    
    PlayersTab.AddBar({Name = "Healthbar", Prefix = "Healthbar"})
    PlayersTab.AddText({Name = "Name", Prefix = "Name"})
    PlayersTab.AddText({Name = "Distance", Prefix = "Distance"})
    PlayersTab.AddBox({Name = "Box"})
    
    local Column = Tabs.Players:Column({})
-- 

Tabs.Settings = Window:Tab({Name = "Settings"})
Library:Configs(Holder, Tabs.Settings)

-- Loops for text
    task.spawn(function()
        while task.wait(1) do
            if not Holder.Items.Holder.Visible then 
                continue
            end 

            local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
            Holder.ChangeMenuTitle(string.format("%s | %s | %s | :>", "vert$!", gameName, os.date("%b. %d %Y, %X")))
        end 
    end)

    local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    Holder.ChangeMenuTitle(string.format("%s | %s | %s | :>", "vert$!", gameName, os.date("%b. %d %Y, %X")))
-- 

-- init this before esp 
    for index,value in MiscOptions do 
        Options[index] = value -- gotta trigger that new index
    end
-- 

for _,player in Players:GetPlayers() do 
    if player == LocalPlayer then 
        continue 
    end 

    Esp.CreateObject(player)
end 

Esp:Connection(Players.PlayerRemoving, Esp.RemovePlayer)
Esp:Connection(Players.PlayerAdded, function(player)
    Esp.CreateObject(player)

    for index,value in MiscOptions do 
        Options[index] = value
    end 
end)

-- Hitbox management for players
Players.PlayerAdded:Connect(function(player)
    -- Wait for character to spawn
    player.CharacterAdded:Connect(function(character)
        task.wait(0.1) -- Small delay to ensure character is fully loaded
        if hitboxEnabled then
            expandPlayerHitbox(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    cleanupPlayer(player)
end)

-- Handle existing players' character respawning
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            task.wait(0.1)
            if hitboxEnabled then
                expandPlayerHitbox(player)
            end
        end)
    end
end
