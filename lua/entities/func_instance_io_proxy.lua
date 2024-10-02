-- ----------------------------------------------------------------------------
-- GP2 Framework
-- https://developer.valvesoftware.com/wiki/Func_instance_io_proxy
-- ----------------------------------------------------------------------------

ENT.Type = "point"

function ENT:KeyValue(k, v)
    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end
end

function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()

    local proxyrelayPrefix = "proxyrelay"
    local proxyrelayPrefix2 = "onproxyrelay"
    if name:StartsWith(proxyrelayPrefix) then
        local relayNumber = name:sub(#proxyrelayPrefix + 1)
        self:TriggerOutput("OnProxyRelay" .. relayNumber)  
    end

    if name:StartsWith(proxyrelayPrefix2) then
        local relayNumber = name:sub(#proxyrelayPrefix2 + 1)
        self:TriggerOutput("OnProxyRelay" .. relayNumber)  
    end
end