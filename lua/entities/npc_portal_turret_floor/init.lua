-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Sentry turret with 3 legs and fancy laser
-- ----------------------------------------------------------------------------

include "shared.lua"

game.AddAmmoType({
    name = "PortalTurretBullet",
	dmgtype = DMG_BULLET, 
	tracer = TRACER_LINE_AND_WHIZ,
	plydmg = 3,
	npcdmg = 3,
    maxcarry = 150,
	force = 6251.624
})

local g_debug_turret = GetConVar("g_debug_turret")

local sv_portal_turret_burn_time_min = CreateConVar("sv_portal_turret_burn_time_min", "1.0", FCVAR_CHEAT, "The min time that the turret will burn for.")
local sv_portal_turret_burn_time_max = CreateConVar("sv_portal_turret_burn_time_max", "1.5", FCVAR_CHEAT, "The max time that the turret will burn for.")
local sv_portal_turret_shoot_at_death = CreateConVar("sv_portal_turret_shoot_at_death", "1", FCVAR_CHEAT, "If the turrets should shoot before they die.")

local TURRET_MODEL = "models/npcs/turret/turret.mdl"
local TURRET_MODEL_SKELETON = "models/npcs/turret/turret_skeleton.mdl"
local TURRET_MODEL_BOX = "models/npcs/turret/turret_boxed.mdl"
local TURRET_MODEL_BACKWARDS = "models/npcs/turret/turret_backwards.mdl"

local INDEX_TO_MODEL = {
    [0] = TURRET_MODEL,
    [1] = TURRET_MODEL,
    [2] = TURRET_MODEL_BOX,
    [3] = TURRET_MODEL_BACKWARDS,
    [4] = TURRET_MODEL_SKELETON,
}

local TURRET_FLOOR_DAMAGE_MULTIPLIER = 3
local TURRET_FLOOR_BULLET_FORCE_MULTIPLIER = 0.4
local TURRET_FLOOR_PHYSICAL_FORCE_MULTIPLIER = 135
local FLOOR_TURRET_MAX_WAIT = 5
local FLOOR_TURRET_SHORT_WAIT = 2
local FLOOR_TURRET_PING_TIME = 1
local PORTAL_FLOOR_TURRET_RANGE = 2.5
local PORTAL_FLOOR_TURRET_MAX_SHOT_DELAY = 2.5

local SF_START_INACTIVE = 64
local SF_FAST_RETIRE = 128
local SF_OUT_OF_AMMO = 256
local SF_FRIENDLY = 512

local VECTOR_CONE_4DEGREES = Vector( 3.490, 3.490 ) 

local STATE_ACTIVE = 0
local STATE_DEPLOY = 1
local STATE_SEARCH = 2
local STATE_ATTACK = 3
local STATE_HELD = 4
local STATE_BURN = 5
local STATE_INACTIVE = 6

local EYE_STATE_ON = 1
local EYE_STATE_SEES_TARGET = 2
local EYE_STATE_OFF = 3

local TALK_SEARCH       = 1
local TALK_AUTOSEARCH   = 2
local TALK_ACTIVE       = 3
local TALK_SUPRESS      = 4
local TALK_DEPLOY       = 5
local TALK_RETIRE       = 6
local TALK_TIPPED       = 7
local TALK_DISABLED     = 8
local TALK_COLLIDE      = 9
local TALK_PICKUP       = 10
local TALK_SHOTAT       = 11
local TALK_DISSOLVED    = 12
local TALK_FLUNG        = 13
local TALK_BURNED       = 14

local NEXT_SPEAK_ALLOW_TIME = 0

local TALK_NAMES = {
    "NPC_FloorTurret2.TalkSearch",
    "NPC_FloorTurret2.TalkAutosearch",
    "NPC_FloorTurret2.TalkActive",
    "NPC_FloorTurret2.TalkSupress",
    "NPC_FloorTurret2.TalkDeploy",
    "NPC_FloorTurret2.TalkRetire",
    "NPC_FloorTurret2.TalkTipped",
    "NPC_FloorTurret2.TalkDisabled",
    "NPC_FloorTurret2.TalkCollide",
    "NPC_FloorTurret2.TalkPickup",
    "NPC_FloorTurret2.TalkShotAt",
    "NPC_FloorTurret2.TalkDissolved",
    "NPC_FloorTurret2.TalkFlung",
    -- "NPC_FloorTurret2.TalkStartBurning",
    "NPC_FloorTurret2.TalkBurned"
}

