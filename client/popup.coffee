
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
      <button>Popup</button>
    </p>
  """

bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item

  $item.find('button').click ->
    popup = window.open('https://livecode.world/graphs/graph.html','_blank');

    # // When the popup has fully loaded, if not blocked by a popup blocker:

    # // This does nothing, assuming the window hasn't changed its location.
    popup.postMessage("The user is 'bob' and the password is 'secret'",
                      "https://secure.example.net");

    # // This will successfully queue a message to be sent to the popup, assuming
    # // the window hasn't changed its location.
    popup.postMessage("hello there!", "http://example.org");

    receiveMessage(event) ->
      # // Do we trust the sender of this message?  (might be
      # // different from what we originally opened, for example).
      if (event.origin != "http://example.org")
        return;

      # // event.source is popup
      # // event.data is "hi there yourself!  the secret response is: rheeeeet!"
    window.addEventListener("message", receiveMessage, false);

window.plugins.popup = {emit, bind} if window?
module.exports = {expand} if module?

