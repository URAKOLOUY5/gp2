function PlayStuckSound()
    print("=================I AM TURRET NAMED: " .. self:GetName())
    Globals.TurretVoManager.TurretStuck(self)
end

-- -------------------------------------------------------------------
-- Called when a functioning turret starts the self test and will pass
-- -------------------------------------------------------------------
function FunctioningTurretPass()
    print("=================TURRET NAME: " .. self:GetName())
    Globals.TurretVoManager.GoodTurretPass(self)
    --ScannerPassTurret()
end

-- -------------------------------------------------------------------
-- Called when a functioning turret starts the self test and will fail
-- -------------------------------------------------------------------
function FunctioningTurretFail()
    Globals.TurretVoManager.GoodTurretTest(self)
    --ScannerRejectTurret()
end

-- -------------------------------------------------------------------
-- Called when a malfunctioning turret starts the self test and will pass
-- -------------------------------------------------------------------
function MalfunctioningTurretPass()
    --self:EmitSound("turret.TurretStuckInTube01")
    Globals.TurretVoManager.DefectTurretPass(self)
    --ScannerPassTurret()
end

-- -------------------------------------------------------------------
-- Called when a malfunctioning turret starts the self test and will fail
-- -------------------------------------------------------------------
function MalfunctioningTurretFail()
    --self:EmitSound("turret.TurretStuckInTubeGoodbye01")
    Globals.TurretVoManager.DefectTurretTest(self)
    --ScannerRejectTurret()
end

function MalfunctioningTurretFling()
    Globals.TurretVoManager.DefectTurretFail(self)
end

function FunctioningTurretFling()
    Globals.TurretVoManager.GoodTurretFail(self)
end

function grabbedDefect()
    print("==========GRABBED A TURRET!")
    Globals.TurretVoManager.grabbedDefectTurret(self)
end

function MalfunctioningTurretSneakBy()
    print("===STARTING SNEAK!!!")
    Globals.TurretVoManager.DefectTurretSneakBy(self)
end

-- =======================================================================
-- =======================================================================

-- -------------------------------------------------------------------
-- Precache sounds we will emit
-- -------------------------------------------------------------------
function Precache()
    util.PrecacheSound("turret.TurretStuckInTube01")
    util.PrecacheSound("turret.TurretStuckInTubeGoodbye01")
end

-- -------------------------------------------------------------------
-- Allow turret to pass scanner
-- -------------------------------------------------------------------
function ScannerPassFunctionTurret()
    EntFire("accept_turret_relay", "trigger", 0, 4)
end

-- -------------------------------------------------------------------
-- Catapults the turret away 
-- -------------------------------------------------------------------
function ScannerRejectFunctioningTurret()
    EntFire("reject_turret_relay", "trigger", 0, 4)
end

-- -------------------------------------------------------------------
-- Allow turret to pass scanner
-- -------------------------------------------------------------------
function ScannerPassMalfunctionTurret()
    EntFire("accept_turret_relay", "trigger", 0, 4)
end

-- -------------------------------------------------------------------
-- Catapults the turret away
-- -------------------------------------------------------------------
function ScannerRejectMalfunctioningTurret()
    EntFire("reject_turret_relay", "trigger", 0, 4)
end


-- =======================================================================
-- =======================================================================

-- -------------------------------------------------------------------
-- Called when a functioning turret is in position to shoot a dummy
-- -------------------------------------------------------------------
function FunctioningTurretReachedDummyShootPosition()
    Globals.TurretVoManager.GoodTurretShootPosition(self)
end

-- -------------------------------------------------------------------
-- Called when a malfunctioning turret is in position to shoot a dummy
-- -------------------------------------------------------------------
function MalfunctioningTurretReachedDummyShootPosition()
    Globals.TurretVoManager.DefectTurretShootPosition(self)
end


-- -------------------------------------------------------------------
-- Spawn a turret to shoot at dummy
-- -------------------------------------------------------------------
function SpawnDummyShootTurret()
    print("***Spawning a turret to shoot at dummy!")

    -- spawn a new turret
    --EntFire("dummyshoot_conveyor_1_spawn_rl", "trigger", 0, 2 )

    -- send current train on down the line to exit
    --EntFire("dummyshoot_conveyor_1_advance_train_relay", "trigger", 0, 2 )
end


-- --------------------------------------------------------------------------------------------------------------
-- Turret Queue Functions
-- --------------------------------------------------------------------------------------------------------------
DBG = 0

if not Globals.GlobalTurretFactoryQueue then
    -- set up global queue
    Globals.GlobalTurretFactoryQueue = {}
end

function OnPostSpawn()
    if not Globals.GlobalTurretFactoryQueue then
        QueueInitialize()
        if DBG then print("===== Initializing QUEUE.  Length: " .. #Globals.GlobalTurretFactoryQueue) end
    end
end

--Initialize the queue
function QueueInitialize()
    table.clear(Globals.GlobalTurretFactoryQueue)
end

--Add a scene to the queue
function QueueAdd()
    table.insert(Globals.GlobalTurretFactoryQueue, self:GetName())
    if DBG then print("====== Adding " .. self:GetName() .. " to queue. Length = " .. #Globals.GlobalTurretFactoryQueue) end
    if #Globals.GlobalTurretFactoryQueue > 4 then
        if DBG then print("====== Turret queue reached " .. #Globals.GlobalTurretFactoryQueue .. ". Removing turret " .. Globals.GlobalTurretFactoryQueue[1] .. " New queue Length = " .. #Globals.GlobalTurretFactoryQueue) end

        -- detonate turret
        EntFire(Globals.GlobalTurretFactoryQueue[1], "selfdestruct", 0, 0)

        -- remove the turret from the queue
        QueueDeleteFirstItem()
    end
end

--Returns number of items in the queue
function QueueLen()
    return #Globals.GlobalTurretFactoryQueue
end

--Delete a single item by index from the queue
function QueueDelete(index)
    if QueueLen() == 0 then
        return false
    end
    -- remove from queue
    table.remove(Globals.GlobalTurretFactoryQueue, index)
end

--Sort through queue and remove self if found
function RemoveSelfFromQueue()
    turretname = self:GetName()
    if DBG then print("===== ATTEMPTING to remove self from queue: " .. turretname) end

    if QueueLen() == 0 then
        return false
    end
    for index, val in ipairs(Globals.GlobalTurretFactoryQueue) do
        if turretname == Globals.GlobalTurretFactoryQueue[index] then
            if DBG then print(" === removing #" .. index .. " named: " .. Globals.GlobalTurretFactoryQueue[index]) end
            table.remove(Globals.GlobalTurretFactoryQueue, index)
            return true
        end
    end
    return false
end

--Delete first item from the queue
function QueueDeleteFirstItem()
    QueueDelete(1)
end