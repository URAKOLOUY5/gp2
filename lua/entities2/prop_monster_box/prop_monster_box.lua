-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Franken turret
-- ----------------------------------------------------------------------------

DECLARE_ENTITY {
    "anim"

    DEFINE_FIELD("Held", false),
    DEFINE_FIELD("IsABox", false),
    DEFINE_FIELD("IsFlying", false),
    DEFINE_FIELD("IsShortcircuit", false),
    
    DEFINE_KEYFIELD("StartAsBox", false),
    DEFINE_KEYFIELD("BoxSwitchSpeed", 400),
    DEFINE_KEYFIELD("AllowSilentDissolve", true),

    DEFINE_FIELD("PushStrength", 1.0)

    DEFINE_INPUT("BecomeBox"),
    DEFINE_INPUT("BecomeMonster"),
    DEFINE_INPUT("BecomeShortcircuit"),
    DEFINE_INPUT("SilentDissolve"),
    DEFINE_INPUT("Dissolve"),

    DEFINE_OUTPUT("OnFizzled"),
}

function PropMonsterBox:Spawn()
    if self:GetStartAsBox() then
        self:SetModel("models/npcs/monsters/monster_A_box.mdl")
    else
        self:SetModel("models/npcs/monsters/monster_a.mdl")
    end
    
    self:SetSolid(SOLID_VPHYSICS)
    self:AddEffects(EF_NOFLASHLIGHT)
end