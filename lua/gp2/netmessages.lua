-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Various net messages
-- ----------------------------------------------------------------------------

GP2.Net = {}

local function AddNetworkMessage(message)
    GP2.Net[message] = message
end

AddNetworkMessage "SendVscriptError"
AddNetworkMessage "SendEmitSound"
AddNetworkMessage "SendMovieDisplay"
AddNetworkMessage "SendRemoveMovieDisplay"
AddNetworkMessage "SendProgressSignDisplay"
AddNetworkMessage "SendRemoveProgressSignDisplay"
AddNetworkMessage "SendPrecacheMovie"
AddNetworkMessage "SendDeferredParticleSystem"
AddNetworkMessage "SendLoadedToServer"

if SERVER then
    for net in pairs(GP2.Net) do
        util.AddNetworkString(net)
    end
end