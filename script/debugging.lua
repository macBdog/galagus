local luaBinaryPath = "C:/Projects/game/external/lua-5.2.3"
local zeroBraneStudioPath = "C:/Projects/ZeroBraneStudio"

function DebuggingStartup(enableDebugging)
  if enableDebugging then
    io.write("LUA debugger starting...\n")
    package.path = package.path..";" .. luaBinaryPath .. "/?.lua"
    package.path = package.path .. ";" ..zeroBraneStudioPath .. "/lualibs/mobdebug/?.lua"
    package.cpath = package.cpath..";" .. luaBinaryPath .. "/?.dll"
    require("mobdebug").start()  
  end
end