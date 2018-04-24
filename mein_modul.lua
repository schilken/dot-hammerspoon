local obj = {}

local function lokaleFunktion()
  print('lokal im Modul')
end

obj.funktionInTabelle = function()
  print('funktionInTabelle()')
  lokaleFunktion()
end

function obj.gehtAuch()
  print('gehtAuch()')
end

return obj