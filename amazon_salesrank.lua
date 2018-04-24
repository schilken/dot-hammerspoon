
local function sort_by_time(array) 
	table.sort(array, function(e1, e2) return e1.time < e2.time end) 
end

local function url_encode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w %-%_%.%~])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str	
end

function amazon_salesrank() 
  local to_base64 = require "basexx".to_base64
  local hashings = require("hashings")
  local sha256 = hashings.sha256
  local xml    = require 'luaxpath'
  local lom = require "lxp.lom"

  local accessKey= '<<<< your key >>>>'
  local secret = "<<<<   your secret    >>>>>"
  local asins = {"1986898423","B07CMBQ19V","1976208009", "B0772QQHNN","1535143320", "1517057094", "1505422388", "1986670767", "B00PV0I7RW", "B00MEVYEBE",  "1502880539", "1503212564"}
  local responseGroups = 'SalesRank'
  local timestamp = os.date("%Y-%m-%dT%H:%M:%SZ")

  parameters = {
      AssociateTag = "skalab-147",
      Operation = "ItemLookup",
      Service = "AWSECommerceService",
      Version = "2013-08-01", 
      AWSAccessKeyId = accessKey,
      Timestamp = timestamp,
      ItemId = table.concat(asins, ","),
      ResponseGroup = responseGroups --"Small,Images" or "SalesRank"
      }

    local tkeys = {}
    for k in pairs(parameters) do table.insert(tkeys, k) end
  -- sort the keys
    table.sort(tkeys)
  -- use the keys to retrieve the values in the sorted order

    local encodedParams = {}
    for _, k in ipairs(tkeys) do 
  --	print(k, parameters[k]) 
      encodedParams[#encodedParams + 1] = k .. "=" .. url_encode(parameters[k])
    end

    local step1 = table.concat(encodedParams, "&")
    local host = "webservices.amazon.de"
    local path = "/onca/xml"

    local step2 = "GET\n" .. host .. "\n" .. path .. "\n" .. step1

    hmac = hashings.hmac(sha256, secret, step2)

    local signature = url_encode(to_base64(hmac:digest()))

    local url = "http://"..host..path.."?"..step1.."&".."Signature="..signature
    print(url)

    local http_request = require "http.request"
    local my_req = http_request.new_from_uri(url)
    local headers, stream = assert(my_req:go())
    for field, value in headers:each() do
        print(field, value)
    end
    local body = assert(stream:get_body_as_string())
  --print(body)

    local displayString = "Amazon-Salesrank</br>"
    local root = lom.parse(body)
    local items = xml.selectNodes(root, '/ItemLookupResponse/Items/Item')
    for ix,item in pairs(items) do
      local asin = item[1][1]
      local salesrank = item[2][1]
      displayString = displayString ..  ": ASIN " .. asin .. ', rank:' .. salesrank .. "</br>"
      print(ix .. ": ASIN " .. asin .. ', rank:' .. salesrank)
      write_log("amazon-" .. asin, salesrank) 
    end
  --printInBrowser(displayString)
    if #items > 0 then 
      analyze_rank()
    end
--  restart_timers()
    return #items
end


function amazon_salesrank_with_retry()
  local read_ranks = amazon_salesrank()
  if read_ranks ~= 0 then return end
  hs.timer.doAfter(5, function() 
    read_ranks = amazon_salesrank()
    if read_ranks ~= 0 then return end
      hs.timer.doAfter(5, function() 
          read_ranks = amazon_salesrank()
      end)
  end)
end

function is_last_rank_lower(filename)
  local path = hammerspoon_data_dir .. "/" .. filename
  print(path)
  local last_line = 0
  local previous_line = 0
  for line in io.lines(path) do
--    print(line)
    previous_line = last_line
    last_line = line
  end
  print(previous_line)
  print(last_line)
  local parts = split(previous_line, "[^:]*")
  print(inspect(parts))
  local previous_rank = tonumber(parts[3])
  parts = split(last_line, "[^:]*")
  local last_rank = tonumber(parts[3])
  return last_rank < (previous_rank * 0.9)
end


function book_sold(filename)
  print("Buch verkauft? >>>" .. filename)
  hs.messages.iMessage("alf147@me.com", "Buch verkauft >>>" .. filename)
end

function analyze_rank()
  for filename in hs.fs.dir(hammerspoon_data_dir) do
    if filename:starts_with("amazon-") then
      if is_last_rank_lower(filename) then
        book_sold(filename)
      end
    end
  end
end

timer_table = {}
for h = 7,23,2 do
  local timestring = h..":55"
  print(timestring) 
  local timer = hs.timer.doAt(timestring, "1d", amazon_salesrank_with_retry, true)
  table.insert(timer_table, timer)
end

--[[

http://webservices.amazon.de/onca/xml?AWSAccessKeyId=AKIAJ4VUYIEE4M5FFZNQ&AssociateTag=skalab-147&ItemId=B0772QQHNN%2C1976208009%2C1535143320%2C1517057094%2C1505422388%2CB00PV0I7RW%2CB00MEVYEBE%2C1502880539%2C1503212564&Operation=ItemLookup&ResponseGroup=SalesRank&Service=AWSECommerceService&Timestamp=2017-12-24T12%3A22%3A31Z&Version=2013-08-01&&Signature=wHLlgyl7iQ%2F4VoiqOiwmFpOJQTvPN1vzpmb1GulNdxg%3D

        let url = "https://\(host)\(path)?\(step1)&Signature=\(sig)"
]]
