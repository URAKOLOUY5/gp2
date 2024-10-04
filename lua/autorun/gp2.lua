-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Start point for whole framework
-- ----------------------------------------------------------------------------

local developer = GetConVar("developer")

local fmt = string.format

GP2_PROJECT_COLOR_THEME = Color(180,155,255)
GP2_PROJECT_COLOR_THEME_LIGHT = Color(238,232,255)
GP2_PROJECT_COLOR_THEME_ERROR = Color(255,90,90)
GP2_PROJECT_COLOR_THEME_ERROR_LIGHT = Color(255,155,155)
GP2_PROJECT_NAME = '[GP2] '

GP2 = {
    Print = function(msg, ...)
        MsgC(GP2_PROJECT_COLOR_THEME, GP2_PROJECT_NAME)
        MsgC(GP2_PROJECT_COLOR_THEME_LIGHT, fmt(msg, ...))
        print()
    end,
    Error = function(msg, ...)
        MsgC(GP2_PROJECT_COLOR_THEME, GP2_PROJECT_NAME)
        MsgC(GP2_PROJECT_COLOR_THEME_ERROR_LIGHT, fmt(msg, ...))
        print()
    end,
}

include("gp2/netmessages.lua")
include("gp2/soundmanager.lua")
include("gp2/particles.lua")

GP2_VERSION = include("gp2/version.lua")

hook.Add("Initialize", "GP2::Initialize", function()
    SoundManager.Initialize()
end)

if SERVER then
    -- AcceptInput hooks
    include("gp2/inputsmanager.lua")
    -- EntityKeyValue hooks
    include("gp2/keyvalues.lua")
    -- Vscripts (serverside only)
    include("gp2/vscriptmanager.lua")
    include("gp2/entityextensions.lua")
    include("gp2/paint.lua")
    include("gp2/vgui.lua")

    hook.Add("PlayerSpawn", "GP2::PlayerSpawn", function(ply, transition)
        -- Try to call OnPostPlayerSpawn on all Vscripted entities
        -- and siltently fail if there's no OnPostPlayerSpawn function in script
        -- pass player to scripts to handle logic per player

        GP2.VScriptMgr.CallHookFunction("OnPostPlayerSpawn", true, ply)
    end)

    hook.Add("PlayerInitialSpawn", "GP2::PlayerInitialSpawn", function(ply, transition)
    end)

    hook.Add("PostCleanupMap", "GP2::PostCleanupMap", function()
        GP2.VScriptMgr.RunScriptFileHandless("mapspawn")
        GP2.VScriptMgr.CallHookFunction("OnPostSpawn", true)
    end)

    hook.Add("InitPostEntity", "GP2::InitPostEntity", function()
        GP2.VScriptMgr.RunScriptFileHandless("mapspawn")

        PaintManager.Initialize()
    end)

    hook.Add("Think", "GP2::Think", function()
        GP2.VScriptMgr.Think()
        -- SoundManager.Think()

        for _, ply in ipairs(player.GetHumans()) do
            if not ply:Alive() then return end
            local wep = ply:GetActiveWeapon()
            if not IsValid(wep) then return end
            if wep:GetClass() ~= "weapon_portalgun" then return end
            local vm = ply:GetViewModel(0)

            if not IsValid(vm) then return end

            vm:RemoveEffects(EF_NODRAW)
            
            if IsValid(ply:GetEntityInUse()) then
                vm:ResetSequence(10)
                vm:RemoveEffects(EF_NODRAW)
                ply.HeldEntityRecently = true
            else
                if ply.HeldEntityRecently then
                    vm:ResetSequence(12)
                    vm:RemoveEffects(EF_NODRAW)
                    ply.HeldEntityRecently = false
                end
            end


        end
    end)

    hook.Add("OnPlayerJump", "GP2::OnPlayerJump", function(ply, speed)
        for _, proxy in ipairs(ents.FindByClass("logic_playerproxy")) do
            proxy:TriggerOutput("OnJump", ply)
        end
    end)

    hook.Add("PhysgunPickup", "GP2::PhysgunPickup", function(ply, ent)
        if ent.OnPhysgunPickup and isfunction(ent.OnPhysgunPickup) then
            return ent:OnPhysgunPickup(ply)
        end
    end)

    hook.Add("PhysgunDrop", "GP2::PhysgunDrop", function(ply, ent)
        if ent.OnPhysgunDrop and isfunction(ent.OnPhysGunDrop) then
            ent:OnPhysGunDrop(ply)
        end
    end)

    hook.Add("OnPlayerPhysicsPickup", "GP2::OnPlayerPhysicsPickup", function(ply, ent)
        if ent.OnPlayerPickup and isfunction(ent.OnPlayerPickup) then
            ent:OnPlayerPickup(ply)
        end
    end)

    hook.Add("OnPlayerPhysicsDrop", "GP2::OnPlayerPhysicsDrop", function(ply, ent, thrown)
        if ent.OnPlayerDrop and isfunction(ent.OnPlayerDrop) then
            ent:OnPlayerDrop(ply, thrown)
        end
    end)

    hook.Add("GravGunOnPickedUp", "GP2::GravGunOnPickedUp", function(ply, ent)
        if ent.OnGravGunPickup and isfunction(ent.OnGravGunPickup) then
            ent:OnGravGunPickup(ply)
        end
    end)

    hook.Add("GravGunOnDropped", "GP2::GravGunOnDropped", function(ply, ent)
        if ent.OnGravGunDrop and isfunction(ent.OnGravGunDrop) then
            ent:OnGravGunDrop(ply)
        end
    end) 
    
    hook.Add("GravGunPunt", "GP2::GravGunPunt", function(ply, ent)
        if ent.OnGravGunPunt and isfunction(ent.OnGravGunPunt) then
            return ent:OnGravGunPunt(ply)
        end
    end)

    hook.Add( "PlayerFootstep", "GP2::PlayerFootsteps", function( ply, pos, foot, sound, volume, rf )
        if ply:GetGroundEntity() ~= NULL then
            ply._PreviousGroundEnt = ply:GetGroundEntity()
        end

        if ply._PreviousGroundEnt and IsValid(ply._PreviousGroundEnt) and ply._PreviousGroundEnt:GetClass() == "projected_wall_entity" then 
            ply:EmitSound("Lightbridge.Step" .. (foot and "Right" or "Left"))
            return true
        end
    end )

    net.Receive(GP2.Net.SendLoadedToServer, function(len, ply)
        local whom = net.ReadEntity()
        --GP2.Print("Player " .. tostring(whom) .. " loaded on server!")

        if whom == Entity(1) then
            GP2.VScriptMgr.CallHookFunction("OnPostSpawn", true)
        end
    end)
else
    include("gp2/paint.lua")

    include("gp2/client/hud.lua")
    include("gp2/client/vgui.lua")
    include("gp2/client/render.lua")

    hook.Add("Think", "GP2::Think", function()
        SoundManager.Think()
    end)

    gameevent.Listen( "player_activate" )
    hook.Add( "player_activate", "GP2::PlayerActivate", function( data ) 
        net.Start(GP2.Net.SendLoadedToServer)
            net.WriteEntity(LocalPlayer())
        net.SendToServer()
    end )
end