#       _/      _/    _/_/      _/_/_/  _/_/_/    _/_/_/
#      _/_/  _/_/  _/    _/  _/          _/    _/
#     _/  _/  _/  _/_/_/_/  _/  _/_/    _/    _/
#    _/      _/  _/    _/  _/    _/    _/    _/
#   _/      _/  _/    _/    _/_/_/  _/_/_/    _/_/_/
#

describe 'Audio async tests', ->
  no1 = null
  LOADING_TIMEOUT = 100
  TEST_TIMEOUT = 250

  beforeAll ->
    jasmine.getFixtures().fixturesPath = '.'
    jasmine.getFixtures().preload 'spec/javascripts/fixtures/html/player-1.html'
    jasmine.getStyleFixtures().fixturesPath = '.'
    jasmine.getStyleFixtures().preload 'lib/css/foundation.min.css',
      'dist/foundation-player.css'

  afterAll ->
    jasmine.getFixtures().clearCache()

  beforeEach (done) ->
    jasmine.getFixtures().load 'spec/javascripts/fixtures/html/player-1.html'
    jasmine.getStyleFixtures().load 'lib/css/foundation.min.css',
      'dist/foundation-player.css'

    $('.no-1').foundationPlayer()
    no1 = $('.no-1').data 'FoundationPlayer'
    no1.audio.muted = true # Mute audio
    no1.audio.play() # Start playing
    done()

  afterEach (done) ->
    no1 = null
    $.removeData document.body, 'FoundationPlayers'
    done()

  it 'has correct audio source', (done) ->
    setTimeout ->
      expect(no1.audio.currentSrc).toMatch /lib\/audio\/acoustic-b\.m4a/
      expect(no1.audio.currentSrc).not.toBe ''
      done()
    , LOADING_TIMEOUT
  , TEST_TIMEOUT

  it 'has correct audio duration', (done) ->
    setTimeout ->
      expect(no1.audio.duration // 1).toBe 4
      done()
    , LOADING_TIMEOUT
  , TEST_TIMEOUT

  it 'seekPercent() works', (done) ->
    setTimeout ->
      no1.seekPercent 0
      expect(no1.audio.currentTime // 1).toBe 0
      no1.seekPercent 50
      expect(no1.audio.currentTime // 1).toBe 2
      no1.seekPercent 100
      expect(no1.audio.currentTime // 1).toBe 4
      no1.seekPercent 150
      expect(no1.audio.currentTime // 1).toBe 4
      done()
    , LOADING_TIMEOUT
  , TEST_TIMEOUT

  it 'seekToTime() works', (done) ->
    setTimeout ->
      no1.seekToTime 0
      expect(no1.audio.currentTime // 1).toBe 0
      no1.seekToTime 3
      expect(no1.audio.currentTime // 1).toBe 3
      no1.seekToTime '0'
      expect(no1.audio.currentTime // 1).toBe 0
      no1.seekToTime '00:03'
      expect(no1.audio.currentTime // 1).toBe 3
      no1.seekToTime '1:10'
      expect(no1.audio.currentTime // 1).toBe 4
      done()
    , LOADING_TIMEOUT
  , TEST_TIMEOUT
