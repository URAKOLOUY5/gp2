-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Progress board
-- ----------------------------------------------------------------------------

AddCSLuaFile()
ENT.Type = "point"

local function LoadLightboardIcons(sign)
    local sp_lightboard_icons_content = file.Read("data_static/sp_lightboard_icons.txt", "GAME")

    if not sp_lightboard_icons_content then
        return
    end

    local icons = util.KeyValuesToTable(sp_lightboard_icons_content, false, false)
    local iconsOrdered = util.KeyValuesToTablePreserveOrder(sp_lightboard_icons_content, false, true)
    if not icons then return end

    local maps = icons.maps
    if not maps then return end

    local level = maps[game.GetMap()]
    if not level then return end

    if level.level_number then
        sign:SetLevelNumber(tonumber(level.level_number))
    end

    if level.total_levels then
        sign:SetTotalLevels(tonumber(level.total_levels))
    end

    if level.startup then
        sign:SetStartupSequence(level.startup)
    end

    if level.dirt then
        sign:SetDirt(tonumber(level.dirt))
    end

    -- Find preserve order "icons" then
    for _, maps in ipairs(iconsOrdered) do
        for _, mapData in ipairs(maps.Value) do
            if mapData.Key ~= game.GetMap() then continue end

            for _, data in ipairs(mapData.Value) do
                if data.Key ~= "icons" then continue end

                for _, icon in ipairs(data.Value) do
                    sign:SetIcons(sign:GetIcons() .. "," .. icon.Key .. "|" .. icon.Value)
                end
            end
        end
    end
end

function ENT:SetupDataTables()
    self:NetworkVar( "String", "StartupSequence" )
    self:NetworkVar( "String", "Icons" ) -- iconname|state, iconname2|state2, ...
    self:NetworkVar( "Float", "StartupTime" )
    self:NetworkVar( "Bool", "Active" )
    self:NetworkVar( "Int", "Dirt" )
    self:NetworkVar( "Int", "LevelNumber" )
    self:NetworkVar( "Int", "TotalLevels" )
    
    if SERVER then
        self:SetStartupSequence("normal_flicker")
        self:SetStartupTime(CurTime())

        LoadLightboardIcons(self)
    end
end

function ENT:UpdateTransmitState()
    net.Start(GP2.Net.SendProgressSignDisplay)
        net.WriteEntity(self)
    net.Broadcast()

    return TRANSMIT_ALWAYS
end


function ENT:AcceptInput(name, activator, caller, data)
    name = name:lower()

    if name == "setactive" then
        self:SetActive(true)
        self:SetStartupTime(CurTime())        
    elseif name == "setinactive" then
        self:SetActive(false)
    end
end  