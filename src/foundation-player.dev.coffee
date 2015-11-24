# foundation-player.js
# Authors: Alexander Egorov, Rita Kondratyeva

(($, window) ->
  'use strict'
  # Define the plugin class
  class FoundationPlayer
    defaults:
      size: 'normal'          # Size of player <normal|small>
      playOnLoad: false       # Play as soon as it's loaded
      skipSeconds: 10         # How many we want to skip
      dimmedVolume: 0.25      # Reduced volume i.e. while seeking
      pauseOthersOnPlay: true # Pause other player instances
      useSeekData: true       # Parse seek data from links by default

    constructor: (el, opt) ->
      @options = $.extend({}, @defaults, opt)
      # jQuery Objects
      @$wrapper =  $(el)
      @$player =   @$wrapper.children('.player')
      @$play =     @$wrapper.find('.player-button.play em')
      @$rewind =   @$wrapper.find('.player-button.rewind em')
      @$volume =   @$wrapper.find('.player-button.volume em')
      @$elapsed =  @$wrapper.find('.player-status.time .elapsed')
      @$remains =  @$wrapper.find('.player-status.time .remains')
      @$progress = @$wrapper.find('.player-progress .progress')
      @$played =   @$progress.find('.progress-meter.played')
      @$sources =  @$wrapper.children('audio')
      # DOM Elements
      # TODO: Manage current audio object more carefully
      @audio =     @$sources.get(0)
      # State
      @played =    0
      @nowdragging = false
      @currentUISize = @options.size
      @canPlayCurrent = false
      # Init calls
      @resetClassAndStyle()   # Setup classes and styles
      @setUpCurrentAudio()    # Set up Play/Pause
      @setUpButtonPlayPause() # Set up Play/Pause
      @setUpButtonVolume()    # Set up volume button
      @setUpButtonRewind()    # Set up rewind button
      @setUpPlayedProgress()  # Set up played progress meter
      @parseDataLinks() if @options.useSeekData

    # Playback API =============================================================
    playPause: ->
      if @audio.paused then @play() else @pause()
    play: ->
      if @options.pauseOthersOnPlay
        @getPlayerInstances().map (p) => p.pause() if @ != p
      @audio.play()
      @updateButtonPlay()
    pause: ->
      @audio.pause()
      @updateButtonPlay()

    seekToTime: (time) ->
      if @canPlayCurrent
        time = parseSeekTime time
        if time > @audio.duration then time = @audio.duration # Needs for Sarari
        @audio.currentTime = time
        @updatePlayedProgress()
        @updateTimeStatuses()
      @

    seekPercent: (p) ->
      timeToGo = @audio.duration * parseSeekPercent p
      @audio.currentTime = timeToGo or 0
      @updatePlayedProgress()
      @updateTimeStatuses()
      @

    # Generic ==================================================================
    # Setup default class
    resetClassAndStyle: ->
      # Set initial size
      @$wrapper.addClass(@options.size)
      # Calculate player width
      @setPlayerSizeHandler()

    # Setup current audio
    setUpCurrentAudio: ->
      # Start preload of audio file
      @audio.load()
      $audio = $(@audio)
      $audio.on 'timeupdate.zf.player`', => # While playing
        @updatePlayedProgress()
        @updateTimeStatuses()
      # Bunch of <audio> events
      $audio.on 'loadstart.zf.player`', => # Loading is started
        @canPlayCurrent = false
        @updateDisabledStatus()
        @updateButtonPlay()
      $audio.on 'durationchange.zf.player`', => # 'NaN' to loaded
        @updateTimeStatuses()   # Update both time statuses
      $audio.on 'progress.zf.player`', =>
        @redrawBufferizationBars()
        @updateDisabledStatus()
      $audio.on 'canplay.zf.player`', => # Can be played
        @canPlayCurrent = true
        @play() if @options.playOnLoad
        @redrawBufferizationBars()
        @updateDisabledStatus()
        @updateButtonPlay()

    # Buttons ==================================================================
    # Set up Play/Pause
    setUpButtonPlayPause: ->
      @$play.bind 'click', =>
        @playPause() if @canPlayCurrent
    # Update Play/Pause
    updateButtonPlay: ->
      @$play.toggleClass('fi-music', !@canPlayCurrent)
      @$play.toggleClass('fi-pause', @audio.paused && @canPlayCurrent)
      @$play.toggleClass('fi-play', !@audio.paused)
      @
    # Set up volume button
    setUpButtonVolume: ->
      @$volume.bind 'click.zf.player`', =>
        @buttonVolumeHandler()
    # Update volume button
    updateButtonVolume: ->
      if @audio.muted
        switchClass @$volume, 'fi-volume-strike', 'fi-volume'
      else
        switchClass @$volume, 'fi-volume', 'fi-volume-strike'
    # Volume button handler
    buttonVolumeHandler: ->
      @toggleMute()
      @updateButtonVolume()

    # Set up rewind button
    setUpButtonRewind: ->
      @$rewind.on 'click', =>
        @seekToTime(@audio.currentTime - @options.skipSeconds)

    # Progress =================================================================
    setUpPlayedProgress: ->
      @$played.css 'width', @played + '%'
      # Click and drag progress
      @$progress.on 'click.zf.player`', (e) =>
        @seekPercent 100 * e.offsetX // @$progress.outerWidth()
      # Drag section is tricky
      # TODO: Mobile actions

      @$progress.on 'mousedown.zf.player`',  () =>
        @nowdragging = true
        @setVolume(@options.dimmedVolume)

      # Stop dragging common handler
      _stopDragHandler = () =>
        if @nowdragging
          @nowdragging = false
          @setVolume(1)
      @$player.on 'mouseleave.zf.player`', () -> _stopDragHandler()
      $(document).on 'mouseup.zf.player`', () -> _stopDragHandler()
      $(window).on 'blur.zf.player`', () -> _stopDragHandler()
      # Update player position
      @$progress.on 'mousemove.zf.player`', (e) =>
        if @nowdragging
          @seekPercent 100 * e.offsetX // @$progress.outerWidth()

    updatePlayedProgress: ->
      @played = Math.round @audio.currentTime / @audio.duration * 100
      @$played.css 'width', @played + '%'
    redrawBufferizationBars: ->
      # This function should be called after playerBeautifyProgressBar
      # Remove all current indicators
      @$progress.find('.buffered').remove()
      segments = @audio.buffered.length
      # If there is at least one segment...
      if segments > 0
        # Some of $progress styles are used for buffer indicators
        t =  parseInt @$progress.css('padding-top'), 10
        l = parseInt @$progress.css('padding-left'), 10
        w = @$progress.width()
        h = @$progress.height()
        widthDelta = 2 * parseInt @$played.css('padding-left'), 10
        for range in [0...segments]
          b = @audio.buffered.start(range) # Segment start second
          e = @audio.buffered.end(range) # Segment end second
          switchClass(@$played.clone(), 'buffered', 'played')
          .css('left', l + (w * (b // @audio.duration)) + 'px')
          .css('top', t).height(h).width(w*(e-b)//@audio.duration)
          .appendTo(@$progress)

    # Volume ===================================================================
    setVolume: (vol) ->
      @audio.volume = vol
    toggleMute: ->
      @audio.muted = !@audio.muted

    # Status ===================================================================
    # Update all statuses
    updateTimeStatuses: ->
      @updateStatusElapsed()
      @updateStatusRemains()
    updateStatusElapsed: -> # Update $elapsed time status
      @$elapsed.text prettyTime @audio.currentTime
    updateStatusRemains: -> # Update $remains time status
      @$remains.text '-' + prettyTime @audio.duration-@audio.currentTime
    updateDisabledStatus: -> # Update $remains time status
      @$player.toggleClass('disabled', !@canPlayCurrent)


    # Look and feel ============================================================
    # This method toggles player size
    togglePlayerSize: ->
      toSize = if @currentUISize == 'normal' then 'small' else 'normal'
      @currentUISize = toSize if @setPlayerSize toSize

    # Set particalar player size
    setPlayerSize: (size) ->
      if size != @currentUISize
        if ('normal' == size or 'small' == size)
            switchClass @$wrapper, size, @currentUISize
            @setPlayerSizeHandler()
            return @currentUISize = size
        else
          console.error 'setPlayerSize: incorrect size argument'
          return false

    # Player resize handler
    setPlayerSizeHandler: ->
      @playerBeautifyProgressBar()
      @redrawBufferizationBars()

    # Deuglification of round progress bar when it 0% width
    playerBeautifyProgressBar: ->
      if @$progress.hasClass('round')
        semiHeight = @$progress.height()/2
        # TODO: Make it better
        @$played.css 'padding', '0 ' + semiHeight + 'px'
        @$progress.find('.buffered').css 'padding', '0 ' + semiHeight + 'px'

    getPlayerInstances: ->
      $.data(document.body, 'FoundationPlayers')

    # Data links ===============================================================
    parseDataLinks: ->
      seekItems = $('[data-seek-to-time]')
      seekItems.off 'click.player.seek' # Remove any existin handlers
      seekItems.on 'click.player.seek', @, (e) ->
        console.log e
        e.preventDefault() # Prevent default action
        e.data.seekToTime($(this).data 'seek-to-time')

    # Helpers ==================================================================
    # Some really internal stuff goes here
    switchClass = (element, p, n) ->
      $(element).addClass(p).removeClass(n)

    # Format second to human readable format
    prettyTime = (s) ->
      return false unless isNumber s
      # As seen here: http://stackoverflow.com/questions/3733227
      min = s // 60
      sec = s - min * 60
      (stringPadLeft min, '0', 2) + ':' + (stringPadLeft sec // 1, '0', 2)

    # Small helper to padd time correctly
    stringPadLeft = (string,pad,length) ->
      # Quick and dirty
      # As seen here: http://stackoverflow.com/questions/3733227
      (new Array(length+1).join(pad)+string).slice(-length)

    # Check number http://stackoverflow.com/a/1280236/228067
    isNumber = (x) ->
      typeof x == 'number' and isFinite(x)

    parseSeekTime = (time) ->
      if isNumber(time) # Numeric e.g. 42th second
        time
      else if m = time.match /^(\d{1,})$/ # String e.g. '15', '42'...
        m[1]
      else if m = time.match /^(\d?\d):(\d\d)$/ # String e.g. '00:15', '1:42'...
        (parseInt m[1], 10) * 60 + (parseInt m[2], 10)
      else
        false

    parseSeekPercent = (p) ->
      return isNumber p unless isNumber p # Can't use both '0.65' and '65'
      return 0 if p < 0
      return 1 if p > 100
      return if p > 1 then p / 100 else p

    # API for testing private functions
    # This comment section passed in compiled JavaScript
    ###__TEST_ONLY_SECTION_STARTS__###
    testingAPI: () ->
      isNumber: isNumber
      prettyTime: prettyTime
      stringPadLeft: stringPadLeft
      switchClass: switchClass
      parseSeekTime: parseSeekTime
      parseSeekPercent: parseSeekPercent
    ###__TEST_ONLY_SECTION_ENDS__###

  # Global variable for testing prototype functions
  ###__TEST_ONLY_SECTION_STARTS__###
  window.FoundationPlayer = FoundationPlayer
  ###__TEST_ONLY_SECTION_ENDS__###

  # Define the jQuery plugin
  $.fn.extend foundationPlayer: (option, args...) ->
    # Set up FoundationPlayers for documant
    if !$.data(document.body, 'FoundationPlayers')
      $.data(document.body, 'FoundationPlayers', [] )
    @each ->
      if !$.data(this, 'FoundationPlayer')
        fplayer = new FoundationPlayer(this, option)
        $.data this, 'FoundationPlayer', fplayer
        $.data(document.body, 'FoundationPlayers').push(fplayer)

) window.jQuery, window
