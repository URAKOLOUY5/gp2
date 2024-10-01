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
        next = nil,
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
        next = nil,
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
        next = nil,
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
        next = nil,
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
        next = nil,
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

	SceneTableLookup[-2500] = "-2500_01" -- OOh.  Dark down here, isn't it. (ghost story)
	SceneTableLookup[-2503] = "-2503_01" -- (smelly humans)
	SceneTableLookup[-2504] = "-2504_01" -- humans, love 'em!
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

-- ****************************************************************************************************
-- sp_a2_bts4
-- ****************************************************************************************************
if curMapName == "sp_a2_bts4" then
	sp_a2_bts4_redemption_turret_held = false
	sp_a2_bts4_redemption_turret_babble_index = 0
	sp_a2_bts4_redemption_turret_babbling = false

	sp_a2_bts4_StillThinkingNagStage = 0
	sp_a2_bts4_StillThinkingNagOK = false
	sp_a2_bts4_StillThinkingNagIdx = 0
	sp_a2_bts4_StillThinkingNagTime = 0
	sp_a2_bts4_MentionedSwap = false
	sp_a2_bts4_At_Window = false
	sp_a2_bts4_At_Big_Potato = false
	sp_a2_bts4_At_Volcano = false
	sp_a2_bts4_Intro_Talking = false
	sp_a2_bts4_Science_Fair_Busy = false
	sp_a2_bts4_Did_Big_Potato = false
	sp_a2_bts4_Did_Volcano = 0
end	


function bts4_redemption_line_turret_safe()
end

function SabotageFactoryRecycledTurretNoticesPlayer()
	GladosPlayVcd(439, nil, "conveyor_turret_body")
end

function bts4_redemption_line_turret_pickup()
	sp_a2_bts4_redemption_turret_held = true

	if not sp_a2_bts4_redemption_turret_babbling then
		GladosPlayVcd(614, nil, "conveyor_turret_body")
	end
end

function bts4_redemption_line_turret_drop()
	sp_a2_bts4_redemption_turret_held = false
end

function bts4_redemption_line_turret_babble_start()
	sp_a2_bts4_redemption_turret_babbling = true
end

function bts4_redemption_line_turret_babble_end()
	local dly = math.Rand(2, 5)
	sp_a2_bts4_redemption_turret_babbling = false
	if sp_a2_bts4_redemption_turret_held then
		EntFire("@glados","runscriptcode","bts4_redemption_line_turret_babble()",dly)
	end
end

function bts4_redemption_line_turret_babble()
	if not sp_a2_bts4_redemption_turret_babbling then
		if sp_a2_bts4_redemption_turret_held then
			if sp_a2_bts4_redemption_turret_babble_index < 8 then
				sp_a2_bts4_redemption_turret_babble_index = sp_a2_bts4_redemption_turret_babble_index + 1
				GladosPlayVcd(614+sp_a2_bts4_redemption_turret_babble_index, nil, "conveyor_turret_body")				
			end
		end
	end
end

function bts4_redemption_line_turret_not_saved()
	GladosCharacterStopScene("conveyor_turret_body")
	GladosPlayVcd(613, nil, "conveyor_turret_body")
end

function bts4_redemption_line_fizzler_approach()
end

function bts4_redemption_line_turret_achievement()
end

function bts4_redemption_line_turret_fizzled()
	GladosCharacterStopScene("conveyor_turret_body")
	GladosPlayVcd(613, nil, "conveyor_turret_body")
end

function FactoryWheatleyHey()
	GladosPlayVcd(515)
end

function FactoryFollowMe()
	GladosPlayVcd(516)
end

function FactoryAlmostThere()
	GladosPlayVcd(518)
end

function FactoryTahDah()
	GladosPlayVcd(517)
end

function FactoryScannerIntro()
	sp_a2_bts4_At_Window = true
	if not sp_a2_bts4_Intro_Talking then
		GladosPlayVcd(519)
	end
end

function FactoryScannerSpeech()
	GladosPlayVcd(519)
end

function FactoryCheckAtWindowEnd()
	sp_a2_bts4_Intro_Talking = false
	if sp_a2_bts4_At_Window then
		FactoryScannerSpeech()
	end
end

function FactoryCheckAtWindowStart()
	sp_a2_bts4_Intro_Talking = true

	if sp_a2_bts4_At_Window then
		FactoryScannerSpeech()
	end
end

function FactoryControlDoorHackIntro()
	GladosPlayVcd(520)
end

function FactoryControlRoomHackSuccess()
	WheatleyStopNag()
	GladosPlayVcd(521)
end

function FactoryFirstTurretTaken()
	WheatleyStopNag()
	GladosPlayVcd(522)
end

function FactoryFirstTurretPulled()
	--WheatleyStopNag()
	--GladosPlayVcd()
end

function FactoryEnableThinkingNag()
	printdebug("%%%%%%%%%%%%%%%%ENABLE STILL THINKING NAG")
	sp_a2_bts4_StillThinkingNagOK = true
end

function FactoryDisableThinkingNag()
	printdebug("%%%%%%%%%%%%%%%%DISABLE STILL THINKING NAG")
	sp_a2_bts4_StillThinkingNagOK = false
end

function FactoryStillThinkingNag()
	printdebug("%%%%%%%%%%%%%%%%STILL THINKING NAG")
	if sp_a2_bts4_StillThinkingNagStage == 0 then
		if not sp_a2_bts4_StillThinkingNagOK then
		return
		end
		if characterCurscene("wheatley") ~= nil then
		sp_a2_bts4_StillThinkingNagTime = CurTime()
		return
		end  
		if CurTime() - sp_a2_bts4_StillThinkingNagTime > 5 and math.random(1, 100) > 50 then
		sp_a2_bts4_StillThinkingNagIdx = sp_a2_bts4_StillThinkingNagIdx + 1
		sp_a2_bts4_StillThinkingNagTime = CurTime()
		if sp_a2_bts4_StillThinkingNagIdx == 1 then
			GladosPlayVcd(523)
		elseif sp_a2_bts4_StillThinkingNagIdx == 2 then
			GladosPlayVcd(524)
		elseif sp_a2_bts4_StillThinkingNagIdx == 3 then
			GladosPlayVcd(525)
		elseif sp_a2_bts4_StillThinkingNagIdx == 4 then
			GladosPlayVcd(526)
		elseif sp_a2_bts4_StillThinkingNagIdx == 5 then
			GladosPlayVcd(527)
		elseif sp_a2_bts4_StillThinkingNagIdx == 6 then
			GladosPlayVcd(528)
		elseif sp_a2_bts4_StillThinkingNagIdx == 7 then
			sp_a2_bts4_MentionedSwap = true
			GladosPlayVcd(529)
		elseif sp_a2_bts4_StillThinkingNagIdx == 8 then
			sp_a2_bts4_MentionedSwap = true
			GladosPlayVcd(530)
		else
			sp_a2_bts4_MentionedSwap = true
			GladosPlayVcd(531)
		end
		end
	elseif sp_a2_bts4_StillThinkingNagStage == 1 then
	end
end

function FactoryWhereAreYouGoing()
	if not sp_a2_bts4_MentionedSwap then
		GladosPlayVcd(532)
	end
end

function FactoryWhereAreYouGoingTwo()
	if not sp_a2_bts4_MentionedSwap then
		GladosPlayVcd(533)
	end
end

function FactoryBroughtBackDefectiveTurret()
	printdebug("$$$$$$$$$$$$$CRAP TURRET TRIGGER")
	sp_a2_bts4_StillThinkingNagStage = 2

	if not sp_a2_bts4_MentionedSwap then
		GladosPlayVcd(535)
	else
		GladosPlayVcd(534)
	end
end

function FactoryWheatleyShoutout()
	if not sp_a2_bts4_MentionedSwap then
		GladosPlayVcd(541)
	end
end

function FactoryEnterScannerRoomWithTurret()
	if not sp_a2_bts4_MentionedSwap then
		GladosPlayVcd(540)
	end
end

function FactorySuccess()
	sp_a2_bts4_StillThinkingNagStage = 2
	if sp_a2_bts4_MentionedSwap then
		GladosPlayVcd(539)
	else
		GladosPlayVcd(538)
	end
end

function ScienceFairBusy()
	sp_a2_bts4_Science_Fair_Busy = true
end

function ScienceFairNotBusy()
	sp_a2_bts4_Science_Fair_Busy = true

	if sp_a2_bts4_At_Volcano then
		PlayerNearScienceFairVolcano()
		return
	end

	if sp_a2_bts4_At_Big_Potato then
		PlayerLookingAtScienceFairPotato()
		return
	end
end

function PlayerNearScienceFairVolcano()
	sp_a2_bts4_At_Volcano = true
	if not sp_a2_bts4_Science_Fair_Busy then
		if sp_a2_bts4_Did_Volcano == 0 then
		sp_a2_bts4_Did_Volcano = 1
		GladosPlayVcd(583)
		elseif sp_a2_bts4_Did_Volcano == 1 then
		sp_a2_bts4_Did_Volcano = 2
		GladosPlayVcd(584)
		end
	end  
end

function PlayerLeavingScienceFairVolcano()
	sp_a2_bts4_At_Volcano = false
end

function PlayerLookingAtScienceFairPotato() -- fires once player looks at potato plant
	sp_a2_bts4_At_Big_Potato = true

	if not sp_a2_bts4_Science_Fair_Busy then
		if not sp_a2_bts4_Did_Big_Potato then
			sp_a2_bts4_Did_Big_Potato = true
			GladosPlayVcd(582)
		end
	end
end

function PlayerNotLookingAtScienceFairPotato()
	sp_a2_bts4_At_Big_Potato = true
end

function sabotage_factory_WatchTheLine()
	GladosPlayVcd(441)
end

function sabotage_factory_ReachedHackingSpot()
	GladosPlayVcd(442)
	print("reaced hacking sport")
end

function sabotage_factory_PlayerReachedWheatley()
	WheatleyStopNag()
	GladosPlayVcd(443)
end

function sabotage_factory_PlayerReachedExitDoor()
	WheatleyStopNag()
	GladosPlayVcd(444)
end

function ScienceFairGoingTheRightWay()
	GladosPlayVcd( -100 )
end

function ScienceFairBringDaughter()
	GladosPlayVcd( -101 )
end

function JustToReassureYou()
	GladosPlayVcd( -102 )
end

function DefinitelySureThisWay()
	GladosPlayVcd( -103 )
end

function sp_a2_bts4_end_dialog()
	GladosPlayVcd( -104 )
end