local SPEAK_LINES_DELAY = {
    [TALK_SEARCH] = 2.75,
    [TALK_AUTOSEARCH] = 1.75,
    [TALK_ACTIVE] = 2.5,
    [TALK_SUPRESS] = 1.5,
    [TALK_DEPLOY] = 1.75,
    [TALK_RETIRE] = 3.5,
    [TALK_TIPPED] = 1.15,
    [TALK_PICKUP] = 2.25,
    [TALK_DISSOLVED] = 10.0,
    [TALK_BURNED] = 0,
}

local SPEAK_LINES_WITH_NO_REPEAT = {
    [TALK_AUTOSEARCH] = true,
    [TALK_SEARCH] = true,
    [TALK_DEPLOY] = true,
    [TALK_PICKUP] = true,
    [TALK_RETIRE] = true,
    [TALK_TIPPED] = true,
}

local SPEAK_LINES_WITH_NO_DELAY = {
    [TALK_DISSOLVED] = true,
    [TALK_FLUNG] = true,
    [TALK_TIPPED] = true,
}

ENT.__input2func = {
    ["enable"] = function(self, activator, caller, data)
        self:Enable()
    end,
    ["enablegagging"] = function(self, activator, caller, data)
        self:SetIsGagging(true)
    end,
    ["enablepickup"] = function(self, activator, caller, data)
        self:SetEnablePickup(true)
    end,
    ["disable"] = function(self, activator, caller, data)
        self:Disable()
    end,
    ["disablegagging"] = function(self, activator, caller, data)
        self:SetGagging(false)
    end,   
    ["diasblepickup"] = function(self, activator, caller, data)
        self:SetEnablePickup(false)
    end,     
    ["toggle"] = function(self, activator, caller, data)
        if not self:GetIsActive() then
            self:Enable()
        else
            self:Disable()
        end
    end,
    ["selfdestructimmediately"] = function(self, activator, caller, data)
        self:SetThink(self.ThinkBreak)
    end,
    ["firebullet"] = function(self, activator, caller, data)
        self:Shoot()
    end,
    ["setmodel"] = function(self, activator, caller, data)
        self:SetModel(INDEX_TO_MODEL[tonumber(data)] or TURRET_MODEL)
    end,
}

function ENT:Enable()
    if not self:GetIsActive() then
        self:SetThink(self.ThinkDeploy)
        self:SetIsActive(true)
    end
end

function ENT:Disable()
    if self:GetIsActive() then
        self:SetThink(self.ThinkRetire)
        self:SetIsActive(false)
    end
end

function ENT:KeyValue(k, v)
    if k == "Gagged" then
        self:SetIsGagged(tobool(v))
    elseif k == "UsedAsActor" then
        self:SetIsAsActor(tobool(v))
    elseif k == "CanShootThroughPortals" then
        self:SetCanShootThroughPortals(tobool(v))
    elseif k == "UseSuperDamageScale" then
        self:SetUseSuperDamageScale(tobool(v))
    elseif k == "TurretRange" then
        self:SetRange(tonumber(v))
    elseif k == "PickupEnabled" then
        self:SetPickupEnabled(tobool(v))            
    elseif k == "ModelIndex" then
        self.ModelIndex = 0
    elseif k == "SkinNumber" then
        self.SkinNumber = tonumber(v)
    elseif k == "DisableMotion" then
        self.DisableMotionAtSpawn = true
    end

    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end
end

