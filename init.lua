local ZBS = "/Applications/ZeroBraneStudio.app/Contents/ZeroBraneStudio"
package.path = package.path .. ";" .. ZBS .. "/lualibs/?/?.lua"
package.path = package.path .. ";" .. ZBS .. "/lualibs/?.lua"
package.cpath = package.cpath .. ";" .. ZBS .. "/bin/?.dylib"
package.cpath = package.cpath .. ";" .. ZBS .. "/bin/clibs53/?.dylib"
--require("mobdebug").start()

print("package.path:" .. package.path)
print("package.cpath:" .. package.cpath)

hammerspoon_data_dir = hs.fs.pathToAbsolute("~/hammerspoon-data")

require("utils")

--*******************************
require("papyrus-functions")
hs.hotkey.bind({"ctrl", "alt", "cmd"}, '1', "toggle_papyrus", toggle_papyrus_bereich)
myPathWatcher= hs.pathwatcher.new(os.getenv("HOME") .. "/Documents/papyrus/numnum/belege/Autoreports/", renameBeleg):start() 

hotkey_cmd_minus = hs.hotkey.bind({"cmd"}, "-", "zoomOut", zoomOut)
hotkey_cmd_plus = hs.hotkey.bind({"cmd"}, "+", "zoomIn", zoomIn)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "delete", "deleteObject",deleteObject)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "8", "makeGroupFromBox", makeGroupFromBox)


--*******************************
require("clipboard-functions")
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "6", "iterateWords", iterateWords)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "7", "parseSimpleMindFile", parseSimpleMindFile)
--hs.hotkey.bind({"ctrl", "alt", "cmd"}, "2", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- delete from line 43 - 1195
function process_file(pathname)
  local tmp_pathname = string.gsub(pathname, ".txt", ".old-txt", 1)
  print(tmp_pathname)
  os.rename(pathname, tmp_pathname)
  
  local file = io.open (pathname, "a")
  local line_nr = 1
  for line in io.lines(tmp_pathname) do
    local parts = split(line, "[^:]*")
    local rank = tonumber(parts[3])
    if line_nr < 44 or line_nr > 1195 then  
      file:write(line .. "\n")
      print(line_nr .. ":" .. line)
    end
    line_nr = line_nr + 1
  end
  file:close()
end

function fillSelectedFileContentsIntoClipboard() 
local pathlist = hs.dialog.chooseFileOrFolder("Wähle eine Datei aus. Ihr Inhalt wird ins Clipboard kopiert.", hammerspoon_data_dir, true, false, false)
print("path:" .. pathlist["1"])
local content = read_file(pathlist["1"])
print(content)
hs.pasteboard.setContents(content)
end

function processSelectedFiles() 
local pathlist = hs.dialog.chooseFileOrFolder("Wähle Dateien aus, die bearbeitet werden sollen.", hammerspoon_data_dir, true, false, true)
  
  for ix,pathname in pairs(pathlist) do 
    print(ix .. "path:" .. pathname)
    process_file(pathname)
  end
end

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "f", "processSelectedFiles", processSelectedFiles)


--*******************************
require("webview-functions")
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "i", "printInBrowser", function() printInBrowser("immer noch alles klar mit der anzeige von textinformationen") end)


--*******************************
require("polling")
require("bitcoin-mining")
--hs.hotkey.bind({"ctrl", "alt", "cmd"}, "m", "miningStatistic", miningStatistic)


--*******************************
require("amazon_salesrank")
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "a", "amazon_salesrank", amazon_salesrank)


function restart_timers()
  for ix,timer in ipairs(timer_table) do
--      timer:fire()
    if timer:running() then
      print( ("timer %d: next trigger in %.1f Stunden"):format(ix, timer:nextTrigger()/3600) )
    else
      print("timer is not running")
--      timer:start()
    end
  end
end  

function test_function()
--  local timestamp = os.date("%Y-%m-%dT%H:%M:%SZ")
--  global_timestamp = timestamp
--  hs.alert.show("test_function:" .. timestamp)
--  write_log("doAt-test", timestamp)
  hs.eventtap.keyStroke({"cmd"}, 'C')
  local allURLs = hs.pasteboard.readURL(nil, true)
--  local content = hs.pasteboard.getContents()
  local entries = #allURLs
  print("test_function(): entries=" .. entries)
  local point = hs.mouse.getRelativePosition()
  hs.eventtap.rightClick(point)
  hs.timer.doAfter(0.5, function() 
    hs.eventtap.keyStroke({}, 'right') 
    hs.eventtap.keyStroke({}, 'down') 
    hs.eventtap.keyStroke({}, 'down')
    if entries > 1 then 
      hs.eventtap.keyStroke({}, 'down')
    end
    hs.eventtap.keyStroke({}, 'return')
  end )
  return 0
end
--*******************************
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "x", test_function)


--*******************************
require("applescript-functions")


--*******************************
require("menubar-examples")


--function noise_recognized(which)
--  hs.alert.show("noise!:")
--end

--noise_listener = hs.noises.new(noise_recognized):start()