if curMapName == "sp_a2_bts4" or curMapName == "sabotage_offices" then
    SceneTable["-100_01"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sp_sabotage_panel_sneak01.vcd"), -- Alright, we took out her turrets. Now lets take out her toxin.
        char = "wheatley",
        postdelay = 0.0,
        predelay = 0.0,
        next = nil,
        noDingOff = true,
        noDingOn = true,
        queue = true
    }

    SceneTable["-101_01"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sphere_flashlight_tour41.vcd"), -- Bring your daughter to work day.  That did not end well.
        char = "wheatley",
        postdelay = 1.0,
        predelay = 0.0,
        next = "-101_02",
        noDingOff = true,
        noDingOn = true,
        fires = {
            {entity = "@glados", input = "runscriptcode", parameter = "ScienceFairBusy()", delay = 0.0, fireatstart = true}
        }
    }

    SceneTable["-101_02"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sphere_flashlight_tour42.vcd"), -- And 40 potato batteries.  Embarassing.
        char = "wheatley",
        postdelay = 0.0,
        predelay = 0.0,
        next = nil,
        noDingOff = true,
        noDingOn = true,
        fires = {
            {entity = "@glados", input = "runscriptcode", parameter = "ScienceFairNotBusy()", delay = 0.0},
            {entity = "lookat_potato_exhibits_relay", input = "trigger", parameter = "", delay = 0.2, fireatstart = true},
            {entity = "wheatley_exhibit_move_triggers", input = "enable", parameter = "", delay = 4.0, fireatstart = true},
            {entity = "lookat_player_rl", input = "trigger", parameter = "", delay = 3, fireatstart = true}
        }
    }

    SceneTable["-102_01"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sphere_flashlight_tour44.vcd"), -- Pretty sure we're going the right way. Just to reassure you.
        char = "wheatley",
        postdelay = 0.0,
        predelay = 0.0,
        next = nil,
        noDingOff = true,
        noDingOn = true,
        queue = true,
        queuepredelay = 1.0
    }

    SceneTable["-103_01"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sphere_flashlight_tour50.vcd"), -- Don't worry i'm absolutely guaranteeing you it is this way.
        char = "wheatley",
        postdelay = 0.0,
        predelay = 0.0,
        next = nil,
        noDingOff = true,
        noDingOn = true,
        fires = {
            {entity = "lookat_deadend_relay", input = "trigger", parameter = "", delay = 2.0, fireatstart = true}, -- aim light down deadend
            {entity = "move_wheatley_to_deadend_relay", input = "trigger", parameter = "", delay = 3.0, fireatstart = true}, -- move towards deadend
            {entity = "lookat_deadend_entry_relay", input = "trigger", parameter = "", delay = 3.7, fireatstart = true}, -- aim light back
            {entity = "move_wheatley_to_exit_relay", input = "trigger", parameter = "", delay = 4.0, fireatstart = true} -- move out of deadend
        }
    }

    SceneTable["-104_01"] = {
        vcd = CreateSceneEntity("scenes/npc/sphere03/sphere_flashlight_tour52.vcd"), -- Definitely sure it's this way.  I dont know where it is.
        char = "wheatley",
        postdelay = 0.0,
        predelay = 0.0,
        next = nil,
        noDingOff = true,
        noDingOn = true
    }
end

SceneTableLookup[-100] = "-100_01" -- Alright we took out her turrets. Now lets go take out her neurotoxin as well.

SceneTableLookup[-101] = "-101_01" -- Bring your daughter to work day.  That did not end well.
									--  And 40 potato batteries.  Embarassing.

SceneTableLookup[-102] = "-102_01" -- Pretty sure we're going the right way. Just to reassure you.

SceneTableLookup[-103] = "-103_01" -- Don't worry i'm absolutely guaranteeing you it is this way.  Ah, It's not this way.

SceneTableLookup[-104] = "-104_01" -- Definitely sure it's this way.  Not entirely sure.  I don't know where it is.

-- ****************************************************************************************************
-- sp_a2_bts5
-- ****************************************************************************************************

if curMapName == "sp_a2_bts5" then
	bts5_cuts = 0
end

if curMapName == "sp_a2_bts5" then
    bts5_cuts = 0
end

function ToxinWheatleyGreetsYou() -- this tank is big - let's get to the observation room
    GladosPlayVcd(561)
end

function ToxinTurretDestructionOurHandiwork() -- when the players see the good turrets into the crusher
    GladosPlayVcd(562)
end

function ToxinTheDoorIsLocked() -- As the player gets to the top of the lift
    GladosPlayVcd(563)
end

function ToxinDoorIsNowOpenMovingToMonitor() -- When the player disables the panels
    GladosPlayVcd(564)
end

function ToxinCutOffFrontOfRoom() -- when the player chops off the front of the room
    nuke()
    GladosPlayVcd(565)
end

function ToxinPipeCut() -- called when *each* pipe is cut
    bts5_cuts = bts5_cuts + 1

    if bts5_cuts == 1 then
        GladosPlayVcd(566)
    elseif bts5_cuts == 4 then
        GladosPlayVcd(567)
    elseif bts5_cuts == 5 then
        GladosPlayVcd(568)
    elseif bts5_cuts == 8 then
        GladosPlayVcd(569)
    end
end

-- we will delay the glass breaking until the destruction is played out.
function ToxinGettingPulledIntoPipe()
    nuke()
    GladosPlayVcd(570)
end

-- player starts vault trap
function VaultTrapStart()
	GladosPlayVcd(-50)
end

-- player begins moving in relaxation vault
function VaultTrapStartMoving()
	GladosPlayVcd(-53)
end

function TurretScene()
	GladosPlayVcd(-700)
end

function TurretDeathReactionDialog()
	GladosPlayVcd(-57)
end

function WheatleyBouncingDownTubeDialog()
end

function WheatleyLandsInChamberDialog()
	GladosPlayVcd(-61)
end

function CoreDetectedDialog()
end

function WheatleyCoreSocketed()
	StopWheatleyPluginNag()
	GladosPlayVcd(-71)
end

function StalemateAssociateNotSoFast()
	StopWheatleyPluginNag()
	GladosPlayVcd(-84)
end

function CoreTransferInitiated()
	nuke()
	EntFire("glados_shutdown_particles_relay", "trigger", 0, 0 )
	GladosPlayVcd(-88)
end

function WheatleyCoreTransferStart()
	sp_a2_core_xfer_left_annex = true
	GladosPlayVcd(-4)
end

function sp_a2_core_leave_annex_nag()
	if not sp_a2_core_xfer_left_annex then
		GladosPlayVcd(-45)
	end
end

function PitHandsGrabGladosHead()
	GladosPlayVcd(-89)
end

function PullGladosIntoPit()
	GladosPlayVcd(-90)
end

function CoreTransferCompleted()
	GladosPlayVcd(-9)
end

function PlayerEnteredElevator()
	StopWheatleyElevatorNag()
	CorePlayerInElevator = 1 -- this will prevent the elevator nag from being triggered by subsequent IO
	EntFire("@exit_elevator_music_relay","trigger", 0, 0 )
	GladosPlayVcd(-13) -- I knew it was going to be cool being in charge..
	
	-- delete many of the small_pos arms
	EntFire("small_pos1", "kill", 0, 0 )
	EntFire("small_pos3", "kill", 0, 0 )
	EntFire("small_pos4", "kill", 0, 0 )
	EntFire("small_pos7", "kill", 0, 0 )
	EntFire("small_pos9", "kill", 0, 0 )
	EntFire("small_pos10", "kill", 0, 0 )
end

function DialogDuringPotatosManufacture()
	GladosPlayVcd(-33)
end

function PotatosPresentation()
	GladosPlayVcd(-34)
end

function ElevatorMoronScene()
	GladosPlayVcd(-37)
end

function ElevatorConclusion()
	GladosPlayVcd(-44)
end

-- ****************************************************************************************************
-- GLADOS BATTLE scenetable
-- ****************************************************************************************************

SceneTableLookup[-50] = "-20_01"
SceneTableLookup[-53] = "-21_01"
SceneTableLookup[-700] = "-700_01"
SceneTableLookup[-750] = "-750_01"
SceneTableLookup[-57] = "-22_01"
SceneTableLookup[-61] = "-23_01"
SceneTableLookup[-760] = "-760_01"
SceneTableLookup[-761] = "-760_01d"
SceneTableLookup[-71] = "-24_01"
SceneTableLookup[-72] = "-72_01"
SceneTableLookup[-73] = "-73_01"
SceneTableLookup[-755] = "-755_01"
SceneTableLookup[-84] = "-25_01"
SceneTableLookup[-88] = "-26_01"
SceneTableLookup[-4] = "-4_01"
SceneTableLookup[-89] = "-27_00"
SceneTableLookup[-90] = "-27_01"
SceneTableLookup[-91] = "-27_03"
SceneTableLookup[-93] = "-28_01"
SceneTableLookup[-666] = "-666_01"
SceneTableLookup[-9] = "-5_01"
SceneTableLookup[-13] = "-14_01"
SceneTableLookup[-33] = "-10_01"
SceneTableLookup[-34] = "-11_01"
SceneTableLookup[-37] = "-12_01"
SceneTableLookup[-44] = "-13_01"
SceneTableLookup[-45] = "-45_01"                                                                                                                                  

-- ****************************************************************************************************
-- GLaDOS Battle
-- ****************************************************************************************************

if curMapName == "sp_a2_core" then -- TODO: CHANGE THIS TO CORRECT MAP NAME
	SceneTable ["-20_01" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/glados/fgbrvtrap02.vcd"), -- I honestly didn't think you would fall for that
		char = "glados",
		postdelay = 1.3,
		predelay = 1.0,
		next = "-20_02",
		noDingOff = true,
		noDingOn = true
	}
	
	SceneTable ["-20_02" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/glados/fgbrvtrap03.vcd"), -- In fact, I devised a much more elaborate trap ahead, for when you got through this easy one.
		char = "glados",
		postdelay = 0.8,
		predelay = 0.0,
		next = "-20_03",
		noDingOff = true,
		noDingOn = true
	}
	
	SceneTable ["-20_03" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/glados/fgbrvtrap05.vcd"), -- If I had known it would be this easy, I would have just dangled a turkey leg
		char = "glados",
		postdelay = 2.0,
		predelay = 0.0,
		next = nil,
		noDingOff = true,
		noDingOn = true,
		fires=
		{
			{entity="rv_start_moving_trigger",input="enable",parameter="",delay=0.5}
		}
		
		
	}
	
-- ======================================  Plays when player lands in moving vault
	SceneTable ["-21_01" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/glados/fgbturrets01.vcd"), -- Well, it was nice catching up. Lets get to business.
		char = "glados",
		postdelay = 0.8,
		predelay = 1.0,
		next = "-21_02",
		noDingOff = true,
		noDingOn = true
	}
	
	SceneTable ["-21_02" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/glados/fgb_trap01.vcd"), -- I hope you brought something more powerful than the portal gun this time
		char = "glados",
		postdelay = 0.4,
		predelay = 0.0,
		next = "-21_03",
		noDingOff = true,
		noDingOn = true,
		fires=
		{
			{entity="glados_chamber_body",input="setanimation",parameter="gladosbattle_firstpart",delay=0,fireatstart=true}, -- ANIM
			{entity="glados_chamber_body",input="setdefaultanimation",parameter="glados_idle_rightside",delay=0,fireatstart=true}
		}
	}
	
	SceneTable ["-21_03" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/glados/fgb_trap02.vcd"), -- Otherwise you're about to become the past president of the being alive club, ha ha. 
		char = "glados",
		postdelay = 0.6,
		predelay = 0.0,
		next = "-21_03b",
		noDingOff = true,
		noDingOn = true,
		talkover=true,
		fires=
		{
			{entity="deploy_turrets_relay",input="Trigger",parameter="",delay=4,fireatstart=true}	
		}
	}

	SceneTable ["-21_03b" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/glados/fgb_trap03.vcd"), -- Seriously, though--goodbye.
		char = "glados",
		postdelay = 0.0,
		predelay = 0.0,
		next = nil,
		noDingOff = true,
		noDingOn = true,
		talkover=true	
	}	
	
	
