-- Rewritten choreo/glados_scenetable_include_manual.nut script

-- ============================================================================
-- SP_A1_INTRO1 (container ride scene)
-- ============================================================================
if curMapName=="sp_a1_intro1" then
	sp_a1_intro1_vault_started = false
	sp_a1_intro_cognitive_gauntlet_said = false
	sp_a1_intro1_door_opened = false

	--Hello?
	SceneTable["-600_01"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHello01.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 0.0,
		next = "-600_02",
		noDingOff = true,
		noDingOn = true,
		fires=
		{
			{entity="container_door_knock_2_relay",input="trigger",parameter="",delay=0.0}
		}		
	}
	
    --Helloooo? 
	SceneTable["-600_02"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHello12.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 1.0,
		next = "-600_03",
		noDingOff = true,
		noDingOn = true,
	}
	--Are you going to open the door? At any time?
	SceneTable["-600_03"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHello13.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 1.0,
		next = "-600_05",
		noDingOff = true,
		noDingOn = true,
	}
	--Hello? Can y--no?
	SceneTable["-600_05"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHello15.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 1.0,
		next = "-600_07",
		noDingOff = true,
		noDingOn = true,
	}
	--Are you going to open this door? Because it's fairly urgent.
	SceneTable["-600_07"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHello17.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 1.0,
		next = "-600_08",
		noDingOff = true,
		noDingOn = true,
	}
	--Oh, just open the door! [to self] That's too aggressive. [loud again] Hello, friend! Why not open the door?
	SceneTable["-600_08"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHello18.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 1.0,
		next = "-600_09",
		noDingOff = true,
		noDingOn = true,
	}
	--[to self] Hm. Could be Spanish, could be Spanish. [loud again] Hola, amigo! Abre la puerta! Donde esta--no. Um...
	SceneTable["-600_09"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHello19.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 1.0,
		next = "-600_11",
		noDingOff = true,
		noDingOn = true,
	}
	--Fine! No, absolutely fine. It's not like I don't have, you know, ten thousand other test subjects begging me to help them escape. You know, it's not like this place is about to EXPLODE.
	SceneTable["-600_11"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHello21.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 1.0,
		next = "-600_12",
		noDingOff = true,
		noDingOn = true,
		fires=
		{
			{entity="container_door_knock_3_relay",input="trigger",parameter="",delay=1.0}
		}
	}
	--Alright, look, okay, I'll be honest. You're the LAST test subject left. And if you DON'T help me, we're both going to die. Alright? I didn't want to say it, you dragged it out of me. Alright? Dead. Dos Muerte.
	SceneTable["-600_12"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHello22.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 2.0,
		next = nil,
		noDingOff = true,
		noDingOn = true,
		fires=
		{
			{entity="@glados",input="RunScriptCode",parameter="sp_a1_intro1_open_door_nags()",delay=1.0}
		}
	}
	
	----------------------------------------------/
	----------------------------------------------/
	
	--Hello!
	SceneTable["-601_01"] =
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHelloNag01.vcd"),
		postdelay=0.1,
		next=nil,
		char="wheatley",
		noDingOff=true,
		noDingOn=true,
		idle=true,
		idlerandom=true,
		idlerepeat=true,
		idleminsecs=1.00,
		idlemaxsecs=2.600,
		idlegroup="sp_a1_intro1_open_door_nag",
		idleorderingroup=1
	}	
	--Helloooooooooooo!
	SceneTable["-601_02"] =
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHelloNag02.vcd"),
		postdelay=0.1,
		next=nil,
		char="wheatley",
		noDingOff=true,
		noDingOn=true,
		idlegroup="sp_a1_intro1_open_door_nag",
		idleorderingroup=2
	}
	--Come on!
	SceneTable["-601_03"] =
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHelloNag03.vcd"),
		postdelay=0.1,
		next=nil,
		char="wheatley",
		noDingOff=true,
		noDingOn=true,
		idlegroup="sp_a1_intro1_open_door_nag",
		idleorderingroup=3
	}
	--Open the door!
	SceneTable["-601_04"] =
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHelloNag04.vcd"),
		postdelay=0.1,
		next=nil,
		char="wheatley",
		noDingOff=true,
		noDingOn=true,
		idlegroup="sp_a1_intro1_open_door_nag",
		idleorderingroup=4
	}
	--Hello!
	SceneTable["-601_05"] =
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningHelloNag05.vcd"),
		postdelay=0.1,
		next=nil,
		char="wheatley",
		noDingOff=true,
		noDingOn=true,
		idlegroup="sp_a1_intro1_open_door_nag",
		idleorderingroup=5
	}
	
	----------------------------------------------/
	----------------------------------------------/

	--YES! I KNEW someone was alive in here!
	SceneTable["-602_01"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/intro_ride01.vcd"),
		char="wheatley",
		postdelay = -0.4,
		predelay = 0.0,
		next = "-602_02",
		noDingOff = true,
		noDingOn = true,
		fires=
		{
--			{entity="are_you_alright_vcd",input="Start",parameter="",delay=0.6},
			{entity="spherebot_train_1_chassis_1",input="MoveToPathNode",parameter="spherebot_path_inside_hallway",delay=3.5},
			{entity="@rl_container_ride_wheatley_enter",input="Trigger",parameter="",delay=3.5},
		}
	}
	
	--AGH! You look TERRIB--you look good. Looking good, actually. If I'm honest.
	SceneTable["-602_02"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/intro_ride02.vcd"),
		char="wheatley",
		postdelay = 0.0,
		predelay = 0.0,
		next = "-602_04",
		noDingOff = true,
		noDingOn = true,
		talkover=true,
	}
	
	--there's PLENTY of time to recover. Just take it slow.
	SceneTable["-602_04"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/intro_ride03.vcd"),
		char="wheatley",
		postdelay = 2.05,
		predelay = 0.0,
		next = "-602_06",
		talkover=true,
		noDingOff = true,
		noDingOn = true,
		fires=
		{
			{entity="@glados",input="runscriptcode",parameter="sp_a1_intro1_prepare()",delay=5.95,fireatstart=true},
			{entity="@sphere",input="setidlesequence",parameter="sphere_glance_up_concerned",delay=0.0},
		}
	}
	
	--please prepare for emergency evacuation [UPGRADED]
	SceneTable["-608_01"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/announcer/evacuationmisc01.vcd"),
		char="announcerglados",
		postdelay = 0.0,
		predelay = 0.0,
		next = nil,
		noDingOff = true,
		noDingOn = true,
		talkover=true,
	}
	

	--Don't panic! Prepare. That's all they're saying. I'm going to get us out of here.
	SceneTable["-602_06"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/intro_ride04.vcd"),
		char="wheatley",
		postdelay = 0.2,
		predelay = 0.0,
		next = "-602_07",
		noDingOff = true,
		noDingOn = true,
		talkover = true,
		fires=
		{
			{entity="@rl_container_ride_wheatley_to_hatch",input="trigger",parameter="",delay=0.0,fireatstart=true},
			{entity="@sphere",input="setidlesequence",parameter="",delay=0.0},
		}
	}
	
	SceneTable["-602_07"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningPrepare04.vcd"),
		char="wheatley",
		postdelay = 0.0,
		predelay = 0.0,
		next = nil,
		noDingOff = true,
		noDingOn = true,
		fires=
		{
			{entity="@start_container_engine_rl",input="trigger",parameter="",delay=2.0,fireatstart=true},
		}
	}

	----------------------------------------------/
	----------------------------------------------/

	--Simple word. 'Apple'.
	SceneTable["-603_01"] =
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningBrainDamageAppleNag01.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 4.5,
		next = "-603_02",
		noDingOff = true,
		noDingOn = true,
