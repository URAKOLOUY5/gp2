-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Turret
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Base = "base_nextbot"

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

AccessorFunc( ENT, "m_iClass", "NPCClass" )

PrecacheParticleSystem("turret_coop_explosion")

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
    self:NetworkVar("String", "State")

    if SERVER then
        self:SetRange(1024)
        self:SetHasAmmo(true)
        self:SetIsActive(true)
        self:SetState("Idle")
    end
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
        self.NextFireTime = 0
        self.LastSight = 0
        
        self:SetNPCClass(CLASS_COMBINE)
        self:SetModel(TURRET_MODEL)
        self:SetHealth(10)
        self:SetSkin(self.SkinNumber or 0)
        self:SetBloodColor(DONT_BLEED)
    end
    
    function ENT:Think()
        self:FindEnemy()
        self:NextThink(CurTime() + 0.1)
        return true
    end

    function ENT:Classify()
        return CLASS_COMBINE
    end

    function ENT:RunBehaviour()
        while true do
            local state = self:GetState()

            -- Right now i'm idling
            if state == "Idle" then
                -- I've found enemy, switch to Attack mode
                if self:HasEnemy() then
                    self:PlaySequenceAndWait("deploy")
                    self:SetState("Attack")
                end
            elseif state == "Attack" then
                -- I've lost enemy, go to Search mode
                if not self:HasEnemy() then
                    self:SetState("Search")
                else
                    -- Shoot at enemy
                    self:Shoot(self.Enemy)
                    
                    local enemyPos = self.Enemy:GetPos()
                    local selfPos = self:GetPos()
                    local targetPos = self:WorldToLocal(enemyPos)
    
                    local aimYaw = math.deg(math.atan2(targetPos.y, targetPos.x))
                    local aimPitch = -math.deg(math.atan2(targetPos.z, targetPos:Length2D()))
    
                    self:SetAimPose(aimYaw, aimPitch)
                end
            elseif state == "Search" then
                -- I'm searching for new enemy
                -- and found it
                if self:HasEnemy() then
                    self:SetState("Attack")
                -- otherwise rotate gun around
                else
                    -- haven't found it before FLOOR_TURRET_MAX_WAIT (or FLOOR_TURRET_SHORT_WAIT if fastRetire)
                    if CurTime() >= self.LastSight then
                        self:PlaySequenceAndWait("retract")
                        self:SetState("Idle")
                    -- rotate guns around
                    else
                    end
                end
            end
            
            coroutine.yield()
        end
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

            -- If it's not visible
            if not ent:Visible(self) then continue end
    
            -- Traceline to player to hit against everything solid (windows, props or entities)
            local trace = util.TraceLine({
                start = self:EyePos(),
                endpos = ent:EyePos(),
                filter = {self, ent},
                mask = MASK_SHOT
            })

            if trace.Hit then continue end
    
            self.Enemy = ent
            self.LastSight = CurTime() + (self:HasSpawnflag(SF_FAST_RETIRE) and FLOOR_TURRET_SHORT_WAIT or FLOOR_TURRET_MAX_WAIT)
            break
        end
    end

    function ENT:ShakeAim(duration)
        self.SubtleAimShakingStartTime = CurTime()
        self.SubtleAimShakeEndTime = CurTime() + duration
    end

    function ENT:HasEnemy()
        return IsValid(self.Enemy)
    end

    function ENT:SetAimPose(yaw, pitch, delta)
        delta = delta or 0.3

        local aimYaw = self:GetPoseParameter("aim_yaw")
        local aimPitch = self:GetPoseParameter("aim_pitch")

        aimYaw = Lerp(delta, aimYaw, yaw)
        aimPitch = Lerp(delta, aimPitch, pitch)

        self:SetPoseParameter("aim_yaw", aimYaw)
        self:SetPoseParameter("aim_pitch", aimPitch)
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
        if CurTime() > self.NextFireTime then
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

                        direction = ((target:GetPos() + center) - self:EyePos()):GetNormalized()
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
                self:EmitSound("NPC_FloorTurret.DryFire")
            end

            self:ShakeAim(2)
            self.NextFireTime = CurTime() + math.Rand(0.09, 0.1)
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

end

-- -------------------------------------------------
-- Client methods
-- -------------------------------------------------
