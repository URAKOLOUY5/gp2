local PotatosEnabled = "GP2::PotatosEnabled"
local PotatosMouthName = "GP2::GladosActorMouth"
local SphereMouthName = "GP2::SphereMouth"

local GladosActor = NULL

local sphereClasses = {
    ["npc_personality_core"] = true,
    ["npc_wheatley_boss"] = true,
    ["prop_dynamic"] = true,
    ["prop_physics"] = true,
    ["generic_actor"] = true
}

local potatoClasses = {
    ["generic_actor"] = true,
    ["viewmodel"] = true,
    ["predicated_viewmodel"] = true,
}

local function is_sphere(ent)
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
        if sphereClasses[class] then
            mat:SetFloat(self.ResultTo, GetGlobalFloat(SphereMouthName, 1))
        -- For potato
        else
            if not GetGlobalBool(PotatosEnabled, true ) then
                mat:SetFloat(self.ResultTo, 0)
            else
                mat:SetFloat(self.ResultTo, 0.2 + GetGlobalFloat(PotatosMouthName, 1) * 0.5)
            end
        end
   end 
} )