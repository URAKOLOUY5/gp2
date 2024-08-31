-- ----------------------------------------------------------------------------
-- GP2
-- Aperture Button (floor)
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"
ENT.AutomaticFrameAdvance = true

local DEFAULT_BUTTON_MODEL = "models/props/portal_button.mdl"
local TRIGGER_MINS = Vector(-20,-20,0)
local TRIGGER_MAXS = Vector(20,20,18)
local DEBUG_PRESSED_COLOR = Color(90,200,90,16)
local DEBUG_UNPRESSED_COLOR = Color(200,90,90,16)

local developer = GetConVar("developer")

if SERVER then
    ENT.Pressed = false
    ENT.ButtonTrigger = NULL

    function ENT:Initialize()
        if not self:GetModel() then
            self:SetModel(DEFAULT_BUTTON_MODEL)
        end

        self:SetMoveType(MOVETYPE_NONE)

        self:CreateBoneFollowers()
        self.SequenceDown = self:LookupSequence("down")
        self.SequenceUp = self:LookupSequence("up")

        self.ButtonTrigger = ents.Create("prop_floor_button_trigger")
        self.ButtonTrigger:Spawn()
        self.ButtonTrigger:SetPos(self:GetPos())
        self.ButtonTrigger:SetParent(self)
        self.ButtonTrigger:SetButton(self)
        self.ButtonTrigger:SetCollisionBounds(TRIGGER_MINS, TRIGGER_MAXS)
    end
    
    function ENT:KeyValue(k, v)
        if k == "skin" then
            self:SetSkin(tonumber(v))
        elseif k == "model" then
            self:SetModel(v)
        end

        if k:StartsWith("On") then
            self:StoreOutput(k, v)
        end
    end

    ENT.__input2func = {
        ["pressin"] = function(self, activator, caller, data)
            self:Press()
        end,
        ["pressout"] = function(self, activator, caller, data)
            self:PressOut()
        end
    }

    function ENT:AcceptInput(name, activator, caller, data)
        name = name:lower()
        local func = self.__input2func[name]
    
        if func and isfunction(func) then
            func(self, activator, caller, data)
        end
    end

    function ENT:Press()
        if self.Pressed then return end

        self.Pressed = true
        self:SetSkin(1)
        self:ResetSequence(self.SequenceDown)
        self:TriggerOutput("OnPressed")
    end

    function ENT:PressOut()
        if not self.Pressed then return end

        self.Pressed = false
        self:SetSkin(0)
        self:ResetSequence(self.SequenceUp)
        self:TriggerOutput("OnUnPressed")
    end

    function ENT:Think()
        self:UpdateBoneFollowers()

        if developer:GetBool() then
            debugoverlay.Box(self:GetPos(), TRIGGER_MINS, TRIGGER_MAXS, 0.1, self.Pressed and DEBUG_PRESSED_COLOR or DEBUG_UNPRESSED_COLOR)
        end

        self:NextThink(CurTime())
        return true
    end

    function ENT:IsButton()
        return true
    end

    function ENT:OnRemove()
        self:DestroyBoneFollowers()

        if IsValid(self.ButtonTrigger) then
            self.ButtonTrigger:Remove()
        end
    end
end