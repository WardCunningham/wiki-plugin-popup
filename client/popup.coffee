
expand = (text)->
  text
    .replace /&/g, '&amp;'
    .replace /</g, '&lt;'
    .replace />/g, '&gt;'
    .replace /\*(.+?)\*/g, '<i>$1</i>'

# http://ward.asia.wiki.org/coordinated-viewing.html
# https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage

emit = ($item, item) ->
  $item.append """
    <p style="background-color:#eee;padding:15px;">
      #{expand item.text}
      <button class=popup>Popup</button>
    </p>
  """

bind = ($item, item) ->
  popup = null
  opener = null

  console.log 'window.opener', window.opener

  $item.dblclick -> wiki.textEditor $item, item

  send = {}
  rcve = {}

  doit = (doit, func) ->
    send[doit] = func.send
    rcve[doit] = func.rcve
    $item.find('button:last').after "<button class=doit>#{doit}</button>"

  doit 'world',
    send: -> 'everyone'
    rcve: -> $item.append "<p>hello world</p>"

  doit 'append-last',
    send: -> $('.page:last').attr('id')
    rcve: (data) -> wiki.doInternalLink data

  doit 'replace-last',
    send: -> $('.page:last').attr('id')
    rcve: (data) -> wiki.doInternalLink data, $item.parents('.page')

  $item.find('button.doit').click (e) ->
    doit = $(e.target).text()
    data = {type:'doit', doit, data:send[doit]()}
    console.log 'doit', data
    (popup || opener)?.postMessage(JSON.stringify(data), "*");

  $item.find('button.popup').click ->
    popup = window.open('http://localhost:3000/view/testing-popup-plugin','_blank');
    console.log 'popup',popup

  receiveMessage = (event) ->
    opener = event.source unless popup
    data = JSON.parse event.data
    console.log 'data', data
    if data.type == 'doit'
      rcve[data.doit](data.data)
    else
      $item.append $ "<p>#{expand event.data}</p>"

  window.addEventListener("message", receiveMessage, false);


window.plugins.popup = {emit, bind} if window?
module.exports = {expand} if module?

