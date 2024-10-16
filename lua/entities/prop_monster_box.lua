-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Franken turret
-- ----------------------------------------------------------------------------

AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Franken Turret"
ENT.Category = "Portal 2"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true

ENT.DeferredTransform = 0

sv_monster_turret_velocity = CreateConVar("sv_monster_turret_velocity", "100.0f", FCVAR_REPLICATED, "The amount of velocity the monster turret tries to move with.")

function ENT:Initialize()
	if CLIENT then return end

	self:SetModel( "models/npcs/monsters/monster_a.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:PhysWake()
	self:SetUseType(SIMPLE_USE)

	-- Set random body part
	for i = 1, 4 do
		self:SetBodygroup(i,math.random(0,1))
	end

	if self:GetIsForcedAsBox() then
		self:SetIsBox(true)
		self:ResetSequence( "hermit_idle" )
	else
		self:ResetSequence( "straight01" )
	end

	self:NextThink(CurTime() + 0.1)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(40)
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Bool", "IsHeld")
	self:NetworkVar("Bool", "IsBox")
	self:NetworkVar("Bool", "IsShortCircuit")
	self:NetworkVar("Bool", "IsForcedAsBox")
	self:NetworkVar("Bool", "IsFlying")
	self:NetworkVar("Float", "PushStrength")
	self:NetworkVar("Float", "BoxSwitchSpeed")

	if SERVER then
		self:SetPushStrength(1.0)
		self:SetBoxSwitchSpeed(400)
	end
end

function ENT:BecomeBox(force)
	if self:GetIsShortCircuit() then return end

	self:SetIsForcedAsBox(force)

	if self:GetIsBox() then
		self.DeferredTransform = 0
	elseif self:GetIsHeld() then
		self.DeferredTransform = 1
	else
		self:SetIsBox(true)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			local velocity = phys:GetVelocity()
			self:SetModel("models/npcs/monsters/monster_A_box.mdl")
			self:PhysicsInit(SOLID_VPHYSICS)

			phys = self:GetPhysicsObject()
			phys:SetVelocity(velocity)

			self:ResetSequence("hermit_in")
		end
	end
end

function ENT:BecomeMonster(force)
	if self:GetIsShortCircuit() then return end

	if force then
		self:SetIsForcedAsBox(false)
	elseif self:GetIsForcedAsBox() then
		return
	end

	if self:GetIsBox() then
		if self:GetIsHeld() then
			self.DeferredTransform = 2
		else
			self:SetIsBox(false)

			local phys = self:GetPhysicsObject()

			if IsValid(phys) then
				local velocity = phys:GetVelocity()
				self:SetModel("models/npcs/monsters/monster_a.mdl")
				self:PhysicsInit(SOLID_VPHYSICS)
	
				phys = self:GetPhysicsObject()
				phys:SetVelocity(velocity)
	
				self:ResetSequence("hermit_out")
			end
		end
	end
end

function ENT:BecomeShortCircuit(force)
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		if not self:GetIsBox() then
			local velocity = phys:GetVelocity()
			self:SetModel("models/npcs/monsters/monster_A_box.mdl")
			self:PhysicsInit(SOLID_VPHYSICS)

			phys = self:GetPhysicsObject()
			phys:SetVelocity(velocity)
		end

		self:ForcePlayerDrop()

		self:ResetSequence("shortcircuit")
		self:EmitSound("DoSparkSmaller")
		self:SetIsBox(true)
		self:SetIsShortCircuit(true)
	end
end

function ENT:OnPlayerPickup(ply)
	if not self:GetIsHeld() then
		self:SetIsHeld(true)

		if not self:GetIsShortCircuit() then
			self:ResetSequence("hermit_in")
		end
	end
end

function ENT:OnPlayerDrop(ply)
	self:SetIsHeld(false)

	if not self:GetIsShortCircuit() then
		if self.DeferredTransform == 1 then
			self:BecomeBox(true)
		elseif self.DeferredTransforn == 2 then
			self:BecomeMonster(true)
		end

		self.DeferredTransform = 0

		if not self:GetIsForcedAsBox() then
			self:ResetSequence("hermit_out")
		end
	end
end

function ENT:AnimateThink()
	if self:GetIsShortCircuit() then
		if self:IsSequenceFinished() then
			self:ResetSequence("shortcircuit")
		end
		
		return
	end

	local phys = self:GetPhysicsObject()
	if not IsValid(phys) then return end

	local velocity = phys:GetVelocity()

	if velocity:LengthSqr() <= self:GetBoxSwitchSpeed() ^ 2 then
		if not self:GetIsHeld() and self:GetIsFlying() and not self:GetIsForcedAsBox() then
			local mins, maxs = self:GetCollisionBounds()

			local tr = util.TraceHull({
				start = self:GetPos(),
				endPos = self:GetPos(),
				mins = mins,
				maxs = maxs,
				mask = MASK_SOLID,
				filter = { self }
			})

			if tr.Hit then
				local vecUp = self:GetAngles():Up()
				local angImpulse = Vector(math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5))

				local vecImpulse = Vector()
				vecImpulse.x = (vecUp.x + math.Rand(-0.2, 0.2)) * sv_monster_turret_velocity:GetFloat()
				vecImpulse.y = (vecUp.y + math.Rand(-0.2, 0.2)) * sv_monster_turret_velocity:GetFloat()
				vecImpulse.z = (vecUp.z + math.Rand(1.7, 2.0)) * sv_monster_turret_velocity:GetFloat()
				
				self:SetGroundEntity(NULL)
				phys:Wake()
				phys:SetVelocityInstantaneous(angImpulse)
				phys:ApplyForceCenter(vecImpulse)
				phys:AddVelocity(vecImpulse)
			else
				self:SetIsFlying(false)
				self:BecomeMonster(false)
			end
		end
	elseif not self:GetIsHeld() and not self:GetIsFlying() then
		self:SetIsFlying(true)
		self:BecomeBox(false)
	end

	if self:IsSequenceFinished() then
		if self:GetIsHeld() or self:GetIsForcedAsBox() then
			self:ResetSequence("hermit_idle")
		else
			local vecUp = self:GetAngles():Up()


			if vecUp.z >= 0.4 then
				local vecImpulse = self:GetPos() - (vecUp * 64.0)

				local tr = util.TraceLine(
					{ 
						start = self:GetPos(),
						endPos = vecImpulse,
						mask = MASK_SOLID,
						filter = self
					}
				)

				if not tr.Hit then
					self:ResetSequence("intheair")
				else
					local random = math.random(0, 2)

					if random > 0 then
						local random2 = random - 1

						if random2 > 0 then
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
						self:SetPushStrength(1.0)
					end
				end
			else
				self:ResetSequence("fallover_idle")
			end
		end
	end
