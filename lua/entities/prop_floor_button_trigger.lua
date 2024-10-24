-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Trigger for floor buttons
-- ----------------------------------------------------------------------------

ENT.Type = "brush"
ENT.Base = "base_brush"
ENT.TouchingEnts = {}
ENT.Button = NULL
ENT.IsPressed = false

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

function ENT:Think()
    for i = #self.TouchingEnts, 1, -1 do
        local ent = self.TouchingEnts[i]

        if not IsValid(ent) then
            table.remove(self.TouchingEnts, i)
        end
    end

    if #self.TouchingEnts == 0 and self.IsPressed and IsValid(self.Button) then
        self.Button:PressOut()
        self.IsPressed = false
    end
end

function ENT:StartTouch(ent)
    if IsValid(self.Button) and BUTTON_VALID_ENTS[ent:GetClass()] 
    and isfunction(self.Button.IsButton) and self.Button:IsButton() then
        table.insert(self.TouchingEnts, ent)
        self.Button:Press()

        if ent:GetClass() == "prop_weighted_cube" then
            ent:SetActivated(true)
        end

        if ent:GetClass() == "prop_monster_box" then
            ent:BecomeBox()
        end

        self.IsPressed = true
    end
end

function ENT:EndTouch(ent)
    table.RemoveByValue(self.TouchingEnts, ent)

    if ent:GetClass() == "prop_weighted_cube" then
        ent:SetActivated(false)
    end

    if ent:GetClass() == "prop_monster_box" then
        ent:BecomeMonster()
    end
end