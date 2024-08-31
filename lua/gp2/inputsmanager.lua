-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Various IO input handlers
-- ----------------------------------------------------------------------------

local developer = GetConVar("developer")

GP2.InputsHandler = {
    Callbacks = {},
    AddCallback = function(name, func)
        GP2.InputsHandler.Callbacks = GP2.InputsHandler.Callbacks or {}
        GP2.InputsHandler.Callbacks[name] = func
    end,
}

hook.Add("AcceptInput", "GP2::AcceptInput", function(ent, name, activator, caller, value)
    local callback = GP2.InputsHandler.Callbacks[name:lower()]

    if callback and isfunction(callback) then
        callback(ent, activator, caller, value)
    end

    if name == "_OnCompletion" then            
        if ent.IsScriptSceneEntity and isfunction(ent.IsScriptSceneEntity) and ent:IsScriptSceneEntity() then
            ent:_OnCompletion()
        end          
    end

    if name == "_OnCanceled" then
        -- HACK to use GetCurrentScene on actors
        local vcd = ent:GetInternalVariable("SceneFile")

        if vcd then
            local vcdContent = file.Read(vcd, "GAME")

            if vcdContent then
                for actorName in vcdContent:gmatch('actor%s+"(.-)"') do
                    for _, entity in ipairs(ents.GetAll()) do
                        if entity:GetName() == actorName then
                            entity:SetCurrentScene(NULL)
                        end
                    end
                end
            end
        end

        if ent.IsScriptSceneEntity and isfunction(ent.IsScriptSceneEntity) and ent:IsScriptSceneEntity() then
            ent:_OnCanceled()
        end            
    end

    if name == "_OnStart"  then
        -- HACK to use GetCurrentScene on actors
        local vcd = ent:GetInternalVariable("SceneFile")

        if vcd then
            local vcdContent = file.Read(vcd, "GAME")

            if vcdContent then
                for actorName in vcdContent:gmatch('actor%s+"(.-)"') do
                    for _, entity in ipairs(ents.GetAll()) do
                        if entity:GetName() == actorName then
                            entity:SetCurrentScene(ent)
                        end
                    end
                end
            end
        end

        if ent.IsScriptSceneEntity and isfunction(ent.IsScriptSceneEntity) and ent:IsScriptSceneEntity() then
            ent:_OnStart() 
        end            
    end
end)

