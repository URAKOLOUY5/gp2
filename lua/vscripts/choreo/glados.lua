-- Rewritten choreo/glados.nut script

debug = true
debug_interval = 5

curMapName = game.GetMap()

lastthink = CurTime()

-- Pitch shifting stuff
pitchShifting = false
pitchShiftLastThink = CurTime()
pitchShiftInterval = 1.0
pitchShiftValue = 1.0
pitchOverride = nil

include "glados_scenetable_include"
include "glados_scenetable_include_manual"

scenequeue = {}
firedfromqueue = false

local sceneDingOn = CreateSceneEntity("scenes/npc/glados_manual/ding_on.vcd")
local sceneDingOff = CreateSceneEntity("scenes/npc/glados_manual/ding_off.vcd")

local queue = {}

function printdebug(msg)
    if debug then
        print(msg)
    end
end

-- Dialogs from glados.nut converted to [mapname] = data format
function MapNameConversion(orgname)
    return MapBspConversion[orgname] or orgname
end

GladosDialog = 
{
    ["sp_a1_intro2"] = { prestart = "PreHub01PortalCarouselEntry01", completed = "PreHub01PortalCarouselSuccess01" },
    ["sp_a1_intro3"] = { prestart = "sp_intro_03Start01", completed = "sp_intro_03MindTheGapFinish01" },
    ["sp_a1_intro4"] = { start = "PreHub01BoxDropperEntry01", completed = "sp_a1_intro4End01" },
    ["sp_a1_intro5"] = { start = "sp_a1_intro5Start01", completed = "PreHub01DualButtonOnePortalSuccessB01" },
    ["sp_a1_intro6"] = { start = "sp_a1_intro6Start01", completed = "sp_a1_intro6End01" },
    ["sp_a1_intro7"] = { prestart = "sp_a1_intro7Start01" },
    ["sp_laser_redirect_intro"] = { start = "sp_laser_redirect_introStart01", completed = "sp_laser_redirect_introEnd01" },
    ["sp_laser_stairs"] = { start = "sp_laser_stairsStart01", completed = "sp_laser_stairsEnd01" },
    ["sp_laser_dual_lasers"] = { prestart = "sp_laser_dual_lasersStart01", completed = "sp_laser_dual_lasersEnd01" },
    ["sp_laser_over_goo"] = { start = "sp_laser_over_gooStart01", completed = "sp_laser_over_gooEnd01" },
    ["sp_catapult_intro"] = { completed = "sp_catapult_introEnd01" },
    ["sp_trust_fling"] = { prestart = "sp_trust_flingStart01", completed = "sp_trust_flingEnd01" },
    ["sp_a2_pit_flings"] = { prestart = "sp_a2_pit_flingsStart01", completed = "sp_a2_pit_flingsCubeSmuggleEnding01" },
    ["sp_a2_fizzler_intro"] = { start = "sp_a2_fizzler_introStart01" },
    ["sp_catapult_fling_sphere_peek"] = { completed = "sp_catapult_fling_sphere_peekEnd01" },
    ["sp_a2_ricochet"] = { prestart = "sp_a2_ricochetStart01", completed = "sp_a2_ricochetEnd01" },
    ["sp_bridge_intro"] = { completed = "sp_bridge_introEnd01" },
    ["sp_bridge_the_gap"] = { prestart = "sp_bridge_the_gapStart01", completed = "sp_bridge_the_gapEnd01" },
    ["sp_turret_training_advanced"] = { prestart = "sp_turret_training_advancedStart01" },
    ["sp_laser_relays"] = { prestart = "sp_laser_relaysStart01", completed = "sp_laser_relaysEnd01" },
    ["sp_a2_turret_blocker"] = { prestart = "sp_turret_blocker_introStart01", completed = "sp_turret_blocker_introEnd01" },
    ["sp_laser_vs_turret_intro"] = { prestart = "sp_laser_vs_turret_introStart01", completed = "sp_laser_vs_turret_introEnd01" },
    ["sp_a2_pull_the_rug"] = { prestart = "sp_a2_pull_the_rugStart01", completed = "sp_a2_pull_the_rugEnd01" },
    ["sp_column_blocker"] = { completed = "sp_column_blockerEnd01" },
    ["sp_a2_laser_chaining"] = { prestart = "sp_a2_laser_chainingStart01", completed = "sp_a2_laser_chainingEnd01" },
    ["sp_a2_triple_laser"] = { start = "sp_a2_triple_laserStart01", completed = "sp_a2_triple_laserEnd01" },
    ["sp_sabotage_jailbreak"] = { prestart = "sp_sabotage_jailbreakStart01" },
    ["sp_a3_speed_ramp"] = { prestart = "-3150_01" },
    ["sp_a4_finale3"] = { prestart = "-4849_01" },
}

function Precache()
    if curMapName == "sp_a4_tb_trust_drop" then
        util.PrecacheSound("World.WheatleyZap")
    elseif curMapName == "sp_a1_wakeup" then
        util.PrecacheSound("World.HackBuzzer")
    elseif curMapName == "sp_a3_speed_ramp" then
        util.PrecacheSound("World.WheatleyZap")
        util.PrecacheSound("World.GladosPotatoZap")
    elseif curMapName == "sp_a1_wakeup" then
        util.PrecacheSound("World.GladosPotatoZap")
    end
