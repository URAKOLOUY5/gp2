debug = true
FORCE_GUN_AND_HALLWAY = false 

FIRST_MAP_WITH_GUN = "sp_a1_intro4"
FIRST_MAP_WITH_UPGRADE_GUN = "sp_a2_laser_intro"
FIRST_MAP_WITH_POTATO_GUN = "sp_a3_speed_ramp"
LAST_PLAYTEST_MAP = "sp_a4_finale4"

FORCED_NO_PORTALGUN = {
    ["sp_a2_intro"] = true
}

CHAPTER_TITLES = {
    ["sp_a1_intro1"] = { title_text = "#portal2_Chapter1_Title", subtitle_text = "#portal2_Chapter1_Subtitle", displayOnSpawn = false, displaydelay = 1.0 },
    ["sp_a2_laser_intro"] = { title_text = "#portal2_Chapter2_Title", subtitle_text = "#portal2_Chapter2_Subtitle", displayOnSpawn = true, displaydelay = 2.5 },
    ["sp_a2_sphere_peek"] = { title_text = "#portal2_Chapter3_Title", subtitle_text = "#portal2_Chapter3_Subtitle", displayOnSpawn = true, displaydelay = 2.5 },
    ["sp_a2_column_blocker"] = { title_text = "#portal2_Chapter4_Title", subtitle_text = "#portal2_Chapter4_Subtitle", displayOnSpawn = true, displaydelay = 2.5 },
    ["sp_a2_bts3"] = { title_text = "#portal2_Chapter5_Title", subtitle_text = "#portal2_Chapter5_Subtitle", displayOnSpawn = true, displaydelay = 1.0 },
    ["sp_a3_00"] = { title_text = "#portal2_Chapter6_Title", subtitle_text = "#portal2_Chapter6_Subtitle", displayOnSpawn = true, displaydelay = 1.5 },
    ["sp_a3_speed_ramp"] = { title_text = "#portal2_Chapter7_Title", subtitle_text = "#portal2_Chapter7_Subtitle", displayOnSpawn = true, displaydelay = 1.0 },
    ["sp_a4_intro"] = { title_text = "#portal2_Chapter8_Title", subtitle_text = "#portal2_Chapter8_Subtitle", displayOnSpawn = true, displaydelay = 2.5 },
    ["sp_a4_finale1"] = { title_text = "#portal2_Chapter9_Title", subtitle_text = "#portal2_Chapter9_Subtitle", displayOnSpawn = false, displaydelay = 1.0 },
}

-- Display the chapter title
function DisplayChapterTitle()
    local level = CHAPTER_TITLES[game.GetMap()]
    
    if level then
        EntFire( "@chapter_title_text", "SetTextColor", "210 210 210 128", 0.0 )
        EntFire( "@chapter_title_text", "SetTextColor2", "50 90 116 128", 0.0 )
        EntFire( "@chapter_title_text", "SetPosY", "0.32", 0.0 )
        EntFire( "@chapter_title_text", "SetText", level.title_text, 0.0 )
        EntFire( "@chapter_title_text", "display", "", level.displaydelay )
        
        EntFire( "@chapter_subtitle_text", "SetTextColor", "210 210 210 128", 0.0 )
        EntFire( "@chapter_subtitle_text", "SetTextColor2", "50 90 116 128", 0.0 )
        EntFire( "@chapter_subtitle_text", "SetPosY", "0.35", 0.0 )
        EntFire( "@chapter_subtitle_text", "settext", level.subtitle_text, 0.0 )
        EntFire( "@chapter_subtitle_text", "display", "", level.displaydelay )
    end
end

-- TryDisplayChapterTitle
function TryDisplayChapterTitle()
    local level = CHAPTER_TITLES[game.GetMap()]

    if level and level.displayonSpawn then
        DisplayChapterTitle()
    end
end

LOOP_TIMER = 0
initialized = false

