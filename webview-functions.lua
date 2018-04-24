local www = require("hs.webview")
local ucc = www.usercontent.new("dashamajig"):injectScript({ source = [[
function KeyPressHappened(e)
{
  if (!e) e=window.event;
  var code;
  if ((e.charCode) && (e.keyCode==0))
    code = e.charCode ;
  else
    code = e.keyCode;
//  console.log(code) ;
  if ((code == 102) && e.metaKey) {
      var textMesg = window.prompt("Enter a search term:","") ;
      if (textMesg != null) {
          try {
              webkit.messageHandlers.dashamajig.postMessage(textMesg);
          } catch(err) {
              console.log('The controller does not exist yet');
          }
      }
      return false ;
  } else {
      return true ;
  }
}
document.onkeypress = KeyPressHappened;
]], mainFrame = true, injectionTime = "documentStart"}):setCallback(doSearch)

webView = nil

function printInBrowser(htmlInput)
  if webView == nil then
    webView = www.new({ x = 0, y = 150,h = 300, w = 600 })
    webView:windowStyle(1+2+4+8)
    webView:windowTitle("Hammerspoon Window")
  end
  webView:bringToFront(true)
  webView:html(htmlInput)
  webView:show()
end
