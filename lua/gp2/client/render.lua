-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Render related hooks
-- ----------------------------------------------------------------------------

EnvPortalLaser = EnvPortalLaser or {}
EnvPortalLaser.Lasers = EnvPortalLaser.Lasers or {}

ProjectedWallEntity = ProjectedWallEntity or {}
ProjectedWallEntity.Walls = ProjectedWallEntity.Walls or {}

local MAX_RAY_LENGTH = 8192
local LASER_MATERIAL = Material("sprites/purplelaser1.vmt")
local LASER_MATERIAL_LETHAL = Material("sprites/laserbeam.vmt")
local LETHAL_COLOR = Color(100, 255, 100)
local NORMAL_COLOR = Color(255, 255, 255)
local SPARK_MATERIAL = Material("effects/spark.vmt")

local PROJECTED_WALL_MATERIAL = Material("effects/projected_wall")

function EnvPortalLaser.AddToRenderList(laser)
    EnvPortalLaser.Lasers[laser] = true
end

function ProjectedWallEntity.AddToRenderList(ent, wall)
    ProjectedWallEntity.Walls[ent] = wall
end

function ProjectedWallEntity.IsAdded(ent)
    return ProjectedWallEntity.Walls[ent] ~= nil and ProjectedWallEntity.Walls[ent]:IsValid()
end

function EnvPortalLaser.Render()
    for laser in pairs(EnvPortalLaser.Lasers) do
        if not IsValid(laser) then
            EnvPortalLaser.Lasers[laser] = nil
            continue
        end

        if not laser:GetEnabled() or IsValid(laser:GetHitEntity()) then 
            if laser.impactParticles then
                laser.impactParticles:StopEmission()
                laser.impactParticles = nil
            end
        else
            if not laser.impactParticles then
                laser.impactParticles = CreateParticleSystem(laser, "discouragement_beam_sparks", PATTACH_CUSTOMORIGIN) 
            end
        end

        if not laser:GetEnabled() then 
            return 
        end
        local curTime = CurTime()

        local lookup = laser:LookupAttachment("laser_attachment")
        local attach

        if lookup == 0 or lookup == -1 then
            attach = {
                Pos = laser:GetPos()
            }
        else
            attach = laser:GetAttachment(lookup)
        end

        local fwd = laser:GetAngles():Forward()
            
        local start = attach.Pos
        local tr = util.TraceLine({
            start = start,
            endpos = start + fwd * MAX_RAY_LENGTH,
            filter = function(ent)
                return not (ent == laser or ent == laser:GetParent() or ent.IsLaserCatcher or ent.IsLaserTarget)
            end,
            mask = MASK_OPAQUE_AND_NPCS,
        })

        local laserDirection = (start - tr.HitPos):GetNormalized()

        laser.trailPoints = laser.trailPoints or {}
        
        render.SetMaterial(laser:GetLethalDamage() and LASER_MATERIAL_LETHAL or LASER_MATERIAL)
        render.DrawBeam(start, tr.HitPos, 32, 0, 1, laser:GetLethalDamage() and LETHAL_COLOR or NORMAL_COLOR)

        -- Update impact point particles
        if laser.impactParticles then
            laser.impactParticles:SetControlPointOrientation(0, tr.HitNormal:Angle())
            laser.impactParticles:SetControlPoint(0, tr.HitPos)
        end
    end
end

function ProjectedWallEntity.Render()
    for entity, wall in pairs(ProjectedWallEntity.Walls) do
        if not IsValid(entity) then
            ProjectedWallEntity.Walls[entity] = nil
            return
        end

        if wall and wall:IsValid() then
            render.SetMaterial(PROJECTED_WALL_MATERIAL)
            wall:Draw()
        end
    end
end

hook.Add("PreDrawTranslucentRenderables", "GP2::PreDrawTranslucentRenderables", function(depth, sky, skybox3d)
    PropIndicatorPanel.Render()
    VguiMovieDisplay.Render()
    VguiSPProgressSign.Render()
    EnvPortalLaser.Render()
    ProjectedWallEntity.Render()
end)