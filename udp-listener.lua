function udp_received(data, addr)
  addr = hs.socket.parseAddress(addr)
  print("'".. data .. "' erhalten von " .. addr.host)
  -- hs.alert.show(data)
  -- hs.notify.show("UDP", "UDP-Paket von " .. addr.host .. " erhalten:\n'" .. data .. "'", "")
  
  if data:starts_with("Hammerspoon-Aktion:bitcoin-off") then
    setBitcoinPollingOff()
  end

  local notification = hs.notify.new(nil, { 
      title = "UDP-Receiver", 
      subTitle = data,
      soundName = hs.notify.defaultNotificationSound
      }):send()
end

udp_listener = hs.socket.udp.server(14777, udp_received):receive()