-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Hard light surface
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"

local MAX_RAY_LENGTH = 8192
local PROJECTED_WALL_WIDTH = 72

ENT.PhysicsSolidMask = CONTENTS_SOLID+CONTENTS_MOVEABLE+CONTENTS_BLOCKLOS

PrecacheParticleSystem("projected_wall_impact")

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", "Updated" )
    self:NetworkVar( "Bool", "GotInitialPosition" )
    self:NetworkVar( "Vector", "InitialPosition" )
    self:NetworkVar( "Float", "DistanceToHit" )
end

function ENT:Initialize()
    if SERVER then
        self.TraceFraction = 0
    end
    self:AddEffects(EF_NODRAW)
end

function ENT:Think()
    if not self:GetUpdated() then
        self:CreateWall()
    end
    
if CLIENT then
    self:SetNextClientThink(CurTime())

    if not ProjectedWallEntity.IsAdded(self) then
        self:CreateWall()
    end
end
    local startPos = self:GetPos()
    local angles = self:GetAngles()
    local fwd = angles:Forward()

    local tr = util.TraceLine({
        start = startPos,
        endpos = startPos + fwd * MAX_RAY_LENGTH,
        mask = MASK_SOLID_BRUSHONLY,
    })


    if self.TraceFraction != tr.Fraction then
        self:SetUpdated(false)
        self.TraceFraction = tr.Fraction
    end

    self:NextThink(CurTime())
    return true
end

function ENT:Draw()
end

function ENT:OnRemove(fd)
    if self.WallImpact then
        self.WallImpact:StopEmissionAndDestroyImmediately()
    end
end

function ENT:CreateWall()
    local startPos = self:GetPos()
    local angles = self:GetAngles()
    local fwd = angles:Forward()
    local right = angles:Right()

    local tr = util.TraceLine({
        start = startPos,
        endpos = startPos + fwd * MAX_RAY_LENGTH,
        mask = MASK_SOLID_BRUSHONLY,
    })

    local hitPos = tr.HitPos
    local distance = hitPos:Distance(startPos)
    local v = -distance / 192

    self:SetDistanceToHit(distance)

    local fullLength = (tr.HitPos - startPos):Length()
    local halfLength = fullLength / 2
    local halfWidth = PROJECTED_WALL_WIDTH / 2

    local verts_col = {
        Vector(-halfLength, -halfWidth, -1),
        Vector(-halfLength, -halfWidth, 0),
        Vector(-halfLength, halfWidth, -1),
        Vector(-halfLength, halfWidth, 0),
        Vector(fullLength, -halfWidth, -1),
        Vector(fullLength, -halfWidth, 0),
        Vector(fullLength, halfWidth, -1),
        Vector(fullLength, halfWidth, 0)
    }

    if CLIENT then
        local verts = {
            { pos = startPos - right * halfWidth, u = 1, v = 0 },
            { pos = startPos - right * halfWidth + fwd * distance, u = 1, v = v },
            { pos = startPos - right * halfWidth + fwd * distance + right * PROJECTED_WALL_WIDTH, u = 0, v = v },
            { pos = startPos + right * halfWidth + fwd * distance, u = 0, v = v },
            { pos = startPos + right * halfWidth, u = 0, v = 0 },
            { pos = startPos - right * halfWidth, u = 1, v = 0 },
        }

        if self.Mesh and self.Mesh:IsValid() then
            self.Mesh:Destroy()
        end

        self.Mesh = Mesh()
        self.Mesh:BuildFromTriangles(verts)
        ProjectedWallEntity.AddToRenderList(self, self.Mesh)
    end

    if SERVER then
        self:PhysicsInitStatic(6)
        self:SetUpdated(true)
    else
        if not self.WallImpact then
            local wallImpactAng = tr.HitNormal:Angle()

            self.WallImpact = CreateParticleSystemNoEntity("projected_wall_impact", tr.HitPos - fwd * 4, wallImpactAng)
            
            --idk how to work with this particle, maybe converter fucked it up
            --self.WallImpact:SetControlPoint(1, Vector(1,1,1))
        end

        if not self:GetUpdated() and self.WallImpact then
            self.WallImpact:StopEmissionAndDestroyImmediately()
            self.WallImpact = nil
        end
    end

    self:EnableCustomCollisions(true) 
    self:PhysicsInitConvex(verts_col, "hard_light_bridge")
    self:GetPhysicsObject():EnableMotion(false)
    self:GetPhysicsObject():SetContents(CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_BLOCKLOS)
end

if SERVER then
    function ENT:UpdateTransmitState()
        return TRANSMIT_ALWAYS
    end
end