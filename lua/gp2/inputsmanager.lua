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

    if name:find("^O_") then
        ent:TriggerConnectedOutput(name:gsub("^O_", ""))
    end

    if ent:GetClass() == "env_projectedtexture" and name:lower() == "turnon" then
        local othersPj = ents.FindByClass(ent:GetClass())

        for i = 1, #othersPj do
            local pj = othersPj[i]

            if not IsValid(pj) then continue end
            if pj == ent then continue end

            pj:Input("TurnOff")
        end
    end

    if ent:GetClass() == "point_servercommand" and value == "give weapon_portalgun" then
        for _, ply in ipairs(player.GetAll()) do
            ply:Give("weapon_portalgun")
        end
    end 

    -- Hack for sp_a2_bts4
    if ent:GetClass() == "env_entity_maker" and name:lower() == "forcespawn" and ent:GetName() == "conveyor_turret_maker" then
        timer.Simple(1, function()
            local conveyor_turret_body = ents.FindByName("conveyor_turret_body")

            for i = 1, #conveyor_turret_body do
                local turret = conveyor_turret_body[i]

                if IsValid(turret) then
                    local phys = turret:GetPhysicsObject()
                    local direction = ent:GetInternalVariable("PostSpawnDirection")
                    local vel = Angle(0, 205, 0)
    
                    if IsValid(phys) then
                        phys:SetVelocity(vel:Forward() * 500)
                        turret:SetVelocity(vel:Forward() * 500)
                    end
                end
            end
        end)
    end

    if name == "O_OnCompleted" then
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
    end

    if name == "O_OnCanceled" then
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
    end

    if name == "O_OnStart"  then
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
    end

    name = name:lower()

    if ent:GetClass() == "logic_playerproxy" then
        local potatoGunActions = {
            addpotatostoportalgun = true,
            removepotatosfromportalgun = false
        }
        
        if potatoGunActions[name] ~= nil then
            for _, ply in ipairs(player.GetAll()) do
                if not ply:Alive() then continue end
                
                for _, wep in ipairs(ply:GetWeapons()) do
                    if wep:GetClass() == "weapon_portalgun" then
                        local isActive = ply:GetActiveWeapon() == wep
                        wep:UpdatePotatoGun(isActive and potatoGunActions[name])
                        wep:SetIsPotatoGun(potatoGunActions[name])
                    end
                end
            end
        end
    end

    if ent:GetClass() == "env_tonemap_controller" and name == "setbloomscale" then
        loweredValue = tonumber(value) * 0.2

        if not ent.DontCallBloomScaleAgain then
            ent.DontCallBloomScaleAgain = true
            --print('Rerouting setbloomscale out to ' .. loweredValue)
            ent:Input("setbloomscale", NULL, NULL, loweredValue)

            timer.Simple(0, function()
                ent.DontCallBloomScaleAgain = nil
            end)

            return true
        end
    end
end)

