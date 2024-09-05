ENT.Type = "brush"

local mats = {}

local sv_gravity = GetConVar("sv_gravity")

function ENT:KeyValue(k, v)
    if k == "playerSpeed" then
        self:SetPlayerSpeed(tonumber(v))
    elseif k == "physicsSpeed" then
        self:SetPhysicsSpeed(tonumber(v))
    elseif k == "useThresholdCheck" then
        self:SetUseThresholdCheck(tobool(v))
    elseif k == "entryAngleTolerance" then
        self:SetEntryAngleTolerance(tonumber(v))
    elseif k == "useExactVelocity" then
        self:SetUseExactVelocity(tobool(v))
    elseif k == "exactVelocityChoiceType" then
        self:SetUseExactVelocityMethod(tonumber(v))
    elseif k == "lowerThreshold" then
        self:SetLowerThreshold(tonumber(v))
    elseif k == "upperThreshold" then
        self:SetUpperThreshold(tonumber(v))
    elseif k == "launchDirection" then
        self:SetLaunchDirection(Angle(v))
    elseif k == "launchTarget" then
        self:SetLaunchTargetName(v) 
    elseif k == "onlyVelocityCheck" then
        self:SetOnlyVelocityCheck(tobool(v)) 
    elseif k == "applyAngularImpulse" then
        self:SetApplyAngularImpulse(tobool(v)) 
    elseif k == "AirCtrlSupressionTime" then
        self:SetAirCtrlSupressionTime(tonumber(v)) 
    end

    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end
end

function ENT:SetupDataTables()
    self:NetworkVar( "Float", "PlayerSpeed" )
    self:NetworkVar( "Float", "PhysicsSpeed" )
    self:NetworkVar( "Float", "LowerThreshold" )
    self:NetworkVar( "Float", "UpperThreshold" )
    self:NetworkVar( "Float", "EntryAngleTolerance" )
    self:NetworkVar( "Float", "AirCtrlSupressionTime" )

    self:NetworkVar( "Angle", "LaunchDirection" )

    self:NetworkVar( "String", "LaunchTargetName" )
    
    self:NetworkVar( "Entity", "LaunchTarget" )

    self:NetworkVar( "Bool", "UseThresholdCheck" )
    self:NetworkVar( "Bool", "UseExactVelocity" )
    self:NetworkVar( "Bool", "UseExactVelocityMethod" )
    self:NetworkVar( "Bool", "OnlyVelocityCheck" )
    self:NetworkVar( "Bool", "ApplyAngularImpulse" )
    self:NetworkVar( "Bool", "DirectionSuppressAirControl" )

    if SERVER then
        -- Defaulting to true
        self:SetApplyAngularImpulse(true)
        self:SetAirCtrlSupressionTime(-1)
        self:SetLowerThreshold(0.15)
        self:SetLowerThreshold(0.30)
        self:SetPlayerSpeed(450)
        self:SetPhysicsSpeed(450)
    end
end

function ENT:Initialize()
    self:SetTrigger(true)

    self.RefireDelay = {}
    self.AbortedLaunchees = {}
    self.Thinking = false

    self:SetLaunchTarget(ents.FindByName(self:GetLaunchTargetName())[1] or NULL)

    for i = 1, player.GetCount() + 1 do
        self.RefireDelay[i] = 0.0
    end
end