--		queue = true
--		queuetimeout = 10
	}
	--Just say 'Apple'. Classic. Very simple.
	SceneTable["-603_02"] =
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningBrainDamageAppleNag02.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 1.0,
		next = "-603_03",
	}
	--Ay. Double Pee-Ell-Ee.
	SceneTable["-603_03"] =
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningBrainDamageAppleNag03.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 1.0,
		next = "-603_04",
	}
	--Just say 'Apple'. Easy word, isn't it? 'Apple'.
	SceneTable["-603_04"] =
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningBrainDamageAppleNag04.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 1.0,
		next = "-603_05",
	}
	--How would you use it in a sentence? "Mmm, this apple's crunchy," you might say. And I'm not even asking you for the whole sentence. Just the word 'Apple'.
	SceneTable["-603_05"] =
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningBrainDamageAppleNag05.vcd"),
		char="wheatley",
		postdelay=0.0,
		predelay = 1.0,
		next = nil,
		fires=
		{
			{entity="sphere_player_has_pressed_space_second",input="Trigger",parameter="",delay=1.5},
		}
	}
	
		----------------------------------------------/
	----------------------------------------------/
	
	-- Let me explain. Most test subjects do experience some cognitive deterioration after a few months in suspension.
	SceneTable["-607_01"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningBrainDamage01.vcd"),
		char="wheatley",
		postdelay = 0.0,
		predelay = 0.0,
		next = "-607_02",
		noDingOff = true,
		noDingOn = true,
		queue = true,
		queuetimeout = 10,
	}

	--Straight away you're thinking, "Oo, that doesn't sound good. But don't be alarmed, alright? Because ah... well, actually, if you DO feel alarmed, hold onto that.
	SceneTable["-607_02"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/intro_ride07.wav"),
		char="wheatley",
		postdelay = 0.0,
		predelay = 0.0,
		next = "-607_03",
	}
	
	--Do you understand what I'm saying? Does any of this make sense? Just tell me 'Yes'.
	SceneTable["-607_03"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/intro_ride08.vcd"),
		char="wheatley",
		postdelay = 0.0,
		predelay = 0.0,
		next = nil,
		fires=
		{
			{entity="hint_press_spacebar_to_talk",input="ShowHint",parameter="",delay=0.0},
			{entity="sphere_player_has_pressed_space_first",input="Enable",parameter="",delay=0.0},
		}
	}
	
	----------------------------------------------/
	----------------------------------------------/

	--Okay, you know what? That's close enough. Just hold tight.
	SceneTable["-604_01"] = 
	{
		vcd=CreateSceneEntity("scenes/npc/sphere03/OpeningCloseEnough01.vcd"),
		char="wheatley",
		postdelay = 0.0,
		predelay = 0.0,
		next = nil,
		noDingOff = true,
		noDingOn = true,
		fires=
		{
			{entity="core_meltdown_rl",input="Trigger",parameter="",delay=0.0},
		}
	}
