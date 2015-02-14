###
  Chrome YouTube Resizer
  (c) 2015 Daniel Davison & Contributors

  Chrome YouTube Resizer is a chrome extension that allows you to resize a YouTube video (embedded or not) to any
  dimensions for your viewing pleasure.
###

class Resizer
  @btnResize             = document.createElement         ('div')

  @controlParent         = document.getElementsByClassName('html5-player-chrome')[0]
  @firstChild            = @controlParent.firstChild
  @mainContainer         = document.getElementById        ('player-api')
  @videoContainer        = document.getElementsByClassName('html5-main-video')[0] # sjust the video container
  @videoContentContainer = document.getElementsByClassName('html5-video-content')[0]

  @activate: ->
    @btnResize.setAttribute('class',      'ytp-button ytp-button-resize')
    @btnResize.setAttribute('role',       'button')
    @btnResize.setAttribute('aria-label', 'Resize')
    @btnResize.setAttribute('tabindex',   '5000')

    if (typeof chrome.extension != 'undefined')
      @btnResize.setAttribute('style', "display: inline-block;background-image: url(#{chrome.extension.getURL('images/resize.png')});background-size: 30px 27px;")
    else
      @btnResize.setAttribute('style', "display: inline-block;background-image: url(dist/images/resize.png)")

    @insertElement()

  # append the element to the youtube vapp/controllers/metrics_controller.rbideo player
  @insertElement: ->
    @controlParent.insertBefore(@btnResize, @firstChild)

  # Dragging.  Thank you! to..
  # http://stackoverflow.com/questions/8960193/how-to-make-html-element-resizable-using-pure-javascript#answer-8960307
  @_initListener: ->
    @mainContainer.removeEventListener('click', @_initListener, false)

  @mainContainer.addEventListener('click', =>
    @_initListener()
    @btnResize.addEventListener('mousedown', @initDrag, false)
  , false)

  @initDrag: (e) =>
    @dragStartX = e.clientX
    @dragStartY = e.clientY
    @dragStartWidth = parseInt(document.defaultView.getComputedStyle(@mainContainer).width, 10)
    @dragStartHeight = parseInt(document.defaultView.getComputedStyle(@mainContainer).height, 10)
    document.documentElement.addEventListener('mousemove', @doDrag,   false)
    document.documentElement.addEventListener('mouseup',   @stopDrag, false)

    @videoContainer.style.left        = '0px'
    @videoContentContainer.style.left = '0px'
    @videoContainer.style.top         = '0px'
    @videoContentContainer.style.top  = '0px'

  @doDrag: (e) =>
    @resizeContainer(e.clientX, e.clientY)

  @stopDrag: =>
    document.documentElement.removeEventListener('mousemove', @doDrag, false)
    document.documentElement.removeEventListener('mouseup', @stopDrag, false)

  # this method resizes all elements that need to be resized in order for the video to fit
  @resizeContainer: (cX, cY) =>
    objectsToResize = [
      @mainContainer,
      @videoContentContainer,
      @videoContainer
    ]

    for obj in objectsToResize
      obj.style.width  = (@dragStartWidth + cX - @dragStartX) + 'px'
      obj.style.height = (@dragStartHeight + cY - @dragStartY) + 'px'

Resizer.activate()
