-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Manages sounds and closecaptions
-- ----------------------------------------------------------------------------

SoundManager = {}

local function AddSoundOverrides()
    local fls = file.Find("data_static/sounds/*.txt", "GAME")

    for _, fl in ipairs(fls) do
        sound.AddSoundOverrides("data_static/sounds/" .. fl)
    end
end

if SERVER then
    function SoundManager.Initialize()
        AddSoundOverrides()
    end

    function SoundManager.Think()
    end
    
    function SoundManager.EntityEmitSound(name, ent, level, pos, duration)
        net.Start(GP2.Net.SendEmitSound)
            net.WriteString(name)
            net.WriteFloat(duration)
        net.Broadcast()
    end
else
    local tokens = {}
    local cc_lang = GetConVar("cc_lang")
    local languageName = ""

    local availableLanguages = {}

    local function emitCaption(name, duration)
        local token = tokens[name:lower()]
        duration = duration * 4.414815018085938 -- idk it works, for some reasons duration produces strange values?
        if token then 
            gui.AddCaption(token, duration)
        end
    end

    local function precacheClosecaptionFiles()
        local fls = file.Find("data_static/subtitles_*.txt", "GAME")

        availableLanguages = {}
        for i, name in ipairs(fls) do
            if name:StartsWith('subtitles_') and name:EndsWith('.txt') then
                availableLanguages[name:Replace('subtitles_', ''):Replace(".txt")] = true
            end
        end
    end

    local function precacheClosecaptions()
        local fl = file.Read("data_static/subtitles_" .. languageName .. ".txt", "GAME")

        if not (fl and availableLanguages[languageName]) then
            if not availableLanguages['english'] then
                GP2.Error("Closecaptions for language " .. languageName .. " haven't been added to cache, english as fallback language cannot be used!")
                return
            else
                GP2.Error("Closecaptions for language " .. languageName .. " haven't been added to cache, instead english will be used") 
                fl = file.Read("data_static/subtitles_english.txt", "GAME")
            end
        end

        local data = util.KeyValuesToTable(fl, true, false)
        tokens = data['tokens']
    end

    function SoundManager.Initialize()
        AddSoundOverrides()
    end

    function SoundManager.Think()
        if languageName ~= cc_lang:GetString() then
            languageName = cc_lang:GetString()
            GP2.Print("Current language for closecaptions is " .. languageName)
            precacheClosecaptionFiles()
            precacheClosecaptions()
        end
    end
    
    function SoundManager.EntityEmitSound(name, ent, level, pos, duration)
        emitCaption(name, duration)
    end
    
    net.Receive(GP2.Net.SendEmitSound, function(len, ply)
        local name = net.ReadString()
        local duration = net.ReadFloat()
        emitCaption(name, duration)
    end)  
end

hook.Add("EntityEmitSound", "GP2::EntityEmitSound", function(data)
    local name = data.OriginalSoundName
    local level = data.SoundLevel
    local ent = data.Entity
    local pos = data.Pos
    local duration = SoundDuration(data.SoundName)

    SoundManager.EntityEmitSound(name, ent, level, pos, duration)
end)