end

-- ****************************************************************************************************
-- SP_A1_INTRO1 scenetable			  
-- ****************************************************************************************************

SceneTableLookup[-600] = "-600_01" -- start of the open the door string of dialog

SceneTableLookup[-601] = "-601_01" -- Nags if player waited through the entire opening sequence

SceneTableLookup[-602] = "-602_01" -- First Sequence when door is opened

SceneTableLookup[-603] = "-603_01" -- Nag telling the player to say apple

SceneTableLookup[-604] = "-604_01" -- Jumping is close enough to saying apple

SceneTableLookup[-605] = "-605_01" -- First Impact with the wall above dock

SceneTableLookup[-606] = "-606_01" -- When the container first starts it's ride

SceneTableLookup[-607] = "-607_01" -- When wheatley re-enters and lets the player know that they have brain damage

SceneTableLookup[-608] = "-608_01" -- Announce interruption - PREPARE FOR EMERGENCY EVACUATION

function sp_a1_intro1_open_door_sequence()
	GladosPlayVcd( -600 )
end

function sp_a1_intro1_open_door_nags() 
    if not sp_a1_intro1_door_opened then
        GladosPlayVcd( -601 )
    end
end

function sp_a1_intro1_knew_someone_alive()
    --GladosCharacterStopScene("wheatley")
    GladosPlayVcd( -602 )
end

function sp_a1_intro1_prepare()
    GladosPlayVcd(-608)
end

function sp_a1_intro1_explain_brain_damage()
	GladosPlayVcd(-607)
end

-- First jump as you head toward the relaxation vault
function sp_a1_intro_thats_the_spirit()
	if not sp_a1_intro1_vault_started then
		if sp_a1_intro_cognitive_gauntlet_said then
			nuke()
			GladosPlayVcd(360)
		end
	end
end

function sp_a1_intro1_say_apple_nag()
	GladosPlayVcd( -603 )
end

