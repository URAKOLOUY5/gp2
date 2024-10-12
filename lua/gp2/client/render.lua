-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Render related hooks
-- ----------------------------------------------------------------------------

EnvPortalLaser = EnvPortalLaser or {}
EnvPortalLaser.Lasers = EnvPortalLaser.Lasers or {}

ProjectedWallEntity = ProjectedWallEntity or {}
ProjectedWallEntity.Walls = ProjectedWallEntity.Walls or {}

NpcPortalTurretFloor = NpcPortalTurretFloor or {}
NpcPortalTurretFloor.Turrets = NpcPortalTurretFloor.Turrets or {}

local MAX_RAY_LENGTH = 8192
local LASER_MATERIAL = Material("sprites/purplelaser1.vmt")
local LASER_MATERIAL_LETHAL = Material("sprites/laserbeam.vmt")
local LETHAL_COLOR = Color(100, 255, 100)
local NORMAL_COLOR = Color(255, 255, 255)
local SPARK_MATERIAL = Material("effects/spark.vmt")

local TURRET_BEAM_COLOR = Color(255,32,32,255)
local TURRET_BEAM_MATERIAL = Material("effects/redlaser1_scripted.vmt")
local TURRET_EYE_GLOW = Material("sprites/glow1_scripted.vmt")

local PROJECTED_WALL_MATERIAL = Material("effects/projected_wall")
local END_POINT_PULSE_SCALE = 16

local HALF_VECTOR = Vector(0.5,0.5,0.5)
local HALF2_VECTOR = Vector(0.25,0.25,0.25)

local gp2_projected_wall_dlight = CreateClientConVar("gp2_projected_wall_dlight", "1", true, false, "Should Hard Light Bridge emit light? Can be expensive if bridge is long!", 0, 1)

TURRET_EYE_GLOW:SetVector("$color", HALF_VECTOR)
TURRET_BEAM_MATERIAL:SetVector("$color", HALF2_VECTOR)

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
        
        render.SetMaterial(LASER_MATERIAL)
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

            if gp2_projected_wall_dlight:GetBool() then
                for i = 64, entity:GetDistanceToHit() - 32, 32 do
                    local dlight = DynamicLight( i )
                    local point = entity:GetParent():GetPos() + entity:GetAngles():Forward() * i

                    if dlight then
                        dlight.pos = point
                        dlight.r = 0
                        dlight.g = 25
                        dlight.b = 75
                        dlight.brightness = 1
                        dlight.decay = 1000 * FrameTime()
                        dlight.size = 192
                        dlight.dietime = CurTime() + 1
                    end
                end
            end
        end
    end
end

function NpcPortalTurretFloor.AddToRenderList(turret)
    NpcPortalTurretFloor.Turrets[turret] = true
end

