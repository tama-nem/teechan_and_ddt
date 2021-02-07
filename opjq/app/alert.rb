require 'opal'

def change_text(id, text)
  changedtext = "#{text}!!!"
  `document.querySelector(id).textContent=changedtext;`
end
