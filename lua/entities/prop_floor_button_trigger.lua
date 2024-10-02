-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Trigger for floor buttons
-- ----------------------------------------------------------------------------

ENT.Type = "brush"
ENT.Base = "base_brush"
ENT.TouchingEnts = 0
ENT.Button = NULL

local BUTTON_VALID_ENTS = {
    ["player"] = true,
    ["prop_weighted_cube"] = true,
    ["prop_monster_box"] = true,
}

function ENT:Initialize()
    self:SetSolid(SOLID_BBOX)
    self:SetTrigger(true)
end

function ENT:SetButton(btn)
    self.Button = btn
end

function ENT:StartTouch(ent)
    if IsValid(self.Button) and BUTTON_VALID_ENTS[ent:GetClass()] 
    and isfunction(self.Button.IsButton) and self.Button:IsButton() then
        self.TouchingEnts = self.TouchingEnts + 1
        self.Button:Press()

        if ent:GetClass() == "prop_weighted_cube" then
            ent:SetActivated(true)
        end
    end
end

function ENT:EndTouch(ent)
    self.TouchingEnts = self.TouchingEnts - 1

    if ent:GetClass() == "prop_weighted_cube" then
        ent:SetActivated(false)
    end

    if self.TouchingEnts == 0 then
        if IsValid(self.Button) then
            self.Button:PressOut()
        end
    end
end