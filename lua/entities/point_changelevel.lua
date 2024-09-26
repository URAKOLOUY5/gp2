-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Change level
-- ----------------------------------------------------------------------------

ENT.Type = "point"

local black = Color(0,0,0)

function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()

    if name == "changelevel" then    
        for _, ply in ipairs(player.GetAll()) do
            ply:ScreenFade(SCREENFADE.OUT, black, 0.25, 0.5)
        end

        timer.Simple(0.25, function()
            RunConsoleCommand("changelevel", data)
        end)
    elseif name == "changelevelpostfade" then
        RunConsoleCommand("changelevel", data)
    end
end  