-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Mark/timer
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "point"

function ENT:SetupDataTables()
    self:NetworkVar( "Float", "TimerDuration" )
    self:NetworkVar( "Bool", "Enabled" )
    self:NetworkVar( "Bool", "IsTimer" )
    self:NetworkVar( "Bool", "IsChecked" )
    self:NetworkVar( "String", "IndicatorLights" )
end

function ENT:Initialize()
    if CLIENT then
        PropIndicatorPanel.AddPanel(self)
    else
        self.TextureFrameToggle = ents.Create("env_texturetoggle")
        self.TextureFrameToggle:SetKeyValue("target", self:GetIndicatorLights(v))
    end
end

function ENT:OnRemove()
    if CLIENT then
        timer.Simple( 0, function()
            if not IsValid(self) then
                if IsValid(self.TextureFrameToggle) then
                    self.TextureFrameToggle:Remove()
                end

                PropIndicatorPanel.RemovePanel(self)
            end
        end)
    end
end

function ENT:UpdateTransmitState() return TRANSMIT_PVS end

if SERVER then
    function ENT:KeyValue(k, v)
        if k == "TimerDuration" then
            self:SetTimerDuration(tonumber(v))
        elseif k == "Enabled" then
            self:SetEnabled(tobool(v))
        elseif k == "IsChecked" then
            self:SetIsChecked(tobool(v))
        elseif k == "IndicatorLights" then
            self:SetIndicatorLights(v)
        end
    
        if k:StartsWith("On") then
            self:StoreOutput(k, v)
        end
    end

    ENT.__input2func = {
        ["check"] = function(self, activator, caller, data)
            if self:GetIsChecked() then return end

            self:Check(true)
        end,
        ["uncheck"] = function(self, activator, caller, data)
            if not self:GetIsChecked() then return end

            self:Check(false)
        end,
    }

    function ENT:AcceptInput(name, activator, caller, data)
        name = name:lower()
        local func = self.__input2func[name]
    
        if func and isfunction(func) then
            func(self, activator, caller, data)
        end
    end

    function ENT:Check(state)
        self:SetIsChecked(state)
        
        if IsValid(self.TextureFrameToggle) then
            self.TextureFrameToggle:Input("SetTextureIndex", nil, nil, state and "1" or "0")
        end
    end
end