function ENT:Initialize()
    self:CapabilitiesClear()

    self:SetModel(INDEX_TO_MODEL[self.ModelIndex or 0])

    self:SetMoveYawLocked(true)
    self:SetHealth(100)
    self:SetMaxHealth(100)
    self:SetUseType(SIMPLE_USE)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMaxYawSpeed(350)
    
    timer.Simple(0, function()
        self:SetMaxLookDistance(self:GetRange())
    end)

    debugoverlay.Line(self:EyePos(), self:EyePos() + self:EyeAngles():Forward() * self:GetRange(), 15)

    self.NextThinkTime = CurTime()

    self.NextThinkFunction = self.ThinkAutoSearch

    self.LastKnownPosition = Vector()
    self.LastVelocity = 0
    self.vecGoalAngles = Angle()
    self.LastSight = 0
    self.SearchSpeed = math.Rand(1.0, 1.4)
    self.NextActivateSoundTime = 0
    self.DistToEnemy = 0
    self.ShootWithBottomBarrels = false
    self.ShotTime = 0
    self.PingTime = 0
    self.BurnExplodeTime = 0
    self.ThrashTime = 0
    self.NextSpeakTime = 0
    self.LastSpeakLine = TALK_AUTOSEARCH

    self:SetState(STATE_ACTIVE)

    self.ActivityOpen = self:GetSequenceActivity(self:LookupSequence("deploy"))
    self.ActivityClose = self:GetSequenceActivity(self:LookupSequence("retract"))
    self.ActivityOpenIdle = self:GetSequenceActivity(self:LookupSequence("idlealert"))
    self.ActivityCloseIdle = self:GetSequenceActivity(self:LookupSequence("idle"))
    self.ActivityFire = self:LookupSequence("fire")
    self.ActivityFire2 = self:LookupSequence("fire2")
    self.ActivityEyeOff = self:GetSequenceActivity(self:LookupSequence("eye_off"))

    self.BarrelAttachments = {
        self:LookupAttachment("LFT_Gun1_Muzzle"),
        self:LookupAttachment("RT_Gun1_Muzzle"),
        self:LookupAttachment("LFT_Gun2_Muzzle"),
        self:LookupAttachment("RT_Gun2_Muzzle")
    }

    if self:HasSpawnFlags(SF_START_INACTIVE) then
        self:SetIsActive(false)
    end
    self:SetHasAmmo(not self:HasSpawnFlags(SF_OUT_OF_AMMO))
    self:SetIdealActivity(self.ActivityCloseIdle)

    self:SetNPCClass(CLASS_COMBINE)
    timer.Simple(0, function()
        self:SetNPCState(NPC_STATE_IDLE)
    end)

    if self.DisableMotionAtSpawn then
        self:GetPhysicsObject():EnableMotion(false)
    else
        self:GetPhysicsObject():Wake()
        self:DropToFloor()
    end
end

function ENT:RunAI( strExp )

	-- If we're running an Engine Side behaviour
	-- then return true and let it get on with it.
	if ( self:IsRunningBehavior() ) then
		return true
	end

	-- If we're doing an engine schedule then return true
	-- This makes it do the normal AI stuff.
	if ( self:DoingEngineSchedule() ) then
		return true
	end

	self:MaintainActivity()
end

function ENT:PreThink()
    if not self:GetIsActive() or self:GetIsAsActor() then return end

    if self.NextThinkFunction == self.ThinkBreak then return end

    -- Ignited by laser
    if self:IsOnFire() then
        if self.NextThinkFunction ~= self.ThinkBurn then
            self.NextSpeakTime = 0
            self.BurnExplodeTime = CurTime() + math.Rand(sv_portal_turret_burn_time_min:GetFloat(), sv_portal_turret_burn_time_max:GetFloat())
            self:SetThink(self.ThinkBurn)
        end
        return
    end

    if self.NextThinkFunction == self.ThinkInactive then return end

    self:MovingSuddenly()

    if self:IsOnSide() and not self:IsPlayerHolding() and self.NextThinkFunction ~= self.ThinkTipped then
        self:TrySpeak(TALK_TIPPED)
        self:SetThink(self.ThinkTipped)
        if self:GetHasAmmo() then
            self.ThrashTime = CurTime() + math.Rand(2.0, 2.5)
        else
            self.ThrashTime = CurTime()
        end
        self:SetNextThink(CurTime() + 0.05)
        return
    end

    if self:IsPlayerHolding() and self.NextThinkFunction ~= self.ThinkHeld then
        self:SetThink(self.ThinkHeld)
        self:TrySpeak(TALK_PICKUP)
    end
end

function ENT:MovingSuddenly()
    local phys = self:GetPhysicsObject()

    if self:IsPlayerHolding() then return end

    if phys and IsValid(phys) then
        local currentVelocitySqr = phys:GetVelocity():LengthSqr()
    
        if not (self:GetIsGagged() or self:GetIsAsActor()) and (currentVelocitySqr - self.LastVelocity) > 500^2 then
            self:EmitSound(TALK_NAMES[TALK_FLUNG])
        end

        self.LastVelocity = currentVelocitySqr
    end
end

function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()
    local func = self.__input2func[name]

    if func and isfunction(func) then
        func(self, activator, caller, data)
    end
end

function ENT:Think()
    if not self:HasCondition(COND.SEE_ENEMY) 
    or self:HasCondition(COND.ENEMY_TOO_FAR)
    or self.DistToEnemy > self:GetRange() then
        self:ClearEnemyMemory()
    end	

    self:PreThink()

    if self.NextThinkFunction 
    and isfunction(self.NextThinkFunction)
    and CurTime() > self.NextThinkTime then
        self:NextThinkFunction()
    end

    self:UpdateFacing()

    self:NextThink(CurTime())
    return true
end

function ENT:SetNextThink(nextThink)
    self.NextThinkTime = nextThink
end

