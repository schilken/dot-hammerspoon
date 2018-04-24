function iterateWords()
  local content = hs.pasteboard.getContents()
  for part in string.gmatch(content, "[^\r\n]+") do
  --  hs.eventtap.keyStroke({"shift"}, "return")
    hs.eventtap.keyStrokes(part)
    hs.eventtap.keyStroke({}, "down")
	end
end


function parseSimpleMindFile()
  local url = hs.pasteboard.readURL()
  local content
  if url then
    local decoded_url = decodeURI(url.url)
    print("url:" .. url.url .. ", decoded:" .. decoded_url)
    local path = string.gsub(decoded_url, "file://", "")
    content = read_file(path)
   end
  if content == nil then
     content = hs.pasteboard.getContents()
  end   
  for part in string.gmatch(content, "text=\"(.-)\"") do
    hs.eventtap.keyStroke({"shift"}, "return")
    replaced_part = string.gsub(part, "\\N", " ")
    hs.eventtap.keyStrokes(replaced_part)
  end
end