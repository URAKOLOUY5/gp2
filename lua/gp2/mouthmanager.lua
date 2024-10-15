-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Fake mouth manager
-- ----------------------------------------------------------------------------

MouthManager = {}

-- Actor list is built by [entity] -> [sound]
local lipsyncData = {}
local actors = {}
local specialCharsRegex = "[*#@><^)}!?&~+%$%%%(%%-]"
local NWVAR_MOUTH = "NWVAR_MOUTH"

local ADVANCE_DELAY = 1 / (16 + 2)

local PotatosMouth = 1
local SphereMouth = 1

local PotatosMouthName = "GP2::GladosActorMouth"
local SphereMouthName = "GP2::SphereMouth"

local sphereClasses = {
    ["npc_personality_core"] = true,
    ["npc_wheatley_boss"] = true,
    ["generic_actor"] = true
}

local potatoClasses = {
    ["generic_actor"] = true
}

local potatoNames = {
    ["@glados"] = true,
    ["@actor_potatos"] = true,
}

local function is_sphere(ent)
    return sphereClasses[ent:GetClass()] and not potatoNames[ent:GetName()]
end

local function is_potatos(ent)
    return potatoClasses[ent:GetClass()] and potatoNames[ent:GetName()]
end

function MouthManager.Initialize()
    local lipsyncs = {}
    
    local function findFilesInDirectory(directory)
        local files, dirs = file.Find(directory .. "/*", "GAME")
        
        for _, fileName in ipairs(files) do
            if not fileName:StartsWith("_lipsync_") then continue end
            table.insert(lipsyncs, directory .. "/" .. fileName)
        end
        
        for _, subDir in ipairs(dirs) do
            findFilesInDirectory(directory .. "/" .. subDir)
        end
    end

    findFilesInDirectory("sound/vo")

    for _, lipsync in ipairs(lipsyncs) do
        local content = file.Read(lipsync, "GAME")
        local relativePath = string.gsub(lipsync, "^sound/", "")
        relativePath = string.gsub(relativePath, "_lipsync_", ""):lower()

        local data = CompileString(content, "LIPSYNC DATA ", true)()

        print('Added [ "' .. relativePath .. '"] = ' .. tostring(#data))
        lipsyncData[relativePath] = data
    end
end

local function removeSpecialCharacters(filePath)
    return filePath:gsub(specialCharsRegex, '')
end

function MouthManager.EmitSound(actor, soundFile)
    soundFile = removeSpecialCharacters(soundFile):lower()
    
    if not lipsyncData[soundFile] then return end

    GP2.Print("Mouth emitted " .. soundFile .. ' on target ' .. tostring(actor))

    actors[actor] = { marker = 0, value = 1, soundFile = soundFile, nextAdvanceTime = CurTime() }    
end

function MouthManager.Think()
    for actor, data in pairs(actors) do
        if not actors[actor] then continue end

        local class = actor:GetClass()

        local marker = data.marker
        local soundFile = data.soundFile
        local nextAdvanceTime = data.nextAdvanceTime

        local lpData = lipsyncData[soundFile]

        if CurTime() > nextAdvanceTime then
            marker = marker + 1

            if marker > #lpData then
                actors[actor] = nil
                continue
            end 

            data.marker = marker
            data.nextAdvanceTime = CurTime() + ADVANCE_DELAY

            -- Wheatley
            if is_sphere(actor) then
                SphereMouth = math.max(lpData[marker], 0.5)
                --print('Mouth for sphere updated to ' .. SphereMouth)
            elseif is_potatos(actor) then
                PotatosMouth = math.max(lpData[marker], 0.1)
                --print('Mouth for potatos updated to ' .. PotatosMouth)
            end
        end
    end

    PotatosMouth = math.Approach(PotatosMouth, 0.1, 0.03)
    SphereMouth = math.Approach(SphereMouth, 0, 0.03)
    SetGlobalFloat(PotatosMouthName, PotatosMouth)
    SetGlobalFloat(SphereMouthName, SphereMouth)
end