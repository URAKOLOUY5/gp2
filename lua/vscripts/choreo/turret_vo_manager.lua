Globals.TurretVoManager = {}

-- print("************************  RUNNING TURRET VO MANAGER *************")

Globals.TurretVoManager.vcdpools = {}

Globals.TurretVoManager.productionSwitched = false
Globals.TurretVoManager.productionStalled = false
Globals.TurretVoManager.grabbedTurretTalked = 0
Globals.TurretVoManager.grabbedTurretHandle = nil

-- ** HACK HACK HACK **
-- This is a fix for the save/load problem with VScript!
-- See GARRET for an explanation 
function HackFixSaveLoad()
    -- print("**************RUNNING")
    Globals.OutputsPattern = "^On.*Output$"
end

Globals.TurretVoManager.vcds = Globals.TurretVoManager.vcds or {}

-- SOURCE: sp_sabotage_factory_defect_chat
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_chat01"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_chat01.vcd"),secs=3.70,group="defect_chat"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_chat02"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_chat02.vcd"),secs=4.18,group="defect_chat"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_chat03"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_chat03.vcd"),secs=1.23,group="defect_chat"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_chat04"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_chat04.vcd"),secs=1.66,group="defect_chat"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_chat05"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_chat05.vcd"),secs=1.02,group="defect_chat"}

sp_sabotage_factory_defect_chat_count = 5

-- SOURCE: sp_sabotage_factory_defect_dryfire
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire01"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire01.vcd"),secs=0.54,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire02"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire02.vcd"),secs=0.89,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire03"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire03.vcd"),secs=0.76,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire04"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire04.vcd"),secs=1.16,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire05"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire05.vcd"),secs=0.42,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire06"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire06.vcd"),secs=0.61,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire07"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire07.vcd"),secs=1.16,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire08"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire08.vcd"),secs=0.89,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire09"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire09.vcd"),secs=0.41,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire10"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire10.vcd"),secs=0.54,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire11"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire11.vcd"),secs=0.77,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire12"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire12.vcd"),secs=0.77,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire13"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire13.vcd"),secs=0.88,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire14"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire14.vcd"),secs=1.46,group="defect_dryfire"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_dryfire15"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_dryfire15.vcd"),secs=1.41,group="defect_dryfire"}

sp_sabotage_factory_defect_dryfire_count = 15

-- SOURCE: sp_sabotage_factory_defect_fail
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail01"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail01.vcd"),secs=0.91,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail02"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail02.vcd"),secs=0.66,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail03"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail03.vcd"),secs=1.63,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail04"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail04.vcd"),secs=1.41,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail05"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail05.vcd"),secs=0.87,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail06"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail06.vcd"),secs=1.22,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail07"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail07.vcd"),secs=1.31,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail08"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail08.vcd"),secs=1.01,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail09"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail09.vcd"),secs=0.94,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail10"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail10.vcd"),secs=1.15,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail11"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail11.vcd"),secs=1.34,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail12"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail12.vcd"),secs=1.39,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail13"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail13.vcd"),secs=1.62,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail14"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail14.vcd"),secs=0.71,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail15"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail15.vcd"),secs=1.09,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail16"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail16.vcd"),secs=0.92,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail17"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail17.vcd"),secs=1.30,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail18"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail18.vcd"),secs=1.36,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail19"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail19.vcd"),secs=0.91,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail20"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail20.vcd"),secs=0.71,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail21"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail21.vcd"),secs=1.10,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail22"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail22.vcd"),secs=1.39,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail23"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail23.vcd"),secs=1.58,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail24"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail24.vcd"),secs=1.40,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail25"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail25.vcd"),secs=1.08,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail26"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail26.vcd"),secs=1.17,group="defect_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_fail27"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_fail27.vcd"),secs=1.18,group="defect_fail"}

sp_sabotage_factory_defect_fail_count = 27