/*	SceneTable ["-21_04" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/glados/fgbturrets02.vcd"), -- You remember my turrets don't you... oh wait, that's you in 5 seconds. goodbye.
		char = "glados",
		postdelay = -9.0,
		predelay = 0.0,
		next = "-700_01",
		noDingOff = true,
		noDingOn = true,
		talkover=true,
		fires=
		{
			{entity="deploy_turrets_relay",input="Trigger",parameter="",delay=4,fireatstart=true},		
		}
	}
*/	
-- ====================================== Turrets deployed scene

	SceneTable ["-700_01" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/turret/glados_battle_defect_arrive18.vcd"), -- [muffled turret talking]
		char = "turret",
		postdelay = 0.0,
		predelay = 0.0,
		next = "-700_02",
		noDingOff = true,
		noDingOn = true,
		talkover=true,	
		settarget1="turret_02-chamber_npc_turret"
	}
	
	SceneTable ["-700_02" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire05.vcd"), -- dry fire
		char = "turret",
		postdelay = -0.5,
		predelay = 0.0,
		next = "-700_03",
		noDingOff = true,
		noDingOn = true,
		talkover=true,
		settarget1="turret_02-chamber_npc_turret",
		fires=
		{
			{entity="box_turret_push_trigger",input="enable",parameter="",delay=0.0,fireatstart=true}	-- turret falls over
		}
	}
	
	SceneTable ["-700_03" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/turret/glados_battle_defect_arrive01.vcd"), -- it's my big chance!
		char = "turret",
		postdelay = 0.0,
		predelay = 0.0,
		next = "-700_04",
		noDingOff = true,
		noDingOn = true,
		talkover=true,		
		settarget1="turret_01-chamber_npc_turret",
		fires=
		{
			{entity="turret_01-chamber_npc_turret_guns_out_ss",input="beginsequence",parameter="",delay=0, fireatstart=true}, -- pop out guns
			{entity="turret_01-chamber_npc_turret",input="ignite",parameter="",delay=0},
		}
	}
	
	SceneTable ["-700_04" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire07.vcd"), -- dry fire
		char = "turret",
		postdelay = 0.0,
		predelay = 0.0,
		next = "-700_05",
		noDingOff = true,
		noDingOn = true,
		talkover=true,
		settarget1="turret_01-chamber_npc_turret"
	}
	
	SceneTable ["-700_05" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/turret/glados_battle_defect_arrive15.vcd"), --  This is trouble
		char = "turret",
		postdelay = 0.0,
		predelay = 0.0,
		next = "-700_06",
		noDingOff = true,
		noDingOn = true,
		talkover=true,
		settarget1="turret_01-chamber_npc_turret",
		fires=
		{
			{entity="turret_01-chamber_npc_turret",input="selfdestructimmediately",parameter="",delay=0.0},		
			{entity="turret_02-chamber_npc_turret",input="ignite",parameter="",delay=0.1}
		}
	}
	
	SceneTable ["-700_06" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/turret/glados_battle_defect_arrive17.vcd"), -- [muffled turret talking while on fire]
		char = "turret",
		postdelay = 0.0,
		predelay = 0.0,
		next = "-700_07",
		noDingOff = true,
		noDingOn = true,
		talkover=true,		
		settarget1="turret_02-chamber_npc_turret",
		fires=
		{
			{entity="turret_02-chamber_npc_turret",input="selfdestructimmediately",parameter="",delay=0.0}
		}
	}
	
	SceneTable ["-700_07" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/turret/glados_battle_defect_arrive12.vcd"), -- ahhh not again!
		char = "turret",
		postdelay = 0.0,
		predelay = 0.0,
		next = "-700_08",
		noDingOff = true,
		noDingOn = true,
		talkover=true,
		settarget1="turret_03-chamber_npc_turret",
		fires=
		{
			{entity="turret_03-chamber_npc_turret",input="selfdestruct",parameter="",delay=0,fireatstart=true},
			{entity="turret_03-chamber_npc_turret",input="selfdestructimmediately",parameter="",delay=0.5}
		}
	}
	
	SceneTable ["-700_08" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/turret/glados_battle_defect_arrive07.vcd"), -- Here it comes, pal!
		char = "turret",
		postdelay = 0.5,
		predelay = 0.0,
		next = "-700_09",
		noDingOff = true,
		noDingOn = true,
		talkover=true,
		settarget1="turret_04-chamber_npc_turret",
		fires=
		{
			{entity="turret_04-chamber_npc_turret_guns_out_ss",input="beginsequence",parameter="",delay=0, fireatstart=true}, -- pop out guns
		}
	}
	
	
	SceneTable ["-700_09" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/turret/glados_battle_defect_arrive08.vcd"), -- Locked and loaded!
		char = "turret",
		postdelay = 0.0,
		predelay = 0.0,
		next = "-700_10",
		noDingOff = true,
		noDingOn = true,
		talkover=true,
		settarget1="turret_05-chamber_npc_turret",
		fires=
		{
			{entity="turret_05 -chamber_npc_turret_guns_out_ss",input="beginsequence",parameter="",delay=0, fireatstart=true}, -- pop out guns
		}
	}
	
	SceneTable ["-700_10" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire01.vcd"), -- dry fire
		char = "turret",
		postdelay = 0.0,
		predelay = 0.0,
		next = "-700_11",
		noDingOff = true,
		noDingOn = true,
		talkover=true,
		settarget1="turret_04-chamber_npc_turret",
		fires=
		{
			{entity="turret_04-chamber_npc_turret",input="ignite",parameter="",delay=0,fireatstart=true},
			{entity="turret_04-chamber_npc_turret",input="selfdestructimmediately",parameter="",delay=1.0},
			{entity="turret_05-chamber_npc_turret",input="ignite",parameter="",delay=0},
		}
		
		-- explodes, cracks glass
		-- sets turret 5 on fire
	}
	
	
	SceneTable ["-700_11" ] =
	{
		vcd = CreateSceneEntity("scenes/npc/turret/glados_battle_defect_arrive16.vcd"), -- Oh this aint' good
		char = "turret",
		postdelay = 0.0,
		predelay = 0.0,
		next = nil,
		noDingOff = true,
		noDingOn = true,
		settarget1="turret_05-chamber_npc_turret",
		fires=
		{
			{entity="turret_05-chamber_npc_turret",input="selfdestructimmediately",parameter="",delay=0.0},
			{entity="@glados",input="RunScriptCode",parameter="TurretDeathReactionDialog()",delay=0.3}
		}
	}
	
	/*
	
	-- ====================================== Turret Death Reaction
	SceneTable["-22_01"] =
	{
		vcd=CreateSceneEntity("scenes/npc/glados/fgbturrets04.vcd") -- My turrets!
		char="glados"
		postdelay=0.1
		predelay = 0.0
		next="-22_02"
		noDingOff=true
		noDingOn=true
	}
	*/
	
	SceneTable["-22_01"] =
	{
		vcd=CreateSceneEntity("scenes/npc/glados/fgb_trap05.vcd"), -- Ohhhhh. You were busy back there.
		char="glados",
		postdelay=0.8,
		predelay = 0.0,
		next="-22_03",
		noDingOff=true,
		noDingOn=true
	}
	
	SceneTable["-22_03"] =
	{
		vcd=CreateSceneEntity("scenes/npc/glados/fgb_trap06.vcd"), --I suppose we could just sit in this room and glare at each other until somebody drops dead, but I have a better idea.
		char="glados",
		postdelay=0.1,
		predelay = 0.0,
		next="-22_05",
		noDingOff=true,
		noDingOn=true,
		fires=
		{
			{entity="deploy_neurotoxin_tube_relay",input="Trigger",parameter="",delay=5.00, fireatstart=true}
		}
	}
	
	/*(SceneTable["-22_04"] =
	{
		vcd=CreateSceneEntity("scenes/npc/glados/gladosbattle_pre07.vcd") -- Your old friend, deadly neurotoxin.
		char="glados"
		postdelay=0.3
		predelay = 0.0
		next="-22_05"
		noDingOff=true
		noDingOn=true
	}*/
	
	SceneTable["-22_05"] =
	{
		vcd=CreateSceneEntity("scenes/npc/glados/fgb_trap08.vcd"), --Your old friend, deadly neurotoxin. If I were you, I'd take a deep breath right now and hold it.
		char="glados",
		postdelay=0.1,
		predelay = 0.0,
		next= nil,
		noDingOff=true,
		noDingOn=true,
		fires=
		{
			{entity="deploy_wheatley_relay",input="Trigger",parameter="",delay=0.00},
			--{entity="glados_watch_wheatley_deploy_relay",input="Trigger",parameter="",delay=0.4} -- makes glados spin to watch wheatley
			{entity="@glados",input="runscriptcode",parameter="StartWheatleyNeurotoxinRideNag()",delay=0.00}
		}
	}

	-- ======================================
	-- Wheatley neurotoxin ride
	-- ======================================

	SceneTable["-750_01"] = {
		vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_wheatley_ows05.vcd"),
		idlerandom = true,
		idlerepeat = true,
		postdelay = 0.1,
		next = nil,
		char = "glados",
		noDingOff = true,
		noDingOn = true,
		idle = true,
		talkover = true,
		idleminsecs = 0.0,
		idlemaxsecs = 0.0,
		idlegroup = "wheatleybouncepain",
		idleorderingroup = 1
	}

	SceneTable["-750_02"] = {
		vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_wheatley_ows06.vcd"),
		postdelay = 0.0,
		next = nil,
		char = "glados",
		noDingOff = true,
		noDingOn = true,
		talkover = true,
		idlegroup = "wheatleybouncepain",
		idleorderingroup = 2
	}

	SceneTable["-750_03"] = {
		vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_wheatley_ows01.vcd"),
		postdelay = 0.0,
		next = nil,
		char = "glados",
		noDingOff = true,
		noDingOn = true,
		talkover = true,
		idlegroup = "wheatleybouncepain",
		idleorderingroup = 3
	}

	SceneTable["-750_04"] = {
		vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_wheatley_ows02.vcd"),
		postdelay = 0.0,
		next = nil,
		char = "glados",
		noDingOff = true,
		noDingOn = true,
		talkover = true,
		idlegroup = "wheatleybouncepain",
		idleorderingroup = 4
	}

	SceneTable["-750_05"] = {
		vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_wheatley_ows20.vcd"),
		postdelay = 0.0,
		next = nil,
		char = "glados",
		noDingOff = true,
		noDingOn = true,
		talkover = true,
		idlegroup = "wheatleybouncepain",
		idleorderingroup = 5
	}

	SceneTable["-750_06"] = {
		vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_wheatley_ows15.vcd"),
		postdelay = 0.0,
		next = nil,
		char = "glados",
		noDingOff = true,
		noDingOn = true,
		talkover = true,
		idlegroup = "wheatleybouncepain",
		idleorderingroup = 6
	}

	SceneTable["-750_07"] = {
		vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_wheatley_ows10.vcd"),
		postdelay = 0.0,
		next = nil,
		char = "glados",
		noDingOff = true,
		noDingOn = true,
		talkover = true,
		idlegroup = "wheatleybouncepain",
		idleorderingroup = 7
	}

	SceneTable["-750_08"] = {
		vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_wheatley_ows18.vcd"),
		postdelay = 0.0,
		next = nil,
		char = "glados",
		noDingOff = true,
		noDingOn = true,
		talkover = true,
		idlegroup = "wheatleybouncepain",
		idleorderingroup = 8
	}
