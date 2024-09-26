-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Sentry turret with 3 legs and fancy laser
-- ----------------------------------------------------------------------------

include "shared.lua"

function ENT:Initialize()
    NpcPortalTurretFloor.AddToRenderList(self)
end