-- SOURCE: sp_sabotage_factory_defect_laugh
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_laugh01"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_laugh01.vcd"), secs=2.70, group="defect_laugh"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_laugh02"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_laugh02.vcd"), secs=2.95, group="defect_laugh"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_laugh03"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_laugh03.vcd"), secs=1.10, group="defect_laugh"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_laugh04"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_laugh04.vcd"), secs=0.79, group="defect_laugh"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_laugh05"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_laugh05.vcd"), secs=1.24, group="defect_laugh"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_laugh06"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_laugh06.vcd"), secs=1.07, group="defect_laugh"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_laugh07"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_laugh07.vcd"), secs=1.58, group="defect_laugh"}

sp_sabotage_factory_defect_laugh_count = 7

-- SOURCE: sp_sabotage_factory_defect_pass
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_pass01"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_pass01.vcd"), secs=0.70, group="defect_pass"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_pass02"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_pass02.vcd"), secs=0.87, group="defect_pass"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_pass03"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_pass03.vcd"), secs=1.43, group="defect_pass"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_pass04"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_pass04.vcd"), secs=1.54, group="defect_pass"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_pass05"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_pass05.vcd"), secs=1.81, group="defect_pass"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_pass06"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_pass06.vcd"), secs=0.71, group="defect_pass"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_pass07"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_pass07.vcd"), secs=0.80, group="defect_pass"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_pass08"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_pass08.vcd"), secs=1.09, group="defect_pass"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_pass09"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_pass09.vcd"), secs=1.34, group="defect_pass"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_pass10"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_pass10.vcd"), secs=1.01, group="defect_pass"}

sp_sabotage_factory_defect_pass_count = 10

-- SOURCE: sp_sabotage_factory_defect_postrange
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange01"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange1.vcd"), secs=1.13, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange02"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange2.vcd"), secs=0.91, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange03"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange3.vcd"), secs=1.39, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange04"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange4.vcd"), secs=1.84, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange05"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange5.vcd"), secs=0.78, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange06"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange6.vcd"), secs=1.81, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange07"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange7.vcd"), secs=0.89, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange08"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange8.vcd"), secs=2.04, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange09"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange9.vcd"), secs=1.43, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange10"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange10.vcd"), secs=0.88, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange11"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange11.vcd"), secs=0.58, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange12"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange12.vcd"), secs=0.77, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange13"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange13.vcd"), secs=0.63, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange14"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange14.vcd"), secs=1.67, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange15"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange15.vcd"), secs=1.01, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange16"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange16.vcd"), secs=1.10, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange17"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange17.vcd"), secs=1.24, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange18"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange18.vcd"), secs=1.37, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange19"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange19.vcd"), secs=0.75, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange20"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange20.vcd"), secs=0.54, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange21"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange21.vcd"), secs=1.08, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange22"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange22.vcd"), secs=1.30, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange23"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange23.vcd"), secs=1.38, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange24"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange24.vcd"), secs=1.56, group="defect_postrange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_postrange25"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_postrange25.vcd"), secs=1.56, group="defect_postrange"}

sp_sabotage_factory_defect_postrange_count = 25

-- SOURCE: sp_sabotage_factory_defect_prerange
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_prerange01"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_prerange01.vcd"), secs=2.80, group="defect_prerange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_prerange02"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_prerange02.vcd"), secs=1.25, group="defect_prerange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_prerange03"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_prerange03.vcd"), secs=1.38, group="defect_prerange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_prerange04"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_prerange04.vcd"), secs=1.34, group="defect_prerange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_prerange05"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_prerange05.vcd"), secs=1.89, group="defect_prerange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_prerange06"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_prerange06.vcd"), secs=2.72, group="defect_prerange"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_prerange07"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_prerange07.vcd"), secs=1.80, group="defect_prerange"}

sp_sabotage_factory_defect_prerange_count = 7

