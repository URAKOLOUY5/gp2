-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Additional missing stuff for Entity metatable
-- ----------------------------------------------------------------------------

local scenes = {}
local connectedOutputs = {}
local MetaEntity = FindMetaTable( 'Entity' )

function MetaEntity:GetCurrentScene()
    return scenes[self:EntIndex()] or NULL
end

function MetaEntity:SetCurrentScene(scene)
    local entIndex = self:EntIndex()
    scenes[entIndex] = scene or NULL
end

function MetaEntity:ConnectOutput(name, func, caller)
    name = name:lower()

    connectedOutputs[self] = connectedOutputs[self] or {}
    connectedOutputs[self][name] = connectedOutputs[self][name] or {}

    table.insert(connectedOutputs[self][name], {caller, func})
end

function MetaEntity:DisconnectOutput(lookupname, lookupfunc)
    lookupname = lookupname:lower()

    local nameTable = connectedOutputs[self] and connectedOutputs[self][lookupname]
    if not nameTable then return end

    for i = #nameTable, 1, -1 do
        if nameTable[i][2] == lookupfunc then
            table.remove(nameTable, i)
        end
    end
end

function MetaEntity:TriggerConnectedOutput(name)
    name = name:lower()

    local nameTable = connectedOutputs[self] and connectedOutputs[self][name]
    if not nameTable then return end

    for i = 1, #nameTable do
        local output = nameTable[i]
        GP2.VScriptMgr.CallScriptFunction(output[1], output[2], true, self)
    end
end

-- custom gp2_entity base
local Integer = {}
Integer.__index = Integer

function isinteger(obj)
    return getmetatable(obj) == Integer
end

function int(number)
    if type(number) ~= "number" then
        error("Value must be an number")
    end

    number = math.floor(number)

    return setmetatable(number, Integer)
end

function DEFINE_FIELD(name, defaultValue)
    if not ENT then return end

    ENT.DTFields = ENT.DTFields or {}
    local typeFunc = type
    local type = ""

    print('DEFINE_FIELD(' .. name .. ', ' .. tostring(defaultValue) .. ')')
    
    if isstring(defaultValue) then
        type = "String"
    elseif isbool(defaultValue) then
        type = "Bool"
    elseif isinteger(defaultValue) then
        type = "Int"
    elseif isnumber(defaultValue) then
        type = "Float"
    elseif isvector(defaultValue) then
        type = "Vector"
    elseif isangle(defaultValue) then
        type = "Angle"
    elseif isentity(defaultValue) then
        type = "Entity"
    else
        error("Invalid type '" .. typeFunc(defaultValue) .. "' for FIELD value")
    end

    table.insert(ENT.DTFields, { type, name, defaultValue })
end

function DEFINE_KEYFIELD(name, defaultValue)
    DEFINE_FIELD(name, defaultValue)
end

function DEFINE_INPUT()
end

function DEFINE_OUTPUT()
end