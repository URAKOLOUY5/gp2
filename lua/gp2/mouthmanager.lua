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

local ADVANCE_DELAY = 1 / 16

local GladosMouth = 1

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
        relativePath = string.gsub(relativePath, "_lipsync_", "")

        local data = CompileString(content, "LIPSYNC DATA ", true)()

        print('Added [ "' .. relativePath .. '"] = ' .. tostring(#data))
        lipsyncData[relativePath] = data
    end
end

local function removeSpecialCharacters(filePath)
    return filePath:gsub(specialCharsRegex, '')
end

function MouthManager.EmitSound(actor, soundFile)
    soundFile = removeSpecialCharacters(soundFile)

    GP2.Print("Mouth emitted " .. soundFile .. ' on target ' .. tostring(actor))
    
    if not lipsyncData[soundFile] then return end

    actors[actor] = { marker = 0, value = 1, soundFile = soundFile, nextAdvanceTime = CurTime() }    
end

function MouthManager.Think()
    for actor, data in pairs(actors) do
        if not actors[actor] then continue end

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

            GladosMouth = math.max(lpData[marker], 0.1)
            GP2.Print("Updating MOUTH to " .. lpData[marker] .. " value")
            data.nextAdvanceTime = CurTime() + ADVANCE_DELAY
        end
    end

    GladosMouth = math.Approach(GladosMouth, 0, 0.03)
    SetGlobalFloat("GP2::GladosActorMouth", GladosMouth)
end