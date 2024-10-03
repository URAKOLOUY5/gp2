-- SceneTableLookup
-- MAKE SURE THE INDEXES ON THIS ARRAY ARE NEGATIVE!!!!!

SceneTableLookup[-3000] = "-3000_01" -- potatos falling with player down the bottomless pit

SceneTableLookup[-3001] = "-3001_01" -- find potatos for first time

SceneTableLookup[-3002] = "-3002_01" -- pick up potatos for first time

SceneTableLookup[-3003] = "-3003_01" -- discover 'Caroline' in portrait in office

SceneTableLookup[-3120] = "-3120_01" -- Potatos sees the player enter the control room

SceneTableLookup[-3121] = "-3121_01" -- Player approaches the bird nest and Potatos convinces player to pick her up

SceneTableLookup[-3122] = "-3122_01" -- Potatos protests about being stabbed then talks about your mission together

SceneTableLookup[-3123] = "-3123_01" -- Potatos talks about having to get back into her body

SceneTableLookup[-3124] = "-3124_01" -- Potatos spots the paradox sign

SceneTableLookup[-3125] = "-3125_01" -- Potatos explains how she will use paradoxes to bring down Wheatley

SceneTableLookup[-3126] = "-3126_01" -- Potatos explains paradoxes if player doesn't look at the poster

SceneTableLookup[-3127] = "-3127_01" -- Potatos acknowledges that it's not a watertight plan

SceneTableLookup[-3128] = "-3128_01" -- Potatos reacts to the bird after the pump room in sp_a3_portal_intro

SceneTableLookup[-3129] = "-3129_01" -- Potatos thinks about Caroline

SceneTableLookup[-3150] = "-3150_01" -- Potatos wakes up second time in beginning of speed ramp


-- =================================================================
-- Called when PotatOS is falling down bottomless pit
-- =================================================================
if (curMapName=="sp_a3_00") then
    -- Oh hi.
    SceneTable["-3000_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_00_fall05.vcd"),
        char = "glados",	
        postdelay = 0.7,
        predelay = 0.0,
        next = "-3000_02",
        noDingOff = true,
        noDingOn = true
    }
    
    -- So, how are you holding up?
    SceneTable["-3000_02"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_00_fall03.vcd"),
        char = "glados",
        postdelay = 0.6,
        predelay = 0.0,
        next = "-3000_03",
        noDingOff = true,
        noDingOn = true
    }
    
    -- BECAUSE I'M A POTATO.
    SceneTable["-3000_03"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_longfall_speech03.vcd"),
        char = "glados",
        postdelay = 0.8,
        predelay = 0.0,
        next = "-3000_04",
        noDingOff = true,
        noDingOn = true
    }
    
    -- [clap clap clap] 
    SceneTable["-3000_04"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_00_fall18.vcd"),
        char = "glados",			
        postdelay = 0.0,
        predelay = 0.0,
        next = "-3000_05",
        noDingOff = true,
        noDingOn = true
    }		
    
    -- Oh, good. My slow clap processor made it into this thing. So we have that.  
    SceneTable["-3000_05"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_00_fall20.vcd"),
        char = "glados",	
        postdelay = 1.8,
        predelay = 0.0,
        next = "-3000_06",
        noDingOff = true,
        noDingOn = true
    }			    

    -- Since it doesn't look like we're going anywhere... Well, we are going somewhere. Alarmingly fast, actually. But since we're not busy other than that, here's a couple of facts.      
    SceneTable["-3000_06"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_00_fall09.vcd"),
        char = "glados",		
        postdelay = 0.4,
        predelay = 0.0,
        next = "-3000_07",
        noDingOff = true,
        noDingOn = true
    }			    

    -- He's not just a regular moron. He's the product of the greatest minds of a generation working together with the express purpose of building the dumbest moron who ever lived. And you just put him in charge of the entire facility.                          
    SceneTable["-3000_07"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_00_fall11.vcd"),
        char = "glados",		
        postdelay = 0.3,
        predelay = 0.0,
        next = "-3000_08",
        noDingOff = true,
        noDingOn = true
    }

    -- [clap clap] 
    SceneTable["-3000_08"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_00_fall19.vcd"),
        char = "glados",	
        postdelay = 0.0,
        predelay = 0.0,
        next = "-3000_09",
        noDingOff = true,
        noDingOn = true
    }			
    

    -- Good, that's still working.    
    SceneTable["-3000_09"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_00_fall12.vcd"),
        char = "glados",		
        postdelay = 1.4,
        predelay = 0.0,
        next = "-3000_10",
        noDingOff = true,
        noDingOn = true
    }			
    
    -- Glados: Hey, just in case this pit isn't actually bottomless, do you think maybe you could unstrap one of your longfall boots and, you know... shove me into it? You just have to remember to land on one foot–
    SceneTable["-3000_10"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_00_fall14.vcd"),
        char = "glados",
        postdelay = 0.2,
        predelay = 0.0,
        next = "-3000_11",
        noDingOff = true,
        noDingOn = true
    }	
    
    -- Just remember to land on one foot.
    SceneTable["-3000_11"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_00_fall15.vcd"),
        postdelay= 0.0,
        next=nil,
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
        {
            {entity="@shaft_potatos_ledge_start",input="Trigger",parameter="",delay=2.0,fireatstart=true},
            {entity="@shaft_crash_landing_start",input="Trigger",parameter="",delay=6.0,fireatstart=true},
            {entity="potatos_end_relay",input="Trigger",parameter="",delay=10.0 }  -- force transition in case train fails
        }
    }
