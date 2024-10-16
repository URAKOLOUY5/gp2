-- ********************************************************************************************
-- MAPSPAWN.lua is called on newgame or transitions
-- ********************************************************************************************
print("==== calling mapspawn.lua")

print('Fixing elevator...')
-- Fixup for arrival teleport
local arrivalTeleport = ents.FindByName("@arrival_teleport")[1]

if arrivalTeleport and IsValid(arrivalTeleport) then
    arrivalTeleport:Input("SetParent", NULL, NULL, "arrival_elevator-elevator_1_body")
    
    local pos = arrivalTeleport:GetPos()
    pos.z = pos.z + 1

    arrivalTeleport:SetPos(pos)
end

-- Fixup for arrival elevator input
local arrival_elevator_elevator_1 = ents.FindByName("arrival_elevator-elevator_1")[1]
if IsValid(arrival_elevator_elevator_1) then
    arrival_elevator_elevator_1:Fire("AddOutput", "OnArrivedAtDestinationNode arrival_elevator-elevator_1,Stop,,0,-1")
end

-- Fix position for @elevator_1_bottom_path_1
local elevator_1_bottom_path_1 = ents.FindByName("@elevator_1_bottom_path_1")[1]
if IsValid(elevator_1_bottom_path_1) then
    local pos = elevator_1_bottom_path_1:GetPos()
    -- idk this works for some reasons
    -- like 0.1 works everywhere i've tested (funny math)
    pos.z = pos.z - 0.1
    elevator_1_bottom_path_1:SetPos(pos)
end

-- Fix shadows for prop_dynamic
local prop_dynamics = ents.FindByClass("prop_dynamic")

for _, ent in pairs(prop_dynamics) do
    ent:DrawShadow(false)
end

-- HACK for CLIP brushes for turrets

local MAPS_WITH_BROKEN_TURRETS = {
    ["sp_a2_turret_intro"] = true,
    ["sp_a2_laser_vs_turret"] = true,
    ["sp_a2_turret_blocker"] = true,
}

if MAPS_WITH_BROKEN_TURRETS[game.GetMap()] then
    local turrets = ents.FindByClass("npc_portal_turret_floor")

    for _, turret in ipairs(turrets) do
        if IsValid(turret:GetPhysicsObject()) then
            turret:GetPhysicsObject():Sleep()
        end
    end
end

function OnPostPlayerSpawn(ply)
    if game.GetMap() == "sp_a3_01" then
        local ang = ply:GetAngles()
        local i = ply:EntIndex()
        local initialPlayerPos = ply:GetPos()
        local initialPos = Vector(-719.880005, -1852, 0)
        local offset = ang:Right() * (32 * (i - 1))

        -- Teleport player to area to open areaportal properly
        ply:SetPos(initialPos + offset)
        
        timer.Simple(13, function()
            ply:SetPos(initialPlayerPos)
            print('Set pos to back')
        end)
    end
end

function OnPostSpawn()
    EntFire("instanceauto*-entrance_lift_train", "StartForward", "", 0)
end