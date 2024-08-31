-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Change level
-- ----------------------------------------------------------------------------

ENT.Type = "point"

function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()

    if name == "changelevel" then
        RunConsoleCommand("changelevel", data)     
    elseif name == "changelevelpostfade" then
        RunConsoleCommand("changelevel", data)
    end
end  