# Test suite related to audio loading
describe 'Audio element tests suite', ->
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

  it 'audio has default preload state', ->
    expect(no1.audio.preload).toBe 'auto'

  # TODO: Test handlers calls
  it 'audio element has all handlers', ->
    $audio = $(no1.audio)
    expect($audio).toHandle('loadstart')
    expect($audio).toHandle('timeupdate')
    expect($audio).toHandle('durationchange')
    expect($audio).toHandle('progress')
    expect($audio).toHandle('canplay')