function ENT:StartTouch(other)
    if not IsValid(other) then
        return
    end

    if not self:PassesTriggerFilters(other) then
        return
    end

    -- Don't refire too quickly
    local refireIndex = other:IsPlayer() and other:EntIndex() or 1

    if refireIndex >= game.MaxPlayers() + 1 then
        GP2.Error("trigger_catapult:StartTouch Trying to store a refire index for an entity( %d ) outside the expected range ( < %d ).\n", nRefireIndex, MAX_PLAYERS + 1)
        refireIndex = 1
    end

    if self.RefireDelay[refireIndex] > CurTime() then
        return
    end

    -- Don't touch things the player is holding
    if other:GetPhysicsObject() and other:IsPlayerHolding() then
        if not self.AbortedLaunchees[other] then
            self.AbortedLaunchees[other] = true
        end

        self.Thinking = true
        self:NextThink(CurTime() + 0.05)
        return
    elseif other:IsPlayer() then
        -- Always keep players in this list in case the were trapped under another player in the previous launch
        if not self.AbortedLaunchees[other] then
            self.AbortedLaunchees[other] = true
        end

        self.Thinking = true
        self:NextThink(CurTime() + 0.05)
    end

    -- Get the target
    local target = self:GetLaunchTarget()

    -- See if we're attempting to hit a target
    if IsValid(target) then
        -- See if we are using the threshold check
        if self:GetUseThresholdCheck() then
            -- Get the velocity of the physics objects / players touching the catapult
            local vecVictim

            if other:IsPlayer() then
                vecVictim = other:GetVelocity()
            elseif IsValid(other:GetPhysicsObject()) then
                vecVictim = other:GetPhysicsObject():GetVelocity()
            else
                GP2.Error("Catapult fail!!  Object is not a player and has no physics object!  BUG THIS")
                vecVictim = Vector(0,0,0)
            end

            local flVictimSpeed = vecVictim:Length()

            -- get the speed needed to hit the target
            local vecVelocity

            if self:GetUseExactVelocity() then
                vecVelocity = self:CalculateLaunchVectorPreserve(vecVictim, other, target)
            else
                vecVelocity = self:CalculateLaunchVector(other, target)
            end

            local flLaunchSpeed = vecVelocity:Length()

            -- is the victim facing the target?
            local vecDirection = (target:GetPos() - other:GetPos())
            local necNormalizedVictim = vecVictim:GetNormalized()
            local vecNormalizedDirection = vecDirection:GetNormalized()

            local flDot = necNormalizedVictim:Dot(vecNormalizedDirection)
            if flDot >= self:GetEntryAngleTolerance() then
                -- Is the victim speed within tolerance to launch them?
                if ( ( ( flLaunchSpeed - (flLaunchSpeed * self:GetLowerThreshold() ) ) < flVictimSpeed ) and ( ( flLaunchSpeed + (flLaunchSpeed * self:GetUpperThreshold() ) ) > flVictimSpeed )  ) then
                    if self:GetOnlyVelocityCheck() then
                        self:OnLaunchedVictim(other)
                    else
                        -- Launch!
                        self:LaunchByTarget(other, target)
                        GP2.Print( "Catapult %q is adjusting velocity of %q so it will hit the target. (Object Velocity: %.1f -- Object needed to be between %.1f and %.1f \n", self:GetName(), other:GetClass(), flVictimSpeed, flLaunchSpeed - (flLaunchSpeed * self:GetLowerThreshold() ), flLaunchSpeed + (flLaunchSpeed * self:GetUpperThreshold() ) );
                    end
                else
                    GP2.Print( "Catapult %q ignoring object %q because its velocity is outside of the threshold. (Object Velocity: %.1f -- Object needed to be between %.1f and %.1f \n", self:GetName(), other:GetClass(), flVictimSpeed, flLaunchSpeed - (flLaunchSpeed * self:GetLowerThreshold() ), flLaunchSpeed + (flLaunchSpeed * self:GetUpperThreshold() ) );
                    -- since we attempted a fling set the refire delay
                    self.RefireDelay[refireIndex] = CurTime() + 0.1
                end
            else
                -- we're facing the wrong way.  set the refire delay.
                self.RefireDelay[refireIndex] = CurTime() + 0.1
            end
        else
            self:LaunchByTarget( other, target )
        end
    else
        local shouldLaunch = true

        if self:GetUseThresholdCheck() then
            -- Get the velocity of the physics objects / players touching the catapult
            local vecVictim
            if other:IsPlayer() then
                vecVictim = other:GetVelocity()
            elseif IsValid(other:GetPhysicsObject()) then
                vecVictim = other:GetPhysicsObject():GetVelocity()
            else
                GP2.Error("Catapult fail!!  Object is not a player and has no physics object!  BUG THIS")
                vecVictim = Vector(0,0,0)
            end
            
            local vecForward = self:GetLaunchDirection():Forward()
            local flDot = vecForward:Dot(vecVictim)
            local flLower = self:GetPlayerSpeed() - (self:GetPlayerSpeed() * self:GetLowerThreshold())
            local flUpper = self:GetPlayerSpeed() + (self:GetPlayerSpeed() * self:GetUpperThreshold())

            if flDot < flLower or flDot > flUpper then
                shouldLaunch = false
            end
        end

        if shouldLaunch then
            if self:GetOnlyVelocityCheck() then
                self:OnLaunchedVictim(other)
            else
                self:LaunchByDirection(other)
            end
        end
    end
end

