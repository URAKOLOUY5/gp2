include "sphere_choreo_include"

EntFire( "!self", "SetIdleSequence", "sphere_damaged_no_twitch_idle", 0 )

DialogVcd = {}

DialogVcd[550] = 404
DialogVcd[551] = 405
DialogVcd[552] = 406
DialogVcd[553] = 407
DialogVcd[555] = 408
DialogVcd[556] = 409
DialogVcd[557] = 410
DialogVcd[558] = 411
DialogVcd[559] = 412
DialogVcd[560] = 413
DialogVcd[561] = 414
DialogVcd[562] = 415
DialogVcd[564] = 416
DialogVcd[565] = 417
DialogVcd[566] = 418
DialogVcd[567] = 419
DialogVcd[568] = 420
DialogVcd[569] = 421
DialogVcd[570] = 422
DialogVcd[571] = 423
DialogVcd[572] = 424
DialogVcd[573] = 425
DialogVcd[574] = 426
DialogVcd[575] = 427
DialogVcd[576] = 428
DialogVcd[577] = 429
DialogVcd[590] = 430
DialogVcd[600] = 431
DialogVcd[601] = 432
DialogVcd[602] = 433
DialogVcd[610] = 434
DialogVcd[611] = 435
DialogVcd[620] = 436
DialogVcd[691] = 437

Dialog[550] = { speaker = WHEATLEY, one = "It sure is dark down here.", nextLine = 551, nextLineDelay = 3 }
Dialog[551] = { speaker = WHEATLEY, one = "We have to make our way to the turret factory.", nextLine = 552, nextLineDelay = 5 }
Dialog[552] = { speaker = WHEATLEY, one = "I'm pretty sure we're on the right path.  Lets go find it.", }


Dialog[553] = { speaker = WHEATLEY, one = "The turret factory should be generally this way...", }

Dialog[555] = { speaker = WHEATLEY, one = "Careful now. Try to jump your way across this machinery.", }

Dialog[556] = { speaker = WHEATLEY, one = "It is a good thing this machinery is off.", }

Dialog[557] = { speaker = WHEATLEY, one = "Oh No!  Are you OK?", nextLine = 558, nextLineDelay = 3 }
Dialog[558] = { speaker = WHEATLEY, one = "Are you alive down there?", nextLine = 559, nextLineDelay = 3 }
Dialog[559] = { speaker = WHEATLEY, one = "If you are alive, can you say something or jump around so I know you are OK?", }

Dialog[560] = { speaker = WHEATLEY, one = "There you are!  I was starting to get worried.", }

Dialog[561] = { speaker = WHEATLEY, one = "Lets try this again.  Try to make your way across the machinery.", }

Dialog[562] = { speaker = WHEATLEY, one = "Nice work.  Lets keep moving.", two = "The factory entrance must be around here somewhere.", }



Dialog[564] = { speaker = WHEATLEY, one = "Careful...  There's something up ahead.", }
Dialog[565] = { speaker = WHEATLEY, one = "Let me light this jump for you", }
Dialog[566] = { speaker = WHEATLEY, one = "Nice jump!", }


--  [ADD DEAD-END t-intersection]

Dialog[567] = { speaker = WHEATLEY, one = "Okay, this way", }
Dialog[568] = { speaker = WHEATLEY, one = "No, no, i'm sure it's this way", }
Dialog[569] = { speaker = WHEATLEY, one = "Hm.  Lets try this way.", }
	
	
	

--  [SEAL OFF JUMP ABOVE MOVING PANEL BRIDGE]


Dialog[570] = { speaker = WHEATLEY, one = "Hear that machinery?", two = "She has really kicked this place into high gear.", }

Dialog[571] = { speaker = WHEATLEY, one = "This looks dangerous.  I'll hold the light steady.", two = "Drop down whenever you are ready.", }


Dialog[572] = { speaker = WHEATLEY, one = "Whatever you do, don't fall off!", }
Dialog[573] = { speaker = WHEATLEY, one = "Quick, this way!", }

Dialog[574] = { speaker = WHEATLEY, one = "Nicely Done!", }
	
	
Dialog[575] = { speaker = WHEATLEY, one = "Okay, let me light this path for you.", }
Dialog[576] = { speaker = WHEATLEY, one = "These delivery tubes are working overtime.", }


--  [if you take a wrong step]
Dialog[577] = { speaker = WHEATLEY, one = "No, not that way", }


Dialog[590] = { speaker = WHEATLEY, one = "We have to split up here for a moment.  Portal up", two = "to that passage and i'll see you on the other side.", }
Dialog[691] = { speaker = WHEATLEY, one = "Hold on, i'll be right there!", }


--  [MAKE THIS ROOM ENTRY ONE WAY]
Dialog[600] = { speaker = WHEATLEY, one = "We have to get you out of that room.", }

