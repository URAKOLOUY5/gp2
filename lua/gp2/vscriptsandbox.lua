-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Sandboxed Lua for vscript
-- ----------------------------------------------------------------------------

local sandbox = {
    tonumber = tonumber,
    tostring = tostring,
    isnumber = isnumber,
    isfunction = isfunction,
	isbool = isbool,
	isstring = isstring,
	istable = istable,
    math = math,
    string = string,
    game = game,
    ents = ents,
    timer = timer,
    table = table,
    error = error,
    ipairs = ipairs,
    pairs = pairs,
    Vector = Vector,
    Angle = Angle,
    CompileString = CompileString,
    CompileFile = CompileFile,
    CurTime = CurTime,
    IsValid = IsValid,
    type = type,
	pcall = pcall,
	include = include,
    setmetatable = setmetatable,
    getmetatable = getmetatable,
    AddOriginToPVS = AddOriginToPVS,
    util = {
        PrecacheSound = util.PrecacheSound,
        PrecacheModel = util.PrecacheModel
    }
}

local SceneEntityMT = {}

function SceneEntityMT:__tostring()
	return "SceneEntity [" .. self:EntIndex() .. "][" .. self.m_szScenePath .. "]"
end

function SceneEntityMT:IsScriptSceneEntity()
    return true
end

sandbox.print = function(msg)
    MsgC(color_white, msg)
	print()
end

sandbox.PrintTable = function(t, indent, done)
    local MsgC = MsgC

	done = done or {}
	indent = indent or 0
	local keys = table.GetKeys( t )

	table.sort( keys, function( a, b )
		if ( isnumber( a ) and isnumber( b ) ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

	done[ t ] = true

	for i = 1, #keys do
		local key = keys[ i ]
		local value = t[ key ]
		key = ( type( key ) == "string" ) and "[\"" .. key .. "\"]" or "[" .. tostring( key ) .. "]"
		MsgC( color_white, string.rep( "\t", indent ) )

		if  ( istable( value ) and !done[ value ] ) then
			done[ value ] = true
			MsgC( color_white, key, ":\n" )
			PrintTable ( value, indent + 2, done )
			done[ value ] = nil
		else
			MsgC(color_white, key, "\t=\t", value, "\n" )
		end

	end
end

sandbox.CreateSceneEntity = function(path)
    local entity = ents.Create("logic_choreographed_scene")
    entity:SetKeyValue("SceneFile", path)
	entity:SetName("@sceneentity" .. entity:EntIndex())
	entity:Spawn()
	entity:Activate()
    entity:Fire('AddOutput', 'OnStart ' .. '!self,O_OnStart,,0,-1')
    entity:Fire('AddOutput', 'OnCompletion ' .. '!self,O_OnCompletion,,0,-1')
    entity:Fire('AddOutput', 'OnCanceled ' .. '!self,O_OnCanceled,,0,-1')

    local originalMT = getmetatable(entity)
    
    SceneEntityMT.__index = function(tbl, key)
        if SceneEntityMT[key] then
            return SceneEntityMT[key]
        end

        if originalMT and originalMT.__index then
            if type(originalMT.__index) == "function" then
                return originalMT.__index(tbl, key)
            else
                return originalMT.__index[key]
            end
        end
    end

    SceneEntityMT.__newindex = function(tbl, key, value)
        if originalMT and originalMT.__newindex then
            if type(originalMT.__newindex) == "function" then
                return originalMT.__newindex(tbl, key, value)
            else
                rawset(tbl, key, value)
            end
        else
            rawset(tbl, key, value)
        end
    end

    entity.m_szScenePath = path
    debug.setmetatable(entity, SceneEntityMT)
	return entity    
end

sandbox.EntFire = function(name, input, value, delay)
    value = value or ""
    delay = delay or 0.0
    
    local entities = ents.FindByName(name)

    for _, ent in ipairs(entities) do
        ent:Fire(input, value, delay)
    end
end

sandbox.EntFireByHandle = function(handle, input, value, delay)
    if IsValid(handle) then
        handle:Fire(input, value, delay)
        --print('EntFireByHandle ' .. tostring(handle) .. ' ' .. input .. ' ' .. value)
    end
end

sandbox.PrecacheMovie = function(movieName)
    if not movieName then return end

    net.Start(GP2.Net.SendPrecacheMovie)
        net.WriteString(movieName)
    net.Broadcast()
end

sandbox.ScriptShowHudMessageAll = function(message, delay)
    delay = delay or 0

    timer.Simple(delay, function()
        PrintMessage( HUD_PRINTCENTER, message )
    end)
end

sandbox.TurnOnPotatos = function()
    SetGlobalBool("GP2::PotatosEnabled", true)
end

sandbox.TurnOffPotatos = function()
    SetGlobalBool("GP2::PotatosEnabled", false)
end

VscriptGlobals = VscriptGlobals or {}
sandbox.Globals = VscriptGlobals

return sandbox