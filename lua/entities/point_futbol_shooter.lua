-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Bomb shooter
-- ----------------------------------------------------------------------------

ENT.Type = "point"

function ENT:Initialize()
    self.TargetEntity = nil
    self.LaunchSpeed = 500
end

function ENT:KeyValue(key, value)
    if key == "launchSpeed" then
        self.LaunchSpeed = tonumber(value)
    end
end

function ENT:AcceptInput(inputName, activator, caller, data)
    inputName = inputName:lower()

    if inputName == "settarget" then
        local target = ents.FindByName(data)[1]

        if not IsValid(target) then
            return
        end

        self.TargetPos = target:GetPos()
    elseif inputName == "shootfutbol" then
        self:ShootFutbol()
    end
end

function ENT:ShootFutbol()
    local targetPos = self.TargetPos

    local futbol = ents.Create("prop_exploding_futbol")
    if not IsValid(futbol) then return end

    futbol:SetPos(self:GetPos())
    futbol:SetExplosionOnTouch(true)
    futbol:Spawn()

    local direction = (targetPos - self:GetPos()):GetNormalized()
    local distance = self:GetPos():Distance(targetPos)

    direction.z = direction.z + 1 -- Add an upward bias

    -- Adjust the velocity based on the distance to the target
    local launchSpeed = (self.LaunchSpeed or 500) * 0.1
    local velocity = direction:GetNormalized() * (launchSpeed + (distance * 0.5))

    local phys = futbol:GetPhysicsObject()
    if IsValid(phys) then
        phys:SetVelocity(velocity)
    end
end