function mining_timer_callback()
  miningStatistic()
end
mining_timer = hs.timer.doEvery(5*60, mining_timer_callback)


polling_state = true
function polling_action_clicked()
  polling_state =  not polling_state
  setPollingDisplay(polling_state)
end

function setBitcoinPollingOff()
  print("setBitcoinPollingOff")
  polling_state = false
  setPollingDisplay(polling_state)
end

function setPollingDisplay(state)
    if state then
        polling_action:setTitle("POLLING")
        mining_timer:start()
    else
        polling_action:setTitle("No Poll")
        mining_timer:stop()
    end
end

polling_action = hs.menubar.new()
if polling_action then
    polling_action:setClickCallback(polling_action_clicked)
    setPollingDisplay(polling_state)
end