MapPlayOrder = {
    -- ====================== ACT 1 ======================
    -- Intro
    "sp_a1_intro1", -- motel to box-on-button
    "sp_a1_intro2", -- portal carousel
    "sp_a1_intro3", -- fall-through-floor, dioramas, portal gun
    "sp_a1_intro4", -- box-in-hole for placing on button
    "sp_a1_intro5", -- fling hinting
    "sp_a1_intro6", -- fling training
    "sp_a1_intro7", -- wheatley meetup
    "sp_a1_wakeup", -- glados
    "@incinerator",

    -- ====================== ACT 2 ======================
    "sp_a2_intro", -- upgraded portal gun track

    -- Lasers
    "sp_a2_laser_intro",
    "sp_a2_laser_stairs",
    "sp_a2_dual_lasers",
    "sp_a2_laser_over_goo",

    -- Catapult
    "sp_a2_catapult_intro",
    "sp_a2_trust_fling",

    -- More Lasers
    "sp_a2_pit_flings",
    "sp_a2_fizzler_intro",

    -- Lasers + Catapult
    "sp_a2_sphere_peek",
    "sp_a2_ricochet",

    -- Bridges
    "sp_a2_bridge_intro",
    "sp_a2_bridge_the_gap",

    -- Turrets
    "sp_a2_turret_intro",
    "sp_a2_laser_relays", -- breather
    "sp_a2_turret_blocker",
    "sp_a2_laser_vs_turret", -- Elevator Glados Chat - Should be removed?

    -- Graduation
    "sp_a2_pull_the_rug",
    "sp_a2_column_blocker", -- Elevator_vista
    "sp_a2_laser_chaining",
    -- "sp_a2_turret_tower",
    "sp_a2_triple_laser",

    -- Sabotage
    "sp_a2_bts1",
    "sp_a2_bts2",
    "sp_a2_bts3",
    "sp_a2_bts4",
    "sp_a2_bts5",
    "sp_a2_bts6",

    -- Glados Chamber Sequence
    "sp_a2_core",

    -- ====================== ACT 3 ======================
    -- Underground
    "sp_a3_00",
    "sp_a3_01",
    "sp_a3_03",
    "@test_dome_lift",
    "sp_a3_jump_intro",
    "@test_dome_lift",
    "sp_a3_bomb_flings",
    "@test_dome_lift",
    "sp_a3_crazy_box",
    "@test_dome_lift",
    "sp_a3_transition01",
    "@test_dome_lift",
    "sp_a3_speed_ramp",
    "@test_dome_lift",
    "sp_a3_speed_flings",
    "@test_dome_lift",
    "sp_a3_portal_intro",
    "@hallway",
    "sp_a3_end",

    -- ====================== ACT 4 ======================
    -- Recapture
    "sp_a4_intro",

    -- Tractor beam
    "sp_a4_tb_intro",
    "sp_a4_tb_trust_drop",
    -- "@hallway",
    "sp_a4_tb_wall_button",
    -- "@hallway",
    "sp_a4_tb_polarity",
    -- "@hallway",
    "sp_a4_tb_catch", -- GRAD

    -- Crushers
    -- Graduation Combos
    "sp_a4_stop_the_box", -- Grad?
    -- "@hallway",
    "sp_a4_laser_catapult", -- Grad
    -- "@hallway",
    -- "sp_catapult_course"
    -- "@hallway",
    -- "sp_box_over_goo", -- Grad
    -- "@hallway",
    "sp_a4_laser_platform",

    -- Tbeam + Paint
    -- "sp_paint_jump_tbeam",
    -- "@hallway",
    "sp_a4_speed_tb_catch",
    -- "@hallway",
    "sp_a4_jump_polarity", -- GRAD
    -- "@hallway",
    -- "sp_paint_portal_tbeams",

    -- Wheatley Escape
    "sp_a4_finale1",
    "sp_a4_finale2",
    "sp_a4_finale3",

    -- Wheatley Battle
    "sp_a4_finale4",

    -- Demo files
    "demo_intro",
    "demo_underground",
    "demo_paint"
}

-- OnPostTransition - we just transitioned, teleport us to the correct place.
function OnPostTransition()
    local foundMap = false
    
    for index, map in ipairs(MapPlayOrder) do
        if game.GetMap() == MapPlayOrder[index] then
            foundMap = true
            
            -- Hook up our entry elevator
            if index - 1 >= 1 then
                if not string.find(MapPlayOrder[index - 1], "@") then
                    print("Teleporting to default start pos")
                    EntFire("@elevator_entry_teleport", "TeleportToCurrentPos", 0, 0)
                    EntFire("@arrival_teleport", "TeleportToCurrentPos", 0, 0)
                else
                    print("Trying to teleport to " .. MapPlayOrder[index - 1] .. "_teleport")
                    EntFire(MapPlayOrder[index - 1] .. "_entry_teleport", "Teleport", 0, 0.0)
                end
            end
            break
        end
    end
    
    if not foundMap then
        EntFire("@elevator_entry_teleport", "TeleportToCurrentPos", 0, 0)
        EntFire("@arrival_teleport", "TeleportToCurrentPos", 0, 0)
    end

    EntFire("arrival_elevator-elevator_1_interior_start_trigger", "Enable", 0, 0.5)
end

function Think()
    
end

function OnPostPlayerSpawn(ply)
    EntFire("arrival_elevator-elevator_1_interior_start_trigger", "Disable", 0, 0)

    local mapWithGunIndex = 999
    local mapWithDualGunIndex = 999
    local mapWithGunPotatoGun = 999

    local map = game.GetMap()

    for i, level in ipairs(MapPlayOrder) do
        if FORCED_NO_PORTALGUN[level] then continue end

        if level == FIRST_MAP_WITH_GUN then
            mapWithGunIndex = i
        end

        if level == FIRST_MAP_WITH_UPGRADE_GUN then
            mapWithDualGunIndex = i
        end

        if level == FIRST_MAP_WITH_POTATO_GUN then
            mapWithGunPotatoGun = i
        end

        if i >= mapWithGunIndex and level == map then
            timer.Simple(0, function()
                ply:Give("weapon_portalgun")
            end)
        end

        if i >= mapWithGunPotatoGun and level == map then
            timer.Simple(0, function()
                ply:GetActiveWeapon():UpdatePotatoGun(true)
            end)
        end
    end
end

function TransitionReady()
    Globals.TransitionReady = 1
end

function TransitionFromMap()
    for i = 1, #MapPlayOrder do
        local order = MapPlayOrder[i]

        if order == game.GetMap() then
            local i1 = i + 1
            local nextMap = MapPlayOrder[i1]

            while nextMap ~= nil and nextMap:StartsWith("@") do
                i1 = i1 + 1
                nextMap = MapPlayOrder[i1]
            end

            if not nextMap then return end

            if nextMap then
                print("Changing level to " .. nextMap)
                EntFire("@changelevel", "Changelevel", nextMap, 0)
            end
        end
    end
end