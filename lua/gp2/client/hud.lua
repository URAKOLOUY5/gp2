-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Head-up-Display
-- ----------------------------------------------------------------------------

local renderlists = {}

local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetTextColor = surface.SetTextColor
local surface_SetTextPos = surface.SetTextPos
local surface_DrawText = surface.DrawText
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local surface_GetTextSize = surface.GetTextSize
local surface_SetFont = surface.SetFont
local max = math.max

local matGradientError = Material("hud/devui-gradient-error.png")
local matWarningIcon = Material("hud/warning.png", "smooth")

local ScrWide, ScrHeight = ScrW(), ScrH()

local function CreateFonts()
    surface.CreateFont("VscriptErrorText", {
        font = "Roboto Medium",
        size = ScrH() * 0.0148,
        antialias = true,
        extended = true
    })

    surface.CreateFont("CoopLevelProgressFont_Small", {
        font = "Univers LT Std 47 Cn Lt",
        extended = true,
        size = 28,
        weight = 600,
        antialias = true,
    })
end

CreateFonts()

GP2.Hud = {
    DeclareLegacyElement = function(func)
        renderlists[#renderlists + 1] = func
    end,
    Render = function(w, h)
        for i = 1, #renderlists do
            local func = renderlists[i]

            if func and isfunction(func) then
                func(w, h)
            end
        end
    end
}

-- Some basic GP2 elements (legacy)

local vscriptErrors = {}
local norepeat = {}

-- Vscript Errors

net.Receive(GP2.Net.SendVscriptError, function(len, ply)
    local text = net.ReadString()

    if norepeat[text] then
        norepeat[text].animAttention = 0
        norepeat[text].spawntime = CurTime()
        norepeat[text].count = (norepeat[text].count or 0) + 1
        return
    end

    local err = {
        text = text,
        dying = false,
        alpha = 0,
        spawntime = CurTime()
    }
    table.insert(vscriptErrors, 1, err)
    
    norepeat[text] = err
end)

local function RenderError(err, position)
    local boxwide = ScrHeight * 0.055
    local margin = ScrHeight * 0.04
    local padding = ScrHeight * 0.03

    local errortext = err.text

    if err.count then
        errortext = errortext .. ' (' .. err.count .. 'x)'
    end

    surface_SetFont("VscriptErrorText")
    local textwidth, textheight = surface_GetTextSize(errortext)
    
    boxwide = boxwide + textwidth + margin
    local boxheight = textheight + padding
    local iconwidth = boxheight * 0.8 

    err.animOffset = err.animOffset or 0
    err.animAttention = err.animAttention or 0
    err.baseY = err.baseY or boxheight * position - ScrHeight * 0.05
    err.baseY = math.Approach(err.baseY, boxheight * position, FrameTime() * ScrHeight * 0.5)

    if CurTime() > err.spawntime + 5 then
        err.alpha = math.Approach(err.alpha, 0, FrameTime() * 0.5)
        err.animOffset = math.Approach(err.animOffset, ScrHeight * 0.0138, FrameTime() * ScrHeight * 0.002)
    else
        err.alpha = math.Approach(err.alpha, position == 1 and 1 or 0.56, FrameTime() * 5)
        err.animAttention = math.Approach(err.animAttention, 1, FrameTime() * ScrHeight * 0.01)
    end

    err.baseY = err.baseY + err.animOffset

    surface_SetMaterial(matGradientError)
    surface_SetDrawColor(255,255 * err.animAttention,255 * err.animAttention,255 * err.alpha)
    surface_DrawTexturedRect(ScrWide - boxwide - margin, err.baseY + margin, boxwide, boxheight)

    surface_SetDrawColor(32,32,32,255 * err.alpha)
    surface_DrawOutlinedRect(ScrWide - boxwide - margin, err.baseY + margin, boxwide, boxheight, max(ScrHeight * 0.002, 1))

    surface_SetMaterial(matWarningIcon)

    surface_SetDrawColor(0,0,0,255 * err.alpha)
    surface_DrawTexturedRect(ScrWide - boxwide - margin + iconwidth / 2 + ScrHeight * 0.002, err.baseY + margin + boxheight / 2 - iconwidth / 2 + ScrHeight * 0.002, iconwidth, iconwidth)

    surface_SetDrawColor(255,100,100,255 * err.alpha)
    surface_DrawTexturedRect(ScrWide - boxwide - margin + iconwidth / 2, err.baseY + margin + boxheight / 2 - iconwidth / 2, iconwidth, iconwidth)

    surface_SetTextColor(0,0,0,255 * err.alpha)
    surface_SetTextPos(ScrWide - boxwide + iconwidth / 2 + ScrHeight * 0.002, err.baseY + margin + boxheight / 2 - textheight / 2 + ScrHeight * 0.002)
    surface_DrawText(errortext)

    surface_SetTextColor(255,100,100,255 * err.alpha)
    surface_SetTextPos(ScrWide - boxwide + iconwidth / 2, err.baseY + margin + boxheight / 2 - textheight / 2)
    surface_DrawText(errortext)  
    
    surface_SetDrawColor(255,100,100,255 * (1 - err.animAttention))
    surface_DrawOutlinedRect(
        ScrWide - boxwide - margin - (ScrHeight * 0.02 * err.animAttention) / 2, 
        err.baseY + margin - (ScrHeight * 0.02 * err.animAttention) / 2, 
        boxwide + (ScrHeight * 0.02 * err.animAttention), 
        boxheight + (ScrHeight * 0.02 * err.animAttention), 
        max(ScrHeight * 0.002, 1))
end

GP2.Hud.DeclareLegacyElement(function(scrw, scrh)
    for i = 1, #vscriptErrors do
        local err = vscriptErrors[i]

        if not err then continue end

        if CurTime() > err.spawntime + 5 and err.alpha <= 0.01 then
            err.animAttention = 1
            norepeat[err.text] = nil
            table.remove(vscriptErrors, i)
        end

        RenderError(err, i)
    end
end)

local GP2_Hud_Render = GP2.Hud.Render

hook.Add("HUDPaint", "GP2::HUDPaint", function()
    GP2_Hud_Render(ScrWide, ScrHeight)
end)

hook.Add("OnScreenSizeChanged", "GP2::OnScreenSizeChanged", function(oW, oH, w, h)
    ScrWide = w
    ScrHeight = h

    CreateFonts()
end)