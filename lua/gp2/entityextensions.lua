-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Additional missing stuff for Entity metatable
-- ----------------------------------------------------------------------------

local scenes = {}
local MetaEntity = FindMetaTable( 'Entity' )

function MetaEntity:GetCurrentScene()
    return scenes[self:EntIndex()] or NULL
end

function MetaEntity:SetCurrentScene(scene)
    local entIndex = self:EntIndex()
    scenes[entIndex] = scene or NULL
end