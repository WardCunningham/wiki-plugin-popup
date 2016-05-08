
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
      <button class=message>Message</button>
    </p>
  """

bind = ($item, item) ->
  popup = null

  $item.dblclick -> wiki.textEditor $item, item

  $item.find('button.popup').click ->
    popup = window.open('https://livecode.world/graphs/graph.html','_blank');
    console.log 'popup',popup
    receiveMessage = (event) ->
      console.log 'recieve', event
      $item.append $ "<p>#{expand event.data}</p>"
    window.addEventListener("message", receiveMessage, false);

  $item.find('button.message').click ->
    console.log 'message', popup
    popup.postMessage("hello there!", "*");


window.plugins.popup = {emit, bind} if window?
module.exports = {expand} if module?

