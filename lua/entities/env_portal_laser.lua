-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Thermal Discouragement Beam
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"

local MAX_RAY_LENGTH = 8192
local RAY_EXTENTS = Vector(8, 8, 8)

util.PrecacheSound("Flesh.LaserBurn")
PrecacheParticleSystem("reflector_start_glow")
PrecacheParticleSystem("laser_start_glow")
PrecacheParticleSystem("laser_relay_powered")
PrecacheParticleSystem("discouragement_beam_sparks")

local TARGETABLE_ENTS = {
    ["prop_physics"] = true,
    ["point_laser_target"] = true,
    ["prop_weighted_cube"] = true,
    ["prop_laser_catcher"] = true,
}

local ENT_ATTACHMENTS = {
    ["env_portal_laser"] = "laser_attachment",
    ["prop_weighted_cube"] = "focus",
}

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", "Enabled" )
    self:NetworkVar( "Bool", "LethalDamage" )
    self:NetworkVar( "Bool", "AutoAim" )
    self:NetworkVar( "Entity", "HitEntity" )

    if SERVER then
        self:SetEnabled(true)
    end
end

function ENT:KeyValue(k, v)
    if k == "StartState" then
        self:SetEnabled(not tobool(v))
    elseif k == "LethalDamage" then
        self:SetLethalDamage(tobool(v))
    elseif k == "AutoAimEnabled" then
        self:SetAutoAim(tobool(v))
    elseif k == "model" then
        self:SetModel(v)
    elseif k == "skin" then
        self:SetSkin(tonumber(v))
    end

    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end
end

ENT.__input2func = {
    ["toggle"] = function(self, activator, caller, data)
        self:TurnOn()
    end,
    ["turnon"] = function(self, activator, caller, data)
        self:TurnOn()
    end,
    ["turnoff"] = function(self, activator, caller, data)
        self:TurnOff()
    end,    
}

function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()
    local func = self.__input2func[name]

    if func and isfunction(func) then
        func(self, activator, caller, data)
    end
end


function ENT:Initialize()
    if SERVER then
        self:PhysicsInitStatic(SOLID_VPHYSICS)
    else
        EnvPortalLaser.AddToRenderList(self) 
    end
end

local function CalcClosestPointOnLineSegment(point, lineStart, lineEnd)
    local toPoint = point - lineStart
    local lineDirection = (lineEnd - lineStart):GetNormalized()
    local dotProduct = math.Clamp(lineDirection:Dot(toPoint), 0, (lineEnd - lineStart):Length())

    return lineStart + lineDirection * dotProduct
end

function ENT:Think()
    if SERVER then
    else
        if not self:GetEnabled() then -- remove particle created by DoLaser
            if self.EmitParticle then
                self.EmitParticle:StopEmission()
                self.EmitParticle = nil
            end
        end
    end

    if self:GetEnabled() then
        self:DoLaser(self)
    end

    if CLIENT then
        if not self:GetEnabled() and self.BeamSound then
            if self.BeamSound:IsPlaying() then
                self.BeamSound:Stop()
            end
            return
        end
    end

    self:NextThink(CurTime())
    return true
end

function ENT:OnRemove(fd)
    if CLIENT then
        if self.BeamSound then
            self.BeamSound:Stop()
            self.BeamSound = nil
        end
    end
end

local function PushPlayerAwayFromLine(player, sourcePos, targetPos, force)
    -- Ensure the player is valid and capable of being moved
    if not IsValid(player) or not player:IsPlayer() or player:GetMoveType() == MOVETYPE_NOCLIP then
        return
    end
    
    -- Calculate the nearest point on the line segment to the player
    local playerPos = player:GetPos()
    local nearestPoint = CalcClosestPointOnLineSegment(playerPos, sourcePos, targetPos)
    
    -- Calculate the direction from the line segment to the player
    local pushDirection = (playerPos - nearestPoint):GetNormalized()
    pushDirection.z = 0  -- Keep the push direction horizontal
    
    -- Double the force if the player is crouching
    if player:Crouching() then
        force = force * 2
    end
    
    -- Calculate the push velocity vector
    local pushVelocity = pushDirection * force
    
    -- Apply the calculated push velocity to the player
    player:SetVelocity(pushVelocity)
end

local function EmitSoundAtClosestPoint(player, sourcePos, targetPos, soundPath)
    -- Ensure the player is valid
    if not IsValid(player) or not player:IsPlayer() or not player:Alive() then
        return
    end

    -- Calculate the nearest point on the line segment to the player
    local playerPos = player:GetPos()
    local nearestPoint = CalcClosestPointOnLineSegment(playerPos, sourcePos, targetPos)

    -- Emit the sound at the nearest point
    sound.Play(soundPath, nearestPoint)
