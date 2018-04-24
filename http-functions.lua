
function received(data, addr)
  addr = hs.socket.parseAddress(addr)
  print("'" .. data .. "' erhalten von " .. addr.host)
  hs.alert.show(data)
  -- hs.notify.show("UDP", "UDP-Paket von " .. addr.host .. " erhalten:\n'" .. data .. "'", "")
  
  local notification = hs.notify.new(nil, { 
      title = "UDP-Receiver", 
      subTitle = "UDP-Paket von " .. addr.host,
      informativeText = data,
      soundName = hs.notify.defaultNotificationSound
      }):send()
end

udp_server = hs.socket.udp.server(14757, received):receive()