function ENT:SetThink(nextThinkFunc)
    if nextThinkFunc then
        self.NextThinkFunction = nextThinkFunc
    end
end

function ENT:SelectSchedule( iNPCState )
	self:SetSchedule(SCHED_IDLE_STAND)
end

function ENT:ThinkAutoSearch()
    self.vecGoalAngles = self:GetAngles()
    self.MoveToFace = false
    self:SetIdealActivity(self.ActivityCloseIdle)

    self:TrySpeak(TALK_AUTOSEARCH)

    -- Spread out our thinking
    self:SetNextThink(CurTime() + math.Rand(0.2, 0.4))
    
    -- Deploy if we've got an active target
    if self:GetIsActive() then
        self:SetState(STATE_ACTIVE)
        self:SetEyeState(EYE_STATE_ON)

        if IsValid(self:GetEnemy()) and not self:GetIsAsActor() then
            self:SetThink(self.ThinkDeploy)
        end
    else
        self:SetEyeState(EYE_STATE_OFF)
    end
end

function ENT:ThinkDeploy()
    self.vecGoalAngles = self:GetAngles()
    self.MoveToFace = false

    self:SetNextThink(CurTime() + 0.05)

    -- Show we've seen a target
    --self:SetEyeState(TURRET_EYE_SEE_TARGET)

    self:TrySpeak(TALK_DEPLOY)

    -- Open if we're not already
    if self:GetActivity() ~= self.ActivityOpen then
        self:SetIdealActivity(self.ActivityOpen)
        self:EmitSound("NPC_FloorTurret.Deploy")

        -- Notify we're deploying
        self:TriggerOutput("OnDeploy", self)
    end

    if self:GetCycle() >= 0.99 then
        self:SetIdealActivity(self.ActivityOpenIdle)

        self.ShotTime = CurTime() + 1
        
        self:SetThink(self.ThinkSearch)
        --self:EmitSound("NPC_FloorTurret.Move")
    end

    self.LastSight = CurTime() + FLOOR_TURRET_MAX_WAIT
end

function ENT:ThinkSearch()
    local angles = self:GetAngles()

    -- If we've found a target, spin up the barrel and start to attack
    if IsValid(self:GetEnemy()) then
        -- Give enemies that are farther away a longer grace period
        local enemy = self:GetEnemy()
        local mid = self:EyePos()
        local enemyMid = enemy:BodyTarget(mid)

        self.DistToEnemy = (enemyMid - mid):Length()
        
        local distanceRatio = self.DistToEnemy / self:GetRange()
        self.ShotTime = CurTime() + distanceRatio ^ 2 * PORTAL_FLOOR_TURRET_MAX_SHOT_DELAY

        self.LastSight = 0
        self:SetThink(self.ThinkActive)

        if CurTime() > self.NextActivateSoundTime then
            self:EmitSound("NPC_FloorTurret.Activate")
            self.NextActivateSoundTime = CurTime() + 3
        end
        return
    end

    if CurTime() > self.LastSight then
        self.LastSight = 0
        self:SetThink(self.ThinkRetire)
        return
    end

    self:TrySpeak(TALK_SEARCH)

    self.vecGoalAngles.x = angles.x + ( math.sin( ( self.LastSight + CurTime() * self.SearchSpeed ) * 1.5 ) * 20 )
    self.vecGoalAngles.y = angles.y + ( math.sin( ( self.LastSight + CurTime() * self.SearchSpeed ) * 2.5 ) * 20 )   

    self:SetState(STATE_SEARCH)
    self:SetEyeState(EYE_STATE_ON)

    self.MoveToFace = true
    self:Ping()
end

