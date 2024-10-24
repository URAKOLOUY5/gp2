-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Franken Wheatley Laboratories turret
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"

ENT.Spawnable = true
ENT.PrintName = "Franken Turret"
ENT.Category = "Portal 2"

ENT.AutomaticFrameAdvance = true
sv_monster_turret_velocity = CreateConVar("sv_monster_turret_velocity", "100.0f", FCVAR_REPLICATED, "The amount of velocity the monster turret tries to move with.")

function ENT:SetupDataTables()
    self:NetworkVar("Bool", "Held")
    self:NetworkVar("Bool", "IsABox")
    self:NetworkVar("Bool", "IsFlying")
    self:NetworkVar("Bool", "IsShortcircuit")
    
    self:NetworkVar("Bool", "StartAsBox")
    self:NetworkVar("Float", "BoxSwitchSpeed")

    self:NetworkVar("Float", "PushStrength")
    self:NetworkVar("Int", "DeferredTransform")
    
    self:NetworkVar("Bool", "AllowSilentDissolve")

    if SERVER then
        self:SetPushStrength(1)
        self:SetBoxSwitchSpeed(400.0)
    end
end

function ENT:AcceptInput(name, activator, entity, data)
    name = name:lower()

    if name == "becomebox" then
        self:BecomeBox(true)
    elseif name == "becomemonster" then
        self:BecomeMonster(true)
    elseif name == "becomeshortcircuit" then
        self:BecomeShortcircuit()
    elseif name == "dissolve" then
        self:Dissolve(0)
        self:TriggerOutput("OnFizzled")
    elseif name == "silentdissolve" and self:GetAllowSilentDissolve() then
        self:Remove()
        self:TriggerOutput("OnFizzled")
    end
end

function ENT:KeyValue(k, v)
    if k == "StartAsBox" then
        self:SetStartAsBox(tobool(v))
    elseif k == "BoxSwitchSpeed" then
        self:SetBoxSwitchSpeed(tonumber(v))
    elseif k == "AllowSilentDissolve" then
        self:SetAllowSilentDissolve(tobool(v))
    end
end

function ENT:Initialize()
    if self:GetStartAsBox() then
        self:SetModel("models/npcs/monsters/monster_A_box.mdl")
    else
        self:SetModel("models/npcs/monsters/monster_a.mdl")
    end
    
    if SERVER then
        self:SetUseType(SIMPLE_USE)
        self:CreateVPhysics()
    end

    if self:GetStartAsBox() then
        self:ResetSequence("hermit_idle")
        self:SetCycle(0)
        self:SetIsABox(true)
    else
        self:ResetSequence("straight01")
        self:SetCycle(0)
        self:SetIsABox(false)
    end

    for i = 1, 4 do
        self:SetBodygroup(i, math.random(0, 1))
    end
end

function ENT:CreateVPhysics()
    self:SetSolid(SOLID_NONE)
    self:SetGroundEntity(NULL)
    self:PhysicsInit(SOLID_VPHYSICS)

    if self:GetPhysicsObject() then
        self:GetPhysicsObject():SetMass(40.0)
        self:GetPhysicsObject():Wake()
    end
end

function ENT:BecomeBox(force)
    if self:GetIsShortcircuit() then
        return
    end

    self:SetStartAsBox(force)

    if self:GetIsABox() then
        self:SetDeferredTransform(0)
    elseif self:GetHeld() then
        self:SetDeferredTransform(1)
    else
        self:SetIsABox(true)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            local vecVelocity = phys:GetVelocity()
            local vecAngVelocity = self:GetLocalAngularVelocity()

            self:SetModel("models/npcs/monsters/monster_A_box.mdl")
            self:CreateVPhysics()

            phys = self:GetPhysicsObject()
            phys:SetVelocity(vecVelocity)
            self:GetLocalAngularVelocity(vecAngVelocity)
            
            self:ResetSequence("hermit_in")
        end
    end
end

function ENT:BecomeMonster(force)
    if self:GetIsShortcircuit() then
        return
    end

    if force then
        self:SetStartAsBox(false)
    elseif self:GetStartAsBox() then
        return
    end

    if self:GetIsABox() then
        if self:GetHeld() then
            self:SetDeferredTransform(2)
        else
            self:SetIsABox(false)

            local phys = self:GetPhysicsObject()
            if IsValid(phys) then
                local vecVelocity = phys:GetVelocity()
                local vecAngVelocity = self:GetLocalAngularVelocity()
    
                self:SetModel("models/npcs/monsters/monster_a.mdl")
                self:CreateVPhysics()
    
                phys = self:GetPhysicsObject()
                phys:SetVelocity(vecVelocity)
                self:GetLocalAngularVelocity(vecAngVelocity)
                
                self:ResetSequence("hermit_out")
            end
        end
    else
        self:SetDeferredTransform(0)
    end
end

function ENT:BecomeShortcircuit()
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        if not self:GetIsABox() then
            local vecVelocity = phys:GetVelocity()
            local vecAngVelocity = self:GetLocalAngularVelocity()
    
            self:SetModel("models/npcs/monsters/monster_A_box.mdl")
            self:CreateVPhysics()
    
            phys = self:GetPhysicsObject()
            phys:SetVelocity(vecVelocity)
            self:GetLocalAngularVelocity(vecAngVelocity)
        end

        self:ForcePlayerDrop()
        self:ResetSequence("shortcircuit")
        self:EmitSound("DoSparkSmaller")
        
        self:SetIsABox(true)
        self:SetIsShortcircuit(true)
    end
end

