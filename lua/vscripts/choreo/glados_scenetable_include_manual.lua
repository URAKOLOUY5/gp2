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

--good luck! as you fall into the vault
function sp_a1_intro_good_luck()
	GladosPlayVcd(361)
end

-- sp_a1_intro7
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

-- ****************************************************************************************************
-- sp_a1_wakeup scenetable			  
-- ****************************************************************************************************

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

-- ****************************************************************************************************
-- sp_a2_trust_fling scenetable
-- ****************************************************************************************************

if (curMapName == "sp_a2_trust_fling") then
	SceneTable["-300_01"] = {
		vcd = CreateSceneEntity("scenes/npc/glados/sp_a2_trust_fling01.vcd"), -- Oh, sorry. Some of these test chambers haven't been cleaned in ages.
		char = "glados",
		postdelay = 0.0,
		predelay = 1.0,
		next = "-301_01",
		noDingOff = true,
		noDingOn = true
	}

	SceneTable["-301_01"] = {
		vcd = CreateSceneEntity("scenes/npc/glados/sp_a2_trust_fling02.vcd"), -- So sometimes there's still trash in them. Standing around. Smelling, and being useless.
		char = "glados",
		postdelay = 0.0,
		predelay = 0.0,
		next = "-302_01",
		noDingOff = true,
		noDingOn = true
	}


	-- triggered when second box hits the ground
	SceneTable["-302_01"] = {
		vcd = CreateSceneEntity("scenes/npc/glados/sp_a2_trust_fling03.vcd"), -- Try to avoid the garbage hurtling towards you.
		char = "glados",
		postdelay = 0.0,
		predelay = 0.5,
		next = nil,
		noDingOff = true,
		noDingOn = true,
		fires = {
		{ entity = "garbage_pickup_relay", input = "enable", parameter = "", delay = 0.5 }
		}
	}


	-- triggered when player picks up the second box
	SceneTable["-303_01"] = {
		vcd = CreateSceneEntity("scenes/npc/glados/sp_a2_trust_fling04.vcd"), -- Don't TEST with the garbage. It's garbage.
		char = "glados",
		postdelay = 0.0,
		predelay = 0.0,
		next = nil,
		noDingOff = true,
		noDingOn = true,
		fires = {
		{ entity = "button_press_dialog_relay", input = "trigger", parameter = "", delay = 0.5 }
		}
	}

	SceneTable["-304_01"] = {
		vcd = CreateSceneEntity("scenes/npc/glados/faithplategarbage06.vcd"), -- Press the button again.
		char = "glados",
		postdelay = 0.0,
		predelay = 0.0,
		next = nil,
		noDingOff = true,
		noDingOn = true
	}
end

SceneTableLookup[-300] = "-300_01"-- Oh, sorry. Some of these test chambers haven't been cleaned in ages.

SceneTableLookup[-301] = "-301_01"-- So sometimes there's still trash in them. Standing around. Smelling, and being useless.

SceneTableLookup[-302] = "-302_01"-- Try to avoid the garbage hurtling towards you.

SceneTableLookup[-303] = "-303_01"-- Don't TEST with the garbage. It's garbage.

SceneTableLookup[-304] = "-304_01"-- Press the button again.

function sp_a2_trust_fling_garbage_spawn()
	GladosPlayVcd( -300 )
end

function sp_a2_trust_fling_garbage_pickup()
	GladosPlayVcd( -303 )
end

function sp_a2_trust_fling_button_press_reminder()
	GladosPlayVcd( -304 )
end

function sp_a2_trust_fling_elevator_stop()
	GladosPlayVcd(465)
end

-- ****************************************************************************************************
-- sp_a2_pit_flings scenetable
-- ****************************************************************************************************

