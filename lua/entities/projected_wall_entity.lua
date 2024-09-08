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
end

function ENT:Initialize()
end

function ENT:Think()
    if not self:GetUpdated() then
        self:CreateWall()
    end
    
if CLIENT then
    self:SetNextClientThink(CurTime() + 0.1)

    if not ProjectedWallEntity.IsAdded(self) then
        self:CreateWall()
    end
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
    local startPos = self:GetParent():GetPos()

    local angles = self:GetAngles()

    local fwd, right, up = angles:Forward(), angles:Right(), angles:Up()

    local tr = util.TraceLine({
        start = startPos,
        endpos = startPos + fwd * MAX_RAY_LENGTH,
        mask = MASK_NPCWORLDSTATIC,
    })

    local hitPos = tr.HitPos
    local distance = hitPos:Distance(startPos)

    local v = distance / 192
    v = -v

    local verts = {}

    if CLIENT then
        verts = {
            { pos = startPos - right * (PROJECTED_WALL_WIDTH / 2), u = 1, v = 0 },
            { pos = startPos - right * (PROJECTED_WALL_WIDTH / 2) + fwd * distance, u = 1, v = v },
            { pos = startPos - right * (PROJECTED_WALL_WIDTH / 2) + fwd * distance + right * PROJECTED_WALL_WIDTH, u = 0, v = v },
        
            { pos = startPos + right * (PROJECTED_WALL_WIDTH / 2) + fwd * distance, u = 0, v = v },
            { pos = startPos + right * (PROJECTED_WALL_WIDTH / 2), u = 0, v = 0 },
            { pos = startPos - right * (PROJECTED_WALL_WIDTH / 2), u = 1, v = 0 },
        }
    else
        local halfLength = (tr.HitPos - startPos):Length() / 2
        local halfWidth = PROJECTED_WALL_WIDTH / 2

        local x0 = -halfLength
        local y0 = -halfWidth
        local z0 = -1
    
        local x1 = halfLength
        local y1 = halfWidth
        local z1 = 0

        verts = {
            Vector( x0, y0, z0 ),
            Vector( x0, y0, z1 ),
            Vector( x0, y1, z0 ),
            Vector( x0, y1, z1 ),
            Vector( x1, y0, z0 ),
            Vector( x1, y0, z1 ),
            Vector( x1, y1, z0 ),
            Vector( x1, y1, z1 )
        }
    end

    if CLIENT then
        if self.Mesh and self.Mesh:IsValid() then
            self.Mesh:Destroy()
        end

        self.Mesh = Mesh()
        self.Mesh:BuildFromTriangles(verts)
        ProjectedWallEntity.AddToRenderList(self, self.Mesh)
    end

    self:SetPos((startPos + tr.HitPos) / 2)

    if SERVER then
        self:PhysicsInitStatic(6)
        
        self:PhysicsInitConvex(verts, "hard_light_bridge")
        self:GetPhysicsObject():EnableMotion(false)
        self:GetPhysicsObject():SetContents(CONTENTS_SOLID+CONTENTS_MOVEABLE+CONTENTS_BLOCKLOS)
        self:EnableCustomCollisions(true)                
        self:SetUpdated(true)
    else
        if not self.WallImpact then
            local wallImpactAng = tr.HitNormal:Angle()
            wallImpactAng.z = self:GetAngles().z

            self.WallImpact = CreateParticleSystemNoEntity("projected_wall_impact", tr.HitPos - fwd * 4, wallImpactAng)
            self.WallImpact:SetControlPoint(1, Vector(1,1,1))

        end
    end
end

if SERVER then
    function ENT:UpdateTransmitState()
        return TRANSMIT_ALWAYS
    end
end