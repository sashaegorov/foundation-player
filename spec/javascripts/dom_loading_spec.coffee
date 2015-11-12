# Test suite related to audio loading
describe 'Audio loading tests suite', ->
  no1 = null
  beforeEach ->
    loadFixtures 'player.html'
    $('.no-1').foundationPlayer()
    no1 = $('.no-1').data 'FoundationPlayer'
  afterEach ->
    no1 = null

  it 'it can\'t play by default', ->
    expect(no1.canPlayCurrent).toBe false

  it 'it doesn\'t play by default', ->
    expect(no1.options.playOnLoad).toBe false

  xit 'it can play after loading', ->
    # TODO: Check it was preloaded in Safari
    no1.audio.load()
    expect(true).toBe true

  it 'audio element has all handlers', ->
    $audio = $(no1.audio)
    expect($audio).toHandle('loadstart')
    expect($audio).toHandle('timeupdate')
    expect($audio).toHandle('durationchange')
    expect($audio).toHandle('progress')
    expect($audio).toHandle('canplay')