end

function StartWheatleyNeurotoxinRideNag()
	GladosPlayVcd( -750 )
end

function StopWheatleyNeurotoxinRideNag()
	GladosStopNag()
	GladosCharacterStopScene("wheatley")  -- this will make wheatley stop talking if he is currently playing a vcd
end

-- ====================================== Wheatley Lands In Chamber
SceneTable["-23_01"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_hello01.vcd"),
    char = "wheatley",
    postdelay = 1.1,
    predelay = 0.0,
    next = "-23_02",
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "shatter_vault_glass_relay", input = "Trigger", parameter = "", delay = 0.4 }
    }
}

SceneTable["-23_02"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/gladosbattle_pre09.vcd"),
    char = "glados",
    postdelay = 0.0,
    predelay = 0.8,
    next = "-23_03",
    noDingOff = true,
    noDingOn = true
}

--CoreDetected
SceneTable["-23_03"] = {
    vcd = CreateSceneEntity("scenes/npc/announcer/gladosbattle11.vcd"),
    char = "announcer",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-23_04",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-23_04"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer04.vcd"),
    char = "glados",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-23_05",
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "glados_chamber_body", input = "setanimation", parameter = "gladosbattle_xfer04", delay = 0, fireatstart = true },
        { entity = "glados_chamber_body", input = "setdefaultanimation", parameter = "glados_idle_agitated_more", delay = 0, fireatstart = true }
    }
}

SceneTable["-23_05"] = {
    vcd = CreateSceneEntity("scenes/npc/announcer/gladosbattle12.vcd"),
    char = "announcer",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-23_06",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-23_06"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_that_is_me02.vcd"),
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-23_07",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-23_07"] = {
    vcd = CreateSceneEntity("scenes/npc/announcer/gladosbattle13.vcd"),
    char = "announcer",
    postdelay = -5.0,
    predelay = 0.0,
    next = "-23_08",
    noDingOff = true,
    noDingOn = true,
    talkover = true,
    fires = {
        { entity = "deploy_core_receptacle_relay", input = "Trigger", parameter = "", delay = 0.3, fireatstart = true },
        { entity = "display_socket_instructions_relay", input = "Trigger", parameter = "", delay = 0.3, fireatstart = true }
    }
}

SceneTable["-23_08"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer05.vcd"),
    char = "glados",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-23_09",
    noDingOff = true,
    noDingOn = true,
    talkover = true
}

SceneTable["-23_09"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer06.vcd"),
    char = "glados",
    postdelay = 0.0,
    predelay = 0.0,
    next = nil,
    noDingOff = true,
    noDingOn = true,
    talkover = true,
    fires = {
        { entity = "@glados", input = "RunScriptCode", parameter = "StartWheatleyPluginScene()", delay = 0.0 }
    }
}

-- ======================================
-- Wheatley socket plug in start
-- ======================================
SceneTable["-760_01"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_plugin_nags01.vcd"),
    char = "wheatley",
    predelay = 0.0,
    postdelay = 0.1,
    next = "-760_01a",
    noDingOff = true,
    noDingOn = true,
    talkover = true
}

SceneTable["-760_01a"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/sp_a2_core02.vcd"),
    postdelay = 0.1,
    predelay = 0,
    next = "-760_01b",
    char = "glados",
    noDingOff = true,
    noDingOn = true,
    talkover = true,
    fires = {
        { entity = "glados_chamber_body", input = "setanimation", parameter = "sp_a2_core02", delay = 0, fireatstart = true },
        { entity = "glados_chamber_body", input = "setdefaultanimation", parameter = "glados_idle_agitated_more", delay = 0, fireatstart = true }
    }
}

SceneTable["-760_01b"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_doit_nags08.vcd"),
    postdelay = 0.0,
    predelay = 0.0,
    next = "-760_01c",
    char = "wheatley",
    noDingOff = true,
    noDingOn = true,
    talkover = true
}

SceneTable["-760_01c"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/sp_a2_core01.vcd"),
    postdelay = 0.0,
    predelay = 0.0,
    next = nil,
    char = "glados",
    noDingOff = true,
    noDingOn = true,
    talkover = true,
    fires = {
        { entity = "glados_chamber_body", input = "setanimation", parameter = "sp_a2_core01", delay = 0, fireatstart = true },
        { entity = "@glados", input = "RunScriptCode", parameter = "StartWheatleyPluginNag()", delay = 0 }
    }
}

-- ======================================
-- Wheatley socket plug in start
-- ======================================
SceneTable["-760_01"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_plugin_nags01.vcd"),
    char = "wheatley",
    predelay = 0.0,
    postdelay = 0.1,
    next = "-760_01a",
    noDingOff = true,
    noDingOn = true,
    talkover = true
}

SceneTable["-760_01a"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/sp_a2_core02.vcd"),
    postdelay = 0.1,
    predelay = 0,
    next = "-760_01b",
    char = "glados",
    noDingOff = true,
    noDingOn = true,
    talkover = true,
    fires = {
        { entity = "glados_chamber_body", input = "setanimation", parameter = "sp_a2_core02", delay = 0, fireatstart = true },
        { entity = "glados_chamber_body", input = "setdefaultanimation", parameter = "glados_idle_agitated_more", delay = 0, fireatstart = true }
    }
}

SceneTable["-760_01b"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_doit_nags08.vcd"),
    postdelay = 0.0,
    predelay = 0.0,
    next = "-760_01c",
    char = "wheatley",
    noDingOff = true,
    noDingOn = true,
    talkover = true
}

SceneTable["-760_01c"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/sp_a2_core01.vcd"),
    postdelay = 0.0,
    predelay = 0.0,
    next = nil,
    char = "glados",
    noDingOff = true,
    noDingOn = true,
    talkover = true,
    fires = {
        { entity = "glados_chamber_body", input = "setanimation", parameter = "sp_a2_core01", delay = 0, fireatstart = true },
        { entity = "@glados", input = "RunScriptCode", parameter = "StartWheatleyPluginNag()", delay = 0 }
    }
}

-- ======================================
-- Wheatley socket plugin nag
-- ======================================

SceneTable["-760_01d"] = {vcd=CreateSceneEntity("scenes/npc/sphere03/fgb_doit_nags09.vcd"),idlerandomonrepeat=true, idlerepeat=true, idleminsecs=1.5, idlemaxsecs=3.0, postdelay=0.1,next=nil,char="wheatley", noDingOff=true, noDingOn=true, idle=true, talkover=true, idlegroup="socketwheatleynag", idleorderingroup=1, idleunder=1}