function ENT:HandleAnimEvent(event, eventTime, cycle, type, options)
    local phys = self:GetPhysicsObject()

    if event ~= 1100 or self:GetHeld() then
        return true
    end

    if IsValid(phys) then
        local angles = self:GetAngles()
        local vecForward = angles:Forward()
        local vecUp = angles:Up()

        if vecUp.z >= 0.1 then
            local angles = self:GetAngles()
            local vecAbsEnd = self:GetPos() + angles:Forward() * 32 - angles:Up() * 32

            local tr = util.TraceLine({
                start = self:GetPos(),
                endPos = vecAbsEnd,
                mask = MASK_SOLID,
                filter = self
            })

            if tr.Hit then
				local vecAbsEnd = Vector(0,0,0)
				vecAbsEnd.x = self:GetPos().x - (vecUp.x * 32.0)
				vecAbsEnd.y = self:GetPos().y - (vecUp.y * 32.0)

				local angImpulse = VectorRand(-0.2, 0.2)
				local flRandom = math.Rand(-0.2, 0.2)
				vecAbsEnd.z = math.Rand(0.7, 1.0)

				local vecVelocity = Vector(0, 0, 0)

				local flVel = sv_monster_turret_velocity:GetFloat()
				local pushStrength = self:GetPushStrength()
				vecVelocity.x = ( (vecForward.x + flRandom) * flVel ) * pushStrength
				vecVelocity.y = ( (vecForward.y + flRandom) * flVel ) * pushStrength
				vecVelocity.z = ( (vecForward.z + vecAbsEnd.z) * flVel ) * pushStrength

				self:SetGroundEntity(NULL)
				phys:Wake()
				phys:SetVelocityInstantaneous(angImpulse)
				phys:ApplyForceCenter(vecVelocity)
				phys:AddVelocity(vecVelocity)
            end
        end
    end

    return true
end

function ENT:GetPreferredCarryAngles(ply)
    return Angle(10,180,0)
end

function ENT:Use(activator, caller, useType, value)
    if activator:IsPlayer() and not self:IsPlayerHolding() and not self:GetHeld() then
        if not self:GetIsShortcircuit() then
            self:ResetSequence("hermit_in")
        end
        activator:PickupObject(self)
        self:SetHeld(true)
    end
end

function ENT:Think()
    if SERVER then
        if not self:IsPlayerHolding() and self:GetHeld() then
            self:SetHeld(false)
            
            if not self:GetIsShortcircuit() then
                if self:GetDeferredTransform() > 0 then
                    if self:GetDeferredTransform() == 1 then
                        self:BecomeBox(true)
                    elseif self:GetDeferredTransform() == 2 then
                        self:BecomeMonster(true)
                    end
    
                    self:SetDeferredTransform(0)
                end
    
                if not self:GetStartAsBox() then
                    self:ResetSequence("hermit_out")
                end
            end
        end

        self:AnimateThink()
    end
    self:NextThink(CurTime())
    return true
end

function ENT:AnimateThink()
    if self:GetIsShortcircuit() then
        if self:IsSequenceFinished() then
            self:ResetSequence("shortcircuit")
        end

        return
    end

    local vecVelocity = vector_origin
    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        if not self:GetHeld() and self:GetIsFlying() and not self:GetStartAsBox() then
            local mins, maxs = self:GetCollisionBounds()

            local tr = util.TraceHull({
                start = self:GetPos(),
                endPos = self:GetPos(),
                mins = mins,
                maxs = maxs,
                mask = MASK_SOLID,
                filter = self
            })

            if tr.StartSolid or tr.AllSolid then
                local vecUp = self:GetAngles():Up()
                
                local angImpulse = VectorRand(-0.5, 0.5)
                local vecImpulse = Vector()
                
				vecImpulse.x = (vecUp.x + math.Rand( -0.2, 0.2 ) ) * sv_monster_turret_velocity:GetFloat()
				vecImpulse.y = (vecUp.y + math.Rand( -0.2, 0.2 ) ) * sv_monster_turret_velocity:GetFloat()
				vecImpulse.z = (vecUp.z + math.Rand( 1.7, 2.0 ) ) * sv_monster_turret_velocity:GetFloat()

                self:SetGroundEntity(NULL)
                phys:Wake()
				phys:SetVelocityInstantaneous(angImpulse)
				phys:ApplyForceCenter(vecVelocity)
				phys:AddVelocity(vecVelocity)
            else
                self:SetIsFlying(true)
                self:BecomeMonster(true)
            end
        end
    elseif not self:GetHeld() and not self:GetIsFlying() then
        self:SetIsFlying(true)
        self:BecomeBox(false)
    end

    if self:IsSequenceFinished() then
        if self:GetHeld() or self:GetStartAsBox() then
            self:ResetSequence("hermit_idle")
        else
            local vecUp = self:GetAngles():Up()

            if vecUp.z >= 0.6 then
                local vecImpulse = self:GetPos() - (vecUp * 32)

                local tr = util.TraceLine({
                    start = self:GetPos(),
                    endPos = vecImpulse,
                    mask = MASK_SOLID,
                    filter = self
                })

                if tr.fraction == 1 then
                    self:ResetSequence("intheair")
                else
                    local iRandom1 = math.random(0, 2)

                    if iRandom1 > 0 then
                        local iRandom2 = iRandom1 - 1

                        if iRandom2 > 0 then
                            if iRandom2 == 1 then
                                self:ResetSequence("straight03")
                                self:SetPushStrength(1.1)
                            end
                        else
                            self:ResetSequence("straight02")
                            self:SetPushStrength(0.7)
                        end
                    else
                        self:ResetSequence("straight01")
                        self:SetPushStrength(1)
                    end
                end
            else
                self:ResetSequence("fallover_idle")
            end
        end
    end
end