end

function nuke()
	scenequeue = {}
	Queue = {}
	GladosAllCharactersStopScene()
	StopAllCaveSpeakers()
end

function StopAllCaveSpeakers()
    local caveactors = {
        "@cave_exit_lift",
        "cave_a3_03_dummy",
        "cave_a3_03_dummy2",
        "cave_a3_03_dummy3",
        "cave_a3_03_exit",
        "cave_a3_03_lift_shaft",
        "cave_a3_03_waiting_room",
        "cave_a3_jump_intro_entrance",
        "cave_a3_jump_intro_interchamber",
        "cave_a3_jump_intro_second_chamber",
        "cave_a3_transition01_dummy",
        "cave_a3_transition01_dummy2",
        "cave_a3_transition01_dummy3",
        "cave_bomb_flings_chamber",
        "cave_bomb_flings_entrance",
        "cave_crazy_box_2nd_chamber",
        "cave_crazy_box_dummy_chamber",
        "cave_crazy_box_entrance",
        "cave_portal_intro_entrance",
        "cave_portal_intro_exit",
        "cave_portal_intro_office",
        "cave_portal_intro_whitepaint",
        "cave_speed_flings_entrance",
        "cave_speed_ramp_entrance",
        "cave_speed_ramp_inter_chamber",
        "cave_transition01_dummy_exit",
        "cave_transition01_welcome"
    }

    for _, val in ipairs(caveactors) do
        local ent = ents.FindByName(val)
        if ent then
            for _, actor in ipairs(ent) do
                local sc = actor:GetCurrentScene()
                if sc ~= nil then
                    EntFireByHandle(sc, "Cancel", "", 0)
                end
            end
        end
    end
end

function EvaluateTimeKey(keyname, keytable)
    local ret = nil

    if keytable[keyname] then
        local typ = type(keytable[keyname])

        if typ == "table" then
            if #keytable[keyname] ~= 2 then
                printdebug("!!!!!!!!!!!!EVALUATE TIME KEY ERROR: " .. keyname .. " is an array with a length ~= 2")
				return 0.00
            end

            ret = math.Rand(keytable[keyname][1], keytable[keyname][2])
        else
            ret = keytable[keyname]
        end
    end

    if ret == nil then
        ret = 0.00
    end

    printdebug(">>>>>>>>>EVALUATE TIME KEY: ".. keyname .. " : " .. ret) 		
    return ret
end

