DBG = false

stock_scanner_turret_type = 0
master_scanner_turret_type = 1  //  master starts out as functional turret

player_in_scanner = false // whether player is standing in scanner or not

function IsTemplateTurretFunctional()
    return master_scanner_turret_type
end

function ConveyorTurretFunctional()
    return stock_scanner_turret_type
end

function TemplateTurretBroken()
    if DBG then print("===== Switching master template to broken.") end
	master_scanner_turret_type = 0
end

function StockTurretFunctional()
    if DBG then print("===== Switching stock scanner to functional.") end
	stock_scanner_turret_type = 1
end

function StockTurretBroken()
    if DBG then print("===== Switching stock scanner to broken.") end
	stock_scanner_turret_type = 0
end

function SetStockDisplayPass()
    EntFire( "stock_scanner_display", "skin", "3", 0.5)
end

function SetStockDisplayFail()
    EntFire( "stock_scanner_display", "skin", "2", 0.5)
end

function SetStockDisplayReset()
    EntFire( "stock_scanner_display", "skin", "0", 0)
end

function SetMasterDisplayPass()
    if IsPlayerInScanner() then
        if DBG then print("===== Player in scanner. Overriding pass screen with error screen.") end
        EntFire( "master_scanner_display", "skin", "1", 0.5)
    else
        EntFire( "master_scanner_display", "skin", "3", 0.5)
    end
end

function SetMasterDisplayFail()
    EntFire( "master_scanner_display", "skin", "2", 0.5)
end

function SetMasterDisplayReset()
    EntFire( "master_scanner_display", "skin", "0", 0)
end

function SetResultDisplayBadMatch()
    EntFire( "result_scanner_display", "skin", "2", 0)
end

function SetResultDisplayGoodMatch()
    EntFire( "result_scanner_display", "skin", "3", 0)
end

function SetResultDisplayNoMatchLeftGreen()
    EntFire( "result_scanner_display", "skin", "5", 0)
end

function SetResultDisplayNoMatchRightGreen()
    EntFire( "result_scanner_display", "skin", "4", 0)
end

function SetResultDisplayReset()
    EntFire( "result_scanner_display", "skin", "0", 0)
end

function ResetScannerDisplays()
    if DBG then print("===== RESETTING ALL DISPLAYS.") end
	SetResultDisplayReset()
	SetStockDisplayReset()
	SetMasterDisplayReset()
end

function SetPlayerInScanner(bool)
    if DBG then print("===== Setting Player in scanner to " .. bool ) end
	player_in_scanner = bool
end

function IsPlayerInScanner()
    return player_in_scanner
end

function ScanMasterTurret()
    -- play scanner animation
    EntFire( "master_scanner_model", "SetAnimation", "turret_scanner_master_scan", 0)

    -- update the display with the results
    if IsTemplateTurretFunctional() then
        SetMasterDisplayPass()
    else
        SetMasterDisplayFail()
    end
end

function ScanStockTurret()
    -- play scanner animation
    EntFire( "stock_scanner_model", "SetAnimation", "turret_scanner_master_scan", 0)
    
    -- update the display with the results
    if ConveyorTurretFunctional() then
        SetStockDisplayPass()
    else
        SetStockDisplayFail()
    end
end

function DisplayScanResults()
    -- test with functional master
    if IsTemplateTurretFunctional() then
        if ConveyorTurretFunctional() then
            SetResultDisplayGoodMatch()
        else
            SetResultDisplayNoMatchRightGreen()
        end
    else
        if ConveyorTurretFunctional() then
            SetResultDisplayNoMatchLeftGreen()
        else
            SetResultDisplayBadMatch()
        end
    end
end