-- SOURCE: sp_sabotage_factory_defect_test
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test01"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test01.vcd"), secs=0.36, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test02"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test02.vcd"), secs=0.66, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test03"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test03.vcd"), secs=0.56, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test04"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test04.vcd"), secs=0.58, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test05"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test05.vcd"), secs=1.20, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test06"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test06.vcd"), secs=0.48, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test07"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test07.vcd"), secs=1.37, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test08"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test08.vcd"), secs=1.05, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test09"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test09.vcd"), secs=3.00, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test10"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test10.vcd"), secs=1.00, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test11"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test11.vcd"), secs=1.00, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test12"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test12.vcd"), secs=0.69, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test13"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test13.vcd"), secs=0.85, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test14"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test14.vcd"), secs=0.30, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test15"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test15.vcd"), secs=0.42, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test16"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test16.vcd"), secs=0.82, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test17"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test17.vcd"), secs=0.88, group="defect_test"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test18"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_defect_test18.vcd"), secs=1.01, group="defect_test"}

sp_sabotage_factory_defect_test_count = 18

-- SOURCE: sp_sabotage_factory_good_fail
Globals.TurretVoManager.vcds["sp_sabotage_factory_good_fail01"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_good_fail01.vcd"), secs=0.85, group="good_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_good_fail02"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_good_fail02.vcd"), secs=2.19, group="good_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_good_fail03"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_good_fail03.vcd"), secs=1.76, group="good_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_good_fail04"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_good_fail04.vcd"), secs=1.29, group="good_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_good_fail05"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_good_fail05.vcd"), secs=1.07, group="good_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_good_fail06"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_good_fail06.vcd"), secs=1.70, group="good_fail"}
Globals.TurretVoManager.vcds["sp_sabotage_factory_good_fail07"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_good_fail07.vcd"), secs=0.63, group="good_fail"}

-- SOURCE: sp_sabotage_factory_good_pass
Globals.TurretVoManager.vcds["sp_sabotage_factory_good_pass01"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_good_pass01.vcd"), secs=0.52, group="good_pass"}

-- SOURCE: sp_sabotage_factory_good_prerange
Globals.TurretVoManager.vcds["sp_sabotage_factory_good_prerange01"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_good_prerange01.vcd"),secs=1.37,group="good_prerange"}

-- SOURCE: sp_sabotage_factory_template
Globals.TurretVoManager.vcds["sp_sabotage_factory_template01"] = { handle=CreateSceneEntity("scenes/npc/turret/sp_sabotage_factory_template01.vcd"),secs=0.52,group="factory_template"}

Globals.TurretVoManager.vcds["announcer_template"] = { handle=CreateSceneEntity("scenes/npc/announcer/sp_sabotage_factory_line01.vcd"),secs=0.46,group="announcer_template"}
Globals.TurretVoManager.vcds["announcer_response"] = { handle=CreateSceneEntity("scenes/npc/announcer/sp_sabotage_factory_line02.vcd"),secs=0.66,group="announcer_template"}

Globals.TurretVoManager.DoTemplate = function()
    local vcd_handle = nil
    vcd_handle = Globals.TurretVoManager.vcds["announcer_template"].handle
    EntFireByHandle(Globals.TurretVoManager.vcds["announcer_template"].handle, "SetTarget1", "npc_scanner_speaker", 0 )
    EntFireByHandle(vcd_handle, "start", "", 0.0 )

    local addSecs
    if Globals.TurretVoManager.productionSwitched then
        local vcd_handle = Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_test01"].handle
        --EntFireByHandle( Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_laugh0"].handle, "SetTarget1", "replacement_template_turret", 0  )
        EntFireByHandle(vcd_handle, "SetTarget1", "replacement_template_turret", 0 )
        EntFireByHandle(vcd_handle, "start", "", Globals.TurretVoManager.vcds["announcer_template"].secs )
        addSecs = Globals.TurretVoManager.vcds["sp_sabotage_factory_template01"].secs
    else
        EntFireByHandle(Globals.TurretVoManager.vcds["sp_sabotage_factory_template01"].handle, "SetTarget1", "initial_template_turret", 0 )
        if not Globals.TurretVoManager.productionStalled then
            EntFireByHandle(Globals.TurretVoManager.vcds["sp_sabotage_factory_template01"].handle, "start", "", Globals.TurretVoManager.vcds["announcer_template"].secs )
        end
        addSecs = Globals.TurretVoManager.vcds["sp_sabotage_factory_template01"].secs
    end

    vcd_handle = Globals.TurretVoManager.vcds["announcer_response"].handle
    local totTime = Globals.TurretVoManager.vcds["announcer_template"].secs + addSecs
    totTime = totTime + 0.3
    EntFireByHandle(vcd_handle, "SetTarget1", "npc_scanner_speaker", 0 )
    EntFireByHandle(vcd_handle, "start", "", totTime )

    return totTime + Globals.TurretVoManager.vcds["announcer_response"].secs 
end

function ProductionSwitch()
    Globals.TurretVoManager.ProductionSwitchToDefects()
end

Globals.TurretVoManager.grabbedDefectTurret = function(turret)
    Globals.TurretVoManager.grabbedTurretTalked = Globals.TurretVoManager.grabbedTurretTalked + 1
    if Globals.TurretVoManager.grabbedTurretTalked > 5 then
        Globals.TurretVoManager.grabbedTurretTalked = 3
    end
    local vcd_handle = nil
    if Globals.TurretVoManager.grabbedTurretTalked == 1 then
        vcd_handle = Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_chat02"].handle
    elseif Globals.TurretVoManager.grabbedTurretTalked == 2 then
        vcd_handle = Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_chat01"].handle
    elseif Globals.TurretVoManager.grabbedTurretTalked == 3 then
        vcd_handle = Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_chat03"].handle
    elseif Globals.TurretVoManager.grabbedTurretTalked == 4 then
        vcd_handle = Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_chat04"].handle
    elseif Globals.TurretVoManager.grabbedTurretTalked == 5 then
        vcd_handle = Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_chat05"].handle
    end

    local curscene = turret:GetCurrentScene()
    if curscene ~= nil then
        EntFireByHandle(curscene, "Cancel", "", 0 )
    end
    EntFireByHandle(vcd_handle, "SetTarget1", turret:GetName(), 0 )
    EntFireByHandle(vcd_handle, "start", "", 0.0 )

    Globals.TurretVoManager.grabbedTurretHandle = turret
end

function productionStall()
    Globals.TurretVoManager.ProductionStall()
end

Globals.TurretVoManager.ProductionStall = function()
    Globals.TurretVoManager.productionStalled = true
end

Globals.TurretVoManager.ProductionSwitchToDefects = function()
    --printl("=================PRODUCTION LINE IS SWITCHED!")
	Globals.TurretVoManager.productionSwitched = true
	Globals.TurretVoManager.productionStalled = false
end

Globals.TurretVoManager.GoodTurretPass = function(turret)
    -- printl("=================GOOD TURRET PASS: CALLER NAME: " .. turret:GetName() )
    local initSecs = Globals.TurretVoManager.DoTemplate()

    local v = "sp_sabotage_factory_good_pass01"
    local vcd_handle = Globals.TurretVoManager.vcds[v].handle

    EntFireByHandle( vcd_handle, "SetTarget1", turret:GetName(), 0)
	EntFireByHandle( vcd_handle, "start", "", initSecs)

    if Globals.TurretVoManager.productionSwitched then
        EntFire( "reject_turret_relay", "trigger", 0, initSecs+0.0 + Globals.TurretVoManager.vcds[v].secs )
		EntFire( turret:GetName(), "RunScriptCode", "FunctioningTurretFling()", initSecs+0.0 + Globals.TurretVoManager.vcds[v].secs)
    else
        EntFire( "accept_turret_relay", "trigger", 0, initSecs+Globals.TurretVoManager.vcds[v].secs)
    end
end

Globals.TurretVoManager.GoodTurretFail = function(turret)
    -- printl("=================GOOD TURRET FAIL: CALLER NAME: " .. turret:GetName() )
    local v = Globals.TurretVoManager.FetchFromPool("good_fail")
    local vcd_handle = Globals.TurretVoManager.vcds[v].handle

    EntFireByHandle( vcd_handle, "SetTarget1", turret:GetName(), 0 )
	EntFireByHandle( vcd_handle, "start", "", 0 )

    if math.random(1,10) > 5 then
        local vcd_handle = Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_laugh0" .. math.random(1,6)].handle
        -- EntFireByHandle( Globals.TurretVoManager.vcds["sp_sabotage_factory_defect_laugh0"].handle, "SetTarget1", "replacement_template_turret", 0)
        EntFireByHandle( vcd_handle, "SetTarget1", "replacement_template_turret", 0)
		EntFireByHandle( vcd_handle, "start", "", math.Rand(0,0.2) )
    end
end

Globals.TurretVoManager.GoodTurretTest = function(turret)
    local initSecs = Globals.TurretVoManager.DoTemplate()

	local v = "sp_sabotage_factory_good_pass01"
	local vcd_handle = Globals.TurretVoManager.vcds[v].handle

    EntFireByHandle( vcd_handle, "SetTarget1", turret:GetName(), 0 )
	EntFireByHandle( vcd_handle, "start", "", initSecs )
	EntFire( "reject_turret_relay", "trigger", 0, initSecs + 0.0 + Globals.TurretVoManager.vcds[v].secs )
	EntFire( turret:GetName(), "RunScriptCode", "FunctioningTurretFling()", initSecs + 0.0 + Globals.TurretVoManager.vcds[v].secs)
end

Globals.TurretVoManager.DefectTurretTest = function(turret)
    local initSecs = Globals.TurretVoManager.DoTemplate()

    local v = Globals.TurretVoManager.FetchFromPool("defect_test")
    local vcd_handle = Globals.TurretVoManager.vcds[v].handle

    EntFireByHandle( vcd_handle, "SetTarget1", turret:GetName(), 0)
	EntFireByHandle( vcd_handle, "start", "", initSecs )

    if Globals.TurretVoManager.productionSwitched then
        EntFire( "accept_turret_relay", "trigger", 0, initSecs+Globals.TurretVoManager.vcds[v].secs)
		EntFire( turret:GetName(), "RunScriptCode", "MalfunctioningTurretSneakBy()", initSecs+0.0 + Globals.TurretVoManager.vcds[v].secs)
    else
        EntFire( "reject_turret_relay", "trigger", 0, initSecs + 0.0 + Globals.TurretVoManager.vcds[v].secs )
		EntFire( turret:GetName(), "RunScriptCode", "MalfunctioningTurretFling()", initSecs + 0.0 + Globals.TurretVoManager.vcds[v].secs)
    end
end

Globals.TurretVoManager.DefectTurretFail = function(turret)
    -- printl("=================DEFECT TURRET FAIL FLING: CALLER NAME: " .. turret:GetName() )

	local v = Globals.TurretVoManager.FetchFromPool("defect_fail")
	local vcd_handle = Globals.TurretVoManager.vcds[v].handle
	EntFireByHandle( vcd_handle, "SetTarget1", turret:GetName(), 0 )
	EntFireByHandle( vcd_handle, "start", "", 0.0 )
end

Globals.TurretVoManager.DefectTurretPass = function(turret)
    local initSecs = Globals.TurretVoManager.DoTemplate()

    local v = Globals.TurretVoManager.FetchFromPool("defect_pass")
	local vcd_handle = Globals.TurretVoManager.vcds[v].handle
	EntFireByHandle( vcd_handle, "SetTarget1", turret:GetName(), 0 )
	EntFireByHandle( vcd_handle, "start", "", initSecs )
	EntFire( "accept_turret_relay", "trigger", 0, initSecs+Globals.TurretVoManager.vcds[v].secs)
	EntFire( turret:GetName(), "RunScriptCode", "MalfunctioningTurretSneakBy()", initSecs+0.0 + Globals.TurretVoManager.vcds[v].secs)
end

Globals.TurretVoManager.DefectTurretSneakBy = function(turret)
    -- printl("=====SNEAKING BY!!!!" .. turret:GetName())
    local vcd_handle = nil

    if math.random(1, 10) > 5 then
        vcd_handle = Globals.TurretVoManager.vcds[Globals.TurretVoManager.FetchFromPool("defect_laugh")].handle
    else
        vcd_handle = Globals.TurretVoManager.vcds[Globals.TurretVoManager.FetchFromPool("defect_pass")].handle
    end

    EntFireByHandle( vcd_handle, "SetTarget1", turret:GetName(), 0 )
	EntFireByHandle( vcd_handle, "start", "", 0.5, null, null )
end

Globals.TurretVoManager.TemplateTurretTest = function(turret)
    -- printl("=================TEMPLATE TURRET PASS: CALLER NAME: " .. turret.GetName() )
    local vcd_handle = Globals.TurretVoManager.vcds["sp_sabotage_factory_template01"]
	EntFireByHandle( vcd_handle, "SetTarget1", turret:GetName(), 0) 
	EntFireByHandle( vcd_handle, "start", "", 1 )
end

Globals.TurretVoManager.FetchFromPool = function(poolname)
    if not Globals.TurretVoManager.vcdpools[poolname] then
        Globals.TurretVoManager.InitVcdPool(poolname)
    end

    if #Globals.TurretVoManager.vcdpools[poolname].queue == 0 then
        Globals.TurretVoManager.InitVcdPool(poolname)
    end

    local ret = Globals.TurretVoManager.vcdpools[poolname].queue[1]
	table.remove(Globals.TurretVoManager.vcdpools[poolname].queue, 1)
	return ret
end

Globals.TurretVoManager.InitVcdPool = function(poolname)
    if Globals.TurretVoManager.vcdpools[poolname] then
        Globals.TurretVoManager.vcdpools[poolname] = nil
    end

    local ta = {}
        for idx, val in pairs(Globals.TurretVoManager.vcds) do
        if val.group == poolname then
            table.insert(ta, idx)
        end
    end

    Globals.TurretVoManager.vcdpools[poolname] = {group = poolname, queue = {}}

    while #ta > 0 do
        local r = math.random(1, #ta)
        table.insert(Globals.TurretVoManager.vcdpools[poolname].queue, ta[r])
        table.remove(ta, r)
    end
end

Globals.TurretVoManager.GoodTurretShootPosition = function(turret)
    local v = Globals.TurretVoManager.FetchFromPool("good_prerange")
	local vcd_handle = Globals.TurretVoManager.vcds[v].handle
	EntFireByHandle( vcd_handle, "SetTarget1", turret:GetName(), 0 )
	EntFireByHandle( vcd_handle, "start", "", 0 )
	
	EntFire("dummyshoot_conveyor_1_spawn_rl", "trigger", 0, Globals.TurretVoManager.vcds[v].secs)
	EntFire("dummyshoot_conveyor_1_advance_train_relay", "trigger", 0, Globals.TurretVoManager.vcds[v].secs)
end

Globals.TurretVoManager.DefectTurretShootPosition = function(turret)
    local totsecs = 0
    local v = ""
    local vcd_handle = nil
  
    -- Play a pre-shooting line (20% chance)
    if math.random(1, 10) > 8 then
      v = Globals.TurretVoManager.FetchFromPool("defect_prerange")
      vcd_handle = Globals.TurretVoManager.vcds[v].handle
      EntFireByHandle(vcd_handle, "SetTarget1", turret:GetName(), 0 )
      EntFireByHandle(vcd_handle, "start", "", 0 )
      totsecs = totsecs + Globals.TurretVoManager.vcds[v].secs
    end
    
    -- Play the dryfire sound
    v = Globals.TurretVoManager.FetchFromPool("defect_dryfire")
    vcd_handle = Globals.TurretVoManager.vcds[v].handle
    EntFireByHandle(vcd_handle, "SetTarget1", turret:GetName(), 0 )
    EntFireByHandle(vcd_handle, "start", "", totsecs )
    totsecs = totsecs + Globals.TurretVoManager.vcds[v].secs
    
    -- Play a post shooting line
    v = Globals.TurretVoManager.FetchFromPool("defect_postrange")
    vcd_handle = Globals.TurretVoManager.vcds[v].handle
    EntFireByHandle(vcd_handle, "SetTarget1", turret:GetName(), 0 )
    EntFireByHandle(vcd_handle, "start", "", totsecs )
  
    -- Lines > 2.5 seconds get cut off unless we delay the conveyor a little
    if Globals.TurretVoManager.vcds[v].secs > 2.5 then
      totsecs = totsecs + 0.5 * (Globals.TurretVoManager.vcds[v].secs)
    else
      totsecs = totsecs + 0.2 * (Globals.TurretVoManager.vcds[v].secs)
    end
    
    -- Set the conveyor moving, spawn another turret
    EntFire("dummyshoot_conveyor_1_spawn_rl", "trigger", "", totsecs)
    EntFire("dummyshoot_conveyor_1_advance_train_relay", "trigger", "", totsecs)
end