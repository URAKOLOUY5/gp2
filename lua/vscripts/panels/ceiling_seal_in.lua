-- --------------------------------------------------------
function CloseCeilingOld()
    local panelDelay = 0.35
    local panelCount = 57
    local exitPanelCount = 3
    local panelOrder = {}

    -- seed
    for i=0,panelCount-1 do
        panelOrder[i] = i
    end

    -- shuffle
    for i=0,panelCount-exitPanelCount-1 do
        local temp = panelOrder[i]
        local index = math.random(0,panelCount-(exitPanelCount+1)-1)
        panelOrder[i] = panelOrder[index]
        panelOrder[index] = temp        
    end

    for i=0,panelCount-1 do
        local doorNum = 1 + panelOrder[i]
        
        -- print("closing door " .. doorNum)
        
        EntFire("door_" .. doorNum .. "-shutter_door","Open", "", panelDelay*i )
    end
end

-- --------------------------------------------------------
-- function SealChambers()
--     local panelCount = 56 
--
--     for i=0,panelCount-1 do
--         local doorNum = 1 + i    
--         EntFire("door_" .. doorNum .. "-shutter_door","Close", "", 0 )
--     end
-- end

local armCount = 61

local closeDoor1 = 28
local closeDoor2 = 29
local farDoor1 = 25
local farDoor2 = 26
local finalDoor1 = 33
local finalDoor2 = 61

