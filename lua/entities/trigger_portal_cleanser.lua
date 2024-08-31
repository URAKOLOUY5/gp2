ENT.Type = "brush"

local mats = {}

local ENTS_TO_DISSOLVE = {
    ["prop_physics"] = true,
    ["prop_weighted_cube"] = true,
    ["prop_monster_box"] = true,
    ["npc_portal_turret_floor"] = true,
    ["npc_turret_floor"] = true,
}

function ENT:KeyValue(k, v)
    if k == "StartDisabled" then
        self:SetEnabled(not tobool(v))
    end

    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end
end

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", "Enabled" )
end

function ENT:Initialize()
    self:SetTrigger(true)

    for _, mat in pairs(self:GetMaterials()) do
        if not mats[mat] then
            mats[mat] = Material(mat)
        end

        if mats[mat]:GetShader():StartsWith("SolidEnergy") then
            self:RemoveEffects(EF_NODRAW)
        end
    end
end

function ENT:StartTouch(ent)
    if not self:GetEnabled() then return end
    if not IsValid(ent) then return end
    if not ENTS_TO_DISSOLVE[ent:GetClass()] then return end
    
    ent:Dissolve(0)
    if ent.Fizzle and isfunction(ent.Fizzle) then
        ent:Fizzle()
    end
end