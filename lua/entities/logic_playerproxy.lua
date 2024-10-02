-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Relay inputs/outputs to the player and back to the world.
-- ----------------------------------------------------------------------------

ENT.Type = "point"

function ENT:KeyValue(k, v)
    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end
end

ENT.__input2func = {
    ["setdropenabled"] = function(self, activator, caller, data)
        for _, sphere in ipairs(ents.FindByClass("npc_personality_core")) do
            sphere:SetDropEnabled(tobool(data))
        end
    end,    
}

function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()
    local func = self.__input2func[name]

    if func and isfunction(func) then
        func(self, activator, caller, data)
    end
end