speaker = hs.speech.new()
function get_user_input()
  local button, text_input = hs.dialog.textPrompt("Test der Sprachausgabe", "Gib ein Wort ein", "mach schon!", "OK", "Abbrechen")
  if button == "OK" then
    speaker:speak(text_input)
  end
end
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "s", "Sprachausgabe", get_user_input)


--*******************************
require("http-functions")

--*********************************
-- S P O O N S
-- you need to remove the comments for all installed Spoons
--*********************************

--[[hs.loadSpoon("ClipboardTool")
--print(spoon.ClipboardTool.name)
--print(spoon.ClipboardTool.homePage)
spoon.ClipboardTool.show_in_menubar = true
--print(spoon.ClipboardTool.frequency)
--print(spoon.ClipboardTool.hist_size)
--print(spoon.ClipboardTool.menubar_title)
spoon.ClipboardTool:bindHotkeys({ toggle_clipboard={{"ctrl", "alt", "cmd"}, "4"} })
spoon.ClipboardTool:start()--]]


--[[hs.loadSpoon("LookupSelection")
spoon.LookupSelection:bindHotkeys({
    lexicon = { { "ctrl", "alt", "cmd" }, "L" },
    neue_notiz = { { "ctrl", "alt", "cmd" }, "N" },
    hsdocs = { { "ctrl", "alt", "cmd" }, "H" },
})--]]
-- hs.loadSpoon("SpeedMenu")

--[[hs.loadSpoon("PopUpMenu")
spoon.PopUpMenu:bindHotkeys({ togglePopupMenu={{"ctrl", "alt", "cmd"}, "P"} })
spoon.PopUpMenu:start()--]]


--hs.loadSpoon("ColorPicker")
--spoon.ColorPicker.show_in_menubar = true
--spoon.ColorPicker:bindHotkeys({ show={{"ctrl", "alt", "cmd"}, "P"}})
--spoon.ColorPicker:start()

-- hs.loadSpoon("CountDown")

--[[hs.loadSpoon("DeepLTranslate")
spoon.DeepLTranslate:bindHotkeys({
    translate = { { "ctrl", "alt", "cmd" }, "E" },
    rephrase  = { { "ctrl", "alt", "cmd" }, "G" },
})--]]


--[[ksheet_visible = false
function toggle_ksheet()
  if ksheet_visible then
    spoon.KSheet:hide()
    ksheet_visible = false
  else
    spoon.KSheet:show()
    ksheet_visible = true
  end    
end
hs.loadSpoon("KSheet")
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "k", "KSheet", toggle_ksheet)--]]

--[[hs.loadSpoon("Commander")
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "m", function() spoon.Commander:show() end)
--]]

--[[HSKeybindings_visible = false
function toggle_HSKeybindings()
  if HSKeybindings_visible then
    spoon.HSKeybindings:hide()
    HSKeybindings_visible = false
  else
    spoon.HSKeybindings:show()
    HSKeybindings_visible = true
  end    
end
hs.loadSpoon("HSKeybindings")
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "0", toggle_HSKeybindings)--]]


--[[hs.loadSpoon("FinderPopup")
spoon.FinderPopup:bindHotkeys({
    finderPopup = { { "ctrl", "alt", "cmd" }, "C" },
})--]]



function requestHandler(type, path, headers, body)
  print(type .. " " .. path)
  print("body:" .. body)
  print("headers:" .. hs.inspect.inspect(headers))
  local response = [[{"data":{"k1":"v1", "k2":"v2"}]]
  return response, 200, {} 
end

server = hs.httpserver.new(true)
server:setPort(14141)
server:setCallback(requestHandler)
server:start()


function usbwatcherCallback(details)
  print(hs.inspect.inspect(details))
end

usbwatcher = hs.usb.watcher.new(usbwatcherCallback)
usbwatcher:start()


hs.urlevent.bind("event1", function(event, paramtable)
  print(event ..":".. hs.inspect.inspect(paramtable))
  end)

hs.urlevent.bind("event2", function(event, paramtable)
  print(event ..":".. hs.inspect.inspect(paramtable))
  end)

hs.urlevent.httpCallback = function(scheme, host, params, fullURL)
  print("hs.urlevent.httpCallback:" .. tostring(fullURL))
end
--[[
for minute = 1,9,2 do 
  local timestring = "11:"..minute
  print(timestring)
  hs.timer.doAt(timestring,"10m", test_function)
end
--]]

require("udp-listener")

require "wifiwatcher"

require "volumeswatcher"

--[[hs.logger.defaultLogLevel="info"
local log = hs.logger.new('myinit')
local dlog = hs.logger.new('myinit', "debug")
local vlog = hs.logger.new('myinit', "verbose")

log.v ("log.v   verboseLevel")
vlog.v("vlog.v  verboseLevel")

log.d ("log.d  debugLevel")
dlog.d("dlog.d debugLevel")

log.i ("log.i  infoLevel")
log.f ("log.f  %s: %d %f", "infoLevel", 42, 1.5)
log.w ("log.w  warningLevel")
log.e ("log.e  errorLevel")--]]