end

function ENT:Think()
	if not CLIENT then
		self:SetIsHeld(self:IsPlayerHolding())
		self:AnimateThink()
	end
	
	self:NextThink( CurTime() )
	return true
end

function ENT:HandleAnimEvent(event)
	if event ~= 1100 or self:GetIsHeld() then
		return true
	else
		local phys = self:GetPhysicsObject()
		
		if IsValid(phys) then
			local vecForward = self:GetForward()
			local vecUp = self:GetUp()
			
			if vecUp.z >= 0.1 then
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

				self:SetGroundEntity(nil)
				phys:Wake()
				phys:SetVelocityInstantaneous(angImpulse)
				phys:ApplyForceCenter(vecVelocity)
				phys:AddVelocity(vecVelocity)
			end

			return true
		end
	end

end

function ENT:AcceptInput(name, activator, caller, data)
	name = name:lower()

	if name == "becomebox" then
		self:BecomeBox(true)
	elseif name == "becomemonster" then
		self:BecomeMonster(true)
	elseif name == "becomeshortcircuit" then
		self:BecomeShortCircuit()
	end
end

function ENT:Use(activator, caller, useType, value)
    if activator:IsPlayer() and not self:IsPlayerHolding() then
        activator:PickupObject(self)
    end
end

function ENT:GetPreferredCarryAngles(ply)
	return Angle(0,180,0)
end
