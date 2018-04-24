
function toggle_papyrus_bereich()
    hs.application.launchOrFocus("Papyrus Autor")
    local papyrus = hs.appfinder.appFromName("Papyrus Autor")

    local menu_pfad = {"Bearbeiten", "Markierungsbereich", "Markierungsbereich aktiv"}
    local markierung_aktiv = papyrus:findMenuItem(menu_pfad)

    if (markierung_aktiv and markierung_aktiv["ticked"]) then
        papyrus:selectMenuItem(menu_pfad)
        hs.alert.show("Markierung aus")
    else 
        papyrus:selectMenuItem(menu_pfad)
        hs.alert.show("Markierung ein")
    end
end


function renameBeleg(files, flagTables)
  print(dump(flagTables))
  for ix,file in pairs(files) do
	  if file:sub(-4) == ".pap" then
	  	if flagTables[ix].itemCreated == true then
	  	  jetzt = os.date("-%H%M.pap")
	  	  newname = string.gsub(file, "%.pap", jetzt)
	  	  print("renameBeleg file:" .. file)
	  	  print("renameBeleg newname:" .. newname)
	  	  rc, error = os.rename(file, newname)
        if rc == nil then
          hs.dialog.blockAlert("Fehler beim Umbenennen!", error, "OK")
        else
			    hs.alert.show("Beleg wurde umbenannt!")
        end
	    end
	  end
	end  
end 

function zoomOut()
  local w = hs.window.focusedWindow()
  if w:title():ends_with("Denkbrett") then
    local size = w:size()
    local zoomoutPoint = {x=88, y = size.h + 10}
    hs.eventtap.leftClick(zoomoutPoint)
  else 
    hotkey_cmd_minus:disable()
    hs.eventtap.keyStroke({"cmd"}, "-")  
    hotkey_cmd_minus:enable()
  end 
end

function zoomIn()
  local w = hs.window.focusedWindow()
  if w:title():ends_with("Denkbrett") then
    local size = w:size()
    local zoomInPoint = {x=124, y = 780}
    hs.eventtap.leftClick(zoomInPoint)
  else 
    hotkey_cmd_plus:disable()
    hs.eventtap.keyStroke({"cmd"}, "+")  
    hotkey_cmd_plus:enable()
  end 
end

function deleteObject()
  local capp = hs.application.frontmostApplication()
--  local tabList = hs.tabs.tabWindows(capp)
--  print(inspect(tabList))
  local w = hs.window.frontmostWindow()
  local title = w:title()
  print("title:" .. title)
  if w:title():ends_with("Denkbrett") then
    local point = hs.mouse.getRelativePosition()
    hs.eventtap.rightClick(point)
    hs.timer.doAfter(1, function() 
      hs.eventtap.keyStroke({}, "up")
      hs.eventtap.keyStroke({}, "return")
      end )
  end
end

function makeGroupFromBox()
  hs.eventtap.keyStroke({"cmd"}, "a")
  hs.eventtap.keyStroke({"cmd"}, "x")
  local point = hs.mouse.getRelativePosition()
  hs.eventtap.rightClick(point)
  hs.timer.doAfter(0.5, function() 
    local newpoint = { x=point.x + 30, y=point.y + 15}
    hs.eventtap.leftClick(newpoint)
    hs.eventtap.keyStroke({}, "delete")
    hs.eventtap.keyStroke({}, "delete")
    hs.eventtap.keyStroke({}, "delete")
    hs.eventtap.keyStroke({}, "delete")
    hs.eventtap.keyStroke({}, "delete")
    hs.eventtap.keyStroke({}, "delete")
    hs.eventtap.keyStroke({"cmd"}, "v")
  end )
end