function Seal()
    -- local armOrder = {}
    --
    -- -- seed
    -- for i=0,armCount-1 do
    --     local checkDoor = i+1
    --     if checkDoor ~= closeDoor1 and
    --        checkDoor ~= closeDoor2 and
    --        checkDoor ~= farDoor1 and
    --        checkDoor ~= farDoor2 and
    --        checkDoor ~= finalDoor1 and
    --        checkDoor ~= finalDoor2 then
    --         table.insert(armOrder, i)
    --     end
    -- end
    -- 
    -- -- shuffle
    -- for i=1,#armOrder do
    --     local temp = armOrder[i]
    --     local index = math.random(1,#armOrder)
    --     armOrder[i] = armOrder[index]
    --     armOrder[index] = temp        
    -- end
    -- 
    -- table.insert(armOrder, closeDoor1)
    -- table.insert(armOrder, closeDoor2)
    -- table.insert(armOrder, farDoor1)
    -- table.insert(armOrder, farDoor2)
    -- table.insert(armOrder, finalDoor1)
    -- table.insert(armOrder, finalDoor2)
    -- 
    -- for i=1,#armOrder do
    --     -- print("Arm " .. (armOrder[i] + 1) .. " has timer " .. timer * 0.35 )
    --     
    --     SealOneArm(armOrder[i] + 1, i * 0.35) -- the last arms in the list go last
    -- end

    local timer = 0
    for i=0,armCount-1 do    
        if i == 33 then
            timer = 0
        end
        
        local count = i
        if count > 32 then 
            count = count - 34
            timer = timer + 0.02*count
        else
            timer = timer + 0.014*count
        end
        
        -- print((i+1) .. " at time " .. timer)
            
        SealOneArm(i + 1, timer) -- the last arms in the list go last
    end

    -- EntFire("door_script", "RunScriptCode", "TryCloseFinalDoors()", 0.35*(#armOrder+2))
end

function Setup()
    for i=0,armCount-1 do
        local armNum = 1 + i    
        SetArmIdle(armNum)
    end
end

function Cleanup()
    for i=0,armCount-1 do
        local armNum = 1 + i    
        CleanUpArm(armNum)
    end
end

function ShowDoors()
    for i=0,armCount-1 do
        local armNum = 1 + i    
        EnableArm(armNum, true)
    end
end

function HideDoors()
    for i=0,armCount-1 do
        local armNum = 1 + i    
        EnableArm(armNum, false)
    end
end

function CloseFirstDoor()
    -- print("Closing first door!")
    -- SealOneArm(closeDoor1, 0)
    -- SealOneArm(closeDoor2, 0)
    -- 
    -- closeDoor1 = -1
    -- closeDoor2 = -1
end

function CloseSecondDoor()
    -- print("Closing second door!")
    -- SealOneArm(farDoor1, 0)
    -- SealOneArm(farDoor2, 0)    
    --
    -- farDoor1 = -1
    -- farDoor2 = -1
end

function TryCloseFinalDoors()
    if closeDoor1 ~= -1 then
        SealOneArm(closeDoor1, 0)
    end

    if closeDoor2 ~= -1 then
        SealOneArm(closeDoor2, 0)
    end

    if farDoor1 ~= -1 then
        SealOneArm(farDoor1, 0)
    end

    if farDoor2 ~= -1 then
        SealOneArm(farDoor2, 0)
    end

    SealOneArm(finalDoor1, 0)
    SealOneArm(finalDoor2, 0)
end

function SetArmIdle(arm_number)
    local prefabName = "sealin_" .. arm_number
    EntFire(prefabName .. "-arm_1", "setanimationnoreset", "block_lower01_drop_idle", 0)
    EntFire(prefabName .. "-arm_2", "setanimationnoreset", "block_upper01_drop_idle", 0)
end

function SealOneArm(arm_number, delay)
    local prefabName = "sealin_" .. arm_number
    local bottomArmName = prefabName .. "-arm_1"
    local topArmName = prefabName .. "-arm_2"
    local bottomPanelName = prefabName .. "-panel_1"
    local topPanelName = prefabName .. "-panel_2"  
    
    if arm_number ~= closeDoor1 and
       arm_number ~= closeDoor2 and
       arm_number ~= farDoor1 and
       arm_number ~= finalDoor1 and
       (arm_number % 3) ~= 0 then
        EntFire(bottomArmName, "setanimationnoreset", "block_lower01_drop", 0.0 + delay)
        EntFire(bottomArmName, "setanimationnoreset", "block_lower01_grabpanel", 1.0 + delay)

        EntFire(bottomPanelName, "setparent", bottomArmName, 1.5 + delay)
        EntFire(bottomPanelName, "setparentattachment", "panel_attach", 1.5 + delay)
        
        EntFire(bottomArmName, "setanimationnoreset", "block_lower01_pushforward", 2.0 + delay)
        
        delay = delay + math.random(-20, 20) / 100

        EntFire(topArmName, "setanimationnoreset", "block_upper01_pushforward", 2.0 + delay)
        
        EntFire(bottomPanelName, "clearparent", "", 3.5 + delay)
    else
        EntFire(topArmName, "setanimationnoreset", "block_upper02_abovestairs", 2.0 + delay)
        EntFire(bottomArmName, "kill", "", 0.0)
    end
    
    EntFire(topArmName, "setanimationnoreset", "block_upper01_drop", 0.0 + delay)
    EntFire(topArmName, "setanimationnoreset", "block_upper01_grabpanel", 1.0 + delay)

    EntFire(topPanelName, "setparent", topArmName, 1.5 + delay)
    EntFire(topPanelName, "setparentattachment", "panel_attach", 1.5 + delay)
    
    EntFire(topPanelName, "clearparent", "", 3.5 + delay)
end

function CleanUpArm(arm_number, delay)
    local prefabName = "sealin_" .. arm_number
	local bottomArmName = prefabName .. "-arm_1"
	local topArmName = prefabName .. "-arm_2"
	local bottomPanelName = prefabName .. "-panel_1"
	local topPanelName = prefabName .. "-panel_2"
	
	EntFire(topArmName, "kill", "", 0.0 )
	EntFire(topPanelName, "kill", "", 0.0 )
	EntFire(bottomArmName, "kill", "", 0.0 )
	EntFire(bottomPanelName, "kill", "", 0.0 )
end

function EnableArm(arm_number, enabled)
    local prefabName = "sealin_" .. arm_number
	local bottomArmName = prefabName .. "-arm_1"
	local topArmName = prefabName .. "-arm_2"
	local bottomPanelName = prefabName .. "-panel_1"
	local topPanelName = prefabName .. "-panel_2"

    if enabled then
        EntFire(topArmName, "Enable", "", 0.0 )
		EntFire(topPanelName, "Enable", "", 0.0 )
		EntFire(bottomArmName, "Enable", "", 0.0 )
		EntFire(bottomPanelName, "Enable", "", 0.0 )
    else
        EntFire(topArmName, "Disable", "", 0.0 )
		EntFire(topPanelName, "Disable", "", 0.0 )
		EntFire(bottomArmName, "Disable", "", 0.0 )
		EntFire(bottomPanelName, "Disable", "", 0.0 )
    end
end