-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Various KV handlers
-- ----------------------------------------------------------------------------

GP2.KeyValueHandler = {
    Callbacks = {},
    Add = function(k, func, classname)
        GP2.KeyValueHandler.Callbacks[k] = {func, classname}
    end
}

hook.Add("EntityKeyValue", "GP2::EntityKeyValue", function(ent, k, v)
    local callback = GP2.KeyValueHandler.Callbacks[k]

    if ent:GetClass() == "trigger_once" and v:find("OnPostTransition()") then
        local trigger_multiple = ents.Create("trigger_multiple")
        trigger_multiple:Fire("AddOutput", k .. " " .. v)
        trigger_multiple:SetKeyValue("spawnflags", "1")
        trigger_multiple:Spawn()
        trigger_multiple:Activate()
        trigger_multiple:SetPos(ent:GetPos())
        trigger_multiple:SetCollisionBounds(ent:GetCollisionBounds())
        trigger_multiple:UseTriggerBounds(true)        

        ent:Remove()
    end

    if callback then
        local func = callback[1]
        local classname = callback[2]
    
        if func and isfunction(func) then
            if classname and ent:GetClass() ~= classname then return end
            func(ent, v)
        end
    end

    -- Recall the Output as input
    local lowerk = k:lower()
    if lowerk:StartsWith("on") then
        local name = k .. " !self," .. "O_" .. lowerk .. ",,0,-1"
        --GP2.Print("Adding output  => %q ", name)
        ent:Input("AddOutput", NULL, NULL, name)
    end
end)

GP2.KeyValueHandler.Add("brightnessscale", function(ent, v)
    ent.brightnessscale = v
end, "env_projectedtexture")

GP2.KeyValueHandler.Add("lightcolor", function(ent, v)
    ent.brightnessscale = ent.brightnessscale or 1

    timer.Simple(0, function()
        local ob = v:Split(" ")
        local r = ob[1] or "255"
        local g = ob[2] or "255"
        local b = ob[3] or "255"
        local a = tonumber(ob[4] or "300")
        a = a * ent.brightnessscale * 5
        local brightness = originalBrightness
        ent:SetKeyValue("lightcolor", r .. " " .. g .. " " .. b .. " " .. a)
    end)
end, "env_projectedtexture")