function NpcPortalTurretFloor.Render()
    for turret in pairs(NpcPortalTurretFloor.Turrets) do
        if not IsValid(turret) then 
            NpcPortalTurretFloor.Turrets[turret] = nil
            continue
        end

        if turret:GetEyeState() == 3 then continue end

        turret.attachNum = turret.attachNum or turret:LookupAttachment("light")
        local attach = turret:GetAttachment(turret.attachNum)

        local start = attach.Pos
        local fwd = turret:GetAngles():Forward()

        local prmn, prmx = turret:GetPoseParameterRange("aim_pitch")
        local yrmn, yrmx = turret:GetPoseParameterRange("aim_yaw")

        local pitch = math.Remap(turret:GetPoseParameter("aim_pitch"), 0, 1, prmn, prmx)
        local yaw = math.Remap(turret:GetPoseParameter("aim_yaw"), 0, 1, yrmn, yrmx)

        turret.LaserAngles = turret.LaserAngles or Angle(0,0,0)
        turret.LaserAngles.x = turret:GetAngles().x + pitch
        turret.LaserAngles.y = turret:GetAngles().y + yaw

        local tr = util.TraceLine({
            start = start,
            endpos = start + turret.LaserAngles:Forward() * MAX_RAY_LENGTH,
            filter = {turret},
            mask = MASK_SOLID,
        })

        turret.FlickerTime = turret.FlickerTime or 0
        turret.Flicked = turret.Flicked or false

        turret.PixVis = turret.PixVis or util.GetPixelVisibleHandle()
        turret.PixVis2 = turret.PixVis2 or util.GetPixelVisibleHandle()
        local pixelVisibility = util.PixelVisible(start, 16, turret.PixVis)
        local pixelVisibility2 = util.PixelVisible(tr.HitPos, 1, turret.PixVis2)

        if not turret:GetHasAmmo() and CurTime() > turret.FlickerTime then
            turret.Flicked = not turret.Flicked
            turret.FlickerTime = CurTime() + math.Rand(0.05, 0.3)
        end

        turret.EyeGlowColor = turret.EyeGlowColor or Color(255,0,0)
        turret.BeamGlowColor = turret.BeamGlowColor or Color(255,0,0)

        turret.BeamGlowColor.r = 255 * pixelVisibility2

        turret.BeamPulseOffset = turret.BeamPulseOffset or math.Rand(0, 2 * math.pi)
        turret.BeamGlowSize = turret.BeamGlowSize or 0
        turret.BeamGlowSize = ((math.max(0.0, math.sin(CurTime() * math.pi + turret.BeamPulseOffset))) * END_POINT_PULSE_SCALE + 3.0)
        
        if turret:GetEyeState() < 3 and not turret.Flicked then
            render.SetBlend(0.2)
            render.SetMaterial(TURRET_BEAM_MATERIAL)
            TURRET_BEAM_MATERIAL:SetVector("$color", HALF_VECTOR)
            render.DrawBeam(start, tr.HitPos, 2, 0, 1, TURRET_BEAM_COLOR)

            render.OverrideBlend( true, BLEND_SRC_COLOR, BLEND_SRC_ALPHA, BLENDFUNC_ADD )
            render.SetMaterial(TURRET_EYE_GLOW)
            render.DrawSprite(tr.HitPos, turret.BeamGlowSize, turret.BeamGlowSize, turret.BeamGlowColor)
            render.OverrideBlend( false )
        end

        turret.EyeGlowSize = turret.EyeGlowSize or 32
        turret.EyeGlowColor = turret.EyeGlowColor or Color(255,0,0)

        if not turret:GetIsAsActor() then
            if turret:GetEyeState() == 1 then
                turret.EyeGlowColor.r = Lerp(FrameTime() * 15, turret.EyeGlowColor.r, 128)
                turret.EyeGlowSize = Lerp(FrameTime() * 5, turret.EyeGlowSize, 32)
            elseif turret:GetEyeState() == 2 then
                turret.EyeGlowColor.r = Lerp(FrameTime() * 15, turret.EyeGlowColor.r, 192)
                turret.EyeGlowSize = Lerp(FrameTime() * 5, turret.EyeGlowSize, 48)
            elseif turret:GetEyeState() == 3 then
                turret.EyeGlowColor.r = Lerp(FrameTime() * 15, turret.EyeGlowColor.r, 0)
                turret.EyeGlowSize = Lerp(FrameTime() * 0.5, turret.EyeGlowSize, 64)
            end
        else
            turret.EyeGlowColor.r = Lerp(FrameTime() * 15, turret.EyeGlowColor.r, 0)
            turret.EyeGlowSize = Lerp(FrameTime() * 5, turret.EyeGlowSize, 32)
        end

        local lp = LocalPlayer()
        local plyPos = lp:GetPos()
        local directionToPlayer = (plyPos - turret:GetPos()):GetNormalized()
        local fwd = turret:GetAngles():Forward()
        local dot = fwd:Dot(directionToPlayer)
        local opacity = math.Clamp((dot + 1) / 2, 0, 1)

        turret.EyeGlowColor.r = 255 * opacity

        render.OverrideBlend( true, BLEND_SRC_COLOR, BLEND_SRC_ALPHA, BLENDFUNC_ADD )
        render.SetMaterial(TURRET_EYE_GLOW)
        render.DrawSprite(start, turret.EyeGlowSize, turret.EyeGlowSize, turret.EyeGlowColor)
        render.OverrideBlend( false )
    end
end


hook.Add("PreDrawTranslucentRenderables", "GP2::PreDrawTranslucentRenderables", function(depth, sky, skybox3d)
    PropIndicatorPanel.Render()
    VguiMovieDisplay.Render()
    VguiSPProgressSign.Render()
    EnvPortalLaser.Render()
    ProjectedWallEntity.Render()
    NpcPortalTurretFloor.Render()
end)