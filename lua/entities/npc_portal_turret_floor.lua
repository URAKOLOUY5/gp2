-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Turret
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"

local TURRET_MODEL = "models/npcs/turret/turret.mdl"
local TURRET_MODEL_SKELETON = "models/npcs/turret/turret_skeleton.mdl"
local TURRET_MODEL_BOX = "models/npcs/turret/turret_boxed.mdl"
local TURRET_MODEL_BACKWARDS = "models/npc/turret/turret_backwards.mdl"

local SF_START_INACTIVE = 64
local SF_FAST_RETIRE = 128
local SF_OUT_OF_AMMO = 256
local SF_FRIENDLY = 512

local INDEX_TO_MODEL = {
    [0] = TURRET_MODEL,
    [2] = TURRET_MODEL_BOX,
    [3] = TURRET_MODEL_BACKWARDS,
    [4] = TURRET_MODEL_SKELETON,
}

local BLACKLISTED_ENEMIES = {
    ["npc_security_camera"] = true
}

local PORTAL_FLOOR_TURRET_MAX_SHOT_DELAY = 2

AccessorFunc( ENT, "m_iClass", "NPCClass" )

PrecacheParticleSystem("turret_coop_explosion")

ENT.AutomaticFrameAdvance = true

local g_debug_turret = GetConVar("g_debug_turret")

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
    self:NetworkVar("Float", "Range")
    self:NetworkVar("Float", "MaxYawSpeed")
    self:NetworkVar("String", "State")
    self:NetworkVar("Entity", "HoldingPlayer")

    if SERVER then
        self:SetRange(1024)
        self:SetHasAmmo(true)
        self:SetIsActive(true)
        self:SetState("Idle")
        self:SetMaxYawSpeed(360.0)
    end
end

function ENT:Think()
    if SERVER then
        self:FindEnemy()

        if IsValid(self:GetHoldingPlayer()) and not self:IsPlayerHolding() then
            self:GetHoldingPlayer(NULL)
        end
    
        if self.ThinkFunction and isfunction(self.ThinkFunction) and CurTime() > self.ThinkNextFunction then
            self.ThinkFunction(self)
        end

        self:UpdateFacing(self.vecGoalAngles)
    else
        self:SetNextClientThink(CurTime())
    end

    self:NextThink(CurTime())
    return true
end

