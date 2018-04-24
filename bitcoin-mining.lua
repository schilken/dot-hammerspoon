local function isHashrateLow(hashrate)
  if hashrate:sub(#hashrate) ~= "G" then
    return true
  else 
    local hashInG = tonumber(hashrate:sub(1,#hashrate-1))
    if hashInG < 20 then
      return true
    end
  end
  return false
end

function asyncGetCallback(status, body, headers)
  --print("body:" .. body)
  local jsonTable = hs.json.decode(body)
  local inspectString = inspect(jsonTable)
  --print("inspectString:" .. inspectString)
  local displayString = "bestever:" .. jsonTable.bestever .. "</br>"
  print("jsonTable.hashrate1m:" .. jsonTable.hashrate1m)
  displayString = displayString ..  "hashrate1m:" .. jsonTable.hashrate1m .. "</br>"
  displayString = displayString ..  "shares:" .. jsonTable.shares .. "</br>"
  displayString = displayString ..  "workers:" .. jsonTable.workers .. "</br>"
  --  print(inspectString)
  if isHashrateLow(jsonTable.hashrate1m) then
    hs.messages.iMessage("alf147@me.com", "hashrate low: " .. jsonTable.hashrate1m)
    printInBrowser(displayString)
  end
end

function miningStatistic()
--  local url = "http://solo.ckpool.org/users/1G8yf8B2HecbQxHV7VoTyMHiMQREbUUjNf"
  local url = "http://solo.ckpool.org/users/17v6pnxTJxWBXRhknkLsGggn4iYCe9PvJB"
  local header = nil
  hs.http.asyncGet(url, headers, asyncGetCallback)
end