function ENT:ThinkActive()
    -- Update our think time
    self:SetNextThink(CurTime() + 0.1)

    self:SetState(STATE_ATTACK)
    self:SetEyeState(EYE_STATE_SEES_TARGET)

    -- If we've become inactive, go back to searching
    if not self:GetIsActive() or not IsValid(self:GetEnemy()) then
        if self:HasSpawnFlags(SF_FAST_RETIRE) then
            self.LastSight = CurTime() + FLOOR_TURRET_SHORT_WAIT
        else
            self.LastSight = CurTime() + FLOOR_TURRET_MAX_WAIT
        end

        self.LastSight = CurTime() + FLOOR_TURRET_MAX_WAIT
        self:SetThink(self.ThinkSearch)
        self.vecGoalAngles = self:GetAngles()
        self.MoveToFace = true
        return
    end

    local enemy = self:GetEnemy()

    -- Get our shot positions
    local mid = self:EyePos()
    local enemyMid = enemy:BodyTarget(mid)
    
    self.LastKnownPosition = enemyMid

    -- Calculate dir and dist to enemy
    local dirToEnemy = enemyMid - mid
    local ownDir = self:GetAngles():Forward()
    self.DistToEnemy = dirToEnemy:Length()
        
    local distanceRatio = self.DistToEnemy / self:GetRange()

    local angleToEnemy = dirToEnemy:Angle()

    -- If we can see our enemy, face it
    if self:Visible(self:GetEnemy()) then
        self.vecGoalAngles.x = angleToEnemy.x
        self.vecGoalAngles.y = angleToEnemy.y
        self.MoveToFace = true
    end

    if self.DistToEnemy > self:GetRange() then
        self.LastSight = CurTime() + 2
        self:ClearEnemyMemory()
        self:SetEnemy(NULL)
        self:SetThink(self.ThinkSupress)

        return
    end

    if CurTime() > self.ShotTime then
        local canShoot = true
        local DOT_10DEGREE = math.rad(10)
        local slope = DOT_10DEGREE

        if self.DistToEnemy < 60 then
            dirToEnemy:Normalize()

            canShoot = dirToEnemy:Dot(ownDir) >= DOT_10DEGREE
            slope = 0.7071
        end

        -- Fire the gun
        if /*self:IsEnemyBehindGlass() or */ canShoot then
            local dot3d = dirToEnemy:Dot(ownDir)

            if not self:GetHasAmmo() then
                self:DryFire()
            else
                if dot3d >= slope then
                    self:SetIdealActivity(self.ActivityOpenIdle)
                    self:ResetSequence(self.ShootWithBottomBarrels and self.ActivityFire2 or self.ActivityFire)

                    -- Fire the weapon
                    self:Shoot(self:EyePos(), dot3d < DOT_10DEGREE)
                end
            end
        end
    end

    self:TrySpeak(TALK_ACTIVE)
end

-- unfinished
function ENT:ThinkSupress()
    -- Update our think time
    self:SetNextThink(CurTime() + 0.1)

    -- If we've acquired an enemy, start firing at it
    if IsValid(self:GetEnemy()) then
        self:SetThink(self.ThinkActive)
        return
    end

    -- See if we're done suppressing
    if CurTime() > self.LastSight then
        -- Should we look for a new target?
        self:SetThink(self.ThinkSearch)

        self.vecGoalAngles = self:GetAngles()
        self.MoveToFace = true

        if self:HasSpawnFlags(SF_FAST_RETIRE) then
            self.LastSight = CurTime() + FLOOR_TURRET_SHORT_WAIT
        else
            self.LastSight = CurTime() + FLOOR_TURRET_MAX_WAIT
        end
        
        return
    end

    // Get our shot positions
    local mid = self:EyePos()
    local enemyMid = self.LastKnownPosition
end

function ENT:ThinkRetire()
    -- Level out the turret
    self.MoveToFace = false

    self:TrySpeak(TALK_RETIRE)

    -- Set ourselves to close
    if self:GetActivity() ~= self.ActivityClose then
        -- Set our visible state to dormant
        -- self:SetEyeState(TURRET_EYE_DORMANT)

        self:SetIdealActivity(self.ActivityOpenIdle)

        if not self.MovingToFace then
            self:EmitSound("NPC_FloorTurret.Retire")

            self:SetIdealActivity(self.ActivityClose)

            -- Notify of the retraction
            self:TriggerOutput("OnRetire", self)
        end
    elseif self:GetCycle() >= 0.99 then
        self:SetIdealActivity(self.ActivityCloseIdle)
        self:SetThink(self.ThinkAutoSearch)
        if self:GetIsActive() then
            self.LastSight = 0

            self:SetNextThink(CurTime() + 0.05)
        end
    end
end

function ENT:ThinkHeld()
    self.MoveToFace = true

    self:SetState(STATE_HELD)

    self:SetNextThink(CurTime() + 0.05)
    self:SetEnemy(NULL)

    -- If we're not held anymore, stop thrashing
    if not self:IsPlayerHolding() then
        self:SetThink(self.ThinkSearch)
        self.LastSight = CurTime() + FLOOR_TURRET_MAX_WAIT
        self:SetNextThink(CurTime() + 0.05)
        return
    end
    
    -- See if we should continue to thrash
    if not self:IsFlagSet(FL_DISSOLVING) then
        if self.ShotTime < CurTime() then
            self:SetIdealActivity(self.ActivityOpenIdle)

            self:DryFire()
            self.ShotTime = CurTime() + math.Rand(0.25, 0.75)

            local angles = self:GetAngles()

            self.vecGoalAngles.x = angles.x + math.Rand(-15, 15)
			self.vecGoalAngles.y = angles.y + math.Rand(-40, 40)
        end
    end
