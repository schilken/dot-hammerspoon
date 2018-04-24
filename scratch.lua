hashrate1m = "23.3G"



function isHashrateLow(hashrate)
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



if isHashrateLow(hashrate1m) then
  print("hashrate low:" .. hashrate1m)
else
  print("hashrate OK:" .. hashrate1m)
end
return 0