if curMapName == "sp_a2_pit_flings" then
    -- triggered when player picks up cube for the first time
    SceneTable["-200_01"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/fizzlecube01.vcd"), -- Oh. Did I accidentally fizzle that before you could complete the test? I'm sorry.
        char = "glados",
        postdelay = 1.0,
        predelay = 0.0,
        next = "-201_01",
        noDingOff = true,
        noDingOn = true
    }
    
    SceneTable["-201_01"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/fizzlecube03.vcd"), -- Go ahead and grab another one so that it won't also fizzle and you won't look stupid again.
        char = "glados",
        postdelay = 0.0,
        predelay = 0.0,
        next = null,
        noDingOff = true,
        noDingOn = true,
        fires = {
            {entity = "drop_new_box_relay", input = "trigger", parameter = "", delay = 1.0, fireatstart = true},
        }
    }
    
    -- triggered when player picks up the second box
    SceneTable["-203_01"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/fizzlecube05.vcd"), -- Oh. No. I fizzled that one too.
        char = "glados",
        postdelay = 0.0,
        predelay = 0.0,
        next = "-204_01",
        noDingOff = true,
        noDingOn = true,
        queue = true,
        fires = {
            {entity = "drop_new_box_relay", input = "trigger", parameter = "", delay = 0.0},
            {entity = "companion_cube_trigger", input = "kill", parameter = "", delay = 0.0, fireatstart = true},
        }
    }
    
    SceneTable["-204_01"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/fizzlecube06.vcd"), -- Oh well. We have warehouses FULL of the things. Absolutely worthless. I'm happy to get rid of them.
        char = "glados",
        postdelay = 0.0,
        predelay = 1.0,
        next = null,
        noDingOff = true,
        noDingOn = true
    }
    
    -- This line plays from the PuzzleCompleted call
    SceneTable["sp_a2_pit_flingsCubeSmuggleEnding01"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/sp_a2_pit_flings03.vcd"), -- Every test chamber is equiped with a fizzler. This one is broken.
        char = "glados",
        postdelay = 0.0,
        predelay = 0.0,
        next = "sp_a2_pit_flingsCubeSmuggleEnding02",
        noDingOff = true,
        noDingOn = true
    }
    
    SceneTable["sp_a2_pit_flingsCubeSmuggleEnding02"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/sp_a2_pit_flings02.vcd"), -- Don't take anything with you.
        char = "glados",
        postdelay = 0.0,
        predelay = 0.0,
        next = null,
        noDingOff = true,
        noDingOn = true,
        fires = {
            {entity = "smuggled_cube_fizzle_trigger", input = "enable", parameter = "", delay = 0.0},
            {entity = "glados_summon_elevator_relay", input = "trigger", parameter = "", delay = 0.5, fireatstart = true}
        }
    }

    -- called when smuggled cube fizzles
    SceneTable["-206_01"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/sp_a2_pit_flings06.vcd"), -- I think that one was about to say "I love you." They ARE sentient, of course. We just have a LOT of them.
        char = "glados",
        postdelay = 0.0,
        predelay = 2,
        next = null,
        noDingOff = true,
        noDingOn = true,
        fires = {{entity = "@transition_script", input = "runscriptcode", parameter = "TransitionReady()", delay = 0.0}}
    }
    
    -- Player got stuck, glados taunts then spawns another cube
    SceneTable["-207_01"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/fizzlecube02.vcd"), -- go ahead and grab another one
        char = "glados",
        postdelay = 0.0,
        predelay = 0.0,
        next = null,
        noDingOff = true,
        noDingOn = true,
        fires = {
            {entity = "drop_new_box_relay", input = "trigger", parameter = "", delay = 0.0}
        }
    }

	boxDissolveCount = 1
end

SceneTableLookup[-200] = "-200_01" -- Oh. Did I accidentally fizzle that before you could complete the test? I'm sorry.

SceneTableLookup[-201] = "-201_01" -- Go ahead and grab another one so that it won't also fizzle and you won't look stupid again.

SceneTableLookup[-202] = "-202_01" -- Go ahead. I PROMISE not to fizzle it this time.

SceneTableLookup[-203] = "-203_01" -- Oh. No. I fizzled that one too.

SceneTableLookup[-204] = "-204_01" -- Oh well. We have warehouses FULL of the things. Absolutely worthless. I'm happy to get rid of them.

SceneTableLookup[-205] = "-205_01" -- Go ahead. This time I promise you'll look incrementally less stupid than the previous two times in which you looked incredibly stupid.

SceneTableLookup[-206] = "-206_01" -- I think that one was about to say "I love you." They ARE sentient, of course. We just have a LOT of them.

SceneTableLookup[-207] = "-207_01" -- ** player got stuck dialog here

