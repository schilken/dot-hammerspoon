caffeineMenu = hs.menubar.new()

function setCaffeineDisplay(status)
    if status then
        caffeineMenu:setTitle("AWAKE")
    else
        caffeineMenu:setTitle("SLEEPY")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeineMenu then
    caffeineMenu:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end