end

function ENT:ThinkBurn()
    self:SetState(STATE_BURN)
    self:SetEyeState(EYE_STATE_SEES_TARGET)

    if CurTime() <= self.BurnExplodeTime then
        self:TrySpeak(TALK_BURNED)
        self.NextSpeakTime = CurTime()
    else
        self:SetThink(self.ThinkBreak)
        self:SetNextThink(CurTime())
    end
end

function ENT:ThinkBreak()
    local explosionPosition = self:GetPos()
    local explosionAngles = self:GetAngles()
    util.BlastDamage(self, self, explosionPosition, 10 * 12, 15)
    
    local effectData = EffectData()
    effectData:SetOrigin(explosionPosition)
    effectData:SetAngles(explosionAngles)
    util.Effect("Explosion", effectData)

    util.ScreenShake(explosionPosition, 20.0, 150.0, 0.75, 750.0)
    
    self:EmitSound("NPC_FloorTurret.Destruct")

    self:TriggerOutput("OnExplode")
    self:Remove()

    hook.Run("OnNPCKilled", self, game.GetWorld())
end

function ENT:ThinkTipped()
    self:SetNextThink(CurTime() + 0.05)
    self:SetEnemy(NULL)

    if not self:GetHasAmmo() then
        self:SetThink(self.ThinkInactive)
        return
    end
    
    -- If we're not on side anymore, stop thrashing
    if not self:IsOnSide() then
        self:ReturnToLife()
        return
    end

    -- See if we should continue to thrash
    if (CurTime() < self.ThrashTime and not self:IsFlagSet(FL_DISSOLVING)) then
        if self.ShotTime < CurTime() then
            if not self:GetHasAmmo() then
                self:SetIdealActivity(self.ActivityOpenIdle)
                self:DryFire()
            elseif (sv_portal_turret_shoot_at_death:GetBool()) then
                local attach = self:GetAttachment(1)

                self:SetIdealActivity(self.ActivityOpenIdle)

                if attach then
                    self:Shoot(self:EyePos())
                end
            end

            self.ShotTime = CurTime() + 0.05
        end

        local angles = self:GetAngles()

        self.vecGoalAngles.x = angles.x + math.Rand(-60, 60)
		self.vecGoalAngles.y = angles.y + math.Rand(-60, 60)
        self.MoveToFace = true
    else
        -- Face forward
        self.vecGoalAngles = self:GetAngles()
        self.MoveToFace = false

        -- Set ourselves to close
        if self:GetActivity() ~= self.ActivityClose then
            self:SetIdealActivity(self.ActivityOpenIdle)

            -- If we're done moving to our desired facing, close up
            if not self.MovingToFace then
                -- Make any last death noises and anims
                self:EmitSound("NPC_FloorTurret.Die")

                self:SetIdealActivity(self.ActivityClose)
                self:EmitSound("NPC_FloorTurret.Retract")

                self:TrySpeak(TALK_DISABLED)

                local dmginfo = DamageInfo()
                dmginfo:SetDamageType(DMG_CRUSH)
                hook.Run( "OnNPCKilled", self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
            end
        elseif self:GetCycle() >= 0.99 then
            self:SetIdealActivity(self.ActivityEyeOff)
            self:SetEyeState(EYE_STATE_OFF)
            self:SetThink(self.ThinkInactive)
        end
    end
end

function ENT:ThinkInactive()
    self:SetNextThink(CurTime() + 1)

    self:SetState(STATE_INACTIVE)

    -- Wake up if we're not on our side
    if not self:IsOnSide() then
        self:SetCollisionGroup(COLLISION_GROUP_NONE)
    else
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    end

    if self:IsOnFire() then
        self:ReturnToLife()
    end
end

function ENT:UpdateFacing()
    local vecGoalLocalAngles = self:WorldToLocalAngles(self.vecGoalAngles)
    local epsilon = 0.1
    
    local currentPitch = self:GetPoseParameter("aim_pitch")
    local currentYaw = self:GetPoseParameter("aim_yaw")

    local targetPitch = self.MoveToFace and vecGoalLocalAngles.x or 0
    local targetYaw = self.MoveToFace and vecGoalLocalAngles.y or 0

    local pitch = math.ApproachAngle(currentPitch, targetPitch, 0.005 * self:GetMaxYawSpeed())
    local yaw = math.ApproachAngle(currentYaw, targetYaw, 0.005 * self:GetMaxYawSpeed())

    self.MovingToFace = math.abs(pitch - targetPitch) > epsilon or math.abs(yaw - targetYaw) > epsilon

    self:SetPoseParameter("aim_pitch", pitch)
    self:SetPoseParameter("aim_yaw", yaw)

    if IsValid(self:GetEnemy()) then
        self:SetEyeTarget(self:GetEnemy():BodyTarget(self:EyePos()))
    else
        self:SetEyeTarget(vector_origin)
    end
end

function ENT:Shoot(vecSrc, strict)
    local enemy = self:GetEnemy()

    local bullet = { 
        Num = 1, 
        Src = vecSrc, 
        Tracer = 1,
        Damage = self:GetAttackDamageScale(),
        Attacker = self,
        Spread = self:GetAttackSpread(),
        AmmoType = "PortalTurretBullet",
        TracerName = "AR2Tracer",
        IgnoreEntity = self
    }

    // if modelIndex == 3 do something

    bullet.Force = not self:GetDamageForce() and 0 or TURRET_FLOOR_BULLET_FORCE_MULTIPLIER

    local barrelIndex = self.ShootWithBottomBarrels and 3 or 1

    -- Shoot out of the left barrel if there's nothing solid between the turret's center and the muzzle
    local attach = self:GetAttachment(self.BarrelAttachments[barrelIndex])
    if attach then
        bullet.Src = attach.Pos
    end

    if not strict and (IsValid(enemy)) then
        bullet.Dir = enemy:BodyTarget(bullet.Src, true) - bullet.Src
    else
        bullet.Dir = attach.Ang:Forward()
    end

    local tr = util.TraceLine({
        start = self:GetPos(),
        endpos = bullet.Src,
        mask = MASK_SHOT,
        filter = self,
    })

    if not tr.Hit then
        self:FireBullets(bullet)
        debugoverlay.Line(bullet.Src, bullet.Src + bullet.Dir * self:GetRange())
    end

    -- Shoot out of the right barrel if there's nothing solid between the turret's center and the muzzle
    attach = self:GetAttachment(self.BarrelAttachments[barrelIndex + 1])

    if attach then
        bullet.Src = attach.Pos
    end

    if not strict and (IsValid(enemy)) then
        bullet.Dir = enemy:BodyTarget(bullet.Src, true) - bullet.Src
    else
        bullet.Dir = attach.Ang:Forward()
    end

    local tr = util.TraceLine({
        start = self:GetPos(),
        endpos = bullet.Src,
        mask = MASK_SHOT,
        filter = self,
    })

    if not tr.Hit then
        self:FireBullets(bullet)
        debugoverlay.Line(bullet.Src, bullet.Src + bullet.Dir * self:GetRange())
    end

    -- Flip shooting from the top or bottom
    self.ShootWithBottomBarrels = not self.ShootWithBottomBarrels

    self:EmitSound("NPC_FloorTurret.ShotSounds")

    local up = self:GetAngles():Up()

    -- If a turret is partially tipped the recoil with each shot so that it can knock itself over
    if up.z < 0.9 then
        local phys = self:GetPhysicsObject()

        if IsValid(phys) then
            phys:AddVelocity(bullet.Dir * -0.35)
            --self:TrySpeak(self.LastSpeakLine)
            --self.NextTalk = CurTime() + 2.5
        end
    end
end

function ENT:DryFire()
    self:EmitSound("NPC_FloorTurret.DryFire")
    self:EmitSound("NPC_FloorTurret.Activate")

    if math.Rand(0, 1) > 0.5 then
        self.ShotTime = CurTime() + math.Rand(1, 2.5)
    else
        self.ShotTime = CurTime()
    end
end

function ENT:Ping()
    -- See if it's time to ping again
    if self.PingTime > CurTime() then
        return
    end

    -- Ping!
    self:EmitSound("NPC_FloorTurret.Ping")

    self.PingTime = CurTime() + FLOOR_TURRET_PING_TIME
end

function ENT:GetAttackSpread(wep, target)
    local weaponProficiency = WEAPON_PROFICIENCY_AVERAGE

    if IsValid(target) then
        if target:IsPlayer() or (target:IsNPC() and (target:Classify() == CLASS_ANTLION or target:Classify() == CLASS_ZOMBIE) ) then
            weaponProficiency = WEAPON_PROFICIENCY_PERFECT
        else
            weaponProficiency = WEAPON_PROFICIENCY_VERY_GOOD
        end
    end

    return VECTOR_CONE_4DEGREES * self:GetWeaponProficiencyValues()[weaponProficiency + 1].spread
end

function ENT:SetCurrentWeaponProficiency(proficiency)
    self.WeaponProficiency = proficiency
end

function ENT:GetCurrentWeaponProficiency()
    return self.WeaponProficiency or WEAPON_PROFICIENCY_AVERAGE
end

function ENT:GetWeaponProficiencyValues()
    self.ProficiencyTable = self.ProficiencyTable or {
        { spread = 2.50, bias = 1.0 },
        { spread = 2.00, bias = 1.0 },
        { spread = 1.50, bias = 1.0 },
        { spread = 1.25, bias = 1.0 },
        { spread = 1.00, bias = 1.0 },
    }

    return self.ProficiencyTable
end

function ENT:GetAttackDamageScale()
    if IsValid(self:GetEnemy()) then
        if self:GetEnemy():IsPlayer() then
            -- Do normal damage when trashing
            if self:IsOnSide() then
                return 1.0
            end

            return TURRET_FLOOR_DAMAGE_MULTIPLIER
        end

        if self:GetUseSuperDamageScale() then
            return TURRET_FLOOR_DAMAGE_MULTIPLIER * 4.0
        end

        return TURRET_FLOOR_DAMAGE_MULTIPLIER
    end
    
    return 1
end

function ENT:IsOnSide()
    if self:WaterLevel() > 0 then
        return true
    end

    local up = self:GetUp()

    return vector_up:Dot(up) < 0.5 
end

function ENT:Use(activator, caller, useType, value)
    if activator:IsPlayer() and not self:IsPlayerHolding() then
        activator:PickupObject(self)
    end
end

function ENT:ReturnToLife()
    self.ThrashTime = 0

    self:SetEyeState(EYE_STATE_ON)
    self:SetThink(self.ThinkSearch)
    self:SetCollisionGroup(COLLISION_GROUP_NONE)
end

function ENT:OnTakeDamage(info)
    if not self:GetIsActive() or self:GetIsAsActor() then return end

    if self:GetState() < STATE_SEARCH then 
        self:SetThink(self.ThinkDeploy)
    end

    local phys = self:GetPhysicsObject()

    self.LastSight = CurTime() + FLOOR_TURRET_MAX_WAIT

    if IsValid(phys) 
    and IsValid(info:GetAttacker()) 
    and info:GetAttacker():GetClass() ~= self:GetClass()
    and (info:GetAttacker():IsPlayer() or info:GetAttacker():IsNPC() or info:GetAttacker():IsNextBot())
    then
        phys:SetVelocity(info:GetDamageForce() / phys:GetMass())
    end
    return 0
end

function ENT:TrySpeak(line, skipglobal)
    if not self:GetIsActive() or self:GetIsGagged() or self:GetIsAsActor() then return end

    if self.LastSpeakLine == line and SPEAK_LINES_WITH_NO_REPEAT[line] then
        return
    end

    if not SPEAK_LINES_WITH_NO_DELAY[line] then
        if CurTime() < NEXT_SPEAK_ALLOW_TIME or CurTime() < self.NextSpeakTime then
            return
        end
    end
    
    self:EmitSound(TALK_NAMES[line])

    if not SPEAK_LINES_WITH_NO_DELAY[line] then
        self.NextSpeakTime = CurTime() + (SPEAK_LINES_DELAY[line] or 0.5)
        if not skipglobal then
            NEXT_SPEAK_ALLOW_TIME = CurTime() + 0.5 -- always 0.5
        end
    end
    
    self.LastSpeakLine = line
end

function ENT:GetPreferredCarryAngles(ply)
    -- Fix PITCH rotation for turret
    local angles = ply:EyeAngles()
    local selfAngles = self:GetAngles()
    return Angle(0 - angles.x,0,0)
end

function ENT:OnPhysgunPickup(ply, ent)
    if self:GetPickupEnabled() and self:GetPickupEnabled() then
        self:TriggerOutput("OnPhysGunPickup")
    end

    return self:GetPickupEnabled()
end

function ENT:OnPhysgunDrop(ply, ent)
    if self:GetPickupEnabled() and self:GetPickupEnabled() then
        self:TriggerOutput("OnPhysGunDrop")
    end
end

function ENT:OnPlayerPickup(ply, ent)
    if self:GetPickupEnabled() then
        self:TriggerOutput("OnPlayerPickup")
        self:TriggerOutput("OnPhysGunPickup")
    end
end

function ENT:OnPlayerDrop(ply, ent, thrown)
    if self:GetPickupEnabled() then
        self:TriggerOutput("OnPlayerDrop")            
        self:TriggerOutput("OnPhysGunDrop")
    end
end