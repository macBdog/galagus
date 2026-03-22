local luaBinaryPath = "C:/Projects/game/external/lua-5.2.3"

function DebuggingStartup(enableDebugging)
  if enableDebugging then
    io.write("LUA debugger starting...\n")
    package.path = package.path .. ";" .. luaBinaryPath .. "/?.lua"
    package.cpath = package.cpath .. ";" .. luaBinaryPath .. "/?.dll"

    -- VSCode Lua Debug adapter (actboy168) attach mode
    local debuggerPath = os.getenv("LUA_DEBUGGER_PATH")
    if debuggerPath then
      package.cpath = package.cpath .. ";" .. debuggerPath .. "/?.dll"
      package.cpath = package.cpath .. ";" .. debuggerPath .. "/?.so"
    end

    -- Local Lua Debugger (tomblind) support
    local lldPath = os.getenv("LOCAL_LUA_DEBUGGER_FILEPATH")
    if lldPath then
      package.path = package.path .. ";" .. lldPath
      require("lldebugger").start()
      io.write("LUA debugger attached (Local Lua Debugger).\n")
      return
    end

    io.write("LUA debugger: set LOCAL_LUA_DEBUGGER_FILEPATH to enable.\n")
  end
end