function sp_a1_intro1_jumping_close_enough()
	GladosCharacterStopScene("wheatley")
	GladosPlayVcd( -604 )
end

-- After final wall hit. Wheatley tells you to go test.
function sp_a1_intro_cognitive_gauntlet()
	GladosPlayVcd(359)
end
	
function sp_a1_intro_cognitive_gauntlet_over()
	sp_a1_intro_cognitive_gauntlet_said = true
end

//good luck! as you fall into the vault
function sp_a1_intro_good_luck()
	GladosPlayVcd(361)
end

// sp_a1_intro7
if curMapName == "sp_a1_intro7" then
	sp_a1_intro7_popped = false
	sp_a1_intro7_camethrough = false
	sp_a1_intro7_pickedup = false
	sp_a1_intro7_pickedupcount= 0
	sp_a1_intro7_pluggedin = false
	sp_a1_intro7_turnedaway = false
	sp_a1_intro7_sayingnotdead = false
	sp_a1_intro7_saidnotdead = false
end

function sp_a1_intro7_HeyUpHere()
	GladosPlayVcd(466)
end

function sp_a1_intro7_YouFoundIt()
	EntFire("spherebot_train_1_chassis_1","MoveToPathNode","spherebot_train_1_path_11",8.5)
	GladosPlayVcd(467)
end

function sp_a1_intro7_PopPortal()
	if not sp_a1_intro7_popped then
		GladosPlayVcd(469)
	end
end

function sp_a1_intro7_PopPortalNag()
	if not sp_a1_intro7_popped then
		GladosPlayVcd(468)
	end
end

function sp_a1_intro7_ComeThroughNag()
	if not sp_a1_intro7_camethrough then
		GladosPlayVcd(470)
	end
end

function sp_a1_intro7_PoppedAPortal()
	EntFire("portal_detector","Disable","",0.0)
	EntFire("@glados","runscriptcode","sp_a1_intro7_ComeThroughNag()",4.0)
	WheatleyStopNag()
	sp_a1_intro7_popped = true
end

function sp_a1_intro7_JumpToOtherSide()
	WheatleyStopNag()
	sp_a1_intro7_camethrough = true
end

function sp_a1_intro7_ManagementRail()
	--WheatleyStopNag()
	GladosPlayVcd(471)
end

function sp_a1_intro7_OnThree()
	GladosPlayVcd(472)
end

function sp_a1_intro7_Impact()
	GladosPlayVcd(473)
end

function sp_a1_intro7_NotDeadStart()
	sp_a1_intro7_sayingnotdead = true
end

function sp_a1_intro7_NotDeadEnd()
	sp_a1_intro7_sayingnotdead = false
	sp_a1_intro7_saidnotdead = true

	if sp_a1_intro7_pickedup then
		nuke()
		GladosPlayVcd(572)
	end
end

function sp_a1_intro7_PickMeUpNag()
	if not sp_a1_intro7_pickedup then
		GladosPlayVcd(474)
	end
end

function sp_a1_intro7_PickUp()
	sp_a1_intro7_pickedup = true

	if sp_a1_intro7_pickedupcount == 0 then
		sp_a1_intro7_pickedupcount = sp_a1_intro7_pickedupcount + 1
		-- before the "I'm not dead!" line has started playing

		if not sp_a1_intro7_sayingnotdead and not sp_a1_intro7_saidnotdead then
			nuke()
			GladosPlayVcd(571)
		else
			if not (not sp_a1_intro7_saidnotdead and sp_a1_intro7_sayingnotdead) then
				WheatleyStopNag()
				GladosPlayVcd(475)
			end
		end
	else
		sp_a1_intro7_pickedupcount = sp_a1_intro7_pickedupcount + 1
		nuke()
		GladosPlayVcd(577)
	end
end

function sp_a1_intro7_PlugMeInNag()
	if not sp_a1_intro7_pluggedin then
		GladosPlayVcd(476)
	end
end

function sp_a1_intro7_NoWatching()
	sp_a1_intro7_pluggedin = true
	WheatleyStopNag()
	GladosPlayVcd(477)
end

function sp_a1_intro7_NoWatchingNag()
	if not sp_a1_intro7_turnedaway then
		GladosPlayVcd(481)
	end
end

