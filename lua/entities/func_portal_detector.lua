-- ----------------------------------------------------------------------------
-- GP2
-- Trigger for floor buttons
-- ----------------------------------------------------------------------------

ENT.Type = "brush"
ENT.TouchingEnts = 0
ENT.Button = NULL

local PORTAL_VALID_ENTS = {
    ["prop_portal"] = true
}

local SF_INACTIVE = 1

function ENT:KeyValue(k, v)
    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end

    if k == "spawnflags" and bit.band(tonumber(v), SF_INACTIVE) ~= 0 then
        self:SetEnabled(false)
    end
end

ENT.__input2func = {
    ["enable"] = function(self, activator, caller, data)
        self:SetEnabled(true)
    end,
    ["diasble"] = function(self, activator, caller, data)
        if not self:GetIsChecked() then return end

        self:SetEnabled(false)
    end,
    ["toggle"] = function(self, activator, caller, data)
        self:SetEnabled(not self:GetEnabled())
    end,    
}

function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()
    local func = self.__input2func[name]

    if func and isfunction(func) then
        func(self, activator, caller, data)
    end
end

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", "Enabled" )

    if SERVER then
        self:SetEnabled(true)
    end
end

function ENT:Initialize()
    self:SetSolid(SOLID_BBOX)
    self:SetTrigger(true)
end

function ENT:StartTouch(ent)
    print(ent)
    if not self:GetEnabled() then return end
    if not PORTAL_VALID_ENTS[ent:GetClass()] then return end

    self:TriggerOutput("OnStartTouchPortal")
    print "detected portal"
end

function ENT:EndTouch(ent)
    if not self:GetEnabled() then return end
    if not PORTAL_VALID_ENTS[ent:GetClass()] then return end

    self:TriggerOutput("OnEndTouchPortal")
end

-- TODO: store portals and detect if they're linked
-- and remove from list
function ENT:Think(ent)
end