function ENT:CalculateLaunchVector(victim, target)
    -- Find where we're going
    local vecSourcePos = victim:GetPos()
    local vecTargetPos = target:GetPos()

    if victim:IsPlayer() then
        vecTargetPos.z = vecTargetPos.z - 64
    end

    local speed = victim:IsPlayer() and self:GetPlayerSpeed() or self:GetPhysicsSpeed()
    local gravity = sv_gravity:GetFloat()

    local vecVelocity = (vecTargetPos - vecSourcePos)

    -- throw at a constant time
    local time = vecVelocity:Length() / speed

    local velocityMultiplier = 1
    vecVelocity = vecVelocity * (velocityMultiplier / time)

    -- adjust upward toss to compensate for gravity loss
    vecVelocity.z = vecVelocity.z + (gravity * time * 0.5)

    return vecVelocity
end

function ENT:CalculateLaunchVectorPreserve(vecInitialVelocity, victim, target, forcePlayer)
    -- Find where we're going
    local vecSourcePos = victim:GetPos()
    local vecTargetPos = target:GetPos()

    -- If victim is player, adjust target position so player's center will hit the target
    if victim:IsPlayer() or forcePlayer then
        vecTargetPos.z = vecTargetPos.z - 64
    end

    local vecDiff = (vecTargetPos - vecSourcePos)

    local flHeight = vecDiff.z
    local flDist = vecDiff:Length2D()
    local flVelocity = (victim:IsPlayer() or forcePlayer) and self:GetPlayerSpeed() or self:GetPhysicsSpeed()
    local flGravity = -1 * sv_gravity:GetFloat()

    if flDist == 0.0 then
        GP2.Error("Bad location input for catapult!")
        return CalculateLaunchVector(victim, target)
    end

    local flRadical = flVelocity * flVelocity * flVelocity * flVelocity - flGravity * (flGravity * flDist * flDist - 2.0 * flHeight * flVelocity * flVelocity)

    if flRadical <= 0.0 then
        GP2.Error( "Catapult can't hit target! Add more speed!\n" );
        return CalculateLaunchVector(victim, target)
    end

    flRadical = math.sqrt(flRadical)

    local flTestAngle1 = flVelocity*flVelocity
    local flTestAngle2 = flTestAngle1

    flTestAngle1 = -math.atan((flTestAngle1 + flRadical) / (flGravity*flDist))
    flTestAngle2 = -math.atan((flTestAngle2 - flRadical) / (flGravity*flDist))

    local vecTestVelocity1 = vecDiff
    vecTestVelocity1.z = 0
    vecTestVelocity1:Normalize()

    local vecTestVelocity2 = vecTestVelocity1

    vecTestVelocity1 = vecTestVelocity1 * (flVelocity * math.cos(flTestAngle1))
    vecTestVelocity1.z = flVelocity * math.sin( flTestAngle1 )

    vecTestVelocity2 = vecTestVelocity2 * math.cos(flTestAngle2)
    vecTestVelocity2.z = flVelocity * math.sin(flTestAngle2)

    vecInitialVelocity:Normalize()

    if self:GetUseExactVelocityMethod() == 1 then
        return vecTestVelocity1
    elseif self:GetUseExactVelocityMethod() == 2 then
        return vecTestVelocity2
    end

    if vecInitialVelocity:Dot(vecTestVelocity1) > vecInitialVelocity:Dot(vecTestVelocity2) then
        return vecTestVelocity1
    end

    return vecTestVelocity2
end

