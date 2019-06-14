browser.browserAction.onClicked.addListener((tab) => {  
  req = new XMLHttpRequest
  req.open('POST', 'https://xlinks.herokuapp.com/links?link[url]=' + encodeURI(tab.url), true)
  req.send()
});