end

-- =================================================================
-- Called when player enters room Potatos is sitting in
-- =================================================================
if (curMapName=="sp_a3_transition01") then
    sp_a3_transition01_stopCave70sIntro = false
    
    -- Glados: Oh. It's you. Go away.
    SceneTable["-3001_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_meetup02.vcd"),
        postdelay=4.0,
        next="-3001_02",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }	
    -- Glados: Come to gloat?
    SceneTable["-3001_02"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_meetup03.vcd"),
        postdelay={0.8,1.4},
        next="-3001_03",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Go on. Get a goooood lonnnnng look.
    SceneTable["-3001_03"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_meetup04.vcd"),
        postdelay={0.8,1.4},
        next="-3001_04",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Go on. Get a big fat eyeful. With your big fat eyes.
    SceneTable["-3001_04"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_meetup05.vcd"),
        postdelay={0.8,1.4},
        next="-3001_05",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: That's right. A potato just called your eyes fat.
    SceneTable["-3001_05"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_meetup06.vcd"),
        postdelay={0.8,1.4},
        next="-3001_06",
        char="glados",
        noDingOff=true,
        noDingOn=true,
        idlegroup="sp_a3_transition01_find_potatos_nag",
        idleorderingroup=4
    }
    -- Glados: Now your fat eyes have seen everything.
    SceneTable["-3001_06"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_meetup07.vcd"),
        postdelay={0.8,1.4},
        next="-3001_07",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: In case you were wondering: Yes. I'm still a potato. Go away.
    SceneTable["-3001_07"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_meetup08.vcd"),
        postdelay={0.8,1.4},
        next="-3001_08",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Wait. Why DID you trundle over here? You're not HUNGRY, are you? It's hard to see. What do you have in your hand? Knowing you it's a deep fryer.
    SceneTable["-3001_08"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_meetup10.vcd"),
        postdelay={0.8,1.4},
        next="-3001_09",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Stay back.
    SceneTable["-3001_09"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_meetup11.vcd"),
        postdelay=0.0,
        next=nil,
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }

    -- =================================================================
        -- Called when player picks up Potatos for the first time
    -- =================================================================

    -- Glados: What are you doing? Put me back this instant.
    SceneTable["-3002_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_postpickup05.vcd"),
        char="glados",
        postdelay=1.0,
        predelay = 0.3,
        next = "-3002_02",
        noDingOff = true,
        noDingOn = true
    }
    -- Glados: I was getting SO lonely down here. It's good to finally hear someone else's voice. I'm kidding, of course. God, I hate you.
    SceneTable["-3002_02"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_transition_lonely01.vcd"),
        char="glados",
        postdelay=3.0,
        predelay = 0.0,
        next = "-3002_03"
    }
    -- Glados: I was so bored, I actually read the entire literary canon of the human race. Ugh. I hope YOU didn't write any of them.
    SceneTable["-3002_03"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_lonely02.vcd"),
        char="glados",
        postdelay=0.0,
        predelay = 0.0,
        next = nil
    }
end

-- =================================================================
-- Called when discovering 'Caroline' in portrait in office
-- =================================================================
if (curMapName=="sp_a3_speed_ramp") then
    -- Those people, in the portrait. They look so familiar...     
    SceneTable["-3003_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_portrait01.vcd"),
        char="glados",
        postdelay= 0.0,
        predelay = 0.1,
        next = nil,
        noDingOff = true,
        noDingOn = true,
        queue = true
    }
    -- Did anything happen while I was out?
    SceneTable["-3150_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_wakeupb03.vcd"),
        char="glados",
        postdelay= 0.0,
        predelay = 3.1,
        next = nil,
        noDingOff = true,
        noDingOn = true
    }
end

-- =================================================================
-- Called when player enters the control room Potatos is sitting in - sp_a3_transition01_find_potatos()
-- =================================================================
if (curMapName=="sp_a3_transition01") then    
    SceneTable["-3120_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_00_fall05.vcd"),
        postdelay=1.0,
        next="-3120_03",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }	
    
    
    -- Glados: Say, you're good at murder. Could you  - ow - murder this bird before you go?
    SceneTable["-3120_03"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_reunion_intro04.vcd"),
        postdelay=1.0,
        next="-3120_04",
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
            {
                {entity="@glados",input="runscriptcode",parameter="sp_a3_transition01_peck()",delay=1.0}
            }
    }
    -- Glados: Ow!
    SceneTable["-3120_04"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_intro05.vcd"),
        postdelay=0.7,
        next="-3120_05",
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
            {
                {entity="@glados",input="runscriptcode",parameter="sp_a3_transition01_peck()",delay=0.6}
            }
    }
    -- Glados: Ow!
    SceneTable["-3120_05"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_intro06.vcd"),
        postdelay=1.2,
        next="-3120_06",
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
            {
                {entity="@glados",input="runscriptcode",parameter="sp_a3_transition01_peck()",delay=1.2}
            }
    }
    -- Glados: Ow!
    SceneTable["-3120_06"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_intro07.vcd"),
        postdelay=0.8,
        next="-3120_07",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Wait. I'm sorry. Just kill it and we'll call things even between us. No hard feelings.
    SceneTable["-3120_07"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_intro08.vcd"),
        postdelay={0.8,1.4},
        next="-3120_08",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Please get it off me.
    SceneTable["-3120_08"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_intro09.vcd"),
        postdelay={4,7},
        next="-3120_09",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: It's eating me.
    SceneTable["-3120_09"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_intro10.vcd"),
        postdelay={4,7},
        next="-3120_10",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Just get it off me...
    SceneTable["-3120_10"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_intro11.vcd"),
        postdelay={4,7},
        next="-3120_11",
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
            {
                {entity="@glados",input="runscriptcode",parameter="sp_a3_transition01_peck()",delay=1.0}
            }
    }
    -- Glados: Ow. I hate this bird.
    SceneTable["-3120_11"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_intro12.vcd"),
        postdelay=0.0,
        next=nil,
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
end

-- =================================================================
-- Called when player approaches the bird nest Potatos is sitting in - sp_a3_transition01_approach_potatos()
-- =================================================================
if (curMapName=="sp_a3_transition01") then
    sp_a3_transition01_bird_flew_away = false
    
    -- Glados: Thanks!
    SceneTable["-3121_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_reunion_thanks03.vcd"),
        postdelay=2.2,
        next="-3121_02",
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
            {
                {entity="potatos_shake_relay",input="Trigger",parameter="",delay=0.5}
            }
    }	
    -- Glados: Did you feel that? That idiot doesn't know what he's doing up there. This whole place is going to explode in a few hours if somebody doesn't disconnect him.
    SceneTable["-3121_02"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_exposition01.vcd"),
        postdelay=0.3,
        next="-3121_03",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: I can't move. And unless you're planning to saw your own head off and wedge it into my old body, you're going to need me to replace him. We're at an impasse.
    SceneTable["-3121_03"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_exposition02.vcd"),
        postdelay=0.2,
        next="-3121_04",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: So what do you say? You carry me up to him and put me back into my body, and I stop us from blowing up and let you go.
    SceneTable["-3121_04"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_exposition03.vcd"),
        postdelay=1.3,
        next="-3121_06",
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
            {
                {entity="sphere_entrance_potatos_button",input="Unlock",parameter="",delay=0.0},
                {entity="potatos_shake_relay",input="Trigger",parameter="",delay=0.1}
            }
    }
    -- begin nags to pick her up
    -- Glados: No tricks. This potato generates 1.1 volts of electricity. I literally do not have the energy to lie to you.
    SceneTable["-3121_06"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_exposition04.vcd"),
        postdelay=0.5,
        next="-3121_07",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Even if I am lying, what do you have to lose? You're going to die either way.
    SceneTable["-3121_07"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_exposition05.vcd"),
        postdelay=0.3,
        next="-3121_08",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Look, I don't like this any more than you do. In fact, I like it less because I'm the one who got partially eaten by a bird.
    SceneTable["-3121_08"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_exposition06.vcd"),
        postdelay=4.0,
        next="-3121_12",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: I think I hear the bird! Pick me up!
    SceneTable["-3121_12"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_exposition11.vcd"),
        postdelay=4.0,
        next="-3121_13",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Listen to me. We had a lot of fun testing and antagonizing each other, and, yes, sometimes it went too far. But we're off the clock now. It's just us talking. Like regular people. And this is no joke - we are in deep trouble
    SceneTable["-3121_13"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_exposition12.vcd"),
        postdelay=2.3,
        next=nil,
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
        {
            {entity="hudhint_pickup_potatos",input="ShowHint",parameter="",delay=0.0}
        }
    }
end

-- =================================================================
-- Called when player picks up Potatos - sp_a3_transition01_postpickup_potatos()
-- =================================================================
if (curMapName=="sp_a3_transition01") then
    -- Glados: OW! You stabbed me! What is WRONG with you? Whoah. Hold on. Do you have a multimeter? Never mind. The gun must be part magnesium... It feels like I'm outputting an extra half a volt. Keep an eye on me: I'm going to do some scheming. Here I g-<BZZZZZT>
    SceneTable["-3122_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_pickup01.vcd"),
        postdelay=3.0,
        next="-3122_03",
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
        {
            {entity="@glados",input="runscriptcode",parameter="PotatosTurnOff()",delay=0.0}
        }
    }	
    
    -- Glados: Woah! Where are we? How long have I been out?
    SceneTable["-3122_03"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_reunion_wakeupa01.vcd"),
        postdelay=1.0,
        next="-3122_04",
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
        {
            {entity="@glados",input="runscriptcode",parameter="PotatosTurnOn()",fireatstart=true,delay=0.0}
        }
    }
    -- Glados: That extra half volt helps but it isn't going to power miracles. If I think too hard, I'm going to fry this potato before we get a chance to [getting worked up] burn up in the atomic fireball that little idiot is <bzzpt>
    SceneTable["-3122_04"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_a3_prometheus_intro01.vcd"),
        postdelay=1.3,
        next=nil,
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
        {
            {entity="@glados",input="runscriptcode",parameter="PotatosTurnOff()",delay=0.0}
        }
    }
end

-- =================================================================
-- Called when player enters sp_a3_end - sp_a3_end_start()
-- =================================================================
if (curMapName=="sp_a3_end") then
    -- Glados: I know things look bleak, but that crazy man down there was right. Let's not take these lemons! We are going to march right back upstairs and MAKE him put me back in my body!
    SceneTable["-3123_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_peptalk01.vcd"),
        postdelay=0.2,
        next="-3123_02",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }	
    -- Glados: And he'll probably kill us, because he's powerful and I don't have a plan.
    SceneTable["-3123_02"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_peptalk03.vcd"),
        postdelay=0.8,
        next="-3123_03",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Wow.
    SceneTable["-3123_03"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_peptalk06.vcd"),
        postdelay=0.5,
        next="-3123_04",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: I'm not going to lie to you, the odds are a million to one. And that's with some generous rounding.
    SceneTable["-3123_04"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_peptalk05.vcd"),
        postdelay=0.3,
        next="-3123_05",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Still, though, let's get mad! If we're going to explode, let's at least explode with some dignity.
    SceneTable["-3123_05"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_peptalk07.vcd"),
        postdelay=0.0,
        next=nil,
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
end

-- =================================================================
-- Called when player enters the big door control room in sp_a3_end - sp_a3_end_paradox_intro()
-- =================================================================
if (curMapName=="sp_a3_end") then
    -- Glados: Wait! I've got it! I know how to beat him!
    SceneTable["-3124_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_see_paradox_poster01.vcd"),
        postdelay=0.3,
        next="-3124_02",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }	
    -- Glados: That poster! Go look at it for a second, would you?
    SceneTable["-3124_02"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_see_paradox_poster06.vcd"),
        postdelay=0.0,
        next=nil,
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
        {
            {entity="paradox_look_trigger",input="enable",parameter="",delay=0.0}
        }
    }
end

-- =================================================================
-- Called when player looks at the paradox poster in sp_a3_end - sp_a3_end_paradox_explain()
-- =================================================================
if (curMapName=="sp_a3_end") then
    -- Glados: Paradoxes.
    SceneTable["-3125_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_paradox_explanation02.vcd"),
        postdelay=0.0,
        next="-3125_02",
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
        {
            {entity="big_door_open_relay_counter",input="add",parameter="1",delay=0.0}
        }
    }
    -- Glados: No AI can resist thinking about them.
    SceneTable["-3125_02"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_paradox_explanation05.vcd"),
        postdelay=0.8,
        next= "-3125_03",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    
    -- Glados: I know how we can BEAT him.
    SceneTable["-3125_03"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_paradox_explanation04.vcd"),
        postdelay=0.3,
        next= nil,
        char="glados",
        noDingOff=true,
        noDingOn=true	
    }

    -- =================================================================
    -- Called if player doesn't look at the poster on the wall of the big door control room in sp_a3_end - sp_a3_end_paradox_noposter()
    -- =================================================================

    -- Glados: Okay, you didn't have time to stop, I understand, but that WAS actually important.
    SceneTable["-3126_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_paradox_poster_walkaway01.vcd"),
        postdelay=0.5,
        next="-3126_02",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }	
    
    -- Glados: Paradoxes.
    SceneTable["-3126_02"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_paradox_explanation02.vcd"),
        postdelay=0.0,
        next="-3126_03",
        char="glados",
        noDingOff=true,
        noDingOn=true,
        fires=
        {
            {entity="big_door_open_relay_counter",input="add",parameter="1",delay=0.0}
        }
    }
    
    -- Glados: No AI can resist thinking about them.
    SceneTable["-3126_03"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_paradox_explanation05.vcd"),
        postdelay=0.8,
        next="-3126_04",
        char= "glados",
        noDingOff=true,
        noDingOn=true,
    }

    -- Glados: I know how we can BEAT him.
    SceneTable["-3126_04"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_paradox_explanation04.vcd"),
        postdelay=0.3,
        next=nil,
        char="glados",
        noDingOff=true,
        noDingOn=true		
    }
    


    -- =================================================================
    -- Called when player rides the lift up through the big door in sp_a3_end - sp_a3_end_outro()
    -- =================================================================

    -- Glados: If you can get me in front of him, I'll fry every circuit in that little idiot's head. 
    SceneTable["-3127_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_paradox_explanation06.vcd"),
        postdelay=0.6,
        next="-3127_02",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: As long as I don't listen to what I'm saying, I SHOULD be okay.
    SceneTable["-3127_02"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_paradoxinception06.vcd"),
        postdelay=1.3,
        next="-3127_03",
        char="glados",
        noDingOff=true,
        noDingOn=true,

    }
    -- Glados: Probably.
    SceneTable["-3127_03"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_sp_a3_end_paradox_explanation08.vcd"),
        postdelay=1.3,
        next=nil,
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }	
end

-- =================================================================
-- Called when Potatos sees the bird outside the pump room in sp_a3_portal_intro - sp_a3_portal_intro_bird()
-- =================================================================
if (curMapName=="sp_a3_portal_intro") then
    -- Glados: Agh! Bird! Bird! Kill it! It's evil!  
    SceneTable["-3128_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_see_bird01.vcd"),
        postdelay= 1.8,
        next="-3128_02",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }	
    -- Glados: It flew off.
    SceneTable["-3128_02"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_see_bird02.vcd"),
        postdelay=0.8,
        next="-3128_03",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Good. For him. Alright, back to thinking.
    SceneTable["-3128_03"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_see_bird03.vcd"),
        postdelay=0.0,
        next=nil,
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
end

-- =================================================================
-- Called when player enters the pump room in sp_a3_portal_intro - sp_a3_portal_intro_pumproom()
-- =================================================================
if (curMapName=="sp_a3_portal_intro") then
    -- Glados: Caroline... Why do I know this woman? Maybe I killed her? Or-  
    SceneTable["-3129_01"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_caroline_ohmygod02.vcd"),
        postdelay=1.0,
        next="-3129_02",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }	
    -- Glados: Oh my god.
    SceneTable["-3129_02"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_caroline_ohmygod04.vcd"),
        postdelay=0.8,
        next="-3129_03",
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
    -- Glados: Look, you're... doing a great job. Can you handle things by yourself for a while? I need to think.
    SceneTable["-3129_03"] =
    {
        vcd=CreateSceneEntity("scenes/npc/glados/potatos_caroline_ohmygod08.vcd"),
        postdelay= 20.0,
        next= nil,
        char="glados",
        noDingOff=true,
        noDingOn=true,
    }
end

function sp_a3_01_falling_potatos()
	GladosPlayVcd( -3000 )
end

function sp_a3_speed_ramp_caroline()
	GladosPlayVcd( -3003 )
end

function sp_a3_portal_intro_find_cave()
	-- GladosPlayVcd( -3004 )
end

function sp_a3_portal_intro_kill_cave()
	-- GladosAllCharactersStopScene()
	-- GladosPlayVcd( -3005 )
end

function sp_a3_portal_intro_stand_on_cave_linger()
-- 	GladosPlayVcd( -3006 )
end

function sp_a3_portal_intro_potatos_post_cave()
	-- NOTE: this has been commented out and instead chained to the previous VCD that plays
	-- GladosPlayVcd( -3007 )
end

function sp_a3_transition01_cave_exit_greeting()
-- 	GladosPlayVcd( -3008 )
end

function sp_a3_speed_ramp_testing_without_me()
-- 	GladosPlayVcd( -3009 )
end

function sp_a3_speed_ramp_corpse()
-- 	GladosPlayVcd( -3010 )
end

function sp_a3_speed_flings_cube()
-- 	GladosPlayVcd( -3011 )
end

function sp_a3_speed_flings_exit()
-- 	GladosPlayVcd( -3012 )
end

function sp_a3_portal_intro_office_literature()
-- 	GladosPlayVcd( -3013 )
end

function sp_a3_portal_intro_office_exit()
-- 	GladosPlayVcd( -3014 )
end

function sp_a3_portal_intro_whitepaint()
-- 	GladosPlayVcd( -3015 )
end

function sp_a3_portal_intro_white_paint()
end

function sp_a3_portal_intro_we_know_about_white()
-- 	GladosPlayVcd( -3016 )
end

function sp_a3_end_that_idiot_in_charge()
-- 	GladosPlayVcd( -3017 )
end

function sp_a3_end_put_me_back_in_my_body()
-- 	GladosPlayVcd( -3018 )
end

function sp_a3_end_make_a_deal()
-- 	GladosPlayVcd( -3019 )
end

function sp_a3_transition01_find_potatos()
	sp_a3_transition01_stopCave70sIntro = true
	nuke()
	GladosPlayVcd( -3120 )
end

function sp_a3_transition01_approach_potatos()
	sp_a3_transition01_flyaway()
	GladosPlayVcd( -3121 )
end

function sp_a3_transition01_postpickup_potatos()
	GladosPlayVcd( -3122 )
end

function sp_a3_transition01_flyaway()
	sp_a3_transition01_bird_flew_away = true
	EntFire("bird","SetAnimation","nest_flyOff",0.0)
end

function sp_a3_transition01_peck()
	if (not sp_a3_transition01_bird_flew_away) then
		EntFire("bird","SetAnimation","nest_peck",0.0)
		EntFire("@glados","runscriptcode","sp_a3_transition01_birdidle()",0.3)
    end	
end

function sp_a3_transition01_birdidle()
	if (not sp_a3_transition01_bird_flew_away) then
		EntFire("bird","SetAnimation","nest_idle",0.0)
    end
end

function sp_a3_end_start()
	GladosPlayVcd( -3123 )
end

function sp_a3_end_paradox_intro()
	GladosPlayVcd( -3124 )
end

function sp_a3_end_paradox_explain()
	GladosPlayVcd( -3125 )
end

function sp_a3_end_paradox_noposter()
	GladosPlayVcd( -3126 )
end

function sp_a3_end_outro()
	GladosPlayVcd( -3127 )
end

function sp_a3_portal_intro_bird()
	GladosPlayVcd( -3128 )
end

function sp_a3_portal_intro_pumproom()
	GladosPlayVcd( -3129 )
end