-- -------------------------------------------------
-- Server methods
-- -------------------------------------------------
if SERVER then
    local DEGREES_45_CONE = math.rad(55)
    local VECTOR_CONE_4DEGREES = Vector( 0.03490, 0.03490 )
    local NEXT_SPEAK_ALLOW_TIME = 0
    local TURRET_FLOOR_DAMAGE_MULTIPLIER = 3
    local TURRET_FLOOR_BULLET_FORCE_MULTIPLIER = 0.4
    local TURRET_FLOOR_PHYSICAL_FORCE_MULTIPLIER = 135
    local FLOOR_TURRET_MAX_WAIT = 5
    local FLOOR_TURRET_SHORT_WAIT = 2

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
        elseif k == "ModelIndex" then
            self:SetModel(INDEX_TO_MODEL[tonumber(v)] or TURRET_MODEL)
            self.GotModel = true
        elseif k == "SkinNumber" then
            self.SkinNumber = tonumber(v)
        elseif k == "spawnflags" then
            self.SpawnFlags = tonumber(v)
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
        self.IsOnSide = false
        self.UseSuperDamageScale = false
        self.NextShotTime = 0
        self.LastSight = 0
        self.SearchSpeed = math.Rand(1.0, 1.4)
        self.attachmentEyes = self:LookupAttachment("eyes")
        self.ThinkFunction = self.ThinkIdle
        self.ThinkNextFunction = CurTime() + 0.1
        self.SequenceFinishTime = 0
        self.vecGoalAngles = self:GetAngles()
        self.NextAlertSound = CurTime()

        self:SetModel(TURRET_MODEL)
        self:SetHealth(10)
        self:SetSkin(self.SkinNumber or 0)
        self:SetBloodColor(DONT_BLEED)
        self:SetNPCClass(CLASS_COMBINE)
        self:SetUseType(SIMPLE_USE)
        self:PhysicsInit(SOLID_VPHYSICS)
        
        -- It breaks some things
        -- so i did normalize
        local angles = self:GetAngles()
        angles:Normalize()
        self:SetAngles(angles)

        self.SequenceRetract = self:LookupSequence("retract")
        self.SequenceDeploy = self:LookupSequence("deploy")
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

        self.SequenceFinishTime = CurTime() + self:SequenceDuration() + addDuration
    end

    function ENT:PlayingSequenceFinished()
        return CurTime() > self.SequenceFinishTime + 0.5
    end

    function ENT:ThinkIdle()
        self.vecGoalAngles = self:GetAngles()

        if self:PlayingSequenceFinished() then
            if self:HasEnemy() then
                GP2.Print("ThinkIdle: Found enemy")
                self:PlaySequence("deploy", -0.5)
                self:SetThinkFunction(self.ThinkDeploy)
                self:SetNextThink(CurTime() + 0.05)
            end
        end
    end

    function ENT:ThinkDeploy()
        if self:PlayingSequenceFinished() then
            print("ThinkDeploy()")
            self:SetThinkFunction(self.ThinkAttack)
        end
    end

    function ENT:ThinkAttack()
        if self:HasEnemy() then
            self:Shoot(self:GetEnemy())

            local dir = self:GetEnemy():GetPos() - self:GetPos()

            self.vecGoalAngles = dir:Angle()
            self:EmitAlertSound()
        else
            self:SetThinkFunction(self.ThinkSearch)
            self:SetNextThink(CurTime() + 0.05)
        end
    end

    function ENT:ThinkSearch()
        if self:HasEnemy() then
            -- I searched and found enemy
            self:SetThinkFunction(self.ThinkDeploy)
            GP2.Print("ThinkSearch: Found enemy")

            -- Give enemies that are farther away a longer grace period
            local distanceRatio = self:GetPos():Distance(self:GetEnemy():GetPos()) / self:GetRange()
            self.NextShotTime = CurTime() + distanceRatio * distanceRatio * PORTAL_FLOOR_TURRET_MAX_SHOT_DELAY
        else
            if CurTime() > self.LastSight then
                self.vecGoalAngles = self:GetAngles()

                if self:IsRelaxedAim() then
                    self:PlaySequence("retract")
                    self:SetThinkFunction(self.ThinkIdle)
                    self:SetNextThink(CurTime() + 0.1)
                end
            else
                local angles = self:GetAngles()

                self.vecGoalAngles.x = angles.x + ( math.sin( ( self.LastSight + CurTime() * self.SearchSpeed ) * 1.5 ) * 20 )
                self.vecGoalAngles.y = angles.y + ( math.sin( ( self.LastSight + CurTime() * self.SearchSpeed ) * 2.5 ) * 20 )             
            end
        end
    end

    function ENT:ThinkHeld()
        if not self:IsPlayerHolding() then
            self:SetThinkFunction(self.ThinkSearch)
            self:SetNextThink(CurTime() + 0.1)
        end

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
                mask = MASK_SHOT
            })


            if trace.Hit then continue end

            debugoverlay.Line(self:GetEyePos(), trace.HitPos, 0.1, Color(0,255,155))

            self.Enemy = ent
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

    function ENT:ShakeAim(duration)
        self.SubtleAimShakingStartTime = CurTime()
        self.SubtleAimShakeEndTime = CurTime() + duration
    end

    function ENT:HasEnemy()
        return IsValid(self.Enemy)
    end

    function ENT:GetEnemy()
        return self.Enemy
    end

    function ENT:UpdateFacing(angDir)
        local attachment = self:GetAttachment(self:LookupAttachment("light"))
        if not attachment then
            return false
        end
    
        local vecGoalLocalAngles = self:WorldToLocalAngles(angDir)
        
        local pitch = math.ApproachAngle(self:GetPoseParameter("aim_pitch"), vecGoalLocalAngles.p, 0.007 * self:GetMaxYawSpeed())
        local yaw = math.ApproachAngle(self:GetPoseParameter("aim_yaw"), vecGoalLocalAngles.y, 0.007 * self:GetMaxYawSpeed())
    
        self:SetPoseParameter("aim_pitch", pitch)
        self:SetPoseParameter("aim_yaw", yaw)
        
        local bMoved = math.abs(pitch - self:GetPoseParameter("aim_pitch")) > 0.1 or math.abs(yaw - self:GetPoseParameter("aim_yaw")) > 0.1
        self.LaserAngle = self.LaserAngle or Angle(0,0,0)
        self.LaserAngle.x = pitch
        self.LaserAngle.y = self:GetAngles().y + yaw
    
        if g_debug_turret:GetBool() then
            local vecMuzzle = attachment.Pos
            local vecGoalDir = self.LaserAngle:Forward()
            
            debugoverlay.Cross(vecMuzzle, 2, 0.05, Color(255, 0, 0), false)
            debugoverlay.Cross(vecMuzzle + vecGoalDir * 256, 2, 0.05, Color(255, 0, 0), false)
            debugoverlay.Line(vecMuzzle, vecMuzzle + vecGoalDir * 256, 0.05, Color(255, 0, 0), false)
        end
    
        return bMoved
    end

    function ENT:IsRelaxedAim()
        local curPitch = self:GetPoseParameter("aim_pitch")
        local curYaw = self:GetPoseParameter("aim_yaw")

        return math.abs(curPitch) < 0.01 and math.abs(curYaw) < 0.01
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
                if self:OnSide() then
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
        if CurTime() > self.NextShotTime then
            local lowerGun = tobool(math.random(0, 1))
    
            if self:GetHasAmmo() then
                self:ResetSequence(lowerGun and "fire2" or "fire")
    
                for i = 1, 2 do
                    local attachmentName = (i == 1 and "LFT" or "RT") .. "_Gun" .. (lowerGun and "2" or "1") .. "_Muzzle"
                    local attach = self:GetAttachment(self:LookupAttachment(attachmentName))
    
                    local direction
                    if IsValid(target) then
                        local min, max = target:GetCollisionBounds()
                        local center = (max + min) / 2

                        direction = ((target:GetPos() + center) - attach.Pos):GetNormalized()
                    else
                        direction = attach.Ang:Forward()
                    end

                    debugoverlay.Line(attach.Pos, attach.Pos + direction * 8192, 0.1, Color(255,0,0))
    
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

            self:ShakeAim(2)
            self.NextShotTime = CurTime() + math.Rand(0.09, 0.1)
        end
    end

    function ENT:DryFire()
        self:EmitSound( "NPC_FloorTurret.DryFire")
        self:EmitSound( "NPC_FloorTurret.Activate" )

        if math.Rand(0, 1) > 0.5 then
            self.NextShotTime = CurTime() + math.Rand(1, 2.5)
        else
            self.NextShotTime = CurTime() + 0.1
        end
    end

    function ENT:OnSide()
        return self.IsOnSide
    end

    function ENT:OnTakeDamage(info)
        local phys = self:GetPhysicsObject()

        if IsValid(phys) and info:GetAttacker():GetClass() ~= self:GetClass() then
            phys:SetVelocity(info:GetDamageForce() / phys:GetMass())
        end
        return 0
    end

    function ENT:GetPreferredCarryAngles(ply)
            -- Fix PITCH rotation for turrets
            local angles = ply:EyeAngles()
            local selfAngles = self:GetAngles()
            return Angle(0 - angles.x,0,0)
    end

    function ENT:Use(activator, caller, useType, value)
        if activator:IsPlayer() and not activator:IsPlayerHolding() then
            activator:PickupObject(self)
            self:SetHoldingPlayer(activator)
            self.NextShotTime = CurTime() + 0.5
            self:PlaySequence("idlealert")
            self:SetThinkFunction(self.ThinkHeld)
        end
    end
end

-- -------------------------------------------------
-- Client methods
-- -------------------------------------------------

if CLIENT then
    function ENT:Draw(studio)
        --local holdingPlayer = self:GetHoldingPlayer()
        --if IsValid(holdingPlayer) and holdingPlayer == LocalPlayer() then
            --cam.IgnoreZ(true)
        --end

        self:DrawModel(studio)
        
        --cam.IgnoreZ(false)
    end
end