function sp_laser_lift_pit_flings_cube_lost()
	if boxDissolveCount == 1 then
		GladosPlayVcd( -200 )
	elseif boxDissolveCount == 2 then
		GladosPlayVcd( -203 )
	else
		print("====== Cube lost! spawning a new one...")
		EntFire( "drop_new_box_relay", "trigger", 0, 0, 0 )
	end

	boxDissolveCount = boxDissolveCount + 1
end

-- Called when sp_laser_lift_pit_flings companion cube is picked up
function sp_laser_lift_pit_flings_companion_cube_dissolved()
	print("***DISSOLVING cube_dropper_box!")

	-- spawn a new box whenever ready
	sp_laser_lift_pit_flings_cube_lost();
end

-- Called if player tries to smuggle cube out of level
function sp_a2_pit_flings_smuggled_cube_fizzle()
	GladosPlayVcd( -206 )
end

-- Triggered when the player gets into an unwinnable state
function sp_a2_pit_flings_player_stuck()
	GladosPlayVcd( -207 )
end

function sp_a2_fizzler_training_Have_To_Go()
	GladosPlayVcd(546)
end


-- ****************************************************************************************************
-- sp_a2_sphere_peek
-- ****************************************************************************************************

if curMapName == "sp_a2_sphere_peek" then
	peekctr = 0
end

function sp_catapult_fling_sphere_peek()
	if peekctr == 0 then
		GladosPlayVcd(335)
	elseif peekctr == 2 then
		GladosPlayVcd(362)
	elseif peekctr == 4 then
		GladosPlayVcd(363)
	end

	peekctr = peekctr + 1
end


-- ****************************************************************************************************
-- sp_a2_ricochet
-- ****************************************************************************************************
function RicochetFutureStarter()
	GladosPlayVcd(631)	
end

-- ****************************************************************************************************
-- sp_a2_bridge_intro
-- ****************************************************************************************************
function bridge_intro_door()
	GladosPlayVcd(236)
end


-- ****************************************************************************************************
-- SP_A2_BRIDGE_THE_GAP - BIRD!
-- ****************************************************************************************************

