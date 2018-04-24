
function wifiwatcherCallback(watcher, details)
  print(hs.wifi.currentNetwork())
  local neuesWLAN = hs.wifi.currentNetwork()
  if neuesWLAN == nil then
  	local notification = hs.notify.new(nil, {
     title = "WifiWatcher", 
     subTitle = "WLAN-Verlassen",
     informativeText = "WLAN verlassen " .. aktuellesWLAN or "-",
     soundName = hs.notify.defaultNotificationSound
     }):send()
  	 return
  end
  local zuhause = aktuellesWLAN == "skalab" 
  -- hs.audiodevice.defaultOutputDevice():setMuted(not zuhause)
  local notification = hs.notify.new(nil, {
     title = "WifiWatcher", 
     subTitle = "WLAN-Wechsel",
     informativeText = "WLAN ungeschaltet auf " .. neuesWLAN,
     soundName = hs.notify.defaultNotificationSound
     }):send()
  aktuellesWLAN = neuesWLAN
end

wifiwatcher = hs.wifi.watcher.new(wifiwatcherCallback):start()