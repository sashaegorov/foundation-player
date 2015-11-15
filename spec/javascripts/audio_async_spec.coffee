#       _/      _/    _/_/      _/_/_/  _/_/_/    _/_/_/
#      _/_/  _/_/  _/    _/  _/          _/    _/
#     _/  _/  _/  _/_/_/_/  _/  _/_/    _/    _/
#    _/      _/  _/    _/  _/    _/    _/    _/
#   _/      _/  _/    _/    _/_/_/  _/_/_/    _/_/_/
#
# TODO: Decrease timeouts if possible
# TODO: Replace audio with shorter one
# TODO: Add style fixtures

describe 'Audio async tests', ->
  no1 = null
  LOADING_TIMEOUT = 1000
  TEST_TIMEOUT = 1500

  beforeAll ->
    jasmine.getFixtures().fixturesPath = '.'
    jasmine.getFixtures().preload 'spec/javascripts/fixtures/html/player-1.html'

  afterAll ->
    jasmine.getFixtures().clearCache()

  beforeEach (done) ->
    jasmine.getFixtures().load 'spec/javascripts/fixtures/html/player-1.html'
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
      expect(no1.audio.currentSrc).toMatch /lib\/audio\/ukulele\.m4a/
      expect(no1.audio.currentSrc).not.toBe ''
      done()
    , LOADING_TIMEOUT
  , TEST_TIMEOUT

  it 'has correct audio duration', (done) ->
    setTimeout ->
      expect(no1.audio.duration).toBe 60.070023
      done()
    , LOADING_TIMEOUT
  , TEST_TIMEOUT