SceneTable["-760_02"] = {vcd=CreateSceneEntity("scenes/npc/sphere03/fgb_plugin_nags06.vcd"),postdelay=0.1,next="-760_02a",char="wheatley",noDingOff=true,noDingOn=true, talkover=true, idlegroup="socketwheatleynag",idleorderingroup=2, idleindex=2}
SceneTable["-760_02a"] = {vcd=CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer13.vcd"),postdelay=0.1,next="-760_02b",char="glados",noDingOff=true,noDingOn=true, talkover=true, idlegroup="socketwheatleynag",idleorderingroup=2, idleunder=2}
SceneTable["-760_02b"] = {vcd=CreateSceneEntity("scenes/npc/sphere03/fgb_doit_nags06.vcd"),postdelay=0.1,next="-760_02c",char="wheatley",noDingOff=true,noDingOn=true, talkover=true, idlegroup="socketwheatleynag",idleorderingroup=2, idleunder=2}
SceneTable["-760_02c"] = {vcd=CreateSceneEntity("scenes/npc/sphere03/fgb_doit_nags03.vcd"),postdelay=1.0,next=nil,char="wheatley",noDingOff=true,noDingOn=true, talkover=true, idlegroup="socketwheatleynag",idleorderingroup=2, idleunder=2}

SceneTable["-760_03"] = {vcd=CreateSceneEntity("scenes/npc/sphere03/fgb_plugin_nags08.vcd"),postdelay=0.1,next="-760_03a",char="wheatley",noDingOff=true,noDingOn=true, talkover=true,idlegroup="socketwheatleynag",idleorderingroup=3, idleindex=3}
SceneTable["-760_03a"] = {vcd=CreateSceneEntity("scenes/npc/glados/sp_a2_core03.vcd"),postdelay=0.1,next=nil,char="glados",noDingOff=true,noDingOn=true, talkover=true, idlegroup="socketwheatleynag",idleorderingroup=3, idleunder=3}

SceneTable["-760_04"] = {vcd=CreateSceneEntity("scenes/npc/sphere03/fgb_plugin_nags07.vcd"),postdelay=0.1,next="-760_04a",char="wheatley",noDingOff=true,noDingOn=true,talkover=true,idlegroup="socketwheatleynag",idleorderingroup=4, idleindex=4}
SceneTable["-760_04a"] = {vcd=CreateSceneEntity("scenes/npc/glados/sp_a2_core04.vcd"),postdelay=0.1,next=nil,char="glados",noDingOff=true,noDingOn=true, talkover=true, idlegroup="socketwheatleynag",idleorderingroup=4, idleunder=4}

SceneTable["-760_05"] = {vcd=CreateSceneEntity("scenes/npc/sphere03/fgb_plugin_nags05.vcd"),postdelay=0.1,next="-760_05a",char="wheatley",noDingOff=true,noDingOn=true,talkover=true,idlegroup="socketwheatleynag",idleorderingroup=5, idleindex=5}
SceneTable["-760_05a"] = {vcd=CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer13.vcd"),postdelay=0.1,next=nil,char="glados",noDingOff=true,noDingOn=true, talkover=true, idlegroup="socketwheatleynag",idleorderingroup=5, idleunder=5}

SceneTable["-760_06"] = {vcd=CreateSceneEntity("scenes/npc/sphere03/fgb_plugin_nags09.vcd"),postdelay=0.1,next="-760_06a",char="wheatley",noDingOff=true,noDingOn=true,talkover=true,idlegroup="socketwheatleynag",idleorderingroup=6, idleindex=6}
SceneTable["-760_06a"] = {vcd=CreateSceneEntity("scenes/npc/glados/sp_a2_core04.vcd"),postdelay=0.1,next=nil,char="glados",noDingOff=true,noDingOn=true, talkover=true, idlegroup="socketwheatleynag",idleorderingroup=6, idleunder=6}

SceneTable["-760_07"] = {vcd=CreateSceneEntity("scenes/npc/sphere03/fgb_plugin_nags11.vcd"),postdelay=0.1,next="-760_07a",char="wheatley",noDingOff=true,noDingOn=true, talkover=true,idlegroup="socketwheatleynag",idleorderingroup=7, idleindex=7}
SceneTable["-760_07a"] = {vcd=CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer12.vcd"),postdelay=0.1,next=nil,char="glados",noDingOff=true,noDingOn=true, talkover=true, idlegroup="socketwheatleynag",idleorderingroup=7, idleunder=7}

function StartWheatleyPluginScene()
	GladosPlayVcd( -760 )
end

function StartWheatleyPluginNag()
	GladosPlayVcd( -761 )
end

function StopWheatleyPluginNag()
	nuke()
end

-- ====================================== Wheatley Plugged in
SceneTable["-24_01"] = 
{
    vcd=CreateSceneEntity("scenes/npc/announcer/gladosbattle14.vcd"), --Substitute core accepted. [UPGRADED]
    char="announcer",
    postdelay=0.1,
    predelay = 0.0,
    next="-24_02",
    noDingOff=true,
    noDingOn=true,
    talkover=true,
    fires=
    {
        {entity="core_transfer_nag_relay",input="kill",parameter="",delay=0.0, fireatstart=true},
        {entity="glados_lookat_wheatley",input="trigger",parameter="",delay=0.0, fireatstart=true}
    }
}

SceneTable["-24_02"] = 
{
    vcd=CreateSceneEntity("scenes/npc/announcer/gladosbattle15.vcd"), --Substitute core, are you ready to start the procedure? [UPGRADED]
    char="announcer",
    postdelay=0.0,
    predelay = 0.0,
    next= "-24_03",
    noDingOff=true,
    noDingOn=true,
    talkover=true
}

SceneTable["-24_03"] = 
{
    vcd=CreateSceneEntity("scenes/npc/sphere03/fgb_ready_glados01.vcd"),    -- Yes!
    char="wheatley",
    postdelay=0.0,
    predelay = 0.0,
    next= "-24_04",
    noDingOff=true,
    noDingOn=true
}

SceneTable["-24_04"] = 
{
    vcd=CreateSceneEntity("scenes/npc/announcer/gladosbattle16.vcd"), --Corrupted core, are you ready to start the procedure? [UPGRADED]
    char="announcer",
    postdelay=0.0,
    predelay = 0.0,
    next= "-24_05",
    noDingOff=true,
    noDingOn=true,
    fires=
    {
        {entity="@glados",input="runscriptcode",parameter="sp_sabotage_glados_specials(1)",delay=0.7},
        {entity="glados_chamber_body",input="setanimation",parameter="gladosbattle_xfer07",delay=0,fireatstart=true}, -- ANIM
        {entity="glados_chamber_body",input="setdefaultanimation",parameter="glados_idle_agitated_more",delay=0,fireatstart=true}
    }
}

SceneTable["-24_05"] = 
{
    vcd=CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer07.vcd"), --No!
    char="glados",
    postdelay=0.4,
    predelay = 0.0,
    next= "-24_06",
    noDingOff=true,
    noDingOn=true,
    talkover=true
}

SceneTable["-24_06"] = 
{
    vcd=CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer08.vcd"),     -- Nonononono!
    char="glados",
    postdelay=0.0,
    predelay = 0.0,
    next= "-24_07",
    noDingOff=true,
    noDingOn=true,
    talkover=true
}

SceneTable["-24_07"] = 
{
    vcd=CreateSceneEntity("scenes/npc/announcer/gladosbattle17.vcd"),    --Stalemate detected. Transfer procedure cannot continue. [UPGRADED]
    char="announcer",
    postdelay=0.0,
    predelay = 0.0,
    next= "-24_08",
    noDingOff=true,
    noDingOn=true
}

SceneTable["-24_08"] = 
{
    vcd=CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer10.vcd"), --Yes! 
    char="glados",
    postdelay=0.0,
    predelay = 0.0,
    next= "-24_09",
    noDingOff=true,
    noDingOn=true,
    talkover=true,
    fires=
    {
        {entity="@glados",input="runscriptcode",parameter="sp_sabotage_glados_specials(2)",delay=0.3,fireatstart=true}
    }
}

SceneTable["-24_09"] = 
{
    vcd = CreateSceneEntity("scenes/npc/announcer/gladosbattle18.vcd"), -- ...unless a stalemate associate is present to press the stalemate resolution button. [UPGRADED]
    char = "announcer",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-24_10",
    noDingOff = true,
    noDingOn = true,
    talkover = true,
    fires =
    {
        {entity = "open_stalemate_room_doors_relay", input = "trigger", parameter = "", delay = 0.0},
        {entity = "display_button_press_instructions_relay", input = "Trigger", parameter = "", delay = 0.0}
    }
}

SceneTable["-24_10"] = 
{
    vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_leave_me_in01.vcd"), -- Leave me in! Leave me in! Go press it!
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.4,
    next = "-24_11",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-24_11"] = 
{
    vcd = CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer13.vcd"), -- Don't do it.
    char = "glados",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-24_12",
    noDingOff = true,
    noDingOn = true,
    fires =
    {
        {entity = "glados_lookat_player", input = "trigger", parameter = "", delay = 0.0, fireatstart = true}
    }
}

SceneTable["-24_12"] = 
{
    vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_doit_nags01.vcd"), -- Yes, do do it!
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-24_13",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-24_13"] = 
{
    vcd = CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer11.vcd"), -- Don't press that button. You don't know what you're doing.
    char = "glados",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-24_14",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-24_14"] = 
{
    vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_stalemate_nags05.vcd"), -- I think she's lying.
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.0,
    next = nil,
    noDingOff = true,
    noDingOn = true,
    fires =
    {
        {entity = "@glados", input = "RunScriptCode", parameter = "StartStalemateButtonPressNag()", delay = 0}
    }
}

-- Stalemate button press nags
SceneTable["-755_01"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/bw_a4_2nd_first_test_solve_nags06.vcd"),
	predelay = {7, 12},
	postdelay = 0.1,
	next = "-755_02",
	char = "wheatley",
	noDingOff = true,
	noDingOn = true,
	idle = true,
	talkover = true,
	idleminsecs = 7.0,
	idlemaxsecs = 12.0,
	idlegroup = "pressthebutton",
	idleorderingroup = 1,
  }
  
  SceneTable["-755_02"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/bw_a4_2nd_first_test_solve_nags07.vcd"),
	postdelay = 3.1,
	next = "-755_03",
	char = "wheatley",
	noDingOff = true,
	noDingOn = true,
	talkover = true,
	idlegroup = "pressthebutton",
	idleorderingroup = 2,
  }
  
  SceneTable["-755_03"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/bw_a4_2nd_first_test_solve_nags08.vcd"),
	postdelay = 3.1,
	next = "-755_04",
	char = "wheatley",
	noDingOff = true,
	noDingOn = true,
	talkover = true,
	idlegroup = "pressthebutton",
	idleorderingroup = 3,
  }
  
  SceneTable["-755_04"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/bw_a4_2nd_first_test_solve_nags09.vcd"),
	postdelay = 3.1,
	next = "-755_05",
	char = "wheatley",
	noDingOff = true,
	noDingOn = true,
	talkover = true,
	idlegroup = "pressthebutton",
	idleorderingroup = 4,
  }
  
  SceneTable["-755_05"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/bw_a4_2nd_first_test_solve_nags10.vcd"),
	postdelay = 3.1,
	next = nil, -- Correctly using nil for no next scene
	char = "wheatley",
	noDingOff = true,
	noDingOn = true,
	talkover = true,
	idlegroup = "pressthebutton",
	idleorderingroup = 5,
  }

SceneTable["-72_01"] =
{
	vcd=CreateSceneEntity("scenes/npc/sphere03/sp_a2_core_pullmeout01.vcd"),
	char="wheatley",
	postdelay=0.0,
	predelay = 0.0,
	next=nil,
	noDingOff=true,
	noDingOn=true,
	talkover = true
}

--Wheatley "Oh yes she is" line
SceneTable["-73_01"] =
{
	vcd=CreateSceneEntity("scenes/npc/sphere03/fgb_ready_glados06.vcd"),
	char="wheatley",
	postdelay=0.0,
	predelay = 0.0,
	next=nil,
	noDingOff=true,
	noDingOn=true,
	talkover = true
}

function StartStalemateButtonPressNag()
	GladosPlayVcd( -755 )
end

function StopStalemateButtonPressNag()
	nuke()	
end

function sp_sabotage_glados_specials(arg)
	if arg == 1 then
		GladosPlayVcd(-73)
	elseif arg == 2 then
		GladosPlayVcd(-72)
	end
end

-- ButtonDenied
SceneTable["-25_01"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer14.vcd"), --Not so fast!
	postdelay = 0.3,
	next = "-25_02",
	char = "glados",
	noDingOff = true,
	noDingOn = true,
	talkover = false,
	fires = {
	  {entity = "glados_chamber_body", input = "setanimation", parameter = "gladosbattle_xfer14", delay = 0, fireatstart = true} --ANIM
	}
  }
  
  SceneTable["-25_02"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer15.vcd"), --Think about this.
	postdelay = 0.2,
	next = "-25_03",
	char = "glados",
	noDingOff = true,
	noDingOn = true,
	talkover = false
  }
  
  SceneTable["-25_03"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer16.vcd"), --You need to be a trained stalemate associate to press that button. You're unqualified. I know this sounds like an obvious ploy, but I'm really not joking.
	postdelay = 0.2,
	next = "-25_04",
	char = "glados",
	noDingOff = true,
	noDingOn = true,
	talkover = false
  }
  
  --Don't listen to her! It IS true that you don't have the qualifications. But you've got something more important than that. A finger, with which to press that button, so that she won't kill us.
  SceneTable["-25_04"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_stalemate_nags06.vcd"),
	postdelay = 0.0,
	next = "-25_05",
	char = "wheatley",
	noDingOff = true,
	noDingOn = true,
	talkover = false
  }
  
  --Impersonating a stalemate associate. I just added that to the list. It's a list I made of all the things you've done. Well, it's a list that I AM making, because you're still doing things right now, even though I'm telling you to stop. Stop, by the way.
  SceneTable["-25_05"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/gladosbattle_xfer17.vcd"),
	postdelay = 0.2,
	next = "-25_06",
	char = "glados",
	noDingOff = true,
	noDingOn = true,
	talkover = false
  }
  
  --I... that's probably correct. But where it is incorrect is while I've been stalling you WE JUST PRESSED THE BUTTON! USE THE MOMENT OF CONFUSION I'VE JUST CREATED TO PRESS THE BUTTON!
  SceneTable["-25_06"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_stalemate_nags12.vcd"),
	postdelay = 3.0,
	next = "-25_07",
	char = "wheatley",
	noDingOff = true,
	noDingOn = true,
	talkover = false
  }
  
  --Have I ever told you the qualities I love most in you? In order: Number one: resolving things, disputes highest among them. Number one, tied: Button-pushing.
  SceneTable["-25_07"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_stalemate_nags08.vcd"),
	postdelay = 3.0,
	next = "-25_08",
	char = "wheatley",
	noDingOff = true,
	noDingOn = true,
	talkover = false
  }
  
  --First thing I thought about you...
  SceneTable["-25_08"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_stalemate_nags07.vcd"),
	postdelay = 3.0,
	next = "-25_08a",
	char = "wheatley",
	noDingOff = true,
	noDingOn = true,
	talkover = false
  }
  
  --Don't want to rush you...
  SceneTable["-25_08a"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_stalemate_nags09.vcd"),
	postdelay = 3.0,
	next = "-25_09",
	char = "wheatley",
	noDingOff = true,
	noDingOn = true,
	talkover = false
  }
  
  --Here's a good idea...
  SceneTable["-25_09"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_stalemate_nags04.vcd"),
	postdelay = 0.1,
	next = nil,  -- Correctly using nil
	char = "wheatley",
	noDingOff = true,
	noDingOn = true,
	talkover = false,
	fires = {
	  {entity = "@glados", input = "RunScriptCode", parameter = "StartStalemateButtonPressNag()", delay = 0}
	}
  }

function StartStalemateRoomLeadLights()
	SetArmSkinOff()
	
	StalemateRoomLeadLightsOn = 1
	
	EntFire("@glados", "RunScriptCode", "StalemateRoomLeadLights()", 0 )
end

function StopStalemateRoomLeadLights()
	StalemateRoomLeadLightsOn = 0

	EntFire("stalemate_runway_lights_relay", "cancelpending", "", 0 )
	EntFire("@glados", "RunScriptCode", "SetArmSkinOn()", 2.7 )
end

-- ============================================================================
-- Causes arm lights to animate towards stalemate room
-- ============================================================================
function StalemateRoomLeadLights()
    if StalemateRoomLeadLightsOn then
        local delay = 0

        -- blink right side of room
        for i = 12, 3, -1 do
            EntFire("chamber_arm_" .. i, "skin", "1", delay)
            EntFire("chamber_arm_" .. i, "skin", "2", delay + 0.1)
            delay = delay + 0.2
        end

        delay = 0

        -- blink left side of room
        for i = 14, 23 do
            EntFire("chamber_arm_" .. i, "skin", "1", delay)
            EntFire("chamber_arm_" .. i, "skin", "2", delay + 0.1)
            delay = delay + 0.2
        end

        EntFire("stalemate_runway_lights_relay", "trigger", "", 2)
    end
end

-- ============================================================================
-- Causes arm lights to switch from blue to red when Wheatley turns evil
-- ============================================================================
function CoreRoomPanelLookTurnRed()
    local delay = 0

    -- Set all the skins to the off state
    EntFire("chamber_arm_*", "skin", "2", 0)

    -- Set the first panel to have the red light on
    EntFire("chamber_arm_1", "skin", "1", delay)

    delay = delay + 0.2

    -- blink right side of room
    for i = 2, 12 do
        EntFire("chamber_arm_" .. i, "skin", "1", delay)
        delay = delay + 0.1
    end

    delay = 0

    -- blink left side of room
    for i = 24, 13, -1 do
        EntFire("chamber_arm_" .. i, "skin", "1", delay)
        delay = delay + 0.2
    end
end


function SetArmSkinOff()
	EntFire( "chamber_arm_*", "skin", "2", 0 )
end

function SetArmSkinOn()
	EntFire( "chamber_arm_*", "skin", "0", 0 )
end

-- track stalemate room light state
StalemateRoomLeadLightsOn = 0

-- Stalemate button pressed
SceneTable ["-45_01" ] =
{
	vcd = CreateSceneEntity("scenes/npc/announcer/gladosbattle20.vcd"),
	char = "announcer",
	postdelay = 0.01,
	predelay = 0.0,
	next = nil,
	noDingOff = true,
	noDingOn = true,
	fires=
	{	
		{entity="@glados",input="runscriptcode",parameter="sp_a2_core_leave_annex_nag()",delay=7.0}
	}
}


SceneTable["-26_01"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/sp_sabotage_glados_dropped01.vcd"), -- ahhh!
	char = "glados",
	postdelay = 0.5,
	predelay = 0.0,
	next = "-26_02",
	noDingOff = true,
	noDingOn = true,
	fires = {
	  {entity = "glados_chamber_body", input = "setanimation", parameter = "Sp_sabotage_glados_dropped", delay = 0, fireatstart = true}, -- ANIM
	  {entity = "glados_chamber_body", input = "setdefaultanimation", parameter = "glados_pit_eyegrab", delay = 0, fireatstart = true}
	}
  }
  
  SceneTable["-26_02"] = {
	vcd = CreateSceneEntity("scenes/npc/announcer/gladosbattle19.vcd"), -- Stalemate Resolved. Core Transfer Initiated. [UPGRADED]
	char = "announcer",
	postdelay = 0.5,
	predelay = 0.0,
	next = nil,
	noDingOff = true,
	noDingOn = true,
	fires = {
	  {entity = "@glados", input = "runscriptcode", parameter = "sp_a2_core_leave_annex_nag()", delay = 3.0}
	}
  }

function a2_core_stalemate_button_pressed()
	GladosPlayVcd(-45)
end

-- Wheatley transfer scene
SceneTable["-4_01"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_xfer_start03.vcd"), -- Here I go!
	char = "wheatley",
	postdelay = 0.6,
	predelay = 0.0,
	next = "-4_02",
	noDingOff = true,
	noDingOn = true,
	talkover = true,
  }
  
  SceneTable["-4_02"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_xfer_start04.vcd"), -- Wait, what if this hurts? What if this really hurts?
	char = "wheatley",
	postdelay = 0.0,
	predelay = 0.0,
	next = "-4_03",
	noDingOff = true,
	noDingOn = true,
	talkover = true,
  }
  
  SceneTable["-4_03"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/fgbwheatleytransfer03.vcd"), -- Oh it will.  Believe me, it will.
	char = "glados",
	postdelay = 0.0,
	predelay = 0.0,
	next = "-4_04",
	noDingOff = true,
	noDingOn = true,
	fires = {
	  {entity = "glados_chamber_body", input = "setanimation", parameter = "fgbwheatleytransfer03", delay = 0, fireatstart = true}, -- ANIM
	  {entity = "glados_chamber_body", input = "setdefaultanimation", parameter = "glados_pit_eyegrab", delay = 0, fireatstart = true}
	}
  }
  
  SceneTable["-4_04"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/fgb_transfer_pain01.vcd"), -- Are you just saying that, or is it really going to hurt? You're just saying that, no, you're not aren't you, it's really going to hurt, isn't it?
	char = "wheatley",
	postdelay = 0.0,
	predelay = 0.0,
	next = "-4_05",
	noDingOff = true,
	noDingOn = true,
  }
  
  
  SceneTable["-4_05"] = {
	vcd = CreateSceneEntity("scenes/npc/sphere03/sp_a2_core_goingtohurt01.vcd"), -- Exactly how much pain are we tAGGGHHH!
	char = "wheatley",
	postdelay = 0.0,
	predelay = 0.0,
	next = nil,
	noDingOff = true,
	noDingOn = true,
	talkover = true,
	fires = {
	  {entity = "maintenance_pit_script", input = "RunScriptCode", parameter = "OpenMaintenancePitDoor()", delay = 0.7, fireatstart = true},
	  {entity = "@glados", input = "RunScriptCode", parameter = "PitHandsGrabGladosHead()", delay = 3.0, fireatstart = true},
	  {entity = "glados_pit_player_clip_relay", input = "trigger", parameter = "", delay = 0.8, fireatstart = true}, -- pushes player off of maintenance pit
	  {entity = "@glados", input = "RunScriptCode", parameter = "GladosCharacterStopScene('wheatley')", delay = 0.2} -- idon't know this is just hack to prevent wheatley speaking twice :/ and breaking whole sequence
	}
  }
  
  
  -- Glados initial grab by small pit arms
  SceneTable["-27_00"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/fgbgladostransfer15.vcd"), -- Get your hands off me!
	char = "glados",
	postdelay = 0.1,
	predelay = 0.0,
	next = nil,
	noDingOff = true,
	noDingOn = true,
	talkover = true,
	fires = {
	  {entity = "pitgrab_player_looking_at_glados_aisc", input = "enable", parameter = "", delay = 0}
	}
  }

  SceneTable["-27_01"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/sp_a2_core_drag_to_hell01.vcd"),
	char = "glados",
	postdelay = 0.0,
	predelay = 0.0,
	next = nil,
	noDingOff = true,
	noDingOn = true,
	fires = {
	  {entity = "glados_head_removal_spark_timer", input = "enable", parameter = "", delay = 1, fireatstart = true},
	  {entity = "glados_head_removal_spark_timer", input = "disable", parameter = "", delay = 3, fireatstart = true},
	  {entity = "@glados", input = "runscriptcode", parameter = "CoreRoomWiltAnim()", delay = 7.0, fireatstart = true},
	  {entity = "maintenance_pit_script", input = "RunScriptCode", parameter = "EjectGladosHead()", delay = 0.0},
	  {entity = "begin_wheatley_emergence_relay", input = "trigger", parameter = "", delay = 2.0},
	  {entity = "@glados", input = "RunScriptCode", parameter = "CoreTransferCompleted()", delay = 2.5},
	  {entity = "maintenance_pit_script", input = "RunScriptCode", parameter = "RevealWheatley()", delay = 2.0},
	}
  }

  -- Glados gibberish nag
SceneTable["-28_01"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/sp_sabotage_glados_gibberish01.vcd"),
	idlerandom = true,
	idlerepeat = true,
	postdelay = 0.1,
	next = nil,
	char = "glados",
	noDingOff = true,
	noDingOn = true,
	idle = true,
	talkover = true,
	idleminsecs = 0.0,
	idlemaxsecs = 0.0,
	idlegroup = "gibberish",
	idleorderingroup = 1,
  }
  SceneTable["-28_02"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/sp_sabotage_glados_gibberish03.vcd"),
	postdelay = 0.1,
	next = nil,
	char = "glados",
	noDingOff = true,
	noDingOn = true,
	talkover = true,
	idlegroup = "gibberish",
	idleorderingroup = 2,
  }
  SceneTable["-28_03"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/sp_sabotage_glados_gibberish04.vcd"),
	postdelay = 0.1,
	next = nil,
	char = "glados",
	noDingOff = true,
	noDingOn = true,
	talkover = true,
	idlegroup = "gibberish",
	idleorderingroup = 3,
  }
  SceneTable["-28_04"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/sp_sabotage_glados_gibberish05.vcd"),
	postdelay = 0.1,
	next = nil,
	char = "glados",
	noDingOff = true,
	noDingOn = true,
	talkover = true,
	idlegroup = "gibberish",
	idleorderingroup = 4,
  }
  SceneTable["-28_05"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/sp_sabotage_glados_gibberish06.vcd"),
	postdelay = 0.1,
	next = nil,
	char = "glados",
	noDingOff = true,
	noDingOn = true,
	talkover = true,
	idlegroup = "gibberish",
	idleorderingroup = 5,
  }
  SceneTable["-28_06"] = {
	vcd = CreateSceneEntity("scenes/npc/glados/sp_sabotage_glados_gibberish07.vcd"),
	postdelay = 0.1,
	next = nil,
	char = "glados",
	noDingOff = true,
	noDingOn = true,
	talkover = true,
	idlegroup = "gibberish",
	idleorderingroup = 6,
  }

if curMapName == "sp_a2_core" then
	GlobalPanelAnimationList = {}

	sp_a2_core_xfer_left_annex = false

	for i = 1, 25 do
		local entry = {}

		local random_anim = math.random(1,4)
		entry = {
			panel_name = "chamber_arm_" .. i,
			wilt_animation = "core_arms_WILT_0" .. random_anim,
			unwilt_animation = "core_arms_UNWILT_0" .. random_anim,

			lookup_small_animation = "core_arms_LOOKUP_SMALL_0" .. random_anim,
			lookup_animation = "core_arms_LOOKUP_0" .. random_anim,
			lookup_idle_animation = "core_arms_LOOKUP_IDLE_0" .. random_anim,
			lookup_return_animation = "core_arms_LOOKUP_RETURN_0" .. random_anim
		}

		table.insert(GlobalPanelAnimationList, entry)
	end
end

function CoreRoomRippleAnim()
	EntFire( "chamber_arm_*", "setanimation", "core_ripple", 0 )
end

function CoreRoomWiltAnim()
	-- ensure that the panels have been swapped (this may have occured already after stalemate, this is just a required failsafe)
	EntFire("swap_stalemate_panels_rl", "trigger", 0, 0 )

	for index, val in ipairs(GlobalPanelAnimationList) do
		-- ensure that the panels have been swapped (this may have occured already after stalemate, this is just a required failsafe)
		EntFire( GlobalPanelAnimationList[index].panel_name, "SetAnimation", GlobalPanelAnimationList[index].wilt_animation, 0 )
	end

	-- blink the skin from off to blue
	EntFire( "blink_panel_error_lights_timer", "enable", 0, 0 )
end

function CoreRoomUnWiltAnim()
	-- stop the blinking
	EntFire( "blink_panel_error_lights_timer", "disable", 0, 0 )

	EntFire("@glados", "RunScriptCode", "SetArmSkinOn()", 1.1 )
	EntFire("@glados", "RunScriptCode", "SetArmSkinOff()", 1.2 )
	
	EntFire("@glados", "RunScriptCode", "SetArmSkinOn()", 1.3 )
	EntFire("@glados", "RunScriptCode", "SetArmSkinOff()", 1.4 )
	
	EntFire("@glados", "RunScriptCode", "SetArmSkinOn()", 1.5 )
	
	-- ripple the room once the light blinking stops
	EntFire("@glados", "RunScriptCode", "CoreRoomRippleAnim()", 1.5 )

	for index, val in ipairs(GlobalPanelAnimationList) do
		EntFire( GlobalPanelAnimationList[index].panel_name, "SetAnimation", GlobalPanelAnimationList[index].unwilt_animation, 0 )
	end
end

function CoreRoomHappyCounterClockwiseAnim()
    EntFire("panel_wave_sound", "playsound", 0, 0)

    local delay = 0
    -- play wave counter clockwise, starting at the middle
    for i = 16, 0, -1 do
        EntFire("chamber_arm_" .. i, "setanimation", "core_arms_WIGGLE_01", delay)
        delay = delay + 0.1
    end

    -- play wave counter clockwise, picking up from start
    for i = 24, 16, -1 do
        EntFire("chamber_arm_" .. i, "setanimation", "core_arms_WIGGLE_01", delay)
        delay = delay + 0.1
    end

    -- now go the other way!
    for i = 16, 24, 1 do
        EntFire("chamber_arm_" .. i, "setanimation", "core_arms_WIGGLE_02", delay)
        delay = delay + 0.08
    end

    -- now go the other way!
    for i = 1, 16, 1 do
        EntFire("chamber_arm_" .. i, "setanimation", "core_arms_WIGGLE_02", delay)
        delay = delay + 0.08
    end

    -- Have wheatley look at the player once the animations are done
    EntFire("glados_lookat_player", "trigger", "", delay)
end

-- ============================================================================
-- Happy flappin' -- flap the panels with random animations (triggered with juggling)
-- ============================================================================
function CoreRoomHappyFlappingAnim()
    EntFire("panel_juggle_sound", "playsound", 0, 0)

    -- flap all the panels
    for i = 1, 24 do
        EntFire("chamber_arm_" .. i, "setanimation", "core_arms_HAPPY_" .. math.random(1, 12), 0)
    end
end

-- ============================================================================
-- Plays the panel animations for the wheatley evil chuckle scene
-- ============================================================================
function CoreRoomEvilLaughPanelAnim()
    for index, val in pairs(GlobalPanelAnimationList) do
        EntFire(GlobalPanelAnimationList[index].panel_name, "SetAnimation", GlobalPanelAnimationList[index].lookup_small_animation, 0)
    end
end

-- ============================================================================
-- Makes the panels look at the player
-- ============================================================================
function CoreRoomPanelLookAnim()
    for index, val in pairs(GlobalPanelAnimationList) do
        EntFire(GlobalPanelAnimationList[index].panel_name, "SetAnimation", GlobalPanelAnimationList[index].lookup_animation, 0)
        EntFire(GlobalPanelAnimationList[index].panel_name, "SetDefaultAnimation", GlobalPanelAnimationList[index].lookup_idle_animation, 0.1)
    end
end

-- ============================================================================
-- Makes the panels return to their normal position
-- ============================================================================
function CoreRoomPanelReturnToNormalAnim()
    for index, val in pairs(GlobalPanelAnimationList) do
        EntFire(GlobalPanelAnimationList[index].panel_name, "SetAnimation", GlobalPanelAnimationList[index].lookup_return_animation, 0)
        EntFire(GlobalPanelAnimationList[index].panel_name, "SetDefaultAnimation", "", 0.1)
    end
end

-- ============================================================================
-- Causes the room to ripple in a pattern starting from the left and right
-- of the stalemate room and ending at the back of the room
-- ============================================================================
function CoreRoomLeftRightWaveAnim()
    local delay = 0

    -- ripple right side of room
    for i = 1, 11 do
        EntFire("chamber_arm_" .. i, "setanimation", "core_ripple", delay)
        delay = delay + 0.2
    end

    delay = 0

    -- ripple left side of room
    for i = 24, 12, -1 do
        EntFire("chamber_arm_" .. i, "setanimation", "core_ripple", delay)
        delay = delay + 0.2
    end
end

SceneTable["-5_01"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_body_intro01.vcd"), -- Wow, check me out!
    char = "wheatley",
    postdelay = 0.2,
    predelay = 0.0,
    next = "-5_01a",
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "wheatley_body", input = "setanimation", parameter = "glados_wheatley_body_intro01", delay = 0, fireatstart = true }, -- ANIM
        { entity = "@glados", input = "runscriptcode", parameter = "CoreRoomUnWiltAnim()", delay = 0, fireatstart = true }
    }
}

SceneTable["-5_01a"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_body_intro04.vcd"), -- We did it! I can't believe we did it! I'm in control of the whole facility now!
    char = "wheatley",
    postdelay = 0.8,
    predelay = 0.0,
    next = "-5_02",
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "@glados", input = "RunScriptCode", parameter = "CoreRoomHappyCounterClockwiseAnim()", delay = 1, fireatstart = true } -- ANIM
    }
}

