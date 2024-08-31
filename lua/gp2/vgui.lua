-- ----------------------------------------------------------------------------
-- GP2 Framework
-- VGuiPanels
-- ----------------------------------------------------------------------------

GP2.KeyValueHandler.Add("panelname", function(ent, v)
    local sp_progress_sign = ents.Create("vgui_sp_progress_sign")
    sp_progress_sign:SetPos(ent:GetPos())
    sp_progress_sign:SetAngles(ent:GetAngles())
    sp_progress_sign:SetName(ent:GetName())
    sp_progress_sign:Spawn()

    timer.Simple(0, function()
        sp_progress_sign:SetAngles(ent:GetAngles())
        ent:Remove()
    end)
end, "vgui_screen")