describe 'Audio async tests', ->
  no1 = null

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
    no1.audio.load() # Start playing
    done()

  afterEach (done) ->
    no1 = null
    $.removeData document.body, 'FoundationPlayers'
    done()

  it 'has correct audio source', (done) ->
    no1.onCanPlay ->
      expect(no1.audio.currentSrc).toMatch /lib\/audio\/acoustic-b\.m4a/
      expect(no1.audio.currentSrc).not.toBe ''
      done()

  it 'has correct audio duration', (done) ->
    no1.onCanPlay ->
      expect(no1.audio.duration // 1).toBe 4
      done()

  it 'seekPercent() works', (done) ->
    no1.onCanPlay ->
      no1.seekPercent 0
      expect(no1.audio.currentTime // 1).toBe 0
      no1.seekPercent 50
      expect(no1.audio.currentTime // 1).toBe 2
      no1.seekPercent 100
      expect(no1.audio.currentTime // 1).toBe 4
      no1.seekPercent 150
      expect(no1.audio.currentTime // 1).toBe 4
      done()

  it 'seekToTime() works', (done) ->
    no1.onCanPlay ->
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

  it 'seekToTime() calls and return', (done) ->
    spyOn no1, 'updatePlayedProgress'
    spyOn no1, 'updateTimeStatuses'
    no1.onCanPlay ->
      # Return value doesn't depend on canPlayCurrent
      expect(no1.seekToTime('00:01').seekToTime '00:02').toBe no1
      expect(no1.updatePlayedProgress).toHaveBeenCalledWith()
      expect(no1.updateTimeStatuses).toHaveBeenCalledWith()
      done()

  it 'seekPercent() calls', (done) ->
    spyOn(no1, 'updatePlayedProgress').and.callThrough()
    spyOn(no1, 'updateTimeStatuses').and.callThrough()
    no1.onCanPlay ->
      no1.seekPercent 0.1
      expect(no1.updatePlayedProgress.calls.count()).toEqual 1
      expect(no1.updateTimeStatuses.calls.count()).toEqual 2
      no1.seekPercent 20
      expect(no1.updatePlayedProgress.calls.count()).toEqual 2
      expect(no1.updateTimeStatuses.calls.count()).toEqual 3
      done()

  it 'seekPercent() return', (done) ->
    no1.onCanPlay ->
      expect(no1.seekPercent(0.1).seekPercent(20)).toBe no1
      done()
