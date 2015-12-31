# foundation-player.js
# Authors: Alexander Egorov, Rita Kondratyeva

(($, window) ->
  'use strict'
  # Define the plugin class
  class FoundationPlayer
    defaults:
      # How it behaves
      playOnLoad: false       # Play as soon as it's loaded
      skipSeconds: 10         # How many we want to skip
      dimmedVolume: 0.25      # Reduced volume i.e. while seeking
      pauseOthersOnPlay: true # Pause other player instances
      useSeekData: false      # Parse seek data from links by default
      # How it looks
      playerUISize: 'normal'  # Size of player <normal|small>
      classPlayDefault: 'fi-music'
      classPlayWait: 'fi-clock'
      classPlayPaused: 'fi-pause'
      classPlayPlaying: 'fi-play'
      classPlayError: 'fi-alert'
      classVolumeOn: 'fi-volume'
      classVolumeOff: 'fi-volume-strike'
      # Event handlers
      canPlayCallback: -> true

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
      @currentUISize = @options.playerUISize
      @canPlayCurrent = false
      @dataLinks = []
      @audioError = null      # Audio error state

      # Is it iOS?
      @iOS = /iPad|iPhone|iPod/.test(navigator.userAgent) \
      && !window.MSStream;

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

    seekPercent: (p, callback) ->
      if @canPlayCurrent
        timeToGo = @audio.duration * parseSeekPercent p
        @audio.currentTime = timeToGo or 0
        @updatePlayedProgress()
        @updateTimeStatuses()
        callback() if typeof callback == 'function'
      @

    # Generic ==================================================================
    # Setup default class
    resetClassAndStyle: ->
      # Set initial size
      @$wrapper.addClass(@options.playerUISize)
      # Calculate player width
      @setPlayerSizeHandler()

    # Setup current audio
    setUpCurrentAudio: ->
      # Start preload of audio file
      @audio.load()
      @audio.preload = 'auto'
      $audio = $(@audio)
      # Bunch of <audio> events
      $audio.on 'timeupdate.zf.player', => # While playing
        @updatePlayedProgress()
        @updateTimeStatuses()
      $audio.on 'loadstart.zf.player', => # Loading is started
        @canPlayCurrent = false
        @updateDisabledStatus()
        @updateButtonPlay()
      $audio.on 'durationchange.zf.player', => # 'NaN' to loaded
        @updateTimeStatuses()   # Update both time statuses
      $audio.on 'progress.zf.player', =>
        @redrawBufferizationBars()
        @updateDisabledStatus()
      $audio.on 'canplay.zf.player', => # Can be played
        @canPlayCurrent = true
        @options.canPlayCallback()
        @play() if @options.playOnLoad
        @redrawBufferizationBars()
        @updateDisabledStatus()
        @updateButtonPlay()
      $audio.children('source').on 'error', (e) => # For <source>'s errors
        @handleAudioError()
      $audio.on 'error', (e) => # For <audio src='...'> errors
        @handleAudioError()

    # Buttons ==================================================================
    # Set up Play/Pause
    setUpButtonPlayPause: ->
      @$play.bind 'click', =>
        @playPause() if @canPlayCurrent
    # Update Play/Pause
    updateButtonPlay: ->
      @$play.toggleClass(@options.classPlayWait,
        !@canPlayCurrent && !@audioError)
      @$play.toggleClass(@options.classPlayPaused,
        @audio.paused && @canPlayCurrent)
      @$play.toggleClass(@options.classPlayPlaying,
        !@audio.paused)
      @$play.toggleClass(@options.classPlayError,
        @audioError)
      @$play.removeClass @options.classPlayDefault
      @
    # Set up volume button
    setUpButtonVolume: ->
      # Hide volume button on iOS
      if @iOS
        @$wrapper.find('.player-button.volume').hide()
      else
        @$volume.bind 'click.zf.player', =>
          @buttonVolumeHandler()
    # Update volume button
    updateButtonVolume: ->
      @$volume.toggleClass(@options.classVolumeOff, @audio.muted)
      @$volume.toggleClass(@options.classVolumeOn, !@audio.muted)

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
      @$progress.on 'click.zf.player', (e) =>
        @seekPercent 100 * e.offsetX // @$progress.outerWidth()
      # Drag section is tricky
      # TODO: Mobile actions

      @$progress.on 'mousedown.zf.player',  =>
        @nowdragging = true
        @setVolume(@options.dimmedVolume)

      # Stop dragging common handler
      _stopDragHandler = =>
        if @nowdragging
          @nowdragging = false
          @setVolume(1)
      @$player.on 'mouseleave.zf.player', -> _stopDragHandler()
      $(document).on 'mouseup.zf.player', -> _stopDragHandler()
      $(window).on 'blur.zf.player', -> _stopDragHandler()
      # Update player position
      @$progress.on 'mousemove.zf.player', (e) =>
        if @nowdragging
          @seekPercent 100 * e.offsetX // @$progress.outerWidth()

    updatePlayedProgress: ->
      @played = Math.round @audio.currentTime / @audio.duration * 100
      @$played.css 'width', @played + '%'
    redrawBufferizationBars: ->
      # This function should be called after playerBeautifyProgressBar
      @$progress.find('.buffered').remove() # remove all current indicators
      segments = @audio.buffered.length
      if segments > 0 # If there is at least one segment...
        w = @$progress.width() # $progress width used for buffer indicators
        for range in [0...segments]
          b = @audio.buffered.start(range) # Segment start second
          e = @audio.buffered.end(range) # Segment end second
          switchClass(@$played.clone(), 'buffered', 'played')
          .css('left', (w * (b // @audio.duration)) + 'px')
          .width(w * (e - b) // @audio.duration).appendTo @$progress

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
      @$remains.text '-' + prettyTime @audio.duration - @audio.currentTime
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
        semiHeight = @$progress.height() / 2
        @$played.css 'padding', "0 #{semiHeight}px"
        @$progress.find('.buffered').css 'padding', "0 #{semiHeight}px"

    getPlayerInstances: ->
      $.data(document.body, 'FoundationPlayers')

    # Data links ===============================================================
    parseDataLinks: ->
      @dataLinks = [] # Reset dataLinks before parsing
      timeLinks = $('[data-seek-to-time]')
      percentLinks = $('[data-seek-to-percentage]')

      dataLinker = (links, parser, attr, action) =>
        clk = 'click.zf.player.seek'
        $.each links, (i, el) =>
          if val = parser $(el).data attr
            @dataLinks.push el
            $(el).off(clk).on clk, @, (e) ->
              e.data[action](val) and e.preventDefault()

      dataLinker timeLinks, parseSeekTime,
        'seek-to-time', 'seekToTime'
      dataLinker percentLinks, parseSeekPercent,
        'seek-to-percentage', 'seekPercent'

    # Errors' handling  ========================================================
    handleAudioError: ->
      # Some error is happend ¯\_(ツ)_/¯
      @audioError = true
      @updateButtonPlay()

    # Accessors ================================================================
    onCanPlay: (callback) ->
      @options.canPlayCallback = callback

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
      (new Array(length + 1).join(pad) + string).slice(-length)

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
    testingAPI: ->
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
