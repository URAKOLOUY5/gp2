-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Turret
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Base = "base_ai"

local TURRET_MODEL = "models/npcs/turret/turret.mdl"
local TURRET_MODEL_SKELETON = "models/npcs/turret/turret_skeleton.mdl"
local TURRET_MODEL_BOX = "models/npcs/turret/turret_boxed.mdl"
local TURRET_MODEL_BACKWARDS = "models/npcs/turret/turret_backwards.mdl"

local SF_START_INACTIVE = 64
local SF_FAST_RETIRE = 128
local SF_OUT_OF_AMMO = 256
local SF_FRIENDLY = 512

local INDEX_TO_MODEL = {
    [0] = TURRET_MODEL,
    [1] = TURRET_MODEL,
    [2] = TURRET_MODEL_BOX,
    [3] = TURRET_MODEL_BACKWARDS,
    [4] = TURRET_MODEL_SKELETON,
}
 
local STATE_ACTIVE = 1
local STATE_ON_SIDE = 2
local STATE_ON_FIRE = 3
local STATE_INACTIVE = 4

local EYE_STATE_ON = 1
local EYE_STATE_SEES_TARGET = 2
local EYE_STATE_OFF = 3

local BLACKLISTED_ENEMIES = {
    ["npc_security_camera"] = true
}

local PORTAL_FLOOR_TURRET_MAX_SHOT_DELAY = 2

AccessorFunc( ENT, "m_iClass", "NPCClass" )

PrecacheParticleSystem("turret_coop_explosion")

ENT.AutomaticFrameAdvance = true

local g_debug_turret = GetConVar("g_debug_turret")
local sv_portal_turret_burn_time_min = CreateConVar("sv_portal_turret_burn_time_min", "1.0", FCVAR_CHEAT, "The min time that the turret will burn for.")
local sv_portal_turret_burn_time_max = CreateConVar("sv_portal_turret_burn_time_max", "1.5", FCVAR_CHEAT, "The max time that the turret will burn for.")
local sv_portal_turret_shoot_at_death = CreateConVar("sv_portal_turret_shoot_at_death", "1", FCVAR_CHEAT, "If the turrets should shoot before they die.")

local debugColorGreen = Color(0,255,155)
local debugColorRed = Color(247,92,92)

