-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Portal
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "anim"

local PORTAL_VALID_ENTS = {
    ["prop_portal"] = true
}

local PORTAL1 = NULL
local PORTAL2 = NULL

PORTALTYPE_1 = 0
PORTALTYPE_2 = 1

local TEMP_MODELS = {
    [PORTALTYPE_1] = "models/portals/portal1.mdl",
    [PORTALTYPE_2] = "models/portals/portal2.mdl",
}

local PLACED_PORTAL_COLOR = Color(255,50,25,5)

local SF_INACTIVE = 1

function ENT:KeyValue(k, v)
    if k:StartsWith("On") then
        self:StoreOutput(k, v)
    end

    if k == "PortalTwo" then
        self:SetType(tonumber(v))
    end

    if k == "Activated" then
        self:SetActivated(tobool(v))
    end
end

ENT.__input2func = {
    ["setactivatedstate"] = function(self, activator, caller, data)
        self:SetState(tobool(data))

        if self:GetState() then
            local min, max = self:GetModelBounds()
            debugoverlay.BoxAngles(self:GetPos(), min, max, self:GetAngles(), 1, PLACED_PORTAL_COLOR)
        end
    end,
}

function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()
    local func = self.__input2func[name]

    if func and isfunction(func) then
        func(self, activator, caller, data)
    end
end

function ENT:SetupDataTables()
    self:NetworkVar( "Int", "Type" )
    self:NetworkVar( "Bool", "State" )
    self:NetworkVar( "Bool", "Activated" )
end

function ENT:Initialize()
    if SERVER then
        if self:GetType() == PORTALTYPE_1 then
            if IsValid(PORTAL1) then
                PORTAL1:Remove() 
            end
            PORTAL1 = self
        else
            if IsValid(PORTAL2) then
                PORTAL2:Remove() 
            end
            PORTAL2 = self
        end
    
        self:SetModel(TEMP_MODELS[self:GetType()])
        self:AddEffects(EF_NOSHADOW)
        self:SetSolid(SOLID_OBB)
        self:SetSolidFlags(FSOLID_TRIGGER + FSOLID_NOT_SOLID + FSOLID_CUSTOMBOXTEST + FSOLID_CUSTOMRAYTEST)
    else
        self.OpenAmount = 0
    end
end

function ENT:Think(ent)
end

if CLIENT then
    ENT.PORTAL_WIDTH = 64
    ENT.PORTAL_HEIGHT = 112

    local BORDER_MATERIALS = {
		[0] = Material("models/portals/portalstaticoverlay_1.vmt"),
		[1] = Material("models/portals/portalstaticoverlay_2.vmt"),
	}

    function ENT:RenderBorder()
		local angle = self:GetAngles()

        self.OpenAmount = math.Approach(self.OpenAmount, 1, FrameTime() * 2.5) 

		angle:RotateAroundAxis(angle:Up(), 90)

		cam.Start3D2D(self:GetPos() - (angle:Forward() * (self.PORTAL_WIDTH / 2)) - (angle:Right() * (self.PORTAL_HEIGHT / 2)), angle, 1)
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(BORDER_MATERIALS[self:GetType()])
			surface.DrawTexturedRect(0,0,self.PORTAL_WIDTH,self.PORTAL_HEIGHT)
            BORDER_MATERIALS[self:GetType()]:SetFloat("$PortalStatic", 1)
            BORDER_MATERIALS[self:GetType()]:SetFloat("$PortalOpenAmount", self.OpenAmount)
            BORDER_MATERIALS[self:GetType()]:SetFloat("$Stage", 2)
            BORDER_MATERIALS[self:GetType()]:SetFloat("$PortalColorScale", 0.25)
		cam.End3D2D()
	end

    function ENT:Draw(studio)
        if not self:GetActivated() then return end

        self:RenderBorder()
    end
end