SceneTable["-5_02"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_body_intro03.vcd"), -- Ha ha ha! Look at me! Not too bad, eh? Giant robot. Massive!
    char = "wheatley",
    postdelay = 0.4,
    predelay = 0.0,
    next = "-5_03",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-5_03"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_body_intro05.vcd"), -- Oh! Right, the escape lift! I'll call it now.
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-5_04",
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "deploy_exit_elevator_relay", input = "Trigger", parameter = "", delay = 0.0, fireatstart = true }
    }
}

SceneTable["-5_04"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_lift01.vcd"), -- lift called, in you go
    char = "wheatley",
    postdelay = 1.0,
    predelay = 1.0,
    next = "-5_05",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-5_05"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_body_intro12.vcd"),
    char = "wheatley",
    postdelay = 0.7,
    predelay = 0.0,
    next = "-5_07",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-5_07"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_lift_nags01.vcd"),
    char = "wheatley",
    postdelay = 0.6,
    predelay = 0.0,
    next = "-5_08",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-5_08"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_lift_nags02.vcd"),
    char = "wheatley",
    postdelay = 0.2,
    predelay = 0.0,
    next = "-5_09",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-5_09"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_lift_nags03.vcd"),
    char = "wheatley",
    postdelay = 1.8,
    predelay = 0.0,
    next = "-5_10",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-5_10"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_lift_nags04.vcd"),
    char = "wheatley",
    postdelay = 0.3,
    predelay = 0.0,
    next = "-5_11",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-5_11"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_lift_nags05.vcd"),
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.0,
    next = nil,
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "@glados", input = "RunScriptCode", parameter = "StartWheatleyElevatorNag()", delay = 3.0 }
    }
}

