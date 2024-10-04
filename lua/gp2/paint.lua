-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Paint and blobulator
-- ----------------------------------------------------------------------------

local TraceLine = util.TraceLine

PaintManager = {}
PaintManager.ReplicatedPlayerList = {}

gp2_blobulator_debug = CreateConVar("gp2_blobulator_debug", "1", FCVAR_CHEAT + FCVAR_REPLICATED, "Enable debug visualization for Blobulator/Paint implementation")
bounce_paint_color = CreateConVar("bounce_paint_color", "0 165 255 255", FCVAR_CHEAT + FCVAR_REPLICATED, "Color of Bounce gel")
speed_paint_color = CreateConVar("speed_paint_color", "255 165 0 255", FCVAR_CHEAT + FCVAR_REPLICATED, "Color of Speed gel")
portal_paint_color = CreateConVar("portal_paint_color", "128 128 128 255", FCVAR_CHEAT + FCVAR_REPLICATED, "Color of Portal gel")

local function cross2D(v1, v2)
    return v1.x * v2.y - v1.y * v2.x
end

local function IsPointInShape(point, vertices, normal, tolerance)
    if #vertices < 3 then return false end

    -- Get point on surface and normal
    local planePoint = vertices[1]
    local planeNormal = normal

    -- Project point to plane
    local relativePoint = point - planePoint
    local distance = relativePoint:Dot(planeNormal)
    
    -- Check if height of point within tolerance
    if math.abs(distance) > tolerance then
        return false
    end

    local projectedPoint = point - planeNormal * distance

    -- Transform coords to 2D
    local transformTo2D = function(vec)
        local u = vertices[2] - planePoint
        local v = u:Cross(planeNormal)
        u:Normalize()
        v:Normalize()

        return Vector(vec:Dot(u), vec:Dot(v))
    end

    local point2D = transformTo2D(projectedPoint)

    local windingNumber = 0

    for i = 1, #vertices do
        local start = vertices[i]
        local finish = vertices[i % #vertices + 1]

        local start2D = transformTo2D(start)
        local finish2D = transformTo2D(finish)

        if start2D.y <= point2D.y then
            if finish2D.y > point2D.y and cross2D(finish2D - start2D, point2D - start2D) > 0 then
                windingNumber = windingNumber + 1
            end
        else
            if finish2D.y <= point2D.y and cross2D(finish2D - start2D, point2D - start2D) < 0 then
                windingNumber = windingNumber - 1
            end
        end
    end

    return windingNumber ~= 0
end

function PaintManager.Initialize()
    if SERVER then
        GP2.Print("Paint initialized")
    else
    end
end

function PaintManager.Think()
end

function PaintManager.GetSurfaceByTrace(start, direction)
    local tr = util.TraceLine({
        start = start,
        endpos = start + direction * 8192,
        filter = ents.GetAll(),
        mask = MASK_NPCWORLDSTATIC
    })
    
    if gp2_blobulator_debug:GetBool() then
        debugoverlay.Line(tr.StartPos, tr.HitPos, 0.25, Color(122,167,252))
        debugoverlay.Cross(tr.HitPos, 2, 0.25, Color(122,167,252))
    end

    if tr.HitWorld then
        local surfinfo = tr.Entity:GetBrushSurfaces()
        
        for s = 1, #surfinfo do
            local vertices = surfinfo[s]:GetVertices()

            if not IsPointInShape(tr.HitPos, vertices, tr.HitNormal, 5) then continue end
            
            if gp2_blobulator_debug:GetBool() then
                for i = 1, #vertices do
                    debugoverlay.Text(vertices[i], tostring(i), 2, false)
                end
    
                -- Connect the vertices with lines to form a shape
                for i = 1, #vertices do
                    -- Draw a line to the next vertex (wrap around to the first vertex for the last line)
                    local nextIndex = i + 1
                    if nextIndex > #vertices then
                        nextIndex = 1
                    end
    
                    -- Draw line between current vertex and the next one
                    debugoverlay.Line(vertices[i], vertices[nextIndex], 2, Color(255, 0, 0), true)
                end
            end

            return s -- Return index of surface
        end
    end 
end

if CLIENT then
    local backgroundColor = Color(0,0,0,128)
    local DrawRect = surface.DrawRect
    local SetDrawColor = surface.SetDrawColor
    local DrawText = surface.DrawText
    local SetFont = surface.SetFont
    local SetTextPos = surface.SetTextPos
    local SetTextColor = surface.SetTextColor

    local DebugOverlay = "DebugOverlay"
    local DebugOverlayBig = "DebugOverlayBig"
    local NoPaint = "Paint is disabled!!!"

    --
    -- Debug hud
    --
    function PaintManager.LegacyHud(scrw, scrh)
        if not gp2_blobulator_debug:GetBool() then return end

        local hasPaint = GetGlobalBool("GP2::PaintInMap", false)

        if not hasPaint then
            SetDrawColor(backgroundColor)
            DrawRect(scrw * 0.8, scrh * 0.2, 300, 100)

            SetFont(DebugOverlayBig)
            SetTextColor(255,0,0,255)
            SetTextPos(scrw * 0.802, scrh * 0.2)
            DrawText(NoPaint)
        else
            SetDrawColor(backgroundColor)
            DrawRect(scrw * 0.8, scrh * 0.2, 200, 100)
    
            SetFont(DebugOverlay)
            SetTextColor(0,200,255)
            SetTextPos(scrw * 0.8, scrh * 0.2)
            DrawText("Paint Debug: ")
        end
    end
else
    function PaintManager.FetchPaintInMap(world, value)
        SetGlobalBool("GP2::PaintInMap", tobool(value))
    end

    GP2.KeyValueHandler.Add("paintinmap", PaintManager.FetchPaintInMap, "worldspawn")
end