-- -------------------------------------------------
-- Server methods
-- -------------------------------------------------
if SERVER then
    local DEGREES_45_CONE = math.rad(55)
    local VECTOR_CONE_4DEGREES = Vector( 0.03490, 0.03490 )
    local NEXT_SPEAK_ALLOW_TIME = 0 -- don't spam with sounds, alternative to sound operators
    
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
        [TALK_BURNED] = 0.5,
    }

    local SPEAK_LINES_WITH_NO_REPEAT = {
        [TALK_AUTOSEARCH] = true,
        [TALK_SEARCH] = true,
        [TALK_PICKUP] = true,
        [TALK_RETIRE] = true,
        [TALK_TIPPED] = true,
    }

    local SPEAK_LINES_WITH_NO_DELAY = {
        [TALK_BURNED] = true,
        [TALK_DISSOLVED] = true,
        [TALK_FLUNG] = true,
    }
    
    local TURRET_FLOOR_DAMAGE_MULTIPLIER = 3
    local TURRET_FLOOR_BULLET_FORCE_MULTIPLIER = 0.4
    local TURRET_FLOOR_PHYSICAL_FORCE_MULTIPLIER = 135
    local FLOOR_TURRET_MAX_WAIT = 5
    local FLOOR_TURRET_SHORT_WAIT = 2

    ENT.__input2func = {
        ["enable"] = function(self, activator, caller, data)
            self:Enable()
        end,
        ["enablegagging"] = function(self, activator, caller, data)
            self:SetGagging(true)
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
            self:SetThinkFunction(self.ThinkBreak)
        end,
        ["firebullet"] = function(self, activator, caller, data)
            self:Shoot(ents.FindByName(data)[1])
        end,
    }

    function ENT:KeyValue(k, v)
        if k == "Gagged" then
            self:SetGagged(tobool(v))
        elseif k == "UsedAsActor" then
            self:SetAsActor(tobool(v))
        elseif k == "CanShootThroughPortals" then
            self:SetCanShootThroughPortals(tobool(v))
        elseif k == "UseSuperDamageScale" then
            self:SetUseSuperDamageScale(tobool(v))
        elseif k == "TurretRange" then
            self:SetRange(tonumber(v))
        elseif k == "PickupEnabled" then
            self:SetPickupEnabled(tobool(v))            
        elseif k == "ModelIndex" then
            self:SetModel(INDEX_TO_MODEL[tonumber(v)] or TURRET_MODEL)
            self.GotModel = true
        elseif k == "SkinNumber" then
            self.SkinNumber = tonumber(v)
        elseif k == "spawnflags" then
            self.SpawnFlags = tonumber(v)
        elseif k == "DisableMotion" then
            self.DisableMotionAtSpawn = true
        end
    
        if k:StartsWith("On") then
            self:StoreOutput(k, v)
        end
    end

    function ENT:HasSpawnflag(sf)
        return bit.band(self:GetInternalVariable("spawnflags"), sf) ~= 0
    end

    function ENT:Initialize()
        self.Enemy = NULL
        self.LastKnownEnemy = NULL
        self.NextShotTime = 0
        self.LastSight = 0
        self.SearchSpeed = math.Rand(1.0, 1.4)
        self.ThinkFunction = self:GetAsActor() and self.ThinkActor or self.ThinkIdle
        self.ThinkNextFunction = CurTime() + 0.1
        self.SequenceFinishTime = 0
        self.ThrashTime = 0
        self.vecGoalAngles = self:GetAngles()
        self.vecGoalAnglesLast = self:GetAngles()
        self.NextAlertSound = 0
        self.RelaxTimeFinished = 0
        self.BurnExplodeTime = 0
        self.NextSpeakTime = 0
        self.LastSpeakLine = -1
        self.LastCachedSpeed = 0
        self.NextShakeTime = 0

        if not self.GotModel then
            self:SetModel(TURRET_MODEL)
        end

        self:SetHealth(10)
        self:SetSkin(self.SkinNumber or 0)
        self:SetBloodColor(DONT_BLEED)
        self:SetNPCClass(CLASS_COMBINE)
        self:SetUseType(SIMPLE_USE)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveYawLocked(true)

        if self.DisableMotionAtSpawn then
            self:GetPhysicsObject():EnableMotion(false)
        else
            self:GetPhysicsObject():Wake()
            self:DropToFloor()
        end

        self:SetHasAmmo(not self:HasSpawnFlags(SF_OUT_OF_AMMO))
        
        -- Normalize angles to prevent some issues
        local angles = self:GetAngles()
        angles:Normalize()
        self:SetAngles(angles)

        self.SequenceRetract = self:LookupSequence("retract")
        self.SequenceDeploy = self:LookupSequence("deploy")

        if not self:HasSpawnFlags(SF_START_INACTIVE) then
            self:SetIsActive(true)
        end
    end

    function ENT:AcceptInput(name, activator, caller, data)
        name = name:lower()
        local func = self.__input2func[name]
    
        if func and isfunction(func) then
            func(self, activator, caller, data)
        end
    end

    function ENT:Disable()
        if self:GetIsActive() then
            self:SetIsActive(false)
            self:PlaySequence("retract")
            self.LastSight = CurTime() + (self:HasSpawnflag(SF_FAST_RETIRE) and FLOOR_TURRET_SHORT_WAIT or FLOOR_TURRET_MAX_WAIT)
        end
    end

    function ENT:Enable()
        if not self:GetIsActive() then
            self:SetIsActive(true)
            self:PlaySequence("deploy")
            self:TriggerOutput("OnDeploy")
            self:SetThinkFunction(self.ThinkSearch)
        end
    end

    function ENT:IsNPC()
        return true
    end

    function ENT:GetEyePos()
        return self:GetAttachment(self:LookupAttachment("eyes")).Pos
    end

    function ENT:PlaySequence(name, addDuration)
        addDuration = addDuration or 0

        self:ResetSequence(name)
        self:ResetSequenceInfo()

        self.SequenceFinishTime = CurTime() + self:SequenceDuration() + addDuration
    end

    function ENT:PlayingSequenceFinished()
        return CurTime() > self.SequenceFinishTime + 0.5
    end

    function ENT:ThinkActor()
        self.NextShakeTime = 0
        self.vecGoalAngles = self:GetAngles()
    end

    function ENT:ThinkIdle()
        self.NextShakeTime = 0
        self.vecGoalAngles = self:GetAngles()

        if not self:HasEnemy() then
            if IsValid(self.LastKnownEnemy) then
                self:TrySpeak(TALK_AUTOSEARCH)
            end
        end

        if self:PlayingSequenceFinished() then
            if self:HasEnemy() then
                --GP2.Print("ThinkIdle: Found enemy")
                self.NextShotTime = CurTime() + 1
                self:SetThinkFunction(self.ThinkSearch)
                self:SetEyeState(EYE_STATE_ON)
                self:SetNextThink(CurTime() + 0.05)
            end
        end
    end

    function ENT:ThinkDeploy()
        if self:PlayingSequenceFinished() then
            self:TrySpeak(TALK_DEPLOY)
            self:SetThinkFunction(self.ThinkAttack)
        end
    end

    function ENT:ThinkAttack()
        if self:HasEnemy() then
            self:Shoot(self:GetEnemy())

            local dir = self:GetEnemy():GetPos() - self:GetPos()

            self.vecGoalAngles = dir:Angle()
            self:SetEyeState(EYE_STATE_SEES_TARGET)
        else
            self:SetThinkFunction(self.ThinkSearch)
            self:SetEyeState(EYE_STATE_ON)
            self:SetNextThink(CurTime() + 0.05)
        end
    end

    function ENT:ThinkSearch()
        self:SetState(STATE_ACTIVE)

        if self:GetSequenceName(self:GetSequence()) == "retract" or self:GetSequenceName(self:GetSequence()) == "idle" then
            self:PlaySequence("deploy", -0.5)
        elseif self:IsSequenceFinished() then
            if self:HasEnemy() then
                -- I searched and found enemy
                self:SetThinkFunction(self.ThinkDeploy)
                --GP2.Print("ThinkSearch: Found enemy")

                self.NextShakeTime = CurTime() + 1
                self:EmitAlertSound()
                self:TriggerOutput("OnDeploy")
    
                -- Give enemies that are farther away a longer grace period
                local distanceRatio = self:GetPos():Distance(self:GetEnemy():GetPos()) / self:GetRange()
                self.NextShotTime = CurTime() + 0.5 + distanceRatio * distanceRatio * PORTAL_FLOOR_TURRET_MAX_SHOT_DELAY
            else
                if CurTime() > self.LastSight then
                    self.vecGoalAngles = self:GetAngles()

                    self:TrySpeak(TALK_RETIRE)
                    self:TriggerOutput("OnRetire")
                    if self:IsRelaxedAim() then
                        self.NextShakeTime = CurTime() + 1
                        self:PlaySequence("retract") 
                        self:SetThinkFunction(self.ThinkIdle)
                        self:SetNextThink(CurTime() + 0.1)
                    end
                else
                    local angles = self:GetAngles()
    
                    self:TrySpeak(TALK_SEARCH)
    
                    self.vecGoalAngles.x = angles.x + ( math.sin( ( self.LastSight + CurTime() * self.SearchSpeed ) * 1.5 ) * 20 )
                    self.vecGoalAngles.y = angles.y + ( math.sin( ( self.LastSight + CurTime() * self.SearchSpeed ) * 2.5 ) * 20 )   
                    
                    self.NextShotTime = CurTime() + 1
                end
            end
        end
    end

    function ENT:ThinkHeld()
        self:ResetSequence("idlealert")

        if not self:IsPlayerHolding() and self:GetState() ~= STATE_ON_FIRE then
            self:SetThinkFunction(self.ThinkSearch)
            self:SetNextThink(CurTime() + 0.1)
            return
        end

        self:TrySpeak(TALK_PICKUP)

        self.LastSight = CurTime() + FLOOR_TURRET_MAX_WAIT
        
        -- if not self:Dissolving() then
        if self.NextShotTime < CurTime() then
            self:DryFire()
            self.NextShotTime = CurTime() + math.Rand(0.25, 0.75)

            self.vecGoalAngles.x = self:GetAngles().x + math.Rand(-15, 15)
            self.vecGoalAngles.y = self:GetAngles().y + math.Rand(-40, 40)
        end
        -- end
    end

    function ENT:ThinkBurn()
        self:SetEyeState(EYE_STATE_SEES_TARGET)

        if CurTime() > self.BurnExplodeTime then
            self:SetThinkFunction(self.ThinkBreak)
            self:SetNextThink(CurTime())
        else
            self:TrySpeak(TALK_BURNED, true)
            self.NextSpeakTime = CurTime() + math.Rand(0.5, 0.75)
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
        
        self:TriggerOutput("OnExplode")
        self:Remove()
    end

    function ENT:ThinkTipped()
        if not self:IsOnSide() then
            self:ReturnToLife()
            return
        end

        -- See if we should continue to thrash
        if not self:GetHasAmmo() then
            self:SetThinkFunction(self.ThinkInactive)
        else
            if CurTime() < self.ThrashTime then
                if self.NextShotTime < CurTime() then
                    if not self:GetHasAmmo() then
                        self:PlaySequence("alertidle")
                        self:DryFire()
                    elseif sv_portal_turret_shoot_at_death:GetBool() then
                        self:Shoot()
                    end
    
                    self.ShotTime = CurTime() + 0.05
                end
    
                self:TrySpeak(TALK_TIPPED)
    
                self.vecGoalAngles.x = self:GetAngles().x + math.Rand(-60, 60)
                self.vecGoalAngles.y = self:GetAngles().y + math.Rand(-60, 60)
            else
                self.vecGoalAngles = self:GetAngles()
                
                if self:GetSequenceName(self:GetSequence()) ~= "retract" then
                    self:PlaySequence("retract")
                    self:SetEyeState(EYE_STATE_OFF)
                    self:TriggerOutput("OnTipped")
                elseif self:IsSequenceFinished() then
                    self:SetState(STATE_INACTIVE)
                    self:TrySpeak(TALK_DISABLED)
                    self:EmitSound('NPC_FloorTurret.Die')
                    self:PlaySequence("eye_off")
                    self:SetThinkFunction(self.ThinkInactive)
                end
            end
        end
    end

    function ENT:Think()
        if IsValid(self:GetHoldingPlayer()) and not self:IsPlayerHolding() then
            self:SetHoldingPlayer(NULL)
        end
   
        if self:IsMovingSuddenly() then
            self:TrySpeak(TALK_FLUNG)
            self.NextSpeakTime = CurTime() + 1.0
        end

        if self:GetIsActive() then
            if self:IsOnFire() then
                if not (self:GetState() == STATE_ON_FIRE) then
                    self.BurnExplodeTime = CurTime() + math.Rand(sv_portal_turret_burn_time_min:GetFloat(), sv_portal_turret_burn_time_max:GetFloat())
                    self:SetThinkFunction(self.ThinkBurn)
                    self:SetState(STATE_ON_FIRE)
                end
            else
                self:FindEnemy()
    
                if not self:IsPlayerHolding() then
                    if self:IsOnSide() and not (self:GetState() > STATE_ACTIVE) and not self:GetAsActor() then
                        if self:GetHasAmmo() then
                            self.ThrashTime = CurTime() + math.Rand(2, 2.5)
                        end
                        
                        self:SetState(STATE_ON_SIDE)
                        self:SetThinkFunction(self.ThinkTipped)
                    end
                end
            end
    
            if self.ThinkFunction and isfunction(self.ThinkFunction) and CurTime() > self.ThinkNextFunction then
                self.ThinkFunction(self)
            end
            
            local moved = self:UpdateFacing(self.vecGoalAngles)

            if moved and self.ThinkFunction == self.ThinkAttack then
                self.NextShakeTime = CurTime() + 1
            end
        end

        self:NextThink(CurTime())
        return true
    end

    function ENT:ThinkInactive()
        self.vecGoalAngles = self:GetAngles()
    end

    function ENT:SetThinkFunction(func)
        self.ThinkFunction = func
    end

    function ENT:SetNextThink(time)
        self.ThinkNextFunction = time
    end

    function ENT:Classify()
        return CLASS_COMBINE
    end

    -- Find enemy in cone 
    function ENT:FindEnemy()
        local incone = ents.FindInCone(self:GetPos(), self:GetAngles():Forward(), self:GetRange(), 0.5)
        self.Enemy = NULL
        local selfClass = self:GetClass()
    
        for i = 1, #incone do
            local ent = incone[i]

            -- I'm not reacting to myself
            if ent == self then
                continue
            end
    
            -- If it's not any of these guys
            if not (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) then
                continue
            end
    
            -- If player is not alive
            if ent:IsPlayer() and not ent:Alive() then
                continue
            end

            -- If entity has notarget
            if bit.band(ent:GetFlags(), FL_NOTARGET) ~= 0 then
                continue
            end

            -- If npc's class is not mine (others can shoot at me probably)
            if ent:IsNextBot() and ent.Classify and ent:Classify() == CLASS_COMBINE then
                continue
            end

            if ent:IsNPC() and ent:Classify() == CLASS_COMBINE then
                continue
            end

            if ent:Health() <= 0 then continue end
    
            -- Don't react to some entities, because I don't care about them
            if BLACKLISTED_ENEMIES[ent:GetClass()] then continue end

            local mins, maxs = ent:GetCollisionBounds()
            local center = (maxs + mins) / 2
    
            -- Traceline to player to hit against everything solid (windows, props or entities)
            local trace = util.TraceLine({
                start = self:GetEyePos(),
                endpos = ent:GetPos() + center,
                filter = {self, ent},
                mask = MASK_BLOCKLOS_AND_NPCS
            })

            if trace.Hit then continue end

            if g_debug_turret:GetBool() then
                debugoverlay.Line(self:GetEyePos(), trace.HitPos, 0.1, debugColorRed)
            end

            self.Enemy = ent
            self.LastKnownEnemy = ent
            self.LastSight = CurTime() + (self:HasSpawnflag(SF_FAST_RETIRE) and FLOOR_TURRET_SHORT_WAIT or FLOOR_TURRET_MAX_WAIT)
            break
        end
    end

    function ENT:EmitAlertSound()
        if CurTime() > self.NextAlertSound then
            self:EmitSound("NPC_FloorTurret.Activate")
            self.NextAlertSound = CurTime() + 3.0
        end
    end

    function ENT:HasEnemy()
        return IsValid(self.Enemy)
    end

    function ENT:GetEnemy()
        return IsValid(self.Enemy) and self.Enemy
    end

    function ENT:IsMovingSuddenly()
        if IsValid(self:GetPhysicsObject()) then
            local phys = self:GetPhysicsObject()
            if not self:IsPlayerHolding() then
                local vVelocity = self:GetPhysicsObject():GetVelocity()
                self.LastCachedSpeed = vVelocity:LengthSqr()

                if self.LastCachedSpeed > 20000.0 then
                    return true
                end
            end
        end

        return false
    end

    function ENT:UpdateFacing(angDir)
        local attachment = self:GetAttachment(self:LookupAttachment("light"))
        if not attachment then
            return false
        end

        if self.vecGoalAnglesLast ~= angDir and not self:GetAsActor() then
            self.NextShakeTime = CurTime() + 1
        end
    
        local vecGoalLocalAngles = self:WorldToLocalAngles(angDir)
        
        local pitch = math.ApproachAngle(self:GetPoseParameter("aim_pitch"), vecGoalLocalAngles.p, 0.005 * self:GetMaxYawSpeed())
        local yaw = math.ApproachAngle(self:GetPoseParameter("aim_yaw"), vecGoalLocalAngles.y, 0.005 * self:GetMaxYawSpeed())
    
        -- I haven't researched thoroughly how they "shake" their aim,
        -- I'll do it my way.
        local timeDifference = CurTime() - self.NextShakeTime
        local shakeMul = math.max(1.5 - timeDifference, 0) * 0.35
        local pitchShake = math.sin(CurTime() * 25) * shakeMul

        pitch = pitch + pitchShake

        self:SetPoseParameter("aim_pitch", pitch)
        self:SetPoseParameter("aim_yaw", yaw)
        
        local bMoved = math.abs(pitch - self:GetPoseParameter("aim_pitch")) > 0.1 or math.abs(yaw - self:GetPoseParameter("aim_yaw")) > 0.1
        self.LaserAngle = self.LaserAngle or Angle(0,0,0)
        self.LaserAngle.x = self:GetAngles().x + pitch
        self.LaserAngle.y = self:GetAngles().y + yaw
    
        if g_debug_turret:GetBool() then
            local vecMuzzle = attachment.Pos
            local vecGoalDir = self.LaserAngle:Forward()
            
            debugoverlay.Cross(vecMuzzle, 2, 0.05, debugColorRed, false)
            debugoverlay.Cross(vecMuzzle + vecGoalDir * 256, 2, 0.05, debugColorRed, false)
            debugoverlay.Line(vecMuzzle, vecMuzzle + vecGoalDir * 256, 0.05, debugColorRed, false)
        end
    
        self.vecGoalAnglesLast = angDir
        return bMoved
    end

    function ENT:IsRelaxedAim()
        local curPitch = self:GetPoseParameter("aim_pitch")
        local curYaw = self:GetPoseParameter("aim_yaw")

        local finished = math.abs(curPitch) < 0.01 and math.abs(curYaw) < 0.01

        if not finished then
            self.RelaxTimeFinished = CurTime() + 1
        end

        return finished
    end

    function ENT:GetAttackSpread(target)
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
        if IsValid(self.Enemy) then
            if self.Enemy:IsPlayer() then
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
    end

    -- Shot at target or randomly
    function ENT:Shoot(target)
        target = target or NULL
        
        local lowerGun = tobool(math.random(0, 1))
        local center = vector_origin

        if CurTime() > self.NextShotTime then
            if IsValid(target) then
                local min, max = target:GetCollisionBounds()
                local trace = util.TraceLine({
                    start = self:GetEyePos(),
                    endpos = target:GetPos() + center,
                    filter = {self, target},
                    mask = MASK_SHOT
                })
        
                if trace.Hit then 
                    self.NextShotTime = CurTime() + math.Rand(0.09, 0.1)
                    return 
                end
            end

            self:EmitAlertSound()
            self:TrySpeak(TALK_ACTIVE)
    
            if self:GetHasAmmo() then
                self:ResetSequence(lowerGun and "fire2" or "fire")
    
                for i = 1, 2 do
                    local attachmentName = (i == 1 and "LFT" or "RT") .. "_Gun" .. (lowerGun and "2" or "1") .. "_Muzzle"
                    local attach = self:GetAttachment(self:LookupAttachment(attachmentName))
    
                    local direction
                    if IsValid(target) then
                        direction = ((target:GetPos() + center) - attach.Pos):GetNormalized()
                    else
                        direction = attach.Ang:Forward()
                    end

                    if g_debug_turret:GetBool() then
                        debugoverlay.Line(attach.Pos, attach.Pos + direction * 8192, 0.1, debugColorRed)
                    end
    
                    if self:GetHasAmmo() then
                        local bullet = {
                            Num = 1,
                            Src = attach.Pos,
                            Dir = direction,
                            Spread = self:GetAttackSpread(target),
                            Tracer = 0,
                            Force = 5000,
                            Damage = self:GetAttackDamageScale(),
                            IgnoreEntity = self,
                            Attacker = self,
                            Callback = function(att, tr, dmginfo)
                                local effectdata = EffectData()
                                effectdata:SetEntity( vehicle )
                                effectdata:SetAttachment( self:LookupAttachment(attachmentName) )
                                effectdata:SetStart( attach.Pos )
                                effectdata:SetOrigin( tr.HitPos )
                                effectdata:SetScale( 6000 )
                                util.Effect("AR2Tracer", effectdata )
                            end
                        }
                        
                        self:FireBullets(bullet)
                    end
                end
    
                self:EmitSound("NPC_FloorTurret.ShotSounds")
            else
                self:DryFire()
            end

            self.NextShotTime = CurTime() + math.Rand(0.09, 0.1)
        end
    end

    function ENT:DryFire()
        self:EmitSound( "NPC_FloorTurret.DryFire")
        self:EmitSound( "NPC_FloorTurret.Activate")

        if math.Rand(0, 1) > 0.5 then
            self.NextShotTime = CurTime() + math.Rand(1, 2.5)
        else
            self.NextShotTime = CurTime() + 0.1
        end
    end

    function ENT:TrySpeak(line, skipglobal)
        if self:GetGagged() or self:GetAsActor() or self:GetState() ~= STATE_ACTIVE then return end
    
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

    function ENT:IsOnSide()
        if self:WaterLevel() > 0 then
            return true
        end

        local up = self:GetUp()

        return vector_up:Dot(up) < 0.5 
    end

    function ENT:OnTakeDamage(info)
        local phys = self:GetPhysicsObject()

        if IsValid(phys) 
        and IsValid(info:GetAttacker()) 
        and info:GetAttacker():GetClass() ~= self:GetClass()
        and (info:GetAttacker():IsPlayer() or info:GetAttacker():IsNPC() or info:GetAttacker():IsNextBot())
        then
            phys:SetVelocity(info:GetDamageForce() / phys:GetMass())
        end
        return 0
    end
    
    function ENT:PhysicsCollide(colData, collider)
        local other = colData.HitEntity
        local myVelocity = self:GetPhysicsObject():GetVelocity()
        local phys = self:GetPhysicsObject()

        if IsValid(phys) and other:IsPlayer() and other:GetMoveType() == MOVETYPE_VPHYSICS and not self:IsPlayerHolding() then

            -- Get a lateral impulse
            local vVelocityImpulse = self:GetPos() - other:GetPos()
            vVelocityImpulse.z = 0

            if vVelocityImpulse:LengthSqr() == 0 then
                vVelocityImpulse.x = 1
                vVelocityImpulse.y = 1
            end

            vVelocityImpulse:Normalize()

            -- If impulse is too much along the forward or back axis, skew it
            local vTurretForward = self:GetAngles():Forward()
            local vTurretRight = self:GetAngles():Right()

            local fForwardDotImpulse = vTurretForward:Dot(vVelocityImpulse)

            if fForwardDotImpulse > 0.7 or fForwardDotImpulse < -0.7 then
                vVelocityImpulse = vVelocityImpulse + vTurretRight
                vVelocityImpulse:Normalize()
            end

            local vAngleImpulse = Vector(vTurretRight:Dot(vVelocityImpulse) < 0.0 and -1.6 or 1.6, math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5))

            vVelocityImpulse = vVelocityImpulse * TURRET_FLOOR_PHYSICAL_FORCE_MULTIPLIER
            vAngleImpulse = vAngleImpulse * TURRET_FLOOR_PHYSICAL_FORCE_MULTIPLIER
            phys:AddVelocity(vVelocityImpulse)
            self:SetLocalAngularVelocity(vAngleImpulse)

            -- Check if another turret is hitting us
            if other:GetClass() == self:GetClass() and other:GetState() == STATE_ACTIVE then
                local vTurretVelocity = GetVelocity()
                local pOtherPhys = other:GetVelocity()

                -- If it's moving faster
                if (vOtherVelocity:LengthSqr() > vTurretVelocity:LengthSqr()) then
                    -- Make the turret falling onto this one talk
                    self:TrySpeak(TALK_COLLIDE)
                    self.NextSpeakTime = CurTime() + 1.2
                end
            end
        end
    end

    function ENT:ReturnToLife()
        self:SetCollisionGroup(COLLISION_GROUP_NONE)
        self:SetState(STATE_ACTIVE)
        self:SetThinkFunction(self.ThinkSearch)
    end

    function ENT:GetPreferredCarryAngles(ply)
        -- Fix PITCH rotation for turrets
        local angles = ply:EyeAngles()
        local selfAngles = self:GetAngles()
        return Angle(0 - angles.x,0,0)
    end

    function ENT:Use(activator, caller, useType, value)
        if activator:IsPlayer() and not activator:IsPlayerHolding() and self:GetPickupEnabled() then
            activator:PickupObject(self)
            self:SetHoldingPlayer(activator)

            if self:GetState() == STATE_ACTIVE and not self:GetAsActor() then
                self.NextShotTime = CurTime() + 0.5
                self.LastSpeakLine = -1
                self.NextSpeakTime = CurTime() + 0.1
                self:SetThinkFunction(self.ThinkHeld)
            end
        end
    end