if curMapName == "sp_a2_bridge_the_gap" then
    -- Perfect, the door's malfunctioning. I guess somebody's going to have to repair that too. [beat] No, don't get up. I'll be right back. Don't touch anything.
    SceneTable["-500_00"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/sp_trust_fling_sphereinterrupt01.vcd"),
        postdelay = 0.000,
        next = nil,
        char = "glados",
        fires = {
            {entity = "start_wheatley_window_scene_relay", input = "trigger", parameter = "", delay = 3.0}
        },
        predelay = 0.2,
        queue = 1 
    }

    -- Hey! Hey! Up here!
    SceneTable["-500_01"] = {vcd = CreateSceneEntity("scenes/npc/sphere03/sp_trust_fling01.vcd"), postdelay = 0.2, next = "-500_02", char = "wheatley", noDingOff = true, noDingOn = true}

    -- I found some bird eggs up here. Just dropped 'em into the door mechanism.  Shut it right down. I--AGH!
    SceneTable["-500_02"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sp_trust_flingAlt07.vcd"),
        postdelay = 0.1,
        next = "-500_03",
        char = "wheatley",
        noDingOff = true,
        noDingOn = true,
        fires = {
            {entity = "bird_attack_start_relay", input = "Trigger", parameter = "", delay = 3.6, fireatstart = true},
        }
    }

    -- BIRD BIRD BIRD BIRD
    SceneTable["-500_03"] = {vcd = CreateSceneEntity("scenes/npc/sphere03/sp_trust_flingAlt02.vcd"), postdelay = 2.5, next = "-500_04", char = "wheatley", noDingOff = true, noDingOn = true}

    -- [out of breath] Okay. That's probably the bird, isn't it? That laid the eggs! Livid!
    SceneTable["-500_04"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sp_trust_flingAlt08.vcd"),
        postdelay = 0.4,
        next = "-500_05",
        char = "wheatley",
        noDingOff = true,
        noDingOn = true,
        fires = {
            {entity = "bird_attack_end_relay", input = "Trigger", parameter = "", delay = 0.0, fireatstart = true} 
        }
    }

    -- Okay, look, the point is, we're gonna break out of here! Very soon, I promise! 
    SceneTable["-500_05"] = {vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_bridge_the_gap_expo01.vcd"), postdelay = 0.1, next = "-500_06", char = "wheatley", noDingOff = true, noDingOn = true}

    -- I just have to figure out how.
    SceneTable["-500_06"] = {vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_bridge_the_gap_expo03.vcd"), postdelay = 0.4, next = "-500_07", char = "wheatley", noDingOff = true, noDingOn = true}

    -- Here she comes! Just keep testing! Remember, you never saw me!
    SceneTable["-500_07"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_bridge_the_gap_expo06.vcd"),
        postdelay = 1,
        next = nil,
        char = "wheatley",
        fires = {
            {entity = "trick_door_open_relay", input = "Trigger", parameter = "", delay = 3.3, fireatstart = true},
            {entity = "wheatley_depart_scene_relay", input = "Trigger", parameter = "", delay = 3, fireatstart = true}
        },
        noDingOff = true,
        noDingOn = true
    }
end

-- ****************************************************************************************************
-- sp_a2_bridge_the_gap scenetable
-- ****************************************************************************************************

if curMapName == "sp_a2_bridge_the_gap" then
    -- Perfect, the door's malfunctioning. I guess somebody's going to have to repair that too. [beat] No, don't get up. I'll be right back. Don't touch anything.
    SceneTable["-500_00"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/sp_trust_fling_sphereinterrupt01.vcd"),
        postdelay = 0.000,
        next = nil,
        char = "glados",
        fires = {
            {entity = "start_wheatley_window_scene_relay", input = "trigger", parameter = "", delay = 3.0}
        },
        predelay = 0.2,
        queue = 1 
    }

    -- Hey! Hey! Up here!
    SceneTable["-500_01"] = {vcd = CreateSceneEntity("scenes/npc/sphere03/sp_trust_fling01.vcd"), postdelay = 0.2, next = "-500_02", char = "wheatley", noDingOff = true, noDingOn = true}

    -- I found some bird eggs up here. Just dropped 'em into the door mechanism.  Shut it right down. I--AGH!
    SceneTable["-500_02"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sp_trust_flingAlt07.vcd"),
        postdelay = 0.1,
        next = "-500_03",
        char = "wheatley",
        noDingOff = true,
        noDingOn = true,
        fires = {
            {entity = "bird_attack_start_relay", input = "Trigger", parameter = "", delay = 3.6, fireatstart = true},
        }
    }

    -- BIRD BIRD BIRD BIRD
    SceneTable["-500_03"] = {vcd = CreateSceneEntity("scenes/npc/sphere03/sp_trust_flingAlt02.vcd"), postdelay = 2.5, next = "-500_04", char = "wheatley", noDingOff = true, noDingOn = true}

    -- [out of breath] Okay. That's probably the bird, isn't it? That laid the eggs! Livid!
    SceneTable["-500_04"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sp_trust_flingAlt08.vcd"),
        postdelay = 0.4,
        next = "-500_05",
        char = "wheatley",
        noDingOff = true,
        noDingOn = true,
        fires = {
            {entity = "bird_attack_end_relay", input = "Trigger", parameter = "", delay = 0.0, fireatstart = true} 
        }
    }

    -- Okay, look, the point is, we're gonna break out of here! Very soon, I promise! 
    SceneTable["-500_05"] = {vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_bridge_the_gap_expo01.vcd"), postdelay = 0.1, next = "-500_06", char = "wheatley", noDingOff = true, noDingOn = true}

    -- I just have to figure out how.
    SceneTable["-500_06"] = {vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_bridge_the_gap_expo03.vcd"), postdelay = 0.4, next = "-500_07", char = "wheatley", noDingOff = true, noDingOn = true}

    -- Here she comes! Just keep testing! Remember, you never saw me!
    SceneTable["-500_07"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_bridge_the_gap_expo06.vcd"),
        postdelay = 1,
        next = nil,
        char = "wheatley",
        fires = {
            {entity = "trick_door_open_relay", input = "Trigger", parameter = "", delay = 3.3, fireatstart = true},
            {entity = "wheatley_depart_scene_relay", input = "Trigger", parameter = "", delay = 3, fireatstart = true}
        },
        noDingOff = true,
        noDingOn = true
    }

	SceneTableLookup[-500] = "-500_00" 	-- Perfect, the door's malfunctioning. I guess somebody's going to have to repair that too. [beat] No, don't get up. I'll be right back. Don't touch anything.
	SceneTableLookup[-501] = "-500_01" 	-- /Hey! Hey! Up here!
										-- I found some bird eggs up here. Just dropped 'em into the door mechanism.  Shut it right down. I--AGH!					
										-- BIRD BIRD BIRD BIRD
										-- [out of breath] Okay. That's probably the bird, isn't it? That laid the eggs! Livid!
										-- Anyway, look, the point is we're gonna break out of here, alright? But we can't do it yet. Look for me fifteen chambers ahead.
										-- Here she comes! Just play along! RememberFifteenChambers!
end

-- Called when door malfunction begins
function sp_a2_bridge_the_gap_brokendoor_scene()
	GladosPlayVcd( -500 )
end

function sp_a2_bridge_the_gap_window_scene()
	GladosPlayVcd( -501 )
end

-- ****************************************************************************************************
-- sp_a2_column_blocker scenetable (birthday surprize)
-- ****************************************************************************************************
if curMapName == "sp_a2_column_blocker" then
    SceneTable["-400_01"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/testchambermisc34.vcd"), -- initiating surprise in 3...2...1.
        char = "glados",
        postdelay = 0.0,
        predelay = 0.0,
        next = "-401_01",
        noDingOff = true,
        noDingOn = true,
        fires = {
            {entity = "surprise_room_lights_on", input = "Trigger", parameter = "", delay = 0.2},
        }
    }
    
    SceneTable["-401_01"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/testchambermisc35.vcd"), -- i made it all up
        char = "glados",
        postdelay = 2.5,
        predelay = 2.0,
        next = "-402_01",
        noDingOff = true,
        noDingOn = true,
        fires = {
            {entity = "surprise_room_effects_relay", input = "Trigger", parameter = "", delay = 0.6},
            {entity = "surprise_room_party_horn_sound", input = "playsound", parameter = "", delay = 0.3}
        }
    }
    
    SceneTable["-402_01"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/testchambermisc41.vcd"), -- surprise.
        char = "glados",
        postdelay = 2.0,
        predelay = 0.0,
        next = "-403_01",
        noDingOff = true,
        noDingOn = true
    }
    
    SceneTable["-403_01"] = {
        vcd = CreateSceneEntity("scenes/npc/glados/sp_a2_column_blocker01.vcd"), -- your parents are probably dead. ...i doubt they'd want to see you.
        char = "glados",
        postdelay = 0.0,
        predelay = 0.0,
        next = nil,
        noDingOff = true,
        noDingOn = true,
        fires = {
            {entity = "surprise_room_door_relay", input = "trigger", parameter = "", delay = 1.5, fireatstart = true}
        }
    }

	SceneTableLookup[-400] = "-400_01"	-- Initiating surprise in 3... 2... 1.
										-- I made it all up
										-- Surprise
										-- Your parents are probably dead... Wouldn't want to see you.
end

function Wheatley_Elevator_Scene_Start()
	GladosPlayVcd(495)
end
	
function Wheatley_Elevator_Scene_Ow()
	GladosPlayVcd(496)
end
	
-- ****************************************************************************************************
-- sp_a2_bts1
-- ****************************************************************************************************

if curMapName == "sp_a2_bts1" then
    sp_a2_bts1_FakeEntered = false
end

function JailbreakGladosSomethingWrong()
    GladosPlayVcd(301)
end

function JailbreakWheatleyHeyLady()
    GladosPlayVcd(497)
end

function JailbreakICanHearYou()
    EntFire("@sphere", "SetIdleSequence", "sphere_damaged_glance_concerned", 0)
    GladosPlayVcd(498)
end

function JailbreakWheatleyCloseChamber()
    WheatleyStopNag()   
    GladosPlayVcd(500)
end

function WheatleyKeepMoving()
    -- WheatleyStopNag()        
    -- GladosPlayVcd(501)
end

function WheatleyGoGoGoNag()
    GladosPlayVcd(502)
end

function JailbreakLastTestIntro()
    WheatleyStopNag()   
    GladosPlayVcd(503)
end

function JailbreakLastChamberMain()
    WheatleyStopNag()   
    GladosPlayVcd(504)
end

function JailbreakLastTestDeer()
    sp_a2_bts1_FakeEntered = true
    WheatleyStopNag()   
    GladosPlayVcd(505)
end

function JailBreakHowStupid()
    if not sp_a2_bts1_FakeEntered then
        WheatleyStopNag()       
        GladosPlayVcd(506)
    end 
end

function JailbreakBridgeDisappear()
    WheatleyStopNag()   
    GladosPlayVcd(507)
end

function JailbreakLookOutTurrets()
    WheatleyStopNag()   
    GladosPlayVcd(508)
end

function JailBreak2Trapped()
    WheatleyStopNag()   
    GladosPlayVcd(573)
end

function JailBreak2Gunfire()
    GladosPlayVcd(574)
end

function bts2_wheatley_comeon_prompt()
    GladosPlayVcd(587)
end

function JailBreak2AlmostOut()
    GladosPlayVcd(575)
end

function JailBreak2BringingDown()
    GladosPlayVcd(576)
end

function JailbreakHurryHurry()
    WheatleyStopNag()   
    GladosPlayVcd(509)
end

function JailbreakGetInTheLift()
    WheatleyStopNag()   
    GladosPlayVcd(510)
end

function jailbreak_player_in_exit_elevator()
    WheatleyStopNag()   
    GladosPlayVcd(511)
end

function Jailbreak2ThisWay()
    WheatleyStopNag()   
    GladosPlayVcd(512)
end

function JailbreakGoGo()
    WheatleyStopNag()   
    GladosPlayVcd(513)
end

function JailbreakComeOnComeOn()
    WheatleyStopNag()   
    GladosPlayVcd(514)
end

-- ****************************************************************************************************
-- sp_a2_bts3
-- ****************************************************************************************************

if curMapName == "sp_a2_bts3" then
    -- ====================================== Ghost Story scene
    
    SceneTable["-2500_01"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sphere_flashlight_tour07.vcd"), -- Ooh.  Dark down here, isn't it.
        char = "wheatley",
        postdelay = 0.0,
        predelay = 0.0,
        next = "-2500_02",
        noDingOff = true,
        noDingOn = true
    }
    
    SceneTable["-2500_02"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sphere_flashlight_tour57.vcd"), -- They say that the old caretaker of this place...
        char = "wheatley",
        postdelay = 0.0,
        predelay = 1.0,
        next = nil,
        noDingOff = true,
        noDingOn = true
    }   
    
    -- ====================================== Smelly Humans scene
    SceneTable["-2503_01"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sphere_flashlight_tour58.vcd"), -- Here's an interesting story.. (smelly humans story)
        char = "wheatley",
        postdelay = 0.0,
        predelay = 0.0,
        next = "-2503_02",
        noDingOff = true,
        noDingOn = true
    }
    
    SceneTable["-2503_02"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sphere_flashlight_tour59.vcd"), -- the um.. sorry, that's.. just tending to the humans.
        char = "wheatley",
        postdelay = 0.0,
        predelay = 0.0,
        next = "-2503_03",
        noDingOff = true,
        noDingOn = true
    }
    
    SceneTable["-2503_03"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sphere_flashlight_tour60.vcd"), -- Sorry about that.  That just slipped out.
        char = "wheatley",
        postdelay = 0.0,
        predelay = 0.0,
        next = nil,
        noDingOff = true,
        noDingOn = true
    }
    
    SceneTable["-2504_01"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sphere_flashlight_tour62.vcd"), -- Ahh. Humans!  Love 'em!
        char = "wheatley",
        postdelay = 0.0,
        predelay = 0.0,
        next = nil,
        noDingOff = true,
        noDingOn = true
    }

	SceneTableLookup[-2500] = "-2500_01" // OOh.  Dark down here, isn't it. (ghost story)
	SceneTableLookup[-2503] = "-2503_01" // (smelly humans)
	SceneTableLookup[-2504] = "-2504_01" // humans, love 'em!
end

function sp_a2_bts3_ghoststory()
	GladosPlayVcd(-2500)
end

function sp_a2_bts3_smellyhumanstart()
	GladosPlayVcd(-2503)
end

function sp_a2_bts3_smellyhumanlovethem()
	GladosPlayVcd(-2504)
end