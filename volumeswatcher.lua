
function volumeswatcherCallback1(ereignis, details)
  local name = details.path
  print(ereignis .. ": " ..  hs.inspect.inspect(details))
  if ereignis == hs.fs.volume.didMount then
    hs.alert.show("Neues Dateisystem:" .. name )
  elseif ereignis == hs.fs.volume.didUnmount then
    hs.alert.show("Dateisystem " .. name .. " entfernt")
  end
end



function volumeswatcherCallback2(ereignis, details)
  local name = string.sub(details.path, 10)
  print(ereignis .. ": " .. name)
  if ereignis == hs.fs.volume.didMount then
    hs.speech.new():speak("Neues Dateisystem:" .. name )
  elseif ereignis == hs.fs.volume.didUnmount then
    hs.speech.new():speak("Dateisystem " .. name .. " entfernt")
  end
end

function volumeswatcherCallback3(ereignis, details)
  if ereignis == hs.fs.volume.didMount then
    hs.fs.volume.eject(details.path)
    hs.speech.new():speak("Du kommst hier nicht rein!")
  end
end

function volumeswatcherCallback4(ereignis, details)
  if ereignis == hs.fs.volume.didMount then
    write_log("volumeswatcher", "gesteckt: " .. details.path)
  elseif ereignis == hs.fs.volume.didUnmount then
    write_log("volumeswatcher",  "entfernt:" .. details.path)
  end
end

function volumeswatcherCallback5(ereignis, details)
  local name = string.sub(details.path, 10)
  print("volumeswatcherCallback5:" .. ereignis .. " " .. name)
  if not (name == "Transcend") then return end 
  if ereignis == hs.fs.volume.didMount then
    local zielverzeichnis = details.path .. "/hammerspoon-backup"
    filemodus, error = hs.fs.attributes("/Volumes/Transcend/hammerspoon-backup", "mode")
    if filemodus == "directory" then 
      hs.alert.show("Datensicherung nach " .. zielverzeichnis )
      write_log("volumeswatcher", "Backup nach " .. zielverzeichnis)
      local v1, v2, v3 = os.execute("cp -R ~/.hammerspoon " .. zielverzeichnis)
      if v3 ~= 0 then
         hs.dialog.blockAlert("Backup-Fehler", "Fehlercode von cp:" .. v3, "OK")
         write_log("volumeswatcher", "Fehler beim cp " .. v3)
      else
         hs.alert.show("Backup Fertig")
         write_log("volumeswatcher", "Backup OK")
        end
  else 
      hs.dialog.blockAlert("Backup-Fehler", error, "OK")
      write_log("volumeswatcher", "Fehler beim backup nach " .. zielverzeichnis .. " - " .. error)
  end
  
  elseif ereignis == hs.fs.volume.didUnmount then
    write_log("volumeswatcher",  "entfernt:" .. details.path)
  end
end

volumeswatcher = hs.fs.volume.new(volumeswatcherCallback5):start()