end

-- -------------------------------------------------
-- Client methods
-- -------------------------------------------------

if CLIENT then
    function ENT:Initialize()
        NpcPortalTurretFloor.AddToRenderList(self)
    end

    function ENT:Draw(studio)
        local holdingPlayer = self:GetHoldingPlayer()
        if IsValid(holdingPlayer) and holdingPlayer == LocalPlayer() then
            cam.IgnoreZ(true)
        end

        self:DrawModel(studio)
        
        cam.IgnoreZ(false)
    end
    
    function ENT:Think()
        self:NextThink(CurTime())
        return true
    end
end

-- -------------------------------------------------
-- Shared methods
-- -------------------------------------------------
function ENT:SetupDataTables()
    self:NetworkVar("Bool", "IsActive")
    self:NetworkVar("Bool", "LoadAlternativeModels")
    self:NetworkVar("Bool", "Gagged")
    self:NetworkVar("Bool", "AsActor")
    self:NetworkVar("Bool", "CanShootThroughPortals")
    self:NetworkVar("Bool", "UseSuperDamageScale")
    self:NetworkVar("Bool", "HasAmmo")
    self:NetworkVar("Bool", "PickupEnabled")
    self:NetworkVar("Float", "Range")
    self:NetworkVar("Float", "MaxYawSpeed")
    self:NetworkVar("Entity", "HoldingPlayer")
    self:NetworkVar("Int", "State")
    self:NetworkVar("Int", "EyeState")

    if SERVER then
        self:SetRange(1024)
        self:SetHasAmmo(true)
        self:SetMaxYawSpeed(360.0)
        self:SetState(STATE_ACTIVE)
        self:SetEyeState(EYE_STATE_ON)
        self:SetPickupEnabled(true)
    end
end