-- Play a vcd from the SceneTable by lookup name or number
function GladosPlayVcd(arg, IgnoreQueue, caller)
    IgnoreQueue = IgnoreQueue or false
    caller = caller or nil

    printdebug("=========GladosPlayVcd Called!========= " .. tostring(arg))
    local dingon = false

    local inst
    local fromqueue = firedfromqueue
    firedfromqueue = false

    if issceneinstance(arg) then
        if arg.waitPreDelayed then
        -- if this is a vcd that was being held for predelay, play it
            inst = arg
            arg = inst.waitPreDelayedEntry
        else
            -- otherwise, play the next vcd in the chain
            inst = arg
            arg=inst.waitNext
        end
    else
        -- If this is a call from the map, look up the integer arg in the scene lookup table.
		-- We need to do this because hammer/the engine can't pass a squirrel script a string, just an integer.
		-- In other words, from a map, @glados.GladosPlayVcd("MyVcd") crashes the game. GladosPlayVcd(16) doesn't.
        -- URAKOLOUY5: haha poor dev, in Lua we can pass the @glados.GladosPlayVcd('MyVcd')
        -- silly C-like languages
        local sceneStart = 0
        if isnumber(arg) then
            if arg == 407 or arg == 43 then -- remove this line without changing map (12/21/2010)
                return
            end

            sceneStart = arg
            printdebug("{}{}{}{}{}{}{}{}{}GladosPlayVcd: " .. arg)
            arg = SceneTableLookup[arg]
        else
            sceneStart = 0
        end

        if not SceneTable[arg] then
            error("Argument " .. tostring(arg) .. " doesn't exist in SceneTable")
            return
        end

        -- if SkipIfBusy is present & we're already playing a scene, skip this new scene
        if SceneTable[arg]["skipifbusy"] then
            if IsValid(characterCurscene(SceneTable[arg].char)) then
                return
            end
        end

        -- if queue is present & we're already playing a scene, add scene to queue
        if SceneTable[arg]["queue"] then
            if not IgnoreQueue then
                if SceneTable[arg]["queuecharacter"] then
                    -- queue if a specific character is talking 
                    if IsValid(characterCurscene(SceneTable[arg].queuecharacter)) then
                        QueueAdd(arg)
                        return
                    end
                else
                    --otherwise, queue if the character associated with the vcd is talking
                    if IsValid(characterCurscene(SceneTable[arg].char)) then
                        QueueAdd(arg)
                        return
                    end
                end
            end
        end

        if (scenequeue_AddScene(arg, SceneTable[arg].char) == nil) then
            return
        end

        inst = scenequeue[arg]
        inst.waitSceneStart = sceneStart

        if SceneTable[arg]["idle"] then
            nags_init(inst, arg)
        end

        -- This is a new dialog block, so turn off special processing
        dingon = true
        pitchShifting = false
        --startBlock = CurTime()

        if SceneTable[arg]["noDingOff"] then
            inst.waitNoDingOff = true
        else
            inst.waitNoDingOff = false
        end

        if SceneTable[arg]["noDingOn"] then
            inst.waitNoDingOn = true
        else
            inst.waitNoDingOn = false
        end        
    end

    local preDelay = 0.00
    if not inst.waitPreDelayed then
        -- -- If this vcd wasn't called after a predelay (meaning the predelay already happened), see if there is a predelay
        preDelay = EvaluateTimeKey("predelay", SceneTable[arg])

        if fromqueue and SceneTable[arg]["queuepredelay"] then
            preDelay = EvaluateTimeKey("queuepredelay", SceneTable[arg])
        end

        -- If there is a predelay, set it and then GladosThink() will fire it after predelay seconds.
        if preDelay > 0.00 then
            inst.waitPreDelayed = true
			inst.waitDelayingUntil = CurTime() + preDelay
			inst.waitPreDelayedEntry = arg
            printdebug("======= " .. arg .. " PREDELAYED FOR " .. preDelay .." SECONDS")
            return
        end
    else
        -- Otherwise, set the PreDelayed flag to false
        inst.waitPreDelayed = false
		inst.waitPreDelayedEntry = nil
    end

    -- If this scene is a nag/idle cycle, grab the next line off the stack
    if inst.isNag then
        -- If we're not in a vcd chain, grab the next vcd from the randomized pool
        if not inst.naginchain then
            arg = nags_fetch(inst)
        end
        
        -- if nothing fetched (because the nag has used all the lines and isn't marked as "repeat"), remove this scene
        if arg == nil then
            scenequeue_DeleteScene(inst.index)
            return
        end
    end

    -- Set ducking volume correctly for booming glados audio
    --SendToConsole( "snd_ducktovolume 0.2" )

    --SetDucking( "announcerVOLayer", "announcerVO", 0.01 ) 
    --SetDucking( "gladosVOLayer", "gladosVO", 0.1 ) 

    if arg ~= nil then
        local ltalkover = SceneTable[arg]["talkover"]

        if ltalkover == nil then
            -- Cancel any vcd that's already playing
            GladosAllCharactersStopScene()
        else
            -- characters can't currently talk over themselves
            GladosCharacterStopScene(SceneTable[arg].char)
        end

        -- Play the initial ding (unless the scene specifically requests no ding)
        if dingon and not inst.waitNoDingOn then
            EntFireByHandle( sceneDingOn, "Start", "", 0.00 )
        end

        -- Start the new vcd	
        printdebug("===================Playing:" .. arg)
        inst.currentCharacter = SceneTable[arg].char

        -- Bind the OnCompletion Event
        printdebug(arg .. " OnCompletion time " .. " - " .. tostring(SceneTable[arg].vcd) ..  SceneTable[arg].vcd.id)
        SceneTable[arg].vcd:DisconnectOutput( "OnCompletion", "PlayNextScene" )
        SceneTable[arg].vcd:ConnectOutput( "OnCompletion", "PlayNextScene", self )
		SceneTable[arg].vcd:ConnectOutput( "OnCanceled", "SceneCanceled", self )

        -- Set the target1 if necessary
        if caller ~= nil then
            if isstring(caller) then
                EntFireByHandle( SceneTable[arg].vcd, "SetTarget1", caller, 0 )
				printdebug("++++++++++++SETTING TARGET: " .. caller)
            else
                EntFireByHandle( SceneTable[arg].vcd, "SetTarget1", caller:GetName(), 0 )
            end
        end

        if SceneTable[arg]["settarget1"] then
            printdebug("++++++++++++ " .. arg .. "SETTING TARGET: " .. SceneTable[arg].settarget1)
			EntFireByHandle( SceneTable[arg].vcd, "SetTarget1", SceneTable[arg].settarget1 , 0 )
        end

        inst.waitVcdTeam = SceneTable[arg].index
		inst.waitVcdCurrent = arg

        inst:addFiredVcd(SceneTable[arg].index)

        if dingon and not inst.waitNoDingOn then
            EntFireByHandle( SceneTable[arg].vcd, "Start", "", 0.18 )
        else	
            EntFireByHandle( SceneTable[arg].vcd, "Start", "", 0.00 )
        end

        -- Does this vcd have a "fire into entities" array?
        if SceneTable[arg]["fires"] then
            for _, val in pairs(SceneTable[arg].fires) do
                if val.fireatstart then
                    printdebug(">>>>>>ENT FIRE AT START: " .. val.entity .. " : " .. val.input)
					EntFire(val.entity, val.input, val.parameter, val.delay)
                end
            end
        end

        if SceneTable[arg]["special"] then
            if SceneTable[arg].special == 1 then
                -- Block-wide pitch shifting
                pitchShifting = true
            elseif SceneTable[arg].special == 2 then
                -- Speed up
                if pitchOverride == nil then
                    EntFireByHandle( SceneTable[arg].vcd, "PitchShift", "2.5", 0 )
                end
            elseif SceneTable[arg].special == 3 then
                EntFireByHandle( SceneTable[arg].vcd, "PitchShift", "0.9", 0 )
            end
        end

        if pitchOverride ~= nil then
            EntFireByHandle( SceneTable[arg].vcd, "PitchShift", tostring(pitchOverride), 0 )
        end

        -- Setup next line (if there is one)
        if SceneTable[arg].next ~= nil or inst.isNag then
            local pdelay = EvaluateTimeKey("postdelay", SceneTable[arg])

            -- if this is a nag, use min/max defined in the first entry in the scene
            if inst.isNag then
                pdelay = math.Rand(inst.nagminsecs,inst.nagmaxsecs)
            end

            if pdelay < 0.00 then
                if inst.isNag then
                    -- If the "next" key ~= nil, it means we're in a vcd chain
                    if SceneTable[arg].next ~= nil then
                        inst.waitNext = SceneTable[arg].next
                        inst.naginchain = true
                    else
                        -- Otherwise, just slug in the same index (any non-nil value would work here, however)
                        inst.waitNext = arg
                        inst.naginchain = false
                    end
                else
                    inst.waitNext = SceneTable[arg].next
                end
                
                inst.waitExitingEarly = true
                inst.waitLength = nil
                inst.waitExitingEarlyStartTime = CurTime()
                
                --If we're in a nag vcd chain, use the vcds postdelay rather than the nag-wide delay
                --This is because vcd chains generally need to be explicitly timed at the chain level
                --since the vcds are grouped together as a block   
                if inst.naginchain then
                    pdelay = EvaluateTimeKey("postdelay",SceneTable[arg])
                end
                
                inst.waitExitingEarlyThreshold = pdelay * -1
            else
                inst.waitExitingEarly = false
                if inst.isNag then
                    if SceneTable[arg].next ~= nil then
                        -- If the "next" key != nil, it means we're in a vcd chain                        
                        inst.waitNext = SceneTable[arg].next
                        inst.naginchain = true
                    else
                        -- Otherwise, just slug in the same index (any non-nil value would work here, however)
                        inst.waitNext = arg
                        inst.naginchain = false                        
                    end
                else
                    inst.waitNext = SceneTable[arg].next
                end

                -- If we're in a nag vcd chain, use the vcds postdelay rather than the nag-wide delay
                -- This is because vcd chains generally need to be explicitly timed at the chain level
                -- since the vcds are grouped together as a block                
                if inst.naginchain then
                    pdelay = EvaluateTimeKey("postdelay", SceneTable[arg])
                end
            end

            inst.waitLength = pdelay
        else
            inst.waitNext = nil
            printdebug("=================== SCENE END")
        end
    end
end

function GladosCharacterStopScene(arg)
    local ent = nil
    local curscene = characterCurscene(arg)

    if curscene and IsValid(curscene) then
        printdebug("&&&&&&STOP SCENE: " .. arg .. " FOUND SCENE TO DELETE!!!!!!!!!")
        EntFireByHandle(curscene, "Cancel", "", 0)
    else
        printdebug("&&&&&&STOP SCENE: NO SCENE TO DELETE FOR " .. arg)
    end
end

function GladosAllCharactersStopScene()
    GladosCharacterStopScene("glados")
    GladosCharacterStopScene("wheatley")
    GladosCharacterStopScene("cave_body")
    GladosCharacterStopScene("core01")
    GladosCharacterStopScene("core02")
    GladosCharacterStopScene("core03")
end
    
function characterCurscene(arg)
    local ret
    local ent

    -- Use if-elseif-else structure to mimic switch-case
    if arg == "bossannouncer" then
        ent = ents.FindByName("@actor_announcer")[1]
    elseif arg == "announcerglados" or arg == "glados" or arg == "@glados" then
        ent = ents.FindByName("@glados")[1]
    elseif arg == "cave" or arg == "@cave" then
        ent = ents.FindByName("@cave")[1]
    elseif arg == "@sphere" or arg == "wheatley" or arg == "sphere" then
        ent = ents.FindByName("@sphere")[1]
    elseif arg == "core01" or arg == "@core01" then
        ent = ents.FindByName("@core01")[1]
    elseif arg == "core02" or arg == "@core02" then
        ent = ents.FindByName("@core02")[1]
    elseif arg == "core03" or arg == "@core03" then
        ent = ents.FindByName("@core03")[1]
    elseif arg == "cave_body" or arg == "cavebody" then
        ent = ents.FindByName("@cave_body")[1]
    elseif arg == "conveyor_turret" then
        ent = ents.FindByName("conveyor_turret_body")[1]
    end

    if ent and IsValid(ent) then
        printdebug("&&&&&&FOUND ENTITY: " .. tostring(ent))
        ret = ent:GetCurrentScene()
    end
    
    return ret
end

-- PuzzleStart fires automatically as the player moves out of the level transition area
function PuzzleStart()
    local mapname = game.GetMap()
    printdebug('=========== Puzzle Start on ' .. mapname)

    local level = GladosDialog[MapNameConversion(mapname)]

    if level and level.start then
        printdebug('=========== Puzzle Start : playing scene ' .. level.start)
		GladosPlayVcd(level.start)
    end
end

-- PuzzlePreStart fires after level load and inital player spawn
function PuzzlePreStart()
	local mapname = game.GetMap()
    printdebug('=========== Puzzle Pre Start on ' .. mapname)

    local level = GladosDialog[MapNameConversion(mapname)]

    if level and level.prestart then
        printdebug('=========== Puzzle Pre Start : playing scene ' .. level.prestart)
		GladosPlayVcd(level.prestart)
    end
end

-- PuzzleCompleted fires when the glados exit speech is supposed to trigger
function PuzzleCompleted()
	local mapname = game.GetMap()
    printdebug('=========== Puzzle Completed on ' .. mapname)

    local level = GladosDialog[MapNameConversion(mapname)]

    if level and level.completed then
        printdebug('=========== Puzzle Completed : playing scene ' .. level.completed)
		GladosPlayVcd(level.completed)
    end
end

-- ExitStarted fires when the exit elevator doors close
function ExitStarted()
	local mapname = game.GetMap()
    printdebug('=========== Puzzle ExitStarted on ' .. mapname)

    local level = GladosDialog[MapNameConversion(mapname)]

    if level and level.exitstarted then
        printdebug('=========== Puzzle ExitStarted : playing scene ' .. level.exitstarted)
		GladosPlayVcd(level.exitstarted)
    end
end

-- Triggers when you drop into the "Mind the Gap" puzzle
function sp_a1_intro3_turret_live_fire()
    GladosPlayVcd(623)
end

-- sp_a1_intro6_first half of chamber
function MidpointPuzzleCompleted()
    GladosPlayVcd(626)
end

function GladosThink()
    -- Put debug stuff here!
    if debug then
        if CurTime() - lastthink > debug_interval then
            printdebug("===================GladosThink-> " .. lastthink)
            lastthink = CurTime()
            QueueDebug()
        end
    end

    -- Is GLaDOS gibbering
    -- if glados_gibbering then
    --   sp_sabotage_glados_gibberish()
    -- end

    -- Are we PitchShifting?
    if pitchShifting then
        if CurTime() - pitchShiftLastThink > pitchShiftInterval then
            local curscene = self:GetCurrentScene()

            if curscene ~= nil and IsValid(curscene) then
                local shiftAmount = math.random(-0.10, 0.10)

                if shiftAmount < 0 then
                    shiftAmount = shiftAmount * 1.5
                end

                pitchShiftValue = pitchShiftValue + shiftAmount
                
                if pitchShiftValue <= 0 or pitchShiftValue >= 1.7 then
                    pitchShiftValue = pitchShiftValue - (shiftAmount * 2)
                end

                EntFireByHandle(curscene, "PitchShift", pitchShiftValue, 0)
                pitchShiftInterval = math.Rand(0.1, 0.2)
            end

            -- Set Lastthink
            pitchShiftLastThink = CurTime()
        end
    end

    -- scan the list of currently playing scenes.
    for _, val in pairs(scenequeue) do
        -- Check if the current vcd is scheduled to exit early
        if val.waitPreDelayed then
            if CurTime() >= val.waitDelayingUntil then
                printdebug("*******LAUNCHING PREDELAYED SCENE")
                GladosPlayVcd(val)
            end
        end

        if val.waitExitingEarly then
            if CurTime() - val.waitExitingEarlyStartTime >= val.waitExitingEarlyThreshold then
                local team
                val.waitExitingEarly = false
                local curscene = characterCurscene(val.currentCharacter)

                if IsValid(curscene) then
                    curscene:DisconnectOutput( "OnCompletion", "PlayNextScene" )
                    curscene:DisconnectOutput( "OnCompletion", "SkipOnCompletion" )
                    curscene:ConnectOutput( "OnCompletion", "SkipOnCompletion", self )
                    team = curscene.id
                    val.waitVcdCurrent = findIndex(team)
                end

                printdebug("====Scene " .. val.index .. " EXITING EARLY")
                PlayNextSceneInternal(val)
                return
            end
        end
    end

    local tmp
    -- Check the deferred scene queue
    tmp = QueueThink()

    -- Is a queued scene ready to fire?
    if tmp ~= nil then
        printdebug("===========FORCING QUEUED SCENE: " .. tmp)
        GladosPlayVcd(tmp, true)
        return
    end

    for idx, val in pairs(scenequeue) do
        -- Are we waiting to play another vcd?
        if val.waiting == 1 then
            if CurTime() - val.waitStartTime >= val.waitLength then
                val.waiting = 0
                GladosPlayVcd(val)
                printdebug("\n\n ARE WE WAITING TO PLAY ANOTHER VCD? - YES!")
            end
        end
    end

    return 0
end

function findIndex(team)
    for idx, val in pairs(SceneTable) do
        if val.index == team then
            return idx
        end
    end

    return nil
end

function FindSceneInstanceByTeam(team)
    local inst = nil

    for idx, val in pairs(scenequeue) do
        printdebug(idx)
        for _, val2 in pairs(val.waitFiredVcds) do
            if val2 == team then
                inst = val
                break
            end
        end
        if inst ~= nil then
            break
        end
    end

    return inst
end

-- If a vcd is tagged to "exit early" (by setting postdelay < 0), 
-- this event fires rather than PlayNextScene() when the vcd finishes.
function SkipOnCompletion()
    printdebug("========SKIPONCOMPLETION CALLING ENTITY: " .. findIndex(owninginstance.id) .. " : TIME " .. CurTime())
    local team = owninginstance.id
	local inst = FindSceneInstanceByTeam(team)

    if inst ~= nil then
        inst:deleteFiredVcd(team)
		inst.waitVcdCurrent = findIndex(team)

        -- Are there any EntFires associated with this vcd?
        if inst.waitVcdCurrent ~= nil then
            if SceneTable[inst.waitVcdCurrent]["fires"] then
                for idx, val in ipairs(SceneTable[inst.waitVcdCurrent].fires) do
                    if not val.fireatstart then
                        printdebug(">>>>>>ENT FIRE AT (SKIPCOMPLETION) END: " .. val.entity .. " : " .. val.input)
						EntFire(val.entity,val.input,val.parameter,val.delay)
                    end
                end
            end
        end
    end
end

function PlayNextScene()
    local team = owninginstance.id
	local inst = FindSceneInstanceByTeam(team)
 
    if inst ~= nil then
        printdebug("========PLAYNEXTSCENE CALLING ENTITY: " .. findIndex(owninginstance.id) .. " : TIME " .. CurTime())
        inst:deleteFiredVcd(team)
        inst.waitVcdCurrent = findIndex(team)
        PlayNextSceneInternal(inst)
    else
        printdebug("========PLAYNEXTSCENE CALLING ENTITY NO LONGER EXISTS: CHECKING QUEUE...")
		QueueCheck()
    end
end

function SceneCanceled()
    printdebug("========SCENE CANCELLED - CALLING ENTITY: " .. findIndex(owninginstance.id))
end

function PlayNextSceneInternal(inst)
    inst = inst or nil

    local i = 0
	local tmp = 0

    -- SendToConsole( "snd_ducktovolume 0.55" )

    -- Are there any "fire at the end" triggers associated with the just completed?
    if inst.waitVcdCurrent ~= nil then
        if SceneTable[inst.waitVcdCurrent]["fires"] then
            for _, val in ipairs(SceneTable[inst.waitVcdCurrent].fires) do
                if not val.fireatstart then
                    printdebug(">>>>>>ENT FIRE AT END: " .. val.entity .. ":" .. val.input)
					EntFire(val.entity,val.input,val.parameter,val.delay)
                end
            end
        end
    end

    -- If the vcd that's ending is part of a nag cycle, check to see if there are any queued
    -- scenes for the primary nag character. If so, abandon the nag and start the queued scene.
    if inst.isNag then
        if QueueLen(inst.currentCharacter)>0 then
            printdebug("========ABANDONING NAG CYCLE TO PLAY QUEUED SCENE")
			scenequeue_DeleteScene(inst.index)
			QueueCheck()
			return
        end
    end

    -- Is there another vcd in the scene chain?
    if inst.waitNext ~= nil then
        printdebug("=====There is a next scene: " .. inst.waitNext)

        if inst.waitLength == nil then
            i = i + 1
            printdebug("===================Ready to play:" .. i)
            GladosPlayVcd(inst)
        else
            inst.waitStartTime = CurTime()
			inst.waiting = 1
        end
    else
        printdebug("=====No next scene!")
        -- Remove the instance from the scene list
        scenequeue_DeleteScene(inst.index)
        -- The current scene is over. Check to see if there are any queued scenes.
        if QueueCheck() then
			return
        end
        -- Do the ding if nothing's queued and the previous scene requires a ding
        if not inst.waitNoDingOff then
            EntFireByHandle( sceneDingOff, "Start", "", 0.1 )
        end
    end
end

function OnPostSpawn()
    local i = 0

    -- assign a unique id to each scene entity
    for name, val in pairs(SceneTable) do
        i = i + 1
        val.vcd.id = i
        val.index = i
        printdebug('name: ' .. name .. ' ' .. tostring(val.vcd) .. ' has team now ' .. i)
    end
    
    -- Initialize the deferred scene queue
    QueueInitialize()
    PuzzlePreStart()

    if curMapName == "sp_a1_wakeup" then
        EntFire("@glados","runscriptcode","sp_a1_wakeup_start_map()",1.0)
    end
end

-------------------------------------------------------------------------------
-- Scenes List Functions START
-------------------------------------------------------------------------------

-- Define the scene metatable
Scene = {}
Scene.__index = Scene

-- Global scene function acts as a constructor
function scene(a, caller)
    -- Initialize a new instance of Scene
    local self = setmetatable({}, Scene)

    printdebug("Creating scene with index " .. a)
    
    -- Instance properties
    self.index = 0
    self.owner = nil
    self.currentCharacter = ""
    self.waitSceneStart = 0 -- 1 means we're waiting for the current vcd to finish so we can play the next vcd in the chain
    self.waiting = 0
    self.waitVcdCurrent = nil -- SceneTable index of last launched vcd
    self.waitStartTime = 0
    self.waitLength = 0
    self.waitNext = nil
    self.waitExitingEarly = false
    self.waitExitingEarlyStartTime = 0
    self.waitExitingEarlyThreshold = 0.00 -- How many seconds should the VCD play before moving on to the next one
    self.waitNoDingOff = false
    self.waitNoDingOn = false
    self.waitFires = {}
    self.waitVcdTeam = -1
    self.waitFiredVcds = {}
    self.isNag = false
    self.nags = {}
    self.nagpool = {}
    self.nagminsecs = 0
    self.nagmaxsecs = 0
    self.naglastfetched = nil
    self.nagrandom = false
    self.nagrandomonrepeat = false
    self.nagtimeslistcompleted = 0
    self.nagrepeat = false
    self.naginchain = false
    
    return self
end

-- Method to clear nags
function Scene:nagsClear()
    self.naglastfetched = nil
    self.nags = {}
end

-- Method to clear nag pool
function Scene:nagpoolClear()
    self.nagpool = {}
end

-- Method to add a fired VCD
function Scene:addFiredVcd(team)
    table.insert(self.waitFiredVcds, team)
end

-- Method to delete a fired VCD
function Scene:deleteFiredVcd(team)
    local fnd = nil
    for idx, val in pairs(self.waitFiredVcds) do
        if val == team then
            fnd = idx
            break
        end
    end
    
    if fnd then
        table.remove(self.waitFiredVcds, fnd)
    end
end

function issceneinstance(obj)
    return getmetatable(obj) == Scene
end

function scenequeue_AddScene(arg, char)
    local delme = nil

    for idx, val in pairs(scenequeue) do
        if SceneTable[idx].char == char then
            delme = idx
        end
        if idx == arg then
            printdebug(">>>>>>>>>>Scene " .. arg .. " is already in the queue")
            return nil
        end
    end

    if delme ~= nil then
        printdebug(">>>>>>>>>>DELETING SCENE " .. delme)
        scenequeue_DeleteScene(delme)
    end

    scenequeue[arg] = scene(arg, self)
    scenequeue_Dump()
    return scenequeue[arg]
end

function scenequeue_DeleteScene(arg)
    for idx, val in pairs(scenequeue) do
        if idx == arg then
            printdebug(">>>>>>>>>>Scene " .. arg .. " deleted!")
            scenequeue[arg] = nil
            return true
        end
    end
    return nil
end

function scenequeue_Dump()
    printdebug(">>>>>>>>>>Scene Dump at " .. CurTime())
    for idx, val in pairs(scenequeue) do
        printdebug(">>>>>>>>>>Scene " .. idx .. " ADDED at " .. val.waitStartTime .. " Type " .. type(val))
    end
end

-------------------------------------------------------------------------------
-- Scene Queue Functions END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Queue Functions
-------------------------------------------------------------------------------

Queue = {}

function QueueInitialize()
    Queue = {}
end

function QueueAdd(arg)
    table.insert(Queue, { item = arg, added = CurTime() })
    
    if SceneTable[arg] then
        if SceneTable[arg].queueforcesecs then
            Queue[#Queue].queueforcesecs = SceneTable[arg].queueforcesecs
        else
            Queue[#Queue].queueforcesecs = 45.0
        end

        if SceneTable[arg].queuetimeout then
            Queue[#Queue].queuetimeout = SceneTable[arg].queuetimeout
        end

        if SceneTable[arg].queuepredelay then
            Queue[#Queue].queuepredelay = SceneTable[arg].queuepredelay
        end
    end
end

function QueueLen(char)
    char = char or nil
    local i = 0

    if not char then
        return #Queue
    else
        for index, scene in ipairs(Queue) do
            if SceneTable[scene.item].char == char then
                i = i + 1
            end
        end
        return i
    end
end

function QueueGetNext()
    local ret = nil
    local l = QueueLen()
    
    if l > 0 then
        ret = Queue[l].item
        table.remove(Queue, l)
    end
    
    return ret
end

function QueueDebug()
    printdebug("===================  items in queue-> " .. #Queue)

    for index, scene in pairs(Queue) do
        printdebug("========= queue item " .. index .. "(" .. scene.item .. "): character " .. SceneTable[scene.item].char)
    end
end

function QueueThink()
    local ret,t,index

    if QueueLen() == 0 then
        return nil
    end

    t = CurTime()
    -- Check to see if any queued scenes timed out
    for index = #Queue, 1, -1 do
        if Queue[index].queuetimeout then
            if t - Queue[index].added > Queue[index].queuetimeout then
                table.remove(Queue, index)
            end
        end
    end

    -- Check to see if any queued scenes should force fire
    for index, scene in ipairs(Queue) do
        if scene.queueforcesecs then
            if t - scene.added > scene.queueforcesecs then
                ret = scene.item
                table.remove(Queue, index)
                return ret
            end
        end
    end

    return nil
end

function QueueCheck()
    local tmp
    if QueueLen()>0 then
        printdebug("===QUEUE LEN IS " .. QueueLen())
        tmp=QueueGetNext()

        if tmp ~= nil then
			firedfromqueue = true
			GladosPlayVcd(tmp,true)
			--GladosPlayVcd(tmp)
			return true
        end
    end

    return false
end

-------------------------------------------------------------------------------
-- Nag Table functions
-------------------------------------------------------------------------------

function nags_init(inst, scenetableentry)
    local i = 0
    inst:nagsClear()

    if SceneTable[scenetableentry]["idleminsecs"] then
        inst.nagminsecs = SceneTable[scenetableentry].idleminsecs

        if SceneTable[scenetableentry]["idlemaxsecs"] then
            inst.nagmaxsecs = SceneTable[scenetableentry].idlemaxsecs
        else
            inst.nagmaxsecs = inst.nagminsecs
        end
    end

    if SceneTable[scenetableentry]["idlerandomonrepeat"] then
        inst.nagrandomonrepeat = true
    end

    if SceneTable[scenetableentry]["idlerepeat"] then
        inst.nagrepeat = true
    end

    if SceneTable[scenetableentry]["idlerandom"] then
        inst.nagrandom = true
    end

    local igroup = SceneTable[scenetableentry].idlegroup
    for idx, val in pairs(SceneTable) do
        if not val["idlegroup"] then
            continue
        end

        if val.idlegroup ~= igroup then
            continue
        end

        local rar = 101
        local mnum = 0
        if val["idlerarity"] then
            rar = val.idlerarity
        end

        if val["idlemaxplays"] then
            mnum = val.idlemaxplays
        end

        -- Skip vcds that are part of a chain (and not the first link in the chain)
        if val["idleunder"] then
            continue
        end

        if val["idleorderingroup"] then
            oig=val.idleorderingroup
        else
            oig=0
        end
        table.insert(inst.nags, {SceneTableIndex=idx, rarity = rar, maxplays = mnum, totplays = 0,orderingroup = oig})
    end

    table.sort(inst.nags, nag_array_compare)
    inst.isNag = true
    inst.nagtimeslistcompleted = 0
    nags_createpool(inst)
end

function nags_createpool(inst)
    inst:nagpoolClear()
    local takeit = false
	local tempa = {}

    for idx, val in pairs(inst.nags) do
        takeit = false

        if val.totplays >= val.maxplays and val.maxplays>0 then
            continue
        end

        if math.random(1, 100) < val.rarity then
            takeit = true
        end

        if takeit then
            table.insert(tempa, val)
        end
    end

    local r
    -- The pool can still be empty at this point if only rare lines were available and none of them "made their roll".
    if #tempa == 0 then
        return
    end

    if inst.nagrandom or (inst.nagrandomonrepeat and inst.nagtimeslistcompleted > 0) then
        -- Make sure the first entry in the new list isn't the same as the last vcd played.
		-- This ensures no repeats.
        if #tempa > 1 and inst.naglastfetched ~= nil then
            while true do
                r = math.random(1, #tempa)
                
                if tempa[r].SceneTableIndex ~= inst.naglastfetched then
                    table.insert(inst.nagpool, tempa[r])
                    table.remove(tempa, r)
                    break
                end
            end
        end
    
        -- Populate the rest of the pool
        while #tempa > 0 do
            r = math.random(1, #tempa)
            table.insert(inst.nagpool, tempa[r])
            table.remove(tempa, r)
        end
    else
        for idx, val in pairs(tempa) do
            table.insert(inst.nagpool, val)
        end
    end
end

function nags_nagpooldump(inst)
    for idx, val in pairs(inst.nagpool) do
        printdebug("*********NAG " .. idx .. " : " .. val.SceneTableIndex)
    end
end

function nags_fetch(inst)
    if #inst.nagpool == 0 then
        if inst.nagrepeat then
            inst.nagtimeslistcompleted = inst.nagtimeslistcompleted + 1
			nags_createpool(inst)
			if #inst.nagpool == 0 then
				return nil
            end
        else
            return nil
        end
    end

	local ret = inst.nagpool[1].SceneTableIndex
    for idx, val in pairs(inst.nags) do
        if val.SceneTableIndex == ret then
            val.totplays = val.totplays + 1
			break
        end
    end
	--nags_nagpooldump(inst)
	table.remove(inst.nagpool, 1)
	inst.naglastfetched = ret
	return ret    
end

local function StopNag(name, arg)
    arg = arg or 0
    nag_stop(name, arg)
end

function GladosStopNag(arg)
    StopNag("glados", arg)
end

function WheatleyStopNag(arg)
    StopNag("wheatley", arg)
end

function Core01StopNag(arg)
    StopNag("core01", arg)
end

function Core02StopNag(arg)
    StopNag("core02", arg)
end

function Core03StopNag(arg)
    StopNag("core03", arg)
end

function nag_stop(char, stoptype)
    local todel = nil
    for idx, val in pairs(scenequeue) do
        if val.isNag and val.currentCharacter == char then
            todel=idx
			break
        end
    end

    if todel ~= nil then
        scenequeue_DeleteScene(todel)
    end
end

function nag_array_compare(a, b)
    if a.orderingroup > b.orderingroup then
        return false
    elseif a.orderingroup < b.orderingroup then
        return true
    else
        return false
    end
end

-------------------------------------------------------------------------------
-- Nag Table functions end
-------------------------------------------------------------------------------