function ENT:LaunchByDirection(victim)
    local vecForward = self:GetLaunchDirection():Forward()
    
    -- Handle a player
    if victim:IsPlayer() then
        -- Simply push us forward
        local vecPush = vecForward * self:GetPlayerSpeed()

        -- Hack on top of magic
        if ( math.abs(vecPush.x) < 0.001 and math.abs(vecPush.y) < 0.001 ) then
            vecPush.z = self:GetPlayerSpeed() * 1.5
        end

        -- Send us flying
        if victim:IsOnGround() then
            victim:SetGroundEntity(NULL)
        end

        hook.Add("Move", "GP2::test_setupmove_removespeed" .. victim:EntIndex(), function(ply, mv, cmd)
            if victim == ply then
                mv:SetVelocity(vecPush)
            end
        end)
        self:OnLaunchedVictim(victim)

        -- Do air control suppression (NO, there's no airaccelerate block in gmod's player :/)
        if self:GetDirectionSuppressAirControl() then
            local flSupressionTimeInSeconds = 0.25

            if self:GetAirControlSupressionTime() > 0 then
               -- If set in the map, use this override time
               flSupressionTimeInSeconds = self:GetAirControlSupressionTime() 
            end

            -- victim:SetAirControlSupressionTime(flSupressionTimeInSeconds * 1000)
        end
    else
        if victim:GetMoveType() == MOVETYPE_VPHYSICS then
            -- Launch!
            local phys = victim:GetPhysicsObject()

            if IsValid(phys) then
                local vecVelocity = vecForward * self:GetPhysicsSpeed()
                vecVelocity.z = self:GetPhysicsSpeed()

                local angImpulse = math.random(-50, 50)

                phys:SetVelocity(vecVelocity)
                self:SetLocalAngularVelocity(Angle(angImpulse, angImpulse, angImpulse))

                -- Force this!
                local flNull = 0.0
                phys:SetDragCoefficient(flNull, flNull)
                phys:SetDamping(flNull, flNull)

                self:TriggerOutput("OnPhysGunDrop")
            end
        end
    end

    self:OnLaunchedVictim(victim)
end

function ENT:OnLaunchedVictim(victim)
    self:TriggerOutput("OnCatapulted")

    if victim:IsPlayer() then
        local nRefireIndex = victim:EntIndex()
        self.RefireDelay[nRefireIndex] = CurTime() + 0.1 -- HACK
    else
        local nRefireIndex = victim:EntIndex()
        self.RefireDelay[1] = CurTime() + 0.1 -- HACK
    end
end

function ENT:LaunchByTarget(victim, target)
    local vecVictim

    if IsValid(victim:GetPhysicsObject()) then
        vecVictim = victim:GetPhysicsObject():GetVelocity()
    else
        vecVictim = victim:GetVelocity()
    end

    -- get the launch vector
    local vecVelocity = self:GetUseExactVelocity() and self:CalculateLaunchVectorPreserve( vecVictim, victim, target ) or self:CalculateLaunchVector( victim, target )

    -- Handle a player
    if victim:IsPlayer() then
        -- Send us flying
        if victim:IsOnGround() then
            victim:SetGroundEntity(NULL)
        end

        -- NO SUPRESSION AIR (trigger_catapult_shared.cpp)
        -- victim:SetAirControlSupressionTime(...)
        --victim:SetVelocity()
        hook.Add("Move", "GP2::test_setupmove_removespeed" .. victim:EntIndex(), function(ply, mv, cmd)
            if victim == ply then
                mv:SetVelocity(vecVelocity)
            end
        end)
        self:OnLaunchedVictim(victim)
    else
        if victim:GetMoveType() == MOVETYPE_VPHYSICS then
            -- Launch!
            local phys = victim:GetPhysicsObject()

            if IsValid(phys) then
                local angImpulse = math.random(-50, 50)

                phys:SetVelocity(vecVelocity)
                victim:SetLocalAngularVelocity(Angle(angImpulse, angImpulse, angImpulse))

                -- Force this!
                local flNull = 0.0
                phys:SetDragCoefficient(flNull, flNull)
                phys:SetDamping(flNull, flNull)

                self:TriggerOutput("OnPhysGunDrop")
            end
        end
    end

    self:OnLaunchedVictim(victim)
end

function ENT:Think()
    if self.Thinking then
        for other in pairs(self.AbortedLaunchees) do
            local bShouldRemove = true

            if IsValid(other) then
                if other:IsPlayer() then
                    -- Time to get launched and stay in the list in case we're stuck under something again.
                    bShouldRemove = self
                    self:StartTouch(other)
                    hook.Remove("Move", "GP2::test_setupmove_removespeed" .. other:EntIndex())
                elseif IsValid(other:GetPhysicsObject()) then
                    if other:IsPlayerHolding() then
                        -- the sphere should stay in the list.
                        bShouldRemove = false
                    else
                        -- Time to get launched!
                        self:StartTouch(other)
                    end
                end
            else
                self.AbortedLaunchees[other] = nil
            end

            if bShouldRemove then
                self.AbortedLaunchees[other] = nil
            end
        end
    end
    
    local count = 0
    for other in pairs(self.AbortedLaunchees) do
        count = count + 1
    end

    if count == 0 then
        self.Thinking = false
        return true
    end

    self:NextThink(CurTime() + 0.05)
    return true
end