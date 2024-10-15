local PotatosEnabled = "GP2::PotatosEnabled"
local PotatosMouthName = "GP2::GladosActorMouth"
local SphereMouthName = "GP2::SphereMouth"

local GladosActor = NULL

local sphereClasses = {
    ["npc_personality_core"] = true,
    ["npc_wheatley_boss"] = true
}

local potatoClasses = {
    ["generic_actor"] = true,
    ["prop_dynamic"] = true,
    ["prop_physics"] = true,
    ["viewmodel"] = true,
    ["predicted_viewmodel"] = true,
}

local potatoClasses = {
    ["viewmodel"] = true,
    ["predicted_viewmodel"] = true,
}

local potatoModels = {
    ["models/npcs/potatos/world_model/potatos_wmodel.mdl"] = true
}

local sphereBossModels = {
    ["models/npcs/glados/glados_wheatley.mdl"] = true,
    ["models/npcs/glados/glados_wheatley_boss.mdl"] = true,
    ["models/npcs/glados/glados_wheatley_boss_screen.mdl"] = true,
    ["models/npcs/glados/glados_wheatley_newbody.mdl"] = true
}

local function is_sphere(ent)
    return (sphereClasses[ent:GetClass()] or sphereBossModels[ent:GetModel()]) or (ent:GetClass() == "generic_actor" and ent:GetName() == "@sphere")
end

local function is_potatos(ent)
    return potatoClasses[ent:GetClass()] or potatoModels[ent:GetModel()]
end

matproxy.Add( {
    name = "LightedMouth", 
    init = function( self, mat, values )
        -- Store the name of the variable we want to set
        self.ResultTo = values.resultvar
    end,
    bind = function( self, mat, ent )
        local flashResult = 1
        local class = ent:GetClass()

        -- For wheatley
        if is_sphere(ent) then
            mat:SetFloat(self.ResultTo, 1 - GetGlobalFloat(SphereMouthName, 0))
        -- For potato
        elseif is_potatos(ent) then
            if not GetGlobalBool(PotatosEnabled, true ) then
                mat:SetFloat(self.ResultTo, 0)
            else
                mat:SetFloat(self.ResultTo, 0.1 + GetGlobalFloat(PotatosMouthName, 1) * 0.5)
            end
        end
   end 
} )