function StopWheatleyElevatorNag()
	nuke()
end

SceneTable["-14_01"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_body_intro14.vcd"), -- Wheatley: I knew it was gonna be cool being in charge of everything, but... WOW, is this cool! This body is amazing!
    char = "wheatley",
    postdelay = 0.7,
    predelay = 0.0,
    next = "-14_05",
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "wheatley_body", input = "setanimation", parameter = "glados_wheatley_heel_turn07", delay = 0, fireatstart = true }, -- ANIM
        { entity = "start_juggling_relay", input = "Trigger", parameter = "", delay = 3, fireatstart = true },
        { entity = "stop_juggling_relay", input = "Trigger", parameter = "", delay = 3 },
        { entity = "@glados", input = "RunScriptCode", parameter = "CoreRoomHappyFlappingAnim()", delay = 3, fireatstart = true }
    }
}

SceneTable["-14_05"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_body_intro15.vcd"), -- Wheatley: And check this out! I'm brilliant now!
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-14_05a",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-14_05a"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_spanish01.vcd"), -- [spanish]
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-14_05b",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-14_05b"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_body_intro16.vcd"), -- I don't know what I just said, but I can find out.
    char = "wheatley",
    postdelay = 0.6,
    predelay = 0.0,
    next = "-14_06",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-14_06"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_body_intro17.vcd"), -- Oh! The elevator. Sorry. [elevator moves]
    char = "wheatley",
    postdelay = 0.2,
    predelay = 0.0,
    next = "-14_07",
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "move_exit_elevator_to_escape_vista_relay", input = "Trigger", parameter = "", delay = 0.2 }
    }
}

SceneTable["-14_07"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_body_intro21.vcd"), -- Seriously, body amazing.
    char = "wheatley",
    postdelay = 0.2,
    predelay = 0.0,
    next = "-14_08",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-14_08"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_body_intro19.vcd"), -- Wheatley: Wow, look how small you are!
    char = "wheatley",
    postdelay = 0.1,
    predelay = 0.0,
    next = "-14_09",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-14_09"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_actually01.vcd"), -- But I'm HUGE. [evil laugh] Where did THAT come from?
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-14_10",
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "@glados", input = "RunScriptCode", parameter = "CoreRoomEvilLaughPanelAnim()", delay = 1.5, fireatstart = true }
    }
}

SceneTable["-14_10"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_actually05.vcd"), -- Wheatley: hahahah... whew... Actually... why do we have to leave right now?
    char = "wheatley",
    postdelay = 0.6,
    predelay = 0.0,
    next = "-14_11",
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "move_exit_elevator_to_smash_start", input = "Trigger", parameter = "", delay = 3.5, fireatstart = true },
        { entity = "wheatly_turns_evil_relay", input = "Trigger", parameter = "", delay = 3.5, fireatstart = true }
    }
}

SceneTable["-14_11"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_actually06.vcd"), -- Wheatley: Do you have any idea how good this feels?
    char = "wheatley",
    postdelay = 0.4,
    predelay = 0.0,
    next = "-14_13",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-14_13"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_heelturn06.vcd"), -- I did that! Me!
    char = "wheatley",
    postdelay = 0.4,
    predelay = 0.0,
    next = "-14_14",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-14_14"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/potatos_fgb_confrontation07.vcd"), -- Glados: You didn't do anything. SHE did all the work.
    char = "glados",
    postdelay = 0.4,
    predelay = 0.0,
    next = "-14_15",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-14_15"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/potatos_fgb_confrontation08.vcd"), -- Glados: You didn't do anything. SHE did all the work.
    char = "glados",
    postdelay = 0.6,
    predelay = 0.0,
    next = "-14_16",
    noDingOff = true,
    noDingOn = true
}

