describe 'Two players', ->
  no1 = no2 = null

  beforeEach ->
    # Fixtures
    jasmine.getFixtures().fixturesPath = '.'
    loadFixtures 'spec/javascripts/fixtures/html/player-1.html',
      'spec/javascripts/fixtures/html/player-2.html'

    # Setup
    $('.no-1').foundationPlayer()
    no1 = $('.no-1').data 'FoundationPlayer'
    $('.no-2').foundationPlayer()
    no2 = $('.no-2').data 'FoundationPlayer'

  afterEach ->
    no1 = no2 = null
    $.removeData(document.body, 'FoundationPlayers')

  it 'play() one call pause() another', ->
    no1.play()
    no2.play()
    expect(no1.audio.paused).toEqual true
    expect(no2.audio.paused).toEqual false

  it 'getPlayerInstances() updates after each new instance', ->
    # Full preclean for this step only
    no1 = no2 = null
    $.removeData(document.body, 'FoundationPlayers')
    # Load markup
    loadFixtures 'spec/javascripts/fixtures/html/player-1.html',
      'spec/javascripts/fixtures/html/player-2.html'

    # Setup first
    $('.no-1').foundationPlayer()
    no1 = $('.no-1').data 'FoundationPlayer'
    expect(no1.getPlayerInstances().length).toEqual 1
    # Setup second
    $('.no-2').foundationPlayer()
    no2 = $('.no-2').data 'FoundationPlayer'
    expect(no1.getPlayerInstances().length).not.toEqual 1
    # Both have updated attribute
    expect(no1.getPlayerInstances().length).toEqual 2
    expect(no2.getPlayerInstances().length).toEqual 2
