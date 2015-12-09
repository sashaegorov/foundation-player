#       _/      _/    _/_/      _/_/_/  _/_/_/    _/_/_/
#      _/_/  _/_/  _/    _/  _/          _/    _/
#     _/  _/  _/  _/_/_/_/  _/  _/_/    _/    _/
#    _/      _/  _/    _/  _/    _/    _/    _/
#   _/      _/  _/    _/    _/_/_/  _/_/_/    _/_/_/
#

describe 'Data links', ->
  describe 'async test with actual audio', ->
    # These tests require loading of audio file
    # so they were moved here as separate suit.

    player = null
    LOADING_TIMEOUT = 100
    TEST_TIMEOUT = 250

    beforeAll ->
      jasmine.getFixtures().fixturesPath = '.'
      jasmine.getFixtures().preload \
        'spec/javascripts/fixtures/html/player-links.html'
      jasmine.getStyleFixtures().fixturesPath = '.'
      jasmine.getStyleFixtures().preload 'lib/css/foundation.min.css',
        'dist/foundation-player.css'

    afterAll ->
      jasmine.getFixtures().clearCache()

    beforeEach (done) ->
      jasmine.getFixtures().load \
        'spec/javascripts/fixtures/html/player-links.html'
      jasmine.getStyleFixtures().load 'lib/css/foundation.min.css',
        'dist/foundation-player.css'

      $('.links-primary').foundationPlayer useSeekData: true
      player = $('.links-primary').data 'FoundationPlayer'
      player.audio.muted = true # Mute audio
      done()

    afterEach (done) ->
      player = null
      $.removeData document.body, 'FoundationPlayers'
      done()

    it 'produce correct seek to time actions', (done) ->
      spyOn player, 'seekToTime' # desirable
      spyOn player, 'seekPercent' # undesirable
      setTimeout ->
        $('#to01').click()
        expect(player.seekToTime).toHaveBeenCalledWith 1
        expect(player.seekPercent).not.toHaveBeenCalled()
        $('#to02').click()
        expect(player.seekToTime).toHaveBeenCalledWith 2
        expect(player.seekPercent).not.toHaveBeenCalled()
        done()
      , LOADING_TIMEOUT
    , TEST_TIMEOUT

    it 'produce correct percentage seek actions', (done) ->
      spyOn player, 'seekPercent' # desirable
      spyOn player, 'seekToTime' # undesirable
      setTimeout ->
        $('#to25').click()
        expect(player.seekPercent).toHaveBeenCalledWith 0.25
        expect(player.seekToTime).not.toHaveBeenCalled()
        $('#to50').click()
        expect(player.seekPercent).toHaveBeenCalledWith 0.5
        expect(player.seekToTime).not.toHaveBeenCalled()
        done()
      , LOADING_TIMEOUT
    , TEST_TIMEOUT
