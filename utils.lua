
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", "Reload Config", function()
  hs.reload()
end)
hs.alert.show("Config loaded")

function inspect(v)
  return hs.inspect.inspect(v)
end

hs.hotkey.alertDuration = 3
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "D", "Delete Konsole", function()
  hs.console.clearConsole()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", "Focused Window", function()
  print(hs.window.focusedWindow())
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "f12", "Screenshot", function()
  local shot = hs.screen.mainScreen():snapshot()
  rc, name = hs.dialog.textPrompt("Screenshot", "Dateiname", "hs-", "OK", "Abbrechen")
  if rc == "OK" then 
    local filename = "/Users/alf147/Dropbox/papyrus/hammerspoon-images/" .. name .. ".png"
    print(filename)
    shot:saveToFile(filename, false, "png")
  end
end)

function read_file(path)
  local file = io.open(path, "r") 
  if not file then return nil end
  local content = file:read "*all"
  file:close()
  return content
end


-- Map the middle mouse to the alt key
eventtapRightMouseDown = hs.eventtap.new({ hs.eventtap.event.types.rightMouseDown }, function(event)
--  hs.alert.show("rightMouseDown")
--  hs.eventtap.event.newKeyEvent("alt", "", true):post()
  local point = hs.mouse.getRelativePosition()
  print("mouse at:" .. point.x ..","..point.y)
  return false
end)
eventtapRightMouseDown:start()


function replace_vars(str, vars)
  -- Allow replace_vars{str, vars} syntax as well as replace_vars(str, {vars})
  if not vars then
    vars = str
    str = vars[1]
  end
  return (string.gsub(str, "({([^}]+)})",
    function(whole,i)
      return vars[i] or whole
    end))
end

function split(str,pat)
  local tbl={}
  str:gsub(pat,function(x) tbl[#tbl+1]=x end)
  return tbl
end

function decodeURI(s)
    if(s) then
      s = string.gsub(s, '%%(%x%x)', 
        function (hex) return string.char(tonumber(hex,16)) end )
    end
    return s
  end

  function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function listApplications() 
	hs.fnutils.each(hs.application.runningApplications(), 
    function(app) 
      print((app:name() or "-") .."|".. (app:bundleID() or "-")) 
    end)
end

hs.urlevent.bind("someAlert", function(eventName, params)
    hs.alert.show("Received someAlert")
end)


function string.ends_with(theString, theEnd)
   return theEnd =='' or string.sub(theString,-string.len(theEnd))==theEnd
end

function string.starts_with(theString, theStart)
   return theStart =='' or string.sub(theString, 1, string.len(theStart))==theStart
end

print("-- package.path:")
for part in string.gmatch(package.path, "([^;]+)") do
  print("      "..part)
end

function write_log(logfilename, line)
  local file = io.open (hammerspoon_data_dir .. "/" .. logfilename .. ".txt", "a")
  local jetzt = os.date("%Y-%m-%d %H:%M : ")
  file:write(jetzt .. line .. "\n")
  file:close()
end

function list_hotkeys()
  for ix, entry in ipairs(hs.hotkey.getHotkeys()) do
    print(entry.msg)
  end
end

function windowCallback(win, app, event)
  print("win:" .. tostring(win))
  print("app:" .. tostring(app))
  print("event:" .. event)
  print(inspect(win:size()))
  win:focus():setSize({w=900, h=750})
end

-- {}
hsdocs_filter = hs.window.filter.new(false):setAppFilter('Hammerspoon', {allowTitles='docs'} )

--hsdocs_filter:subscribe({hs.window.filter.windowTitleChanged, hs.window.filter.windowCreated}, windowCallback)
hsdocs_filter:subscribe({hs.window.filter.windowTitleChanged, hs.window.filter.windowCreated}, windowCallback)