require 'opal'

def change_text(id, text)
  `document.querySelector(id).textContent=text;`
end

def window_open(url)
  `window.open( url );`
end
