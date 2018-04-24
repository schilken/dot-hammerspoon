local apple_script_source2 = [[
tell application "Finder"   
  empty the trash  
end tell
]]

local apple_script_source3 = [[
display dialog "This sentence is what will be displayed in the dialog window."
]]


function sendMessage(receiver, message)
local apple_script_source  = replace_vars{ [[
tell application "Messages"
activate
set theHandle to "{receiver}" 
set theMessage to "{message}"
set theService to first service whose service type is iMessage
set theBuddy to first buddy that its service is theService and handle is theHandle
send theMessage to theBuddy
end tell
]],
  receiver = receiver,
  message = message
}
status, v2, v3 = hs.osascript.applescript(apple_script_source)
print("status:" .. inspect(status))
end