--  [shines light on panels, wall]
Dialog[601] = { speaker = WHEATLEY, one = "Can you reach that wall back there?", }
Dialog[602] = { speaker = WHEATLEY, one = "There's another wall over here", }


Dialog[610] = { speaker = WHEATLEY, one = "Ah, here it is -- the turret factory entrance!", }
Dialog[611] = { speaker = WHEATLEY, one = "There are no rails.  I can't follow you.", two = "Keep following that path.  I'll meet you up ahead.", }

Dialog[620] = { speaker = WHEATLEY, one = "Don't forget -- watch out for her defenses!", }

Dialog[700] = { speaker = WHEATLEY, one = "We made it!", }
Dialog[701] = { speaker = WHEATLEY, one = "She seems pretty angry.  We better keep moving.", }

Dialog[702] = { speaker = WHEATLEY, one = "Uh oh...", }

Dialog[703] = { speaker = WHEATLEY, one = "Hang on a second...", }

Dialog[704] = { speaker = WHEATLEY, one = "There! That's better.", }


Dialog[706] = { speaker = WHEATLEY, one = "Follow me.  I'll light the way.", }

function SpeakLineVcd(arg)
    if DialogVcd[arg] then
        EntFire("@glados","RunScriptCode","GladosPlayVcd(" .. DialogVcd[arg] .. ")",0.00)
    else
        SpeakLine( arg )
    end
end

function WheatleyDarknessIntro()
    SpeakLineVcd(553)
end

function WheatleyMachineRoomCaution()
    SpeakLineVcd(555)
end

function WheatleyMachineRoomCommentary()
    SpeakLineVcd(556)
end

function WheatleyMachineRoomPlayerFall()
    SpeakLineVcd(557)
end

function WheatleyMachineRoomPlayerOK()
    SpeakLineVcd(560)
end

function WheatleyMachineRoomRetry()
    SpeakLineVcd(561)
end

function WheatleyMachineRoomCompletion()
    SpeakLineVcd(562)
end

function WheatleyGapJumpCaution()
    SpeakLineVcd(564)
end

function WheatleyGapJumpLightHelp()
    SpeakLineVcd(565)
end

function WheatleyIntersectionConfused()
    SpeakLineVcd(567)
end

function WheatleyIntersectionConfusedAgain()
    SpeakLineVcd(568)
end

function WheatleyIntersectionCompletion()
    SpeakLineVcd(569)
end

function WheatleyPanelDropStart()
    -- SpeakLineVcd(570)  -- COMMENTED OUT FOR COLOGNE
end

function WheatleyPanelDropToPanel()
    SpeakLineVcd(571)
end

function WheatleyPanelDropCaution()
    -- SpeakLineVcd(572) -- COMMENTED OUT FOR COLOGNE
end

function WheatleyPanelDropExit()
    SpeakLineVcd(573)
end

function WheatleyMazeStart()
    SpeakLineVcd(575)
end

function WheatleyMazeCommentary()
    -- disconnected this line since Wheatley now plays smelly humans dialog in this area
    -- SpeakLineVcd(576)
end

function WheatleyMazeWrongWay()
    SpeakLineVcd(577)
end

function WheatleyPanelDropNiceJob()
    SpeakLineVcd(574)
end

function WheatleyMazePortalExit()
    SpeakLineVcd(590)
end

function WheatleyMazePortalHoldOn()
    SpeakLineVcd(691)
end 

function WheatleyGapShootStart()
    SpeakLineVcd(600)
end

function WheatleyGapShootFirstWall()
    SpeakLineVcd(601)
    EntFire("spherebot_1_bottom_swivel_1", "SetTargetEntity", "back_wall_look_target", 0)
    EntFire("spherebot_1_top_swivel_1", "SetTargetEntity", "back_wall_look_target", 0)
    EntFire("spherebot_train_1_chassis_1", "MoveToPathNode", "spherebot_gap_shoot_train_4", 0)
end

function WheatleyGapShootSecondWall()
    SpeakLineVcd(602)
end

function WheatleyToxinDebut()
    SpeakLineVcd(610)
end

function WheatleyDeparting()
    SpeakLineVcd(611)
end

function WheatleyDepartingGoalReminder()
    SpeakLineVcd(620)
end

function WheatleyTransitionStart()
    -- SpeakLineVcd(700)
    EntFire("@glados", "RunScriptCode", "GladosPlayVcd(315)", 0)
end

function WheatleyTransitionGladosAngry()
   --SpeakLineVcd( 701 )
end

function WheatleyTransitionPowerGoingOut()
    -- SpeakLineVcd( 702 )
    EntFire("@glados","RunScriptCode","GladosPlayVcd(320)", 3)
end

function WheatleyTransitionHangOn()
    --SpeakLineVcd( 703 )
end

function WheatleyTransitionThatsBetter()
    --SpeakLineVcd( 704 )
end

function WheatleyStartingDarknessTour()
    --SpeakLineVcd( 706 )
end