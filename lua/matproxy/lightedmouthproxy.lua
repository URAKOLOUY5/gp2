local PotatosEnabled = "GP2::PotatosEnabled"
local PotatosMouth = "GP2::GladosActorMouth"

local GladosActor = NULL

matproxy.Add( {
    name = "LightedMouth", 
    init = function( self, mat, values )
        -- Store the name of the variable we want to set
        self.ResultTo = values.resultvar
    end,
    bind = function( self, mat, ent )
        local flashResult = 1

        if not GetGlobalBool(PotatosEnabled, true ) then
            mat:SetFloat(self.ResultTo, 0)
        else
            mat:SetFloat(self.ResultTo, 0.2 + GetGlobalFloat(PotatosMouth) * 0.5)
        end   
   end 
} )