-- WHEATLEY grabs GLADOS

SceneTable["-14_16"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_heelturn08.vcd"), -- Wheatley: Oh really?
    char = "wheatley",
    postdelay = 0.3,
    predelay = 0.0,
    next = "-14_17",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-14_17"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_heelturn09.vcd"), -- Well, maybe it's time I DID something, then.
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-14_18",
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "maintenance_pit_script", input = "RunScriptCode", parameter = "MakePotatos()", delay = 1.3, fireatstart = true }
    }
}

SceneTable["-14_18"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/sp_sabotage_glados_confused04.vcd"), -- Glados: What are you doing?
    char = "glados",
    postdelay = 0.2,
    predelay = 0.0,
    next = "-14_20",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-14_20"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/potatos_emotion_no01.vcd"), -- Glados: No!
    char = "glados",
    postdelay = 0.1,
    predelay = 0.0,
    next = "-14_21",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-14_21"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/potatos_emotion_no02.vcd"), -- Glados: No!
    char = "glados",
    postdelay = 0.1,
    predelay = 0.0,
    next = "-14_22",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-14_22"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/potatos_emotion_no03.vcd"), -- Glados: No!
    char = "glados",
    postdelay = 0.0,
    predelay = 0.0,
    next = nil,
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "@glados", input = "RunScriptCode", parameter = "DialogDuringPotatosManufacture()", delay = 0.5 }
    }
}

-- Wheatley talks to player while PotatOS is being made

SceneTable["-10_01"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_heel_turn07.vcd"), -- I'm on to you too lady.. Now who's the boss?
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.0,
    next = nil,
    noDingOff = true,
    noDingOn = true,
    talkover = true,
    fires = {
        -- pop out the panels to look at player
        { entity = "@glados", input = "RunScriptCode", parameter = "CoreRoomPanelLookAnim()", delay = 1.8, fireatstart = true },
        { entity = "wheatley_evil_lightson_sound", input = "playsound", parameter = "", delay = 1.8, fireatstart = true },
        { entity = "@glados", input = "RunScriptCode", parameter = "CoreRoomPanelLookTurnRed()", delay = 2.3, fireatstart = true },

        -- start turn scene
        { entity = "maintenance_pit_script", input = "RunScriptCode", parameter = "PresentPotatos()", delay = 14, fireatstart = true }, -- long delay. This opens the doors and puts the little hands up with the potato.
        { entity = "maintenance_pit_script", input = "RunScriptCode", parameter = "DeliverPotatos()", delay = 0 }, -- pincer shows up, takes potato from small arms
        { entity = "@glados", input = "RunScriptCode", parameter = "PotatosPresentation()", delay = 2 }, -- starts the "ah! see that?" scene

        { entity = "potato_factory_effects_start_relay", input = "trigger", parameter = "", delay = 0, fireatstart = true },
        { entity = "potato_factory_effects_stop_relay", input = "trigger", parameter = "", delay = 0 },
        { entity = "glados_detached_head", input = "kill", parameter = "", delay = 3.5, fireatstart = true }, -- deletes glados's head
        { entity = "maintenance_pit_script", input = "RunScriptCode", parameter = "DeletePitArms()", delay = 5, fireatstart = true }, -- deletes all but the small pit arms

        { entity = "maintenance_pit_script", input = "RunScriptCode", parameter = "EnablePincer()", delay = 0, fireatstart = true }, -- enables visibility on the pincer arm
        { entity = "potatos_arrival_chime", input = "playsound", parameter = "", delay = 1.5 } -- sound when potatos shows up
    }
}

-- Wheatley displays potato battery for first time

SceneTable["-11_01"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_heel_turn10.vcd"), -- Ah!
    char = "wheatley",
    postdelay = 3.0,
    predelay = 0.0,
    next = "-11_02",
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "@glados", input = "RunScriptCode", parameter = "CoreRoomPanelReturnToNormalAnim()", delay = 0 }
    }
}

SceneTable["-11_02"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_potato01.vcd"), -- See that?
    char = "wheatley",
    postdelay = 0.5,
    predelay = 0.0,
    next = "-11_03",
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "maintenance_pit_script", input = "RunScriptCode", parameter = "DeleteSmallArms()", delay = 0, fireatstart = true }
    }
}

SceneTable["-11_03"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_potato02.vcd"), -- THAT is a potato battery. Now you live in it.
    char = "wheatley",
    postdelay = 0.5,
    predelay = 0.0,
    next = "-11_04",
    noDingOff = true,
    noDingOn = true,
    fires = {
        -- {entity="@glados",input="RunScriptCode",parameter="PotatosPresentation()",delay=0, fireatstart=true },
        { entity = "maintenance_pit_script", input = "RunScriptCode", parameter = "WigglePotatosMultiple()", delay = 0.0, fireatstart = true },
        { entity = "maintenance_pit_script", input = "RunScriptCode", parameter = "TapGladosGentlyOnGlass()", delay = 1.4, fireatstart = true }
    }
}

SceneTable["-11_04"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_potato04.vcd"), -- [chuckles]
    char = "wheatley",
    postdelay = -0.2,
    predelay = 0.0,
    next = "-11_05",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-11_05"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/potatos_fgb_confrontation05.vcd"), -- I know you.
    char = "glados",
    postdelay = 0.4,
    predelay = 0.0,
    next = nil,
    noDingOff = true,
    noDingOn = true,
    talkover = true,
    fires = {
        { entity = "begin_potatos_moron_scene_relay", input = "Trigger", parameter = "", delay = 0.5 }
    }
}

-- Elevator moron scene

SceneTable["-12_01"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_history_response01.vcd"), -- What?
    char = "wheatley",
    postdelay = 0.3,
    predelay = 0.0,
    next = "-12_07",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-12_07"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/potatos_fgb_confrontation11.vcd"), -- The engineers tried everything to make me... behave. To slow me down.
    char = "glados",
    postdelay = 0.2,
    predelay = 0.0,
    next = "-12_08",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-12_08"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/potatos_fgb_confrontation12.vcd"), -- Once, they even attached an Intelligence Dampening Sphere on me. It clung to my brain like a tumor, generating an endless stream of terrible ideas.
    char = "glados",
    postdelay = -9.5,
    predelay = 0.0,
    next = "-12_09",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-12_09"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_history_response13.vcd"), -- No! I'm not listening! I'm not listening!
    char = "wheatley",
    postdelay = -1.3,
    predelay = 0.0,
    next = "-12_10",
    noDingOff = true,
    noDingOn = true,
    talkover = true
}

SceneTable["-12_10"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/potatos_fgb_confrontation16.vcd"), -- It was your voice.
    char = "glados",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-12_11",
    noDingOff = true,
    noDingOn = true,
    talkover = true
}

SceneTable["-12_11"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_history_response12.vcd"), -- No! No! You're LYING! You're LYING!
    char = "wheatley",
    postdelay = -1.5,
    predelay = 0.0,
    next = "-12_12",
    noDingOff = true,
    noDingOn = true
}

SceneTable["-12_12"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/potatos_fgb_confrontation17.vcd"), -- Yes. You're the tumor.
    char = "glados",
    postdelay = 0.4,
    predelay = 0.0,
    next = "-12_12a",
    noDingOff = true,
    noDingOn = true,
    talkover = true
}

SceneTable["-12_12a"] = {
    vcd = CreateSceneEntity("scenes/npc/glados/potatos_fgb_defiance16.vcd"), -- You're not just a regular moron. You were designed to be a moron.
    char = "glados",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-12_13",
    noDingOff = true,
    noDingOn = true,
    talkover = true
}

SceneTable["-12_13"] = {
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_history_response05.vcd"), -- I am smart! I'm not a moron!
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-12_14",
    noDingOff = true,
    noDingOn = true,
    fires = {
        { entity = "maintenance_pit_script", input = "RunScriptCode", parameter = "TapGladosStronglyOnGlass()", delay = 0.6, fireatstart = true }
    }
}

SceneTable["-12_14"] = 
{
    -- YES YOU ARE! YOU'RE THE MORON THEY BUILT TO MAKE ME AN IDIOT! 
    vcd = CreateSceneEntity("scenes/npc/glados/potatos_fgb_confrontation19.vcd"),
    char = "glados",
    postdelay = 0.0,
    predelay = 0.0,
    next = "-12_15",
    noDingOff = true,
    noDingOn = true,
    talkover = true
}

SceneTable["-12_15"] = 
{
    -- How about NOW? Now who's a moron?
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_fgb_heel_turn15.vcd"),
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.0,
    next = nil,
    noDingOff = true,
    noDingOn = true,
    fires =
    {
        {entity = "maintenance_pit_script", input = "RunScriptCode", parameter = "PunchGladosThroughGlass()", delay = 0.5, fireatstart = true},
        {entity = "begin_elevator_conclusion_relay", input = "Trigger", parameter = "", delay = 0.0}
    }
}

--[[SceneTable["-12_16"] = 
{
    -- I hate to tell you this...
    vcd = CreateSceneEntity("scenes/npc/glados/potatos_fgbprefallelevator04.vcd"),
    char = "glados",
    postdelay = 0.0,
    predelay = 0.0,
    next = nil,
    noDingOff = true,
    noDingOn = true,
    fires = 
    {
    }
}]]--

-- Announcer: Please return to the core transfer bay
SceneTable["-45_01"] = 
{
    vcd = CreateSceneEntity("scenes/npc/announcer/gladosbattle20.vcd"), -- Stalemate resolved.
    char = "announcer",
    postdelay = 0.01,
    predelay = 0.0,
    next = nil,
    noDingOff = true,
    noDingOn = true,
    fires = 
    {   
        {entity = "@glados", input = "runscriptcode", parameter = "sp_a2_core_leave_annex_nag()", delay = 7.0}
    }
}

-- Elevator conclusion
SceneTable["-13_01"] = 
{
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_pitpunch02.vcd"), -- Could a moron punch you into this pit?
    char = "wheatley",
    postdelay = 1,
    predelay = 0.0,
    next = "-13_02",
    noDingOff = true,
    noDingOn = true,
    fires =
    {   
        {entity = "exit_elevator_groan_sound", input = "playsound", parameter = "", delay = 0.2},
        {entity = "elevator_prebreak_shake", input = "startshake", parameter = "", delay = 0.2}
    }
}

SceneTable["-13_02"] = 
{
    vcd = CreateSceneEntity("scenes/npc/sphere03/bw_sp_a2_core_pitpunch03.vcd"), -- uh oh.
    char = "wheatley",
    postdelay = 0.0,
    predelay = 0.0,
    next = nil,
    noDingOff = true,
    noDingOn = true,
    fires =
    {
        {entity = "@command", input = "command", parameter = "map_wants_save_disable 0", delay = 1.0},
        {entity = "begin_elevator_collapse_relay", input = "Trigger", parameter = "", delay = 0.0},
        {entity = "ghostAnim_potatos", input = "setanimation", parameter = "reach1_fall", delay = 0.0}
    }
}