function sp_a1_intro7_TurnAroundNow()
	sp_a1_intro7_turnedaway = true
	WheatleyStopNag()
	GladosPlayVcd(478)
end

function sp_a1_intro7_BamSecretPanel()
	sp_a1_intro7_turnedaway = true
	WheatleyStopNag()
	GladosPlayVcd(479)
end

function sp_a1_intro7_GloriousFreedom()
	GladosPlayVcd(480)
end

function sp_a1_intro7_DontLeaveMeNag()
end

// sp_a1_wakeup

if curMapName == "sp_a1_wakeup" then
	sp_a1_wakeup_gantryexpositionover = false
	sp_a1_wakeup_gantryexpositioncounter = 0
	sp_a1_wakeup_humanexpositionover = false
	sp_a1_wakeup_In_Breaker_Room = false
	sp_a1_wakeup_Looked_Down = false
end

function sp_a1_wakeup_start_map()
	GladosPlayVcd(482)
end

function sp_a1_wakeup_gantry_exposition_end()
	sp_a1_wakeup_gantryexpositionover = true
end

function sp_a1_wakeup_inside_observation()
	if sp_a1_wakeup_gantryexpositionover then
		if sp_a1_wakeup_gantryexpositioncounter == 0 then
			sp_a1_wakeup_gantryexpositioncounter = sp_a1_wakeup_gantryexpositioncounter + 1
			GladosPlayVcd(483)
		elseif sp_a1_wakeup_gantryexpositioncounter == 1 then
			sp_a1_wakeup_gantryexpositioncounter = sp_a1_wakeup_gantryexpositioncounter + 1
			GladosPlayVcd(484)
		elseif sp_a1_wakeup_gantryexpositioncounter == 2 then
			sp_a1_wakeup_gantryexpositioncounter = sp_a1_wakeup_gantryexpositioncounter + 1
			GladosPlayVcd(485)
		elseif sp_a1_wakeup_gantryexpositioncounter == 3 then
			sp_a1_wakeup_gantryexpositioncounter = sp_a1_wakeup_gantryexpositioncounter + 1
			GladosPlayVcd(486)
		end
	end
end

function sp_a1_wakeup_gantry_door_open()
	GladosPlayVcd(487)
end

function sp_a1_wakeup_there_she_is()
	GladosPlayVcd(488)
end

function sp_a1_wakeup_human_exposition_end()
	sp_a1_wakeup_gantryexpositionend = true
end

function sp_a1_wakeup_down_the_stairs()
	GladosPlayVcd(489)
end

function sp_a1_wakeup_JumpNags()
	GladosPlayVcd(581)
end

function sp_a1_wakeup_Falling()
	nuke()
	GladosPlayVcd(579)
end

function sp_a1_wakeup_Landed()
	GladosPlayVcd(580)
end

function sp_a1_wakeup_come_through_here()
	if sp_a1_wakeup_Looked_Down then
		GladosPlayVcd(586)
	end
end

function sp_a1_wakeup_Do_Not_Look_Down()
	GladosPlayVcd(491)
end

function sp_a1_wakeup_Do_Not_Look_Down_Over()
	sp_a1_wakeup_Looked_Down = true
	EntFire("@ComeThroughHereTrigger","enable","",0.2)
end

function sp_a1_wakeup_This_Is_Breaker_Room()
	GladosPlayVcd(492)
end

function sp_a1_wakeup_Lets_Go_In()
	if (notsp_a1_wakeup_In_Breaker_Room) then
		GladosPlayVcd(585)
	end
end

function sp_a1_wakeup_Do_Not_Touch()
	sp_a1_wakeup_In_Breaker_Room = true
	GladosPlayVcd(493)
end

function sp_a1_wakeup_Lights_On()
	GladosPlayVcd(494)
end

function sp_a1_wakeup_Oops()
	GladosPlayVcd(542)
end

function sp_a1_wakeup_ElevatorBreakerRideFinished()
	GladosPlayVcd(589)
end

function sp_a1_wakeup_playbuzzer()
	self:EmitSound("World.HackBuzzer")
end

function sp_a1_wakeup_WheatleyGettingGrabbed()
	EntFire("lcs_wheatley_sphere_crush","Start", "", 0)
end

function sp_a1_wakeup_transport()
end