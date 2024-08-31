-- ----------------------------------------------------------------------------
-- GP2 Framework
-- VGuiPanels
-- ----------------------------------------------------------------------------

-------------------------------
-- indicator_panel
-------------------------------

PropIndicatorPanel = PropIndicatorPanel or {}
PropIndicatorPanel.Panels = PropIndicatorPanel.Panels or {}
PropIndicatorPanel.Panelslookup = PropIndicatorPanel.Panelslookup or {}

local vgui_indicator_checked = Material("vgui/signage/vgui_indicator_checked")
local vgui_indicator_unchecked = Material("vgui/signage/vgui_indicator_unchecked")

local anglesFixup = Angle(0,90,90)
local PANEL_SIZE = 32

local floor = math.floor
local min = math.min
local rand = math.Rand

function PropIndicatorPanel.AddPanel(panel)
    if panel:GetClass() ~= "prop_indicator_panel" then
        return
    end

    PropIndicatorPanel.Panels[#PropIndicatorPanel.Panels + 1] = panel
    PropIndicatorPanel.Panelslookup[panel] = #PropIndicatorPanel.Panels -- save index
end

function PropIndicatorPanel.RemovePanel(panel)
    local paneltoremove = PropIndicatorPanel.Panels[PropIndicatorPanel.Panelslookup[panel]]

    if paneltoremove and IsValid(paneltoremove) then
        PropIndicatorPanel.Panels[PropIndicatorPanel.Panelslookup[panel]] = nil 
    end
end

function PropIndicatorPanel.Render()
    for i = 1, #PropIndicatorPanel.Panels do
        local panel = PropIndicatorPanel.Panels[i]
        if not IsValid(panel) then continue end

        local pos = panel:GetPos() + panel:GetAngles():Up() * PANEL_SIZE * 0.5 + panel:GetAngles():Right() * PANEL_SIZE * 0.5 - panel:GetAngles():Forward() * 1
        local ang = panel:GetAngles() + anglesFixup

        cam.Start3D2D(pos, ang, 1)
            surface.SetDrawColor(255,255,255)
            surface.SetMaterial(panel:GetIsChecked() and vgui_indicator_checked or vgui_indicator_unchecked)
            surface.DrawTexturedRect(0,0,PANEL_SIZE,PANEL_SIZE)
        cam.End3D2D()
    end
end

-------------------------------
-- movie_display
-------------------------------

VguiMovieDisplay = VguiMovieDisplay or {}

VguiMovieDisplay.PrecachedMovies = VguiMovieDisplay.PrecachedMovies or {}
VguiMovieDisplay.MovieGroups = VguiMovieDisplay.MovieGroups or {}
VguiMovieDisplay.MasterSlavesInGroup = VguiMovieDisplay.MasterSlavesInGroup or {}
VguiMovieDisplay.Movies = VguiMovieDisplay.Movies or {}

local elevator_video_lines = Material("vgui/elevator_video_lines.vmt")

net.Receive(GP2.Net.SendMovieDisplay, function(len, ply)
    VguiMovieDisplay.AddDisplay(net.ReadEntity())
end)

net.Receive(GP2.Net.SendRemoveMovieDisplay, function(len, ply)
    VguiMovieDisplay.RemoveDisplay(net.ReadEntity())
end)

net.Receive(GP2.Net.SendPrecacheMovie, function(len, ply)
    local movieName = net.ReadString()

    if not VguiMovieDisplay.PrecachedMovies[movieName] and file.Exists("materials/" .. movieName .. ".vmt", "GAME") then
        VguiMovieDisplay.PrecachedMovies[movieName] = Material(movieName .. ".vmt")
    end
end)

function VguiMovieDisplay.AddDisplay(display)
    if display:GetClass() ~= "vgui_movie_display" then return end
    if not display:GetActive() then return end

    local size = display:GetSize()
    local width = size.x
    local height = size.y

    local movieName = display:GetMovie()
    VguiMovieDisplay.PrecachedMovies[movieName] = VguiMovieDisplay.PrecachedMovies[movieName] or nil

    if not VguiMovieDisplay.PrecachedMovies[movieName] and file.Exists("materials/" .. movieName .. ".vmt", "GAME") then
        VguiMovieDisplay.PrecachedMovies[movieName] = Material(movieName .. ".vmt")
    end

    if not VguiMovieDisplay.PrecachedMovies[movieName] then
        return
    end
    
    local textureWidth = VguiMovieDisplay.PrecachedMovies[movieName]:GetTexture("$basetexture"):GetMappingWidth()
    local textureHeight = VguiMovieDisplay.PrecachedMovies[movieName]:GetTexture("$basetexture"):GetMappingHeight()

    local groupName = display:GetGroupName()
    VguiMovieDisplay.MovieGroups[groupName] = VguiMovieDisplay.MovieGroups[groupName] or {
        movieName = movieName,
        rt = GetRenderTargetEx("_rt_moviedisplay_group_" .. groupName, textureWidth, textureHeight, RT_SIZE_DEFAULT, MATERIAL_RT_DEPTH_SHARED, 32768, CREATERENDERTARGETFLAGS_HDR, IMAGE_FORMAT_BGRA8888),
        mat = CreateMaterial("rt_moviedisplay_group_" .. groupName, "UnlitGeneric", {
            ["$basetexture"] = "_rt_moviedisplay_group_" .. groupName
        }),
        width = textureWidth,
        height = textureHeight,
    }

    VguiMovieDisplay.Movies[display] = true
end

function VguiMovieDisplay.CaptureVideos()
    -- Render target per group
    for group, data in pairs(VguiMovieDisplay.MovieGroups) do
        local movie = VguiMovieDisplay.PrecachedMovies[data.movieName]
        local looping = data.looping
        local width = data.width
        local height = data.height

        --GP2.Print("Rendering movie " .. data.movieName)

        render.PushRenderTarget(data.rt)
            cam.Start2D()
                surface.SetDrawColor(255,255,255)
                surface.SetMaterial(movie)
                surface.DrawTexturedRect(0,0,width,height)

                surface.SetDrawColor(0,0,0,196) -- darken it a bit
                surface.DrawRect(0,0,width,height)
            cam.End2D()

        render.PopRenderTarget()        
    end
end

function VguiMovieDisplay.Render()
    for display in pairs(VguiMovieDisplay.Movies) do
        if not IsValid(display) then
            VguiMovieDisplay.Movies[display] = nil
            continue
        end
        if not display:GetActive() then return end

        local pos = display:GetPos()
        local ang = display:GetAngles()

        local size = display:GetSize()
        local width, height = size.x, size.y

        local mat = VguiMovieDisplay.MovieGroups[display:GetGroupName()].mat

        cam.Start3D2D(pos + ang:Up() * height, ang + anglesFixup, 1)
            --render.ClearDepth(true)
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(mat)
            surface.DrawTexturedRectUV(0, 0, width, height, display:GetUMin(), display:GetVMin(), display:GetUMax(), display:GetVMax())

            surface.SetDrawColor(100,100,100,255)
            surface.SetMaterial(elevator_video_lines)
            surface.DrawTexturedRect(0,0, width, height)
        cam.End3D2D()
    end
end

function VguiMovieDisplay.RemoveDisplay(display)
    VguiMovieDisplay.Movies[display] = nil
end

hook.Add("RenderScene", "GP2::RenderScene", function()
    VguiMovieDisplay.CaptureVideos() -- FIXME: just decided to place it there
end)

-------------------------------
-- sp_progress_sign
-------------------------------

VguiSPProgressSign = VguiSPProgressSign or {}
VguiSPProgressSign.Signs = VguiSPProgressSign.Signs or {}

local vgui_coop_progress_board = Material("vgui/screens/vgui_coop_progress_board.vmt")
local vgui_coop_progress_board_numbers = Material("vgui/screens/vgui_coop_progress_board_numbers.vmt")
local vgui_coop_progress_board_bar = Material("vgui/screens/vgui_coop_progress_board_bar.vmt")
local p2_lightboard_vgui = Material("vgui/screens/p2_lightboard_vgui.vmt")

local elevatorVideoOverlays = {
    [1] = Material("vgui/elevator_video_overlay1.vmt"), 
    [2] = Material("vgui/elevator_video_overlay2.vmt"), 
    [3] = Material("vgui/elevator_video_overlay3.vmt"), 
}

local SIGN_WIDTH = 94
local SIGN_HEIGHT = 190

local color_black = Color(0,0,0,255)

local startupSequences = {
    ["normal_flicker"] = {
        flicker_rate_min = 0.2,
        flicker_rate_max = 0.65,
        flicker_quick_min = 0.02,
        flicker_quick_max = 0.12,
        bg_flicker_length = 0.75,
        level_number_delay = 0.80,
        icon_delay = 1.0,
        progress_delay = 1.65,
    },
    ["dirty_flicker"] = {
        flicker_rate_min = 0.2,
        flicker_rate_max = 0.65,
        flicker_quick_min = 0.02,
        flicker_quick_max = 0.12,
        bg_flicker_length = 0.75,
        level_number_delay = 0.80,
        icon_delay = 1.0,
        progress_delay = 1.65,
    },
    ["broken_flicker"] = {
        flicker_rate_min = 0.5,
        flicker_rate_max = 0.8,
        flicker_quick_min = 0.1,
        flicker_quick_max = 0.5,
        bg_flicker_length = 5.00,
        level_number_delay = 4.5,
        icon_delay = 3.0,
        progress_delay = 2.8,
    },
}

-- x, y, w, h
local numbersSheet = {
    [0] = {0, 0, 170, 512},
    [1] = {171, 0, 170, 512},
    [2] = {341, 0, 170, 512},
    [3] = {512, 0, 170, 512},
    [4] = {683, 0, 170, 512},
    [5] = {853, 0, 170, 512},
    [6] = {0, 512, 170, 512},
    [7] = {171, 512, 170, 512},
    [8] = {341, 512, 170, 512},
    [9] = {512, 512, 170, 512},
}

local ICON_TO_NUMBER = {
    ["cube_drop"] = 1,
    ["cube_button"] = 2,
    ["cube_bonk"] = 3,
    ["drink_water"] = 4,
    ["goop"] = 5,
    ["crushers"] = 6,
    ["laser_cube"] = 7,
    ["turret"] = 8,
    ["turret_burn"] = 9,
    ["portal_fling"] = 10,
    ["plate_fling"] = 11,
    ["bridges"] = 12,
    ["bridge_block"] = 13,
    ["grinders"] = 14,
    ["tbeams"] = 15,
    ["paint_bounce"] = 16,
    ["paint_speed"] = 17,
    ["handoff"] = 18,
    ["button_stand"] = 19,
    ["laser_power"] = 20,
    ["portal_fling_2"] = 21,
    ["tbeam_polarity"] = 22,
    ["danger_field"] = 23
}

local function DrawNumber(number, x, y, rW, rH)
    local partWidth = 171
    local partHeight = 512

    local uvWidth = partWidth / 1024
    local uvHeight = partHeight / 1024

    local numberData = numbersSheet[number]

    local u0 = numberData[1] / 1024
    local v0 = numberData[2] / 1024
    local u1 = u0 + uvWidth
    local v1 = v0 + uvHeight

    surface.SetMaterial(vgui_coop_progress_board_numbers)
    surface.DrawTexturedRectUV(x, y, rW, rH, u0, v0, u1, v1)
end

local function DrawIcon(icon, x, y, w, h, state)
    local iconWidth = 204
    local iconHeight = 204

    local uvWidth = iconWidth / 1024
    local uvHeight = iconHeight / 1024

    local adjustedIndex = icon - 1

    local column = adjustedIndex % 5
    local row = floor(adjustedIndex / 5)

    local u0 = column * uvWidth + 2 / 1024
    local v0 = row * uvHeight + 2 / 1024
    local u1 = u0 + uvWidth
    local v1 = v0 + uvHeight

    local clr = state and 255 or 128
    surface.SetDrawColor(0,0,0,clr)
    surface.SetMaterial(p2_lightboard_vgui)
    surface.DrawTexturedRectUV(x, y, w, h, u0, v0, u1, v1)
end

local anglesFixup = Angle(0,0,0)

local function scaledText(text, font, x, y, scale)
    render.PushFilterMag(TEXFILTER.ANISOTROPIC)
    render.PushFilterMin(TEXFILTER.ANISOTROPIC)

    local m = Matrix()
    m:Translate(Vector(x, y, 0))
    m:Scale(Vector(scale, scale, 1))

    surface.SetFont(font)
    cam.PushModelMatrix(m, true)
        draw.DrawText(text, "CoopLevelProgressFont_Small", 0, 0, color_black)
    cam.PopModelMatrix()

    render.PopFilterMag()
    render.PopFilterMin()
end

net.Receive(GP2.Net.SendProgressSignDisplay, function(len, ply)
    VguiSPProgressSign.AddSign(net.ReadEntity())
end)

net.Receive(GP2.Net.SendRemoveProgressSignDisplay, function(len, ply)
    VguiSPProgressSign.AddSign(net.ReadEntity())
end)

function VguiSPProgressSign.AddSign(sign)
    if not IsValid(sign) then return end
    if sign:GetClass() ~= "vgui_sp_progress_sign" then return end

    VguiSPProgressSign.Signs[sign] = true
end

function VguiSPProgressSign.Render()
    for sign in pairs(VguiSPProgressSign.Signs) do
        if not IsValid(sign) then
            VguiSPProgressSign.Signs[sign] = nil
            continue
        end

        if not sign:GetActive() then
            return
        end

        local pos = sign:GetPos()
        local ang = sign:GetAngles() + anglesFixup

        local activeTime = CurTime() - sign:GetStartupTime()
        local sequence = startupSequences[sign:GetStartupSequence()]

        sign.nextFlickerTime = sign.nextFlickerTime or CurTime()
        sign.isDarkened = sign.isDarkened or false

        -- it's definitely not same as P2 
        if activeTime < sequence.bg_flicker_length then
            if CurTime() >= sign.nextFlickerTime then
                sign.isDarkened = not sign.isDarkened
                if sign.isDarkened then
                    sign.nextFlickerTime = CurTime() + rand(sequence.flicker_rate_min, sequence.flicker_rate_max)
                else
                    sign.nextFlickerTime = CurTime() + rand(sequence.flicker_quick_min, sequence.flicker_quick_max)
                end
            end
        else
            sign.isDarkened = false
        end

        cam.Start3D2D(pos - ang:Right() * SIGN_HEIGHT, ang, 1)
            surface.SetMaterial(vgui_coop_progress_board)
            local clr = sign.isDarkened and 32 or (activeTime < sequence.bg_flicker_length and 96 or 114)
            surface.SetDrawColor(clr, clr, clr, 255)
            surface.DrawTexturedRect(0, 0, SIGN_WIDTH, SIGN_HEIGHT)

            local levelNumber = min(sign:GetLevelNumber(), 99)
            local totalLevels = min(sign:GetTotalLevels(), 99)

            local percentage = levelNumber / totalLevels

            local numbers = tostring(levelNumber)
            local totalNumbers = tostring(totalLevels)
            local digits = {}
            local digitsTotal = {}

            -- Show big numbers
            if activeTime > sequence.level_number_delay then
                surface.SetMaterial(vgui_coop_progress_board_numbers)
                
                if #numbers == 1 then
                    digits[1] = 0
                    digits[2] = tonumber(numbers)
                elseif #numbers == 2 then
                    digits[1] = tonumber(string.sub(numbers, 1, 1))
                    digits[2] = tonumber(string.sub(numbers, 2, 2))
                else
                    digits[1] = tonumber(string.sub(numbers, 1, #numbers-1))
                    digits[2] = tonumber(string.sub(numbers, #numbers, #numbers))
                end

                DrawNumber(digits[1], 18, 20, 25, 75)
                DrawNumber(digits[2], 45, 20, 25, 75)
            end

            -- Show progress bar
            if activeTime > sequence.progress_delay then
                if #totalNumbers == 1 then
                    digitsTotal[1] = 0
                    digitsTotal[2] = tonumber(totalNumbers)
                elseif #totalNumbers == 2 then
                    digitsTotal[1] = tonumber(string.sub(totalNumbers, 1, 1))
                    digitsTotal[2] = tonumber(string.sub(totalNumbers, 2, 2))
                else
                    digitsTotal[1] = tonumber(string.sub(totalNumbers, 1, #totalNumbers-1))
                    digitsTotal[2] = tonumber(string.sub(totalNumbers, #totalNumbers, #totalNumbers))
                end

                scaledText(digits[1] .. digits[2] .. '/' .. digitsTotal[1] .. digitsTotal[2], "CoopLevelProgressFont_Small", 19, 99, 0.25)

                local progressBarWidth = 72 * percentage

                surface.SetMaterial(vgui_coop_progress_board_bar)
                surface.DrawTexturedRectUV(19, 109, progressBarWidth, 8, 0, 0, progressBarWidth / 10, 1)
            end

            if not sign.Icons then
                local icons = sign:GetIcons():Split(",")
                table.remove(icons, 1)
                sign.Icons = {}

                for _, icon in ipairs(icons) do
                    local data = icon:Split("|")

                    sign.Icons[#sign.Icons + 1] = {data[1], tobool(data[2])}
                end
            end

            -- Show icons
            if activeTime > sequence.icon_delay then
                local i = 1
                for _, icon in pairs(sign.Icons) do
                    local iconName = icon[1]
                    local state = icon[2]
                    local icon2integer = ICON_TO_NUMBER[iconName]

                    local x = 19 + 15 * ((i - 1) % 5)
                    local y = i <= 5 and 136 or 150 
                    DrawIcon(icon2integer, x, y, 12, 12, state)
                    i = i + 1
                end
            end

            local dirt = sign:GetDirt()
            if dirt > 0 and dirt < 4 then
                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(elevatorVideoOverlays[dirt + 1])
                surface.DrawTexturedRect(0, 0, SIGN_WIDTH, SIGN_HEIGHT)
            end
        cam.End3D2D()
    end
end

function VguiSPProgressSign.RemoveDisplay(sign)
    VguiSPProgressSign.Signs[sign] = nil
end