-- ----------------------------------------------------------------------------
-- GP2 Framework
-- Everything related to VScripts, i.e. I/O system, global methods, etc.
-- ----------------------------------------------------------------------------

local vscriptinstance = {}
local entswithvscripts = {}
local thinkqueues = {}

local fmt = string.format

local MetaEntity = FindMetaTable( 'Entity' )

local function relativeInclude(baseDir, fileName)
    local actualPath = string.format("%s/%s.lua", baseDir, fileName:gsub("%.[^%.]+$", ""))
    if not file.Exists(actualPath, "LUA") then
        error("Included script not found: " .. actualPath)
    end
    return CompileFile(actualPath)
end

function MetaEntity:GetOrCreateVScriptScope()
    vscriptinstance[self] = vscriptinstance[self] or include("gp2/vscriptsandbox.lua")
    return vscriptinstance[self]
end

GP2.VScriptMgr = {
    Initialize = function()
        GP2.Print("Initializing the VScript system")
    end,

    --
    -- Run script file
    -- 
    InitializeScriptForEntity = function(ent, v)
        entswithvscripts[ent] = true
        GP2.VScriptMgr.RunScriptFile(ent, v)

        timer.Simple(0, function()
            GP2.VScriptMgr.CallScriptFunction(ent, "Precache", true, NULL)
        end)
    end,

    --
    -- Add think function to queue
    -- 
    InitializeScriptThinkFuncForEntity = function(ent, v)
        thinkqueues[ent] = v
    end,     

    ClearScriptScope = function(ent)
        vscriptinstance[ent] = {}
    end,

    --
    -- Run script file in entity's scope
    -- if no valid scope, create it before running script
    --
    RunScriptFile = function(ent, fl)
        fl = fl:gsub("%.[^%.]+$", "") -- remove trailing extension
        local actualPath = "vscripts/" .. fl .. ".lua"
    
        if not file.Exists(actualPath, "LUA") then
            GP2.VScriptMgr.Error("Script not found (lua/%s)", actualPath)
            return
        end
    
        GP2.Print("Running script '%s' on entity '%s'", fl, ent:GetName() ~= "" and ent:GetName() or ent:GetClass())
        local scope = ent:GetOrCreateVScriptScope()

        scope.self = ent

        -- Relative include
        scope.include = function(fileName)
            local baseDir = string.match(actualPath, "^(.-)[^/]+$")
            local chunk, err = relativeInclude(baseDir, fileName)
            if not chunk then error(err, 2) end
            setfenv(chunk, scope)()
        end
    
        -- Attempt to compile and execute the script
        local chunk, err = CompileFile(actualPath)
        if not chunk then
            GP2.VScriptMgr.Error(err)
            return
        end
    
        -- Set the environment and run the script
        setfenv(chunk, scope)
        local success, runtimeErr = pcall(chunk)
        if not success then
            GP2.VScriptMgr.Error(runtimeErr)
        end
    end,

    --
    -- Run script file without entity's scope
    -- just executes it and leaves in void...
    --
    RunScriptFileHandless = function(fl)
        fl = fl:gsub("%.[^%.]+$", "") -- remove trailing extension
        local actualPath = "vscripts/" .. fl .. ".lua"
    
        if not file.Exists(actualPath, "LUA") then
            GP2.VScriptMgr.Error("Script not found (lua/%s)", actualPath)
            return
        end
    
        GP2.Print("Running script '%s'", fl)
        local scope = include("gp2/vscriptsandbox.lua")

        -- Relative include
        scope.include = function(fileName)
            local baseDir = string.match(actualPath, "^(.-)[^/]+$")
            local chunk, err = relativeInclude(baseDir, fileName)
            if not chunk then error(err, 2) end
            setfenv(chunk, scope)()
        end
    
        -- Attempt to compile and execute the script
        local chunk, err = CompileFile(actualPath)
        if not chunk then
            GP2.VScriptMgr.Error(err)
            return
        end
    
        -- Set the environment and run the script
        setfenv(chunk, scope)
        local success, runtimeErr = pcall(chunk)
        if not success then
            GP2.VScriptMgr.Error(runtimeErr)
        end
    end,

    --
    -- Run Lua code in entity's scope
    -- if no valid scope, create it before running code
    --
    RunScriptCode = function(ent, code)
        local scope = ent:GetOrCreateVScriptScope()

        scope.self = ent

        -- Relative include
        scope.include = function(fileName)
            GP2.VScriptMgr.Error("Include function is not supported in RunScriptCode.")
        end

        -- Attempt to compile and execute the code string
        local chunk, err = CompileString(code)
        if not chunk and err then
            GP2.VScriptMgr.Error(err:gsub("CompileString:(%d)+", ""))
            return
        end

        -- Set the environment and run the script
        setfenv(chunk, scope)
        local success, runtimeErr = pcall(chunk)
        if not success and runtimeErr then
            GP2.VScriptMgr.Error(runtimeErr:gsub("CompileString%:%d+: ", "RunScriptCode: ( '" .. (ent:GetName() ~= "" and ent:GetName() or ent:GetClass()) .. "' )"))
        end        

        GP2.Print("Calling the %q on %q", code, tostring(ent))
    end,

    --
    -- Run function in entity's scope scope without args
    -- if no valid scope, create it before running function
    --
    CallScriptFunction = function(ent, funcname, failesilent, caller)
        failesilent = failesilent or false

        local scope = ent:GetOrCreateVScriptScope()
        scope.self = ent
        scope.owninginstance = caller
        local func = scope[funcname]

        if func and func then
            func()
        elseif not failesilent then
            GP2.VScriptMgr.Error("Attempt to call script function with name '%s' (not found)")
        end
    end,

    --
    -- Same as CallScriptFunction but with args
    --
    CallScriptFunctionWithArgs = function(ent, funcname, failesilent, ...)
        failesilent = failesilent or false

        local scope = ent:GetOrCreateVScriptScope()
        local func = scope[funcname]

        if func and func then
            func(...)
        elseif not failesilent then
            GP2.VScriptMgr.Error("Attempt to call script function with name '%s' (not found)", funcname)
        end
    end,

    CallHookFunction = function(hookname, failesilent, ...)
        for ent in pairs(entswithvscripts) do
            if IsValid(ent) or ent:IsWorld() then
                GP2.VScriptMgr.CallScriptFunctionWithArgs(ent, hookname, failesilent, ...)
            end
        end
    end,

    Think = function()
        for ent, thinkfunc in pairs(thinkqueues) do
            -- Try to call think function on this entity
            -- otherwise silently fail
            GP2.VScriptMgr.CallScriptFunction(ent, thinkfunc, true)
        end
    end,

    Error = function(msg, ...)
        msg = "VScript Error : " .. fmt(msg, ...)

        GP2.Error(msg, ...)

        if player.GetCount() > 0 then
            net.Start(GP2.Net.SendVscriptError)
                net.WriteString(msg)
            net.Broadcast()
        end
    end,
}

GP2.InputsHandler.AddCallback("runscriptcode", function(ent, activator, caller, value)
    GP2.VScriptMgr.RunScriptCode(ent, value)
end)

GP2.InputsHandler.AddCallback("runscriptfile", function(ent, activator, caller, value)
    GP2.VScriptMgr.RunScriptFile(ent, value)
end)

GP2.InputsHandler.AddCallback("callscriptfunction", function(ent, activator, caller, value)
    GP2.VScriptMgr.CallScriptFunction(ent, value, false, caller)
end)

GP2.KeyValueHandler.Add("vscripts", GP2.VScriptMgr.InitializeScriptForEntity)
GP2.KeyValueHandler.Add("thinkfunction", GP2.VScriptMgr.InitializeScriptThinkFuncForEntity)