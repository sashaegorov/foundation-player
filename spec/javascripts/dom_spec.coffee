describe 'One player', ->
  no1 = null

  beforeEach ->
    # Fixtures
    jasmine.getFixtures().fixturesPath = '.'
    loadFixtures 'spec/javascripts/fixtures/html/player-1.html'
    # Setup
    $('.no-1').foundationPlayer()
    no1 = $('.no-1').data 'FoundationPlayer'

  afterEach ->
    no1 = null
    $.removeData(document.body, 'FoundationPlayers')

  it 'Initialized player?', ->
    expect(no1).toBeDefined()

  it 'player has default size', ->
    expect(no1.currentUISize).toEqual no1.options.playerUISize
    expect(no1.options.playerUISize).toEqual 'normal'
    expect(no1.options.playerUISize).not.toEqual 'small'

  it 'play() works', ->
    no1.play()
    expect(no1.audio.paused).toEqual false

  it 'paused() works', ->
    no1.pause()
    expect(no1.audio.paused).toEqual true

  it 'play()+pause() works', ->
    no1.play()
    no1.pause()
    expect(no1.audio.paused).toEqual true

  it 'playPause() works', ->
    no1.pause()
    no1.playPause()
    expect(no1.audio.paused).toEqual false
    no1.playPause()
    expect(no1.audio.paused).toEqual true

  it 'setVolume() works', ->
    no1.setVolume 0.5
    expect(no1.audio.volume).toEqual 0.5

  it 'setPlayerSize() works', ->
    no1.setPlayerSize 'small'
    expect(no1.currentUISize).toEqual 'small'

  it 'togglePlayerSize() works', ->
    no1.setPlayerSize 'small'
    no1.togglePlayerSize()
    expect(no1.currentUISize).toEqual 'normal'
    no1.togglePlayerSize()
    expect(no1.currentUISize).toEqual 'small'

  it 'toggleMute() works', ->
    no1.audio.muted = false
    no1.toggleMute()
    expect(no1.audio.muted).toEqual true
    no1.toggleMute()
    expect(no1.audio.muted).toEqual false