end

function ENT:DoLaser(child)
    local ang = IsValid(child) and child:GetAngles() or self:GetAngles()
    local lookupAttachment = child:LookupAttachment(ENT_ATTACHMENTS[child:GetClass()])
    local attach = child:GetAttachment(lookupAttachment)

    if not attach then
        attach = { Pos = child:GetPos() }
    end

    local start = attach.Pos
    local fwd = ang:Forward()

    local tr = util.TraceLine({
        start = start,
        endpos = start + fwd * MAX_RAY_LENGTH,
        filter = function(ent)
            return not (ent == self or ent == child or ent:IsPlayer() or ent == self:GetParent() or ent.IsLaserCatcher or ent.IsLaserTarget)
        end,
        mask = MASK_OPAQUE_AND_NPCS,
    })
    
    local hitent = tr.Entity
    if TARGETABLE_ENTS[hitent:GetClass()] then
        self:SetHitEntity(hitent) 
    else
        self:SetHitEntity(NULL) 
    end

    if hitent:GetClass() == "prop_weighted_cube" and hitent:GetCubeType() ~= 2 then
        self:SetHitEntity(NULL)
    end

    local rayEndPos = tr.HitPos + fwd * 16

    if SERVER then
        --debugoverlay.Line(start, rayEndPos, 0.12, Color(255, 10, 10), true)
    
        local lst = ents.FindAlongRay(start, rayEndPos, -RAY_EXTENTS, RAY_EXTENTS)
        for _, entity in ipairs(lst) do
            if not IsValid(entity) then continue end
    
            -- Check if the entity is damagable
            if entity:IsPlayer() then
                if entity:IsOnGround() then
                    PushPlayerAwayFromLine(entity, start, rayEndPos, 300)
                    EmitSoundAtClosestPoint(entity, start, rayEndPos, "Flesh.LaserBurn")
                    entity:TakeDamage(8)
                end
            elseif entity:GetClass() == "npc_portal_turret_floor" then
                entity:Ignite(5)
            else
                entity:TakeDamage(8, self)
            end      
        end
    else
        --debugoverlay.Line(start, rayEndPos, 0.12, Color(10, 218, 255), true)

        if not child.EmitParticle then
            if child ~= self or not self:GetModel() then
                child.EmitParticle = CreateParticleSystem(child, "reflector_start_glow", PATTACH_ABSORIGIN_FOLLOW)
            else
                child.EmitParticle = CreateParticleSystem(child, "laser_start_glow", PATTACH_POINT_FOLLOW, lookupAttachment)
            end
        end

        if not child.BeamSound then
            child.BeamSound = CreateSound(child, self:GetLethalDamage() and "LaserGreen.BeamLoop" or "Laser.BeamLoop")
            child.BeamSound:SetSoundLevel(0)
            child.BeamSound:PlayEx(0, 100)
        else
            
            local pos = LocalPlayer():GetPos()
            local nearest = CalcClosestPointOnLineSegment(pos, start, rayEndPos)
            local distance = (pos - nearest):Length()
        
            local maxDistance = 355
            local minVolume = 0
            local maxVolume = 0.25
        
            -- Volume based on the distance
            local volume = math.Clamp((maxDistance - distance) / maxDistance * (maxVolume - minVolume) + minVolume, minVolume, maxVolume)
        
            if not child.BeamSound:IsPlaying() then
                child.BeamSound:PlayEx(volume, 100)
            else
                child.BeamSound:ChangeVolume(volume)
            end


        end
    end

    if IsValid(hitent) then
        if SERVER then
            if hitent:GetClass() == "prop_weighted_cube" and not hitent:HasLaser() and hitent:GetCubeType() == 2 then
                local laser = ents.Create(self:GetClass())
                laser:Spawn()
                laser:SetPos(hitent:GetPos())
                laser:SetAngles(hitent:GetAngles())
                laser:SetParent(hitent)
                laser:AddEffects(EF_NODRAW)
                laser:SetLethalDamage(self:GetLethalDamage())
                laser:SetAutoAim(self:GetAutoAim())
                hitent:SetLaser(laser)
                hitent:SetParentLaser(self)
            end
        end
    end
end

if SERVER then
    ENT.laserList = {}
    ENT.reflectionCubes = {}

    function ENT:TurnOn()
        self:SetEnabled(true)
    end

    function ENT:TurnOff()
        self:SetEnabled(false)
    end

    function ENT:Toggle()
        if not self:GetEnabled() then
            self:TurnOn()
        else
            self:TurnOff()
        end
    end

    function ENT:UpdateTransmitState()
        return TRANSMIT_ALWAYS
    end
end